Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0BBH4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:56:31 -0500
Received: from iksaif.net ([88.191.73.63]:50262 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab0BBHwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:09 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 15/28] asus-laptop: removing read_status/store_status/write_status and asus->status
Date: Tue,  2 Feb 2010 08:38:58 +0100
Message-Id: <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   81 +++++++++++-------------------------
 1 files changed, 24 insertions(+), 57 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index d726db3..2349e88 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -107,16 +107,8 @@ MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
  * Flags for hotk status
  * WL_ON and BT_ON are also used for wireless_status()
  */
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
+#define WL_RSTS		0x01	/* internal Wifi */
+#define BT_RSTS		0x02	/* internal Bluetooth */
 
 #define ASUS_HANDLE(object, paths...)					\
 	static acpi_handle  object##_handle = NULL;			\
@@ -244,7 +236,6 @@ struct asus_laptop {
 	int lcd_state;
 
 	acpi_handle handle;	/* the handle of the hotk device */
-	char status;		/* status of the hotk, for LEDs, ... */
 	u32 ledd_status;	/* status of the LED display */
 	u8 light_level;		/* light sensor level */
 	u8 light_switch;	/* light sensor switch value */
@@ -332,35 +323,18 @@ static int write_acpi_int(acpi_handle handle, const char *method, int val)
 	return write_acpi_int_ret(handle, method, val, NULL);
 }
 
-/* Generic LED functions */
-static int read_status(struct asus_laptop *asus, int mask)
+/* Generic LED function */
+static void asus_led_set(struct asus_laptop *asus, acpi_handle handle,
+			 int value)
 {
-	return (asus->status & mask) ? 1 : 0;
-}
-
-static void write_status(struct asus_laptop *asus, acpi_handle handle,
-			 int out, int mask)
-{
-	asus->status = (out) ? (asus->status | mask) : (asus->status & ~mask);
-
-	switch (mask) {
-	case MLED_ON:
-		out = !(out & 0x1);
-		break;
-	case GLED_ON:
-		out = (out & 0x1) + 1;
-		break;
-	case GPS_ON:
-		handle = (out) ? gps_on_handle : gps_off_handle;
-		out = 0x02;
-		break;
-	default:
-		out &= 0x1;
-		break;
-	}
+	if (handle == mled_set_handle)
+		value = !value;
+	else if (handle == gled_set_handle)
+		value = !value + 1;
+	else
+		value = !!value;
 
-	if (write_acpi_int(handle, NULL, out))
-		pr_warning(" write failed %x\n", mask);
+	write_acpi_int(handle, NULL, value);
 }
 
 /*
@@ -403,7 +377,7 @@ ASUS_LED(kled, "kbd_backlight", 3);
 		struct asus_laptop *asus = work_to_asus(work, object);	\
 									\
 		int value = asus->leds.object##_wk;			\
-		write_status(asus, object##_set_handle, value, (mask));	\
+		asus_led_set(asus, object##_set_handle, value);		\
 	}								\
 	static enum led_brightness object##_led_get(			\
 		struct led_classdev *led_cdev)				\
@@ -740,9 +714,9 @@ static int parse_arg(const char *buf, unsigned long count, int *val)
 	return count;
 }
 
-static ssize_t store_status(struct asus_laptop *asus,
-			    const char *buf, size_t count,
-			    acpi_handle handle, int mask)
+static ssize_t sysfs_acpi_set(struct asus_laptop *asus,
+			      const char *buf, size_t count,
+			      acpi_handle handle)
 {
 	int rv, value;
 	int out = 0;
@@ -751,8 +725,8 @@ static ssize_t store_status(struct asus_laptop *asus,
 	if (rv > 0)
 		out = value ? 1 : 0;
 
-	write_status(asus, handle, out, mask);
-
+	if (write_acpi_int(handle, NULL, value))
+		return -ENODEV;
 	return rv;
 }
 
@@ -810,7 +784,7 @@ static ssize_t show_wlan(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", asus_wireless_status(asus, WL_ON));
+	return sprintf(buf, "%d\n", asus_wireless_status(asus, WL_RSTS));
 }
 
 static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
@@ -818,7 +792,7 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return store_status(asus, buf, count, wl_switch_handle, WL_ON);
+	return sysfs_acpi_set(asus, buf, count, wl_switch_handle);
 }
 
 /*
@@ -829,7 +803,7 @@ static ssize_t show_bluetooth(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", asus_wireless_status(asus, BT_ON));
+	return sprintf(buf, "%d\n", asus_wireless_status(asus, BT_RSTS));
 }
 
 static ssize_t store_bluetooth(struct device *dev,
@@ -838,7 +812,7 @@ static ssize_t store_bluetooth(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return store_status(asus, buf, count, bt_switch_handle, BT_ON);
+	return sysfs_acpi_set(asus, buf, count, bt_switch_handle);
 }
 
 /*
@@ -1439,16 +1413,9 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 
 	/* WLED and BLED are on by default */
 	if (bluetooth_status >= 0)
-		write_status(asus, bt_switch_handle, !!bluetooth_status, BT_ON);
+		write_acpi_int(bt_switch_handle, NULL, !!bluetooth_status);
 	if (wireless_status >= 0)
-		write_status(asus, wl_switch_handle, !!wireless_status, WL_ON);
-
-	/* If the h/w switch is off, we need to check the real status */
-	write_status(asus, NULL, asus_wireless_status(asus, BT_ON), BT_ON);
-	write_status(asus, NULL, asus_wireless_status(asus, WL_ON), WL_ON);
-
-	/* LCD Backlight is on by default */
-	write_status(asus, NULL, 1, LCD_ON);
+		write_acpi_int(wl_switch_handle, NULL, !!wireless_status);
 
 	/* Keyboard Backlight is on by default */
 	if (kled_set_handle)
-- 
1.6.6.1

