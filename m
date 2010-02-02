Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0BBHw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:28 -0500
Received: from iksaif.net ([88.191.73.63]:50266 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 12/28] asus-laptop: stop using read_status for bluetooth and wlan
Date: Tue,  2 Feb 2010 08:38:55 +0100
Message-Id: <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   55 +++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 940ce3d..cee751e 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -239,6 +239,9 @@ struct asus_laptop {
 
 	struct asus_laptop_leds leds;
 
+	int wireless_status;
+	bool have_rsts;
+
 	acpi_handle handle;	/* the handle of the hotk device */
 	char status;		/* status of the hotk, for LEDs, ... */
 	u32 ledd_status;	/* status of the LED display */
@@ -328,23 +331,6 @@ static int write_acpi_int(acpi_handle handle, const char *method, int val)
 	return write_acpi_int_ret(handle, method, val, NULL);
 }
 
-static int read_wireless_status(struct asus_laptop *asus, int mask)
-{
-	unsigned long long status;
-	acpi_status rv = AE_OK;
-
-	if (!wireless_status_handle)
-		return (asus->status & mask) ? 1 : 0;
-
-	rv = acpi_evaluate_integer(wireless_status_handle, NULL, NULL, &status);
-	if (ACPI_FAILURE(rv))
-		pr_warning("Error reading Wireless status\n");
-	else
-		return (status & mask) ? 1 : 0;
-
-	return (asus->status & mask) ? 1 : 0;
-}
-
 static int read_gps_status(struct asus_laptop *asus)
 {
 	unsigned long long status;
@@ -362,10 +348,7 @@ static int read_gps_status(struct asus_laptop *asus)
 /* Generic LED functions */
 static int read_status(struct asus_laptop *asus, int mask)
 {
-	/* There is a special method for both wireless devices */
-	if (mask == BT_ON || mask == WL_ON)
-		return read_wireless_status(asus, mask);
-	else if (mask == GPS_ON)
+	if (mask == GPS_ON)
 		return read_gps_status(asus);
 
 	return (asus->status & mask) ? 1 : 0;
@@ -812,6 +795,25 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 }
 
 /*
+ * Wireless
+ */
+static int asus_wireless_status(struct asus_laptop *asus, int mask)
+{
+	unsigned long long status;
+	acpi_status rv = AE_OK;
+
+	if (!asus->have_rsts)
+		return (asus->wireless_status & mask) ? 1 : 0;
+
+	rv = acpi_evaluate_integer(wireless_status_handle, NULL, NULL, &status);
+	if (ACPI_FAILURE(rv)) {
+		pr_warning("Error reading Wireless status\n");
+		return -EINVAL;
+	}
+	return !!(status & mask);
+}
+
+/*
  * WLAN
  */
 static ssize_t show_wlan(struct device *dev,
@@ -819,7 +821,7 @@ static ssize_t show_wlan(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", read_status(asus, WL_ON));
+	return sprintf(buf, "%d\n", asus_wireless_status(asus, WL_ON));
 }
 
 static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
@@ -838,7 +840,7 @@ static ssize_t show_bluetooth(struct device *dev,
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", read_status(asus, BT_ON));
+	return sprintf(buf, "%d\n", asus_wireless_status(asus, BT_ON));
 }
 
 static ssize_t store_bluetooth(struct device *dev,
@@ -1371,7 +1373,8 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	if (hwrs_result & BT_HWRS)
 		ASUS_HANDLE_INIT(bt_switch);
 
-	ASUS_HANDLE_INIT(wireless_status);
+	if (!ASUS_HANDLE_INIT(wireless_status))
+		asus->have_rsts = true;
 
 	ASUS_HANDLE_INIT(brightness_set);
 	ASUS_HANDLE_INIT(brightness_get);
@@ -1424,8 +1427,8 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 		write_status(asus, wl_switch_handle, !!wireless_status, WL_ON);
 
 	/* If the h/w switch is off, we need to check the real status */
-	write_status(asus, NULL, read_status(asus, BT_ON), BT_ON);
-	write_status(asus, NULL, read_status(asus, WL_ON), WL_ON);
+	write_status(asus, NULL, asus_wireless_status(asus, BT_ON), BT_ON);
+	write_status(asus, NULL, asus_wireless_status(asus, WL_ON), WL_ON);
 
 	/* LCD Backlight is on by default */
 	write_status(asus, NULL, 1, LCD_ON);
-- 
1.6.6.1

