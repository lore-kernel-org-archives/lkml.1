Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYF3P3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYF3P3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYF3P1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:52 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60311 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751733AbYF3P1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:49 -0400
Message-Id: <20080630152748.170622054@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:25:54 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 07/17] MMC: S3C24XX: Add platform data for MMC/SD driver
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3c_mci_platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds platform data support to the s3mci driver.  This allows
flexible board-specific configuration of set_power, card detect and read only
pins.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:31:15.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:31:46.000000000 +0100
@@ -21,6 +21,8 @@
 #include <asm/arch/regs-sdi.h>
 #include <asm/arch/regs-gpio.h>
 
+#include <asm/plat-s3c24xx/mci.h>
+
 #include "s3cmci.h"
 
 #define DRIVER_NAME "s3c-mci"
@@ -1011,6 +1013,9 @@ static void s3cmci_set_ios(struct mmc_ho
 		s3c2410_gpio_cfgpin(S3C2410_GPE9, S3C2410_GPE9_SDDAT2);
 		s3c2410_gpio_cfgpin(S3C2410_GPE10, S3C2410_GPE10_SDDAT3);
 
+		if (host->pdata->set_power)
+			host->pdata->set_power(ios->power_mode, ios->vdd);
+
 		if (!host->is2440)
 			mci_con |= S3C2410_SDICON_FIFORESET;
 
@@ -1024,6 +1029,9 @@ static void s3cmci_set_ios(struct mmc_ho
 		if (host->is2440)
 			mci_con |= S3C2440_SDICON_SDRESET;
 
+		if (host->pdata->set_power)
+			host->pdata->set_power(ios->power_mode, ios->vdd);
+
 		break;
 	}
 
@@ -1072,9 +1080,25 @@ static void s3cmci_reset(struct s3cmci_h
 	writel(con, host->base + S3C2410_SDICON);
 }
 
+static int s3cmci_get_ro(struct mmc_host *mmc)
+{
+	struct s3cmci_host *host = mmc_priv(mmc);
+
+	if (host->pdata->gpio_wprotect == 0)
+		return 0;
+
+	return s3c2410_gpio_getpin(host->pdata->gpio_wprotect);
+}
+
 static struct mmc_host_ops s3cmci_ops = {
 	.request	= s3cmci_request,
 	.set_ios	= s3cmci_set_ios,
+	.get_ro		= s3cmci_get_ro,
+};
+
+static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
+	/* This is currently here to avoid a number of if (host->pdata)
+	 * checks. Any zero fields to ensure reaonable defaults are picked. */
 };
 
 static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
@@ -1094,6 +1118,12 @@ static int __devinit s3cmci_probe(struct
 	host->pdev	= pdev;
 	host->is2440	= is2440;
 
+	host->pdata = pdev->dev.platform_data;
+	if (!host->pdata) {
+		pdev->dev.platform_data = &s3cmci_def_pdata;
+		host->pdata = &s3cmci_def_pdata;
+	}
+
 	spin_lock_init(&host->complete_lock);
 	tasklet_init(&host->pio_tasklet, pio_tasklet, (unsigned long) host);
 
@@ -1112,7 +1142,8 @@ static int __devinit s3cmci_probe(struct
 	host->pio_active 	= XFER_NONE;
 
 	host->dma		= S3CMCI_DMA;
-	host->irq_cd		= IRQ_EINT2;
+	host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
+	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
 
 	host->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!host->mem) {
@@ -1158,7 +1189,7 @@ static int __devinit s3cmci_probe(struct
 
 	disable_irq(host->irq);
 
-	s3c2410_gpio_cfgpin(S3C2410_GPF2, S3C2410_GPF2_EINT2);
+	s3c2410_gpio_cfgpin(host->pdata->gpio_detect, S3C2410_GPIO_IRQ);
 	set_irq_type(host->irq_cd, IRQT_BOTHEDGE);
 
 	if (request_irq(host->irq_cd, s3cmci_irq_cd, 0, DRIVER_NAME, host)) {
@@ -1168,6 +1199,10 @@ static int __devinit s3cmci_probe(struct
 		goto probe_free_irq;
 	}
 
+	if (host->pdata->gpio_wprotect)
+		s3c2410_gpio_cfgpin(host->pdata->gpio_wprotect,
+				    S3C2410_GPIO_INPUT);
+
 	if (s3c2410_dma_request(S3CMCI_DMA, &s3cmci_dma_client, NULL)) {
 		dev_err(&pdev->dev, "unable to get DMA channel.\n");
 		ret = -EBUSY;
@@ -1191,11 +1226,14 @@ static int __devinit s3cmci_probe(struct
 	host->clk_rate = clk_get_rate(host->clk);
 
 	mmc->ops 	= &s3cmci_ops;
-	mmc->ocr_avail	= MMC_VDD_32_33;
+	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps	= MMC_CAP_4_BIT_DATA;
 	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
 	mmc->f_max 	= host->clk_rate / host->clk_div;
 
+	if (host->pdata->ocr_avail)
+		mmc->ocr_avail = host->pdata->ocr_avail;
+
 	mmc->max_blk_count	= 4095;
 	mmc->max_blk_size	= 4095;
 	mmc->max_req_size	= 4095 * 512;
Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.h	2008-06-30 12:31:15.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.h	2008-06-30 12:31:37.000000000 +0100
@@ -22,6 +22,7 @@ enum s3cmci_waitfor {
 
 struct s3cmci_host {
 	struct platform_device	*pdev;
+	struct s3c24xx_mci_pdata *pdata;
 	struct mmc_host		*mmc;
 	struct resource		*mem;
 	struct clk		*clk;
Index: linux-2.6.26-rc8-next20080627/include/asm-arm/plat-s3c24xx/mci.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc8-next20080627/include/asm-arm/plat-s3c24xx/mci.h	2008-06-30 12:31:37.000000000 +0100
@@ -0,0 +1,12 @@
+#ifndef _ARCH_MCI_H
+#define _ARCH_MCI_H
+
+struct s3c24xx_mci_pdata {
+	unsigned int	gpio_detect;
+	unsigned int	gpio_wprotect;
+	unsigned long	ocr_avail;
+	void		(*set_power)(unsigned char power_mode,
+				     unsigned short vdd);
+};
+
+#endif /* _ARCH_NCI_H */

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
