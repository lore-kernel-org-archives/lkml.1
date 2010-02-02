Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0BBHrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:47:12 -0500
Received: from iksaif.net ([88.191.73.63]:48710 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0BBHrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:47:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 04/28] asus-laptop: simplify write_acpi_int
Date: Tue,  2 Feb 2010 08:38:47 +0100
Message-Id: <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need a buffer for "INIT". Adds write_acpi_init_ret for it.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 013ab86..7058cb5 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -352,8 +352,8 @@ static struct key_entry asus_keymap[] = {
  *
  * returns 0 if write is successful, -1 else.
  */
-static int write_acpi_int(acpi_handle handle, const char *method, int val,
-			  struct acpi_buffer *output)
+static int write_acpi_int_ret(acpi_handle handle, const char *method, int val,
+			      struct acpi_buffer *output)
 {
 	struct acpi_object_list params;	/* list of input parameters (an int) */
 	union acpi_object in_obj;	/* the only param we use */
@@ -374,6 +374,11 @@ static int write_acpi_int(acpi_handle handle, const char *method, int val,
 		return -1;
 }
 
+static int write_acpi_int(acpi_handle handle, const char *method, int val)
+{
+	return write_acpi_int_ret(handle, method, val, NULL);
+}
+
 static int read_wireless_status(int mask)
 {
 	unsigned long long status;
@@ -437,7 +442,7 @@ static void write_status(acpi_handle handle, int out, int mask)
 		break;
 	}
 
-	if (write_acpi_int(handle, NULL, out, NULL))
+	if (write_acpi_int(handle, NULL, out))
 		pr_warning(" write failed %x\n", mask);
 }
 
@@ -496,7 +501,7 @@ static int set_kled_lvl(int kblv)
 	else
 		kblv = 0;
 
-	if (write_acpi_int(kled_set_handle, NULL, kblv, NULL)) {
+	if (write_acpi_int(kled_set_handle, NULL, kblv)) {
 		pr_warning("Keyboard LED display write failed\n");
 		return -EINVAL;
 	}
@@ -571,7 +576,7 @@ static int read_brightness(struct backlight_device *bd)
 
 static int set_brightness(struct backlight_device *bd, int value)
 {
-	if (write_acpi_int(brightness_set_handle, NULL, value, NULL)) {
+	if (write_acpi_int(brightness_set_handle, NULL, value)) {
 		pr_warning("Error changing brightness\n");
 		return -EIO;
 	}
@@ -710,7 +715,7 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0) {
-		if (write_acpi_int(ledd_set_handle, NULL, value, NULL))
+		if (write_acpi_int(ledd_set_handle, NULL, value))
 			pr_warning("LED display write failed\n");
 		else
 			hotk->ledd_status = (u32) value;
@@ -755,7 +760,7 @@ static ssize_t store_bluetooth(struct device *dev,
 static void set_display(int value)
 {
 	/* no sanity check needed for now */
-	if (write_acpi_int(display_set_handle, NULL, value, NULL))
+	if (write_acpi_int(display_set_handle, NULL, value))
 		pr_warning("Error setting display\n");
 	return;
 }
@@ -814,7 +819,7 @@ static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
  */
 static void set_light_sens_switch(int value)
 {
-	if (write_acpi_int(ls_switch_handle, NULL, value, NULL))
+	if (write_acpi_int(ls_switch_handle, NULL, value))
 		pr_warning("Error setting light sensor switch\n");
 	hotk->light_switch = value;
 }
@@ -839,7 +844,7 @@ static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
 
 static void set_light_sens_level(int value)
 {
-	if (write_acpi_int(ls_level_handle, NULL, value, NULL))
+	if (write_acpi_int(ls_level_handle, NULL, value))
 		pr_warning("Error setting light sensor level\n");
 	hotk->light_level = value;
 }
@@ -1104,7 +1109,7 @@ static int asus_hotk_get_info(void)
 		pr_warning("Couldn't get the DSDT table header\n");
 
 	/* We have to write 0 on init this far for all ASUS models */
-	if (write_acpi_int(hotk->handle, "INIT", 0, &buffer)) {
+	if (write_acpi_int_ret(hotk->handle, "INIT", 0, &buffer)) {
 		pr_err("Hotkey initialization failed\n");
 		return -ENODEV;
 	}
@@ -1119,7 +1124,7 @@ static int asus_hotk_get_info(void)
 		       (uint) bsts_result);
 
 	/* This too ... */
-	write_acpi_int(hotk->handle, "CWAP", wapf, NULL);
+	write_acpi_int(hotk->handle, "CWAP", wapf);
 
 	/*
 	 * Try to match the object returned by INIT to the specific model.
-- 
1.6.6.1

