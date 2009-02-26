Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZBZTYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZBZTYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZBZTYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:24:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35105 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752419AbZBZTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:24:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Fix get_mode() for WM835x DCDCs
Date: Thu, 26 Feb 2009 19:24:20 +0000
Message-Id: <1235676260-19696-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235676260-19696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1235676260-19696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM835x regulators need a different register checking for force
mode on each DCDC. Previously the force mode status for DCDC1 was
checked.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 93e0ce5..261db94 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1031,18 +1031,30 @@ static unsigned int wm8350_dcdc_get_mode(struct regulator_dev *rdev)
 	int dcdc = rdev_get_id(rdev);
 	u16 mask, sleep, active, force;
 	int mode = REGULATOR_MODE_NORMAL;
+	int reg;
 
-	if (dcdc < WM8350_DCDC_1 || dcdc > WM8350_DCDC_6)
-		return -EINVAL;
-
-	if (dcdc == WM8350_DCDC_2 || dcdc == WM8350_DCDC_5)
+	switch (dcdc) {
+	case WM8350_DCDC_1:
+		reg = WM8350_DCDC1_FORCE_PWM;
+		break;
+	case WM8350_DCDC_3:
+		reg = WM8350_DCDC3_FORCE_PWM;
+		break;
+	case WM8350_DCDC_4:
+		reg = WM8350_DCDC4_FORCE_PWM;
+		break;
+	case WM8350_DCDC_6:
+		reg = WM8350_DCDC6_FORCE_PWM;
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	mask = 1 << (dcdc - WM8350_DCDC_1);
 	active = wm8350_reg_read(wm8350, WM8350_DCDC_ACTIVE_OPTIONS) & mask;
+	force = wm8350_reg_read(wm8350, reg) & WM8350_DCDC1_FORCE_PWM_ENA;
 	sleep = wm8350_reg_read(wm8350, WM8350_DCDC_SLEEP_OPTIONS) & mask;
-	force = wm8350_reg_read(wm8350, WM8350_DCDC1_FORCE_PWM)
-	    & WM8350_DCDC1_FORCE_PWM_ENA;
+
 	dev_dbg(wm8350->dev, "mask %x active %x sleep %x force %x",
 		mask, active, sleep, force);
 
-- 
1.6.1.3

