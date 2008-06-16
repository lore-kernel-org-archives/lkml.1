Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYFPOgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYFPOgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYFPOfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:17 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50190 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753868AbYFPOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:14 -0400
Message-Id: <20080616143512.400250136@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:48 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 03/16] MMC: S3C24XX MMC/SD driver write fixes
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci_dbg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@openmoko.org>

This patch is a workaround of some S3C2410 MMC chip bug

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-16 14:19:18.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 14:19:44.000000000 +0100
@@ -454,11 +454,17 @@ static irqreturn_t s3cmci_irq(int irq, v
 
 	if (mci_csta & S3C2410_SDICMDSTAT_CRCFAIL) {
 		if (cmd->flags & MMC_RSP_CRC) {
-			cmd->error = MMC_ERR_BADCRC;
-			host->status = "error: bad command crc";
-			goto fail_transfer;
+			if (host->mrq->cmd->flags & MMC_RSP_136) {
+				dbg(host, dbg_irq,
+				    "fixup: ignore CRC fail with long rsp\n");
+			} else {
+#if 0
+				cmd->error = MMC_ERR_BADCRC;
+				host->status = "error: bad command crc";
+				goto fail_transfer;
+#endif
+			}
 		}
-
 		mci_cclear |= S3C2410_SDICMDSTAT_CRCFAIL;
 	}
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
