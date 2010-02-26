Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946Ab0BZMVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:21:44 -0500
Received: from legolas.restena.lu ([158.64.1.34]:53028 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935929Ab0BZMVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:21:38 -0500
Date: Fri, 26 Feb 2010 13:17:16 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Richard Purdie <rpurdie@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] backlight, msi-laptop, msi-wmi: fix incomplete registration
 failure handling
Message-ID: <20100226131716.77d351ce@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100221002831.689bace8@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly return backlight registration error to parent.
Mark struct backlight_ops as const.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Reviewed-by: Anisse Astier <anisse@astier.eu>
---
 drivers/platform/x86/msi-laptop.c    |    2 +-
 drivers/platform/x86/msi-wmi.c       |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 759763d..1093ba2 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -161,7 +161,7 @@ static int bl_update_status(struct backlight_device *b)
 	return set_lcd_level(b->props.brightness);
 }
 
-static struct backlight_ops msibl_ops = {
+static const struct backlight_ops msibl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status  = bl_update_status,
 };
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index f5f70d4..5f7cff1 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -138,7 +138,7 @@ static int bl_set_status(struct backlight_device *bd)
 	return msi_wmi_set_block(0, backlight_map[bright]);
 }
 
-static struct backlight_ops msi_backlight_ops = {
+static const struct backlight_ops msi_backlight_ops = {
 	.get_brightness	= bl_get,
 	.update_status	= bl_set_status,
 };
@@ -251,8 +251,10 @@ static int __init msi_wmi_init(void)
 	if (!acpi_video_backlight_support()) {
 		backlight = backlight_device_register(DRV_NAME,
 				NULL, NULL, &msi_backlight_ops);
-		if (IS_ERR(backlight))
+		if (IS_ERR(backlight)) {
+			err = PTR_ERR(backlight);
 			goto err_free_input;
+		}
 
 		backlight->props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
 		err = bl_get(NULL);
-- 
1.6.4.4

