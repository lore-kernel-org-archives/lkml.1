Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZG0Ntf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZG0Ntf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZG0Ntd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:49:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59134 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754539AbZG0Nq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 19/22] regulator: Add WM831x DC-DC boost convertor support
Date: Mon, 27 Jul 2009 14:46:09 +0100
Message-Id: <1248702372-29534-19-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of PMICs include a single DC-DC boost convertor.
This adds basic support for this convertor.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/wm831x-dcdc.c |  131 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 97ae40f..3251e22 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -614,6 +614,132 @@ static struct platform_driver wm831x_buckp_driver = {
 };
 
 /*
+ * DCDC boost convertors
+ */
+
+static int wm831x_boostp_get_status(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	int ret;
+
+	/* First, check for errors */
+	ret = wm831x_reg_read(wm831x, WM831X_DCDC_UV_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & (1 << rdev_get_id(rdev))) {
+		dev_dbg(wm831x->dev, "DCDC%d under voltage\n",
+			rdev_get_id(rdev) + 1);
+		return REGULATOR_STATUS_ERROR;
+	}
+
+	/* Is the regulator on? */
+	ret = wm831x_reg_read(wm831x, WM831X_DCDC_STATUS);
+	if (ret < 0)
+		return ret;
+	if (ret & (1 << rdev_get_id(rdev)))
+		return REGULATOR_STATUS_ON;
+	else
+		return REGULATOR_STATUS_OFF;
+}
+
+static struct regulator_ops wm831x_boostp_ops = {
+	.get_status = wm831x_boostp_get_status,
+
+	.is_enabled = wm831x_dcdc_is_enabled,
+	.enable = wm831x_dcdc_enable,
+	.disable = wm831x_dcdc_disable,
+};
+
+static __devinit int wm831x_boostp_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
+	struct wm831x_dcdc *dcdc;
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
+
+	if (pdata->dcdc[id] == NULL)
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
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	dcdc->base = res->start;
+
+	snprintf(dcdc->name, sizeof(dcdc->name), "DCDC%d", id + 1);
+	dcdc->desc.name = dcdc->name;
+	dcdc->desc.id = id;
+	dcdc->desc.type = REGULATOR_VOLTAGE;
+	dcdc->desc.ops = &wm831x_boostp_ops;
+	dcdc->desc.owner = THIS_MODULE;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
+					     pdata->dcdc[id], dcdc);
+	if (IS_ERR(dcdc->regulator)) {
+		ret = PTR_ERR(dcdc->regulator);
+		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	irq = platform_get_irq_byname(pdev, "UV");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_uv_irq,
+				 IRQF_TRIGGER_RISING, dcdc->name,
+				 dcdc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
+			irq, ret);
+		goto err_regulator;
+	}
+
+	platform_set_drvdata(pdev, dcdc);
+
+	return 0;
+
+err_regulator:
+	regulator_unregister(dcdc->regulator);
+err:
+	kfree(dcdc);
+	return ret;
+}
+
+static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
+{
+	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	regulator_unregister(dcdc->regulator);
+	kfree(dcdc);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_boostp_driver = {
+	.probe = wm831x_boostp_probe,
+	.remove = __devexit_p(wm831x_boostp_remove),
+	.driver		= {
+		.name	= "wm831x-boostp",
+	},
+};
+
+/*
  * External Power Enable
  *
  * These aren't actually DCDCs but look like them in hardware so share
@@ -707,6 +833,10 @@ static int __init wm831x_dcdc_init(void)
 	if (ret != 0)
 		pr_err("Failed to register WM831x BUCKP driver: %d\n", ret);
 
+	ret = platform_driver_register(&wm831x_boostp_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x BOOST driver: %d\n", ret);
+
 	ret = platform_driver_register(&wm831x_epe_driver);
 	if (ret != 0)
 		pr_err("Failed to register WM831x EPE driver: %d\n", ret);
@@ -718,6 +848,7 @@ subsys_initcall(wm831x_dcdc_init);
 static void __exit wm831x_dcdc_exit(void)
 {
 	platform_driver_unregister(&wm831x_epe_driver);
+	platform_driver_unregister(&wm831x_boostp_driver);
 	platform_driver_unregister(&wm831x_buckp_driver);
 	platform_driver_unregister(&wm831x_buckv_driver);
 }
-- 
1.6.3.3

