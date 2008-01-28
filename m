Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbYA1TKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbYA1TKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYA1TJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:44 -0500
Received: from smtp.nokia.com ([192.100.122.230]:62278 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015AbYA1TJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:42 -0500
Message-ID: <479E27F3.5020503@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:31 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] MMC: OMAP: New release dma and abort xfer functions
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:17.0086 (UTC) FILETIME=[473E4BE0:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

New functions to support MMC multislot:
mmc_omap_release_dma() and mmc_omap_abort_xfer().

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |   79 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index c6dac7e..4f98bef 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -342,26 +342,32 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd)
 }
 
 static void
+mmc_omap_release_dma(struct mmc_omap_host *host, struct mmc_data *data,
+		     int abort)
+{
+	enum dma_data_direction dma_data_dir;
+
+	BUG_ON(host->dma_ch < 0);
+	if (data->error)
+		omap_stop_dma(host->dma_ch);
+	/* Release DMA channel lazily */
+	mod_timer(&host->dma_timer, jiffies + HZ);
+	if (data->flags & MMC_DATA_WRITE)
+		dma_data_dir = DMA_TO_DEVICE;
+	else
+		dma_data_dir = DMA_FROM_DEVICE;
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_len,
+		     dma_data_dir);
+}
+
+static void
 mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	if (host->dma_in_use) {
-		enum dma_data_direction dma_data_dir;
-
-		BUG_ON(host->dma_ch < 0);
-		if (data->error)
-			omap_stop_dma(host->dma_ch);
-		/* Release DMA channel lazily */
-		mod_timer(&host->dma_timer, jiffies + HZ);
-		if (data->flags & MMC_DATA_WRITE)
-			dma_data_dir = DMA_TO_DEVICE;
-		else
-			dma_data_dir = DMA_FROM_DEVICE;
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_len,
-			     dma_data_dir);
-	}
+	if (host->dma_in_use)
+		mmc_omap_release_dma(host, data, data->error);
+
 	host->data = NULL;
 	host->sg_len = 0;
-	clk_disable(host->fclk);
 
 	/* NOTE:  MMC layer will sometimes poll-wait CMD13 next, issuing
 	 * dozens of requests until the card finishes writing data.
@@ -369,8 +375,12 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 	 */
 
 	if (!data->stop) {
+		struct mmc_host *mmc;
+
 		host->mrq = NULL;
-		mmc_request_done(host->mmc, data->mrq);
+		mmc = host->mmc;
+		mmc_omap_release_slot(host->current_slot);
+		mmc_request_done(mmc, data->mrq);
 		return;
 	}
 
@@ -378,6 +388,32 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 }
 
 static void
+mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
+{
+	int loops;
+	u16 ie;
+
+	if (host->dma_in_use)
+		mmc_omap_release_dma(host, data, 1);
+
+	host->data = NULL;
+	host->sg_len = 0;
+
+	ie = OMAP_MMC_READ(host, IE);
+	OMAP_MMC_WRITE(host, IE, 0);
+	OMAP_MMC_WRITE(host, CMD, 1 << 7);
+	loops = 0;
+	while (!(OMAP_MMC_READ(host, STAT) & OMAP_MMC_STAT_END_OF_CMD)) {
+		udelay(1);
+		loops++;
+		if (loops == 100000)
+			break;
+	}
+	OMAP_MMC_WRITE(host, STAT, OMAP_MMC_STAT_END_OF_CMD);
+	OMAP_MMC_WRITE(host, IE, ie);
+}
+
+static void
 mmc_omap_end_of_data(struct mmc_omap_host *host, struct mmc_data *data)
 {
 	unsigned long flags;
@@ -454,9 +490,14 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 	}
 
 	if (host->data == NULL || cmd->error) {
+		struct mmc_host *mmc;
+
+		if (host->data != NULL)
+			mmc_omap_abort_xfer(host, host->data);
 		host->mrq = NULL;
-		clk_disable(host->fclk);
-		mmc_request_done(host->mmc, cmd->mrq);
+		mmc = host->mmc;
+		mmc_omap_release_slot(host->current_slot);
+		mmc_request_done(mmc, cmd->mrq);
 	}
 }
 
-- 1.5.3.GIT

