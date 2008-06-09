Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYFIGiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYFIGiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYFIGiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:38:08 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:47167 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbYFIGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:38:07 -0400
Date: Mon, 9 Jun 2008 08:38:03 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] au1xmmc: SDIO IRQ support.
Message-ID: <20080609063803.GE8724@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609063521.GA8724@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e4bbe21c402e8cdd3a1536db36779f3cae6d47d8 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Sat, 17 May 2008 17:58:52 +0200
Subject: [PATCH] au1xmmc: SDIO IRQ support

Wire up the SD controllers' SDIO IRQ capability.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 2bd4cf4..16b5640 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -736,6 +736,9 @@ static irqreturn_t au1xmmc_irq(int irq, void *dev_id)
 	if (!(status & SD_STATUS_I))
 		return IRQ_NONE;	/* not ours */
 
+	if (status & SD_STATUS_SI)	/* SDIO */
+		mmc_signal_sdio_irq(host->mmc);
+
 	if (host->mrq && (status & STATUS_TIMEOUT)) {
 		if (status & SD_STATUS_RAT)
 			host->mrq->cmd->error = -ETIMEDOUT;
@@ -862,10 +865,21 @@ static void au1xmmc_dbdma_shutdown(struct au1xmmc_host *host)
 }
 #endif
 
+static void au1xmmc_enable_sdio_irq(struct mmc_host *mmc, int en)
+{
+	struct au1xmmc_host *host = mmc_priv(mmc);
+
+	if (en)
+		IRQ_ON(host, SD_CONFIG_SI);
+	else
+		IRQ_OFF(host, SD_CONFIG_SI);
+}
+
 static const struct mmc_host_ops au1xmmc_ops = {
 	.request	= au1xmmc_request,
 	.set_ios	= au1xmmc_set_ios,
 	.get_ro		= au1xmmc_card_readonly,
+	.enable_sdio_irq = au1xmmc_enable_sdio_irq,
 };
 
 static void au1xmmc_poll_event(unsigned long arg)
@@ -964,7 +978,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	mmc->max_blk_count = 512;
 
 	mmc->ocr_avail = AU1XMMC_OCR;
-	mmc->caps = MMC_CAP_4_BIT_DATA;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
 
 	host->status = HOST_S_IDLE;
 
-- 
1.5.5.3

