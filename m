Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYLVLTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYLVLTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYLVLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:19:24 -0500
Received: from smtp.nokia.com ([192.100.122.230]:60916 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYLVLTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:19:23 -0500
Message-ID: <494F7A02.2030302@nokia.com>
Date: Mon, 22 Dec 2008 13:29:06 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have errors
 are read
References: <48F74121.1020409@nokia.com>	<20081026123228.26d2a86a@mjolnir.drzeus.cx>	<4908727F.5080003@nokia.com>	<20081130200558.21f2561b@mjolnir.drzeus.cx>	<49390BD7.3040305@nokia.com> <20081221152915.352d5c05@mjolnir.drzeus.cx>
In-Reply-To: <20081221152915.352d5c05@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2008 11:18:19.0816 (UTC) FILETIME=[FE80D280:01C96426]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Fri, 05 Dec 2008 13:09:11 +0200
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> @@ -281,6 +289,16 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  		brq.data.sg = mq->sg;
>>  		brq.data.sg_len = mmc_queue_map_sg(mq);
>>  
>> +		/*
>> +		 * Some drivers expect the sg list to be the same size as the
>> +		 * request, which it won't be if we have fallen back to do
>> +		 * one sector at a time.
>> +		 */
>> +		if (disable_multi) {
>> +			brq.data.sg->length = 512;
>> +			brq.data.sg_len = 1;
>> +		}
>> +
>>  		mmc_queue_bounce_pre(mq);
>>  
>>  		mmc_wait_for_req(card->host, &brq.mrq);
> 
> Unfortunately, there is no guarantee that the sg list will be sector
> aligned.

OK.  I am curious though - do you know anywhere in the kernel that actually
does submit I/O in buffers that are not aligned to 512?

>          Look at the code removed in f3eb0aaa02 for how to handle this
> properly.
> 
> Other than that, the patch looks ready to go.
> 
> Rgds

From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] mmc_block: ensure all sectors that do not have errors are read

If a card encounters an ECC error while reading a sector it will
timeout.  Instead of reporting the entire I/O request as having
an error, redo the I/O one sector at a time so that all readable
sectors are provided to the upper layers.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   76 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 2998112..679b489 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -231,7 +231,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
-	int ret = 1;
+	int ret = 1, disable_multi = 0;
 
 	mmc_claim_host(card->host);
 
@@ -253,6 +253,14 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
 		brq.data.blocks = req->nr_sectors;
 
+		/*
+		 * After a read error, we redo the request one sector at a time
+		 * in order to accurately determine which sectors can be read
+		 * successfully.
+		 */
+		if (disable_multi && brq.data.blocks > 1)
+			brq.data.blocks = 1;
+
 		if (brq.data.blocks > 1) {
 			/* SPI multiblock writes terminate using a special
 			 * token, not a STOP_TRANSMISSION request.
@@ -281,6 +289,25 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		brq.data.sg = mq->sg;
 		brq.data.sg_len = mmc_queue_map_sg(mq);
 
+		/*
+		 * Adjust the sg list so it is the same size as the
+		 * request.
+		 */
+		if (brq.data.blocks != req->nr_sectors) {
+			int i, data_size = brq.data.blocks << 9;
+			struct scatterlist *sg;
+
+			for_each_sg(brq.data.sg, sg, brq.data.sg_len, i) {
+				data_size -= sg->length;
+				if (data_size <= 0) {
+					sg->length += data_size;
+					i++;
+					break;
+				}
+			}
+			brq.data.sg_len = i;
+		}
+
 		mmc_queue_bounce_pre(mq);
 
 		mmc_wait_for_req(card->host, &brq.mrq);
@@ -292,8 +319,16 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		 * until later as we need to wait for the card to leave
 		 * programming mode even when things go wrong.
 		 */
-		if (brq.cmd.error || brq.data.error || brq.stop.error)
+		if (brq.cmd.error || brq.data.error || brq.stop.error) {
+			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
+				/* Redo read one sector at a time */
+				printk(KERN_WARNING "%s: retrying using single "
+				       "block read\n", req->rq_disk->disk_name);
+				disable_multi = 1;
+				continue;
+			}
 			status = get_card_status(card, req);
+		}
 
 		if (brq.cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write "
@@ -350,8 +385,20 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 #endif
 		}
 
-		if (brq.cmd.error || brq.data.error || brq.stop.error)
+		if (brq.cmd.error || brq.stop.error || brq.data.error) {
+			if (rq_data_dir(req) == READ) {
+				/*
+				 * After an error, we redo I/O one sector at a
+				 * time, so we only reach here after trying to
+				 * read a single sector.
+				 */
+				spin_lock_irq(&md->lock);
+				ret = __blk_end_request(req, -EIO, brq.data.blksz);
+				spin_unlock_irq(&md->lock);
+				continue;
+			}
 			goto cmd_err;
+		}
 
 		/*
 		 * A block was successfully transferred.
@@ -373,25 +420,20 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	 * If the card is not SD, we can still ok written sectors
 	 * as reported by the controller (which might be less than
 	 * the real number of written sectors, but never more).
-	 *
-	 * For reads we just fail the entire chunk as that should
-	 * be safe in all cases.
 	 */
-	if (rq_data_dir(req) != READ) {
-		if (mmc_card_sd(card)) {
-			u32 blocks;
+	if (mmc_card_sd(card)) {
+		u32 blocks;
 
-			blocks = mmc_sd_num_wr_blocks(card);
-			if (blocks != (u32)-1) {
-				spin_lock_irq(&md->lock);
-				ret = __blk_end_request(req, 0, blocks << 9);
-				spin_unlock_irq(&md->lock);
-			}
-		} else {
+		blocks = mmc_sd_num_wr_blocks(card);
+		if (blocks != (u32)-1) {
 			spin_lock_irq(&md->lock);
-			ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+			ret = __blk_end_request(req, 0, blocks << 9);
 			spin_unlock_irq(&md->lock);
 		}
+	} else {
+		spin_lock_irq(&md->lock);
+		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+		spin_unlock_irq(&md->lock);
 	}
 
 	mmc_release_host(card->host);
-- 
1.5.4.3
