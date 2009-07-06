Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZGFQZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZGFQZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZGFQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:25:07 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3724 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZGFQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:25:05 -0400
Date: Mon, 6 Jul 2009 17:25:07 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: lm-sensors@lm-sensors.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Support high precision ADM1023 remote sensor
Message-ID: <Pine.LNX.4.64.0907061720470.11795@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADM1023 temperature sensor supports higher resolution for its external 
sensor (sensitivity of 1/8 deg C).  This patch makes this higher 
resolution available through the appropriate temperature sysfs nodes.

Curiously, this functionality was available in the 2.4 kernel driver (but 
formatted in a less helpful manner).

---
 drivers/hwmon/adm1021.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index b11e06f..de84398 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -85,14 +85,11 @@ struct adm1021_data {
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	s8 temp_max[2];		/* Register values */
-	s8 temp_min[2];
-	s8 temp[2];
+	int temp_max[2];		/* Register values */
+	int temp_min[2];
+	int temp[2];
 	u8 alarms;
 	/* Special values for ADM1023 only */
-	u8 remote_temp_prec;
-	u8 remote_temp_os_prec;
-	u8 remote_temp_hyst_prec;
 	u8 remote_temp_offset;
 	u8 remote_temp_offset_prec;
 };
@@ -141,7 +138,7 @@ static ssize_t show_temp(struct device *dev,
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct adm1021_data *data = adm1021_update_device(dev);
 
-	return sprintf(buf, "%d\n", 1000 * data->temp[index]);
+	return sprintf(buf, "%d\n", data->temp[index]);
 }
 
 static ssize_t show_temp_max(struct device *dev,
@@ -150,7 +147,7 @@ static ssize_t show_temp_max(struct device *dev,
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct adm1021_data *data = adm1021_update_device(dev);
 
-	return sprintf(buf, "%d\n", 1000 * data->temp_max[index]);
+	return sprintf(buf, "%d\n", data->temp_max[index]);
 }
 
 static ssize_t show_temp_min(struct device *dev,
@@ -159,7 +156,7 @@ static ssize_t show_temp_min(struct device *dev,
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct adm1021_data *data = adm1021_update_device(dev);
 
-	return sprintf(buf, "%d\n", 1000 * data->temp_min[index]);
+	return sprintf(buf, "%d\n", data->temp_min[index]);
 }
 
 static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
@@ -412,25 +409,27 @@ static struct adm1021_data *adm1021_update_device(struct device *dev)
 		dev_dbg(&client->dev, "Starting adm1021 update\n");
 
 		for (i = 0; i < 2; i++) {
-			data->temp[i] = i2c_smbus_read_byte_data(client,
-						ADM1021_REG_TEMP(i));
-			data->temp_max[i] = i2c_smbus_read_byte_data(client,
-						ADM1021_REG_TOS_R(i));
-			data->temp_min[i] = i2c_smbus_read_byte_data(client,
-						ADM1021_REG_THYST_R(i));
+			data->temp[i] = 1000 *
+				(s8) i2c_smbus_read_byte_data(
+					client, ADM1021_REG_TEMP(i));
+			data->temp_max[i] = 1000 *
+				(s8) i2c_smbus_read_byte_data(
+					client, ADM1021_REG_TOS_R(i));
+			data->temp_min[i] = 1000 *
+				(s8) i2c_smbus_read_byte_data(
+					client, ADM1021_REG_THYST_R(i));
 		}
 		data->alarms = i2c_smbus_read_byte_data(client,
 						ADM1021_REG_STATUS) & 0x7c;
 		if (data->type == adm1023) {
-			data->remote_temp_prec =
-				i2c_smbus_read_byte_data(client,
-						ADM1023_REG_REM_TEMP_PREC);
-			data->remote_temp_os_prec =
-				i2c_smbus_read_byte_data(client,
-						ADM1023_REG_REM_TOS_PREC);
-			data->remote_temp_hyst_prec =
-				i2c_smbus_read_byte_data(client,
-						ADM1023_REG_REM_THYST_PREC);
+			/* The ADM1023 provides 3 extra bits of precision for
+			 * the remote sensor in extra registers. */
+			data->temp[1] += 125 * (i2c_smbus_read_byte_data(
+				client, ADM1023_REG_REM_TEMP_PREC) >> 5);
+			data->temp_max[1] += 125 * (i2c_smbus_read_byte_data(
+				client, ADM1023_REG_REM_TOS_PREC) >> 5);
+			data->temp_min[1] += 125 * (i2c_smbus_read_byte_data(
+				client, ADM1023_REG_REM_THYST_PREC) >> 5);
 			data->remote_temp_offset =
 				i2c_smbus_read_byte_data(client,
 						ADM1023_REG_REM_OFFSET);
-- 
1.6.1.3

