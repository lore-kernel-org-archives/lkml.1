Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbZANKKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbZANKKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZANKKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:10:00 -0500
Received: from smtp.nokia.com ([192.100.122.230]:34117 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZANKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:09:59 -0500
Message-ID: <496DBCB1.6020508@nokia.com>
Date: Wed, 14 Jan 2009 12:21:37 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
CC: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] OMAP: HSMMC: Fix response type for busy after response
References: <20090113133827.29474.92645.sendpatchset@ahunter-laptop> <20090113133841.29474.15852.sendpatchset@ahunter-laptop> <496DBC4B.2000609@nokia.com>
In-Reply-To: <496DBC4B.2000609@nokia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2009 10:09:21.0601 (UTC) FILETIME=[2B6F9310:01C97630]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f1038d1f1b3360130b41ffe77c568d76bc4102e9 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
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

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   40 +++++++++++++++++++++++++++++++---------
 1 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 115d114..3ce2a38 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -151,6 +151,7 @@ struct mmc_omap_host {
 	int			initstr;
 	int			slot_id;
 	int			dbclk_enabled;
+	int			response_busy;
 
 	struct timer_list       idle_timer;
 	spinlock_t		clk_lock;     /* for changing enabled state */
@@ -288,10 +289,14 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
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
 
@@ -326,6 +331,15 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
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
@@ -368,7 +382,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 			cmd->resp[0] = OMAP_HSMMC_READ(host->base, RSP10);
 		}
 	}
-	if (host->data == NULL || cmd->error) {
+	if ((host->data == NULL && !host->response_busy) || cmd->error) {
 		host->mrq = NULL;
 		mmc_omap_fclk_lazy_disable(host);
 		mmc_request_done(host->mmc, cmd->mrq);
@@ -433,7 +447,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
 
-	if (host->cmd == NULL && host->data == NULL) {
+	if (host->mrq == NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
 			OMAP_HSMMC_READ(host->base, STAT));
 		return IRQ_HANDLED;
@@ -464,8 +478,11 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				}
 				end_cmd = 1;
 			}
-			if (host->data) {
-				mmc_dma_cleanup(host, -ETIMEDOUT);
+			if (host->data || host->response_busy) {
+				if (host->data)
+					mmc_dma_cleanup(host, -ETIMEDOUT);
+				host->response_busy = 0;
+
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
@@ -475,11 +492,16 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			}
 		}
 		if ((status & DATA_TIMEOUT) || (status & DATA_CRC)) {
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
+
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
-- 
1.5.4.3

