Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYLELAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYLELAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLELAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:00:07 -0500
Received: from smtp.nokia.com ([192.100.122.230]:59867 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYLELAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:00:04 -0500
Message-ID: <49390BD7.3040305@nokia.com>
Date: Fri, 05 Dec 2008 13:09:11 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have errors
 are read
References: <48F74121.1020409@nokia.com>	<20081026123228.26d2a86a@mjolnir.drzeus.cx>	<4908727F.5080003@nokia.com> <20081130200558.21f2561b@mjolnir.drzeus.cx>
In-Reply-To: <20081130200558.21f2561b@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2008 10:59:29.0362 (UTC) FILETIME=[8BAD7B20:01C956C8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Wed, 29 Oct 2008 16:26:07 +0200
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> Pierre Ossman wrote:
>>> You also need to adjust the sg list when you change the block count.
>>> There was code there that did that previously, but it got removed in
>>> 2.6.27-rc1.
>> That is not necessary.  It is an optimisation.  In general, optimising an
>> error path serves no purpose.
>>
> 
> Actually, it is a requirement that some drivers rely on. There is also
> a WARN_ON(), or possibly a BUG_ON() in the request handling path. I
> think it only triggers with MMC_DEBUG though...

OK

>>> Some concerns here:
>>>
>>> 1. "brq.data.blocks > 1" doesn't need to be optimised into its own
>>> variable. It just obscures things.
>> But you have to assume that no driver changes the 'blocks' variable e.g.
>> counts it down.
> 
> That would be a no-no. I guess this is not properly documented, but it
> is strongly implied that the request structure should be read-only
> except for fields that contain result data. ;)
> 
>> It is not an optimisation, it is just to improve
>> reliability and readability.  What does it obscure?
> 
> if-clauses look like they're different, but they're not.

Well, the if clauses are different anyway, but no matter.

>>> 3. You should check all errors, not just data.error and ETIMEDOUT.
>> No.  Data timeout is a special case.  The other errors are system errors.
>> If there is a command error or stop error (which is also a command error)
>> it means either there is a bug in the kernel or the controller or card
>> has failed to follow the specification.  Under those circumstances
> 
> Controllers do not follow the specs. Welcome to reality. :)
> 
> (sad fact: I don't think there is a single controller out there that
> follows the specs to 100%).
> 
> Anyway, for this specific case, a controller might not be able to
> differentiate between command and data timeouts. Or it might report
> "data error" for anything unexpected (I seem to recall one of the
> currently supported controllers behaves like this).
> 
> Generally it's about being as flexible as we can be. This is a world of
> crappy hardware, so strict spec adherence just leads to a lot of hurt.
> And I have the scars to prove it. :)

I agree with your philosophy, although I was merely letting it go back to
the way it was - which I thought was safer then introducing new behaviour
into an undefined situation.

>>> 4. You should first report the successfully transferred blocks as ok.
>> That is another optimisation of the error path i.e. not necessary.  It
>> is simpler to just start processing the request again - which the patch
>> does.
>>
> 
> I suppose.
> 
>>> You might also want to print something so that it is
>>> visible that the driver retried the transfer.
>> There are already two error messages per sector (one from this function
>> and one from '__blk_end_request()', so another message is too much.
>>
> 
> I didn't mean an error for the bad sector, but something like
> "encountered an error during multi-block transfer. retrying...". This
> could save a lot of time and headache during debugging in the future.
> 
>> @@ -362,12 +380,19 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  #endif
>>  		}
>>  
>> -		if (brq.cmd.error || brq.data.error || brq.stop.error)
>> +		if (brq.cmd.error || brq.stop.error)
>> +			goto cmd_err;
>> +
>> +		if (brq.data.error == -ETIMEDOUT && rq_data_dir(req) == READ) {
>> +			spin_lock_irq(&md->lock);
>> +			ret = __blk_end_request(req, -EIO, brq.data.blksz);
>> +			spin_unlock_irq(&md->lock);
>> +			continue;
>> +		}
>> +
> 
> This could use a comment explaining that if we've reached this point,
> we know that it was a single sector that failed.
> 
>> +		if (brq.cmd.error)
>>  			goto cmd_err;
>>  
>> -		/*
>> -		 * A block was successfully transferred.
>> -		 */
>>  		spin_lock_irq(&md->lock);
>>  		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
>>  		spin_unlock_irq(&md->lock);
> 
> Shouldn't this comment stay now? :)

OK


>From ceb711896b3c0cbc1c01b8f0c3733cedf3d88843 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Thu, 16 Oct 2008 13:13:08 +0300
Subject: [PATCH] mmc_block: ensure all sectors that do not have errors are read

If a card encounters an ECC error while reading a sector it will
timeout.  Instead of reporting the entire I/O request as having
an error, redo the I/O one sector at a time so that all readable
sectors are provided to the upper layers.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   68 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 5b46ec9..040b57e 100644
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
@@ -281,6 +289,16 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		brq.data.sg = mq->sg;
 		brq.data.sg_len = mmc_queue_map_sg(mq);
 
+		/*
+		 * Some drivers expect the sg list to be the same size as the
+		 * request, which it won't be if we have fallen back to do
+		 * one sector at a time.
+		 */
+		if (disable_multi) {
+			brq.data.sg->length = 512;
+			brq.data.sg_len = 1;
+		}
+
 		mmc_queue_bounce_pre(mq);
 
 		mmc_wait_for_req(card->host, &brq.mrq);
@@ -292,8 +310,17 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		 * until later as we need to wait for the card to leave
 		 * programming mode even when things go wrong.
 		 */
-		if (brq.cmd.error || brq.data.error || brq.stop.error)
+		if (brq.cmd.error || brq.data.error || brq.stop.error) {
+			if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
+				/* Redo read one sector at a time */
+				printk(KERN_WARNING "%s: error, retrying using "
+				       "single block read\n",
+				       req->rq_disk->disk_name);
+				disable_multi = 1;
+				continue;
+			}
 			status = get_card_status(card, req);
+		}
 
 		if (brq.cmd.error) {
 			printk(KERN_ERR "%s: error %d sending read/write "
@@ -350,8 +377,20 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
@@ -373,25 +412,20 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
