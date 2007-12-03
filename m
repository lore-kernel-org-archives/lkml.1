Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXLCS4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXLCS4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXLCS4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:56:12 -0500
Received: from smtp3.global.net.uk ([80.189.92.91]:54352 "EHLO
	smtp3.global.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXLCS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:56:10 -0500
X-Greylist: delayed 3366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 13:56:10 EST
Message-ID: <4754441F.1030405@linuxrealtime.co.uk>
Date: Mon, 03 Dec 2007 17:59:59 +0000
From: Steve Hardy <steve@linuxrealtime.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] : hwmon - new chip driver for TI ADS7828 A-D
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Authenticated-Sender: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch against 2.6.23.9 which adds support for the 
Burr-Brown/Texas-Instruments
ADS7828 12-bit 8-channel A-D converter.

The chip is used for voltage monitoring on the COTS processor card I am
currently working with.

The driver simply outputs the current input voltages (in mv as specified
in the lm-sensors sysfs interface documentation).  Any scaling required for
a specific board is handled by user-space.  Hopefully this makes the driver
generic enough to be generally useful.

The driver is basically a simple rehash of existing code - I used lm75 as
the starting point, with some inspiration from other existing drivers.

Please let me know if there are any problems with the patch.

Regards,
Steve


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.

Signed-off-by: Steve Hardy <steve@linuxrealtime.co.uk>

---

diff -uprN -X linux-2.6.23.9/Documentation/dontdiff 
linux-2.6.23.9/drivers/hwmon/Kconfig 
linux-2.6.23.9-ads7828/drivers/hwmon/Kconfig
--- linux-2.6.23.9/drivers/hwmon/Kconfig    2007-11-26 
17:51:43.000000000 +0000
+++ linux-2.6.23.9-ads7828/drivers/hwmon/Kconfig    2007-11-28 
10:02:02.000000000 +0000
@@ -530,6 +530,16 @@ config SENSORS_THMC50
       This driver can also be built as a module.  If so, the module
       will be called thmc50.
 
+config SENSORS_ADS7828
+    tristate "Texas Instruments ADS7828"
+    depends on I2C && EXPERIMENTAL
+    help
+      If you say yes here you get support for Texas Instruments ADS7828
+      12-bit 8-channel ADC device
+
+      This driver can also be built as a module.  If so, the module
+      will be called ads7828
+
 config SENSORS_VIA686A
     tristate "VIA686A"
     depends on PCI
diff -uprN -X linux-2.6.23.9/Documentation/dontdiff 
linux-2.6.23.9/drivers/hwmon/Makefile 
linux-2.6.23.9-ads7828/drivers/hwmon/Makefile
--- linux-2.6.23.9/drivers/hwmon/Makefile    2007-11-26 
17:51:43.000000000 +0000
+++ linux-2.6.23.9-ads7828/drivers/hwmon/Makefile    2007-11-28 
10:02:02.000000000 +0000
@@ -22,6 +22,7 @@ obj-$(CONFIG_SENSORS_ADM1026)    += adm1026
 obj-$(CONFIG_SENSORS_ADM1029)    += adm1029.o
 obj-$(CONFIG_SENSORS_ADM1031)    += adm1031.o
 obj-$(CONFIG_SENSORS_ADM9240)    += adm9240.o
+obj-$(CONFIG_SENSORS_ADS7828)    += ads7828.o
 obj-$(CONFIG_SENSORS_APPLESMC)    += applesmc.o
 obj-$(CONFIG_SENSORS_AMS)    += ams/
 obj-$(CONFIG_SENSORS_ATXP1)    += atxp1.o
diff -uprN -X linux-2.6.23.9/Documentation/dontdiff 
linux-2.6.23.9/drivers/hwmon/ads7828.c 
linux-2.6.23.9-ads7828/drivers/hwmon/ads7828.c
--- linux-2.6.23.9/drivers/hwmon/ads7828.c    1970-01-01 
01:00:00.000000000 +0100
+++ linux-2.6.23.9-ads7828/drivers/hwmon/ads7828.c    2007-11-28 
10:02:02.000000000 +0000
@@ -0,0 +1,304 @@
+/*
+    ads7828.c - lm_sensors driver for ads7828 12bit 8ch ADC
+    (C) 2007 EADS Astrium
+
+    This driver is based on the lm75 and other lm_sensors/hwmon drivers
+
+    Written by Steve Hardy <steve@linuxrealtime.co.uk>
+
+    Datasheet available at : http://focus.ti.com/lit/ds/symlink/ads7828.pdf
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+
+/* Addresses to scan */
+static unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
+    I2C_CLIENT_END };
+
+/* Insmod parameters */
+I2C_CLIENT_INSMOD_1(ads7828);
+
+/* The ADS7828 registers */
+#define ADS7828_NCH 8 /* 8 channels of 12bit A-D supported */
+#define ADS7828_CMD_SD_SE 0x80 /* Single ended inputs */
+#define ADS7828_CMD_SD_DIFF 0x00 /* Differential inputs */
+#define ADS7828_CMD_PD0 0x0 /* Power Down between A-D conversions */
+#define ADS7828_CMD_PD1 0x04 /* Internal ref OFF && A-D ON */
+#define ADS7828_CMD_PD2 0x08 /* Internal ref ON && A-D OFF */
+#define ADS7828_CMD_PD3 0x0C /* Internal ref ON && A-D ON */
+#define ADS7828_INT_VREF 2500 /* Internal vref is 2.5v, 2500mV */
+
+/* module parameters */
+static int ads7828_se_input = 1; /* Default is SE, 0 == diff */
+static int ads7828_int_vref = 1; /* Default is internal ref ON */
+static int ads7828_vref = ADS7828_INT_VREF; /* set if vref != 2.5v */
+module_param(ads7828_se_input, bool, S_IRUGO);
+module_param(ads7828_int_vref, bool, S_IRUGO);
+module_param(ads7828_vref, int, S_IRUGO);
+
+static u8 ads7828_cmd_byte; /* cmd byte without channel bits */
+static unsigned int ads7828_lsb_resol; /* resolution of the ADC sample 
lsb */
+
+/* Each client has this additional data */
+struct ads7828_data {
+    struct i2c_client client;
+    struct class_device *class_dev;
+    struct mutex update_lock; /* mutex protect updates */
+    char valid; /* !=0 if following fields are valid */
+    unsigned long last_updated; /* In jiffies */
+    u16 adc_input[ADS7828_NCH]; /* ADS7828_NCH 12bit samples */
+};
+
+static int ads7828_attach_adapter(struct i2c_adapter *adapter);
+static int ads7828_detect(struct i2c_adapter *adapter, int address, int 
kind);
+static void ads7828_init_client(struct i2c_client *client);
+static int ads7828_detach_client(struct i2c_client *client);
+static struct ads7828_data *ads7828_update_device(struct device *dev);
+static u16 ads7828_read_value(struct i2c_client *client, u8 reg);
+
+/* This is the driver that will be inserted */
+static struct i2c_driver ads7828_driver = {
+    .driver = {
+        .name = "ads7828",
+    },
+    .id = I2C_DRIVERID_ADS7828,
+    .attach_adapter = ads7828_attach_adapter,
+    .detach_client = ads7828_detach_client,
+};
+
+static ssize_t show_in(struct device *dev, struct device_attribute *da,
+    char *buf)
+{
+    struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
+    struct ads7828_data *data = ads7828_update_device(dev);
+    /* Print value (in mv as specified in sysctl-interface 
documentation) */
+    return sprintf(buf, "%d\n", (data->adc_input[attr->index] *
+        ads7828_lsb_resol)/1000);
+}
+
+#define in_reg(offset)\
+static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in,\
+    NULL, offset);
+
+in_reg(0);
+in_reg(1);
+in_reg(2);
+in_reg(3);
+in_reg(4);
+in_reg(5);
+in_reg(6);
+in_reg(7);
+
+static int ads7828_attach_adapter(struct i2c_adapter *adapter)
+{
+    if (!(adapter->class & I2C_CLASS_HWMON))
+        return 0;
+    return i2c_probe(adapter, &addr_data, ads7828_detect);
+}
+
+static struct attribute *ads7828_attributes[] = {
+    &sensor_dev_attr_in0_input.dev_attr.attr,
+    &sensor_dev_attr_in1_input.dev_attr.attr,
+    &sensor_dev_attr_in2_input.dev_attr.attr,
+    &sensor_dev_attr_in3_input.dev_attr.attr,
+    &sensor_dev_attr_in4_input.dev_attr.attr,
+    &sensor_dev_attr_in5_input.dev_attr.attr,
+    &sensor_dev_attr_in6_input.dev_attr.attr,
+    &sensor_dev_attr_in7_input.dev_attr.attr,
+    NULL
+};
+
+static const struct attribute_group ads7828_group = {
+    .attrs = ads7828_attributes,
+};
+
+/* This function is called by i2c_detect */
+static int ads7828_detect(struct i2c_adapter *adapter, int address, int 
kind)
+{
+    struct i2c_client *new_client;
+    struct ads7828_data *data;
+    int err = 0, ch = 0;
+    const char *name = "";
+    u8 cmd;
+    u16 in_data;
+
+    /* Check we have a valid client */
+    if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+                         I2C_FUNC_SMBUS_WORD_DATA))
+        goto exit;
+
+    /* OK. For now, we presume we have a valid client. We now create the
+         client structure, even though we cannot fill it completely yet.
+         But it allows us to access ads7828_read_value. */
+    data = kmalloc(sizeof(struct ads7828_data), GFP_KERNEL);
+    if (!data)
+        err = -ENOMEM;
+        goto exit;
+    }
+    memset(data, 0, sizeof(struct ads7828_data));
+
+    new_client = &data->client;
+    i2c_set_clientdata(new_client, data);
+    new_client->addr = address;
+    new_client->adapter = adapter;
+    new_client->driver = &ads7828_driver;
+    new_client->flags = 0;
+
+    /* Perform local initialisation */
+    ads7828_init_client(new_client);
+
+    /* Now, we do the remaining detection. There is no identification
+    dedicated register so attempt to sanity check using knowledge of 
the chip
+    - Read from the 8 channel addresses
+    - Check the top 4 bits of each result are not set (12 data bits)
+    */
+    if (kind < 0) {
+        for (ch = 0; ch < ADS7828_NCH; ch++) {
+            /* cmd byte C2,C1,C0 - see datasheet */
+            cmd = (((ch>>1) | (ch&0x01)<<2)<<4);
+            cmd |= ads7828_cmd_byte;
+            in_data = ads7828_read_value(new_client, cmd);
+            if (in_data & 0xF000) {
+                printk(KERN_DEBUG
+                "%s : Doesn't look like an ads7828 device\n",
+                __FUNCTION__);
+                goto exit_free;
+            }
+        }
+    }
+
+    /* Determine the chip type - only one kind supported! */
+    if (kind <= 0)
+        kind = ads7828;
+
+    if (kind == ads7828)
+        name = "ads7828";
+
+    /* Fill in the remaining client fields, put it into the global list */
+    strlcpy(new_client->name, name, I2C_NAME_SIZE);
+    data->valid = 0;
+    mutex_init(&data->update_lock);
+
+    /* Tell the I2C layer a new client has arrived */
+    err = i2c_attach_client(new_client);
+    if (err)
+        goto exit_free;
+
+    /* Register sysfs hooks */
+    err = sysfs_create_group(&new_client->dev.kobj, &ads7828_group);
+    if (err)
+        goto exit_detach;
+
+    data->class_dev = hwmon_device_register(&new_client->dev);
+    if (IS_ERR(data->class_dev)) {
+        err = PTR_ERR(data->class_dev);
+        goto exit_remove;
+    }
+
+    return 0;
+
+exit_remove:
+    sysfs_remove_group(&new_client->dev.kobj, &ads7828_group);
+exit_detach:
+    i2c_detach_client(new_client);
+exit_free:
+    kfree(data);
+exit:
+    return err;
+}
+
+static int ads7828_detach_client(struct i2c_client *client)
+{
+    struct ads7828_data *data = i2c_get_clientdata(client);
+    hwmon_device_unregister(data->class_dev);
+    sysfs_remove_group(&client->dev.kobj, &ads7828_group);
+    i2c_detach_client(client);
+    kfree(i2c_get_clientdata(client));
+    return 0;
+}
+
+/* The ADS7828 returns the 12bit sample in two bytes,
+    these are read as a word then byte-swapped */
+static u16 ads7828_read_value(struct i2c_client *client, u8 reg)
+{
+    u16 buffer = i2c_smbus_read_word_data(client, reg);
+    return ((buffer&0xFF)<<8) | ((buffer&0xFF00)>>8);
+}
+
+static void ads7828_init_client(struct i2c_client *client)
+{
+    /* Initialise the command byte according to module parameters */
+    ads7828_cmd_byte = ads7828_se_input ?
+        ADS7828_CMD_SD_SE : ADS7828_CMD_SD_DIFF;
+    ads7828_cmd_byte |= ads7828_int_vref ?
+        ADS7828_CMD_PD3 : ADS7828_CMD_PD1;
+
+    /* Calculate the LSB resolution */
+    ads7828_lsb_resol = (ads7828_vref*1000)/4096;
+}
+
+static struct ads7828_data *ads7828_update_device(struct device *dev)
+{
+    struct i2c_client *client = to_i2c_client(dev);
+    struct ads7828_data *data = i2c_get_clientdata(client);
+    unsigned int cmd, ch;
+
+    mutex_lock(&data->update_lock); /* LOCK */
+
+    if (time_after(jiffies, data->last_updated + HZ + HZ / 2)
+            || !data->valid) {
+        dev_dbg(&client->dev, "Starting ads7828 update\n");
+
+        for (ch = 0; ch < ADS7828_NCH; ch++) {
+            /* cmd byte C2,C1,C0 - see datasheet */
+            cmd = (((ch>>1) | (ch&0x01)<<2)<<4);
+            cmd |= ads7828_cmd_byte;
+            data->adc_input[ch] = ads7828_read_value(client, cmd);
+        }
+        data->last_updated = jiffies;
+        data->valid = 1;
+    }
+
+    mutex_unlock(&data->update_lock); /* UNLOCK */
+
+    return data;
+}
+
+static int __init sensors_ads7828_init(void)
+{
+    return i2c_add_driver(&ads7828_driver);
+}
+
+static void __exit sensors_ads7828_exit(void)
+{
+    i2c_del_driver(&ads7828_driver);
+}
+
+MODULE_AUTHOR("Steve Hardy <steve@linuxrealtime.co.uk");
+MODULE_DESCRIPTION("ADS7828 driver");
+MODULE_LICENSE("GPL");
+
+module_init(sensors_ads7828_init);
+module_exit(sensors_ads7828_exit);
diff -uprN -X linux-2.6.23.9/Documentation/dontdiff 
linux-2.6.23.9/include/linux/i2c-id.h 
linux-2.6.23.9-ads7828/include/linux/i2c-id.h
--- linux-2.6.23.9/include/linux/i2c-id.h    2007-11-26 
17:51:43.000000000 +0000
+++ linux-2.6.23.9-ads7828/include/linux/i2c-id.h    2007-11-28 
10:02:02.000000000 +0000
@@ -161,6 +161,7 @@
 #define I2C_DRIVERID_FSCHER 1046
 #define I2C_DRIVERID_W83L785TS 1047
 #define I2C_DRIVERID_OV7670 1048    /* Omnivision 7670 camera */
+#define I2C_DRIVERID_ADS7828 1049
 
 /*
  * ---- Adapter types ----------------------------------------------------
