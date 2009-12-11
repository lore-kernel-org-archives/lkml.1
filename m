Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbZLKHyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbZLKHyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbZLKHye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:54:34 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32449 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZLKHyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:54:33 -0500
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, sameo@linux.intel.com,
       linux-kernel@vger.kernel.org
Cc: peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com,
       ext-juha.1.keski-saari@nokia.com
Subject: [PATCH 1/1] twl4030-regulator: extend twlreg_info to contain turnon delay and remap
Date: Fri, 11 Dec 2009 09:53:51 +0200
Message-Id: <1260518031-11192-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 11 Dec 2009 07:54:06.0645 (UTC) FILETIME=[1D46CE50:01CA7A37]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the twlreg_info structure to hold the turnon delay and remap config
value for regulators, and implement turnon delay in reg_enable

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |   63 ++++++++++++++++++---------------
 1 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index 477c965..a0e43f3 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -43,6 +44,12 @@ struct twlreg_info {
 	/* chip constraints on regulator behavior */
 	u16			min_mV;
 
+	/* regulator specific turn-on delay */
+	u16			delay;
+
+	/* stte REMAP default configuration */
+	u8			remap;
+
 	/* used by regulator core */
 	struct regulator_desc	desc;
 };
@@ -108,13 +115,18 @@ static int twl4030reg_enable(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			grp;
+	int			ret;
 
 	grp = twl4030reg_read(info, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
 	grp |= P1_GRP;
-	return twl4030reg_write(info, VREG_GRP, grp);
+	ret = twl4030reg_write(info, VREG_GRP, grp);
+
+	udelay(info->delay);
+
+	return ret;
 }
 
 static int twl4030reg_disable(struct regulator_dev *rdev)
@@ -401,36 +413,29 @@ static struct regulator_ops twl4030fixed_ops = {
  * software control over them after boot.
  */
 static struct twlreg_info twl4030_regs[] = {
-	TWL_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
-	TWL_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
-	TWL_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
-	TWL_ADJUSTABLE_LDO(VAUX3, 0x1f, 3),
-	TWL_ADJUSTABLE_LDO(VAUX4, 0x23, 4),
-	TWL_ADJUSTABLE_LDO(VMMC1, 0x27, 5),
-	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
-	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
-	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
-	TWL_ADJUSTABLE_LDO(VSIM, 0x37, 9),
-	TWL_ADJUSTABLE_LDO(VDAC, 0x3b, 10),
-	TWL_FIXED_LDO(VINTANA1, 0x3f, 1500, 11),
-	TWL_ADJUSTABLE_LDO(VINTANA2, 0x43, 12),
-	TWL_FIXED_LDO(VINTDIG, 0x47, 1500, 13),
-	TWL_ADJUSTABLE_LDO(VIO, 0x4b, 14),
-	TWL_ADJUSTABLE_LDO(VDD1, 0x55, 15),
-	TWL_ADJUSTABLE_LDO(VDD2, 0x63, 16),
-	TWL_FIXED_LDO(VUSB1V5, 0x71, 1500, 17),
-	TWL_FIXED_LDO(VUSB1V8, 0x74, 1800, 18),
-	TWL_FIXED_LDO(VUSB3V1, 0x77, 3100, 19),
+	TWL_ADJUSTABLE_LDO(VAUX1, 0x17, 1, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VAUX2, 0x1b, 2, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VAUX3, 0x1f, 3, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VAUX4, 0x23, 4, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VMMC1, 0x27, 5, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7, 100, 0x00),
+	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VSIM, 0x37, 9, 100, 0x00),
+	TWL_ADJUSTABLE_LDO(VDAC, 0x3b, 10, 100, 0x08),
+	TWL_FIXED_LDO(VINTANA1, 0x3f, 1500, 11, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VINTANA2, 0x43, 12, 100, 0x08),
+	TWL_FIXED_LDO(VINTDIG, 0x47, 1500, 13, 100, 0x08),
+	TWL_ADJUSTABLE_LDO(VIO, 0x4b, 14, 1000, 0x08),
+	TWL_ADJUSTABLE_LDO(VDD1, 0x55, 15, 1000, 0x08),
+	TWL_ADJUSTABLE_LDO(VDD2, 0x63, 16, 1000, 0x08),
+	TWL_FIXED_LDO(VUSB1V5, 0x71, 1500, 17, 100, 0x08),
+	TWL_FIXED_LDO(VUSB1V8, 0x74, 1800, 18, 100, 0x08),
+	TWL_FIXED_LDO(VUSB3V1, 0x77, 3100, 19, 150, 0x08),
 	/* VUSBCP is managed *only* by the USB subchip */
 };
 
-static const u8 REG_REMAP_table[] = {
-	0x08, 0x08, 0x08, 0x08, 0x00, 0x08, 0x08,
-	0x08, 0x00, 0x08, 0x08, 0x08, 0x08, 0x08,
-	0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
-	0x08,
-};
-
 static int twl4030reg_probe(struct platform_device *pdev)
 {
 	int				i;
@@ -482,7 +487,7 @@ static int twl4030reg_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, rdev);
 
-       twl4030reg_write(info, VREG_REMAP, REG_REMAP_table[pdev->id]);
+       twl4030reg_write(info, VREG_REMAP, info->remap);
 
 	/* NOTE:  many regulators support short-circuit IRQs (presentable
 	 * as REGULATOR_OVER_CURRENT notifications?) configured via:
-- 
1.6.3.3

