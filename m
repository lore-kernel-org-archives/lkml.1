Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYJPNVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYJPNVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYJPNVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:21:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64495 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYJPNVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:21:06 -0400
Message-ID: <48F74121.1020409@nokia.com>
Date: Thu, 16 Oct 2008 16:26:57 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Pierre Ossman" <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mmc_block: ensure all sectors that do not have errors
 are read
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 13:20:31.0303 (UTC) FILETIME=[F6BBB570:01C92F91]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a card encounters an ECC error while reading a sector it will
timeout.  Instead of reporting the entire I/O request as having
an error, redo the I/O one sector at a time so that all readable
sectors are provided to the upper layers.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index d121462..0566aae 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -256,13 +256,14 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
-	int ret = 1;
+	int ret = 1, disable_multi = 0;
 
 	mmc_claim_host(card->host);
 
 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd;
+		int multi, err;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -278,6 +279,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
 		brq.data.blocks = req->nr_sectors;
 
+		if (disable_multi && brq.data.blocks > 1)
+			brq.data.blocks = 1;
+
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
@@ -287,10 +291,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 				brq.mrq.stop = &brq.stop;
 			readcmd = MMC_READ_MULTIPLE_BLOCK;
 			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
+			multi = 1;
 		} else {
 			brq.mrq.stop = NULL;
 			readcmd = MMC_READ_SINGLE_BLOCK;
 			writecmd = MMC_WRITE_BLOCK;
+			multi = 0;
 		}
 
 		if (rq_data_dir(req) == READ) {
@@ -312,6 +318,13 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 		mmc_queue_bounce_post(mq);
 
+		if (multi && rq_data_dir(req) == READ &&
+		    brq.data.error == -ETIMEDOUT) {
+			/* Redo read one sector at a time */
+			disable_multi = 1;
+			continue;
+		}
+
 		/*
 		 * Check for errors here, but don't jump to cmd_err
 		 * until later as we need to wait for the card to leave
@@ -360,14 +373,21 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 #endif
 		}
 
-		if (brq.cmd.error || brq.data.error || brq.stop.error)
+		if (brq.cmd.error || brq.stop.error)
 			goto cmd_err;
 
-		/*
-		 * A block was successfully transferred.
-		 */
+		if (brq.data.error) {
+			if (brq.data.error == -ETIMEDOUT &&
+			    rq_data_dir(req) == READ) {
+				err = -EIO;
+				brq.data.bytes_xfered = brq.data.blksz;
+			} else
+				goto cmd_err;
+		} else
+			err = 0;
+
 		spin_lock_irq(&md->lock);
-		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, err, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
-- 
1.5.4.3
