Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0BBHwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:36 -0500
Received: from iksaif.net ([88.191.73.63]:50268 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 07/28] asus-laptop: change initialization order
Date: Tue,  2 Feb 2010 08:38:50 +0100
Message-Id: <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean asus-laptop initialization to match new eeepc-laptop code.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  369 ++++++++++++++++++------------------
 1 files changed, 180 insertions(+), 189 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 74463a0..8834405 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -201,6 +201,8 @@ ASUS_HANDLE(kled_get, ASUS_HOTK_PREFIX "GLKB");
  */
 struct asus_hotk {
 	char *name;		/* laptop name */
+
+	struct platform_device *platform_device;
 	struct acpi_device *device;	/* the device we are in */
 	acpi_handle handle;	/* the handle of the hotk device */
 	char status;		/* status of the hotk, for LEDs, ... */
@@ -222,33 +224,6 @@ static struct acpi_table_header *asus_info;
 /* The actual device the driver binds to */
 static struct asus_hotk *hotk;
 
-/*
- * The hotkey driver declaration
- */
-static const struct acpi_device_id asus_device_ids[] = {
-	{"ATK0100", 0},
-	{"ATK0101", 0},
-	{"", 0},
-};
-MODULE_DEVICE_TABLE(acpi, asus_device_ids);
-
-static int asus_hotk_add(struct acpi_device *device);
-static int asus_hotk_remove(struct acpi_device *device, int type);
-static void asus_hotk_notify(struct acpi_device *device, u32 event);
-
-static struct acpi_driver asus_hotk_driver = {
-	.name = ASUS_HOTK_NAME,
-	.class = ASUS_HOTK_CLASS,
-	.owner = THIS_MODULE,
-	.ids = asus_device_ids,
-	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
-	.ops = {
-		.add = asus_hotk_add,
-		.remove = asus_hotk_remove,
-		.notify = asus_hotk_notify,
-		},
-};
-
 /* The backlight device /sys/class/backlight */
 static struct backlight_device *asus_backlight_device;
 
@@ -936,7 +911,7 @@ static int asus_setkeycode(struct input_dev *dev, int scancode, int keycode)
 	return -EINVAL;
 }
 
-static void asus_hotk_notify(struct acpi_device *device, u32 event)
+static void asus_acpi_notify(struct acpi_device *device, u32 event)
 {
 	static struct key_entry *key;
 	u16 count;
@@ -1013,19 +988,49 @@ static struct attribute *asuspf_attributes[] = {
 	NULL
 };
 
-static struct attribute_group asuspf_attribute_group = {
+static struct attribute_group platform_attribute_group = {
 	.attrs = asuspf_attributes
 };
 
-static struct platform_driver asuspf_driver = {
+static int asus_platform_init(void)
+{
+	int result;
+
+	hotk->platform_device = platform_device_alloc(ASUS_HOTK_FILE, -1);
+	if (!hotk->platform_device)
+		return -ENOMEM;
+
+	result = platform_device_add(hotk->platform_device);
+	if (result)
+		goto fail_platform_device;
+
+	result = sysfs_create_group(&hotk->platform_device->dev.kobj,
+				    &platform_attribute_group);
+	if (result)
+		goto fail_sysfs;
+	return 0;
+
+fail_sysfs:
+	platform_device_del(hotk->platform_device);
+fail_platform_device:
+	platform_device_put(hotk->platform_device);
+	return result;
+}
+
+static void asus_platform_exit(void)
+{
+	sysfs_remove_group(&hotk->platform_device->dev.kobj,
+			   &platform_attribute_group);
+	platform_device_unregister(hotk->platform_device);
+}
+
+static struct platform_driver platform_driver = {
 	.driver = {
 		   .name = ASUS_HOTK_FILE,
 		   .owner = THIS_MODULE,
 		   }
 };
 
-static struct platform_device *asuspf_device;
-
 static void asus_hotk_add_fs(void)
 {
 	ASUS_SET_DEVICE_ATTR(infos, 0444, show_infos, NULL);
@@ -1196,7 +1201,7 @@ static int asus_hotk_get_info(void)
 	return AE_OK;
 }
 
-static int asus_input_init(void)
+static int asus_input_init(struct device *dev)
 {
 	const struct key_entry *key;
 	int result;
@@ -1207,6 +1212,7 @@ static int asus_input_init(void)
 		return 0;
 	}
 	hotk->inputdev->name = "Asus Laptop extra buttons";
+	hotk->inputdev->dev.parent = dev;
 	hotk->inputdev->phys = ASUS_HOTK_FILE "/input0";
 	hotk->inputdev->id.bustype = BUS_HOST;
 	hotk->inputdev->getkeycode = asus_getkeycode;
@@ -1228,101 +1234,6 @@ static int asus_input_init(void)
 	return result;
 }
 
-static int asus_hotk_check(void)
-{
-	int result = 0;
-
-	result = acpi_bus_get_status(hotk->device);
-	if (result)
-		return result;
-
-	if (hotk->device->status.present) {
-		result = asus_hotk_get_info();
-	} else {
-		pr_err("Hotkey device not present, aborting\n");
-		return -EINVAL;
-	}
-
-	return result;
-}
-
-static int asus_hotk_found;
-
-static int asus_hotk_add(struct acpi_device *device)
-{
-	int result;
-
-	pr_notice("Asus Laptop Support version %s\n",
-	       ASUS_LAPTOP_VERSION);
-
-	hotk = kzalloc(sizeof(struct asus_hotk), GFP_KERNEL);
-	if (!hotk)
-		return -ENOMEM;
-
-	hotk->handle = device->handle;
-	strcpy(acpi_device_name(device), ASUS_HOTK_DEVICE_NAME);
-	strcpy(acpi_device_class(device), ASUS_HOTK_CLASS);
-	device->driver_data = hotk;
-	hotk->device = device;
-
-	result = asus_hotk_check();
-	if (result)
-		goto end;
-
-	asus_hotk_add_fs();
-
-	asus_hotk_found = 1;
-
-	/* WLED and BLED are on by default */
-	if (bluetooth_status != -1)
-		write_status(bt_switch_handle, !!bluetooth_status, BT_ON);
-	if (wireless_status != -1)
-		write_status(wl_switch_handle, !!wireless_status, WL_ON);
-
-	/* If the h/w switch is off, we need to check the real status */
-	write_status(NULL, read_status(BT_ON), BT_ON);
-	write_status(NULL, read_status(WL_ON), WL_ON);
-
-	/* LCD Backlight is on by default */
-	write_status(NULL, 1, LCD_ON);
-
-	/* Keyboard Backlight is on by default */
-	if (kled_set_handle)
-		set_kled_lvl(1);
-
-	/* LED display is off by default */
-	hotk->ledd_status = 0xFFF;
-
-	/* Set initial values of light sensor and level */
-	hotk->light_switch = 0;	/* Default to light sensor disabled */
-	hotk->light_level = 5;	/* level 5 for sensor sensitivity */
-
-	if (ls_switch_handle)
-		set_light_sens_switch(hotk->light_switch);
-
-	if (ls_level_handle)
-		set_light_sens_level(hotk->light_level);
-
-	/* GPS is on by default */
-	write_status(NULL, 1, GPS_ON);
-
-end:
-	if (result) {
-		kfree(hotk->name);
-		kfree(hotk);
-	}
-
-	return result;
-}
-
-static int asus_hotk_remove(struct acpi_device *device, int type)
-{
-	kfree(hotk->name);
-	kfree(hotk);
-
-	return 0;
-}
-
 static void asus_backlight_exit(void)
 {
 	if (asus_backlight_device)
@@ -1350,18 +1261,6 @@ static void asus_input_exit(void)
 		input_unregister_device(hotk->inputdev);
 }
 
-static void __exit asus_laptop_exit(void)
-{
-	asus_backlight_exit();
-	asus_led_exit();
-	asus_input_exit();
-
-	acpi_bus_unregister_driver(&asus_hotk_driver);
-	sysfs_remove_group(&asuspf_device->dev.kobj, &asuspf_attribute_group);
-	platform_device_unregister(asuspf_device);
-	platform_driver_unregister(&asuspf_driver);
-}
-
 static int asus_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
@@ -1448,87 +1347,179 @@ out:
 	return rv;
 }
 
-static int __init asus_laptop_init(void)
+
+static bool asus_device_present;
+
+static int __devinit asus_acpi_init(struct acpi_device *device)
 {
-	int result;
+	int result = 0;
 
-	result = acpi_bus_register_driver(&asus_hotk_driver);
-	if (result < 0)
+	result = acpi_bus_get_status(hotk->device);
+	if (result)
 		return result;
-
-	/*
-	 * This is a bit of a kludge.  We only want this module loaded
-	 * for ASUS systems, but there's currently no way to probe the
-	 * ACPI namespace for ASUS HIDs.  So we just return failure if
-	 * we didn't find one, which will cause the module to be
-	 * unloaded.
-	 */
-	if (!asus_hotk_found) {
-		acpi_bus_unregister_driver(&asus_hotk_driver);
+	if (!hotk->device->status.present) {
+		pr_err("Hotkey device not present, aborting\n");
 		return -ENODEV;
 	}
 
-	result = asus_input_init();
+	result = asus_hotk_get_info();
 	if (result)
-		goto fail_input;
+		return result;
 
-	/* Register platform stuff */
-	result = platform_driver_register(&asuspf_driver);
-	if (result)
-		goto fail_platform_driver;
+	asus_hotk_add_fs();
 
-	asuspf_device = platform_device_alloc(ASUS_HOTK_FILE, -1);
-	if (!asuspf_device) {
-		result = -ENOMEM;
-		goto fail_platform_device1;
-	}
+	/* WLED and BLED are on by default */
+	write_status(bt_switch_handle, 1, BT_ON);
+	write_status(wl_switch_handle, 1, WL_ON);
 
-	result = platform_device_add(asuspf_device);
-	if (result)
-		goto fail_platform_device2;
+	/* If the h/w switch is off, we need to check the real status */
+	write_status(NULL, read_status(BT_ON), BT_ON);
+	write_status(NULL, read_status(WL_ON), WL_ON);
+
+	/* LCD Backlight is on by default */
+	write_status(NULL, 1, LCD_ON);
 
-	result = sysfs_create_group(&asuspf_device->dev.kobj,
-				    &asuspf_attribute_group);
+	/* Keyboard Backlight is on by default */
+	if (kled_set_handle)
+		set_kled_lvl(1);
+
+	/* LED display is off by default */
+	hotk->ledd_status = 0xFFF;
+
+	/* Set initial values of light sensor and level */
+	hotk->light_switch = 0;	/* Default to light sensor disabled */
+	hotk->light_level = 5;	/* level 5 for sensor sensitivity */
+
+	if (ls_switch_handle)
+		set_light_sens_switch(hotk->light_switch);
+
+	if (ls_level_handle)
+		set_light_sens_level(hotk->light_level);
+
+	/* GPS is on by default */
+	write_status(NULL, 1, GPS_ON);
+	return result;
+}
+
+static int __devinit asus_acpi_add(struct acpi_device *device)
+{
+	int result;
+
+	pr_notice("Asus Laptop Support version %s\n",
+		  ASUS_LAPTOP_VERSION);
+	hotk = kzalloc(sizeof(struct asus_hotk), GFP_KERNEL);
+	if (!hotk)
+		return -ENOMEM;
+	hotk->handle = device->handle;
+	strcpy(acpi_device_name(device), ASUS_HOTK_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ASUS_HOTK_CLASS);
+	device->driver_data = hotk;
+	hotk->device = device;
+
+	result = asus_acpi_init(device);
 	if (result)
-		goto fail_sysfs;
+		goto fail_platform;
 
-	result = asus_led_init(&asuspf_device->dev);
+	/*
+	 * Register the platform device first.  It is used as a parent for the
+	 * sub-devices below.
+	 */
+	result = asus_platform_init();
 	if (result)
-		goto fail_led;
+		goto fail_platform;
 
 	if (!acpi_video_backlight_support()) {
-		result = asus_backlight_init(&asuspf_device->dev);
+		result = asus_backlight_init(&hotk->platform_device->dev);
 		if (result)
 			goto fail_backlight;
 	} else
-		pr_info("Brightness ignored, must be controlled by "
-		       "ACPI video driver\n");
+		pr_info("Backlight controlled by ACPI video driver\n");
 
+	result = asus_input_init(&hotk->platform_device->dev);
+	if (result)
+		goto fail_input;
+
+	result = asus_led_init(&hotk->platform_device->dev);
+	if (result)
+		goto fail_led;
+
+	asus_device_present = true;
 	return 0;
 
+fail_led:
+	asus_input_exit();
+fail_input:
+	asus_backlight_exit();
 fail_backlight:
-       asus_led_exit();
+	asus_platform_exit();
+fail_platform:
+	kfree(hotk->name);
+	kfree(hotk);
 
-fail_led:
-       sysfs_remove_group(&asuspf_device->dev.kobj,
-			  &asuspf_attribute_group);
+	return result;
+}
 
-fail_sysfs:
-	platform_device_del(asuspf_device);
+static int asus_acpi_remove(struct acpi_device *device, int type)
+{
+	asus_backlight_exit();
+	asus_led_exit();
+	asus_input_exit();
+	asus_platform_exit();
+
+	kfree(hotk->name);
+	kfree(hotk);
+	return 0;
+}
+
+static const struct acpi_device_id asus_device_ids[] = {
+	{"ATK0100", 0},
+	{"ATK0101", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, asus_device_ids);
 
-fail_platform_device2:
-	platform_device_put(asuspf_device);
+static struct acpi_driver asus_acpi_driver = {
+	.name = ASUS_HOTK_NAME,
+	.class = ASUS_HOTK_CLASS,
+	.owner = THIS_MODULE,
+	.ids = asus_device_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = asus_acpi_add,
+		.remove = asus_acpi_remove,
+		.notify = asus_acpi_notify,
+		},
+};
 
-fail_platform_device1:
-	platform_driver_unregister(&asuspf_driver);
+static int __init asus_laptop_init(void)
+{
+	int result;
 
-fail_platform_driver:
-	asus_input_exit();
+	result = platform_driver_register(&platform_driver);
+	if (result < 0)
+		return result;
 
-fail_input:
+	result = acpi_bus_register_driver(&asus_acpi_driver);
+	if (result < 0)
+		goto fail_acpi_driver;
+	if (!asus_device_present) {
+		result = -ENODEV;
+		goto fail_no_device;
+	}
+	return 0;
 
+fail_no_device:
+	acpi_bus_unregister_driver(&asus_acpi_driver);
+fail_acpi_driver:
+	platform_driver_unregister(&platform_driver);
 	return result;
 }
 
+static void __exit asus_laptop_exit(void)
+{
+	acpi_bus_unregister_driver(&asus_acpi_driver);
+	platform_driver_unregister(&platform_driver);
+}
+
 module_init(asus_laptop_init);
 module_exit(asus_laptop_exit);
-- 
1.6.6.1

