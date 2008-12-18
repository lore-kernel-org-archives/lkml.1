Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752773AbYLRKqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYLRKqD (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYLRKot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:44:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35876 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751666AbYLRKor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:44:47 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] mfd: Support configurable numbers of DCDCs and ISINKs on WM8350
Date: Thu, 18 Dec 2008 10:44:43 +0000
Message-Id: <1229597084-12727-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229597084-12727-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081218104301.GA12649@rakim.wolfsonmicro.main>
 <1229597084-12727-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-4-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some WM8350 variants have fewer DCDCs and ISINKs. Identify these at
probe and refuse to use the absent DCDCs when running on these chips.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c            |    6 ++++++
 drivers/regulator/wm8350-regulator.c |    7 +++++++
 include/linux/mfd/wm8350/pmic.h      |    4 ++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 03af3b1..56c363c 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1301,6 +1301,9 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 	switch (mask_rev) {
 	case 0:
+		wm8350->pmic.max_dcdc = WM8350_DCDC_6;
+		wm8350->pmic.max_isink = WM8350_ISINK_B;
+
 		switch (chip_rev) {
 		case WM8350_REV_E:
 			dev_info(wm8350->dev, "WM8350 Rev E\n");
@@ -1325,6 +1328,9 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		break;
 
 	case 2:
+		wm8350->pmic.max_dcdc = WM8350_DCDC_6;
+		wm8350->pmic.max_isink = WM8350_ISINK_B;
+
 		switch (chip_rev) {
 		case 0:
 			dev_info(wm8350->dev, "WM8352 Rev A\n");
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 1f44b17..c68c496 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1380,6 +1380,13 @@ int wm8350_register_regulator(struct wm8350 *wm8350, int reg,
 	if (wm8350->pmic.pdev[reg])
 		return -EBUSY;
 
+	if (reg >= WM8350_DCDC_1 && reg <= WM8350_DCDC_6 &&
+	    reg > wm8350->pmic.max_dcdc)
+		return -ENODEV;
+	if (reg >= WM8350_ISINK_A && reg <= WM8350_ISINK_B &&
+	    reg > wm8350->pmic.max_isink)
+		return -ENODEV;
+
 	pdev = platform_device_alloc("wm8350-regulator", reg);
 	if (!pdev)
 		return -ENOMEM;
diff --git a/include/linux/mfd/wm8350/pmic.h b/include/linux/mfd/wm8350/pmic.h
index 69b69e0..96acbfc 100644
--- a/include/linux/mfd/wm8350/pmic.h
+++ b/include/linux/mfd/wm8350/pmic.h
@@ -701,6 +701,10 @@ struct platform_device;
 struct regulator_init_data;
 
 struct wm8350_pmic {
+	/* Number of regulators of each type on this device */
+	int max_dcdc;
+	int max_isink;
+
 	/* ISINK to DCDC mapping */
 	int isink_A_dcdc;
 	int isink_B_dcdc;
-- 
1.5.6.5

