Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYFPOh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYFPOh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYFPOfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:22 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50210 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753954AbYFPOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:14 -0400
Message-Id: <20080616143513.455971153@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:53 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 08/16] MMC: S3C24XX: Add support to invert write protect line
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-roinvert.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for inverting the sense of the MMC driver's write
protect detection line.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-16 15:24:59.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 15:25:01.000000000 +0100
@@ -1076,11 +1076,18 @@ static void s3cmci_reset(struct s3cmci_h
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
Index: linux-2.6.26-rc5-q2/include/asm-arm/arch-s3c2410/mci.h
===================================================================
--- linux-2.6.26-rc5-q2.orig/include/asm-arm/arch-s3c2410/mci.h	2008-06-16 15:24:59.000000000 +0100
+++ linux-2.6.26-rc5-q2/include/asm-arm/arch-s3c2410/mci.h	2008-06-16 15:25:01.000000000 +0100
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
