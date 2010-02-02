Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0BBHzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:55:19 -0500
Received: from iksaif.net ([88.191.73.63]:50269 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 25/28] asus-laptop: add gps rfkill
Date: Tue,  2 Feb 2010 08:39:08 +0100
Message-Id: <1265096351-15239-26-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-25-git-send-email-corentincj@iksaif.net>
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
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-21-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-22-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-23-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-24-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-25-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rfkill subsystem will enable gps by default.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig       |    1 +
 drivers/platform/x86/asus-laptop.c |   65 ++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7f5a222..527abf1 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -59,6 +59,7 @@ config ASUS_LAPTOP
 	select NEW_LEDS
 	select BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
+	depends on RFKILL || RFKILL = n
 	select INPUT_SPARSEKMAP
 	---help---
 	  This is the new Linux driver for Asus laptops. It may also support some
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 1d61094..e1df92a 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -50,6 +50,7 @@
 #include <asm/uaccess.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/rfkill.h>
 
 #define ASUS_LAPTOP_VERSION	"0.42"
 
@@ -238,6 +239,8 @@ struct asus_laptop {
 	bool have_rsts;
 	int lcd_state;
 
+	struct rfkill *gps_rfkill;
+
 	acpi_handle handle;	/* the handle of the hotk device */
 	u32 ledd_status;	/* status of the LED display */
 	u8 light_level;		/* light sensor level */
@@ -1006,7 +1009,6 @@ static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 
 /*
  * GPS
- * TODO: use rfkill
  */
 static int asus_gps_status(struct asus_laptop *asus)
 {
@@ -1052,10 +1054,58 @@ static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 	ret = asus_gps_switch(asus, !!value);
 	if (ret)
 		return ret;
+	rfkill_set_sw_state(asus->gps_rfkill, !value);
 	return rv;
 }
 
 /*
+ * rfkill
+ */
+static int asus_gps_rfkill_set(void *data, bool blocked)
+{
+	acpi_handle handle = data;
+
+	return asus_gps_switch(handle, !blocked);
+}
+
+static const struct rfkill_ops asus_gps_rfkill_ops = {
+	.set_block = asus_gps_rfkill_set,
+};
+
+static void asus_rfkill_exit(struct asus_laptop *asus)
+{
+	if (asus->gps_rfkill) {
+		rfkill_unregister(asus->gps_rfkill);
+		rfkill_destroy(asus->gps_rfkill);
+		asus->gps_rfkill = NULL;
+	}
+}
+
+static int asus_rfkill_init(struct asus_laptop *asus)
+{
+	int result;
+
+	if (acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) ||
+	    acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) ||
+	    acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
+		return 0;
+
+	asus->gps_rfkill = rfkill_alloc("asus-gps", &asus->platform_device->dev,
+					RFKILL_TYPE_GPS,
+					&asus_gps_rfkill_ops, NULL);
+	if (!asus->gps_rfkill)
+		return -EINVAL;
+
+	result = rfkill_register(asus->gps_rfkill);
+	if (result) {
+		rfkill_destroy(asus->gps_rfkill);
+		asus->gps_rfkill = NULL;
+	}
+
+	return result;
+}
+
+/*
  * Input device (i.e. hotkeys)
  */
 static void asus_input_notify(struct asus_laptop *asus, int event)
@@ -1416,12 +1466,6 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 		asus_als_level(asus, asus->light_level);
 	}
 
-	/* GPS is on by default */
-	if (!acpi_check_handle(asus->handle, METHOD_GPS_ON, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_GPS_OFF, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
-		asus_gps_switch(asus, 1);
-
 	asus->lcd_state = 1; /* LCD should be on when the module load */
 	return result;
 }
@@ -1469,9 +1513,15 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	if (result)
 		goto fail_led;
 
+	result = asus_rfkill_init(asus);
+	if (result)
+		goto fail_rfkill;
+
 	asus_device_present = true;
 	return 0;
 
+fail_rfkill:
+	asus_led_exit(asus);
 fail_led:
 	asus_input_exit(asus);
 fail_input:
@@ -1490,6 +1540,7 @@ static int asus_acpi_remove(struct acpi_device *device, int type)
 	struct asus_laptop *asus = acpi_driver_data(device);
 
 	asus_backlight_exit(asus);
+	asus_rfkill_exit(asus);
 	asus_led_exit(asus);
 	asus_input_exit(asus);
 	asus_platform_exit(asus);
-- 
1.6.6.1

