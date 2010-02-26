Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936164Ab0BZMVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:21:46 -0500
Received: from legolas.restena.lu ([158.64.1.34]:38740 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935934Ab0BZMVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:21:38 -0500
Date: Fri, 26 Feb 2010 13:20:10 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Richard Purdie <rpurdie@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] backlight, panasonic-laptop: fix incomplete registration
 failure handling
Message-ID: <20100226132010.3ffeca88@neptune.home>
In-Reply-To: <20100221002831.689bace8@neptune.home>
References: <20100221002831.689bace8@neptune.home>
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
Acked-by: Harald Welte <laforge@gnumonks.org> (registration failure)
---
 drivers/platform/x86/panasonic-laptop.c |    4 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 9012d8d..9b17343 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -352,7 +352,7 @@ static int bl_set_status(struct backlight_device *bd)
 	return acpi_pcc_write_sset(pcc, SINF_DC_CUR_BRIGHT, bright);
 }
 
-static struct backlight_ops pcc_backlight_ops = {
+static const struct backlight_ops pcc_backlight_ops = {
 	.get_brightness	= bl_get,
 	.update_status	= bl_set_status,
 };
@@ -644,8 +644,10 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	/* initialize backlight */
 	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
 						   &pcc_backlight_ops);
-	if (IS_ERR(pcc->backlight))
+	if (IS_ERR(pcc->backlight)) {
+		result = PTR_ERR(pcc->backlight);
 		goto out_input;
+	}
 
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-- 
1.6.4.4

