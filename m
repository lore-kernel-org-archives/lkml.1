Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbYF3Vp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbYF3Vp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933402AbYF3VlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:13 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50405 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933461AbYF3VlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:10 -0400
Message-Id: <20080630214108.982655551@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:25 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 02/16] MMC: S3C24XX MMC/SD driver write fixes
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci_dbg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@openmoko.org>

This patch is a workaround of some S3C2410 MMC chip bug

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:18:49.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:04.000000000 +0100
@@ -461,9 +461,19 @@ static irqreturn_t s3cmci_irq(int irq, v
 
 	if (mci_csta & S3C2410_SDICMDSTAT_CRCFAIL) {
 		if (cmd->flags & MMC_RSP_CRC) {
-			cmd->error = -EILSEQ;
-			host->status = "error: bad command crc";
-			goto fail_transfer;
+			if (host->mrq->cmd->flags & MMC_RSP_136) {
+				dbg(host, dbg_irq,
+				    "fixup: ignore CRC fail with long rsp\n");
+			} else {
+				/* note, we used to fail the transfer
+				 * here, but it seems that this is just
+				 * the hardware getting it wrong.
+				 *
+				 * cmd->error = -EILSEQ;
+				 * host->status = "error: bad command crc";
+				 * goto fail_transfer;
+				*/
+			}
 		}
 
 		mci_cclear |= S3C2410_SDICMDSTAT_CRCFAIL;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
