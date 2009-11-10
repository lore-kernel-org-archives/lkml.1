Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZKJIWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZKJIWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZKJIWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:22:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZKJIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:22:04 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/2] regulator/mc13783: various cleanups
Date: Tue, 10 Nov 2009 09:18:07 +0100
Message-Id: <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091106002847.GC22366@sortiz.org>
 <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- define needed registers and bits in the driver
- properly namespace functions and structs
- fix locking as required by patch
  "mfd/mc13783: near complete rewrite"
- use platform_data as provided by "mfd/mc13783: near complete rewrite"
  instead of accessing struct mc13783
- struct mc13783_regulator_priv.desc is (and was) unused and so can go
  away
- use cpp magic to initialize mc13783_regulators
- bring MODULE_LICENSE in sync with actual copyright
- minor style fixes

This allows not including mc13783-private.h which I intend to remove
soon.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Hello,

should I invest the effort to split that patch up?  E.g. one patch per
list item above?  (Probably defining the registers in
mc13783-regulator.c would clash wich removing #include
<linux/mfd/mc13783-private.h>, but the other changes should be
ortogonal.)

Best regards
Uwe

 drivers/regulator/mc13783-regulator.c |  389 ++++++++++-----------------------
 1 files changed, 112 insertions(+), 277 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 710211f..9f99862 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -8,15 +8,47 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/mfd/mc13783-private.h>
+#include <linux/mfd/mc13783.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/driver.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/mc13783.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/err.h>
 
+#define MC13783_REG_SWITCHERS4			28
+#define MC13783_REG_SWITCHERS4_PLLEN			(1 << 18)
+
+#define MC13783_REG_SWITCHERS5			29
+#define MC13783_REG_SWITCHERS5_SW3EN			(1 << 20)
+
+#define MC13783_REG_REGULATORMODE0		32
+#define MC13783_REG_REGULATORMODE0_VAUDIOEN		(1 << 0)
+#define MC13783_REG_REGULATORMODE0_VIOHIEN		(1 << 3)
+#define MC13783_REG_REGULATORMODE0_VIOLOEN		(1 << 6)
+#define MC13783_REG_REGULATORMODE0_VDIGEN		(1 << 9)
+#define MC13783_REG_REGULATORMODE0_VGENEN		(1 << 12)
+#define MC13783_REG_REGULATORMODE0_VRFDIGEN		(1 << 15)
+#define MC13783_REG_REGULATORMODE0_VRFREFEN		(1 << 18)
+#define MC13783_REG_REGULATORMODE0_VRFCPEN		(1 << 21)
+
+#define MC13783_REG_REGULATORMODE1		33
+#define MC13783_REG_REGULATORMODE1_VSIMEN		(1 << 0)
+#define MC13783_REG_REGULATORMODE1_VESIMEN		(1 << 3)
+#define MC13783_REG_REGULATORMODE1_VCAMEN		(1 << 6)
+#define MC13783_REG_REGULATORMODE1_VRFBGEN		(1 << 9)
+#define MC13783_REG_REGULATORMODE1_VVIBEN		(1 << 11)
+#define MC13783_REG_REGULATORMODE1_VRF1EN		(1 << 12)
+#define MC13783_REG_REGULATORMODE1_VRF2EN		(1 << 15)
+#define MC13783_REG_REGULATORMODE1_VMMC1EN		(1 << 18)
+#define MC13783_REG_REGULATORMODE1_VMMC2EN		(1 << 21)
+
+#define MC13783_REG_POWERMISC			34
+#define MC13783_REG_POWERMISC_GPO1EN			(1 << 6)
+#define MC13783_REG_POWERMISC_GPO2EN			(1 << 8)
+#define MC13783_REG_POWERMISC_GPO3EN			(1 << 10)
+#define MC13783_REG_POWERMISC_GPO4EN			(1 << 12)
+
 struct mc13783_regulator {
 	struct regulator_desc desc;
 	int reg;
@@ -25,298 +57,97 @@ struct mc13783_regulator {
 
 static struct regulator_ops mc13783_regulator_ops;
 
+#define MC13783_DEFINE(prefix, _name, _reg)				\
+	[MC13783_ ## prefix ## _ ## _name] = {				\
+		.desc = {						\
+			.name = #prefix "_" #_name,			\
+			.ops = &mc13783_regulator_ops,			\
+			.type = REGULATOR_VOLTAGE,			\
+			.id = MC13783_ ## prefix ## _ ## _name,		\
+			.owner = THIS_MODULE,				\
+		},							\
+		.reg = MC13783_REG_ ## _reg,				\
+		.enable_bit = MC13783_REG_ ## _reg ## _ ## _name ## EN,	\
+	}
+
+#define MC13783_DEFINE_SW(_name, _reg) MC13783_DEFINE(SW, _name, _reg)
+#define MC13783_DEFINE_REGU(_name, _reg) MC13783_DEFINE(REGU, _name, _reg)
+
 static struct mc13783_regulator mc13783_regulators[] = {
-	[MC13783_SW_SW3] = {
-		.desc = {
-			.name	= "SW_SW3",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_SW_SW3,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_SWITCHERS_5,
-		.enable_bit = MC13783_SWCTRL_SW3_EN,
-	},
-	[MC13783_SW_PLL] = {
-		.desc = {
-			.name	= "SW_PLL",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_SW_PLL,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_SWITCHERS_4,
-		.enable_bit = MC13783_SWCTRL_PLL_EN,
-	},
-	[MC13783_REGU_VAUDIO] = {
-		.desc = {
-			.name	= "REGU_VAUDIO",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VAUDIO,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VAUDIO_EN,
-	},
-	[MC13783_REGU_VIOHI] = {
-		.desc = {
-			.name	= "REGU_VIOHI",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VIOHI,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VIOHI_EN,
-	},
-	[MC13783_REGU_VIOLO] = {
-		.desc = {
-			.name	= "REGU_VIOLO",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VIOLO,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VIOLO_EN,
-	},
-	[MC13783_REGU_VDIG] = {
-		.desc = {
-			.name	= "REGU_VDIG",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VDIG,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VDIG_EN,
-	},
-	[MC13783_REGU_VGEN] = {
-		.desc = {
-			.name	= "REGU_VGEN",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VGEN,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VGEN_EN,
-	},
-	[MC13783_REGU_VRFDIG] = {
-		.desc = {
-			.name	= "REGU_VRFDIG",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VRFDIG,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VRFDIG_EN,
-	},
-	[MC13783_REGU_VRFREF] = {
-		.desc = {
-			.name	= "REGU_VRFREF",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VRFREF,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VRFREF_EN,
-	},
-	[MC13783_REGU_VRFCP] = {
-		.desc = {
-			.name	= "REGU_VRFCP",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VRFCP,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_0,
-		.enable_bit = MC13783_REGCTRL_VRFCP_EN,
-	},
-	[MC13783_REGU_VSIM] = {
-		.desc = {
-			.name	= "REGU_VSIM",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VSIM,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VSIM_EN,
-	},
-	[MC13783_REGU_VESIM] = {
-		.desc = {
-			.name	= "REGU_VESIM",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VESIM,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VESIM_EN,
-	},
-	[MC13783_REGU_VCAM] = {
-		.desc = {
-			.name	= "REGU_VCAM",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VCAM,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VCAM_EN,
-	},
-	[MC13783_REGU_VRFBG] = {
-		.desc = {
-			.name	= "REGU_VRFBG",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VRFBG,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VRFBG_EN,
-	},
-	[MC13783_REGU_VVIB] = {
-		.desc = {
-			.name	= "REGU_VVIB",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VVIB,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VVIB_EN,
-	},
-	[MC13783_REGU_VRF1] = {
-		.desc = {
-			.name	= "REGU_VRF1",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VRF1,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VRF1_EN,
-	},
-	[MC13783_REGU_VRF2] = {
-		.desc = {
-			.name	= "REGU_VRF2",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VRF2,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VRF2_EN,
-	},
-	[MC13783_REGU_VMMC1] = {
-		.desc = {
-			.name	= "REGU_VMMC1",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VMMC1,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VMMC1_EN,
-	},
-	[MC13783_REGU_VMMC2] = {
-		.desc = {
-			.name	= "REGU_VMMC2",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_VMMC2,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_REGULATOR_MODE_1,
-		.enable_bit = MC13783_REGCTRL_VMMC2_EN,
-	},
-	[MC13783_REGU_GPO1] = {
-		.desc = {
-			.name	= "REGU_GPO1",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_GPO1,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_POWER_MISCELLANEOUS,
-		.enable_bit = MC13783_REGCTRL_GPO1_EN,
-	},
-	[MC13783_REGU_GPO2] = {
-		.desc = {
-			.name	= "REGU_GPO2",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_GPO2,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_POWER_MISCELLANEOUS,
-		.enable_bit = MC13783_REGCTRL_GPO2_EN,
-	},
-	[MC13783_REGU_GPO3] = {
-		.desc = {
-			.name	= "REGU_GPO3",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_GPO3,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_POWER_MISCELLANEOUS,
-		.enable_bit = MC13783_REGCTRL_GPO3_EN,
-	},
-	[MC13783_REGU_GPO4] = {
-		.desc = {
-			.name	= "REGU_GPO4",
-			.ops	= &mc13783_regulator_ops,
-			.type	= REGULATOR_VOLTAGE,
-			.id	= MC13783_REGU_GPO4,
-			.owner	= THIS_MODULE,
-		},
-		.reg = MC13783_REG_POWER_MISCELLANEOUS,
-		.enable_bit = MC13783_REGCTRL_GPO4_EN,
-	},
+	MC13783_DEFINE_SW(SW3, SWITCHERS5),
+	MC13783_DEFINE_SW(PLL, SWITCHERS4),
+
+	MC13783_DEFINE_REGU(VAUDIO, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VIOHI, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VIOLO, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VDIG, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VGEN, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VRFDIG, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VRFREF, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VRFCP, REGULATORMODE0),
+	MC13783_DEFINE_REGU(VSIM, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VESIM, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VCAM, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VRFBG, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VVIB, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VRF1, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VRF2, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VMMC1, REGULATORMODE1),
+	MC13783_DEFINE_REGU(VMMC2, REGULATORMODE1),
+	MC13783_DEFINE_REGU(GPO1, POWERMISC),
+	MC13783_DEFINE_REGU(GPO2, POWERMISC),
+	MC13783_DEFINE_REGU(GPO3, POWERMISC),
+	MC13783_DEFINE_REGU(GPO4, POWERMISC),
 };
 
-struct mc13783_priv {
-	struct regulator_desc desc[ARRAY_SIZE(mc13783_regulators)];
+struct mc13783_regulator_priv {
 	struct mc13783 *mc13783;
-	struct regulator_dev *regulators[0];
+	struct regulator_dev *regulators[];
 };
 
-static int mc13783_enable(struct regulator_dev *rdev)
+static int mc13783_regulator_enable(struct regulator_dev *rdev)
 {
-	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
+	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	return mc13783_set_bits(priv->mc13783, mc13783_regulators[id].reg,
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_reg_rmw(priv->mc13783, mc13783_regulators[id].reg,
 			mc13783_regulators[id].enable_bit,
 			mc13783_regulators[id].enable_bit);
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
 }
 
-static int mc13783_disable(struct regulator_dev *rdev)
+static int mc13783_regulator_disable(struct regulator_dev *rdev)
 {
-	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int id = rdev_get_id(rdev);
+	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	return mc13783_set_bits(priv->mc13783, mc13783_regulators[id].reg,
+	mc13783_lock(priv->mc13783);
+	ret = mc13783_reg_rmw(priv->mc13783, mc13783_regulators[id].reg,
 			mc13783_regulators[id].enable_bit, 0);
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
 }
 
-static int mc13783_is_enabled(struct regulator_dev *rdev)
+static int mc13783_regulator_is_enabled(struct regulator_dev *rdev)
 {
-	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
+	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;
 
+	mc13783_lock(priv->mc13783);
 	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
+	mc13783_unlock(priv->mc13783);
+
 	if (ret)
 		return ret;
 
@@ -324,29 +155,32 @@ static int mc13783_is_enabled(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops mc13783_regulator_ops = {
-	.enable		= mc13783_enable,
-	.disable	= mc13783_disable,
-	.is_enabled	= mc13783_is_enabled,
+	.enable = mc13783_regulator_enable,
+	.disable = mc13783_regulator_disable,
+	.is_enabled = mc13783_regulator_is_enabled,
 };
 
 static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 {
-	struct mc13783_priv *priv;
+	struct mc13783_regulator_priv *priv;
 	struct mc13783 *mc13783 = dev_get_drvdata(pdev->dev.parent);
+	struct mc13783_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	struct mc13783_regulator_init_data *init_data;
 	int i, ret;
 
 	dev_dbg(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);
 
-	priv = kzalloc(sizeof(*priv) + mc13783->num_regulators * sizeof(void *),
+	priv = kzalloc(sizeof(*priv) +
+			pdata->num_regulators * sizeof(priv->regulators[0]),
 			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->mc13783 = mc13783;
 
-	for (i = 0; i < mc13783->num_regulators; i++) {
-		init_data = &mc13783->regulators[i];
+	for (i = 0; i < pdata->num_regulators; i++) {
+		init_data = &pdata->regulators[i];
 		priv->regulators[i] = regulator_register(
 				&mc13783_regulators[init_data->id].desc,
 				&pdev->dev, init_data->init_data, priv);
@@ -373,11 +207,12 @@ err:
 
 static int __devexit mc13783_regulator_remove(struct platform_device *pdev)
 {
-	struct mc13783_priv *priv = platform_get_drvdata(pdev);
-	struct mc13783 *mc13783 = priv->mc13783;
+	struct mc13783_regulator_priv *priv = platform_get_drvdata(pdev);
+	struct mc13783_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	int i;
 
-	for (i = 0; i < mc13783->num_regulators; i++)
+	for (i = 0; i < pdata->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
 	return 0;
@@ -404,7 +239,7 @@ static void __exit mc13783_regulator_exit(void)
 }
 module_exit(mc13783_regulator_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de");
 MODULE_DESCRIPTION("Regulator Driver for Freescale MC13783 PMIC");
 MODULE_ALIAS("platform:mc13783-regulator");
-- 
1.6.5.2

