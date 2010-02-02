Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0BBHzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:55:36 -0500
Received: from iksaif.net ([88.191.73.63]:50264 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 10/28] asus-laptop: callbacks should use "driver data" parameter or field
Date: Tue,  2 Feb 2010 08:38:53 +0100
Message-Id: <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Changelog stolen from Alan's patch for eeepc-laptop, but this patch
does the same thing for asus-laptop)

Callback methods should not refer to a variable like "asus" (formally
"hotk").  Instead, they should extract the data they need either from
a "driver data" parameter, or the "driver data" field of the object
which they operate on.  The "asus" variable can then be removed.

In practice, drivers under "drivers/platform" can get away without using
driver data, because it doesn't make sense to have more than one
instance of them.  However this makes it harder to review them for
correctness.  This is especially true for core ACPI developers who have
not previously been exposed to this anti-pattern :-).

This will serve as an example of best practice for new driver writers
(whether they find it themselves, or have it pointed out during review
:-).

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  362 +++++++++++++++++++++---------------
 1 files changed, 209 insertions(+), 153 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 4ff30ca..58a4864 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -196,6 +196,34 @@ ASUS_HANDLE(kled_set, ASUS_LAPTOP_PREFIX "SLKB");
 ASUS_HANDLE(kled_get, ASUS_LAPTOP_PREFIX "GLKB");
 
 /*
+ * Define a specific led structure to keep the main structure clean
+ */
+#define ASUS_DEFINE_LED(object)					\
+	int object##_wk;					\
+	struct work_struct object##_work;			\
+	struct led_classdev object;
+
+
+#define led_to_asus(led_cdev, led)					\
+	container_of(container_of(led_cdev, struct asus_laptop_leds,	\
+				  led),					\
+		     struct asus_laptop, leds)
+#define work_to_asus(work, led)						\
+	container_of(container_of(work, struct asus_laptop_leds,	\
+				  led##_work),				\
+		     struct asus_laptop, leds)
+
+struct asus_laptop_leds {
+	ASUS_DEFINE_LED(mled)
+	ASUS_DEFINE_LED(tled)
+	ASUS_DEFINE_LED(rled)
+	ASUS_DEFINE_LED(pled)
+	ASUS_DEFINE_LED(gled)
+	ASUS_DEFINE_LED(kled)
+	struct workqueue_struct *workqueue;
+};
+
+/*
  * This is the main structure, we can use it to store anything interesting
  * about the hotk device
  */
@@ -206,7 +234,11 @@ struct asus_laptop {
 	struct platform_device *platform_device;
 	struct acpi_device *device;		/* the device we are in */
 	struct backlight_device *backlight_device;
+
 	struct input_dev *inputdev;
+	struct key_entry *keymap;
+
+	struct asus_laptop_leds leds;
 
 	acpi_handle handle;	/* the handle of the hotk device */
 	char status;		/* status of the hotk, for LEDs, ... */
@@ -217,10 +249,6 @@ struct asus_laptop {
 	u16 *keycode_map;
 };
 
-static struct asus_laptop *asus;
-
-static struct workqueue_struct *led_workqueue;
-
 /*
  * The backlight class declaration
  */
@@ -237,8 +265,6 @@ static struct backlight_ops asusbl_ops = {
 	static enum led_brightness object##_led_get(			\
 		struct led_classdev *led_cdev);				\
 	static void object##_led_update(struct work_struct *ignored);	\
-	static int object##_led_wk;					\
-	static DECLARE_WORK(object##_led_work, object##_led_update);	\
 	static struct led_classdev object##_led = {			\
 		.name           = "asus::" ledname,			\
 		.brightness_set = object##_led_set,			\
@@ -261,7 +287,7 @@ struct key_entry {
 
 enum { KE_KEY, KE_END };
 
-static struct key_entry asus_keymap[] = {
+static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x02, KEY_SCREENLOCK},
 	{KE_KEY, 0x05, KEY_WLAN},
 	{KE_KEY, 0x08, KEY_F13},
@@ -333,7 +359,7 @@ static int write_acpi_int(acpi_handle handle, const char *method, int val)
 	return write_acpi_int_ret(handle, method, val, NULL);
 }
 
-static int read_wireless_status(int mask)
+static int read_wireless_status(struct asus_laptop *asus, int mask)
 {
 	unsigned long long status;
 	acpi_status rv = AE_OK;
@@ -350,7 +376,7 @@ static int read_wireless_status(int mask)
 	return (asus->status & mask) ? 1 : 0;
 }
 
-static int read_gps_status(void)
+static int read_gps_status(struct asus_laptop *asus)
 {
 	unsigned long long status;
 	acpi_status rv = AE_OK;
@@ -365,18 +391,19 @@ static int read_gps_status(void)
 }
 
 /* Generic LED functions */
-static int read_status(int mask)
+static int read_status(struct asus_laptop *asus, int mask)
 {
 	/* There is a special method for both wireless devices */
 	if (mask == BT_ON || mask == WL_ON)
-		return read_wireless_status(mask);
+		return read_wireless_status(asus, mask);
 	else if (mask == GPS_ON)
-		return read_gps_status();
+		return read_gps_status(asus);
 
 	return (asus->status & mask) ? 1 : 0;
 }
 
-static void write_status(acpi_handle handle, int out, int mask)
+static void write_status(struct asus_laptop *asus, acpi_handle handle,
+			 int out, int mask)
 {
 	asus->status = (out) ? (asus->status | mask) : (asus->status & ~mask);
 
@@ -405,13 +432,19 @@ static void write_status(acpi_handle handle, int out, int mask)
 	static void object##_led_set(struct led_classdev *led_cdev,	\
 				     enum led_brightness value)		\
 	{								\
-		object##_led_wk = (value > 0) ? 1 : 0;			\
-		queue_work(led_workqueue, &object##_led_work);		\
+		struct asus_laptop *asus =				\
+			led_to_asus(led_cdev, object);			\
+									\
+		asus->leds.object##_wk = (value > 0) ? 1 : 0;		\
+		queue_work(asus->leds.workqueue,			\
+			   &asus->leds.object##_work);			\
 	}								\
-	static void object##_led_update(struct work_struct *ignored)	\
+	static void object##_led_update(struct work_struct *work)	\
 	{								\
-		int value = object##_led_wk;				\
-		write_status(object##_set_handle, value, (mask));	\
+		struct asus_laptop *asus = work_to_asus(work, object);	\
+									\
+		int value = asus->leds.object##_wk;			\
+		write_status(asus, object##_set_handle, value, (mask));	\
 	}								\
 	static enum led_brightness object##_led_get(			\
 		struct led_classdev *led_cdev)				\
@@ -448,7 +481,7 @@ static int get_kled_lvl(void)
 	return kblv;
 }
 
-static int set_kled_lvl(int kblv)
+static int set_kled_lvl(struct asus_laptop *asus, int kblv)
 {
 	if (kblv > 0)
 		kblv = (1 << 7) | (kblv & 0x7F);
@@ -465,13 +498,17 @@ static int set_kled_lvl(int kblv)
 static void kled_led_set(struct led_classdev *led_cdev,
 			 enum led_brightness value)
 {
-	kled_led_wk = value;
-	queue_work(led_workqueue, &kled_led_work);
+	struct asus_laptop *asus = led_to_asus(led_cdev, kled);
+
+	asus->leds.kled_wk = value;
+	queue_work(asus->leds.workqueue, &asus->leds.kled_work);
 }
 
-static void kled_led_update(struct work_struct *ignored)
+static void kled_led_update(struct work_struct *work)
 {
-	set_kled_lvl(kled_led_wk);
+	struct asus_laptop *asus = work_to_asus(work, kled);
+
+	set_kled_lvl(asus, asus->leds.kled_wk);
 }
 
 static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
@@ -479,19 +516,19 @@ static enum led_brightness kled_led_get(struct led_classdev *led_cdev)
 	return get_kled_lvl();
 }
 
-static int get_lcd_state(void)
+static int get_lcd_state(struct asus_laptop *asus)
 {
-	return read_status(LCD_ON);
+	return read_status(asus, LCD_ON);
 }
 
-static int set_lcd_state(int value)
+static int set_lcd_state(struct asus_laptop *asus, int value)
 {
 	int lcd = 0;
 	acpi_status status = 0;
 
 	lcd = value ? 1 : 0;
 
-	if (lcd == get_lcd_state())
+	if (lcd == get_lcd_state(asus))
 		return 0;
 
 	if (lcd_switch_handle) {
@@ -502,11 +539,11 @@ static int set_lcd_state(int value)
 			pr_warning("Error switching LCD\n");
 	}
 
-	write_status(NULL, lcd, LCD_ON);
+	write_status(asus, NULL, lcd, LCD_ON);
 	return 0;
 }
 
-static void lcd_blank(int blank)
+static void lcd_blank(struct asus_laptop *asus, int blank)
 {
 	struct backlight_device *bd = asus->backlight_device;
 
@@ -539,6 +576,7 @@ static int set_brightness(struct backlight_device *bd, int value)
 
 static int update_bl_status(struct backlight_device *bd)
 {
+	struct asus_laptop *asus = bl_get_data(bd);
 	int rv;
 	int value = bd->props.brightness;
 
@@ -547,7 +585,7 @@ static int update_bl_status(struct backlight_device *bd)
 		return rv;
 
 	value = (bd->props.power == FB_BLANK_UNBLANK) ? 1 : 0;
-	return set_lcd_state(value);
+	return set_lcd_state(asus, value);
 }
 
 /*
@@ -562,6 +600,7 @@ static int update_bl_status(struct backlight_device *bd)
 static ssize_t show_infos(struct device *dev,
 			  struct device_attribute *attr, char *page)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int len = 0;
 	unsigned long long temp;
 	char buf[16];		/* enough for all info */
@@ -638,7 +677,8 @@ static int parse_arg(const char *buf, unsigned long count, int *val)
 	return count;
 }
 
-static ssize_t store_status(const char *buf, size_t count,
+static ssize_t store_status(struct asus_laptop *asus,
+			    const char *buf, size_t count,
 			    acpi_handle handle, int mask)
 {
 	int rv, value;
@@ -648,7 +688,7 @@ static ssize_t store_status(const char *buf, size_t count,
 	if (rv > 0)
 		out = value ? 1 : 0;
 
-	write_status(handle, out, mask);
+	write_status(asus, handle, out, mask);
 
 	return rv;
 }
@@ -659,12 +699,15 @@ static ssize_t store_status(const char *buf, size_t count,
 static ssize_t show_ledd(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
 	return sprintf(buf, "0x%08x\n", asus->ledd_status);
 }
 
 static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
 
 	rv = parse_arg(buf, count, &value);
@@ -683,13 +726,17 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 static ssize_t show_wlan(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", read_status(WL_ON));
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", read_status(asus, WL_ON));
 }
 
 static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
-	return store_status(buf, count, wl_switch_handle, WL_ON);
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return store_status(asus, buf, count, wl_switch_handle, WL_ON);
 }
 
 /*
@@ -698,20 +745,24 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 static ssize_t show_bluetooth(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", read_status(BT_ON));
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", read_status(asus, BT_ON));
 }
 
 static ssize_t store_bluetooth(struct device *dev,
 			       struct device_attribute *attr, const char *buf,
 			       size_t count)
 {
-	return store_status(buf, count, bt_switch_handle, BT_ON);
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return store_status(asus, buf, count, bt_switch_handle, BT_ON);
 }
 
 /*
  * Display
  */
-static void set_display(int value)
+static void set_display(struct asus_laptop *asus, int value)
 {
 	/* no sanity check needed for now */
 	if (write_acpi_int(display_set_handle, NULL, value))
@@ -719,7 +770,7 @@ static void set_display(int value)
 	return;
 }
 
-static int read_display(void)
+static int read_display(struct asus_laptop *asus)
 {
 	unsigned long long value = 0;
 	acpi_status rv = AE_OK;
@@ -747,7 +798,9 @@ static int read_display(void)
 static ssize_t show_disp(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", read_display());
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", read_display(asus));
 }
 
 /*
@@ -760,18 +813,19 @@ static ssize_t show_disp(struct device *dev,
 static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0)
-		set_display(value);
+		set_display(asus, value);
 	return rv;
 }
 
 /*
  * Light Sens
  */
-static void set_light_sens_switch(int value)
+static void set_light_sens_switch(struct asus_laptop *asus, int value)
 {
 	if (write_acpi_int(ls_switch_handle, NULL, value))
 		pr_warning("Error setting light sensor switch\n");
@@ -781,22 +835,25 @@ static void set_light_sens_switch(int value)
 static ssize_t show_lssw(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
 	return sprintf(buf, "%d\n", asus->light_switch);
 }
 
 static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0)
-		set_light_sens_switch(value ? 1 : 0);
+		set_light_sens_switch(asus, value ? 1 : 0);
 
 	return rv;
 }
 
-static void set_light_sens_level(int value)
+static void set_light_sens_level(struct asus_laptop *asus, int value)
 {
 	if (write_acpi_int(ls_level_handle, NULL, value))
 		pr_warning("Error setting light sensor level\n");
@@ -806,19 +863,22 @@ static void set_light_sens_level(int value)
 static ssize_t show_lslvl(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
 	return sprintf(buf, "%d\n", asus->light_level);
 }
 
 static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
+	struct asus_laptop *asus = dev_get_drvdata(dev);
 	int rv, value;
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0) {
 		value = (0 < value) ? ((15 < value) ? 15 : value) : 0;
 		/* 0 <= value <= 15 */
-		set_light_sens_level(value);
+		set_light_sens_level(asus, value);
 	}
 
 	return rv;
@@ -830,34 +890,40 @@ static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 static ssize_t show_gps(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", read_status(GPS_ON));
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", read_status(asus, GPS_ON));
 }
 
 static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
-	return store_status(buf, count, NULL, GPS_ON);
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+
+	return store_status(asus, buf, count, NULL, GPS_ON);
 }
 
 /*
  * Hotkey functions
  */
-static struct key_entry *asus_get_entry_by_scancode(int code)
+static struct key_entry *asus_get_entry_by_scancode(struct asus_laptop *asus,
+						    int code)
 {
 	struct key_entry *key;
 
-	for (key = asus_keymap; key->type != KE_END; key++)
+	for (key = asus->keymap; key->type != KE_END; key++)
 		if (code == key->code)
 			return key;
 
 	return NULL;
 }
 
-static struct key_entry *asus_get_entry_by_keycode(int code)
+static struct key_entry *asus_get_entry_by_keycode(struct asus_laptop *asus,
+						   int code)
 {
 	struct key_entry *key;
 
-	for (key = asus_keymap; key->type != KE_END; key++)
+	for (key = asus->keymap; key->type != KE_END; key++)
 		if (code == key->keycode && key->type == KE_KEY)
 			return key;
 
@@ -866,7 +932,8 @@ static struct key_entry *asus_get_entry_by_keycode(int code)
 
 static int asus_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 {
-	struct key_entry *key = asus_get_entry_by_scancode(scancode);
+	struct asus_laptop *asus = input_get_drvdata(dev);
+	struct key_entry *key = asus_get_entry_by_scancode(asus, scancode);
 
 	if (key && key->type == KE_KEY) {
 		*keycode = key->keycode;
@@ -878,18 +945,19 @@ static int asus_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 
 static int asus_setkeycode(struct input_dev *dev, int scancode, int keycode)
 {
+	struct asus_laptop *asus = input_get_drvdata(dev);
 	struct key_entry *key;
 	int old_keycode;
 
 	if (keycode < 0 || keycode > KEY_MAX)
 		return -EINVAL;
 
-	key = asus_get_entry_by_scancode(scancode);
+	key = asus_get_entry_by_scancode(asus, scancode);
 	if (key && key->type == KE_KEY) {
 		old_keycode = key->keycode;
 		key->keycode = keycode;
 		set_bit(keycode, dev->keybit);
-		if (!asus_get_entry_by_keycode(old_keycode))
+		if (!asus_get_entry_by_keycode(asus, old_keycode))
 			clear_bit(old_keycode, dev->keybit);
 		return 0;
 	}
@@ -899,6 +967,7 @@ static int asus_setkeycode(struct input_dev *dev, int scancode, int keycode)
 
 static void asus_acpi_notify(struct acpi_device *device, u32 event)
 {
+	struct asus_laptop *asus = acpi_driver_data(device);
 	static struct key_entry *key;
 	u16 count;
 
@@ -907,11 +976,11 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 	 * switched
 	 */
 	if (event == ATKD_LCD_ON) {
-		write_status(NULL, 1, LCD_ON);
-		lcd_blank(FB_BLANK_UNBLANK);
+		write_status(asus, NULL, 1, LCD_ON);
+		lcd_blank(asus, FB_BLANK_UNBLANK);
 	} else if (event == ATKD_LCD_OFF) {
-		write_status(NULL, 0, LCD_ON);
-		lcd_blank(FB_BLANK_POWERDOWN);
+		write_status(asus, NULL, 0, LCD_ON);
+		lcd_blank(asus, FB_BLANK_POWERDOWN);
 	}
 
 	/* TODO Find a better way to handle events count. */
@@ -922,7 +991,7 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 					count);
 
 	if (asus->inputdev) {
-		key = asus_get_entry_by_scancode(event);
+		key = asus_get_entry_by_scancode(asus, event);
 		if (!key)
 			return ;
 
@@ -978,13 +1047,14 @@ static struct attribute_group platform_attribute_group = {
 	.attrs = asuspf_attributes
 };
 
-static int asus_platform_init(void)
+static int asus_platform_init(struct asus_laptop *asus)
 {
 	int result;
 
 	asus->platform_device = platform_device_alloc(ASUS_LAPTOP_FILE, -1);
 	if (!asus->platform_device)
 		return -ENOMEM;
+	platform_set_drvdata(asus->platform_device, asus);
 
 	result = platform_device_add(asus->platform_device);
 	if (result)
@@ -1003,7 +1073,7 @@ fail_platform_device:
 	return result;
 }
 
-static void asus_platform_exit(void)
+static void asus_platform_exit(struct asus_laptop *asus)
 {
 	sysfs_remove_group(&asus->platform_device->dev.kobj,
 			   &platform_attribute_group);
@@ -1012,12 +1082,12 @@ static void asus_platform_exit(void)
 
 static struct platform_driver platform_driver = {
 	.driver = {
-		   .name = ASUS_LAPTOP_FILE,
-		   .owner = THIS_MODULE,
-		   }
+		.name = ASUS_LAPTOP_FILE,
+		.owner = THIS_MODULE,
+	}
 };
 
-static void asus_laptop_add_fs(void)
+static void asus_laptop_add_fs(struct asus_laptop *asus)
 {
 	ASUS_SET_DEVICE_ATTR(infos, 0444, show_infos, NULL);
 
@@ -1187,7 +1257,7 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	return AE_OK;
 }
 
-static int asus_input_init(struct device *dev)
+static int asus_input_init(struct asus_laptop *asus)
 {
 	const struct key_entry *key;
 	int result;
@@ -1198,13 +1268,16 @@ static int asus_input_init(struct device *dev)
 		return 0;
 	}
 	asus->inputdev->name = "Asus Laptop extra buttons";
-	asus->inputdev->dev.parent = dev;
+	asus->inputdev->dev.parent = &asus->platform_device->dev;
 	asus->inputdev->phys = ASUS_LAPTOP_FILE "/input0";
 	asus->inputdev->id.bustype = BUS_HOST;
 	asus->inputdev->getkeycode = asus_getkeycode;
 	asus->inputdev->setkeycode = asus_setkeycode;
+	input_set_drvdata(asus->inputdev, asus);
 
-	for (key = asus_keymap; key->type != KE_END; key++) {
+	asus->keymap = kmemdup(asus_keymap, sizeof(asus_keymap),
+				GFP_KERNEL);
+	for (key = asus->keymap; key->type != KE_END; key++) {
 		switch (key->type) {
 		case KE_KEY:
 			set_bit(EV_KEY, asus->inputdev->evbit);
@@ -1220,40 +1293,44 @@ static int asus_input_init(struct device *dev)
 	return result;
 }
 
-static void asus_backlight_exit(void)
+static void asus_backlight_exit(struct asus_laptop *asus)
 {
 	if (asus->backlight_device)
 		backlight_device_unregister(asus->backlight_device);
 }
 
-#define  ASUS_LED_UNREGISTER(object)				\
+#define ASUS_LED_UNREGISTER(object)				\
 	if (object##_led.dev)					\
 		led_classdev_unregister(&object##_led)
 
-static void asus_led_exit(void)
+static void asus_led_exit(struct asus_laptop *asus)
 {
-	destroy_workqueue(led_workqueue);
 	ASUS_LED_UNREGISTER(mled);
 	ASUS_LED_UNREGISTER(tled);
 	ASUS_LED_UNREGISTER(pled);
 	ASUS_LED_UNREGISTER(rled);
 	ASUS_LED_UNREGISTER(gled);
 	ASUS_LED_UNREGISTER(kled);
+	if (asus->leds.workqueue) {
+		destroy_workqueue(asus->leds.workqueue);
+		asus->leds.workqueue = NULL;
+	}
 }
 
-static void asus_input_exit(void)
+static void asus_input_exit(struct asus_laptop *asus)
 {
 	if (asus->inputdev)
 		input_unregister_device(asus->inputdev);
 }
 
-static int asus_backlight_init(struct device *dev)
+static int asus_backlight_init(struct asus_laptop *asus)
 {
 	struct backlight_device *bd;
+	struct device *dev = &asus->platform_device->dev;
 
 	if (brightness_set_handle && lcd_switch_handle) {
 		bd = backlight_device_register(ASUS_LAPTOP_FILE, dev,
-					       NULL, &asusbl_ops);
+					       asus, &asusbl_ops);
 		if (IS_ERR(bd)) {
 			pr_err("Could not register asus backlight device\n");
 			asus->backlight_device = NULL;
@@ -1270,79 +1347,55 @@ static int asus_backlight_init(struct device *dev)
 	return 0;
 }
 
-static int asus_led_register(acpi_handle handle,
-			     struct led_classdev *ldev, struct device *dev)
-{
-	if (!handle)
-		return 0;
-
-	return led_classdev_register(dev, ldev);
-}
-
-#define ASUS_LED_REGISTER(object, device)				\
-	asus_led_register(object##_set_handle, &object##_led, device)
-
-static int asus_led_init(struct device *dev)
+/*
+ * Ugly macro, need to fix that later
+ */
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
 {
 	int rv;
 
-	rv = ASUS_LED_REGISTER(mled, dev);
-	if (rv)
-		goto out;
-
-	rv = ASUS_LED_REGISTER(tled, dev);
-	if (rv)
-		goto out1;
-
-	rv = ASUS_LED_REGISTER(rled, dev);
-	if (rv)
-		goto out2;
-
-	rv = ASUS_LED_REGISTER(pled, dev);
-	if (rv)
-		goto out3;
-
-	rv = ASUS_LED_REGISTER(gled, dev);
-	if (rv)
-		goto out4;
-
-	if (kled_set_handle && kled_get_handle)
-		rv = ASUS_LED_REGISTER(kled, dev);
-	if (rv)
-		goto out5;
-
 	/*
 	 * Functions that actually update the LED's are called from a
 	 * workqueue. By doing this as separate work rather than when the LED
 	 * subsystem asks, we avoid messing with the Asus ACPI stuff during a
 	 * potentially bad time, such as a timer interrupt.
 	 */
-	led_workqueue = create_singlethread_workqueue("led_workqueue");
-	if (!led_workqueue)
-		goto out6;
+	asus->leds.workqueue = create_singlethread_workqueue("led_workqueue");
+	if (!asus->leds.workqueue)
+		return -ENOMEM;
 
-	return 0;
-out6:
-	rv = -ENOMEM;
-	ASUS_LED_UNREGISTER(kled);
-out5:
-	ASUS_LED_UNREGISTER(gled);
-out4:
-	ASUS_LED_UNREGISTER(pled);
-out3:
-	ASUS_LED_UNREGISTER(rled);
-out2:
-	ASUS_LED_UNREGISTER(tled);
-out1:
-	ASUS_LED_UNREGISTER(mled);
-out:
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
 	return rv;
 }
 
 
 static bool asus_device_present;
 
-static int __devinit asus_acpi_init(struct acpi_device *device)
+static int __devinit asus_acpi_init(struct asus_laptop *asus)
 {
 	int result = 0;
 
@@ -1358,22 +1411,22 @@ static int __devinit asus_acpi_init(struct acpi_device *device)
 	if (result)
 		return result;
 
-	asus_laptop_add_fs();
+	asus_laptop_add_fs(asus);
 
 	/* WLED and BLED are on by default */
-	write_status(bt_switch_handle, 1, BT_ON);
-	write_status(wl_switch_handle, 1, WL_ON);
+	write_status(asus, bt_switch_handle, 1, BT_ON);
+	write_status(asus, wl_switch_handle, 1, WL_ON);
 
 	/* If the h/w switch is off, we need to check the real status */
-	write_status(NULL, read_status(BT_ON), BT_ON);
-	write_status(NULL, read_status(WL_ON), WL_ON);
+	write_status(asus, NULL, read_status(asus, BT_ON), BT_ON);
+	write_status(asus, NULL, read_status(asus, WL_ON), WL_ON);
 
 	/* LCD Backlight is on by default */
-	write_status(NULL, 1, LCD_ON);
+	write_status(asus, NULL, 1, LCD_ON);
 
 	/* Keyboard Backlight is on by default */
 	if (kled_set_handle)
-		set_kled_lvl(1);
+		set_kled_lvl(asus, 1);
 
 	/* LED display is off by default */
 	asus->ledd_status = 0xFFF;
@@ -1383,18 +1436,19 @@ static int __devinit asus_acpi_init(struct acpi_device *device)
 	hotk->light_level = 5;	/* level 5 for sensor sensitivity */
 
 	if (ls_switch_handle)
-		set_light_sens_switch(asus->light_switch);
+		set_light_sens_switch(asus, asus->light_switch);
 
 	if (ls_level_handle)
-		set_light_sens_level(asus->light_level);
+		set_light_sens_level(asus, asus->light_level);
 
 	/* GPS is on by default */
-	write_status(NULL, 1, GPS_ON);
+	write_status(asus, NULL, 1, GPS_ON);
 	return result;
 }
 
 static int __devinit asus_acpi_add(struct acpi_device *device)
 {
+	struct asus_laptop *asus;
 	int result;
 
 	pr_notice("Asus Laptop Support version %s\n",
@@ -1408,7 +1462,7 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	device->driver_data = asus;
 	asus->device = device;
 
-	result = asus_acpi_init(device);
+	result = asus_acpi_init(asus);
 	if (result)
 		goto fail_platform;
 
@@ -1416,22 +1470,22 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	 * Register the platform device first.  It is used as a parent for the
 	 * sub-devices below.
 	 */
-	result = asus_platform_init();
+	result = asus_platform_init(asus);
 	if (result)
 		goto fail_platform;
 
 	if (!acpi_video_backlight_support()) {
-		result = asus_backlight_init(&asus->platform_device->dev);
+		result = asus_backlight_init(asus);
 		if (result)
 			goto fail_backlight;
 	} else
 		pr_info("Backlight controlled by ACPI video driver\n");
 
-	result = asus_input_init(&asus->platform_device->dev);
+	result = asus_input_init(asus);
 	if (result)
 		goto fail_input;
 
-	result = asus_led_init(&asus->platform_device->dev);
+	result = asus_led_init(asus);
 	if (result)
 		goto fail_led;
 
@@ -1439,11 +1493,11 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	return 0;
 
 fail_led:
-	asus_input_exit();
+	asus_input_exit(asus);
 fail_input:
-	asus_backlight_exit();
+	asus_backlight_exit(asus);
 fail_backlight:
-	asus_platform_exit();
+	asus_platform_exit(asus);
 fail_platform:
 	kfree(asus->name);
 	kfree(asus);
@@ -1453,10 +1507,12 @@ fail_platform:
 
 static int asus_acpi_remove(struct acpi_device *device, int type)
 {
-	asus_backlight_exit();
-	asus_led_exit();
-	asus_input_exit();
-	asus_platform_exit();
+	struct asus_laptop *asus = acpi_driver_data(device);
+
+	asus_backlight_exit(asus);
+	asus_led_exit(asus);
+	asus_input_exit(asus);
+	asus_platform_exit(asus);
 
 	kfree(asus->name);
 	kfree(asus);
-- 
1.6.6.1

