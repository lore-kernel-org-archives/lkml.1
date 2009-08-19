Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZHSORc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZHSORc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZHSORb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:17:31 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:54170 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361AbZHSORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:17:30 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mjg@redhat.com
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 2/5] dell-laptop: fix rfkill memory leak on unload and failure paths
Date: Wed, 19 Aug 2009 15:06:48 +0100
Message-Id: <1250690811-21203-2-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4A8C0623.8030808@tuffmail.co.uk>
References: <4A8C0623.8030808@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill_unregister() should always be followed by rfkill_destroy().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/dell-laptop.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 12b6f33..8fbff38 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -268,6 +268,22 @@ err_wifi:
 	return ret;
 }
 
+static void dell_cleanup_rfkill(void)
+{
+	if (wifi_rfkill) {
+		rfkill_unregister(wifi_rfkill);
+		rfkill_destroy(wifi_rfkill);
+	}
+	if (bluetooth_rfkill) {
+		rfkill_unregister(bluetooth_rfkill);
+		rfkill_destroy(bluetooth_rfkill);
+	}
+	if (wwan_rfkill) {
+		rfkill_unregister(wwan_rfkill);
+		rfkill_destroy(wwan_rfkill);
+	}
+}
+
 static int dell_send_intensity(struct backlight_device *bd)
 {
 	struct calling_interface_buffer buffer;
@@ -370,12 +386,7 @@ static int __init dell_init(void)
 	return 0;
 
 fail_backlight:
-	if (wifi_rfkill)
-		rfkill_unregister(wifi_rfkill);
-	if (bluetooth_rfkill)
-		rfkill_unregister(bluetooth_rfkill);
-	if (wwan_rfkill)
-		rfkill_unregister(wwan_rfkill);
+	dell_cleanup_rfkill();
 fail_rfkill:
 	kfree(da_tokens);
 	return ret;
@@ -384,12 +395,7 @@ fail_rfkill:
 static void __exit dell_exit(void)
 {
 	backlight_device_unregister(dell_backlight_device);
-	if (wifi_rfkill)
-		rfkill_unregister(wifi_rfkill);
-	if (bluetooth_rfkill)
-		rfkill_unregister(bluetooth_rfkill);
-	if (wwan_rfkill)
-		rfkill_unregister(wwan_rfkill);
+	dell_cleanup_rfkill();
 }
 
 module_init(dell_init);
-- 
1.6.3.2

