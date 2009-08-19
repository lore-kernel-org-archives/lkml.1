Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbZHSORe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbZHSORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZHSORe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:17:34 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:49529 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752513AbZHSORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:17:31 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mjg@redhat.com
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 1/5] dell-laptop: fix a use-after-free error on the failure path
Date: Wed, 19 Aug 2009 15:06:47 +0100
Message-Id: <1250690811-21203-1-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4A8C0623.8030808@tuffmail.co.uk>
References: <4A8C0623.8030808@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dell_setup_rfkill() already cleans up the rfkill devices on failure.
So if it returns an error, we should not try to unregister the rfkill
devices.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/dell-laptop.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..12b6f33 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -330,7 +330,7 @@ static int __init dell_init(void)
 
 	if (ret) {
 		printk(KERN_WARNING "dell-laptop: Unable to setup rfkill\n");
-		goto out;
+		goto fail_rfkill;
 	}
 
 #ifdef CONFIG_ACPI
@@ -358,7 +358,7 @@ static int __init dell_init(void)
 		if (IS_ERR(dell_backlight_device)) {
 			ret = PTR_ERR(dell_backlight_device);
 			dell_backlight_device = NULL;
-			goto out;
+			goto fail_backlight;
 		}
 
 		dell_backlight_device->props.max_brightness = max_intensity;
@@ -368,13 +368,15 @@ static int __init dell_init(void)
 	}
 
 	return 0;
-out:
+
+fail_backlight:
 	if (wifi_rfkill)
 		rfkill_unregister(wifi_rfkill);
 	if (bluetooth_rfkill)
 		rfkill_unregister(bluetooth_rfkill);
 	if (wwan_rfkill)
 		rfkill_unregister(wwan_rfkill);
+fail_rfkill:
 	kfree(da_tokens);
 	return ret;
 }
-- 
1.6.3.2

