Return-Path: <linux-kernel-owner+w=401wt.eu-S1764705AbYFFP6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764705AbYFFP6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbYFFPze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51784 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756577AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155526.269677007@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:26 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 09/15] MMC: Allow card-detect to be on an non-IRQ capable pin on the S3C24XX
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-nocdirq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the S3C24XX MMC driver to have the card detect be on
a pin that is not IRQ capable.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:32.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:34.000000000 +0100
@@ -1150,8 +1150,6 @@ static int s3cmci_probe(struct platform_
 	host->pio_active 	= XFER_NONE;
 
 	host->dma		= S3CMCI_DMA;
-	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
-	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
 
 	host->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!host->mem) {
@@ -1193,15 +1191,23 @@ static int s3cmci_probe(struct platform_
 
 	disable_irq(host->irq);
 
-	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
-	set_irq_type(host->irq_cd, IRQT_BOTHEDGE);
+	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
 
-	if (request_irq(host->irq_cd, s3cmci_irq_cd, 0, DRIVER_NAME, host)) {
-		dev_err(&pdev->dev,
-			"failed to request card detect interrupt.\n");
+	if (host->irq_cd >= 0) {
+		set_irq_type(host->irq_cd, IRQT_BOTHEDGE);
 
-		ret = -ENOENT;
-		goto probe_free_irq;
+		if (request_irq(host->irq_cd, s3cmci_irq_cd,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, DRIVER_NAME, host)) {
+			dev_err(&pdev->dev,
+				"failed to request card detect interrupt.\n");
+	  
+			ret = -ENOENT;
+			goto probe_free_irq;
+		}
+	} else {
+		dev_warn(&pdev->dev, "host detect has no irq available\n");
+		s3c2410_gpio_cfgpin(host->pdata->gpio_detect,
+				    S3C2410_GPIO_INPUT);
 	}
 
 	if (host->pdata->gpio_wprotect)
@@ -1264,7 +1270,8 @@ static int s3cmci_probe(struct platform_
 	clk_put(host->clk);
 
  probe_free_irq_cd:
- 	free_irq(host->irq_cd, host);
+	if (host->irq_cd >= 0)
+		free_irq(host->irq_cd, host);
 
  probe_free_irq:
  	free_irq(host->irq, host);
@@ -1290,8 +1297,11 @@ static int s3cmci_remove(struct platform
 	clk_disable(host->clk);
 	clk_put(host->clk);
 	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
- 	free_irq(host->irq_cd, host);
+
+	if (host->irq_cd >= 0)
+		free_irq(host->irq_cd, host);
  	free_irq(host->irq, host);
+
 	iounmap(host->base);
 	release_mem_region(host->mem->start, RESSIZE(host->mem));
 	mmc_free_host(mmc);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
