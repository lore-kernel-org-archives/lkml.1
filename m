Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634Ab0ADSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0ADSSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629Ab0ADSSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:18:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37063 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753582Ab0ADSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:18:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regulator: Implement enable_time() for WM835x ISINKs
Date: Mon,  4 Jan 2010 18:17:46 +0000
Message-Id: <1262629066-18398-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <20100104181634.GA18258@rakim.wolfsonmicro.main>
References: <20100104181634.GA18258@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |   46 ++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 1bbff09..927e735 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -290,6 +290,51 @@ static int wm8350_isink_is_enabled(struct regulator_dev *rdev)
 	return -EINVAL;
 }
 
+static int wm8350_isink_enable_time(struct regulator_dev *rdev)
+{
+	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
+	int isink = rdev_get_id(rdev);
+	int reg;
+
+	switch (isink) {
+	case WM8350_ISINK_A:
+		reg = wm8350_reg_read(wm8350, WM8350_CSA_FLASH_CONTROL);
+		break;
+	case WM8350_ISINK_B:
+		reg = wm8350_reg_read(wm8350, WM8350_CSB_FLASH_CONTROL);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (reg & WM8350_CS1_FLASH_MODE) {
+		switch (reg & WM8350_CS1_ON_RAMP_MASK) {
+		case 0:
+			return 0;
+		case 1:
+			return 1950;
+		case 2:
+			return 3910;
+		case 3:
+			return 7800;
+		}
+	} else {
+		switch (reg & WM8350_CS1_ON_RAMP_MASK) {
+		case 0:
+			return 0;
+		case 1:
+			return 250000;
+		case 2:
+			return 500000;
+		case 3:
+			return 1000000;
+		}
+	}
+
+	return -EINVAL;
+}
+
+
 int wm8350_isink_set_flash(struct wm8350 *wm8350, int isink, u16 mode,
 			   u16 trigger, u16 duration, u16 on_ramp, u16 off_ramp,
 			   u16 drive)
@@ -1221,6 +1266,7 @@ static struct regulator_ops wm8350_isink_ops = {
 	.enable = wm8350_isink_enable,
 	.disable = wm8350_isink_disable,
 	.is_enabled = wm8350_isink_is_enabled,
+	.enable_time = wm8350_isink_enable_time,
 };
 
 static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
-- 
1.6.5.7

