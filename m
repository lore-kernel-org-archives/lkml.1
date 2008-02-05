Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYBERil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYBERil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbYBERi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:38:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:31742 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbYBERi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:38:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=XwJRSCYdQDd7wgQOHGlH23KGn1K/cBGflDI8WWIR69Sas4RjBucjPhs3Cy4H7KbNbAgVEhPwvFkXe2HqcNZRgHo/QbbzjvciMHLTu4zOp+2E/JJkXz1hjqiVBx6+4KSOHeqB3LUoNA5NgMQ2jlvh3quzYtW0vMSoBncfwXfsbKo=
Date: Tue, 5 Feb 2008 18:38:20 +0100
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org
Subject: [PATH] misc,acpi,backlight: Compal Laptop Extras (2nd try)
Message-ID: <20080205183820.65dcf111@debian>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

This is driver for Compal Laptop: FL90/IFL90, based on MSI
driver.

This driver exports a few files in /sys/devices/platform/compal-laptop/:
 lcd_level - screen brightness: contains a single integer in the range 0..7 (rw)
 wlan - wlan subsystem state: contains 0 or 1 (rw)
 bluetooth - bluetooth subsystem state: contains 0 or 1 (rw)
 raw - raw value taken from embedded controller register (ro)

In addition to these platform device attributes the driver registers itself
in the Linux backlight control subsystem and is available to userspace under
/sys/class/backlight/compal-laptop/.

Based on 2.6.24

Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
diff -uprN a/drivers/misc/compal-laptop.c b/drivers/misc/compal-laptop.c
--- a/drivers/misc/compal-laptop.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/misc/compal-laptop.c	2008-02-05 18:10:00.000000000 +0100
@@ -0,0 +1,415 @@
+/*-*-linux-c-*-*/
+
+/*
+  Copyright (C) 2008 Cezary Jackiewicz <cezary.Jackiewicz (at) gmail.com>
+
+  based on MSI driver
+
+  Copyright (C) 2006 Lennart Poettering <mzxreary (at) 0pointer (dot) de>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+  02110-1301, USA.
+ */
+
+/*
+ * comapl-laptop.c - Compal FL90/IFL90 laptop support.
+ *
+ * This driver exports a few files in /sys/devices/platform/compal-laptop/:
+ *
+ *   lcd_level - Screen brightness: contains a single integer in the
+ *   range 0..7. (rw)
+ *
+ *   wlan - wlan subsystem state: contains 0 or 1 (rw)
+ *
+ *   bluetooth - Bluetooth subsystem state: contains 0 or 1 (rw)
+ *
+ *   raw - raw value taken from embedded controller register (ro)
+ *
+ * In addition to these platform device attributes the driver
+ * registers itself in the Linux backlight control subsystem and is
+ * available to userspace under /sys/class/backlight/compal-laptop/.
+ *
+ * This driver might work on other laptops produced by Compal. If you
+ * want to try it you can pass force=1 as argument to the module which
+ * will force it to load even when the DMI data doesn't identify the
+ * laptop as IFL90.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/dmi.h>
+#include <linux/backlight.h>
+#include <linux/platform_device.h>
+#include <linux/autoconf.h>
+
+#define COMPAL_DRIVER_VERSION "0.2.2"
+
+#define COMPAL_LCD_LEVEL_MAX 8
+
+#define COMPAL_EC_COMMAND_WIRELESS 0xBB
+#define COMPAL_EC_COMMAND_LCD_LEVEL 0xB9
+
+static int force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
+
+/* Hardware access */
+
+static int set_lcd_level(int level)
+{
+	if (level < 0 || level >= COMPAL_LCD_LEVEL_MAX)
+		return -EINVAL;
+
+	ec_write(COMPAL_EC_COMMAND_LCD_LEVEL, level);
+
+	return 0;
+}
+
+static int get_lcd_level(void)
+{
+	u8 result;
+
+	ec_read(COMPAL_EC_COMMAND_LCD_LEVEL, &result);
+
+	return (int) result;
+}
+
+static int set_wlan_state(int state)
+{
+	u8 result, value;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	if ((result & 0x10) == 0)
+		return -EINVAL;
+	else {
+	    if (state)
+		value = (u8) (result | 0x01);
+	    else
+		value = (u8) (result & 0xFE);
+	    ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+	}
+
+	return 0;
+}
+
+static int set_bluetooth_state(int state)
+{
+	u8 result, value;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	if ((result & 0x10) == 0)
+		return -EINVAL;
+	else {
+	    if (state)
+		value = (u8) (result | 0x02);
+	    else
+		value = (u8) (result & 0xFD);
+	    ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+	}
+
+	return 0;
+}
+
+static int get_wireless_state(int *wlan, int *bluetooth)
+{
+	u8 result;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	if (wlan) {
+	    if ((result & 0x10) == 0)
+		*wlan = 0;
+	    else
+		*wlan = result & 0x01;
+	}
+
+	if (bluetooth) {
+	    if ((result & 0x10) == 0)
+		*bluetooth = 0;
+	    else
+		*bluetooth = (result >> 1) & 0x01;
+	}
+
+	return 0;
+}
+
+/* Backlight device stuff */
+
+static int bl_get_brightness(struct backlight_device *b)
+{
+	return get_lcd_level();
+}
+
+
+static int bl_update_status(struct backlight_device *b)
+{
+	return set_lcd_level(b->props.brightness);
+}
+
+static struct backlight_ops compalbl_ops = {
+	.get_brightness = bl_get_brightness,
+	.update_status  = bl_update_status,
+};
+
+static struct backlight_device *compalbl_device;
+
+/* Platform device */
+
+static ssize_t show_wlan(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+
+	int ret, enabled;
+
+	ret = get_wireless_state(&enabled, NULL);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%i\n", enabled);
+}
+
+static ssize_t show_raw(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	u8 result;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	return sprintf(buf, "%i\n", result);
+}
+
+static ssize_t show_bluetooth(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+
+	int ret, enabled;
+
+	ret = get_wireless_state(NULL, &enabled);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%i\n", enabled);
+}
+
+static ssize_t show_lcd_level(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+
+	int ret;
+
+	ret = get_lcd_level();
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%i\n", ret);
+}
+
+static ssize_t store_lcd_level(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+
+	int level, ret;
+
+	if (sscanf(buf, "%i", &level) != 1 ||
+	    (level < 0 || level >= COMPAL_LCD_LEVEL_MAX))
+		return -EINVAL;
+
+	ret = set_lcd_level(level);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t store_wlan_state(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+
+	int state, ret;
+
+	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
+		return -EINVAL;
+
+	ret = set_wlan_state(state);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t store_bluetooth_state(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+
+	int state, ret;
+
+	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
+		return -EINVAL;
+
+	ret = set_bluetooth_state(state);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(lcd_level, 0644, show_lcd_level, store_lcd_level);
+static DEVICE_ATTR(bluetooth, 0644, show_bluetooth, store_bluetooth_state);
+static DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan_state);
+static DEVICE_ATTR(raw, 0444, show_raw, NULL);
+
+static struct attribute *compal_attributes[] = {
+	&dev_attr_lcd_level.attr,
+	&dev_attr_bluetooth.attr,
+	&dev_attr_wlan.attr,
+	&dev_attr_raw.attr,
+	NULL
+};
+
+static struct attribute_group compal_attribute_group = {
+	.attrs = compal_attributes
+};
+
+static struct platform_driver compal_driver = {
+	.driver = {
+		.name = "compal-laptop",
+		.owner = THIS_MODULE,
+	}
+};
+
+static struct platform_device *compal_device;
+
+/* Initialization */
+
+static int dmi_check_cb(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
+	    id->ident);
+	return 0;
+}
+
+static struct dmi_system_id __initdata compal_dmi_table[] = {
+	{
+		.ident = "FL90/IFL90",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "IFL90"),
+			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "FL90/IFL90",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "IFL90"),
+			DMI_MATCH(DMI_BOARD_VERSION, "REFERENCE"),
+		},
+		.callback = dmi_check_cb
+	},
+	{ }
+};
+
+static int __init compal_init(void)
+{
+	int ret;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	if (!force && !dmi_check_system(compal_dmi_table))
+		return -ENODEV;
+
+	/* Register backlight stuff */
+
+	compalbl_device = backlight_device_register("compal-laptop", NULL, NULL,
+						&compalbl_ops);
+	if (IS_ERR(compalbl_device))
+		return PTR_ERR(compalbl_device);
+
+	compalbl_device->props.max_brightness = COMPAL_LCD_LEVEL_MAX-1;
+
+	ret = platform_driver_register(&compal_driver);
+	if (ret)
+		goto fail_backlight;
+
+	/* Register platform stuff */
+
+	compal_device = platform_device_alloc("compal-laptop", -1);
+	if (!compal_device) {
+		ret = -ENOMEM;
+		goto fail_platform_driver;
+	}
+
+	ret = platform_device_add(compal_device);
+	if (ret)
+		goto fail_platform_device1;
+
+	ret = sysfs_create_group(&compal_device->dev.kobj,
+	    &compal_attribute_group);
+	if (ret)
+		goto fail_platform_device2;
+
+	/* Disable automatic brightness control by default because
+	 * this module was probably loaded to do brightness control in
+	 * software. */
+
+	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
+	    " successfully loaded.\n");
+
+	return 0;
+
+fail_platform_device2:
+
+	platform_device_del(compal_device);
+
+fail_platform_device1:
+
+	platform_device_put(compal_device);
+
+fail_platform_driver:
+
+	platform_driver_unregister(&compal_driver);
+
+fail_backlight:
+
+	backlight_device_unregister(compalbl_device);
+
+	return ret;
+}
+
+static void __exit compal_cleanup(void)
+{
+
+	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
+	platform_device_unregister(compal_device);
+	platform_driver_unregister(&compal_driver);
+	backlight_device_unregister(compalbl_device);
+
+	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
+}
+
+module_init(compal_init);
+module_exit(compal_cleanup);
+
+MODULE_AUTHOR("Cezary Jackiewicz");
+MODULE_DESCRIPTION("Compal Laptop Support");
+MODULE_VERSION(COMPAL_DRIVER_VERSION);
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS("dmi:*:rnIFL90:rvrIFT00:*");
+MODULE_ALIAS("dmi:*:rnIFL90:rvrREFERENCE:*");
diff -uprN a/drivers/misc/Kconfig b/drivers/misc/Kconfig
--- a/drivers/misc/Kconfig	2008-01-24 23:58:37.000000000 +0100
+++ b/drivers/misc/Kconfig	2008-02-05 17:41:37.000000000 +0100
@@ -145,6 +145,20 @@ config MSI_LAPTOP
 
 	  If you have an MSI S270 laptop, say Y or M here.
 
+config COMPAL_LAPTOP
+        tristate "Compal Laptop Extras"
+        depends on X86
+        depends on ACPI_EC
+        depends on BACKLIGHT_CLASS_DEVICE
+        ---help---
+	  This is a driver for laptops built by Compal:
+
+	  Compal FL90/IFL90
+	  
+	  It adds support for Bluetooth, WLAN and LCD brightness control.
+
+	  If you have a Compal FL90/IFL90 laptop, say Y or M here.
+
 config SONY_LAPTOP
 	tristate "Sony Laptop Extras"
 	depends on X86 && ACPI
diff -uprN a/drivers/misc/Makefile b/drivers/misc/Makefile
--- a/drivers/misc/Makefile	2008-01-24 23:58:37.000000000 +0100
+++ b/drivers/misc/Makefile	2008-02-05 17:41:37.000000000 +0100
@@ -6,6 +6,7 @@ obj- := misc.o	# Dummy rule to force bui
 obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_MSI_LAPTOP)     += msi-laptop.o
+obj-$(CONFIG_COMPAL_LAPTOP)     += compal-laptop.o
 obj-$(CONFIG_ASUS_LAPTOP)     += asus-laptop.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
