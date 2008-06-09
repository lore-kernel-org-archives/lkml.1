Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYFIGhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYFIGhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbYFIGhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:37:36 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:49730 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbYFIGhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:37:35 -0400
Date: Mon, 9 Jun 2008 08:37:33 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] au1xmmc: enable 4 bit transfer mode
Message-ID: <20080609063733.GD8724@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609063521.GA8724@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f05df3bb70a64b2996e2c8f1591be35a351959c2 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Sat, 17 May 2008 17:53:57 +0200
Subject: [PATCH] au1xmmc: enable 4 bit transfer mode

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index d8776d6..2bd4cf4 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -95,14 +95,13 @@ static inline void IRQ_OFF(struct au1xmmc_host *host, u32 mask)
 
 static inline void SEND_STOP(struct au1xmmc_host *host)
 {
-
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
@@ -697,6 +696,7 @@ static void au1xmmc_reset_controller(struct au1xmmc_host *host)
 static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 {
 	struct au1xmmc_host *host = mmc_priv(mmc);
+	u32 config2;
 
 	if (ios->power_mode == MMC_POWER_OFF)
 		au1xmmc_set_power(host, 0);
@@ -708,6 +708,18 @@ static void au1xmmc_set_ios(struct mmc_host* mmc, struct mmc_ios* ios)
 		au1xmmc_set_clock(host, ios->clock);
 		host->clock = ios->clock;
 	}
+
+	config2 = au_readl(HOST_CONFIG2(host));
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_4:
+		config2 |= SD_CONFIG2_WB;
+		break;
+	case MMC_BUS_WIDTH_1:
+		config2 &= ~SD_CONFIG2_WB;
+		break;
+	}
+	au_writel(config2, HOST_CONFIG2(host));
+	au_sync();
 }
 
 #define STATUS_TIMEOUT (SD_STATUS_RAT | SD_STATUS_DT)
@@ -952,7 +964,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	mmc->max_blk_count = 512;
 
 	mmc->ocr_avail = AU1XMMC_OCR;
-	mmc->caps = 0;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
 
 	host->status = HOST_S_IDLE;
 
-- 
1.5.5.3

