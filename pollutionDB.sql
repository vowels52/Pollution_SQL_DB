-- phpMyAdmin SQL Dump
-- version 4.2.4
-- http://www.phpmyadmin.net

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `pollutionDB`
--
CREATE DATABASE IF NOT EXISTS `pollutionDB` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `pollutionDB`;

-- --------------------------------------------------------
-- Create tables without foreign key constraints
-- --------------------------------------------------------

-- User table
DROP TABLE IF EXISTS `User`;
CREATE TABLE IF NOT EXISTS `User` (
   `user_id` INT PRIMARY KEY AUTO_INCREMENT,
   `username` VARCHAR(50) UNIQUE,
   `roles` ENUM('Admin', 'Checker', 'Contributor', 'Viewer') NOT NULL,
   `password` VARCHAR(255) NOT NULL,
   `email` VARCHAR(100) DEFAULT NULL,
   `phone` VARCHAR(20) DEFAULT NULL,
   `name_first` VARCHAR(50) NOT NULL,
   `name_last` VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Organization table
DROP TABLE IF EXISTS `Organization`;
CREATE TABLE IF NOT EXISTS `Organization` (
   `organization_id` INT PRIMARY KEY AUTO_INCREMENT,
   `name` VARCHAR(100) NOT NULL,
   `phone` VARCHAR(20) NOT NULL,
   `website_url` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Pollution Type table
DROP TABLE IF EXISTS `Pollution_Type`;
CREATE TABLE IF NOT EXISTS `Pollution_Type` (
   `type_id` INT PRIMARY KEY AUTO_INCREMENT,
   `type_name` VARCHAR(50) UNIQUE NOT NULL,
   `description` TEXT,
   `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Transaction table
DROP TABLE IF EXISTS `Transaction`;
CREATE TABLE IF NOT EXISTS `Transaction` (
   `transaction_id` INT PRIMARY KEY AUTO_INCREMENT,
   `user_id` INT NOT NULL,
   `address_id` INT NOT NULL,
   `date` DATE NOT NULL,
   `time_added` TIME NOT NULL,
   `time_measured` TIME NOT NULL,
   `radius_affected` FLOAT NOT NULL,
   `coordinates` VARCHAR(100) NOT NULL,
   `type_id` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Address table
DROP TABLE IF EXISTS `Address`;
CREATE TABLE IF NOT EXISTS `Address` (
   `address_id` INT PRIMARY KEY AUTO_INCREMENT,
   `organization_id` INT DEFAULT NULL,
   `transaction_id` INT NOT NULL,
   `first_entry` VARCHAR(20) NOT NULL,
   `street_name` VARCHAR(100) NOT NULL,
   `city` VARCHAR(100) NOT NULL,
   `zip_code` VARCHAR(10) NOT NULL,
   `state` VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Funding table
DROP TABLE IF EXISTS `Funding`;
CREATE TABLE IF NOT EXISTS `Funding` (
   `funding_id` INT PRIMARY KEY AUTO_INCREMENT,
   `user_id` INT NOT NULL,
   `receiver_name` VARCHAR(100) NOT NULL,
   `amount` DECIMAL(10,2) NOT NULL,
   `date` DATE NOT NULL,
   `pollution_targeted` ENUM('Air', 'Water', 'Soil') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Water Pollution table
DROP TABLE IF EXISTS `Water_Pollution`;
CREATE TABLE IF NOT EXISTS `Water_Pollution` (
   `water_id` INT PRIMARY KEY AUTO_INCREMENT,
   `transaction_id` INT NOT NULL,
   `source` VARCHAR(100) DEFAULT NULL,
   `turbidity` FLOAT DEFAULT NULL,
   `pH_level` FLOAT DEFAULT NULL,
   `dissolved_oxygen` FLOAT DEFAULT NULL,
   `temperature` FLOAT DEFAULT NULL,
   `point_source_flag` BOOLEAN DEFAULT NULL,
   `generalPollutionTag` ENUM('Clean', 'Low', 'Moderate', 'Hazardous') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Air Pollution table
DROP TABLE IF EXISTS `Air_Pollution`;
CREATE TABLE IF NOT EXISTS `Air_Pollution` (
   `air_id` INT PRIMARY KEY AUTO_INCREMENT,
   `transaction_id` INT NOT NULL,
   `particulate_matter` FLOAT DEFAULT NULL,
   `monitoring_type` VARCHAR(100) DEFAULT NULL,
   `CO_level` FLOAT DEFAULT NULL,
   `NO2_level` FLOAT DEFAULT NULL,
   `lead_level` FLOAT DEFAULT NULL,
   `SO2_level` FLOAT DEFAULT NULL,
   `ozone_level` FLOAT DEFAULT NULL,
   `generalPollutionTag` ENUM('Clean', 'Low', 'Moderate', 'Hazardous') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Soil Pollution table
DROP TABLE IF EXISTS `Soil_Pollution`;
CREATE TABLE IF NOT EXISTS `Soil_Pollution` (
   `soil_id` INT PRIMARY KEY AUTO_INCREMENT,
   `transaction_id` INT NOT NULL,
   `geo_index` FLOAT DEFAULT NULL,
   `pH_level` FLOAT DEFAULT NULL,
   `TOC` FLOAT DEFAULT NULL,
   `generalPollutionTag` ENUM('Clean', 'Low', 'Moderate', 'Hazardous') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Sponsors table
DROP TABLE IF EXISTS `Sponsors`;
CREATE TABLE IF NOT EXISTS `Sponsors` (
   `transaction_id` INT NOT NULL,
   `funding_id` INT NOT NULL,
   PRIMARY KEY (`transaction_id`, `funding_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Associated_With table
DROP TABLE IF EXISTS `Associated_With`;
CREATE TABLE IF NOT EXISTS `Associated_With` (
   `user_id` INT NOT NULL,
   `organization_id` INT NOT NULL,
   PRIMARY KEY (`user_id`, `organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Water Tag Rules table
DROP TABLE IF EXISTS `Water_TagRules`;
CREATE TABLE IF NOT EXISTS `Water_TagRules` (
    `tag_id` INT PRIMARY KEY AUTO_INCREMENT,
    `tag_name` VARCHAR(100) NOT NULL,
    `turbidity_min` FLOAT DEFAULT NULL,
    `turbidity_max` FLOAT DEFAULT NULL,
    `ph_min` FLOAT DEFAULT NULL,
    `ph_max` FLOAT DEFAULT NULL,
    `dissolved_oxygen_min` FLOAT DEFAULT NULL,
    `dissolved_oxygen_max` FLOAT DEFAULT NULL,
    `temperature_min` FLOAT DEFAULT NULL,
    `temperature_max` FLOAT DEFAULT NULL,
    `description` TEXT
);

-- Air Tag Rules table
DROP TABLE IF EXISTS `Air_TagRules`;
CREATE TABLE IF NOT EXISTS `Air_TagRules` (
    `tag_id` INT PRIMARY KEY AUTO_INCREMENT,
    `tag_name` VARCHAR(100) NOT NULL,
    `particulate_matter_min` FLOAT DEFAULT NULL,
    `particulate_matter_max` FLOAT DEFAULT NULL,
    `CO_level_min` FLOAT DEFAULT NULL,
    `CO_level_max` FLOAT DEFAULT NULL,
    `NO2_level_min` FLOAT DEFAULT NULL,
    `NO2_level_max` FLOAT DEFAULT NULL,
    `lead_level_min` FLOAT DEFAULT NULL,
    `lead_level_max` FLOAT DEFAULT NULL,
    `SO2_level_min` FLOAT DEFAULT NULL,
    `SO2_level_max` FLOAT DEFAULT NULL,
    `ozone_level_min` FLOAT DEFAULT NULL,
    `ozone_level_max` FLOAT DEFAULT NULL,
    `description` TEXT
);

-- Soil Tag Rules table
DROP TABLE IF EXISTS `Soil_TagRules`;
CREATE TABLE IF NOT EXISTS `Soil_TagRules` (
    `tag_id` INT PRIMARY KEY AUTO_INCREMENT,
    `tag_name` VARCHAR(100) NOT NULL,
    `geo_index_min` FLOAT DEFAULT NULL,
    `geo_index_max` FLOAT DEFAULT NULL,
    `ph_min` FLOAT DEFAULT NULL,
    `ph_max` FLOAT DEFAULT NULL,
    `TOC_min` FLOAT DEFAULT NULL,
    `TOC_max` FLOAT DEFAULT NULL,
    `description` TEXT
);

-- --------------------------------------------------------
-- Insert Sample Data
-- --------------------------------------------------------

-- Insert Users
INSERT INTO `User` (`username`, `roles`, `password`, `email`, `phone`, `name_first`, `name_last`) VALUES
('admin1', 'Admin', '$2y$10$encrypted1', 'admin@polltrack.org', '206-555-0101', 'John', 'Smith'),
('checker1', 'Checker', '$2y$10$encrypted2', 'checker@polltrack.org', '206-555-0102', 'Jane', 'Doe'),
('contrib1', 'Contributor', '$2y$10$encrypted3', 'contrib@polltrack.org', '206-555-0103', 'Bob', 'Johnson'),
('viewer1', 'Viewer', '$2y$10$encrypted4', 'viewer@polltrack.org', '206-555-0104', 'Alice', 'Brown');

-- Insert Organizations
INSERT INTO `Organization` (`name`, `phone`, `website_url`) VALUES
('EPA Northwest', '206-555-1000', 'https://epa-nw.gov'),
('National Environmental Defense Coalition', '800-555-2000', 'https://nedc.org'),
('EcoWatch America', '877-555-3000', 'https://ecowatchamerica.org'),
('Green Earth Alliance', '888-555-4000', 'https://greenearth.org'),
('Pacific Environmental Labs', '425-555-5000', 'https://pacenvlabs.com'),
('Clean Water Action Network', '866-555-6000', 'https://cleanwaternetwork.org'),
('Air Quality Monitoring Systems', '855-555-7000', 'https://airqualityms.org'),
('Soil Health Initiative', '844-555-8000', 'https://soilhealth.org'),
('Urban Environmental Watch', '833-555-9000', 'https://urbanenvwatch.org'),
('Coastal Protection Alliance', '822-555-1100', 'https://coastalprotect.org'),
('Mountain States Environmental Group', '811-555-1200', 'https://mtsenv.org'),
('Great Lakes Conservation', '800-555-1300', 'https://greatlakesconserve.org'),
('Desert Environmental Research', '877-555-1400', 'https://desertenv.org'),
('Forest Ecosystem Protection', '866-555-1500', 'https://forestprotect.org'),
('River Basin Alliance', '855-555-1600', 'https://riverbasin.org'),
('Climate Action Network', '844-555-1700', 'https://climateactionnet.org');

-- Insert Pollution Types
INSERT INTO `Pollution_Type` (`type_name`, `description`) VALUES
('Air', 'Atmospheric pollution including particulate matter, gases, and other airborne contaminants'),
('Water', 'Contamination of water bodies including chemical, physical, and biological changes'),
('Soil', 'Land contamination affecting soil quality and composition');

-- Insert Transactions
INSERT INTO `Transaction` (`user_id`, `address_id`, `date`, `time_added`, `time_measured`, `radius_affected`, `coordinates`, `type_id`) VALUES
(1, 1, '2025-03-01', '09:00:00', '08:30:00', 2.5, '47.6062° N, 122.3321° W', 2),
(2, 2, '2025-03-02', '10:15:00', '09:45:00', 1.8, '47.6097° N, 122.3331° W', 1),
(3, 3, '2025-05-03', '14:30:00', '14:00:00', 3.0, '47.6205° N, 122.3493° W', 3),
(4, 4, '2025-05-04', '16:45:00', '16:00:00', 2.2, '47.6183° N, 122.3283° W', 2),
(1, 5, '2025-05-05', '11:30:00', '11:00:00', 2.8, '47.6150° N, 122.3350° W', 1),
(2, 6, '2025-04-06', '13:45:00', '13:15:00', 1.5, '47.6180° N, 122.3360° W', 3),
(3, 7, '2025-03-07', '15:20:00', '14:50:00', 2.1, '47.6220° N, 122.3380° W', 2),
(4, 8, '2025-03-08', '10:00:00', '09:30:00', 3.2, '47.6240° N, 122.3400° W', 1),
(1, 9, '2025-03-09', '14:15:00', '13:45:00', 2.4, '47.6260° N, 122.3420° W', 3),
(2, 10, '2025-03-10', '16:30:00', '16:00:00', 1.9, '47.6280° N, 122.3440° W', 2),
(3, 11, '2025-03-11', '09:45:00', '09:15:00', 2.7, '47.6300° N, 122.3460° W', 1),
(4, 12, '2025-03-12', '11:20:00', '10:50:00', 3.5, '47.6320° N, 122.3480° W', 3),
(1, 13, '2025-05-13', '13:40:00', '13:10:00', 2.3, '47.6340° N, 122.3500° W', 2),
(2, 14, '2025-03-14', '15:55:00', '15:25:00', 1.7, '47.6360° N, 122.3520° W', 1),
(3, 15, '2025-03-15', '10:30:00', '10:00:00', 2.9, '47.6380° N, 122.3540° W', 3),
(4, 16, '2025-05-16', '12:45:00', '12:15:00', 3.3, '47.6400° N, 122.3560° W', 2);

-- Insert Addresses
INSERT INTO `Address` (`organization_id`, `transaction_id`, `first_entry`, `street_name`, `city`, `zip_code`, `state`) VALUES
-- EPA Northwest (WA, OR, ID offices)
(1, 1, '123', 'Pine Street', 'Seattle', '98101', 'WA'),
(NULL, 2, '456', 'Morrison Street', 'Portland', '97204', 'OR'),
(1, 3, '789', 'Main Street', 'Boise', '83702', 'ID'),

-- National Environmental Defense Coalition (multiple regions)
(2, 4, '100', 'Broadway', 'New York', '10007', 'NY'),
(NULL, 5, '200', 'Market Street', 'San Francisco', '94105', 'CA'),
(2, 6, '300', 'Congress Avenue', 'Austin', '78701', 'TX'),

-- EcoWatch America (nationwide presence)
(3, 7, '400', 'Michigan Avenue', 'Chicago', '60601', 'IL'),
(NULL, 8, '500', 'Peachtree Street', 'Atlanta', '30308', 'GA'),
(3, 9, '600', 'Las Vegas Boulevard', 'Las Vegas', '89101', 'NV'),

-- Green Earth Alliance (multiple locations)
(4, 10, '700', 'Pike Street', 'Seattle', '98101', 'WA'),
(NULL, 11, '800', 'Newbury Street', 'Boston', '02116', 'MA'),
(4, 12, '900', 'Lincoln Road', 'Miami Beach', '33139', 'FL'),

-- Pacific Environmental Labs (West Coast focus)
(5, 13, '321', 'Lake Washington Blvd', 'Kirkland', '98033', 'WA'),
(NULL, 14, '432', 'Ocean Avenue', 'San Diego', '92109', 'CA'),
(5, 15, '543', 'Coastal Highway', 'Newport', '97365', 'OR'),

-- Clean Water Action Network (nationwide)
(6, 16, '111', 'River Road', 'Minneapolis', '55401', 'MN'),
(NULL, 1, '222', 'Lake Shore Drive', 'Chicago', '60601', 'IL'),
(6, 2, '333', 'Gulf Street', 'Houston', '77002', 'TX'),

-- Air Quality Monitoring Systems (major urban areas)
(7, 3, '444', 'Market Street', 'Philadelphia', '19103', 'PA'),
(NULL, 4, '555', 'Wilshire Boulevard', 'Los Angeles', '90017', 'CA'),
(7, 5, '666', 'Fifth Avenue', 'New York', '10022', 'NY'),

-- Soil Health Initiative (agricultural regions)
(8, 6, '777', 'Farm Road', 'Des Moines', '50309', 'IA'),
(NULL, 7, '888', 'Prairie Avenue', 'Kansas City', '64105', 'MO'),
(8, 8, '999', 'Valley Road', 'Sacramento', '95814', 'CA'),

-- Urban Environmental Watch (major cities)
(9, 9, '123', 'City Center', 'Denver', '80202', 'CO'),
(NULL, 10, '234', 'Downtown Street', 'Phoenix', '85004', 'AZ'),
(9, 11, '345', 'Metropolitan Avenue', 'Charlotte', '28202', 'NC'),

-- Coastal Protection Alliance (coastal states)
(10, 12, '456', 'Beach Drive', 'Miami', '33139', 'FL'),
(NULL, 13, '567', 'Harbor Street', 'Seattle', '98101', 'WA'),
(10, 14, '678', 'Oceanview Boulevard', 'San Diego', '92109', 'CA'),

-- Mountain States Environmental Group
(11, 15, '789', 'Mountain View Road', 'Denver', '80202', 'CO'),
(NULL, 16, '890', 'Canyon Street', 'Salt Lake City', '84101', 'UT'),
(11, 1, '901', 'Peak Avenue', 'Bozeman', '59715', 'MT'),

-- Great Lakes Conservation
(12, 2, '112', 'Lakeshore Drive', 'Chicago', '60601', 'IL'),
(NULL, 3, '223', 'Erie Street', 'Cleveland', '44113', 'OH'),
(12, 4, '334', 'Superior Avenue', 'Detroit', '48226', 'MI'),

-- Desert Environmental Research
(13, 5, '445', 'Desert Road', 'Phoenix', '85004', 'AZ'),
(NULL, 6, '556', 'Canyon Drive', 'Las Vegas', '89101', 'NV'),
(13, 7, '667', 'Mesa Street', 'Albuquerque', '87102', 'NM'),

-- Forest Ecosystem Protection
(14, 8, '778', 'Forest Lane', 'Portland', '97204', 'OR'),
(NULL, 9, '889', 'Redwood Highway', 'Sacramento', '95814', 'CA'),
(14, 10, '990', 'Pine Street', 'Seattle', '98101', 'WA'),

-- River Basin Alliance
(15, 11, '111', 'River Walk', 'New Orleans', '70130', 'LA'),
(NULL, 12, '222', 'Mississippi Boulevard', 'Memphis', '38103', 'TN'),
(15, 13, '333', 'Missouri Avenue', 'St. Louis', '63102', 'MO'),

-- Climate Action Network (nationwide)
(16, 14, '444', 'Innovation Drive', 'Boston', '02116', 'MA'),
(NULL, 15, '555', 'Research Park', 'Berkeley', '94704', 'CA'),
(16, 16, '666', 'Science Center', 'Austin', '78701', 'TX');

-- Insert Funding
INSERT INTO `Funding` (`user_id`, `receiver_name`, `amount`, `date`, `pollution_targeted`) VALUES
(1, 'Clean Water Action Network', 75000.00, '2025-05-07', 'Water'),
(2, 'Coastal Protection Alliance', 100000.00, '2025-05-05', 'Water'),
(3, 'River Basin Alliance', 85000.00, '2025-05-02', 'Water'),
(4, 'Air Quality Monitoring Systems', 120000.00, '2025-05-09', 'Air');

-- Insert Water Pollution Data
INSERT INTO `Water_Pollution` (`transaction_id`, `source`, `turbidity`, `pH_level`, `dissolved_oxygen`, `temperature`, `point_source_flag`, `generalPollutionTag`) VALUES
(1, 'Industrial Runoff', 5.2, 6.8, 7.5, 18.5, true, 'Moderate'),
(2, 'Storm Drain', 3.8, 7.2, 8.1, 17.9, true, 'Low'),
(3, 'Agricultural Runoff', 7.5, 6.5, 6.8, 19.2, false, 'Hazardous'),
(4, 'Natural Source', 2.1, 7.0, 8.5, 16.8, false, 'Clean'),
(5, 'Urban Runoff', 4.8, 6.9, 7.8, 18.2, true, 'Moderate'),
(6, 'Industrial Discharge', 6.2, 6.4, 6.5, 20.1, true, 'Hazardous'),
(7, 'Storm Water', 3.2, 7.1, 8.3, 17.5, false, 'Low'),
(8, 'River Sediment', 4.5, 6.7, 7.2, 18.8, false, 'Moderate'),
(9, 'Coastal Runoff', 3.9, 7.3, 8.0, 19.5, true, 'Low'),
(10, 'Factory Discharge', 5.8, 6.3, 6.7, 20.5, true, 'Hazardous'),
(11, 'Rain Water', 2.5, 7.0, 8.4, 17.2, false, 'Clean'),
(12, 'Lake Sediment', 4.2, 6.8, 7.6, 18.6, false, 'Moderate'),
(13, 'Marine Discharge', 4.0, 7.2, 7.9, 19.0, true, 'Low'),
(14, 'Industrial Waste', 6.5, 6.2, 6.4, 20.8, true, 'Hazardous'),
(15, 'Natural Spring', 2.3, 7.1, 8.6, 16.5, false, 'Clean'),
(16, 'Urban Drainage', 4.7, 6.6, 7.4, 18.9, true, 'Moderate');

-- Insert Air Pollution Data
INSERT INTO `Air_Pollution` (`transaction_id`, `particulate_matter`, `monitoring_type`, `CO_level`, `NO2_level`, `lead_level`, `SO2_level`, `ozone_level`, `generalPollutionTag`) VALUES
(1, 35.5, 'Continuous', 2.1, 0.053, 0.15, 0.075, 0.070, 'Moderate'),
(2, 12.1, 'Mobile', 1.5, 0.031, 0.08, 0.042, 0.055, 'Low'),
(3, 55.3, 'Fixed Station', 4.2, 0.075, 0.25, 0.155, 0.095, 'Hazardous'),
(4, 8.2, 'Continuous', 0.8, 0.021, 0.05, 0.021, 0.045, 'Clean'),
(5, 28.4, 'Mobile', 1.9, 0.048, 0.12, 0.065, 0.065, 'Moderate'),
(6, 45.6, 'Fixed Station', 3.5, 0.068, 0.20, 0.125, 0.085, 'Hazardous'),
(7, 15.3, 'Continuous', 1.2, 0.035, 0.09, 0.035, 0.050, 'Low'),
(8, 32.1, 'Mobile', 2.3, 0.055, 0.16, 0.085, 0.075, 'Moderate'),
(9, 10.5, 'Fixed Station', 1.1, 0.028, 0.07, 0.032, 0.048, 'Low'),
(10, 48.7, 'Continuous', 3.8, 0.071, 0.22, 0.135, 0.088, 'Hazardous'),
(11, 7.8, 'Mobile', 0.9, 0.025, 0.06, 0.025, 0.042, 'Clean'),
(12, 30.2, 'Fixed Station', 2.0, 0.050, 0.14, 0.070, 0.068, 'Moderate'),
(13, 13.4, 'Continuous', 1.4, 0.033, 0.10, 0.038, 0.052, 'Low'),
(14, 52.1, 'Mobile', 4.0, 0.073, 0.23, 0.145, 0.092, 'Hazardous'),
(15, 9.1, 'Fixed Station', 1.0, 0.027, 0.07, 0.028, 0.046, 'Clean'),
(16, 33.8, 'Continuous', 2.2, 0.058, 0.17, 0.080, 0.072, 'Moderate');

-- Insert Soil Pollution Data
INSERT INTO `Soil_Pollution` (`transaction_id`, `geo_index`, `pH_level`, `TOC`, `generalPollutionTag`) VALUES
(1, 3.5, 6.8, 2.5, 'Moderate'),
(2, 2.8, 7.1, 1.8, 'Low'),
(3, 4.7, 5.9, 3.8, 'Hazardous'),
(4, 1.9, 7.3, 1.2, 'Clean'),
(5, 3.2, 6.9, 2.3, 'Moderate'),
(6, 4.3, 6.1, 3.5, 'Hazardous'),
(7, 2.5, 7.0, 1.6, 'Low'),
(8, 3.7, 6.7, 2.7, 'Moderate'),
(9, 2.6, 7.2, 1.7, 'Low'),
(10, 4.5, 6.0, 3.6, 'Hazardous'),
(11, 2.0, 7.4, 1.3, 'Clean'),
(12, 3.4, 6.8, 2.4, 'Moderate'),
(13, 2.7, 7.1, 1.9, 'Low'),
(14, 4.8, 5.8, 3.9, 'Hazardous'),
(15, 1.8, 7.3, 1.1, 'Clean'),
(16, 3.6, 6.7, 2.6, 'Moderate');

-- Insert Sponsors relationships
INSERT INTO `Sponsors` (`transaction_id`, `funding_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Insert Associated_With relationships
INSERT INTO `Associated_With` (`user_id`, `organization_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(1, 5),
(2, 6),
(3, 7),
(4, 8),
(1, 9),
(2, 10),
(3, 11),
(4, 12),
(1, 13),
(2, 14),
(3, 15),
(4, 16);

-- Insert Water Tag Rules
INSERT INTO `Water_TagRules` (`tag_name`, `turbidity_min`, `turbidity_max`, `ph_min`, `ph_max`, `dissolved_oxygen_min`, `dissolved_oxygen_max`, `temperature_min`, `temperature_max`, `description`) VALUES
-- Tag 1: Safe for Drinking
('Safe for Drinking', NULL, 1.0, 6.5, 8.5, 6.0, NULL, NULL, 25.0, 'Water meets safety standards for drinking'),
-- Tag 2: Not Drinkable - High Turbidity
('Not Drinkable - High Turbidity', 5.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Turbidity is too high for drinking use'),
-- Tag 3: Acidic Water Warning
('Acidic Water Warning', NULL, NULL, NULL, 5.5, NULL, NULL, NULL, NULL, 'pH level indicates water is too acidic'),
-- Tag 4: Oxygen Depleted
('Oxygen Depleted', NULL, NULL, NULL, NULL, NULL, 3.0, NULL, NULL, 'Low dissolved oxygen, harmful to aquatic life'),
-- Tag 5: Warm Water Alert
('Warm Water Alert', NULL, NULL, NULL, NULL, NULL, NULL, 30.0, NULL, 'Temperature is above safe ecological range');

-- Insert Air Tag Rules
INSERT INTO `Air_TagRules` (`tag_name`, `particulate_matter_min`, `particulate_matter_max`, `CO_level_min`, `CO_level_max`, `NO2_level_min`, `NO2_level_max`, `lead_level_min`, `lead_level_max`, `SO2_level_min`, `SO2_level_max`, `ozone_level_min`, `ozone_level_max`, `description`) VALUES
-- Tag 1: Good Air Quality
('Good Air Quality', NULL, 12.0, NULL, 1.0, NULL, 0.053, NULL, 0.05, NULL, 0.02, NULL, 0.060, 'Air quality is good and poses little to no risk'),
-- Tag 2: High Particulate Matter
('High Particulate Matter', 35.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Particulate matter exceeds safety threshold'),
-- Tag 3: Carbon Monoxide Warning
('Carbon Monoxide Warning', NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CO levels are above safety threshold'),
-- Tag 4: Ozone Alert
('Ozone Alert', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.085, NULL, 'Ozone levels are at concerning levels'),
-- Tag 5: Multiple Pollutant Warning
('Multiple Pollutant Warning', 25.0, NULL, 2.0, NULL, 0.070, NULL, 0.10, NULL, 0.10, NULL, 0.070, NULL, 'Multiple air pollutants at elevated levels');

-- Insert Soil Tag Rules
INSERT INTO `Soil_TagRules` (`tag_name`, `geo_index_min`, `geo_index_max`, `ph_min`, `ph_max`, `TOC_min`, `TOC_max`, `description`) VALUES
-- Tag 1: Optimal Soil Quality
('Optimal Soil Quality', NULL, 2.0, 6.0, 7.5, NULL, 3.0, 'Soil conditions are ideal for most vegetation'),
-- Tag 2: High Contamination Risk
('High Contamination Risk', 4.0, NULL, NULL, NULL, NULL, NULL, 'Geological index indicates high contamination risk'),
-- Tag 3: pH Imbalance
('pH Imbalance', NULL, NULL, NULL, 5.5, NULL, NULL, 'Soil pH is too acidic for most plants'),
-- Tag 4: Organic Content Warning
('Organic Content Warning', NULL, NULL, NULL, NULL, 3.5, NULL, 'High total organic carbon content detected'),
-- Tag 5: Critical Soil Condition
('Critical Soil Condition', 4.5, NULL, NULL, 5.0, 4.0, NULL, 'Multiple soil quality indicators at critical levels');

-- --------------------------------------------------------
-- Add Foreign Key Constraints
-- --------------------------------------------------------

-- Indexes for table `funding`
ALTER TABLE `Funding` ADD CONSTRAINT `fk_funding_user` FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`) ON DELETE CASCADE;

-- Indexes for table `transactions`
ALTER TABLE `Transaction` ADD CONSTRAINT `fk_transaction_user` FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`) ON DELETE CASCADE;
ALTER TABLE `Transaction` ADD CONSTRAINT `fk_transaction_address` FOREIGN KEY (`address_id`) REFERENCES `Address`(`address_id`) ON DELETE CASCADE;

-- Indexes for table `address`
ALTER TABLE `Address` ADD CONSTRAINT `fk_address_org` FOREIGN KEY (`organization_id`) REFERENCES `Organization`(`organization_id`) ON DELETE SET NULL;
ALTER TABLE `Address` ADD CONSTRAINT `fk_address_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `Transaction`(`transaction_id`) ON DELETE CASCADE;

-- Indexes for table `air_pollution`
ALTER TABLE `Air_Pollution` ADD CONSTRAINT `fk_air_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `Transaction`(`transaction_id`) ON DELETE CASCADE;

-- Indexes for table `water_pollution`
ALTER TABLE `Water_Pollution` ADD CONSTRAINT `fk_water_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `Transaction`(`transaction_id`) ON DELETE CASCADE;

-- Indexes for table `soil_pollution`
ALTER TABLE `Soil_Pollution` ADD CONSTRAINT `fk_soil_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `Transaction`(`transaction_id`) ON DELETE CASCADE;

-- Indexes for table `sponsors`
ALTER TABLE `Sponsors` ADD CONSTRAINT `fk_sponsors_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `Transaction`(`transaction_id`) ON DELETE CASCADE;
ALTER TABLE `Sponsors` ADD CONSTRAINT `fk_sponsors_funding` FOREIGN KEY (`funding_id`) REFERENCES `Funding`(`funding_id`) ON DELETE CASCADE;

-- Indexes for table `associated_with`
ALTER TABLE `Associated_With` ADD CONSTRAINT `fk_assoc_user` FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`) ON DELETE CASCADE;
ALTER TABLE `Associated_With` ADD CONSTRAINT `fk_assoc_org` FOREIGN KEY (`organization_id`) REFERENCES `Organization`(`organization_id`) ON DELETE CASCADE;

-- Add foreign key for Transaction type_id
ALTER TABLE `Transaction` ADD CONSTRAINT `fk_transaction_type` FOREIGN KEY (`type_id`) REFERENCES `Pollution_Type`(`type_id`) ON DELETE RESTRICT;

-- --------------------------------------------------------
-- Add Check Constraints (Triggers)
-- --------------------------------------------------------

DELIMITER //

-- Check for `air_pollution` insert
CREATE TRIGGER check_air_pollution_insert BEFORE INSERT ON Air_Pollution
FOR EACH ROW
BEGIN
  IF NEW.ozone_level IS NULL AND
     NEW.SO2_level IS NULL AND
     NEW.lead_level IS NULL AND
     NEW.NO2_level IS NULL AND
     NEW.CO_level IS NULL AND
     NEW.particulate_matter IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'At least one pollutant value must be provided.';
  END IF;
END;
//

-- Check for `air_pollution` update
CREATE TRIGGER check_air_pollution_update BEFORE UPDATE ON Air_Pollution
FOR EACH ROW
BEGIN
  IF NEW.ozone_level IS NULL AND
     NEW.SO2_level IS NULL AND
     NEW.lead_level IS NULL AND
     NEW.NO2_level IS NULL AND
     NEW.CO_level IS NULL AND
     NEW.particulate_matter IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'At least one pollutant value must be provided.';
  END IF;
END;
//

-- Check for `water_pollution` insert
CREATE TRIGGER check_water_pollution_insert BEFORE INSERT ON Water_Pollution
FOR EACH ROW
BEGIN
  IF NEW.turbidity IS NULL AND
     NEW.pH_level IS NULL AND
     NEW.dissolved_oxygen IS NULL AND
     NEW.temperature IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'At least one water pollution field must be non-NULL.';
  END IF;
END;
//

-- Check for `water_pollution` update
CREATE TRIGGER check_water_pollution_update BEFORE UPDATE ON Water_Pollution
FOR EACH ROW
BEGIN
  IF NEW.turbidity IS NULL AND
     NEW.pH_level IS NULL AND
     NEW.dissolved_oxygen IS NULL AND
     NEW.temperature IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'At least one water pollution field must be non-NULL.';
  END IF;
END;
//

-- Check for `soil_pollution` insert
CREATE TRIGGER check_soil_pollution_insert BEFORE INSERT ON Soil_Pollution
FOR EACH ROW
BEGIN
  IF NEW.geo_index IS NULL AND
     NEW.pH_level IS NULL AND
     NEW.TOC IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'At least one soil pollution field must be non-NULL.';
  END IF;
END;
//

-- Check for `soil_pollution` update
CREATE TRIGGER check_soil_pollution_update BEFORE UPDATE ON Soil_Pollution
FOR EACH ROW
BEGIN
  IF NEW.geo_index IS NULL AND
     NEW.pH_level IS NULL AND
     NEW.TOC IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'At least one soil pollution field must be non-NULL.';
  END IF;
END;
//

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */; 
