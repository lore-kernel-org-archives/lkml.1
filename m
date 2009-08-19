Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZHSSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZHSSf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZHSSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:35:28 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:23099 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZHSSf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:35:27 -0400
X-Loopcount0: from 10.9.160.253
From: Mario Limonciello <Mario_Limonciello@Dell.com>
To: cezary.jackiewicz@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       Mario Limonciello <Mario_Limonciello@Dell.com>
Subject: [PATCH 2/3] Add rfkill support to compal-laptop
Date: Wed, 19 Aug 2009 13:36:09 -0500
Message-Id: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Reviewed-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/compal-laptop.c |   87 +++++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index c1c8c03..da7ead6 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -52,6 +52,7 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
+#include <linux/rfkill.h>
 
 #define COMPAL_DRIVER_VERSION "0.2.6"
 
@@ -64,6 +65,10 @@
 #define WLAN_MASK	0x01
 #define BT_MASK 	0x02
 
+static struct rfkill *wifi_rfkill;
+static struct rfkill *bt_rfkill;
+static struct platform_device *compal_device;
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -89,6 +94,77 @@ static int get_lcd_level(void)
 	return (int) result;
 }
 
+static int compal_rfkill_set(void *data, bool blocked)
+{
+	unsigned long radio = (unsigned long) data;
+	u8 result, value;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	if (!blocked)
+		value = (u8) (result | radio);
+	else
+		value = (u8) (result & ~radio);
+	ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+
+	return 0;
+}
+
+static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
+{
+	u8 result;
+	bool hw_blocked;
+
+	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+
+	hw_blocked = !(result & KILLSWITCH_MASK);
+	rfkill_set_hw_state(rfkill, hw_blocked);
+}
+
+static const struct rfkill_ops compal_rfkill_ops = {
+	.poll = compal_rfkill_poll,
+	.set_block = compal_rfkill_set,
+};
+
+static int setup_rfkill(void)
+{
+	int ret;
+
+	wifi_rfkill = rfkill_alloc("compal-wifi", &compal_device->dev,
+				RFKILL_TYPE_WLAN, &compal_rfkill_ops,
+				(void *) WLAN_MASK);
+	if (!wifi_rfkill)
+		return -ENOMEM;
+
+	ret = rfkill_register(wifi_rfkill);
+	if (ret)
+		goto err_wifi;
+
+	bt_rfkill = rfkill_alloc("compal-bluetooth", &compal_device->dev,
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,
+				(void *) BT_MASK);
+	if (!bt_rfkill) {
+		ret = -ENOMEM;
+		goto err_allocate_bt;
+	}
+	ret = rfkill_register(bt_rfkill);
+	if (ret)
+		goto err_register_bt;
+
+	return 0;
+
+err_register_bt:
+	rfkill_destroy(bt_rfkill);
+
+err_allocate_bt:
+	rfkill_unregister(wifi_rfkill);
+
+err_wifi:
+	rfkill_destroy(wifi_rfkill);
+
+	return ret;
+}
+
 static int set_wlan_state(int state)
 {
 	u8 result, value;
@@ -258,8 +334,6 @@ static struct platform_driver compal_driver = {
 	}
 };
 
-static struct platform_device *compal_device;
-
 /* Initialization */
 
 static int dmi_check_cb(const struct dmi_system_id *id)
@@ -397,11 +471,16 @@ static int __init compal_init(void)
 	if (ret)
 		goto fail_platform_device2;
 
+	ret = setup_rfkill();
+	if (ret)
+		goto fail_rfkill;
+
 	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
 		" successfully loaded.\n");
 
 	return 0;
 
+fail_rfkill:
 fail_platform_device2:
 
 	platform_device_del(compal_device);
@@ -428,6 +507,10 @@ static void __exit compal_cleanup(void)
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
+	rfkill_unregister(wifi_rfkill);
+	rfkill_destroy(wifi_rfkill);
+	rfkill_unregister(bt_rfkill);
+	rfkill_destroy(bt_rfkill);
 
 	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
 }
-- 
1.6.3.3

