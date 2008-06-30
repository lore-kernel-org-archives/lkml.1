Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbYF3Vvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbYF3Vvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763545AbYF3Vl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:28 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50417 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933141AbYF3VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:12 -0400
Message-Id: <20080630214110.024426598@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:30 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 07/16] MMC: S3C24XX: Add support to invert write protect line
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-roinvert.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for inverting the sense of the MMC driver's write
protect detection line.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:31:46.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:42.000000000 +0100
@@ -1083,11 +1083,18 @@ static void s3cmci_reset(struct s3cmci_h
 static int s3cmci_get_ro(struct mmc_host *mmc)
 {
 	struct s3cmci_host *host = mmc_priv(mmc);
+	struct s3c24xx_mci_pdata *pdata = host->pdata;
+	int ret;
 
-	if (host->pdata->gpio_wprotect == 0)
+	if (pdata->gpio_wprotect == 0)
 		return 0;
 
-	return s3c2410_gpio_getpin(host->pdata->gpio_wprotect);
+	ret = s3c2410_gpio_getpin(pdata->gpio_wprotect);
+
+	if (pdata->wprotect_invert)
+		ret = !ret;
+
+	return ret;
 }
 
 static struct mmc_host_ops s3cmci_ops = {
Index: linux-2.6.26-rc8-next20080627/include/asm-arm/plat-s3c24xx/mci.h
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/include/asm-arm/plat-s3c24xx/mci.h	2008-06-30 12:31:37.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/include/asm-arm/plat-s3c24xx/mci.h	2008-06-30 12:36:42.000000000 +0100
@@ -2,6 +2,8 @@
 #define _ARCH_MCI_H
 
 struct s3c24xx_mci_pdata {
+	unsigned int	wprotect_invert : 1;
+
 	unsigned int	gpio_detect;
 	unsigned int	gpio_wprotect;
 	unsigned long	ocr_avail;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
