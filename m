Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab0BZPTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965018Ab0BZPTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:08 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 04/14] dell-laptop: Update rfkill state on kill switch
Date: Fri, 26 Feb 2010 10:18:37 -0500
Message-Id: <1267197527-18062-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rfkill interface on Dells only sends a notification that the switch
has been changed via the keyboard controller. Add a filter so we can
pick these notifications up and update the rfkill state appropriately.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/Kconfig       |    1 +
 drivers/platform/x86/dell-laptop.c |   48 ++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index f526e73..6848f21 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -79,6 +79,7 @@ config DELL_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
 	depends on POWER_SUPPLY
+	depends on SERIO_I8042
 	default n
 	---help---
 	This driver adds support for rfkill and backlight control to Dell
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 3780994..9d7e0be 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -22,6 +22,7 @@
 #include <linux/rfkill.h>
 #include <linux/power_supply.h>
 #include <linux/acpi.h>
+#include <linux/i8042.h>
 #include "../../firmware/dcdbas.h"
 
 #define BRIGHTNESS_TOKEN 0x7d
@@ -214,6 +215,18 @@ static const struct rfkill_ops dell_rfkill_ops = {
 	.query = dell_rfkill_query,
 };
 
+static void dell_update_rfkill(struct work_struct *ignored)
+{
+	if (wifi_rfkill)
+		dell_rfkill_query(wifi_rfkill, (void *)1);
+	if (bluetooth_rfkill)
+		dell_rfkill_query(bluetooth_rfkill, (void *)2);
+	if (wwan_rfkill)
+		dell_rfkill_query(wwan_rfkill, (void *)3);
+}
+static DECLARE_DELAYED_WORK(dell_rfkill_work, dell_update_rfkill);
+
+
 static int __init dell_setup_rfkill(void)
 {
 	struct calling_interface_buffer buffer;
@@ -338,6 +351,30 @@ static struct backlight_ops dell_ops = {
 	.update_status  = dell_send_intensity,
 };
 
+bool dell_laptop_i8042_filter(unsigned char data, unsigned char str,
+			      struct serio *port)
+{
+	static bool extended;
+
+	if (str & 0x20)
+		return false;
+
+	if (unlikely(data == 0xe0)) {
+		extended = true;
+		return false;
+	} else if (unlikely(extended)) {
+		switch (data) {
+		case 0x8:
+			schedule_delayed_work(&dell_rfkill_work,
+					      round_jiffies_relative(HZ));
+			break;
+		}
+		extended = false;
+	}
+
+	return false;
+}
+
 static int __init dell_init(void)
 {
 	struct calling_interface_buffer buffer;
@@ -373,6 +410,13 @@ static int __init dell_init(void)
 		goto fail_rfkill;
 	}
 
+	ret = i8042_install_filter(dell_laptop_i8042_filter);
+	if (ret) {
+		printk(KERN_WARNING
+		       "dell-laptop: Unable to install key filter\n");
+		goto fail_filter;
+	}
+
 #ifdef CONFIG_ACPI
 	/* In the event of an ACPI backlight being available, don't
 	 * register the platform controller.
@@ -410,6 +454,8 @@ static int __init dell_init(void)
 	return 0;
 
 fail_backlight:
+	i8042_remove_filter(dell_laptop_i8042_filter);
+fail_filter:
 	dell_cleanup_rfkill();
 fail_rfkill:
 	platform_device_del(platform_device);
@@ -424,6 +470,8 @@ fail_platform_driver:
 
 static void __exit dell_exit(void)
 {
+	cancel_delayed_work_sync(&dell_rfkill_work);
+	i8042_remove_filter(dell_laptop_i8042_filter);
 	backlight_device_unregister(dell_backlight_device);
 	dell_cleanup_rfkill();
 }
-- 
1.6.6.1

