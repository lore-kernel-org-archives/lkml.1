Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZHSOML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZHSOML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZHSOMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:12:08 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:52688 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752561AbZHSOMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:12:06 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mjg@redhat.com
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 3/5] dell-laptop: create a platform device as a parent for the rfkill devices etc.
Date: Wed, 19 Aug 2009 15:06:49 +0100
Message-Id: <1250690811-21203-3-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4A8C0623.8030808@tuffmail.co.uk>
References: <4A8C0623.8030808@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dell-laptop may not need to export any sysfs files, but it should still
create a platform device as a parent for the rfkill and backlight
devices.  Otherwise sysfs will display these as "virtual" devices,
with no connection to either physical hardware or the dell-laptop
module.

Apparently this is useful for hardware detection.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/dell-laptop.c |   38 ++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 8fbff38..a13a9f7 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -58,6 +58,14 @@ static int da_command_code;
 static int da_num_tokens;
 static struct calling_interface_token *da_tokens;
 
+static struct platform_driver platform_driver = {
+	.driver = {
+		.name = "dell-laptop",
+		.owner = THIS_MODULE,
+	}
+};
+
+static struct platform_device *platform_device;
 static struct backlight_device *dell_backlight_device;
 static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
@@ -217,7 +225,8 @@ static int dell_setup_rfkill(void)
 	status = buffer.output[1];
 
 	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
-		wifi_rfkill = rfkill_alloc("dell-wifi", NULL, RFKILL_TYPE_WLAN,
+		wifi_rfkill = rfkill_alloc("dell-wifi", &platform_device->dev,
+					   RFKILL_TYPE_WLAN,
 					   &dell_rfkill_ops, (void *) 1);
 		if (!wifi_rfkill) {
 			ret = -ENOMEM;
@@ -229,7 +238,8 @@ static int dell_setup_rfkill(void)
 	}
 
 	if ((status & (1<<3|1<<9)) == (1<<3|1<<9)) {
-		bluetooth_rfkill = rfkill_alloc("dell-bluetooth", NULL,
+		bluetooth_rfkill = rfkill_alloc("dell-bluetooth",
+						&platform_device->dev,
 						RFKILL_TYPE_BLUETOOTH,
 						&dell_rfkill_ops, (void *) 2);
 		if (!bluetooth_rfkill) {
@@ -242,7 +252,9 @@ static int dell_setup_rfkill(void)
 	}
 
 	if ((status & (1<<4|1<<10)) == (1<<4|1<<10)) {
-		wwan_rfkill = rfkill_alloc("dell-wwan", NULL, RFKILL_TYPE_WWAN,
+		wwan_rfkill = rfkill_alloc("dell-wwan",
+					   &platform_device->dev,
+					   RFKILL_TYPE_WWAN,
 					   &dell_rfkill_ops, (void *) 3);
 		if (!wwan_rfkill) {
 			ret = -ENOMEM;
@@ -342,6 +354,18 @@ static int __init dell_init(void)
 		return -ENODEV;
 	}
 
+	ret = platform_driver_register(&platform_driver);
+	if (ret)
+		goto fail_platform_driver;
+	platform_device = platform_device_alloc("dell-laptop", -1);
+	if (!platform_device) {
+		ret = -ENOMEM;
+		goto fail_platform_device1;
+	}
+	ret = platform_device_add(platform_device);
+	if (ret)
+		goto fail_platform_device2;
+
 	ret = dell_setup_rfkill();
 
 	if (ret) {
@@ -368,7 +392,7 @@ static int __init dell_init(void)
 	if (max_intensity) {
 		dell_backlight_device = backlight_device_register(
 			"dell_backlight",
-			NULL, NULL,
+			&platform_device->dev, NULL,
 			&dell_ops);
 
 		if (IS_ERR(dell_backlight_device)) {
@@ -388,6 +412,12 @@ static int __init dell_init(void)
 fail_backlight:
 	dell_cleanup_rfkill();
 fail_rfkill:
+	platform_device_del(platform_device);
+fail_platform_device2:
+	platform_device_put(platform_device);
+fail_platform_device1:
+	platform_driver_unregister(&platform_driver);
+fail_platform_driver:
 	kfree(da_tokens);
 	return ret;
 }
-- 
1.6.3.2

