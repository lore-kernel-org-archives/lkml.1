Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbZHLPI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbZHLPI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZHLPI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:08:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55310 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZHLPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:08:25 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 5/5] [regulator] Add a Freescale MC13783 regulator driver
Date: Wed, 12 Aug 2009 17:05:31 +0200
Message-Id: <1250089531-10399-6-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250089531-10399-5-git-send-email-s.hauer@pengutronix.de>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-5-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides basic support for the voltage regulators
integrated into the Freescale MC13783 PMIC. It is currently
only possible to enable/disable outputs, not to actually
set the voltage.

changes since v1:

- decrease verbosity
- use subsys_initcall instead of module_init
- use platform_driver_probe instead of platform_driver_register
- add __devexit_p to mc13783_regulator_remove

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/Kconfig   |    8 +
 drivers/regulator/Makefile  |    1 +
 drivers/regulator/mc13783.c |  410 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 419 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/mc13783.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..69197e9 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -117,4 +117,12 @@ config REGULATOR_LP3971
 	 Say Y here to support the voltage regulators and convertors
 	 on National Semiconductors LP3971 PMIC
 
+config REGULATOR_MC13783
+	tristate "Support regulators on Freescale MC13783 PMIC"
+	depends on MFD_MC13783
+	help
+	  Say y here to support the regulators found on the Freescale MC13783
+	  PMIC.
+
 endif
+
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4d762c4..6d45846 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -16,5 +16,6 @@ obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
+obj-$(CONFIG_REGULATOR_MC13783) += mc13783.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/mc13783.c b/drivers/regulator/mc13783.c
new file mode 100644
index 0000000..710211f
--- /dev/null
+++ b/drivers/regulator/mc13783.c
@@ -0,0 +1,410 @@
+/*
+ * Regulator Driver for Freescale MC13783 PMIC
+ *
+ * Copyright (C) 2008 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mfd/mc13783-private.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/driver.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/mc13783.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+
+struct mc13783_regulator {
+	struct regulator_desc desc;
+	int reg;
+	int enable_bit;
+};
+
+static struct regulator_ops mc13783_regulator_ops;
+
+static struct mc13783_regulator mc13783_regulators[] = {
+	[MC13783_SW_SW3] = {
+		.desc = {
+			.name	= "SW_SW3",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_SW_SW3,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_SWITCHERS_5,
+		.enable_bit = MC13783_SWCTRL_SW3_EN,
+	},
+	[MC13783_SW_PLL] = {
+		.desc = {
+			.name	= "SW_PLL",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_SW_PLL,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_SWITCHERS_4,
+		.enable_bit = MC13783_SWCTRL_PLL_EN,
+	},
+	[MC13783_REGU_VAUDIO] = {
+		.desc = {
+			.name	= "REGU_VAUDIO",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VAUDIO,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VAUDIO_EN,
+	},
+	[MC13783_REGU_VIOHI] = {
+		.desc = {
+			.name	= "REGU_VIOHI",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VIOHI,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VIOHI_EN,
+	},
+	[MC13783_REGU_VIOLO] = {
+		.desc = {
+			.name	= "REGU_VIOLO",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VIOLO,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VIOLO_EN,
+	},
+	[MC13783_REGU_VDIG] = {
+		.desc = {
+			.name	= "REGU_VDIG",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VDIG,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VDIG_EN,
+	},
+	[MC13783_REGU_VGEN] = {
+		.desc = {
+			.name	= "REGU_VGEN",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VGEN,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VGEN_EN,
+	},
+	[MC13783_REGU_VRFDIG] = {
+		.desc = {
+			.name	= "REGU_VRFDIG",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VRFDIG,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VRFDIG_EN,
+	},
+	[MC13783_REGU_VRFREF] = {
+		.desc = {
+			.name	= "REGU_VRFREF",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VRFREF,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VRFREF_EN,
+	},
+	[MC13783_REGU_VRFCP] = {
+		.desc = {
+			.name	= "REGU_VRFCP",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VRFCP,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_0,
+		.enable_bit = MC13783_REGCTRL_VRFCP_EN,
+	},
+	[MC13783_REGU_VSIM] = {
+		.desc = {
+			.name	= "REGU_VSIM",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VSIM,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VSIM_EN,
+	},
+	[MC13783_REGU_VESIM] = {
+		.desc = {
+			.name	= "REGU_VESIM",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VESIM,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VESIM_EN,
+	},
+	[MC13783_REGU_VCAM] = {
+		.desc = {
+			.name	= "REGU_VCAM",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VCAM,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VCAM_EN,
+	},
+	[MC13783_REGU_VRFBG] = {
+		.desc = {
+			.name	= "REGU_VRFBG",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VRFBG,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VRFBG_EN,
+	},
+	[MC13783_REGU_VVIB] = {
+		.desc = {
+			.name	= "REGU_VVIB",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VVIB,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VVIB_EN,
+	},
+	[MC13783_REGU_VRF1] = {
+		.desc = {
+			.name	= "REGU_VRF1",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VRF1,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VRF1_EN,
+	},
+	[MC13783_REGU_VRF2] = {
+		.desc = {
+			.name	= "REGU_VRF2",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VRF2,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VRF2_EN,
+	},
+	[MC13783_REGU_VMMC1] = {
+		.desc = {
+			.name	= "REGU_VMMC1",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VMMC1,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VMMC1_EN,
+	},
+	[MC13783_REGU_VMMC2] = {
+		.desc = {
+			.name	= "REGU_VMMC2",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_VMMC2,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_REGULATOR_MODE_1,
+		.enable_bit = MC13783_REGCTRL_VMMC2_EN,
+	},
+	[MC13783_REGU_GPO1] = {
+		.desc = {
+			.name	= "REGU_GPO1",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_GPO1,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_POWER_MISCELLANEOUS,
+		.enable_bit = MC13783_REGCTRL_GPO1_EN,
+	},
+	[MC13783_REGU_GPO2] = {
+		.desc = {
+			.name	= "REGU_GPO2",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_GPO2,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_POWER_MISCELLANEOUS,
+		.enable_bit = MC13783_REGCTRL_GPO2_EN,
+	},
+	[MC13783_REGU_GPO3] = {
+		.desc = {
+			.name	= "REGU_GPO3",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_GPO3,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_POWER_MISCELLANEOUS,
+		.enable_bit = MC13783_REGCTRL_GPO3_EN,
+	},
+	[MC13783_REGU_GPO4] = {
+		.desc = {
+			.name	= "REGU_GPO4",
+			.ops	= &mc13783_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.id	= MC13783_REGU_GPO4,
+			.owner	= THIS_MODULE,
+		},
+		.reg = MC13783_REG_POWER_MISCELLANEOUS,
+		.enable_bit = MC13783_REGCTRL_GPO4_EN,
+	},
+};
+
+struct mc13783_priv {
+	struct regulator_desc desc[ARRAY_SIZE(mc13783_regulators)];
+	struct mc13783 *mc13783;
+	struct regulator_dev *regulators[0];
+};
+
+static int mc13783_enable(struct regulator_dev *rdev)
+{
+	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	return mc13783_set_bits(priv->mc13783, mc13783_regulators[id].reg,
+			mc13783_regulators[id].enable_bit,
+			mc13783_regulators[id].enable_bit);
+}
+
+static int mc13783_disable(struct regulator_dev *rdev)
+{
+	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+
+	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
+
+	return mc13783_set_bits(priv->mc13783, mc13783_regulators[id].reg,
+			mc13783_regulators[id].enable_bit, 0);
+}
+
+static int mc13783_is_enabled(struct regulator_dev *rdev)
+{
+	struct mc13783_priv *priv = rdev_get_drvdata(rdev);
+	int ret, id = rdev_get_id(rdev);
+	unsigned int val;
+
+	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
+	if (ret)
+		return ret;
+
+	return (val & mc13783_regulators[id].enable_bit) != 0;
+}
+
+static struct regulator_ops mc13783_regulator_ops = {
+	.enable		= mc13783_enable,
+	.disable	= mc13783_disable,
+	.is_enabled	= mc13783_is_enabled,
+};
+
+static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
+{
+	struct mc13783_priv *priv;
+	struct mc13783 *mc13783 = dev_get_drvdata(pdev->dev.parent);
+	struct mc13783_regulator_init_data *init_data;
+	int i, ret;
+
+	dev_dbg(&pdev->dev, "mc13783_regulator_probe id %d\n", pdev->id);
+
+	priv = kzalloc(sizeof(*priv) + mc13783->num_regulators * sizeof(void *),
+			GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->mc13783 = mc13783;
+
+	for (i = 0; i < mc13783->num_regulators; i++) {
+		init_data = &mc13783->regulators[i];
+		priv->regulators[i] = regulator_register(
+				&mc13783_regulators[init_data->id].desc,
+				&pdev->dev, init_data->init_data, priv);
+
+		if (IS_ERR(priv->regulators[i])) {
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+				mc13783_regulators[i].desc.name);
+			ret = PTR_ERR(priv->regulators[i]);
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+err:
+	while (--i >= 0)
+		regulator_unregister(priv->regulators[i]);
+
+	kfree(priv);
+
+	return ret;
+}
+
+static int __devexit mc13783_regulator_remove(struct platform_device *pdev)
+{
+	struct mc13783_priv *priv = platform_get_drvdata(pdev);
+	struct mc13783 *mc13783 = priv->mc13783;
+	int i;
+
+	for (i = 0; i < mc13783->num_regulators; i++)
+		regulator_unregister(priv->regulators[i]);
+
+	return 0;
+}
+
+static struct platform_driver mc13783_regulator_driver = {
+	.driver	= {
+		.name	= "mc13783-regulator",
+		.owner	= THIS_MODULE,
+	},
+	.remove		= __devexit_p(mc13783_regulator_remove),
+};
+
+static int __init mc13783_regulator_init(void)
+{
+	return platform_driver_probe(&mc13783_regulator_driver,
+			mc13783_regulator_probe);
+}
+subsys_initcall(mc13783_regulator_init);
+
+static void __exit mc13783_regulator_exit(void)
+{
+	platform_driver_unregister(&mc13783_regulator_driver);
+}
+module_exit(mc13783_regulator_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de");
+MODULE_DESCRIPTION("Regulator Driver for Freescale MC13783 PMIC");
+MODULE_ALIAS("platform:mc13783-regulator");
-- 
1.6.3.3

