Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZCLQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZCLQXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZCLQXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:23:01 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25150 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbZCLQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:22:58 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Mar 2009 18:23:06 +0200
Message-Id: <20090312162306.19421.92821.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
Subject: [PATCH 2/10] OMAP: HSMMC: Fix response type for busy after response
X-OriginalArrivalTime: 12 Mar 2009 16:22:41.0748 (UTC) FILETIME=[C4828140:01C9A32E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3fcbf97e7275765c878d24837f95a15764dd20f5 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Mon, 12 Jan 2009 16:13:08 +0200
Subject: [PATCH] OMAP: HSMMC: Fix response type for busy after response

Some MMC commands result in the card becoming busy after
the response is received.  This needs to be specified
for the omap_hsmmc host controller, which is what this
patch does.  However, the effect is that some commands
with no data will cause a Transfer Complete (TC) interrupt
in addition to the Command Complete (CC) interrupt.
In order to deal with that, the irq handler has needed
a few changes also.

The benefit of this change is that the omap_hsmmc host
controller driver now waits for the TC interrupt while
the card is busy, so the mmc_block driver needs to poll
the card status just once instead of repeatedly.
i.e. the net result is more sleep and less cpu.

The command sequence for open-ended multi-block write
with DMA is now:

	Issue write command CMD25
	Receive CC interrupt
	Data is sent
	Receive TC interrupt (DMA is done)
	Issue stop command CMD12
	Receive CC interrupt
	Card is busy
	Receive TC interrupt
	Card is now ready for next transfer

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 5ff2ca2..1f84bd4 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -150,6 +150,7 @@ struct mmc_omap_host {
 	int			initstr;
 	int			slot_id;
 	int			dbclk_enabled;
+	int			response_busy;
 	struct	omap_mmc_platform_data	*pdata;
 };
 
@@ -244,10 +245,14 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
 	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
 	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
 
+	host->response_busy = 0;
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136)
 			resptype = 1;
-		else
+		else if (cmd->flags & MMC_RSP_BUSY) {
+			resptype = 3;
+			host->response_busy = 1;
+		} else
 			resptype = 2;
 	}
 
@@ -282,6 +287,15 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
 static void
 mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 {
+	if (!data) {
+		struct mmc_request *mrq = host->mrq;
+
+		host->mrq = NULL;
+		mmc_omap_fclk_lazy_disable(host);
+		mmc_request_done(host->mmc, mrq);
+		return;
+	}
+
 	host->data = NULL;
 
 	if (host->use_dma && host->dma_ch != -1)
@@ -323,7 +337,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 			cmd->resp[0] = OMAP_HSMMC_READ(host->base, RSP10);
 		}
 	}
-	if (host->data == NULL || cmd->error) {
+	if ((host->data == NULL && !host->response_busy) || cmd->error) {
 		host->mrq = NULL;
 		mmc_request_done(host->mmc, cmd->mrq);
 	}
@@ -413,7 +427,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
 
-	if (host->cmd == NULL && host->data == NULL) {
+	if (host->mrq == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
 			OMAP_HSMMC_READ(host->base, STAT));
 		return IRQ_HANDLED;
@@ -438,18 +452,24 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				}
 				end_cmd = 1;
 			}
-			if (host->data) {
-				mmc_dma_cleanup(host, -ETIMEDOUT);
+			if (host->data || host->response_busy) {
+				if (host->data)
+					mmc_dma_cleanup(host, -ETIMEDOUT);
+				host->response_busy = 0;
 				mmc_omap_reset_controller_fsm(host, SRD);
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
 			(status & DATA_CRC)) {
-			if (host->data) {
-				if (status & DATA_TIMEOUT)
-					mmc_dma_cleanup(host, -ETIMEDOUT);
+			if (host->data || host->response_busy) {
+				int err = (status & DATA_TIMEOUT) ?
+						-ETIMEDOUT : -EILSEQ;
+
+				if (host->data)
+					mmc_dma_cleanup(host, err);
 				else
-					mmc_dma_cleanup(host, -EILSEQ);
+					host->mrq->cmd->error = err;
+				host->response_busy = 0;
 				mmc_omap_reset_controller_fsm(host, SRD);
 				end_trans = 1;
 			}
-- 
1.5.6.3

