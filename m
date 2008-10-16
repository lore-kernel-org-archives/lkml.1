Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYJPNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYJPNVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYJPNVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:21:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64492 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYJPNVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:21:06 -0400
Message-ID: <48F7411F.3020109@nokia.com>
Date: Thu, 16 Oct 2008 16:26:55 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Pierre Ossman" <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mmc_block: print better data error message after timeout
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 13:20:29.0319 (UTC) FILETIME=[F58CF970:01C92F91]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In particular, if the card gets an ECC error it will
timeout, in which case it is much more helpful to see
an ECC error rather than a timeout error.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   47 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 24c97d3..d121462 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -210,6 +210,47 @@ static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 	return blocks;
 }
 
+static void print_data_error(struct mmc_blk_request *brq, struct mmc_card *card,
+			     struct request *req)
+{
+	struct mmc_command cmd;
+	char *emsg;
+	u32 status;
+	int status_err = 0;
+
+	if (brq->data.error != -ETIMEDOUT || mmc_host_is_spi(card->host))
+		goto out_print;
+
+	if (brq->mrq.stop)
+		/* 'Stop' response contains card status */
+		status = brq->mrq.stop->resp[0];
+	else {
+		cmd.opcode = MMC_SEND_STATUS;
+		cmd.arg = card->rca << 16;
+		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+		status_err = mmc_wait_for_cmd(card->host, &cmd, 0);
+		if (status_err)
+			goto out_print;
+		status = cmd.resp[0];
+	}
+
+	emsg = (status & R1_CARD_ECC_FAILED) ? "ECC" : "I/O";
+
+	printk(KERN_ERR "%s: %s error transferring data, sector %u, "
+	       "card status %#x\n", req->rq_disk->disk_name, emsg,
+	       (unsigned)req->sector, status);
+
+	return;
+
+out_print:
+	printk(KERN_ERR "%s: error %d transferring data, sector %u, nr %u\n",
+	       req->rq_disk->disk_name, brq->data.error, (unsigned)req->sector,
+	       (unsigned)req->nr_sectors);
+	if (status_err)
+		printk(KERN_ERR "%s: error %d requesting card status\n",
+		       req->rq_disk->disk_name, status_err);
+}
+
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_blk_data *md = mq->data;
@@ -281,10 +322,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 			       req->rq_disk->disk_name, brq.cmd.error);
 		}
 
-		if (brq.data.error) {
-			printk(KERN_ERR "%s: error %d transferring data\n",
-			       req->rq_disk->disk_name, brq.data.error);
-		}
+		if (brq.data.error)
+			print_data_error(&brq, card, req);
 
 		if (brq.stop.error) {
 			printk(KERN_ERR "%s: error %d sending stop command\n",
-- 
1.5.4.3
