Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0BBHyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:54:13 -0500
Received: from iksaif.net ([88.191.73.63]:50264 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0BBHwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:12 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 14/28] asus-laptop: stop using read_status for lcd
Date: Tue,  2 Feb 2010 08:38:57 +0100
Message-Id: <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(anyway lcd code is scheduled for removal)

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   37 +++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index ea51d7e..d726db3 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -241,6 +241,7 @@ struct asus_laptop {
 
 	int wireless_status;
 	bool have_rsts;
+	int lcd_state;
 
 	acpi_handle handle;	/* the handle of the hotk device */
 	char status;		/* status of the hotk, for LEDs, ... */
@@ -538,30 +539,33 @@ error:
 /*
  * Backlight device
  */
-static int get_lcd_state(struct asus_laptop *asus)
+static int asus_lcd_status(struct asus_laptop *asus)
 {
-	return read_status(asus, LCD_ON);
+	return asus->lcd_state;
 }
 
-static int set_lcd_state(struct asus_laptop *asus, int value)
+static int asus_lcd_set(struct asus_laptop *asus, int value)
 {
 	int lcd = 0;
 	acpi_status status = 0;
 
-	lcd = value ? 1 : 0;
+	lcd = !!value;
 
-	if (lcd == get_lcd_state(asus))
+	if (lcd == asus_lcd_status(asus))
 		return 0;
 
-	if (lcd_switch_handle) {
-		status = acpi_evaluate_object(lcd_switch_handle,
-					      NULL, NULL, NULL);
+	if (!lcd_switch_handle)
+		return -ENODEV;
+
+	status = acpi_evaluate_object(lcd_switch_handle,
+				      NULL, NULL, NULL);
 
-		if (ACPI_FAILURE(status))
-			pr_warning("Error switching LCD\n");
+	if (ACPI_FAILURE(status)) {
+		pr_warning("Error switching LCD\n");
+		return -ENODEV;
 	}
 
-	write_status(asus, NULL, lcd, LCD_ON);
+	asus->lcd_state = lcd;
 	return 0;
 }
 
@@ -569,6 +573,8 @@ static void lcd_blank(struct asus_laptop *asus, int blank)
 {
 	struct backlight_device *bd = asus->backlight_device;
 
+	asus->lcd_state = (blank == FB_BLANK_UNBLANK);
+
 	if (bd) {
 		bd->props.power = blank;
 		backlight_update_status(bd);
@@ -607,7 +613,7 @@ static int update_bl_status(struct backlight_device *bd)
 		return rv;
 
 	value = (bd->props.power == FB_BLANK_UNBLANK) ? 1 : 0;
-	return set_lcd_state(asus, value);
+	return asus_lcd_set(asus, value);
 }
 
 static struct backlight_ops asusbl_ops = {
@@ -1144,13 +1150,10 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 	 * We need to tell the backlight device when the backlight power is
 	 * switched
 	 */
-	if (event == ATKD_LCD_ON) {
-		write_status(asus, NULL, 1, LCD_ON);
+	if (event == ATKD_LCD_ON)
 		lcd_blank(asus, FB_BLANK_UNBLANK);
-	} else if (event == ATKD_LCD_OFF) {
-		write_status(asus, NULL, 0, LCD_ON);
+	else if (event == ATKD_LCD_OFF)
 		lcd_blank(asus, FB_BLANK_POWERDOWN);
-	}
 
 	/* TODO Find a better way to handle events count. */
 	count = asus->event_count[event % 128]++;
-- 
1.6.6.1

