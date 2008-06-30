Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYF3PaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYF3PaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYF3P1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:55 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60335 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbYF3P1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:50 -0400
Message-Id: <20080630152749.795735357@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:26:01 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 14/17] MMC: S3C24XX: Add media presence test to request handling.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-add-mediacheck.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that we have physical media present before attempting to
send a request to a card. This ensures that we do not get flooded
by errors from commands that can never be completed timing out.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:57.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 15:23:42.000000000 +0100
@@ -984,6 +984,18 @@ static void s3cmci_send_request(struct m
 	enable_irq(host->irq);
 }
 
+static int s3cmci_card_present(struct s3cmci_host *host)
+{
+	struct s3c24xx_mci_pdata *pdata = host->pdata;
+	int ret;
+
+	if (pdata->gpio_detect == 0)
+		return -ENOSYS;
+
+	ret = s3c2410_gpio_getpin(pdata->gpio_detect) ? 0 : 1;
+	return ret ^ pdata->detect_invert;
+}
+
 static void s3cmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct s3cmci_host *host = mmc_priv(mmc);
@@ -992,7 +1004,12 @@ static void s3cmci_request(struct mmc_ho
 	host->cmd_is_stop = 0;
 	host->mrq = mrq;
 
-	s3cmci_send_request(mmc);
+	if (s3cmci_card_present(host) == 0) {
+		dbg(host, dbg_err, "%s: no medium present\n", __func__);
+		host->mrq->cmd->error = -ENOMEDIUM;
+		mmc_request_done(mmc, mrq);
+	} else
+		s3cmci_send_request(mmc);
 }
 
 static void s3cmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
Index: linux-2.6.26-rc8-next20080627/include/asm-arm/plat-s3c24xx/mci.h
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/include/asm-arm/plat-s3c24xx/mci.h	2008-06-30 12:36:42.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/include/asm-arm/plat-s3c24xx/mci.h	2008-06-30 12:37:19.000000000 +0100
@@ -3,6 +3,7 @@
 
 struct s3c24xx_mci_pdata {
 	unsigned int	wprotect_invert : 1;
+	unsigned int	detect_invert : 1;   /* set => detect active high. */
 
 	unsigned int	gpio_detect;
 	unsigned int	gpio_wprotect;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
