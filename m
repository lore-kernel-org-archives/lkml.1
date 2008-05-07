Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbYEGQHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbYEGQHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYEGQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:07:10 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:59225 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbYEGQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:07:07 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 12:07:07 EDT
Date: Wed, 7 May 2008 18:07:05 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] au1xmmc: 4 bit transfer mode
Message-ID: <20080507160705.GF17806@roarinelk.homelinux.net>
References: <20080507160154.GA17806@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507160154.GA17806@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c3bf4d3ee34ecaa3d3ee13d843677ed25da8ca6e Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 15:04:51 +0200
Subject: [PATCH] au1xmmc: 4 bit transfer mode

Add 4 Bit transfer mode support.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 17870cd..8ee7640 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -159,13 +159,13 @@ static inline void IRQ_OFF(struct au1xmmc_host *host, u32 mask)
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
@@ -760,6 +760,7 @@ static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
+	u32 config;
 
 	if (ios->power_mode == MMC_POWER_OFF)
 		au1xmmc_set_power(host, 0);
@@ -771,6 +772,18 @@ static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
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
@@ -983,7 +996,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	mmc->max_blk_count = 512;
 
 	mmc->ocr_avail = AU1XMMC_OCR;
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
 
 	host->id = pdev->id;
 	host->status = HOST_S_IDLE;
-- 
1.5.5.1

