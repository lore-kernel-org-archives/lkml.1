Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYKRPWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYKRPWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYKRPWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:22:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37576 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753597AbYKRPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:22:20 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Switch WM8350 revision detection to a feature based model
Date: Tue, 18 Nov 2008 15:22:17 +0000
Message-Id: <1227021737-19913-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than check for chip revisions in the WM8350 drivers have the core
code set flags for relevant differences.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c         |    6 ++----
 drivers/power/wm8350_power.c      |    2 +-
 include/linux/mfd/wm8350/core.h   |    8 --------
 include/linux/mfd/wm8350/supply.h |    2 ++
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 3734f20..7dece8e 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1225,19 +1225,17 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
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
index 8e11539..349d439 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -558,12 +558,6 @@
 #define WM8350_IRQ_WKUP_ONKEY			48
 #define WM8350_IRQ_WKUP_GP_WAKEUP		49
 
-/* wm8350 chip revisions */
-#define WM8350_REV_E				0x4
-#define WM8350_REV_F				0x5
-#define WM8350_REV_G				0x6
-#define WM8350_REV_H				0x7
-
 #define WM8350_NUM_IRQ				63
 
 struct wm8350_reg_access {
@@ -585,8 +579,6 @@ struct wm8350_irq {
 };
 
 struct wm8350 {
-	int rev;		/* chip revision */
-
 	struct device *dev;
 
 	/* device IO */
diff --git a/include/linux/mfd/wm8350/supply.h b/include/linux/mfd/wm8350/supply.h
index 293fff2..8713533 100644
--- a/include/linux/mfd/wm8350/supply.h
+++ b/include/linux/mfd/wm8350/supply.h
@@ -130,6 +130,8 @@ struct wm8350_power {
 	struct power_supply usb;
 	struct power_supply ac;
 	struct wm8350_charger_policy *policy;
+
+	int rev_g_coeff;
 };
 
 #endif
-- 
1.5.6.5

