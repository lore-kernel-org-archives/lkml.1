Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYJ2KWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYJ2KWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYJ2KWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:22:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:45594 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYJ2KWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:22:45 -0400
Message-ID: <49083B1C.6060803@nokia.com>
Date: Wed, 29 Oct 2008 12:29:48 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
References: <48F7411F.3020109@nokia.com> <20081026121155.69692474@mjolnir.drzeus.cx>
In-Reply-To: <20081026121155.69692474@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2008 10:22:32.0043 (UTC) FILETIME=[40C4B3B0:01C939B0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add command response and card status to error
messages.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   56 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 7 deletions(-)


Pierre

This patch amends error messages for all error codes and is independent of SPI.
Status values are not OR'd together from different commands as that would
muddy the waters for anyone trying to understand the nature of the error.
Waiting for the card to become ready after an error is also not included,
as it is not in the standards and is a separate issue anyway.

Regards
Adrian


diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3d067c3..9998718 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -209,6 +209,27 @@ static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 	return blocks;
 }
 
+static u32 get_card_status(struct mmc_card *card, struct request *req)
+{
+	struct mmc_command cmd;
+	int err;
+
+	/* SEND STATUS command is not supported by SDIO */
+	if (mmc_card_sdio(card))
+		return 0;
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+	cmd.opcode = MMC_SEND_STATUS;
+	if (!mmc_host_is_spi(card->host))
+		cmd.arg = card->rca << 16;
+	cmd.flags = MMC_RSP_SPI_R2 | MMC_RSP_R1 | MMC_CMD_AC;
+	err = mmc_wait_for_cmd(card->host, &cmd, 0);
+	if (err)
+		printk(KERN_ERR "%s: error %d sending status comand",
+			       req->rq_disk->disk_name, err);
+	return cmd.resp[0];
+}
+
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -220,7 +241,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 	do {
 		struct mmc_command cmd;
-		u32 readcmd, writecmd;
+		u32 readcmd, writecmd, status = 0;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -275,19 +296,40 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		 * until later as we need to wait for the card to leave
 		 * programming mode even when things go wrong.
 		 */
+		if (brq.cmd.error || brq.data.error || brq.stop.error)
+			status = get_card_status(card, req);
+
 		if (brq.cmd.error) {
-			printk(KERN_ERR "%s: error %d sending read/write command\n",
-			       req->rq_disk->disk_name, brq.cmd.error);
+			printk(KERN_ERR "%s: error %d sending read/write "
+			       "command, response %#x, card status %#x\n",
+			       req->rq_disk->disk_name, brq.cmd.error,
+			       brq.cmd.resp[0], status);
 		}
 
 		if (brq.data.error) {
-			printk(KERN_ERR "%s: error %d transferring data\n",
-			       req->rq_disk->disk_name, brq.data.error);
+			if (brq.data.error == -ETIMEDOUT) {
+				/* 'Stop' response contains card status */
+				if (brq.mrq.stop)
+					status = brq.mrq.stop->resp[0];
+				printk(KERN_ERR "%s: error transferring data,"
+				       " sector %u, nr %u, card status %#x\n",
+				       req->rq_disk->disk_name,
+				       (unsigned)req->sector,
+				       (unsigned)req->nr_sectors, status);
+			} else {
+				printk(KERN_ERR "%s: error %d transferring data,"
+				       " sector %u, nr %u, card status %#x\n",
+				       req->rq_disk->disk_name, brq.data.error,
+				       (unsigned)req->sector,
+				       (unsigned)req->nr_sectors, status);
+			}
 		}
 
 		if (brq.stop.error) {
-			printk(KERN_ERR "%s: error %d sending stop command\n",
-			       req->rq_disk->disk_name, brq.stop.error);
+			printk(KERN_ERR "%s: error %d sending stop command, "
+			       "response %#x, card status %#x\n",
+			       req->rq_disk->disk_name, brq.stop.error,
+			       brq.stop.resp[0], status);
 		}
 
 		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
-- 
1.5.4.3

