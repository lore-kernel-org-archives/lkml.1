Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYHKMeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYHKMeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYHKMd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:33:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYHKMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:33:57 -0400
Subject: [PATCH] hwmon: Included max1618 support in max1619 driver
From: Tobias Himmer <tobias@himmer-online.de>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, bigeasy@linutronix.de, hjk@linutronix.de,
       fishor@mail.ru, khali@linux-fr.org, akpm@linux-foundation.org
Date: Mon, 11 Aug 2008 14:33:41 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808111433.41280.tobias@himmer-online.de>
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18W1nmTFxR4+AGWFT/wHydC30DBt9D0B6cVjGH
 0lN6QDvAtctoNplunzYGq6fr0v4HIXDZcUHh/Ac3/1zq8LkdsM
 9rm/jflaXzFpxEjhnFTg5qieaFxayEvP87TZRyvUeE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I modified the existing max1619 driver in order to support the MAX1618 chip,
a stripped down version of the MAX1619.

Tobias


Signed-off-by: Tobias Himmer <tobias@himmer-online.de>
---
 drivers/hwmon/Kconfig   |    3 +-
 drivers/hwmon/max1619.c |  204 +++++++++++++++++++++++++++++++----------------
 2 files changed, 138 insertions(+), 69 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 00ff533..374b282 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -507,7 +507,8 @@ config SENSORS_MAX1619
 	tristate "Maxim MAX1619 sensor chip"
 	depends on I2C
 	help
-	  If you say yes here you get support for MAX1619 sensor chip.
+	  If you say yes here you get support for Maxim MAX1619 and MAX1618
+	  sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called max1619.
diff --git a/drivers/hwmon/max1619.c b/drivers/hwmon/max1619.c
index 7e7267a..5788808 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -3,12 +3,15 @@
  *             monitoring
  * Copyright (C) 2003-2004 Alexey Fisher <fishor@mail.ru>
  *                         Jean Delvare <khali@linux-fr.org>
+ *                         Tobias Himmer <tobias@himmer-online.de>
  *
  * Based on the lm90 driver. The MAX1619 is a sensor chip made by Maxim.
- * It reports up to two temperatures (its own plus up to
- * one external one). Complete datasheet can be
- * obtained from Maxim's website at:
+ * It reports up to two temperatures (its own plus up to one external one).
+ * This driver will also work on the MAX1618, a stripped down version with
+ * only one (external) temperature source.
+ * Complete datasheets can be obtained from Maxim's website at:
  *   http://pdfserv.maxim-ic.com/en/ds/MAX1619.pdf
+ *   http://pdfserv.maxim-ic.com/en/ds/MAX1618.pdf
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -44,7 +47,7 @@ static const unsigned short normal_i2c[] = {
  * Insmod parameters
  */
 
-I2C_CLIENT_INSMOD_1(max1619);
+I2C_CLIENT_INSMOD_2(max1619, max1618);
 
 /*
  * The MAX1619 registers
@@ -80,8 +83,7 @@ I2C_CLIENT_INSMOD_1(max1619);
  */
 
 static int max1619_attach_adapter(struct i2c_adapter *adapter);
-static int max1619_detect(struct i2c_adapter *adapter, int address,
-	int kind);
+static int max1619_detect(struct i2c_adapter *adapter, int address, int kind);
 static void max1619_init_client(struct i2c_client *client);
 static int max1619_detach_client(struct i2c_client *client);
 static struct max1619_data *max1619_update_device(struct device *dev);
@@ -106,37 +108,54 @@ struct max1619_data {
 	struct i2c_client client;
 	struct device *hwmon_dev;
 	struct mutex update_lock;
+	const struct attribute_group *group;
+	int kind; /* detected chip ( max1619 / max1618 ) */
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
 
 	/* registers values */
-	u8 temp_input1; /* local */
-	u8 temp_input2, temp_low2, temp_high2; /* remote */
-	u8 temp_crit2;
-	u8 temp_hyst2;
-	u8 alarms; 
+	u8 local;
+	u8 remote;
+	u8 remote_low, remote_high;
+	u8 remote_crit, remote_hyst;
+	u8 alarms;
 };
 
 /*
  * Sysfs stuff
  */
 
+static ssize_t show_temp1_input(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct max1619_data *data = max1619_update_device(dev);
+	return sprintf(buf, "%d\n", TEMP_FROM_REG((data->kind == max1618)?
+					data->remote : data->local));
+}
+
+static ssize_t show_temp2_input(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct max1619_data *data = max1619_update_device(dev);
+	return sprintf(buf, "%d\n", TEMP_FROM_REG(data->remote));
+}
+
 #define show_temp(value) \
-static ssize_t show_##value(struct device *dev, struct device_attribute *attr, char *buf) \
+static ssize_t show_##value(struct device *dev, struct device_attribute *attr, \
+			    char *buf) \
 { \
 	struct max1619_data *data = max1619_update_device(dev); \
 	return sprintf(buf, "%d\n", TEMP_FROM_REG(data->value)); \
 }
-show_temp(temp_input1);
-show_temp(temp_input2);
-show_temp(temp_low2);
-show_temp(temp_high2);
-show_temp(temp_crit2);
-show_temp(temp_hyst2);
-
-#define set_temp2(value, reg) \
-static ssize_t set_##value(struct device *dev, struct device_attribute *attr, const char *buf, \
-	size_t count) \
+
+show_temp(remote_low);
+show_temp(remote_high);
+show_temp(remote_crit);
+show_temp(remote_hyst);
+
+#define set_temp(value, reg) \
+static ssize_t set_##value(struct device *dev, struct device_attribute *attr, \
+			   const char *buf, size_t count) \
 { \
 	struct i2c_client *client = to_i2c_client(dev); \
 	struct max1619_data *data = i2c_get_clientdata(client); \
@@ -149,12 +168,13 @@ static ssize_t set_##value(struct device *dev, struct device_attribute *attr, co
 	return count; \
 }
 
-set_temp2(temp_low2, MAX1619_REG_W_REMOTE_LOW);
-set_temp2(temp_high2, MAX1619_REG_W_REMOTE_HIGH);
-set_temp2(temp_crit2, MAX1619_REG_W_REMOTE_CRIT);
-set_temp2(temp_hyst2, MAX1619_REG_W_TCRIT_HYST);
+set_temp(remote_low, MAX1619_REG_W_REMOTE_LOW);
+set_temp(remote_high, MAX1619_REG_W_REMOTE_HIGH);
+set_temp(remote_crit, MAX1619_REG_W_REMOTE_CRIT);
+set_temp(remote_hyst, MAX1619_REG_W_TCRIT_HYST);
 
-static ssize_t show_alarms(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_alarms(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
 	struct max1619_data *data = max1619_update_device(dev);
 	return sprintf(buf, "%d\n", data->alarms);
@@ -168,22 +188,49 @@ static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", (data->alarms >> bitnr) & 1);
 }
 
-static DEVICE_ATTR(temp1_input, S_IRUGO, show_temp_input1, NULL);
-static DEVICE_ATTR(temp2_input, S_IRUGO, show_temp_input2, NULL);
-static DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp_low2,
-	set_temp_low2);
-static DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp_high2,
-	set_temp_high2);
-static DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp_crit2,
-	set_temp_crit2);
-static DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_temp_hyst2,
-	set_temp_hyst2);
+/* These are for both - MAX1619 and MAX1618 */
+static DEVICE_ATTR(temp1_input, S_IRUGO, show_temp1_input, NULL);
 static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
+
+/* These are just for MAX1619 */
+static DEVICE_ATTR(temp2_input, S_IRUGO, show_temp2_input, NULL);
+static DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_remote_low,
+		   set_remote_low);
+static DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_remote_high,
+		   set_remote_high);
+static DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_remote_crit,
+		   set_remote_crit);
+static DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_remote_hyst,
+		   set_remote_hyst);
 static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO, show_alarm, NULL, 1);
 static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
 static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_alarm, NULL, 3);
 static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_alarm, NULL, 4);
 
+/* These are just for MAX1618 */
+static DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_remote_low,
+		   set_remote_low);
+static DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_remote_high,
+		   set_remote_high);
+static SENSOR_DEVICE_ATTR(temp1_fault, S_IRUGO, show_alarm, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, show_alarm, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL, 4);
+
+static struct attribute *max1618_attributes[] = {
+	&dev_attr_temp1_input.attr,
+	&dev_attr_temp1_min.attr,
+	&dev_attr_temp1_max.attr,
+
+	&dev_attr_alarms.attr,
+	&sensor_dev_attr_temp1_fault.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group max1618_group = {
+	.attrs = max1618_attributes,
+};
 static struct attribute *max1619_attributes[] = {
 	&dev_attr_temp1_input.attr,
 	&dev_attr_temp2_input.attr,
@@ -256,9 +303,9 @@ static int max1619_detect(struct i2c_adapter *adapter, int address, int kind)
 	 */
 	if (kind < 0) { /* detection */
 		reg_config = i2c_smbus_read_byte_data(new_client,
-			      MAX1619_REG_R_CONFIG);
+				MAX1619_REG_R_CONFIG);
 		reg_convrate = i2c_smbus_read_byte_data(new_client,
-			       MAX1619_REG_R_CONVRATE);
+				MAX1619_REG_R_CONVRATE);
 		reg_status = i2c_smbus_read_byte_data(new_client,
 				MAX1619_REG_R_STATUS);
 		if ((reg_config & 0x03) != 0x00
@@ -272,14 +319,24 @@ static int max1619_detect(struct i2c_adapter *adapter, int address, int kind)
 
 	if (kind <= 0) { /* identification */
 		u8 man_id, chip_id;
-	
+
 		man_id = i2c_smbus_read_byte_data(new_client,
-			 MAX1619_REG_R_MAN_ID);
+				MAX1619_REG_R_MAN_ID);
 		chip_id = i2c_smbus_read_byte_data(new_client,
-			  MAX1619_REG_R_CHIP_ID);
-		
-		if ((man_id == 0x4D) && (chip_id == 0x04))
-			kind = max1619;
+				MAX1619_REG_R_CHIP_ID);
+
+		if (man_id == 0x4D) {
+			switch (chip_id) {
+			case 0x04:
+				kind = max1619;
+				name = "max1619";
+				break;
+			case 0x02:
+				kind = max1618;
+				name = "max1618";
+				break;
+			}
+		}
 
 		if (kind <= 0) { /* identification failed */
 			dev_info(&adapter->dev,
@@ -289,8 +346,7 @@ static int max1619_detect(struct i2c_adapter *adapter, int address, int kind)
 		}
 	}
 
-	if (kind == max1619)
-		name = "max1619";
+	data->kind = kind;
 
 	/* We can fill in the remaining client fields */
 	strlcpy(new_client->name, name, I2C_NAME_SIZE);
@@ -305,7 +361,13 @@ static int max1619_detect(struct i2c_adapter *adapter, int address, int kind)
 	max1619_init_client(new_client);
 
 	/* Register sysfs hooks */
-	if ((err = sysfs_create_group(&new_client->dev.kobj, &max1619_group)))
+	if (kind == max1618)
+		data->group = &max1618_group;
+	else
+		data->group = &max1619_group;
+
+	err = sysfs_create_group(&new_client->dev.kobj, data->group);
+	if (err)
 		goto exit_detach;
 
 	data->hwmon_dev = hwmon_device_register(&new_client->dev);
@@ -317,7 +379,7 @@ static int max1619_detect(struct i2c_adapter *adapter, int address, int kind)
 	return 0;
 
 exit_remove_files:
-	sysfs_remove_group(&new_client->dev.kobj, &max1619_group);
+	sysfs_remove_group(&new_client->dev.kobj, data->group);
 exit_detach:
 	i2c_detach_client(new_client);
 exit_free:
@@ -347,7 +409,8 @@ static int max1619_detach_client(struct i2c_client *client)
 	int err;
 
 	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &max1619_group);
+
+	sysfs_remove_group(&client->dev.kobj, data->group);
 
 	if ((err = i2c_detach_client(client)))
 		return err;
@@ -365,21 +428,25 @@ static struct max1619_data *max1619_update_device(struct device *dev)
 
 	if (time_after(jiffies, data->last_updated + HZ * 2) || !data->valid) {
 		dev_dbg(&client->dev, "Updating max1619 data.\n");
-		data->temp_input1 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_LOCAL_TEMP);
-		data->temp_input2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_TEMP);
-		data->temp_high2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_HIGH);
-		data->temp_low2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_LOW);
-		data->temp_crit2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_CRIT);
-		data->temp_hyst2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_TCRIT_HYST);
-		data->alarms = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_STATUS);
-
+		switch (data->kind) {
+		default:
+			data->local = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_LOCAL_TEMP);
+			data->remote_crit = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_CRIT);
+			data->remote_hyst = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_TCRIT_HYST);
+		/* fallthrough */
+		case max1618:
+			data->remote = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_TEMP);
+			data->remote_high = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_HIGH);
+			data->remote_low = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_LOW);
+			data->alarms = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_STATUS);
+		}
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
@@ -399,9 +466,10 @@ static void __exit sensors_max1619_exit(void)
 	i2c_del_driver(&max1619_driver);
 }
 
-MODULE_AUTHOR("Alexey Fisher <fishor@mail.ru> and "
-	"Jean Delvare <khali@linux-fr.org>");
-MODULE_DESCRIPTION("MAX1619 sensor driver");
+MODULE_AUTHOR("Alexey Fisher <fishor@mail.ru>, "
+	"Jean Delvare <khali@linux-fr.org>,"
+	"Tobias Himmer <tobias@himmer-online.de>");
+MODULE_DESCRIPTION("MAX1619 / MAX1618 sensor driver");
 MODULE_LICENSE("GPL");
 
 module_init(sensors_max1619_init);
-- 
1.5.5.2

