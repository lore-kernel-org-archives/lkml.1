Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYFHV0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYFHV0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYFHV0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:26:38 -0400
Received: from panic.vm.bytemark.co.uk ([80.68.89.222]:51414 "EHLO
	panic.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbYFHV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:26:37 -0400
X-Greylist: delayed 2205 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 17:26:36 EDT
Date: Sun, 8 Jun 2008 21:49:48 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fujitsu U810 keyboard light support
Message-ID: <20080608204948.GA22405@panic.cs-bristol.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Julian Brown <jules@panic.cs-bristol.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This patch contains support for the Fujitsu U810 mini-laptops'
keyboard-illuminating "headlights". Information on how to control these
was reverse-engineered from the ACPI DSDT and from disassembling the
Windows driver for the device (i.e. it's not 100% certain that this
patch won't make your laptop explode, but it works for me. A more likely
problem is that I might have broken support for other Fujitsu laptops,
but I can't test that).

The patched fujitsu-laptop module creates two entities in the /sys
hierarchy:

  /sys/devices/platform/fujitsu-laptop/kbd_light
  /sys/class/leds/kbd_light/*

So that then, the lights can be controlled by reading/writing to these
files. (Probably not all the LED class things are relevant, though).

The fujitsu-laptop module before patching only uses the FUJ02B1 ACPI "HID"
(namespace? Identifier?), but the keyboard LEDs (as well as several other
possibly-interesting things) hang off the FUJ02E3 ("FEXT") HID. I'm not
sure if adding the latter to the existing driver (vs. creating a new one)
was the right thing to do, but I think it's probably sensible.

Any comments/suggestions?

Thanks,

Julian

(Please CC me on replies.)

--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="fujitsu-laptop-fuj02e3-support-2.diff"

--- linux-2.6-2.6.25/drivers/misc/fujitsu-laptop.c	2008-04-17 03:49:44.000000000 +0100
+++ ../linux-2.6-2.6.25-patched/drivers/misc/fujitsu-laptop.c	2008-06-04 22:36:22.000000000 +0100
@@ -49,9 +49,10 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/backlight.h>
+#include <linux/leds.h>
 #include <linux/platform_device.h>
 
-#define FUJITSU_DRIVER_VERSION "0.3"
+#define FUJITSU_DRIVER_VERSION "0.3E"
 
 #define FUJITSU_LCD_N_LEVELS 8
 
@@ -60,6 +61,10 @@
 #define ACPI_FUJITSU_DRIVER_NAME        "Fujitsu laptop FUJ02B1 ACPI extras driver"
 #define ACPI_FUJITSU_DEVICE_NAME        "Fujitsu FUJ02B1"
 
+#define ACPI_FUJITSU_EXT_HID		"FUJ02E3"
+#define ACPI_FUJITSU_EXT_DRIVER_NAME	"Fujitsu laptop FUJ02E3 ACPI extras driver"
+#define ACPI_FUJITSU_EXT_DEVICE_NAME    "Fujitsu FUJ02E3"
+
 struct fujitsu_t {
 	acpi_handle acpi_handle;
 	struct backlight_device *bl_device;
@@ -68,6 +73,10 @@ struct fujitsu_t {
 	unsigned long fuj02b1_state;
 	unsigned int brightness_changed;
 	unsigned int brightness_level;
+
+	acpi_handle acpi_ext_handle;
+	unsigned long fuj02e3_state;
+	int using_fuj02e3;
 };
 
 static struct fujitsu_t *fujitsu;
@@ -141,6 +150,72 @@ static struct backlight_ops fujitsubl_op
 	.update_status = bl_update_status,
 };
 
+/* Keyboard illumination stuff.  */
+
+static int call_fuj02e3_func(int cmd, int a0, int a1, int a2)
+{
+	acpi_status status = AE_OK;
+	union acpi_object params[4] = {
+		{ .type = ACPI_TYPE_INTEGER },
+		{ .type = ACPI_TYPE_INTEGER },
+		{ .type = ACPI_TYPE_INTEGER },
+		{ .type = ACPI_TYPE_INTEGER }
+	};
+	struct acpi_object_list arg_list = { 4, &params[0] };
+	struct acpi_buffer output;
+	union acpi_object out_obj;
+	acpi_handle handle = NULL;
+	
+	if (!fujitsu->acpi_ext_handle)
+		return -ENODEV;
+	
+	status = acpi_get_handle(fujitsu->acpi_ext_handle, "FUNC", &handle);
+	if (ACPI_FAILURE(status)) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "FUNC not present\n"));
+		return -ENODEV;
+	}
+	
+	params[0].integer.value = cmd;
+	params[1].integer.value = a0;
+	params[2].integer.value = a1;
+	params[3].integer.value = a2;
+	
+	output.length = sizeof(out_obj);
+	output.pointer = &out_obj;
+	
+	status = acpi_evaluate_object(handle, NULL, &arg_list, &output);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+	
+	if (out_obj.type != ACPI_TYPE_INTEGER)
+		return -ENODEV;
+	
+	return out_obj.integer.value;
+}
+
+static int set_kbd_light(int level)
+{
+	int led_info = call_fuj02e3_func(0x1001, 0, 0, 0);
+	return call_fuj02e3_func(0x1001, 1, led_info, (level << 16) | 3);
+}
+
+static int get_kbd_light(void)
+{
+	int led_info = call_fuj02e3_func(0x1001, 0, 0, 0);
+	return (call_fuj02e3_func(0x1001, 2, led_info, 0) >> 16) & 3;
+}
+
+static void kbd_brightness_set(struct led_classdev *cdev,
+			       enum led_brightness brightness)
+{
+	set_kbd_light((brightness > 127) ? 3 : 0);
+}
+
+struct led_classdev led_device = {
+	.name = "kbd_light",
+	.brightness_set = kbd_brightness_set
+};
+
 /* Platform device */
 
 static ssize_t show_lcd_level(struct device *dev,
@@ -174,10 +249,39 @@ static ssize_t store_lcd_level(struct de
 	return count;
 }
 
+static ssize_t show_kbd_light(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	int ret;
+	ret = get_kbd_light();
+	if (ret < 0)
+		return ret;
+	
+	return sprintf(buf, "%i\n", ret);
+}
+
+static ssize_t store_kbd_light(struct device *dev,
+			       struct device_attribute *attr, const char *buf,
+			       size_t count)
+{
+	int level, ret;
+	
+	if (sscanf(buf, "%i", &level) != 1)
+		return -EINVAL;
+
+	ret = set_kbd_light(level);
+	if (ret < 0)
+		return ret;
+	
+	return count;
+}
+
 static DEVICE_ATTR(lcd_level, 0644, show_lcd_level, store_lcd_level);
+static DEVICE_ATTR(kbd_light, 0644, show_kbd_light, store_kbd_light);
 
 static struct attribute *fujitsupf_attributes[] = {
 	&dev_attr_lcd_level.attr,
+	&dev_attr_kbd_light.attr,
 	NULL
 };
 
@@ -236,6 +340,48 @@ static int acpi_fujitsu_remove(struct ac
 	return 0;
 }
 
+static int acpi_fujitsu_ext_add(struct acpi_device *device)
+{
+	int result = 0;
+	int state = 0;
+
+	ACPI_FUNCTION_TRACE("acpi_fujitsu_ext_add");
+
+	if (!device)
+		return -EINVAL;
+
+	fujitsu->acpi_ext_handle = device->handle;
+	sprintf(acpi_device_name(device), "%s", ACPI_FUJITSU_EXT_DEVICE_NAME);
+	sprintf(acpi_device_class(device), "%s", ACPI_FUJITSU_CLASS);
+	acpi_driver_data(device) = fujitsu;
+
+	result = acpi_bus_get_power(fujitsu->acpi_ext_handle, &state);
+	if (result) {
+		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
+				  "Error reading power state\n"));
+		goto end;
+	}
+
+	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
+	       acpi_device_name(device), acpi_device_bid(device),
+	       !device->power.state ? "on" : "off");
+
+      end:
+
+	return result;
+}
+
+static int acpi_fujitsu_ext_remove(struct acpi_device *device, int type)
+{
+	ACPI_FUNCTION_TRACE("acpi_fujitsu_ext_remove");
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+	fujitsu->acpi_ext_handle = NULL;
+
+	return 0;
+}
+
 static const struct acpi_device_id fujitsu_device_ids[] = {
 	{ACPI_FUJITSU_HID, 0},
 	{"", 0},
@@ -251,6 +397,21 @@ static struct acpi_driver acpi_fujitsu_d
 		},
 };
 
+static const struct acpi_device_id fujitsu_ext_device_ids[] = {
+	{ACPI_FUJITSU_EXT_HID, 0},
+	{"", 0},
+};
+
+static struct acpi_driver acpi_fujitsu_ext_driver = {
+	.name = ACPI_FUJITSU_EXT_DRIVER_NAME,
+	.class = ACPI_FUJITSU_CLASS,
+	.ids = fujitsu_ext_device_ids,
+	.ops = {
+		.add = acpi_fujitsu_ext_add,
+		.remove = acpi_fujitsu_ext_remove
+	}
+};
+
 /* Initialization */
 
 static int __init fujitsu_init(void)
@@ -271,6 +432,18 @@ static int __init fujitsu_init(void)
 		goto fail_acpi;
 	}
 
+	result = acpi_bus_register_driver(&acpi_fujitsu_ext_driver);
+	if (result < 0) {
+		/* We want the FUJ02B1 driver to work by itself, so don't
+		   fail here.  */
+		printk(KERN_INFO "fujitsu-laptop: not using FUJ02E3 "
+		       "extensions\n");
+		fujitsu->using_fuj02e3 = 0;
+	}
+	else {
+		fujitsu->using_fuj02e3 = 1;
+	}
+
 	/* Register backlight stuff */
 
 	fujitsu->bl_device =
@@ -296,6 +469,12 @@ static int __init fujitsu_init(void)
 	if (ret)
 		goto fail_platform_device1;
 
+	/* Register keyboard illumination stuff.  */
+	ret = led_classdev_register(&fujitsu->pf_device->dev, &led_device);
+	if (ret)
+		printk(KERN_INFO "fujitsu-laptop: no keyboard illumination "
+		       "registered\n");
+
 	ret =
 	    sysfs_create_group(&fujitsu->pf_device->dev.kobj,
 			       &fujitsupf_attribute_group);
@@ -338,6 +517,12 @@ static void __exit fujitsu_cleanup(void)
 	platform_driver_unregister(&fujitsupf_driver);
 	backlight_device_unregister(fujitsu->bl_device);
 
+	if (fujitsu->using_fuj02e3) {
+		led_classdev_unregister(&led_device);
+		acpi_bus_unregister_driver(&acpi_fujitsu_ext_driver);
+		fujitsu->using_fuj02e3 = 0;
+	}
+
 	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
 
 	kfree(fujitsu);

--u3/rZRmxL6MmkK24--
