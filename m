Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896Ab0AZSzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0AZSzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704Ab0AZSzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:55:35 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:43093 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab0AZSze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:55:34 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B5F3AFE.7020404@cam.ac.uk>
Date: Tue, 26 Jan 2010 18:57:02 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, giometti@linux.it
Subject: [PATCH V3] tsl2550: Move form i2c/chips to als and update interfaces
References: <4B23D029.9080004@cam.ac.uk> <20100126105138.1006aaad@hyperion.delvare> <4B5F38A3.1030208@cam.ac.uk> <4B5F3961.3090103@jic23.retrosnub.co.uk>
In-Reply-To: <4B5F3961.3090103@jic23.retrosnub.co.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 Reverted incorrect removal of i2c/chips references in i2c/Kconfig etc.

 Documentation/ABI/testing/sysfs-class-als |    9 +++
 drivers/als/Kconfig                       |   14 ++++
 drivers/als/Makefile                      |    2 +
 drivers/{i2c/chips => als}/tsl2550.c      |  101 +++++++++++++++++-----------
 drivers/i2c/chips/Kconfig                 |   10 ---
 drivers/i2c/chips/Makefile                |    2 -
 6 files changed, 86 insertions(+), 52 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-als b/Documentation/ABI/testing/sysfs-class-als
index d3b33f3..732f449 100644
--- a/Documentation/ABI/testing/sysfs-class-als
+++ b/Documentation/ABI/testing/sysfs-class-als
@@ -7,3 +7,12 @@ Description:	Current Ambient Light Illuminance reported by
 		Unit: lux (lumens per square meter)
 		RO
 
+What:		/sys/class/als/.../exposure_time[n]
+Date:		Dec. 2009
+KernelVersion:	2.6.32
+Contact:	Jonathan Cameron <jic23@cam.ac.uk>
+Description:	Sensor exposure time.  In some devices this
+		corresponds to the combined time needed to
+		to internally read several different sensors.
+		Unit: microseconds
+		RW
diff --git a/drivers/als/Kconfig b/drivers/als/Kconfig
index 200c52b..1564ffc 100644
--- a/drivers/als/Kconfig
+++ b/drivers/als/Kconfig
@@ -8,3 +8,17 @@ menuconfig ALS
 	  This framework provides a generic sysfs I/F for Ambient Light
 	  Sensor devices.
 	  If you want this support, you should say Y or M here.
+
+if ALS
+
+config ALS_TSL2550
+	tristate "Taos TSL2550 ambient light sensor"
+	depends on EXPERIMENTAL && I2C
+	help
+	  If you say yes here you get support for the Taos TSL2550
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called tsl2550.
+
+endif #ALS
diff --git a/drivers/als/Makefile b/drivers/als/Makefile
index a527197..7be5631 100644
--- a/drivers/als/Makefile
+++ b/drivers/als/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-$(CONFIG_ALS)		+= als_sys.o
+
+obj-$(CONFIG_ALS_TSL2550)	+= tsl2550.o
\ No newline at end of file
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/als/tsl2550.c
similarity index 81%
rename from drivers/i2c/chips/tsl2550.c
rename to drivers/als/tsl2550.c
index a0702f3..8d5f2a1 100644
--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/als/tsl2550.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>
  *  Copyright (C) 2007 Eurotech S.p.A. <info@eurotech.it>
+ *  Copyright (C) 2009 Jonathan Cameron <jic23@cam.ac.uk>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -24,9 +25,11 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/als_sys.h>
 
 #define TSL2550_DRV_NAME	"tsl2550"
-#define DRIVER_VERSION		"1.2"
+#define DRIVER_VERSION		"2.0"
 
 /*
  * Defines
@@ -44,11 +47,12 @@
  */
 
 struct tsl2550_data {
+	struct device *classdev;
 	struct i2c_client *client;
 	struct mutex update_lock;
 
-	unsigned int power_state : 1;
-	unsigned int operating_mode : 1;
+	unsigned int power_state:1;
+	unsigned int operating_mode:1;
 };
 
 /*
@@ -102,15 +106,16 @@ static int tsl2550_get_adc_value(struct i2c_client *client, u8 cmd)
 		return ret;
 	if (!(ret & 0x80))
 		return -EAGAIN;
+	if (ret == 0x7f)
+		return -ERANGE;
 	return ret & 0x7f;	/* remove the "valid" bit */
 }
 
 /*
- * LUX calculation
+ * LUX calculation - note the range is dependent on combination
+ * of infrared level and visible light levels.
  */
 
-#define	TSL2550_MAX_LUX		1846
-
 static const u8 ratio_lut[] = {
 	100, 100, 100, 100, 100, 100, 100, 100,
 	100, 100, 100, 100, 100, 100, 99, 99,
@@ -180,8 +185,7 @@ static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
 	else
 		return -EAGAIN;
 
-	/* LUX range check */
-	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
+	return lux;
 }
 
 /*
@@ -191,7 +195,8 @@ static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
 static ssize_t tsl2550_show_power_state(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
 
 	return sprintf(buf, "%u\n", data->power_state);
 }
@@ -199,12 +204,12 @@ static ssize_t tsl2550_show_power_state(struct device *dev,
 static ssize_t tsl2550_store_power_state(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct tsl2550_data *data = i2c_get_clientdata(client);
-	unsigned long val = simple_strtoul(buf, NULL, 10);
-	int ret;
+	unsigned long val;
+	int ret = strict_strtoul(buf, 10, &val);
 
-	if (val < 0 || val > 1)
+	if (val < 0 || val > 1 || ret)
 		return -EINVAL;
 
 	mutex_lock(&data->update_lock);
@@ -220,40 +225,45 @@ static ssize_t tsl2550_store_power_state(struct device *dev,
 static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO,
 		   tsl2550_show_power_state, tsl2550_store_power_state);
 
-static ssize_t tsl2550_show_operating_mode(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t tsl2550_show_exposure(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
 {
-	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
-
-	return sprintf(buf, "%u\n", data->operating_mode);
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	if (data->operating_mode)
+		return sprintf(buf, "160000\n");
+	else
+		return sprintf(buf, "800000\n");
 }
 
-static ssize_t tsl2550_store_operating_mode(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t tsl2550_store_exposure(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t count)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct tsl2550_data *data = i2c_get_clientdata(client);
-	unsigned long val = simple_strtoul(buf, NULL, 10);
-	int ret;
-
-	if (val < 0 || val > 1)
-		return -EINVAL;
+	unsigned long val;
 
-	if (data->power_state == 0)
-		return -EBUSY;
+	int ret = strict_strtoul(buf, 10, &val);
 
+	if (ret)
+		return -EINVAL;
 	mutex_lock(&data->update_lock);
-	ret = tsl2550_set_operating_mode(client, val);
+	if (val >= 800000)
+		ret = tsl2550_set_operating_mode(client, 0);
+	else
+		ret = tsl2550_set_operating_mode(client, 1);
 	mutex_unlock(&data->update_lock);
-
 	if (ret < 0)
 		return ret;
 
 	return count;
 }
 
-static DEVICE_ATTR(operating_mode, S_IWUSR | S_IRUGO,
-		   tsl2550_show_operating_mode, tsl2550_store_operating_mode);
+static DEVICE_ATTR(exposure_time0, S_IWUSR | S_IRUGO,
+		   tsl2550_show_exposure, tsl2550_store_exposure);
 
 static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
 {
@@ -284,7 +294,7 @@ static ssize_t __tsl2550_show_lux(struct i2c_client *client, char *buf)
 static ssize_t tsl2550_show_lux1_input(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	struct tsl2550_data *data = i2c_get_clientdata(client);
 	int ret;
 
@@ -299,13 +309,13 @@ static ssize_t tsl2550_show_lux1_input(struct device *dev,
 	return ret;
 }
 
-static DEVICE_ATTR(lux1_input, S_IRUGO,
+static DEVICE_ATTR(illuminance0, S_IRUGO,
 		   tsl2550_show_lux1_input, NULL);
 
 static struct attribute *tsl2550_attributes[] = {
 	&dev_attr_power_state.attr,
-	&dev_attr_operating_mode.attr,
-	&dev_attr_lux1_input.attr,
+	&dev_attr_exposure_time0.attr,
+	&dev_attr_illuminance0.attr,
 	NULL
 };
 
@@ -391,14 +401,22 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
 		goto exit_kfree;
 
 	/* Register sysfs hooks */
-	err = sysfs_create_group(&client->dev.kobj, &tsl2550_attr_group);
-	if (err)
+	data->classdev = als_device_register(&client->dev);
+	if (IS_ERR(data->classdev)) {
+		err = PTR_ERR(data->classdev);
 		goto exit_kfree;
+	}
+
+	err = sysfs_create_group(&data->classdev->kobj, &tsl2550_attr_group);
+	if (err)
+		goto exit_unreg;
 
 	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
 
 	return 0;
 
+exit_unreg:
+	als_device_unregister(data->classdev);
 exit_kfree:
 	kfree(data);
 exit:
@@ -407,12 +425,15 @@ exit:
 
 static int __devexit tsl2550_remove(struct i2c_client *client)
 {
-	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&data->classdev->kobj, &tsl2550_attr_group);
+	als_device_unregister(data->classdev);
 
 	/* Power down the device */
 	tsl2550_set_power_state(client, 0);
 
-	kfree(i2c_get_clientdata(client));
+	kfree(data);
 
 	return 0;
 }
diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index ae4539d..c11f8d6 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -6,14 +6,4 @@
 
 menu "Miscellaneous I2C Chip support"
 
-config SENSORS_TSL2550
-	tristate "Taos TSL2550 ambient light sensor"
-	depends on EXPERIMENTAL
-	help
-	  If you say yes here you get support for the Taos TSL2550
-	  ambient light sensor.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called tsl2550.
-
 endmenu
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index fe0af0f..ffde18d 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -10,8 +10,6 @@
 # * I/O expander drivers go to drivers/gpio
 #
 
-obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
-
 ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
-- 
1.6.4.4

