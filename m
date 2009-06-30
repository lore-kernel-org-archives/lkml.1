Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZF3PcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZF3PcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZF3Pbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:31:44 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4312 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZF3Pbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:31:42 -0400
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
Subject: [PATCH V2 3/3] msm_sdcc.c: Move overly indented code to separate function
Date: Tue, 30 Jun 2009 08:31:39 -0700
Message-Id: <fe6ed2705438ee22314ffb265d9e7cdc83e714d0.1246371534.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246371533.git.joe@perches.com>
References: <20090630132112.GB28447@elf.ucw.cz> <cover.1246371533.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/msm_sdcc.c |  132 ++++++++++++++++++++----------------------
 1 files changed, 63 insertions(+), 69 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 874de6a..9bd4f6a 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -584,6 +584,67 @@ static void msmsdcc_do_cmdirq(struct msmsdcc_host *host, uint32_t status)
 		msmsdcc_start_data(host, cmd->data);
 }
 
+static void
+msmsdcc_handle_irq_data(struct msmsdcc_host *host, u32 status,
+			void __iomem *base)
+{
+	struct mmc_data *data = host->curr.data;
+
+	if (!data)
+		return;
+
+	/* Check for data errors */
+	if (status & (MCI_DATACRCFAIL | MCI_DATATIMEOUT |
+		      MCI_TXUNDERRUN | MCI_RXOVERRUN)) {
+		msmsdcc_data_err(host, data, status);
+		host->curr.data_xfered = 0;
+		if (host->dma.sg)
+			msm_dmov_stop_cmd(host->dma.channel,
+					  &host->dma.hdr, 0);
+		else {
+			msmsdcc_stop_data(host);
+			if (!data->stop)
+				msmsdcc_request_end(host, data->mrq);
+			else
+				msmsdcc_start_command(host, data->stop, 0);
+		}
+	}
+
+	/* Check for data done */
+	if (!host->curr.got_dataend && (status & MCI_DATAEND))
+		host->curr.got_dataend = 1;
+
+	if (!host->curr.got_datablkend && (status & MCI_DATABLOCKEND))
+		host->curr.got_datablkend = 1;
+
+	/*
+	 * If DMA is still in progress, we complete via the completion handler
+	 */
+	if (host->curr.got_dataend && host->curr.got_datablkend &&
+	    !host->dma.busy) {
+		/*
+		 * There appears to be an issue in the controller where
+		 * if you request a small block transfer (< fifo size),
+		 * you may get your DATAEND/DATABLKEND irq without the
+		 * PIO data irq.
+		 *
+		 * Check to see if there is still data to be read,
+		 * and simulate a PIO irq.
+		 */
+		if (readl(base + MMCISTATUS) & MCI_RXDATAAVLBL)
+			msmsdcc_pio_irq(1, host);
+
+		msmsdcc_stop_data(host);
+		if (!data->error)
+			host->curr.data_xfered = host->curr.xfer_size;
+
+		if (!data->stop)
+			msmsdcc_request_end(host, data->mrq);
+		else
+			msmsdcc_start_command(host, data->stop, 0);
+	}
+}
+
 static irqreturn_t
 msmsdcc_irq(int irq, void *dev_id)
 {
@@ -596,79 +657,12 @@ msmsdcc_irq(int irq, void *dev_id)
 	spin_lock(&host->lock);
 
 	do {
-		struct mmc_data *data;
 		status = readl(base + MMCISTATUS);
 
-		status &= (readl(base + MMCIMASK0) |
-					      MCI_DATABLOCKENDMASK);
+		status &= (readl(base + MMCIMASK0) | MCI_DATABLOCKENDMASK);
 		writel(status, base + MMCICLEAR);
 
-		data = host->curr.data;
-		if (data) {
-			/* Check for data errors */
-			if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|
-				      MCI_TXUNDERRUN|MCI_RXOVERRUN)) {
-				msmsdcc_data_err(host, data, status);
-				host->curr.data_xfered = 0;
-				if (host->dma.sg)
-					msm_dmov_stop_cmd(host->dma.channel,
-							  &host->dma.hdr, 0);
-				else {
-					msmsdcc_stop_data(host);
-					if (!data->stop)
-						msmsdcc_request_end(host,
-								    data->mrq);
-					else
-						msmsdcc_start_command(host,
-								     data->stop,
-								     0);
-				}
-			}
-
-			/* Check for data done */
-			if (!host->curr.got_dataend && (status & MCI_DATAEND))
-				host->curr.got_dataend = 1;
-
-			if (!host->curr.got_datablkend &&
-			    (status & MCI_DATABLOCKEND)) {
-				host->curr.got_datablkend = 1;
-			}
-
-			if (host->curr.got_dataend &&
-			    host->curr.got_datablkend) {
-				/*
-				 * If DMA is still in progress, we complete
-				 * via the completion handler
-				 */
-				if (!host->dma.busy) {
-					/*
-					 * There appears to be an issue in the
-					 * controller where if you request a
-					 * small block transfer (< fifo size),
-					 * you may get your DATAEND/DATABLKEND
-					 * irq without the PIO data irq.
-					 *
-					 * Check to see if theres still data
-					 * to be read, and simulate a PIO irq.
-					 */
-					if (readl(base + MMCISTATUS) &
-							       MCI_RXDATAAVLBL)
-						msmsdcc_pio_irq(1, host);
-
-					msmsdcc_stop_data(host);
-					if (!data->error)
-						host->curr.data_xfered =
-							host->curr.xfer_size;
-
-					if (!data->stop)
-						msmsdcc_request_end(host,
-								    data->mrq);
-					else
-						msmsdcc_start_command(host,
-							      data->stop, 0);
-				}
-			}
-		}
+		msmsdcc_handle_irq_data(host, status, base);
 
 		if (status & (MCI_CMDSENT | MCI_CMDRESPEND | MCI_CMDCRCFAIL |
 			      MCI_CMDTIMEOUT) && host->curr.cmd) {
-- 
1.6.3.1.10.g659a0.dirty

