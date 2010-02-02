Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0BBHwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:14 -0500
Received: from iksaif.net ([88.191.73.63]:50244 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab0BBHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 11/28] asus-laptop: code movement
Date: Tue,  2 Feb 2010 08:38:54 +0100
Message-Id: <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asus-laptop driver implements a number of interfaces like the
backlight class driver.  This change makes it easier to examine the
implementation of one interface at at a time, without having to search
through the file to find init() and exit() functions etc.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  440 ++++++++++++++++++------------------
 1 files changed, 223 insertions(+), 217 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 58a4864..940ce3d 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -58,36 +58,6 @@
 #define ASUS_LAPTOP_FILE	KBUILD_MODNAME
 #define ASUS_LAPTOP_PREFIX	"\\_SB.ATKD."
 
-
-/*
- * Some events we use, same for all Asus
- */
-#define ATKD_BR_UP	0x10
-#define ATKD_BR_DOWN	0x20
-#define ATKD_LCD_ON	0x33
-#define ATKD_LCD_OFF	0x34
-
-/*
- * Known bits returned by \_SB.ATKD.HWRS
- */
-#define WL_HWRS		0x80
-#define BT_HWRS		0x100
-
-/*
- * Flags for hotk status
- * WL_ON and BT_ON are also used for wireless_status()
- */
-#define WL_ON		0x01	/* internal Wifi */
-#define BT_ON		0x02	/* internal Bluetooth */
-#define MLED_ON		0x04	/* mail LED */
-#define TLED_ON		0x08	/* touchpad LED */
-#define RLED_ON		0x10	/* Record LED */
-#define PLED_ON		0x20	/* Phone LED */
-#define GLED_ON		0x40	/* Gaming LED */
-#define LCD_ON		0x80	/* LCD backlight */
-#define GPS_ON		0x100	/* GPS */
-#define KEY_ON		0x200	/* Keyboard backlight */
-
 MODULE_AUTHOR("Julien Lerouge, Karol Kozimor, Corentin Chary");
 MODULE_DESCRIPTION(ASUS_LAPTOP_NAME);
 MODULE_LICENSE("GPL");
@@ -119,6 +89,35 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
 
+/*
+ * Some events we use, same for all Asus
+ */
+#define ATKD_BR_UP	0x10
+#define ATKD_BR_DOWN	0x20
+#define ATKD_LCD_ON	0x33
+#define ATKD_LCD_OFF	0x34
+
+/*
+ * Known bits returned by \_SB.ATKD.HWRS
+ */
+#define WL_HWRS		0x80
+#define BT_HWRS		0x100
+
+/*
+ * Flags for hotk status
+ * WL_ON and BT_ON are also used for wireless_status()
+ */
+#define WL_ON		0x01	/* internal Wifi */
+#define BT_ON		0x02	/* internal Bluetooth */
+#define MLED_ON		0x04	/* mail LED */
+#define TLED_ON		0x08	/* touchpad LED */
+#define RLED_ON		0x10	/* Record LED */
+#define PLED_ON		0x20	/* Phone LED */
+#define GLED_ON		0x40	/* Gaming LED */
+#define LCD_ON		0x80	/* LCD backlight */
+#define GPS_ON		0x100	/* GPS */
+#define KEY_ON		0x200	/* Keyboard backlight */
+
 #define ASUS_HANDLE(object, paths...)					\
 	static acpi_handle  object##_handle = NULL;			\
 	static char *object##_paths[] = { paths }
@@ -249,36 +248,6 @@ struct asus_laptop {
 	u16 *keycode_map;
 };
 
-/*
- * The backlight class declaration
- */
-static int read_brightness(struct backlight_device *bd);
-static int update_bl_status(struct backlight_device *bd);
-static struct backlight_ops asusbl_ops = {
-	.get_brightness = read_brightness,
-	.update_status = update_bl_status,
-};
-
-#define ASUS_LED(object, ledname, max)					\
-	static void object##_led_set(struct led_classdev *led_cdev,	\
-				     enum led_brightness value);	\
-	static enum led_brightness object##_led_get(			\
-		struct led_classdev *led_cdev);				\
-	static void object##_led_update(struct work_struct *ignored);	\
-	static struct led_classdev object##_led = {			\
-		.name           = "asus::" ledname,			\
-		.brightness_set = object##_led_set,			\
-		.brightness_get = object##_led_get,			\
-		.max_brightness = max					\
-	}
-
-ASUS_LED(mled, "mail", 1);
-ASUS_LED(tled, "touchpad", 1);
-ASUS_LED(rled, "record", 1);
-ASUS_LED(pled, "phone", 1);
-ASUS_LED(gled, "gaming", 1);
-ASUS_LED(kled, "kbd_backlight", 3);
-
 struct key_entry {
 	char type;
 	u8 code;
@@ -427,6 +396,29 @@ static void write_status(struct asus_laptop *asus, acpi_handle handle,
 		pr_warning(" write failed %x\n", mask);
 }
 
+/*
+ * LEDs
+ */
+#define ASUS_LED(object, ledname, max)					\
+	static void object##_led_set(struct led_classdev *led_cdev,	\
+				     enum led_brightness value);	\
+	static enum led_brightness object##_led_get(			\
+		struct led_classdev *led_cdev);				\
+	static void object##_led_update(struct work_struct *ignored);	\
+	static struct led_classdev object##_led = {			\
+		.name           = "asus::" ledname,			\
+		.brightness_set = object##_led_set,			\
+		.brightness_get = object##_led_get,			\
+		.max_brightness = max					\
+	}
+
+ASUS_LED(mled, "mail", 1);
+ASUS_LED(tled, "touchpad", 1);
+ASUS_LED(rled, "record", 1);
+ASUS_LED(pled, "phone", 1);
+ASUS_LED(gled, "gaming", 1);
+ASUS_LED(kled, "kbd_backlight", 3);
+
 /* /sys/class/led handlers */
 #define ASUS_LED_HANDLER(object, mask)					\
 	static void object##_led_set(struct led_classdev *led_cdev,	\
@@ -459,7 +451,7 @@ ASUS_LED_HANDLER(tled, TLED_ON);
 ASUS_LED_HANDLER(gled, GLED_ON);
 
 /*
- * Keyboard backlight
+ * Keyboard backlight (also a LED)
  */
 static int get_kled_lvl(void)
 {
@@ -516,6 +508,70 @@ static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
 	return get_kled_lvl();
 }
 
+#define ASUS_LED_UNREGISTER(object)				\
+	if (object##_led.dev)					\
+		led_classdev_unregister(&object##_led)
+
+static void asus_led_exit(struct asus_laptop *asus)
+{
+	ASUS_LED_UNREGISTER(mled);
+	ASUS_LED_UNREGISTER(tled);
+	ASUS_LED_UNREGISTER(pled);
+	ASUS_LED_UNREGISTER(rled);
+	ASUS_LED_UNREGISTER(gled);
+	ASUS_LED_UNREGISTER(kled);
+	if (asus->leds.workqueue) {
+		destroy_workqueue(asus->leds.workqueue);
+		asus->leds.workqueue = NULL;
+	}
+}
+
+/*  Ugly macro, need to fix that later */
+#define ASUS_LED_REGISTER(asus, object, _name, max)			\
+	do {								\
+		struct led_classdev *ldev = &asus->leds.object;		\
+		if (!object##_set_handle)				\
+			break ;						\
+									\
+		INIT_WORK(&asus->leds.object##_work, object##_led_update); \
+		ldev->name = "asus::" _name;				\
+		ldev->brightness_set = object##_led_set;		\
+		ldev->max_brightness = max;				\
+		rv = led_classdev_register(&asus->platform_device->dev, ldev); \
+		if (rv)							\
+			goto error;					\
+	} while (0)
+
+static int asus_led_init(struct asus_laptop *asus)
+{
+	int rv;
+
+	/*
+	 * Functions that actually update the LED's are called from a
+	 * workqueue. By doing this as separate work rather than when the LED
+	 * subsystem asks, we avoid messing with the Asus ACPI stuff during a
+	 * potentially bad time, such as a timer interrupt.
+	 */
+	asus->leds.workqueue = create_singlethread_workqueue("led_workqueue");
+	if (!asus->leds.workqueue)
+		return -ENOMEM;
+
+	ASUS_LED_REGISTER(asus, mled, "mail", 1);
+	ASUS_LED_REGISTER(asus, tled, "touchpad", 1);
+	ASUS_LED_REGISTER(asus, rled, "record", 1);
+	ASUS_LED_REGISTER(asus, pled, "phone", 1);
+	ASUS_LED_REGISTER(asus, gled, "gaming", 1);
+	if (kled_set_handle && kled_get_handle)
+		ASUS_LED_REGISTER(asus, kled, "kbd_backlight", 3);
+error:
+	if (rv)
+		asus_led_exit(asus);
+	return rv;
+}
+
+/*
+ * Backlight device
+ */
 static int get_lcd_state(struct asus_laptop *asus)
 {
 	return read_status(asus, LCD_ON);
@@ -588,6 +644,41 @@ static int update_bl_status(struct backlight_device *bd)
 	return set_lcd_state(asus, value);
 }
 
+static struct backlight_ops asusbl_ops = {
+	.get_brightness = read_brightness,
+	.update_status = update_bl_status,
+};
+
+static int asus_backlight_init(struct asus_laptop *asus)
+{
+	struct backlight_device *bd;
+	struct device *dev = &asus->platform_device->dev;
+
+	if (brightness_set_handle && lcd_switch_handle) {
+		bd = backlight_device_register(ASUS_LAPTOP_FILE, dev,
+					       asus, &asusbl_ops);
+		if (IS_ERR(bd)) {
+			pr_err("Could not register asus backlight device\n");
+			asus->backlight_device = NULL;
+			return PTR_ERR(bd);
+		}
+
+		asus->backlight_device = bd;
+
+		bd->props.max_brightness = 15;
+		bd->props.brightness = read_brightness(NULL);
+		bd->props.power = FB_BLANK_UNBLANK;
+		backlight_update_status(bd);
+	}
+	return 0;
+}
+
+static void asus_backlight_exit(struct asus_laptop *asus)
+{
+	if (asus->backlight_device)
+		backlight_device_unregister(asus->backlight_device);
+}
+
 /*
  * Platform device handlers
  */
@@ -904,7 +995,7 @@ static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 }
 
 /*
- * Hotkey functions
+ * Input device (i.e. hotkeys)
  */
 static struct key_entry *asus_get_entry_by_scancode(struct asus_laptop *asus,
 						    int code)
@@ -965,10 +1056,72 @@ static int asus_setkeycode(struct input_dev *dev, int scancode, int keycode)
 	return -EINVAL;
 }
 
+static void asus_input_notify(struct asus_laptop *asus, int event)
+{
+	struct key_entry *key;
+
+	key = asus_get_entry_by_scancode(asus, event);
+	if (!key)
+		return ;
+
+	switch (key->type) {
+	case KE_KEY:
+		input_report_key(asus->inputdev, key->keycode, 1);
+		input_sync(asus->inputdev);
+		input_report_key(asus->inputdev, key->keycode, 0);
+		input_sync(asus->inputdev);
+		break;
+	}
+}
+
+static int asus_input_init(struct asus_laptop *asus)
+{
+	const struct key_entry *key;
+	int result;
+
+	asus->inputdev = input_allocate_device();
+	if (!asus->inputdev) {
+		pr_info("Unable to allocate input device\n");
+		return 0;
+	}
+	asus->inputdev->name = "Asus Laptop extra buttons";
+	asus->inputdev->dev.parent = &asus->platform_device->dev;
+	asus->inputdev->phys = ASUS_LAPTOP_FILE "/input0";
+	asus->inputdev->id.bustype = BUS_HOST;
+	asus->inputdev->getkeycode = asus_getkeycode;
+	asus->inputdev->setkeycode = asus_setkeycode;
+	input_set_drvdata(asus->inputdev, asus);
+
+	asus->keymap = kmemdup(asus_keymap, sizeof(asus_keymap),
+				GFP_KERNEL);
+	for (key = asus->keymap; key->type != KE_END; key++) {
+		switch (key->type) {
+		case KE_KEY:
+			set_bit(EV_KEY, asus->inputdev->evbit);
+			set_bit(key->keycode, asus->inputdev->keybit);
+			break;
+		}
+	}
+	result = input_register_device(asus->inputdev);
+	if (result) {
+		pr_info("Unable to register input device\n");
+		input_free_device(asus->inputdev);
+	}
+	return result;
+}
+
+static void asus_input_exit(struct asus_laptop *asus)
+{
+	if (asus->inputdev)
+		input_unregister_device(asus->inputdev);
+}
+
+/*
+ * ACPI driver
+ */
 static void asus_acpi_notify(struct acpi_device *device, u32 event)
 {
 	struct asus_laptop *asus = acpi_driver_data(device);
-	static struct key_entry *key;
 	u16 count;
 
 	/*
@@ -990,20 +1143,7 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 					dev_name(&asus->device->dev), event,
 					count);
 
-	if (asus->inputdev) {
-		key = asus_get_entry_by_scancode(asus, event);
-		if (!key)
-			return ;
-
-		switch (key->type) {
-		case KE_KEY:
-			input_report_key(asus->inputdev, key->keycode, 1);
-			input_sync(asus->inputdev);
-			input_report_key(asus->inputdev, key->keycode, 0);
-			input_sync(asus->inputdev);
-			break;
-		}
-	}
+	asus_input_notify(asus, event);
 }
 
 #define ASUS_CREATE_DEVICE_ATTR(_name)					\
@@ -1257,142 +1397,6 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	return AE_OK;
 }
 
-static int asus_input_init(struct asus_laptop *asus)
-{
-	const struct key_entry *key;
-	int result;
-
-	asus->inputdev = input_allocate_device();
-	if (!asus->inputdev) {
-		pr_info("Unable to allocate input device\n");
-		return 0;
-	}
-	asus->inputdev->name = "Asus Laptop extra buttons";
-	asus->inputdev->dev.parent = &asus->platform_device->dev;
-	asus->inputdev->phys = ASUS_LAPTOP_FILE "/input0";
-	asus->inputdev->id.bustype = BUS_HOST;
-	asus->inputdev->getkeycode = asus_getkeycode;
-	asus->inputdev->setkeycode = asus_setkeycode;
-	input_set_drvdata(asus->inputdev, asus);
-
-	asus->keymap = kmemdup(asus_keymap, sizeof(asus_keymap),
-				GFP_KERNEL);
-	for (key = asus->keymap; key->type != KE_END; key++) {
-		switch (key->type) {
-		case KE_KEY:
-			set_bit(EV_KEY, asus->inputdev->evbit);
-			set_bit(key->keycode, asus->inputdev->keybit);
-			break;
-		}
-	}
-	result = input_register_device(asus->inputdev);
-	if (result) {
-		pr_info("Unable to register input device\n");
-		input_free_device(asus->inputdev);
-	}
-	return result;
-}
-
-static void asus_backlight_exit(struct asus_laptop *asus)
-{
-	if (asus->backlight_device)
-		backlight_device_unregister(asus->backlight_device);
-}
-
-#define ASUS_LED_UNREGISTER(object)				\
-	if (object##_led.dev)					\
-		led_classdev_unregister(&object##_led)
-
-static void asus_led_exit(struct asus_laptop *asus)
-{
-	ASUS_LED_UNREGISTER(mled);
-	ASUS_LED_UNREGISTER(tled);
-	ASUS_LED_UNREGISTER(pled);
-	ASUS_LED_UNREGISTER(rled);
-	ASUS_LED_UNREGISTER(gled);
-	ASUS_LED_UNREGISTER(kled);
-	if (asus->leds.workqueue) {
-		destroy_workqueue(asus->leds.workqueue);
-		asus->leds.workqueue = NULL;
-	}
-}
-
-static void asus_input_exit(struct asus_laptop *asus)
-{
-	if (asus->inputdev)
-		input_unregister_device(asus->inputdev);
-}
-
-static int asus_backlight_init(struct asus_laptop *asus)
-{
-	struct backlight_device *bd;
-	struct device *dev = &asus->platform_device->dev;
-
-	if (brightness_set_handle && lcd_switch_handle) {
-		bd = backlight_device_register(ASUS_LAPTOP_FILE, dev,
-					       asus, &asusbl_ops);
-		if (IS_ERR(bd)) {
-			pr_err("Could not register asus backlight device\n");
-			asus->backlight_device = NULL;
-			return PTR_ERR(bd);
-		}
-
-		asus->backlight_device = bd;
-
-		bd->props.max_brightness = 15;
-		bd->props.brightness = read_brightness(NULL);
-		bd->props.power = FB_BLANK_UNBLANK;
-		backlight_update_status(bd);
-	}
-	return 0;
-}
-
-/*
- * Ugly macro, need to fix that later
- */
-#define ASUS_LED_REGISTER(asus, object, _name, max)			\
-	do {								\
-		struct led_classdev *ldev = &asus->leds.object;		\
-		if (!object##_set_handle)				\
-			break ;						\
-									\
-		INIT_WORK(&asus->leds.object##_work, object##_led_update); \
-		ldev->name = "asus::" _name;				\
-		ldev->brightness_set = object##_led_set;		\
-		ldev->max_brightness = max;				\
-		rv = led_classdev_register(&asus->platform_device->dev, ldev); \
-		if (rv)							\
-			goto error;					\
-	} while (0)
-
-static int asus_led_init(struct asus_laptop *asus)
-{
-	int rv;
-
-	/*
-	 * Functions that actually update the LED's are called from a
-	 * workqueue. By doing this as separate work rather than when the LED
-	 * subsystem asks, we avoid messing with the Asus ACPI stuff during a
-	 * potentially bad time, such as a timer interrupt.
-	 */
-	asus->leds.workqueue = create_singlethread_workqueue("led_workqueue");
-	if (!asus->leds.workqueue)
-		return -ENOMEM;
-
-	ASUS_LED_REGISTER(asus, mled, "mail", 1);
-	ASUS_LED_REGISTER(asus, tled, "touchpad", 1);
-	ASUS_LED_REGISTER(asus, rled, "record", 1);
-	ASUS_LED_REGISTER(asus, pled, "phone", 1);
-	ASUS_LED_REGISTER(asus, gled, "gaming", 1);
-	if (kled_set_handle && kled_get_handle)
-		ASUS_LED_REGISTER(asus, kled, "kbd_backlight", 3);
-error:
-	if (rv)
-		asus_led_exit(asus);
-	return rv;
-}
-
-
 static bool asus_device_present;
 
 static int __devinit asus_acpi_init(struct asus_laptop *asus)
@@ -1414,8 +1418,10 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	asus_laptop_add_fs(asus);
 
 	/* WLED and BLED are on by default */
-	write_status(asus, bt_switch_handle, 1, BT_ON);
-	write_status(asus, wl_switch_handle, 1, WL_ON);
+	if (bluetooth_status >= 0)
+		write_status(asus, bt_switch_handle, !!bluetooth_status, BT_ON);
+	if (wireless_status >= 0)
+		write_status(asus, wl_switch_handle, !!wireless_status, WL_ON);
 
 	/* If the h/w switch is off, we need to check the real status */
 	write_status(asus, NULL, read_status(asus, BT_ON), BT_ON);
@@ -1432,8 +1438,8 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	asus->ledd_status = 0xFFF;
 
 	/* Set initial values of light sensor and level */
-	hotk->light_switch = 0;	/* Default to light sensor disabled */
-	hotk->light_level = 5;	/* level 5 for sensor sensitivity */
+	asus->light_switch = 0;	/* Default to light sensor disabled */
+	asus->light_level = 5;	/* level 5 for sensor sensitivity */
 
 	if (ls_switch_handle)
 		set_light_sens_switch(asus, asus->light_switch);
-- 
1.6.6.1

