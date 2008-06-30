Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbYF3Vv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbYF3Vv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933171AbYF3Vla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:30 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50423 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933384AbYF3VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:12 -0400
Message-Id: <20080630214110.435818323@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:32 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 09/16] MMC: S3C24XX: Allow card-detect on non-IRQ capable pin
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-nocdirq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the S3C24XX MMC driver to have the card detect be on
a pin that is not IRQ capable.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:49.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:51.000000000 +0100
@@ -1150,8 +1150,6 @@ static int __devinit s3cmci_probe(struct
 	host->pio_active 	= XFER_NONE;
 
 	host->dma		= S3CMCI_DMA;
-	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
-	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
 
 	host->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!host->mem) {
@@ -1197,14 +1195,20 @@ static int __devinit s3cmci_probe(struct
 
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
@@ -1273,7 +1277,8 @@ static int __devinit s3cmci_probe(struct
 	clk_put(host->clk);
 
  probe_free_irq_cd:
-	free_irq(host->irq_cd, host);
+	if (host->irq_cd >= 0)
+		free_irq(host->irq_cd, host);
 
  probe_free_irq:
 	free_irq(host->irq, host);
@@ -1303,7 +1308,8 @@ static int s3cmci_remove(struct platform
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
