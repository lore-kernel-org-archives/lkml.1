Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0BBHzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:55:15 -0500
Received: from iksaif.net ([88.191.73.63]:50267 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentin.chary@gmail.com>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 17/28] asus-laptop: stop using ASUS_HANDLE and use relative methods instead
Date: Tue,  2 Feb 2010 08:39:00 +0100
Message-Id: <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
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
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Stop using ASUS_HANDLE because most of the time it is not needed.
This macro was introduced to display_get and lcd_switch which are not
part of the interface provided by Asus, and are scheduled for removal.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  240 +++++++++++++++++++-----------------
 1 files changed, 129 insertions(+), 111 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index ae4f808..671fad9 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -115,27 +115,27 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 	static char *object##_paths[] = { paths }
 
 /* LED */
-ASUS_HANDLE(mled_set, ASUS_LAPTOP_PREFIX "MLED");
-ASUS_HANDLE(tled_set, ASUS_LAPTOP_PREFIX "TLED");
-ASUS_HANDLE(rled_set, ASUS_LAPTOP_PREFIX "RLED");	/* W1JC */
-ASUS_HANDLE(pled_set, ASUS_LAPTOP_PREFIX "PLED");	/* A7J */
-ASUS_HANDLE(gled_set, ASUS_LAPTOP_PREFIX "GLED");	/* G1, G2 (probably) */
+#define METHOD_MLED		"MLED"
+#define METHOD_TLED		"TLED"
+#define METHOD_RLED		"RLED"	/* W1JC */
+#define METHOD_PLED		"PLED"	/* A7J */
+#define METHOD_GLED		"GLED"	/* G1, G2 (probably) */
 
 /* LEDD */
-ASUS_HANDLE(ledd_set, ASUS_LAPTOP_PREFIX "SLCM");
+#define METHOD_LEDD		"SLCM"
 
 /*
  * Bluetooth and WLAN
  * WLED and BLED are not handled like other XLED, because in some dsdt
  * they also control the WLAN/Bluetooth device.
  */
-ASUS_HANDLE(wl_switch, ASUS_LAPTOP_PREFIX "WLED");
-ASUS_HANDLE(bt_switch, ASUS_LAPTOP_PREFIX "BLED");
-ASUS_HANDLE(wireless_status, ASUS_LAPTOP_PREFIX "RSTS");	/* All new models */
+#define METHOD_WLAN		"WLED"
+#define METHOD_BLUETOOTH	"BLED"
+#define METHOD_WL_STATUS	"RSTS"
 
 /* Brightness */
-ASUS_HANDLE(brightness_set, ASUS_LAPTOP_PREFIX "SPLV");
-ASUS_HANDLE(brightness_get, ASUS_LAPTOP_PREFIX "GPLV");
+#define METHOD_BRIGHTNESS_SET	"SPLV"
+#define METHOD_BRIGHTNESS_GET	"GPLV"
 
 /* Backlight */
 ASUS_HANDLE(lcd_switch, "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
@@ -148,7 +148,7 @@ ASUS_HANDLE(lcd_switch, "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
 	    "\\Q10");		/* A2x, L2D, L3D, M2E */
 
 /* Display */
-ASUS_HANDLE(display_set, ASUS_LAPTOP_PREFIX "SDSP");
+#define METHOD_SWITCH_DISPLAY	"SDSP"
 ASUS_HANDLE(display_get,
 	    /* A6B, A6K A6R A7D F3JM L4R M6R A3G M6A M6V VX-1 V6J V6V W3Z */
 	    "\\_SB.PCI0.P0P1.VGA.GETD",
@@ -173,18 +173,18 @@ ASUS_HANDLE(display_get,
 	    /* A3F A6F A3N A3L M6N W3N W6A */
 	    "\\SSTE");
 
-ASUS_HANDLE(ls_switch, ASUS_LAPTOP_PREFIX "ALSC"); /* Z71A Z71V */
-ASUS_HANDLE(ls_level, ASUS_LAPTOP_PREFIX "ALSL");	 /* Z71A Z71V */
+#define METHOD_ALS_CONTROL	"ALSC" /* Z71A Z71V */
+#define METHOD_ALS_LEVEL	"ALSL" /* Z71A Z71V */
 
 /* GPS */
 /* R2H use different handle for GPS on/off */
-ASUS_HANDLE(gps_on, ASUS_LAPTOP_PREFIX "SDON");	/* R2H */
-ASUS_HANDLE(gps_off, ASUS_LAPTOP_PREFIX "SDOF");	/* R2H */
-ASUS_HANDLE(gps_status, ASUS_LAPTOP_PREFIX "GPST");
+#define METHOD_GPS_ON		"SDON"
+#define METHOD_GPS_OFF		"SDOF"
+#define METHOD_GPS_STATUS	"GPST"
 
 /* Keyboard light */
-ASUS_HANDLE(kled_set, ASUS_LAPTOP_PREFIX "SLKB");
-ASUS_HANDLE(kled_get, ASUS_LAPTOP_PREFIX "GLKB");
+#define METHOD_KBD_LIGHT_SET	"SLKB"
+#define METHOD_KBD_LIGHT_GET	"GLKB"
 
 /*
  * Define a specific led structure to keep the main structure clean
@@ -323,18 +323,44 @@ static int write_acpi_int(acpi_handle handle, const char *method, int val)
 	return write_acpi_int_ret(handle, method, val, NULL);
 }
 
+static int acpi_check_handle(acpi_handle handle, const char *method,
+			     acpi_handle *ret)
+{
+	acpi_status status;
+
+	if (method == NULL)
+		return -ENODEV;
+
+	if (ret)
+		status = acpi_get_handle(handle, (char *)method,
+					 ret);
+	else {
+		acpi_handle dummy;
+
+		status = acpi_get_handle(handle, (char *)method,
+					 &dummy);
+	}
+
+	if (status != AE_OK) {
+		if (ret)
+			pr_warning("Error finding %s\n", method);
+		return -ENODEV;
+	}
+	return 0;
+}
+
 /* Generic LED function */
-static void asus_led_set(struct asus_laptop *asus, acpi_handle handle,
+static void asus_led_set(struct asus_laptop *asus, char *method,
 			 int value)
 {
-	if (handle == mled_set_handle)
+	if (!strcmp(method, METHOD_MLED))
 		value = !value;
-	else if (handle == gled_set_handle)
+	else if (!strcmp(method, METHOD_GLED))
 		value = !value + 1;
 	else
 		value = !!value;
 
-	write_acpi_int(handle, NULL, value);
+	write_acpi_int(asus->handle, method, value);
 }
 
 /*
@@ -361,7 +387,7 @@ ASUS_LED(gled, "gaming", 1);
 ASUS_LED(kled, "kbd_backlight", 3);
 
 /* /sys/class/led handlers */
-#define ASUS_LED_HANDLER(object, mask)					\
+#define ASUS_LED_HANDLER(object, method)				\
 	static void object##_led_set(struct led_classdev *led_cdev,	\
 				     enum led_brightness value)		\
 	{								\
@@ -377,7 +403,7 @@ ASUS_LED(kled, "kbd_backlight", 3);
 		struct asus_laptop *asus = work_to_asus(work, object);	\
 									\
 		int value = asus->leds.object##_wk;			\
-		asus_led_set(asus, object##_set_handle, value);		\
+		asus_led_set(asus, method, value);			\
 	}								\
 	static enum led_brightness object##_led_get(			\
 		struct led_classdev *led_cdev)				\
@@ -385,16 +411,16 @@ ASUS_LED(kled, "kbd_backlight", 3);
 		return led_cdev->brightness;				\
 	}
 
-ASUS_LED_HANDLER(mled, MLED_ON);
-ASUS_LED_HANDLER(pled, PLED_ON);
-ASUS_LED_HANDLER(rled, RLED_ON);
-ASUS_LED_HANDLER(tled, TLED_ON);
-ASUS_LED_HANDLER(gled, GLED_ON);
+ASUS_LED_HANDLER(mled, METHOD_MLED);
+ASUS_LED_HANDLER(pled, METHOD_PLED);
+ASUS_LED_HANDLER(rled, METHOD_RLED);
+ASUS_LED_HANDLER(tled, METHOD_TLED);
+ASUS_LED_HANDLER(gled, METHOD_GLED);
 
 /*
  * Keyboard backlight (also a LED)
  */
-static int asus_kled_lvl(void)
+static int asus_kled_lvl(struct asus_laptop *asus)
 {
 	unsigned long long kblv;
 	struct acpi_object_list params;
@@ -406,7 +432,8 @@ static int asus_kled_lvl(void)
 	in_obj.type = ACPI_TYPE_INTEGER;
 	in_obj.integer.value = 2;
 
-	rv = acpi_evaluate_integer(kled_get_handle, NULL, &params, &kblv);
+	rv = acpi_evaluate_integer(asus->handle, METHOD_KBD_LIGHT_GET,
+				   &params, &kblv);
 	if (ACPI_FAILURE(rv)) {
 		pr_warning("Error reading kled level\n");
 		return -ENODEV;
@@ -421,7 +448,7 @@ static int asus_kled_set(struct asus_laptop *asus, int kblv)
 	else
 		kblv = 0;
 
-	if (write_acpi_int(kled_set_handle, NULL, kblv)) {
+	if (write_acpi_int(asus->handle, METHOD_KBD_LIGHT_SET, kblv)) {
 		pr_warning("Keyboard LED display write failed\n");
 		return -EINVAL;
 	}
@@ -446,7 +473,9 @@ static void kled_led_update(struct work_struct *work)
 
 static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
 {
-	return asus_kled_lvl();
+	struct asus_laptop *asus = led_to_asus(led_cdev, kled);
+
+	return asus_kled_lvl(asus);
 }
 
 #define ASUS_LED_UNREGISTER(object)				\
@@ -468,10 +497,11 @@ static void asus_led_exit(struct asus_laptop *asus)
 }
 
 /*  Ugly macro, need to fix that later */
-#define ASUS_LED_REGISTER(asus, object, _name, max)			\
+#define ASUS_LED_REGISTER(asus, object, _name, max, method)		\
 	do {								\
 		struct led_classdev *ldev = &asus->leds.object;		\
-		if (!object##_set_handle)				\
+									\
+		if (method && acpi_check_handle(asus->handle, method, NULL)) \
 			break ;						\
 									\
 		INIT_WORK(&asus->leds.object##_work, object##_led_update); \
@@ -497,13 +527,14 @@ static int asus_led_init(struct asus_laptop *asus)
 	if (!asus->leds.workqueue)
 		return -ENOMEM;
 
-	ASUS_LED_REGISTER(asus, mled, "mail", 1);
-	ASUS_LED_REGISTER(asus, tled, "touchpad", 1);
-	ASUS_LED_REGISTER(asus, rled, "record", 1);
-	ASUS_LED_REGISTER(asus, pled, "phone", 1);
-	ASUS_LED_REGISTER(asus, gled, "gaming", 1);
-	if (kled_set_handle && kled_get_handle)
-		ASUS_LED_REGISTER(asus, kled, "kbd_backlight", 3);
+	ASUS_LED_REGISTER(asus, mled, "mail", 1, METHOD_MLED);
+	ASUS_LED_REGISTER(asus, tled, "touchpad", 1, METHOD_TLED);
+	ASUS_LED_REGISTER(asus, rled, "record", 1, METHOD_RLED);
+	ASUS_LED_REGISTER(asus, pled, "phone", 1, METHOD_PLED);
+	ASUS_LED_REGISTER(asus, gled, "gaming", 1, METHOD_GLED);
+	if (!acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_SET, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_GET, NULL))
+		ASUS_LED_REGISTER(asus, kled, "kbd_backlight", 3, NULL);
 error:
 	if (rv)
 		asus_led_exit(asus);
@@ -557,10 +588,12 @@ static void lcd_blank(struct asus_laptop *asus, int blank)
 
 static int asus_read_brightness(struct backlight_device *bd)
 {
+	struct asus_laptop *asus = bl_get_data(bd);
 	unsigned long long value;
 	acpi_status rv = AE_OK;
 
-	rv = acpi_evaluate_integer(brightness_get_handle, NULL, NULL, &value);
+	rv = acpi_evaluate_integer(asus->handle, METHOD_BRIGHTNESS_GET,
+				   NULL, &value);
 	if (ACPI_FAILURE(rv))
 		pr_warning("Error reading brightness\n");
 
@@ -569,7 +602,9 @@ static int asus_read_brightness(struct backlight_device *bd)
 
 static int asus_set_brightness(struct backlight_device *bd, int value)
 {
-	if (write_acpi_int(brightness_set_handle, NULL, value)) {
+	struct asus_laptop *asus = bl_get_data(bd);
+
+	if (write_acpi_int(asus->handle, METHOD_BRIGHTNESS_SET, value)) {
 		pr_warning("Error changing brightness\n");
 		return -EIO;
 	}
@@ -600,7 +635,9 @@ static int asus_backlight_init(struct asus_laptop *asus)
 	struct backlight_device *bd;
 	struct device *dev = &asus->platform_device->dev;
 
-	if (brightness_set_handle && lcd_switch_handle) {
+	if (!acpi_check_handle(asus->handle, METHOD_BRIGHTNESS_GET, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_BRIGHTNESS_SET, NULL) &&
+	    lcd_switch_handle) {
 		bd = backlight_device_register(ASUS_LAPTOP_FILE, dev,
 					       asus, &asusbl_ops);
 		if (IS_ERR(bd)) {
@@ -612,8 +649,8 @@ static int asus_backlight_init(struct asus_laptop *asus)
 		asus->backlight_device = bd;
 
 		bd->props.max_brightness = 15;
-		bd->props.brightness = asus_read_brightness(NULL);
 		bd->props.power = FB_BLANK_UNBLANK;
+		bd->props.brightness = asus_read_brightness(bd);
 		backlight_update_status(bd);
 	}
 	return 0;
@@ -716,7 +753,7 @@ static int parse_arg(const char *buf, unsigned long count, int *val)
 
 static ssize_t sysfs_acpi_set(struct asus_laptop *asus,
 			      const char *buf, size_t count,
-			      acpi_handle handle)
+			      const char *method)
 {
 	int rv, value;
 	int out = 0;
@@ -725,7 +762,7 @@ static ssize_t sysfs_acpi_set(struct asus_laptop *asus,
 	if (rv > 0)
 		out = value ? 1 : 0;
 
-	if (write_acpi_int(handle, NULL, value))
+	if (write_acpi_int(asus->handle, method, value))
 		return -ENODEV;
 	return rv;
 }
@@ -749,7 +786,7 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0) {
-		if (write_acpi_int(ledd_set_handle, NULL, value))
+		if (write_acpi_int(asus->handle, METHOD_LEDD, value))
 			pr_warning("LED display write failed\n");
 		else
 			asus->ledd_status = (u32) value;
@@ -768,7 +805,8 @@ static int asus_wireless_status(struct asus_laptop *asus, int mask)
 	if (!asus->have_rsts)
 		return (asus->wireless_status & mask) ? 1 : 0;
 
-	rv = acpi_evaluate_integer(wireless_status_handle, NULL, NULL, &status);
+	rv = acpi_evaluate_integer(asus->handle, METHOD_WL_STATUS,
+				   NULL, &status);
 	if (ACPI_FAILURE(rv)) {
 		pr_warning("Error reading Wireless status\n");
 		return -EINVAL;
@@ -792,7 +830,7 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sysfs_acpi_set(asus, buf, count, wl_switch_handle);
+	return sysfs_acpi_set(asus, buf, count, METHOD_WLAN);
 }
 
 /*
@@ -812,7 +850,7 @@ static ssize_t store_bluetooth(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sysfs_acpi_set(asus, buf, count, bt_switch_handle);
+	return sysfs_acpi_set(asus, buf, count, METHOD_BLUETOOTH);
 }
 
 /*
@@ -821,7 +859,7 @@ static ssize_t store_bluetooth(struct device *dev,
 static void asus_set_display(struct asus_laptop *asus, int value)
 {
 	/* no sanity check needed for now */
-	if (write_acpi_int(display_set_handle, NULL, value))
+	if (write_acpi_int(asus->handle, METHOD_SWITCH_DISPLAY, value))
 		pr_warning("Error setting display\n");
 	return;
 }
@@ -883,7 +921,7 @@ static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
  */
 static void asus_als_switch(struct asus_laptop *asus, int value)
 {
-	if (write_acpi_int(ls_switch_handle, NULL, value))
+	if (write_acpi_int(asus->handle, METHOD_ALS_CONTROL, value))
 		pr_warning("Error setting light sensor switch\n");
 	asus->light_switch = value;
 }
@@ -911,7 +949,7 @@ static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
 
 static void asus_als_level(struct asus_laptop *asus, int value)
 {
-	if (write_acpi_int(ls_level_handle, NULL, value))
+	if (write_acpi_int(asus->handle, METHOD_ALS_LEVEL, value))
 		pr_warning("Error setting light sensor level\n");
 	asus->light_level = value;
 }
@@ -949,7 +987,8 @@ static int asus_gps_status(struct asus_laptop *asus)
 	unsigned long long status;
 	acpi_status rv = AE_OK;
 
-	rv = acpi_evaluate_integer(gps_status_handle, NULL, NULL, &status);
+	rv = acpi_evaluate_integer(asus->handle, METHOD_GPS_STATUS,
+				   NULL, &status);
 	if (ACPI_FAILURE(rv)) {
 		pr_warning("Error reading GPS status\n");
 		return -ENODEV;
@@ -959,9 +998,9 @@ static int asus_gps_status(struct asus_laptop *asus)
 
 static int asus_gps_switch(struct asus_laptop *asus, int status)
 {
-	acpi_handle handle = status ? gps_on_handle : gps_off_handle;
+	const char *meth = status ? METHOD_GPS_ON : METHOD_GPS_OFF;
 
-	if (write_acpi_int(handle, NULL, 0x02))
+	if (write_acpi_int(asus->handle, meth, 0x02))
 		return -ENODEV;
 	return 0;
 }
@@ -1224,27 +1263,33 @@ static void asus_laptop_add_fs(struct asus_laptop *asus)
 {
 	ASUS_SET_DEVICE_ATTR(infos, 0444, show_infos, NULL);
 
-	if (wl_switch_handle)
+	if (!acpi_check_handle(asus->handle, METHOD_WLAN, NULL))
 		ASUS_SET_DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan);
 
-	if (bt_switch_handle)
+	if (!acpi_check_handle(asus->handle, METHOD_BLUETOOTH, NULL))
 		ASUS_SET_DEVICE_ATTR(bluetooth, 0644,
 				     show_bluetooth, store_bluetooth);
 
-	if (display_set_handle && display_get_handle)
-		ASUS_SET_DEVICE_ATTR(display, 0644, show_disp, store_disp);
-	else if (display_set_handle)
-		ASUS_SET_DEVICE_ATTR(display, 0200, NULL, store_disp);
+	if (!acpi_check_handle(asus->handle, METHOD_SWITCH_DISPLAY, NULL)) {
+		if (display_get_handle)
+			ASUS_SET_DEVICE_ATTR(display, 0644, show_disp,
+					     store_disp);
+		else
+			ASUS_SET_DEVICE_ATTR(display, 0200, NULL, store_disp);
+	}
 
-	if (ledd_set_handle)
+	if (!acpi_check_handle(asus->handle, METHOD_LEDD, NULL))
 		ASUS_SET_DEVICE_ATTR(ledd, 0644, show_ledd, store_ledd);
 
-	if (ls_switch_handle && ls_level_handle) {
+	if (!acpi_check_handle(asus->handle, METHOD_ALS_CONTROL, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_ALS_LEVEL, NULL)) {
 		ASUS_SET_DEVICE_ATTR(ls_level, 0644, show_lslvl, store_lslvl);
 		ASUS_SET_DEVICE_ATTR(ls_switch, 0644, show_lssw, store_lssw);
 	}
 
-	if (gps_status_handle && gps_on_handle && gps_off_handle)
+	if (!acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
 		ASUS_SET_DEVICE_ATTR(gps, 0644, show_gps, store_gps);
 }
 
@@ -1337,55 +1382,23 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	if (*string)
 		pr_notice("  %s model detected\n", string);
 
-	ASUS_HANDLE_INIT(mled_set);
-	ASUS_HANDLE_INIT(tled_set);
-	ASUS_HANDLE_INIT(rled_set);
-	ASUS_HANDLE_INIT(pled_set);
-	ASUS_HANDLE_INIT(gled_set);
-
-	ASUS_HANDLE_INIT(ledd_set);
-
-	ASUS_HANDLE_INIT(kled_set);
-	ASUS_HANDLE_INIT(kled_get);
-
 	/*
 	 * The HWRS method return informations about the hardware.
 	 * 0x80 bit is for WLAN, 0x100 for Bluetooth.
 	 * The significance of others is yet to be found.
-	 * If we don't find the method, we assume the device are present.
 	 */
 	status =
 	    acpi_evaluate_integer(asus->handle, "HRWS", NULL, &hwrs_result);
-	if (ACPI_FAILURE(status))
-		hwrs_result = WL_HWRS | BT_HWRS;
+	if (!ACPI_FAILURE(status))
+		pr_notice("  HRWS returned %x", (int)hwrs_result);
 
-	if (hwrs_result & WL_HWRS)
-		ASUS_HANDLE_INIT(wl_switch);
-	if (hwrs_result & BT_HWRS)
-		ASUS_HANDLE_INIT(bt_switch);
-
-	if (!ASUS_HANDLE_INIT(wireless_status))
+	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts = true;
 
-	ASUS_HANDLE_INIT(brightness_set);
-	ASUS_HANDLE_INIT(brightness_get);
-
+	/* Scheduled for removal */
 	ASUS_HANDLE_INIT(lcd_switch);
-
-	ASUS_HANDLE_INIT(display_set);
 	ASUS_HANDLE_INIT(display_get);
 
-	/*
-	 * There is a lot of models with "ALSL", but a few get
-	 * a real light sens, so we need to check it.
-	 */
-	if (!ASUS_HANDLE_INIT(ls_switch))
-		ASUS_HANDLE_INIT(ls_level);
-
-	ASUS_HANDLE_INIT(gps_on);
-	ASUS_HANDLE_INIT(gps_off);
-	ASUS_HANDLE_INIT(gps_status);
-
 	kfree(model);
 
 	return AE_OK;
@@ -1413,12 +1426,14 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 
 	/* WLED and BLED are on by default */
 	if (bluetooth_status >= 0)
-		write_acpi_int(bt_switch_handle, NULL, !!bluetooth_status);
+		write_acpi_int(asus->handle, METHOD_BLUETOOTH,
+			       !!bluetooth_status);
 	if (wireless_status >= 0)
-		write_acpi_int(wl_switch_handle, NULL, !!wireless_status);
+		write_acpi_int(asus->handle, METHOD_WLAN,
+			       !!wireless_status);
 
 	/* Keyboard Backlight is on by default */
-	if (kled_set_handle)
+	if (!acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_SET, NULL))
 		asus_kled_set(asus, 1);
 
 	/* LED display is off by default */
@@ -1428,14 +1443,17 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	asus->light_switch = 0;	/* Default to light sensor disabled */
 	asus->light_level = 5;	/* level 5 for sensor sensitivity */
 
-	if (ls_switch_handle)
+	if (!acpi_check_handle(asus->handle, METHOD_ALS_CONTROL, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_ALS_LEVEL, NULL)) {
 		asus_als_switch(asus, asus->light_switch);
-
-	if (ls_level_handle)
 		asus_als_level(asus, asus->light_level);
+	}
 
 	/* GPS is on by default */
-	asus_gps_switch(asus, 1);
+	if (!acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) &&
+	    !acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
+		asus_gps_switch(asus, 1);
 	return result;
 }
 
-- 
1.6.6.1

