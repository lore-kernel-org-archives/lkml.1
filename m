Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZG1OW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZG1OW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZG1OW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:22:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55708 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753061AbZG1OW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:22:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 19/23] regulator: Add WM831x EPE support
Date: Tue, 28 Jul 2009 15:22:23 +0100
Message-Id: <1248790943-26768-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248702372-29534-18-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248702372-29534-18-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of PMICs provide two optional outputs for
controlling external devices during power sequencing, for example
an external regulator. While in essence these are GPIOs the
hardware presents them as DCDCs with very little control so
provide support via the regulator API in that fashion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---

Support missing platform data for the chip as a whole.

 drivers/regulator/wm831x-dcdc.c |   88 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index fa5126e..88a7dba 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -613,6 +613,89 @@ static struct platform_driver wm831x_buckp_driver = {
 	},
 };
 
+/*
+ * External Power Enable
+ *
+ * These aren't actually DCDCs but look like them in hardware so share
+ * code.
+ */
+
+#define WM831X_EPE_BASE 6
+
+static struct regulator_ops wm831x_epe_ops = {
+	.is_enabled = wm831x_dcdc_is_enabled,
+	.enable = wm831x_dcdc_enable,
+	.disable = wm831x_dcdc_disable,
+	.get_status = wm831x_dcdc_get_status,
+};
+
+static __devinit int wm831x_epe_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->epe);
+	struct wm831x_dcdc *dcdc;
+	int ret;
+
+	dev_dbg(&pdev->dev, "Probing EPE%d\n", id + 1);
+
+	if (pdata == NULL || pdata->epe[id] == NULL)
+		return -ENODEV;
+
+	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	if (dcdc == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	dcdc->wm831x = wm831x;
+
+	/* For current parts this is correct; probably need to revisit
+	 * in future.
+	 */
+	snprintf(dcdc->name, sizeof(dcdc->name), "EPE%d", id + 1);
+	dcdc->desc.name = dcdc->name;
+	dcdc->desc.id = id + WM831X_EPE_BASE; /* Offset in DCDC registers */
+	dcdc->desc.ops = &wm831x_epe_ops;
+	dcdc->desc.type = REGULATOR_VOLTAGE;
+	dcdc->desc.owner = THIS_MODULE;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
+					     pdata->epe[id], dcdc);
+	if (IS_ERR(dcdc->regulator)) {
+		ret = PTR_ERR(dcdc->regulator);
+		dev_err(wm831x->dev, "Failed to register EPE%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, dcdc);
+
+	return 0;
+
+err:
+	kfree(dcdc);
+	return ret;
+}
+
+static __devexit int wm831x_epe_remove(struct platform_device *pdev)
+{
+	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
+
+	regulator_unregister(dcdc->regulator);
+	kfree(dcdc);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_epe_driver = {
+	.probe = wm831x_epe_probe,
+	.remove = __devexit_p(wm831x_epe_remove),
+	.driver		= {
+		.name	= "wm831x-epe",
+	},
+};
+
 static int __init wm831x_dcdc_init(void)
 {
 	int ret;
@@ -624,12 +707,17 @@ static int __init wm831x_dcdc_init(void)
 	if (ret != 0)
 		pr_err("Failed to register WM831x BUCKP driver: %d\n", ret);
 
+	ret = platform_driver_register(&wm831x_epe_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x EPE driver: %d\n", ret);
+
 	return 0;
 }
 subsys_initcall(wm831x_dcdc_init);
 
 static void __exit wm831x_dcdc_exit(void)
 {
+	platform_driver_unregister(&wm831x_epe_driver);
 	platform_driver_unregister(&wm831x_buckp_driver);
 	platform_driver_unregister(&wm831x_buckv_driver);
 }
-- 
1.6.3.3

