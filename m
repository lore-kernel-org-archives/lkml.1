Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYFPOkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYFPOkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbYFPOff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:35 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50216 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754001AbYFPOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:15 -0400
Message-Id: <20080616143513.902891780@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:55 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 10/16] MMC: S3C24XX: Allow card-detect on non-IRQ capable pin
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-nocdirq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the S3C24XX MMC driver to have the card detect be on
a pin that is not IRQ capable.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-16 15:25:03.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 15:25:04.000000000 +0100
@@ -1145,8 +1145,6 @@ static int s3cmci_probe(struct platform_
 	host->pio_active 	= XFER_NONE;
 
 	host->dma		= S3CMCI_DMA;
-	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
-	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
 
 	host->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!host->mem) {
@@ -1188,14 +1186,20 @@ static int s3cmci_probe(struct platform_
 
 	disable_irq(host->irq);
 
-	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
-	set_irq_type(host->irq_cd, IRQT_BOTHEDGE);
+	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
 
-	if (request_irq(host->irq_cd, s3cmci_irq_cd, 0, DRIVER_NAME, host)) {
-		dev_err(&pdev->dev,
-			"failed to request card detect interrupt.\n");
-		ret = -ENOENT;
-		goto probe_free_irq;
+	if (host->irq_cd >= 0) {
+		if (request_irq(host->irq_cd, s3cmci_irq_cd,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				DRIVER_NAME, host)) {
+			dev_err(&pdev->dev, "can't get card detect irq.\n");
+			ret = -ENOENT;
+			goto probe_free_irq;
+		}
+	} else {
+		dev_warn(&pdev->dev, "host detect has no irq available\n");
+		s3c2410_gpio_cfgpin(host->pdata->gpio_detect,
+				    S3C2410_GPIO_INPUT);
 	}
 
 	if (host->pdata->gpio_wprotect)
@@ -1261,7 +1265,8 @@ static int s3cmci_probe(struct platform_
 	clk_put(host->clk);
 
  probe_free_irq_cd:
-	free_irq(host->irq_cd, host);
+	if (host->irq_cd >= 0)
+		free_irq(host->irq_cd, host);
 
  probe_free_irq:
 	free_irq(host->irq, host);
@@ -1291,7 +1296,8 @@ static int s3cmci_remove(struct platform
 	tasklet_disable(&host->pio_tasklet);
 	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
 
-	free_irq(host->irq_cd, host);
+	if (host->irq_cd >= 0)
+		free_irq(host->irq_cd, host);
 	free_irq(host->irq, host);
 
 	iounmap(host->base);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
