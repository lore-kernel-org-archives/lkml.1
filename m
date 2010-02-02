Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0BBHzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:55:22 -0500
Received: from iksaif.net ([88.191.73.63]:50271 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 09/28] asus-laptop: move backlight and dsdt info inside asus_laptop struct
Date: Tue,  2 Feb 2010 08:38:52 +0100
Message-Id: <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the use of "driver data" for callbacks.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   69 +++++++++++++++--------------------
 1 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 2505f15..4ff30ca 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -202,30 +202,24 @@ ASUS_HANDLE(kled_get, ASUS_LAPTOP_PREFIX "GLKB");
 struct asus_laptop {
 	char *name;		/* laptop name */
 
+	struct acpi_table_header *dsdt_info;
 	struct platform_device *platform_device;
-	struct acpi_device *device;	/* the device we are in */
+	struct acpi_device *device;		/* the device we are in */
+	struct backlight_device *backlight_device;
+	struct input_dev *inputdev;
+
 	acpi_handle handle;	/* the handle of the hotk device */
 	char status;		/* status of the hotk, for LEDs, ... */
 	u32 ledd_status;	/* status of the LED display */
 	u8 light_level;		/* light sensor level */
 	u8 light_switch;	/* light sensor switch value */
 	u16 event_count[128];	/* count for each event TODO make this better */
-	struct input_dev *inputdev;
 	u16 *keycode_map;
 };
 
-/*
- * This header is made available to allow proper configuration given model,
- * revision number , ... this info cannot go in struct asus_laptop because it is
- * available before the hotk
- */
-static struct acpi_table_header *asus_info;
-
-/* The actual device the driver binds to */
 static struct asus_laptop *asus;
 
-/* The backlight device /sys/class/backlight */
-static struct backlight_device *asus_backlight_device;
+static struct workqueue_struct *led_workqueue;
 
 /*
  * The backlight class declaration
@@ -237,14 +231,6 @@ static struct backlight_ops asusbl_ops = {
 	.update_status = update_bl_status,
 };
 
-/*
- * These functions actually update the LED's, and are called from a
- * workqueue. By doing this as separate work rather than when the LED
- * subsystem asks, we avoid messing with the Asus ACPI stuff during a
- * potentially bad time, such as a timer interrupt.
- */
-static struct workqueue_struct *led_workqueue;
-
 #define ASUS_LED(object, ledname, max)					\
 	static void object##_led_set(struct led_classdev *led_cdev,	\
 				     enum led_brightness value);	\
@@ -522,7 +508,7 @@ static int set_lcd_state(int value)
 
 static void lcd_blank(int blank)
 {
-	struct backlight_device *bd = asus_backlight_device;
+	struct backlight_device *bd = asus->backlight_device;
 
 	if (bd) {
 		bd->props.power = blank;
@@ -619,22 +605,22 @@ static ssize_t show_infos(struct device *dev,
 	if (!ACPI_FAILURE(rv))
 		len += sprintf(page + len, "ASYM value         : %#x\n",
 			       (uint) temp);
-	if (asus_info) {
-		snprintf(buf, 16, "%d", asus_info->length);
+	if (asus->dsdt_info) {
+		snprintf(buf, 16, "%d", asus->dsdt_info->length);
 		len += sprintf(page + len, "DSDT length        : %s\n", buf);
-		snprintf(buf, 16, "%d", asus_info->checksum);
+		snprintf(buf, 16, "%d", asus->dsdt_info->checksum);
 		len += sprintf(page + len, "DSDT checksum      : %s\n", buf);
-		snprintf(buf, 16, "%d", asus_info->revision);
+		snprintf(buf, 16, "%d", asus->dsdt_info->revision);
 		len += sprintf(page + len, "DSDT revision      : %s\n", buf);
-		snprintf(buf, 7, "%s", asus_info->oem_id);
+		snprintf(buf, 7, "%s", asus->dsdt_info->oem_id);
 		len += sprintf(page + len, "OEM id             : %s\n", buf);
-		snprintf(buf, 9, "%s", asus_info->oem_table_id);
+		snprintf(buf, 9, "%s", asus->dsdt_info->oem_table_id);
 		len += sprintf(page + len, "OEM table id       : %s\n", buf);
-		snprintf(buf, 16, "%x", asus_info->oem_revision);
+		snprintf(buf, 16, "%x", asus->dsdt_info->oem_revision);
 		len += sprintf(page + len, "OEM revision       : 0x%s\n", buf);
-		snprintf(buf, 5, "%s", asus_info->asl_compiler_id);
+		snprintf(buf, 5, "%s", asus->dsdt_info->asl_compiler_id);
 		len += sprintf(page + len, "ASL comp vendor id : %s\n", buf);
-		snprintf(buf, 16, "%x", asus_info->asl_compiler_revision);
+		snprintf(buf, 16, "%x", asus->dsdt_info->asl_compiler_revision);
 		len += sprintf(page + len, "ASL comp revision  : 0x%s\n", buf);
 	}
 
@@ -1084,7 +1070,7 @@ static int asus_handle_init(char *name, acpi_handle * handle,
  * method, we can make all the detection we want, and modify the asus_laptop
  * struct
  */
-static int asus_laptop_get_info(void)
+static int asus_laptop_get_info(struct asus_laptop *asus)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *model = NULL;
@@ -1097,10 +1083,9 @@ static int asus_laptop_get_info(void)
 	 * models, but late enough to allow acpi_bus_register_driver() to fail
 	 * before doing anything ACPI-specific. Should we encounter a machine,
 	 * which needs special handling (i.e. its hotkey device has a different
-	 * HID), this bit will be moved. A global variable asus_info contains
-	 * the DSDT header.
+	 * HID), this bit will be moved.
 	 */
-	status = acpi_get_table(ACPI_SIG_DSDT, 1, &asus_info);
+	status = acpi_get_table(ACPI_SIG_DSDT, 1, &asus->dsdt_info);
 	if (ACPI_FAILURE(status))
 		pr_warning("Couldn't get the DSDT table header\n");
 
@@ -1237,8 +1222,8 @@ static int asus_input_init(struct device *dev)
 
 static void asus_backlight_exit(void)
 {
-	if (asus_backlight_device)
-		backlight_device_unregister(asus_backlight_device);
+	if (asus->backlight_device)
+		backlight_device_unregister(asus->backlight_device);
 }
 
 #define  ASUS_LED_UNREGISTER(object)				\
@@ -1271,11 +1256,11 @@ static int asus_backlight_init(struct device *dev)
 					       NULL, &asusbl_ops);
 		if (IS_ERR(bd)) {
 			pr_err("Could not register asus backlight device\n");
-			asus_backlight_device = NULL;
+			asus->backlight_device = NULL;
 			return PTR_ERR(bd);
 		}
 
-		asus_backlight_device = bd;
+		asus->backlight_device = bd;
 
 		bd->props.max_brightness = 15;
 		bd->props.brightness = read_brightness(NULL);
@@ -1326,6 +1311,12 @@ static int asus_led_init(struct device *dev)
 	if (rv)
 		goto out5;
 
+	/*
+	 * Functions that actually update the LED's are called from a
+	 * workqueue. By doing this as separate work rather than when the LED
+	 * subsystem asks, we avoid messing with the Asus ACPI stuff during a
+	 * potentially bad time, such as a timer interrupt.
+	 */
 	led_workqueue = create_singlethread_workqueue("led_workqueue");
 	if (!led_workqueue)
 		goto out6;
@@ -1363,7 +1354,7 @@ static int __devinit asus_acpi_init(struct acpi_device *device)
 		return -ENODEV;
 	}
 
-	result = asus_laptop_get_info();
+	result = asus_laptop_get_info(asus);
 	if (result)
 		return result;
 
-- 
1.6.6.1

