Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbYLBPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbYLBPlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYLBPkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:40:53 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34937 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbYLBPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:40:51 -0500
Message-Id: <20081202154112.788195791@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:40:24 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch 6/8] SDHCI: Check DMA for overruns at end of transfer
Content-Disposition: inline; filename=simtec/s3c64xx/debug-card.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of a transfer, check that the DMA engine in the
SDHCI controller actually did what it was meant to and didn't
overrun the end of the buffer.

This seems to be triggered by a timeout during an CMD25 (multiple block         
write) to a card. The mmc_block module then issues a command to find out        
how much data was moved and this seems to end up triggering this DMA            
check. The result is the card's queue generates an OOPS as the stack has        
been trampled on due to the extra data transfered.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux.git/drivers/mmc/host/sdhci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-10-29 16:59:38.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-10-29 16:59:41.000000000 +0000
@@ -736,6 +736,23 @@ static void sdhci_set_transfer_mode(stru
 	writew(mode, host->ioaddr + SDHCI_TRANSFER_MODE);
 }
 
+static void shdci_check_dma_overrun(struct sdhci_host *host, struct mmc_data *data)
+{
+	u32 dma_pos = readl(host->ioaddr + SDHCI_DMA_ADDRESS);
+	u32 dma_start = sg_dma_address(data->sg);
+	u32 dma_end = dma_start + data->sg->length;
+
+	/* Test whether we ended up moving more data than
+	 * was originally requested. */
+
+	if (dma_pos <= dma_end)
+		return;
+
+	printk(KERN_ERR "%s: dma overrun, dma %08x, req %08x..%08x\n",
+	       mmc_hostname(host->mmc), dma_pos,
+	       dma_start, dma_end);
+}
+
 static void sdhci_finish_data(struct sdhci_host *host)
 {
 	struct mmc_data *data;
@@ -749,6 +766,8 @@ static void sdhci_finish_data(struct sdh
 		if (host->flags & SDHCI_USE_ADMA)
 			sdhci_adma_table_post(host, data);
 		else {
+			shdci_check_dma_overrun(host, data);
+
 			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
 				data->sg_len, (data->flags & MMC_DATA_READ) ?
 					DMA_FROM_DEVICE : DMA_TO_DEVICE);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
