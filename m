Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZBZTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZBZTvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbZBZTuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:50:24 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:45859 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756350AbZBZTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:50:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=awxgJPU0rPCFkwTLS3hoflMLYtsyCCGyKPWiq6Wd4Sgiy49GjKUtepIZlLzGNE2Mwau62o5pE0QBHU+DrFFvyr/Bq47GCjAzy6CeOsLipu9+a5c4DTzyMOviZ6L6OeY6DAAvyerS2gHfB+SwRu/6P5FB1HIi10QZv8uuzfHVLRE=  ;
X-YMail-OSG: lauV5WkVM1kR1ftXkyrctDO2KzZGbOyhkbkpErxzzxNDjWbIOoPmqQtX1TvFqrObTQtdyWNSAowJA4O3EmVi95x_S0O7UgFoXmNqm1WHcZgygvqFLrEEvd_O61QdbG2dHRzHI0PAJOlAnnosSm07pOaDjukdTgtecOUBQBHoyJN4qCyf3QMQTYA56QKSuoumQbFSX4PPRv6RJtZ5uiPb1ZVtLdj08qWWJI3OTw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: [patch/rfc 2.6.29-rc6 2/2] regulator: twl4030 voltage enumeration (v2)
Date: Thu, 26 Feb 2009 11:50:14 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902231245.44360.david-b@pacbell.net> <200902231254.13990.david-b@pacbell.net>
In-Reply-To: <200902231254.13990.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261150.15125.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Update previously-posted twl4030 regulator driver to export
supported voltages to upper layers using a new mechanism.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Updates since previous version:  match updated [1/2] interfaces.

Note that the twl4030 regulator patch referred to will need a
minor patch to work with the -next tree, because of interface
change in the regulator framework.

 drivers/regulator/twl4030-regulator.c |   62 +++++++++++---------------------
 1 file changed, 23 insertions(+), 39 deletions(-)

--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -42,7 +42,6 @@ struct twlreg_info {
 
 	/* chip constraints on regulator behavior */
 	u16			min_mV;
-	u16			max_mV;
 
 	/* used by regulator core */
 	struct regulator_desc	desc;
@@ -262,6 +261,14 @@ static const u16 VDAC_VSEL_table[] = {
 };
 
 
+static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	int			mV = info->table[index];
+
+	return IS_UNSUP(mV) ? 0 : (LDO_MV(mV) * 1000);
+}
+
 static int
 twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 {
@@ -276,6 +283,8 @@ twl4030ldo_set_voltage(struct regulator_
 			continue;
 		uV = LDO_MV(mV) * 1000;
 
+		/* REVISIT for VAUX2, first match may not be best/lowest */
+
 		/* use the first in-range value */
 		if (min_uV <= uV && uV <= max_uV)
 			return twl4030reg_write(info, VREG_DEDICATED, vsel);
@@ -297,6 +306,8 @@ static int twl4030ldo_get_voltage(struct
 }
 
 static struct regulator_ops twl4030ldo_ops = {
+	.list_voltage	= twl4030ldo_list_voltage,
+
 	.set_voltage	= twl4030ldo_set_voltage,
 	.get_voltage	= twl4030ldo_get_voltage,
 
@@ -314,6 +325,13 @@ static struct regulator_ops twl4030ldo_o
 /*
  * Fixed voltage LDOs don't have a VSEL field to update.
  */
+static int twl4030fixed_list_voltage(struct regulator_dev *rdev, unsigned index)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+
+	return info->min_mV * 1000;
+}
+
 static int twl4030fixed_get_voltage(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
@@ -322,6 +340,8 @@ static int twl4030fixed_get_voltage(stru
 }
 
 static struct regulator_ops twl4030fixed_ops = {
+	.list_voltage	= twl4030fixed_list_voltage,
+
 	.get_voltage	= twl4030fixed_get_voltage,
 
 	.enable		= twl4030reg_enable,
@@ -343,6 +363,7 @@ static struct regulator_ops twl4030fixed
 	.desc = { \
 		.name = #label, \
 		.id = TWL4030_REG_##label, \
+		.n_voltages = ARRAY_SIZE(label##_VSEL_table), \
 		.ops = &twl4030ldo_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
@@ -353,10 +374,10 @@ static struct regulator_ops twl4030fixed
 	.base = offset, \
 	.id = num, \
 	.min_mV = mVolts, \
-	.max_mV = mVolts, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL4030_REG_##label, \
+		.n_voltages = 1, \
 		.ops = &twl4030fixed_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
@@ -402,14 +423,11 @@ static int twl4030reg_probe(struct platf
 	struct regulator_init_data	*initdata;
 	struct regulation_constraints	*c;
 	struct regulator_dev		*rdev;
-	int				min_uV, max_uV;
 
 	for (i = 0, info = NULL; i < ARRAY_SIZE(twl4030_regs); i++) {
 		if (twl4030_regs[i].desc.id != pdev->id)
 			continue;
 		info = twl4030_regs + i;
-		min_uV = info->min_mV * 1000;
-		max_uV = info->max_mV * 1000;
 		break;
 	}
 	if (!info)
@@ -423,10 +441,6 @@ static int twl4030reg_probe(struct platf
 	 * this driver and the chip itself can actually do.
 	 */
 	c = &initdata->constraints;
-	if (!c->min_uV || c->min_uV < min_uV)
-		c->min_uV = min_uV;
-	if (!c->max_uV || c->max_uV > max_uV)
-		c->max_uV = max_uV;
 	c->valid_modes_mask &= REGULATOR_MODE_NORMAL | REGULATOR_MODE_STANDBY;
 	c->valid_ops_mask &= REGULATOR_CHANGE_VOLTAGE
 				| REGULATOR_CHANGE_MODE
@@ -471,36 +485,6 @@ static struct platform_driver twl4030reg
 
 static int __init twl4030reg_init(void)
 {
-	unsigned i, j;
-
-	/* determine min/max voltage constraints, taking into account
-	 * whether set_voltage() will use the "unsupported" settings
-	 */
-	for (i = 0; i < ARRAY_SIZE(twl4030_regs); i++) {
-		struct twlreg_info	*info = twl4030_regs + i;
-		const u16		*table;
-
-		/* fixed-voltage regulators */
-		if (!info->table_len)
-			continue;
-
-		/* LDO regulators: */
-		for (j = 0, table = info->table;
-				j < info->table_len;
-				j++, table++) {
-			u16		mV = *table;
-
-			if (IS_UNSUP(mV))
-				continue;
-			mV = LDO_MV(mV);
-
-			if (info->min_mV == 0 || info->min_mV > mV)
-				info->min_mV = mV;
-			if (info->max_mV < mV)
-				info->max_mV = mV;
-		}
-	}
-
 	return platform_driver_register(&twl4030reg_driver);
 }
 subsys_initcall(twl4030reg_init);
