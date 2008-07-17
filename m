Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYGQOdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYGQOdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbYGQOc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:32:56 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:53657 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755849AbYGQOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:32:56 -0400
Subject: MMC: s3cmci: ensure host stopped on machine shutdown
Message-Id: <20080717143253.823429733@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-mmc-shutdown.patch
Date: Thu, 17 Jul 2008 15:32:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the s3cmci host controller is turned off
when the machine is shutdown, otherwise we end up
leaving the card powered and processing insertion and
removal events after the system prints "System halted."

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-quilt3.orig/drivers/mmc/host/s3cmci.c	2008-07-17 15:15:35.000000000 +0100
+++ linux-2.6.26-quilt3/drivers/mmc/host/s3cmci.c	2008-07-17 15:29:23.000000000 +0100
@@ -1331,21 +1331,30 @@ static int __devinit s3cmci_probe(struct
 	return ret;
 }
 
+static void s3cmci_shutdown(struct platform_device *pdev)
+{
+	struct mmc_host	*mmc = platform_get_drvdata(pdev);
+	struct s3cmci_host *host = mmc_priv(mmc);
+
+	if (host->irq_cd >= 0)
+		free_irq(host->irq_cd, host);
+
+	mmc_remove_host(mmc);
+	clk_disable(host->clk);
+}
+
 static int __devexit s3cmci_remove(struct platform_device *pdev)
 {
 	struct mmc_host		*mmc  = platform_get_drvdata(pdev);
 	struct s3cmci_host	*host = mmc_priv(mmc);
 
-	mmc_remove_host(mmc);
+	s3cmci_shutdown(pdev);
 
-	clk_disable(host->clk);
 	clk_put(host->clk);
 
 	tasklet_disable(&host->pio_tasklet);
 	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
 
-	if (host->irq_cd >= 0)
-		free_irq(host->irq_cd, host);
 	free_irq(host->irq, host);
 
 	iounmap(host->base);
@@ -1397,6 +1406,7 @@ static struct platform_driver s3cmci_241
 	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_2410_probe,
 	.remove		= __devexit_p(s3cmci_remove),
+	.shutdown	= s3cmci_shutdown,
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
@@ -1406,6 +1416,7 @@ static struct platform_driver s3cmci_241
 	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_2412_probe,
 	.remove		= __devexit_p(s3cmci_remove),
+	.shutdown	= s3cmci_shutdown,
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
@@ -1415,6 +1426,7 @@ static struct platform_driver s3cmci_244
 	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_2440_probe,
 	.remove		= __devexit_p(s3cmci_remove),
+	.shutdown	= s3cmci_shutdown,
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
