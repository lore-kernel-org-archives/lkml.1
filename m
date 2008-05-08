Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbYEHIEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbYEHIEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbYEHIEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:04:20 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:34471 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYEHIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:04:18 -0400
Date: Thu, 8 May 2008 10:04:16 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] au1xmmc: 4 bit transfer mode
Message-ID: <20080508080416.GF24383@roarinelk.homelinux.net>
References: <20080508080040.GA24383@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508080040.GA24383@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f850f29297156c673fe3453c4c1c4642c46567e2 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 15:04:51 +0200
Subject: [PATCH] au1xmmc: 4 bit transfer mode

Add 4 Bit transfer mode support.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 8660f86..d9e334f 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -161,13 +161,13 @@ static inline void IRQ_OFF(struct au1xmmc_host *host, u32 mask)
 static inline void SEND_STOP(struct au1xmmc_host *host)
 {
 
-	/* We know the value of CONFIG2, so avoid a read we don't need */
-	u32 mask = SD_CONFIG2_EN;
+	u32 config2;
 
 	WARN_ON(host->status != HOST_S_DATA);
 	host->status = HOST_S_STOP;
 
-	au_writel(mask | SD_CONFIG2_DF, HOST_CONFIG2(host));
+	config2 = au_readl(HOST_CONFIG2(host));
+	au_writel(config2 | SD_CONFIG2_DF, HOST_CONFIG2(host));
 	au_sync();
 
 	/* Send the stop commmand */
@@ -762,6 +762,7 @@ static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
+	u32 config;
 
 	if (ios->power_mode == MMC_POWER_OFF)
 		au1xmmc_set_power(host, 0);
@@ -773,6 +774,18 @@ static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 		au1xmmc_set_clock(host, ios->clock);
 		host->clock = ios->clock;
 	}
+
+	config = au_readl(HOST_CONFIG2(host));
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_4:
+		config |= (1 << 8);
+		break;
+	case MMC_BUS_WIDTH_1:
+		config &= ~(1 << 8);
+		break;
+	}
+	au_writel(config, HOST_CONFIG2(host));
+	au_sync();
 }
 
 static void au1xmmc_dma_callback(int irq, void *dev_id)
@@ -985,7 +998,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	mmc->max_blk_count = 512;
 
 	mmc->ocr_avail = AU1XMMC_OCR;
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
 
 	host->id = pdev->id;
 	host->status = HOST_S_IDLE;
-- 
1.5.5.1

