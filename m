Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0BBHwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:12 -0500
Received: from iksaif.net ([88.191.73.63]:50248 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0BBHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 18/28] asus-laptop: add error check for write_acpi_int calls
Date: Tue,  2 Feb 2010 08:39:01 +0100
Message-Id: <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
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
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add to helpers for bluetooth and wlan.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 671fad9..aad6b93 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -350,7 +350,7 @@ static int acpi_check_handle(acpi_handle handle, const char *method,
 }
 
 /* Generic LED function */
-static void asus_led_set(struct asus_laptop *asus, char *method,
+static int asus_led_set(struct asus_laptop *asus, char *method,
 			 int value)
 {
 	if (!strcmp(method, METHOD_MLED))
@@ -360,7 +360,7 @@ static void asus_led_set(struct asus_laptop *asus, char *method,
 	else
 		value = !!value;
 
-	write_acpi_int(asus->handle, method, value);
+	return write_acpi_int(asus->handle, method, value);
 }
 
 /*
@@ -817,6 +817,15 @@ static int asus_wireless_status(struct asus_laptop *asus, int mask)
 /*
  * WLAN
  */
+static int asus_wlan_set(struct asus_laptop *asus, int status)
+{
+	if (write_acpi_int(asus->handle, METHOD_WLAN, !!status)) {
+		pr_warning("Error setting wlan status to %d", status);
+		return -EIO;
+	}
+	return 0;
+}
+
 static ssize_t show_wlan(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
@@ -836,6 +845,15 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 /*
  * Bluetooth
  */
+static int asus_bluetooth_set(struct asus_laptop *asus, int status)
+{
+	if (write_acpi_int(asus->handle, METHOD_BLUETOOTH, !!status)) {
+		pr_warning("Error setting bluetooth status to %d", status);
+		return -EIO;
+	}
+	return 0;
+}
+
 static ssize_t show_bluetooth(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -1353,8 +1371,8 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 		       (uint) bsts_result);
 
 	/* This too ... */
-	write_acpi_int(asus->handle, "CWAP", wapf);
-
+	if (write_acpi_int(asus->handle, "CWAP", wapf))
+		pr_err("Error calling CWAP(%d)\n", wapf);
 	/*
 	 * Try to match the object returned by INIT to the specific model.
 	 * Handle every possible object (or the lack of thereof) the DSDT
@@ -1426,11 +1444,10 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 
 	/* WLED and BLED are on by default */
 	if (bluetooth_status >= 0)
-		write_acpi_int(asus->handle, METHOD_BLUETOOTH,
-			       !!bluetooth_status);
+		asus_bluetooth_set(asus, !!bluetooth_status);
+
 	if (wireless_status >= 0)
-		write_acpi_int(asus->handle, METHOD_WLAN,
-			       !!wireless_status);
+		asus_wlan_set(asus, !!wireless_status);
 
 	/* Keyboard Backlight is on by default */
 	if (!acpi_check_handle(asus->handle, METHOD_KBD_LIGHT_SET, NULL))
-- 
1.6.6.1

