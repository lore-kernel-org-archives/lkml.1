Return-Path: <linux-kernel-owner+w=401wt.eu-S1764604AbYFFP7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764604AbYFFP7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbYFFPzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:36 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51819 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760266AbYFFPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:31 -0400
Message-Id: <20080606155524.923688919@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:19 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 02/15] MMC: S3C24XX MMC/SD driver write fixes From: Harald Welte <laforge@openmoko.org>
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci_dbg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a workaround of some S3C2410 MMC chip bug

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:31:39.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:45:55.000000000 +0100
@@ -441,11 +441,17 @@ static irqreturn_t s3cmci_irq(int irq, v
 
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
