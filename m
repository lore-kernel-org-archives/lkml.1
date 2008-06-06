Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbYFFP4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbYFFP4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbYFFPzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:31 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51780 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756696AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155525.883349725@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:24 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 07/15] MMC: Add support to invert S3C24XX write protect line
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-roinvert.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for inverting the sense of the MMC driver's write
protect detection line.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:04.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:30.000000000 +0100
@@ -1082,11 +1082,18 @@ static void s3cmci_reset(struct s3cmci_h
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
Index: linux-2.6.26-rc5-q/include/asm-arm/arch-s3c2410/mci.h
===================================================================
--- linux-2.6.26-rc5-q.orig/include/asm-arm/arch-s3c2410/mci.h	2008-06-06 15:46:04.000000000 +0100
+++ linux-2.6.26-rc5-q/include/asm-arm/arch-s3c2410/mci.h	2008-06-06 15:46:30.000000000 +0100
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
