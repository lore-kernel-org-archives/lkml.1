Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0CJSdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:33:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34261 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932717Ab0CJScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:32:53 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] power_supply: Use genirq in wm831x_power
Date: Wed, 10 Mar 2010 18:27:40 +0000
Message-Id: <1268245660-19140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the WM831x core has been converted to use genirq for the
interrupt controller there is no longer any need for chip specific
wrappers for IRQ operations. Convert to use genirq directly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm831x_power.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index f85e80b..bf2ff41 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -536,9 +536,9 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 		goto err_battery;
 
 	irq = platform_get_irq_byname(pdev, "SYSLO");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_syslo_irq,
-				 IRQF_TRIGGER_RISING, "SYSLO",
-				 power);
+	ret = request_threaded_irq(irq, NULL, wm831x_syslo_irq,
+				   IRQF_TRIGGER_RISING, "System power low",
+				   power);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request SYSLO IRQ %d: %d\n",
 			irq, ret);
@@ -546,9 +546,9 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq_byname(pdev, "PWR SRC");
-	ret = wm831x_request_irq(wm831x, irq, wm831x_pwr_src_irq,
-				 IRQF_TRIGGER_RISING, "Power source",
-				 power);
+	ret = request_threaded_irq(irq, NULL, wm831x_pwr_src_irq,
+				   IRQF_TRIGGER_RISING, "Power source",
+				   power);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request PWR SRC IRQ %d: %d\n",
 			irq, ret);
@@ -557,10 +557,10 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
 		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
-		ret = wm831x_request_irq(wm831x, irq, wm831x_bat_irq,
-					 IRQF_TRIGGER_RISING,
-					 wm831x_bat_irqs[i],
-					 power);
+		ret = request_threaded_irq(irq, NULL, wm831x_bat_irq,
+					   IRQF_TRIGGER_RISING,
+					   wm831x_bat_irqs[i],
+					   power);
 		if (ret != 0) {
 			dev_err(&pdev->dev,
 				"Failed to request %s IRQ %d: %d\n",
@@ -574,13 +574,13 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 err_bat_irq:
 	for (; i >= 0; i--) {
 		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
-		wm831x_free_irq(wm831x, irq, power);
+		free_irq(irq, power);
 	}
 	irq = platform_get_irq_byname(pdev, "PWR SRC");
-	wm831x_free_irq(wm831x, irq, power);
+	free_irq(irq, power);
 err_syslo:
 	irq = platform_get_irq_byname(pdev, "SYSLO");
-	wm831x_free_irq(wm831x, irq, power);
+	free_irq(irq, power);
 err_usb:
 	power_supply_unregister(usb);
 err_battery:
@@ -595,19 +595,18 @@ err_kmalloc:
 static __devexit int wm831x_power_remove(struct platform_device *pdev)
 {
 	struct wm831x_power *wm831x_power = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = wm831x_power->wm831x;
 	int irq, i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
 		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
-		wm831x_free_irq(wm831x, irq, wm831x_power);
+		free_irq(irq, wm831x_power);
 	}
 
 	irq = platform_get_irq_byname(pdev, "PWR SRC");
-	wm831x_free_irq(wm831x, irq, wm831x_power);
+	free_irq(irq, wm831x_power);
 
 	irq = platform_get_irq_byname(pdev, "SYSLO");
-	wm831x_free_irq(wm831x, irq, wm831x_power);
+	free_irq(irq, wm831x_power);
 
 	power_supply_unregister(&wm831x_power->battery);
 	power_supply_unregister(&wm831x_power->wall);
-- 
1.7.0

