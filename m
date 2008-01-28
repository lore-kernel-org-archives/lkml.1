Return-Path: <linux-kernel-owner+w=401wt.eu-S1763756AbYA1TQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763756AbYA1TQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761804AbYA1TLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:11:36 -0500
Received: from smtp.nokia.com ([192.100.122.233]:23728 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762618AbYA1TLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:11:35 -0500
Message-ID: <479E2800.903@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:44 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] MMC: OMAP: General cleanup for MMC multislot support
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:29.0914 (UTC) FILETIME=[4EE3B1A0:01C861E1]
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
 drivers/mmc/host/omap.c |   52 ++++++++++++++++++++++++++++-------------------
 1 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index ea3b79e..169f721 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -562,11 +562,12 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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
@@ -577,12 +578,19 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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
@@ -594,12 +602,12 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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
@@ -624,16 +632,16 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				struct mmc_omap_slot *slot =
 					host->current_slot;
 				if (host->cmd->opcode != MMC_ALL_SEND_CID &&
-						host->cmd->opcode !=
-						MMC_SEND_OP_COND &&
-						host->cmd->opcode !=
-						MMC_APP_CMD &&
-						!mmc_omap_cover_is_open(slot))
+				    host->cmd->opcode != MMC_SEND_OP_COND &&
+				    host->cmd->opcode != MMC_APP_CMD &&
+				    (slot == NULL ||
+				     !mmc_omap_cover_is_open(slot)))
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
 
@@ -641,9 +649,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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
@@ -652,13 +661,13 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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
@@ -666,13 +675,14 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
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

