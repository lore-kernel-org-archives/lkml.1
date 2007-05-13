Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXEMHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXEMHoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbXEMHoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 03:44:12 -0400
Received: from S01060016b61d1226.cg.shawcable.net ([68.147.67.118]:41050 "EHLO
	sandbox.secretlab.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbXEMHoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 03:44:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
To: Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Date: Sun, 13 May 2007 01:43:42 -0600
Message-ID: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Here is the 3rd iteration with the following changes:
- Modified to be an i2c "new style" driver based on David Brownell's work
- uses the new prototype for i2c_smbus_read_i2c_block_data() for block data
  reads instead of a single byte at a time.

 drivers/i2c/chips/ds1682.c |  270 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 270 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
new file mode 100644
index 0000000..0a4a89e
--- /dev/null
+++ b/drivers/i2c/chips/ds1682.c
@@ -0,0 +1,270 @@
+/*
+ * Dallas Semiconductor DS1682 Elapsed Time Recorder device driver
+ *
+ * Written by: Grant Likely <grant.likely@secretlab.ca>
+ *
+ * Copyright (C) 2007 Secret Lab Technologies Ltd.
+ * Copyright (C) 2005 James Chapman <jchapman@katalix.com>
+ * Copyright (C) 2000 Russell King
+ *
+ * Derived from ds1337 real time clock device driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * The DS1682 elapsed timer recorder is a simple device that implements
+ * one elapsed time counter, one event counter, an alarm signal and 10
+ * bytes of general purpose EEPROM.
+ *
+ * This driver provides access to the DS1682 counters and user data via
+ * the sysfs.  The following attributes are added to the device node:
+ *     elapsed_time (u32): Total elapsed event time in ms resolution
+ *     alarm_time (u32): When elapsed time exceeds the value in alarm_time,
+ *                       then the alarm pin is asserted.
+ *     event_count (u16): number of times the event pin has gone low.
+ *     eeprom (u8[10]): general purpose EEPROM
+ *
+ * Counter registers and user data are both read/write unless the device
+ * has been write protected.  This driver does not support turning off write
+ * protection.  Once write protection is turned on, it is impossible to
+ * turn it off again, so I have left the feature out of this driver to avoid
+ * accidental enabling, but it is trivial to add write protect support.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <linux/sysfs.h>
+#include <linux/ctype.h>
+#include <linux/hwmon-sysfs.h>
+
+/* Device registers */
+#define DS1682_REG_CONFIG		0x00
+#define DS1682_REG_ALARM		0x01
+#define DS1682_REG_ELAPSED		0x05
+#define DS1682_REG_EVT_CNTR		0x09
+#define DS1682_REG_EEPROM		0x0b
+#define DS1682_REG_RESET		0x1d
+#define DS1682_REG_WRITE_DISABLE	0x1e
+#define DS1682_REG_WRITE_MEM_DISABLE	0x1f
+
+#define DS1682_EEPROM_SIZE		10
+
+/*
+ * Generic counter attributes
+ */
+static ssize_t ds1682_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct i2c_client *client = to_i2c_client(dev);
+	__le32 val = 0;
+	int rc;
+
+	dev_dbg(dev, "ds1682_show() called on %s\n", attr->attr.name);
+
+	/* Read the register */
+	rc = i2c_smbus_read_i2c_block_data(client, sattr->index, sattr->nr,
+					   (u8 *) & val);
+	if (rc < 0)
+		return -EIO;
+
+	/* Special case: the 32 bit regs are time values with 1/4s
+	 * resolution, scale them up to milliseconds */
+	if (sattr->nr == 4)
+		return sprintf(buf, "%lli\n", ((u64) le32_to_cpu(val)) * 250);
+
+	/* Format the output string and return # of bytes */
+	return sprintf(buf, "%li\n", (long)le32_to_cpu(val));
+}
+
+static ssize_t ds1682_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct i2c_client *client = to_i2c_client(dev);
+	char *endp;
+	u64 val;
+	__le32 val_le;
+	int rc;
+
+	dev_dbg(dev, "ds1682_store() called on %s\n", attr->attr.name);
+
+	/* Decode input */
+	val = simple_strtoull(buf, &endp, 0);
+	if (buf == endp) {
+		dev_dbg(dev, "input string not a number\n");
+		return -EIO;
+	}
+
+	/* Special case: the 32 bit regs are time values with 1/4s
+	 * resolution, scale input down to quarter-seconds */
+	if (sattr->nr == 4)
+		do_div(val, 250);
+
+	/* write out the value */
+	val_le = cpu_to_le32(val);
+	rc = i2c_smbus_write_i2c_block_data(client, sattr->index, sattr->nr,
+					    (u8 *) & val);
+	if (rc < 0) {
+		dev_err(dev, "register write failed; reg=0x%x, size=%i\n",
+			sattr->index, sattr->nr);
+		return -EIO;
+	}
+
+	return count;
+}
+
+/*
+ * Simple register attributes
+ */
+SENSOR_DEVICE_ATTR_2(config, S_IRUGO, ds1682_show, NULL, DS1682_REG_CONFIG, 1);
+SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
+		     4, DS1682_REG_ELAPSED);
+SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
+		     4, DS1682_REG_ALARM);
+SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
+		     2, DS1682_REG_EVT_CNTR);
+
+static const struct attribute_group ds1682_group = {
+	.attrs = (struct attribute *[]) {
+		&sensor_dev_attr_config.dev_attr.attr,
+		&sensor_dev_attr_elapsed_time.dev_attr.attr,
+		&sensor_dev_attr_alarm_time.dev_attr.attr,
+		&sensor_dev_attr_event_count.dev_attr.attr,
+		NULL,
+	},
+};
+
+/*
+ * User data attribute
+ */
+static ssize_t ds1682_eeprom_read(struct kobject *kobj, char *buf, loff_t off,
+				  size_t count)
+{
+	struct i2c_client *client = kobj_to_i2c_client(kobj);
+	int rc;
+
+	dev_dbg(&client->dev, "ds1682_eeprom_read(p=%p, off=%lli, c=%zi)\n",
+		buf, off, count);
+
+	if (off > DS1682_EEPROM_SIZE)
+		return 0;
+
+	if (off + count > DS1682_EEPROM_SIZE)
+		count = DS1682_EEPROM_SIZE - off;
+
+	rc = i2c_smbus_read_i2c_block_data(client, DS1682_REG_EEPROM + off,
+					   count, buf);
+	if (rc < 0)
+		return -EIO;
+
+	return count;
+}
+
+static ssize_t ds1682_eeprom_write(struct kobject *kobj, char *buf, loff_t off,
+				   size_t count)
+{
+	struct i2c_client *client = kobj_to_i2c_client(kobj);
+
+	dev_dbg(&client->dev, "ds1682_eeprom_write(p=%p, off=%lli, c=%zi)\n",
+		buf, off, count);
+
+	if (off >= DS1682_EEPROM_SIZE)
+		return -ENOSPC;
+
+	if (off + count > DS1682_EEPROM_SIZE)
+		count = DS1682_EEPROM_SIZE - off;
+
+	/* Write out to the device */
+	if (i2c_smbus_write_i2c_block_data(client, DS1682_REG_EEPROM + off,
+					   count, buf) < 0)
+		return -EIO;
+
+	return count;
+}
+
+static struct bin_attribute ds1682_eeprom_attr = {
+	.attr = {
+		.name = "eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = DS1682_EEPROM_SIZE,
+	.read = ds1682_eeprom_read,
+	.write = ds1682_eeprom_write,
+};
+
+/*
+ * Called when a device is found at the ds1682 address
+ */
+static int ds1682_probe(struct i2c_client *client)
+{
+	int err = 0;
+
+	if (client->addr != 0x6b) {
+		dev_err(&client->dev, "%x is not a valid address\n",
+			client->addr);
+		return -ENODEV;
+	}
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_READ_BYTE_DATA |
+				     I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
+		dev_err(&client->dev, "i2c bus does not support the ds1682\n");
+		goto exit;
+	}
+
+	if (sysfs_create_group(&client->dev.kobj, &ds1682_group))
+		goto exit;
+
+	if (sysfs_create_bin_file(&client->dev.kobj, &ds1682_eeprom_attr))
+		goto exit_bin_attr;
+
+	return 0;
+
+      exit_bin_attr:
+	sysfs_remove_group(&client->dev.kobj, &ds1682_group);
+      exit:
+	return err;
+}
+
+static int ds1682_remove(struct i2c_client *client)
+{
+	sysfs_remove_bin_file(&client->dev.kobj, &ds1682_eeprom_attr);
+	sysfs_remove_group(&client->dev.kobj, &ds1682_group);
+
+	return 0;
+}
+
+static struct i2c_driver ds1682_driver = {
+	.driver = {
+		.name = "ds1682",
+	},
+	.probe = ds1682_probe,
+	.remove = ds1682_remove,
+};
+
+static int __init ds1682_init(void)
+{
+	return i2c_add_driver(&ds1682_driver);
+}
+
+static void __exit ds1682_exit(void)
+{
+	i2c_del_driver(&ds1682_driver);
+}
+
+MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
+MODULE_DESCRIPTION("DS1682 Elapsed Time Indicator driver");
+MODULE_LICENSE("GPL");
+
+module_init(ds1682_init);
+module_exit(ds1682_exit);

