Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbYF3VuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbYF3VuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933470AbYF3Vl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:26 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50440 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933391AbYF3VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:12 -0400
Message-Id: <20080630214111.628099117@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:37 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 14/16] MMC: S3C24XX: Update error debugging.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-debug-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add better debugging to show where errors are being
generated, as some error codes can come from several
different code paths.

Also fix the error return path from s3cmci_setup_data()
to return the error it returned to the request.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 22:35:48.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 22:35:49.000000000 +0100
@@ -450,6 +450,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 	}
 
 	if (mci_csta & S3C2410_SDICMDSTAT_CMDTIMEOUT) {
+		dbg(host, dbg_err, "CMDSTAT: error CMDTIMEOUT\n");
 		cmd->error = -ETIMEDOUT;
 		host->status = "error: command timeout";
 		goto fail_transfer;
@@ -505,12 +506,14 @@ static irqreturn_t s3cmci_irq(int irq, v
 	/* Check for FIFO failure */
 	if (host->is2440) {
 		if (mci_fsta & S3C2440_SDIFSTA_FIFOFAIL) {
+			dbg(host, dbg_err, "FIFO failure\n");
 			host->mrq->data->error = -EILSEQ;
 			host->status = "error: 2440 fifo failure";
 			goto fail_transfer;
 		}
 	} else {
 		if (mci_dsta & S3C2410_SDIDSTA_FIFOFAIL) {
+			dbg(host, dbg_err, "FIFO failure\n");
 			cmd->data->error = -EILSEQ;
 			host->status = "error:  fifo failure";
 			goto fail_transfer;
@@ -518,18 +521,21 @@ static irqreturn_t s3cmci_irq(int irq, v
 	}
 
 	if (mci_dsta & S3C2410_SDIDSTA_RXCRCFAIL) {
+		dbg(host, dbg_err, "bad data crc (outgoing)\n");
 		cmd->data->error = -EILSEQ;
 		host->status = "error: bad data crc (outgoing)";
 		goto fail_transfer;
 	}
 
 	if (mci_dsta & S3C2410_SDIDSTA_CRCFAIL) {
+		dbg(host, dbg_err, "bad data crc (incoming)\n");
 		cmd->data->error = -EILSEQ;
 		host->status = "error: bad data crc (incoming)";
 		goto fail_transfer;
 	}
 
 	if (mci_dsta & S3C2410_SDIDSTA_DATATIMEOUT) {
+		dbg(host, dbg_err, "data timeout\n");
 		cmd->data->error = -ETIMEDOUT;
 		host->status = "error: data timeout";
 		goto fail_transfer;
@@ -956,8 +962,9 @@ static void s3cmci_send_request(struct m
 		host->dcnt++;
 
 		if (res) {
-			cmd->error = -EINVAL;
-			cmd->data->error = -EINVAL;
+			dbg(host, dbg_err, "setup data error %d\n", res);
+			cmd->error = res;
+			cmd->data->error = res;
 
 			mmc_request_done(mmc, mrq);
 			return;
@@ -969,6 +976,7 @@ static void s3cmci_send_request(struct m
 			res = s3cmci_prepare_pio(host, cmd->data);
 
 		if (res) {
+			dbg(host, dbg_err, "data prepare error %d\n", res);
 			cmd->error = res;
 			cmd->data->error = res;
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
