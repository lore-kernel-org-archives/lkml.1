Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbYHLIZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbYHLIZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYHLIYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:24:52 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55321 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575AbYHLIYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:24:51 -0400
Subject: MMC: s3cmci: attach get_cd host ops
Message-Id: <20080812082449.729133366@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-mmc-fix-card-detect.patch
Date: Tue, 12 Aug 2008 09:24:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attach the routine to get_cd to allow the MMC core to find out whether
there is a card present or not without the tedious process of trying to
send commands to the card or not.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc2-quilt3/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.27-rc2-quilt3.orig/drivers/mmc/host/s3cmci.c	2008-08-11 23:33:09.000000000 +0100
+++ linux-2.6.27-rc2-quilt3/drivers/mmc/host/s3cmci.c	2008-08-11 23:39:33.000000000 +0100
@@ -1004,8 +1004,9 @@ static void s3cmci_send_request(struct m
 	enable_irq(host->irq);
 }
 
-static int s3cmci_card_present(struct s3cmci_host *host)
+static int s3cmci_card_present(struct mmc_host *mmc)
 {
+	struct s3cmci_host *host = mmc_priv(mmc);
 	struct s3c24xx_mci_pdata *pdata = host->pdata;
 	int ret;
 
@@ -1024,7 +1025,7 @@ static void s3cmci_request(struct mmc_ho
 	host->cmd_is_stop = 0;
 	host->mrq = mrq;
 
-	if (s3cmci_card_present(host) == 0) {
+	if (s3cmci_card_present(mmc) == 0) {
 		dbg(host, dbg_err, "%s: no medium present\n", __func__);
 		host->mrq->cmd->error = -ENOMEDIUM;
 		mmc_request_done(mmc, mrq);
@@ -1139,6 +1140,7 @@ static struct mmc_host_ops s3cmci_ops = 
 	.request	= s3cmci_request,
 	.set_ios	= s3cmci_set_ios,
 	.get_ro		= s3cmci_get_ro,
+	.get_cd		= s3cmci_card_present,
 };
 
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
