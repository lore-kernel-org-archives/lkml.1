Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYCNTnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYCNTnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbYCNTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:41:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50641 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759258AbYCNTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:41:27 -0400
Message-ID: <47DAD3C2.7070407@indt.org.br>
Date: Fri, 14 Mar 2008 15:36:34 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] MMC: OMAP: General cleanup for MMC multislot support
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:39:14.0790 (UTC) FILETIME=[15C2A860:01C8860B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

General code cleanup, modifications at some dev_* functions and
other hacks at mmc_omap_irq() for MMC multislot support.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |   46 +++++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index de508ae..ae0de17 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -547,11 +547,12 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	u16 status;
 	int end_command;
 	int end_transfer;
-	int transfer_error;
+	int transfer_error, cmd_error;
 
 	if (host->cmd == NULL && host->data == NULL) {
 		status = OMAP_MMC_READ(host, STAT);
-		dev_info(mmc_dev(host->mmc),"spurious irq 0x%04x\n", status);
+		dev_info(mmc_dev(host->slots[0]->mmc),
+			 "Spurious IRQ 0x%04x\n", status);
 		if (status != 0) {
 			OMAP_MMC_WRITE(host, STAT, status);
 			OMAP_MMC_WRITE(host, IE, 0);
@@ -562,12 +563,19 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	end_command = 0;
 	end_transfer = 0;
 	transfer_error = 0;
+	cmd_error = 0;
 
 	while ((status = OMAP_MMC_READ(host, STAT)) != 0) {
+		int cmd;
+
 		OMAP_MMC_WRITE(host, STAT, status);
+		if (host->cmd != NULL)
+			cmd = host->cmd->opcode;
+		else
+			cmd = -1;
 #ifdef CONFIG_MMC_DEBUG
 		dev_dbg(mmc_dev(host->mmc), "MMC IRQ %04x (CMD %d): ",
-			status, host->cmd != NULL ? host->cmd->opcode : -1);
+			status, cmd);
 		mmc_omap_report_irq(status);
 		printk("\n");
 #endif
@@ -579,12 +587,12 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				mmc_omap_xfer_data(host, 1);
 		}
 
-		if (status & OMAP_MMC_STAT_END_OF_DATA) {
+		if (status & OMAP_MMC_STAT_END_OF_DATA)
 			end_transfer = 1;
-		}
 
 		if (status & OMAP_MMC_STAT_DATA_TOUT) {
-			dev_dbg(mmc_dev(host->mmc), "data timeout\n");
+			dev_dbg(mmc_dev(host->mmc), "data timeout (CMD%d)\n",
+				cmd);
 			if (host->data) {
 				host->data->error = -ETIMEDOUT;
 				transfer_error = 1;
@@ -608,12 +616,14 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			if (host->cmd) {
 				struct mmc_omap_slot *slot =
 					host->current_slot;
-				if (!mmc_omap_cover_is_open(slot))
+				if (slot == NULL ||
+				    !mmc_omap_cover_is_open(slot))
 					dev_err(mmc_dev(host->mmc),
-						"command timeout, CMD %d\n",
-						host->cmd->opcode);
+						"command timeout (CMD%d)\n",
+						cmd);
 				host->cmd->error = -ETIMEDOUT;
 				end_command = 1;
+				cmd_error = 1;
 			}
 		}
 
@@ -621,9 +631,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			if (host->cmd) {
 				dev_err(mmc_dev(host->mmc),
 					"command CRC error (CMD%d, arg 0x%08x)\n",
-					host->cmd->opcode, host->cmd->arg);
+					cmd, host->cmd->arg);
 				host->cmd->error = -EILSEQ;
 				end_command = 1;
+				cmd_error = 1;
 			} else
 				dev_err(mmc_dev(host->mmc),
 					"command CRC error without cmd?\n");
@@ -632,13 +643,13 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 		if (status & OMAP_MMC_STAT_CARD_ERR) {
 			dev_dbg(mmc_dev(host->mmc),
 				"ignoring card status error (CMD%d)\n",
-				host->cmd->opcode);
+				cmd);
 			end_command = 1;
 		}
 
 		/*
 		 * NOTE: On 1610 the END_OF_CMD may come too early when
-		 * starting a write 
+		 * starting a write
 		 */
 		if ((status & OMAP_MMC_STAT_END_OF_CMD) &&
 		    (!(status & OMAP_MMC_STAT_A_EMPTY))) {
@@ -646,13 +657,14 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 		}
 	}
 
-	if (end_command) {
+	if (end_command)
 		mmc_omap_cmd_done(host, host->cmd);
+	if (host->data != NULL) {
+		if (transfer_error)
+			mmc_omap_xfer_done(host, host->data);
+		else if (end_transfer)
+			mmc_omap_end_of_data(host, host->data);
 	}
-	if (transfer_error)
-		mmc_omap_xfer_done(host, host->data);
-	else if (end_transfer)
-		mmc_omap_end_of_data(host, host->data);
 
 	return IRQ_HANDLED;
 }
-- 1.5.3.GIT

