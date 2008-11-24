Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYKXPxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYKXPxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYKXPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:53:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59335 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752960AbYKXPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:53:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Switch WM8350 revision detection to a feature based model
Date: Mon, 24 Nov 2008 15:53:11 +0000
Message-Id: <1227541992-20692-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than check for chip revisions in the WM8350 drivers have the core
code set flags for relevant differences.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Updated to keep the constants for the revisions.

 drivers/mfd/wm8350-core.c         |    6 ++----
 drivers/power/wm8350_power.c      |    2 +-
 include/linux/mfd/wm8350/core.h   |    2 --
 include/linux/mfd/wm8350/supply.h |    2 ++
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 60439bd..764bf15 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1240,19 +1240,17 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		switch ((id2 & WM8350_CHIP_REV_MASK) >> 12) {
 		case WM8350_REV_E:
 			dev_info(wm8350->dev, "Found Rev E device\n");
-			wm8350->rev = WM8350_REV_E;
 			break;
 		case WM8350_REV_F:
 			dev_info(wm8350->dev, "Found Rev F device\n");
-			wm8350->rev = WM8350_REV_F;
 			break;
 		case WM8350_REV_G:
 			dev_info(wm8350->dev, "Found Rev G device\n");
-			wm8350->rev = WM8350_REV_G;
+			wm8350->power.rev_g_coeff = 1;
 			break;
 		case WM8350_REV_H:
 			dev_info(wm8350->dev, "Found Rev H device\n");
-			wm8350->rev = WM8350_REV_H;
+			wm8350->power.rev_g_coeff = 1;
 			break;
 		default:
 			/* For safety we refuse to run on unknown hardware */
diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index 9c0a847..74e7593 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -44,7 +44,7 @@ static int wm8350_read_usb_uvolts(struct wm8350 *wm8350)
 
 static inline int wm8350_charge_time_min(struct wm8350 *wm8350, int min)
 {
-	if (wm8350->rev < WM8350_REV_G)
+	if (!wm8350->power.rev_g_coeff)
 		return (((min - 30) / 15) & 0xf) << 8;
 	else
 		return (((min - 30) / 30) & 0xf) << 8;
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index d2614df..3c97356 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -585,8 +585,6 @@ struct wm8350_irq {
 };
 
 struct wm8350 {
-	int rev;		/* chip revision */
-
 	struct device *dev;
 
 	/* device IO */
diff --git a/include/linux/mfd/wm8350/supply.h b/include/linux/mfd/wm8350/supply.h
index 7972151..2b94793 100644
--- a/include/linux/mfd/wm8350/supply.h
+++ b/include/linux/mfd/wm8350/supply.h
@@ -127,6 +127,8 @@ struct wm8350_power {
 	struct power_supply usb;
 	struct power_supply ac;
 	struct wm8350_charger_policy *policy;
+
+	int rev_g_coeff;
 };
 
 #endif
-- 
1.5.6.5

