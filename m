Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbXJEJcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbXJEJcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXJEJck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:32:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:48278 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbXJEJci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c/cm+t4Lg3T9qRQz55YX9nM/wgz1k3RD60I56AU1p7hJC2FVQxrEiAHE5RV3ci4f/D2Hksv+iyz/iQQt+ukFgnCLpzufqk4JZ9IhAittCXDlqQDuplpxy1oByQp4ydzTvpfxUvNjKua0ns6hV/blkyQK2TbA0NSV8IEI/XBxdO0=
Message-ID: <e2e108260710050232s1b0a9cb7u604ab7e20b61646e@mail.gmail.com>
Date: Fri, 5 Oct 2007 11:32:35 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: khali@linux-fr.org
Subject: [PATCH] I2C: add support for the PCF8575 chip
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche

Add support for the PCF8575 I2C chip.

Signed-off-by: Bart Van Assche (bart.vanassche@gmail.com)
---
diff -uprN -X orig/linux-2.6.22.9/Documentation/dontdiff
orig/linux-2.6.22.9/drivers/i2c/chips/Kconfig
linux-2.6.22.9/drivers/i2c/chips/Kconfig
--- orig/linux-2.6.22.9/drivers/i2c/chips/Kconfig	2007-09-26
20:03:01.000000000 +0200
+++ linux-2.6.22.9/drivers/i2c/chips/Kconfig	2007-10-05 09:27:19.000000000 +0200
@@ -41,13 +41,27 @@ config SENSORS_PCF8574
 	default n
 	help
 	  If you say yes here you get support for Philips PCF8574 and
-	  PCF8574A chips.
+	  PCF8574A chips. These chips are 8-bit I/O expanders for the I2C bus.

 	  This driver can also be built as a module.  If so, the module
 	  will be called pcf8574.

-	  These devices are hard to detect and rarely found on mainstream
-	  hardware.  If unsure, say N.
+	  These devices are hard to detect automatically and are rarely found
+	  on mainstream hardware.  If unsure, say N.
+
+config SENSORS_PCF8575
+	tristate "Philips PCF8575"
+	default n
+	help
+	  If you say yes here you get support for Philips PCF8575 chip.
+	  This chip is a 16-bit I/O expander for the I2C bus.  Several other
+	  chip manufacturers sell equivalent chips, e.g. Texas Instruments.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pcf8575.
+
+	  This device is hard to detect automatically and is rarely found on
+	  mainstream hardware.  If unsure, say N.

 config SENSORS_PCA9539
 	tristate "Philips PCA9539 16-bit I/O port"
diff -uprN -X orig/linux-2.6.22.9/Documentation/dontdiff
orig/linux-2.6.22.9/drivers/i2c/chips/Makefile
linux-2.6.22.9/drivers/i2c/chips/Makefile
--- orig/linux-2.6.22.9/drivers/i2c/chips/Makefile	2007-09-26
20:03:01.000000000 +0200
+++ linux-2.6.22.9/drivers/i2c/chips/Makefile	2007-10-05
09:16:21.000000000 +0200
@@ -9,6 +9,7 @@ obj-$(CONFIG_SENSORS_MAX6875)	+= max6875
 obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
 obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
 obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
+obj-$(CONFIG_SENSORS_PCF8575)	+= pcf8575.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
diff -uprN -X orig/linux-2.6.22.9/Documentation/dontdiff
orig/linux-2.6.22.9/drivers/i2c/chips/pcf8575.c
linux-2.6.22.9/drivers/i2c/chips/pcf8575.c
--- orig/linux-2.6.22.9/drivers/i2c/chips/pcf8575.c	2007-10-05
09:44:02.000000000 +0200
+++ linux-2.6.22.9/drivers/i2c/chips/pcf8575.c	2007-10-05
11:10:46.000000000 +0200
@@ -0,0 +1,305 @@
+/*
+  pcf8575.c - Part of lm_sensors, Linux kernel modules for hardware
+  monitoring
+  Copyright (c) 2000  Frodo Looijaard <frodol@dds.nl>,
+  Philip Edelbrock <phil@netroedge.com>,
+  Dan Eaton <dan.eaton@rocketlogix.com>
+  Ported to Linux 2.6 by Aurelien Jarno <aurel32@debian.org> with
+  the help of Jean Delvare <khali@linux-fr.org>
+
+  Copyright (C) 2006 Michael Hennerich, Analog Devices Inc.
+  <hennerich@blackfin.uclinux.org>
+  based on the pcf8574.c
+
+  Ported from ucLinux to mainstream Linux kernel by Bart Van Assche.
+
+  About the pcf8575: the pcf8575 is an 16-bit I/O expander for the I2C bus
+  produced by a.o. Philips Semiconductors.
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/version.h>
+#include <linux/i2c.h>
+
+
+/* Addresses to scan */
+static unsigned short normal_i2c[]       = { I2C_CLIENT_END };
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+static unsigned short normal_i2c_range[] = { I2C_CLIENT_END };
+#endif
+
+/* Insmod parameters */
+I2C_CLIENT_INSMOD;
+
+
+/* Each client has this additional data */
+struct pcf8575_data {
+	struct i2c_client client;
+
+	u16 write;  /* Remember last written value */
+	u8  buf[3];
+};
+
+static int pcf8575_attach_adapter(struct i2c_adapter *adapter);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
+static int pcf8575_detect(struct i2c_adapter *adapter, int address, int kind);
+#else
+static int pcf8575_detect(struct i2c_adapter *adapter,
+			int addr, unsigned short flags, int kind);
+#endif
+static int pcf8575_detach_client(struct i2c_client *client);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver pcf8575_driver = {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "pcf8575",
+	},
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
+	.owner           = THIS_MODULE,
+	.name            = "pcf8575",
+	.flags           = I2C_DF_NOTIFY,
+#else
+#error
+#endif
+	.attach_adapter  = pcf8575_attach_adapter,
+	.detach_client   = pcf8575_detach_client,
+};
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)
+/* following are the sysfs callback functions */
+static ssize_t show_read(struct device *dev,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+			struct device_attribute *attr,
+#endif
+			char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pcf8575_data *data = i2c_get_clientdata(client);
+	unsigned short val;
+
+	i2c_master_recv(client, data->buf, 2);
+
+	val = data->buf[0];
+	val |= data->buf[1]<<8;
+
+	return sprintf(buf, "%u\n", val);
+}
+
+static DEVICE_ATTR(read, S_IRUGO, show_read, NULL);
+
+static ssize_t show_write(struct device *dev,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+			struct device_attribute *attr,
+#endif
+			char *buf)
+{
+	struct pcf8575_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	return sprintf(buf, "%u\n", data->write);
+}
+
+static ssize_t set_write(struct device *dev,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+			struct device_attribute *attr,
+#endif
+			const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pcf8575_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+
+	if (val > 0xffff)
+		return -EINVAL;
+
+	data->write = val;
+
+	data->buf[0] = val & 0xFF;
+	data->buf[1] = val >> 8;
+
+	i2c_master_send(client, data->buf, 2);
+
+	return count;
+}
+
+static DEVICE_ATTR(write, S_IWUSR | S_IRUGO, show_write, set_write);
+
+static ssize_t set_set_bit(struct device *dev,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+			struct device_attribute *attr,
+#endif
+			const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pcf8575_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+	unsigned short dummy;
+	if (val > 15)
+		return -EINVAL;
+
+	i2c_master_recv(client, data->buf, 2);
+
+	dummy = data->buf[0];
+	dummy |= data->buf[1]<<8;
+
+	dummy |= 1 << val;
+
+	data->buf[0] = dummy & 0xFF;
+	data->buf[1] = dummy >> 8;
+
+	i2c_master_send(client, data->buf, 2);
+
+	return count;
+}
+
+static DEVICE_ATTR(set_bit, S_IWUSR, show_write, set_set_bit);
+
+static ssize_t set_clear_bit(struct device *dev,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+			struct device_attribute *attr,
+#endif
+			const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pcf8575_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+	unsigned short dummy;
+	if (val > 15)
+		return -EINVAL;
+
+	i2c_master_recv(client, data->buf, 2);
+
+	dummy = data->buf[0];
+	dummy |= data->buf[1]<<8;
+
+	dummy &= ~(1 << val);
+
+	data->buf[0] = dummy & 0xFF;
+	data->buf[1] = dummy >> 8;
+
+	i2c_master_send(client, data->buf, 2);
+
+	return count;
+}
+
+static DEVICE_ATTR(clear_bit, S_IWUSR, show_write, set_clear_bit);
+#endif
+
+/*
+ * Real code
+ */
+
+static int pcf8575_attach_adapter(struct i2c_adapter *adapter)
+{
+	return i2c_probe(adapter, &addr_data, pcf8575_detect);
+}
+
+/* This function is called by i2c_probe */
+static int pcf8575_detect(struct i2c_adapter *adapter,
+			int address,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 0)
+			unsigned short flags,
+#endif
+			int kind)
+{
+	struct i2c_client *new_client;
+	struct pcf8575_data *data;
+	int err = 0;
+	const char *client_name = "";
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
+		goto exit;
+
+	/* OK. For now, we presume we have a valid client. We now create the
+	   client structure, even though we cannot fill it completely yet. */
+	data = kzalloc(sizeof(struct pcf8575_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	new_client = &data->client;
+	i2c_set_clientdata(new_client,  data);
+	new_client->addr = address;
+	new_client->adapter = adapter;
+	new_client->driver = &pcf8575_driver;
+	new_client->flags = 0;
+
+	/* Now, we would do the remaining detection. But the pcf8575 is plainly
+	   impossible to detect! Stupid chip. */
+
+
+	client_name = "pcf8575";
+
+	/* Fill in the remaining client fields and put into the global list */
+	strlcpy(new_client->name, client_name, I2C_NAME_SIZE);
+
+	/* Tell the I2C layer a new client has arrived */
+	err = i2c_attach_client(new_client);
+	if (err)
+		goto exit_free;
+
+
+	/* Register sysfs hooks */
+	if (device_create_file(&new_client->dev, &dev_attr_read) >= 0
+	    && device_create_file(&new_client->dev, &dev_attr_write) >= 0
+	    && device_create_file(&new_client->dev, &dev_attr_set_bit) >= 0
+	    && device_create_file(&new_client->dev, &dev_attr_clear_bit) >= 0) {
+		return 0;
+	}
+
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int pcf8575_detach_client(struct i2c_client *client)
+{
+	int err;
+
+	err = i2c_detach_client(client);
+	if (err)
+		return err;
+
+	kfree(i2c_get_clientdata(client));
+	return 0;
+}
+
+static int __init pcf8575_init(void)
+{
+	return i2c_add_driver(&pcf8575_driver);
+}
+
+static void __exit pcf8575_exit(void)
+{
+	i2c_del_driver(&pcf8575_driver);
+}
+
+
+MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
+	      "Philip Edelbrock <phil@netroedge.com>, "
+	      "Dan Eaton <dan.eaton@rocketlogix.com> "
+	      "and Aurelien Jarno <aurelien@aurel32.net>"
+	      "Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("pcf8575 driver");
+MODULE_LICENSE("GPL");
+
+module_init(pcf8575_init);
+module_exit(pcf8575_exit);
