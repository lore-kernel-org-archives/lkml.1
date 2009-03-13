Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZCMKQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZCMKQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZCMKQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:16:05 -0400
Received: from smtp.nokia.com ([192.100.122.233]:20517 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZCMKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:16:04 -0400
Message-ID: <49BA326B.8030305@nokia.com>
Date: Fri, 13 Mar 2009 12:16:11 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] OMAP: HSMMC: Fix MMC3 dma
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop> <20090312162353.19421.55941.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162353.19421.55941.sendpatchset@ahunter-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2009 10:15:43.0215 (UTC) FILETIME=[AADABFF0:01C9A3C4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6cdb22ab764bf852097674c26d521d3e8a1e5581 Mon Sep 17 00:00:00 2001
From: Grazvydas Ignotas <notasas@gmail.com>
Date: Sat, 3 Jan 2009 10:36:13 +0000
Subject: [PATCH] OMAP: HSMMC: Fix MMC3 dma

Data transfers on third OMAP3 MMC controller don't work
because DMA line numbers are only defined for MMC1 and MMC2.
Fix that and store line numbers in mmc_omap_host structure
to reduce code size.
Tested on OMAP3 pandora board.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---



This time with Grazvydas Ignotas email address fixed.



 drivers/mmc/host/omap_hsmmc.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 0e47073..91381f4 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -100,6 +100,7 @@
  */
 #define OMAP_MMC1_DEVID		0
 #define OMAP_MMC2_DEVID		1
+#define OMAP_MMC3_DEVID		2
 
 #define MMC_TIMEOUT_MS		20
 #define OMAP_MMC_MASTER_CLOCK	96000000
@@ -147,6 +148,7 @@ struct mmc_omap_host {
 	int			irq;
 	int			carddetect;
 	int			use_dma, dma_ch;
+	int			dma_line_tx, dma_line_rx;
 	int			slot_id;
 	int			dbclk_enabled;
 	int			response_busy;
@@ -652,17 +654,10 @@ static int mmc_omap_get_dma_sync_dev(struct mmc_omap_host *host,
 {
 	int sync_dev;
 
-	if (data->flags & MMC_DATA_WRITE) {
-		if (host->id == OMAP_MMC1_DEVID)
-			sync_dev = OMAP24XX_DMA_MMC1_TX;
-		else
-			sync_dev = OMAP24XX_DMA_MMC2_TX;
-	} else {
-		if (host->id == OMAP_MMC1_DEVID)
-			sync_dev = OMAP24XX_DMA_MMC1_RX;
-		else
-			sync_dev = OMAP24XX_DMA_MMC2_RX;
-	}
+	if (data->flags & MMC_DATA_WRITE)
+		sync_dev = host->dma_line_tx;
+	else
+		sync_dev = host->dma_line_rx;
 	return sync_dev;
 }
 
@@ -1134,6 +1129,25 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 
 	omap_hsmmc_init(host);
 
+	/* Select DMA lines */
+	switch (host->id) {
+	case OMAP_MMC1_DEVID:
+		host->dma_line_tx = OMAP24XX_DMA_MMC1_TX;
+		host->dma_line_rx = OMAP24XX_DMA_MMC1_RX;
+		break;
+	case OMAP_MMC2_DEVID:
+		host->dma_line_tx = OMAP24XX_DMA_MMC2_TX;
+		host->dma_line_rx = OMAP24XX_DMA_MMC2_RX;
+		break;
+	case OMAP_MMC3_DEVID:
+		host->dma_line_tx = OMAP34XX_DMA_MMC3_TX;
+		host->dma_line_rx = OMAP34XX_DMA_MMC3_RX;
+		break;
+	default:
+		dev_err(mmc_dev(host->mmc), "Invalid MMC id\n");
+		goto err_irq;
+	}
+
 	/* Request IRQ for MMC operations */
 	ret = request_irq(host->irq, mmc_omap_irq, IRQF_DISABLED,
 			mmc_hostname(mmc), host);
-- 
1.5.6.3

