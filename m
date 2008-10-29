Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYJ2OTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYJ2OTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYJ2OTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:19:23 -0400
Received: from smtp.nokia.com ([192.100.122.230]:60652 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYJ2OTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:19:22 -0400
Message-ID: <4908727F.5080003@nokia.com>
Date: Wed, 29 Oct 2008 16:26:07 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have errors
 are read
References: <48F74121.1020409@nokia.com> <20081026123228.26d2a86a@mjolnir.drzeus.cx>
In-Reply-To: <20081026123228.26d2a86a@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2008 14:18:50.0593 (UTC) FILETIME=[43D7BD10:01C939D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Thu, 16 Oct 2008 16:26:57 +0300
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> If a card encounters an ECC error while reading a sector it will
>> timeout.  Instead of reporting the entire I/O request as having
>> an error, redo the I/O one sector at a time so that all readable
>> sectors are provided to the upper layers.
>>
>> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
>> ---
> 
> We actually had something like this on the table some time ago. It got
> scrapped because of data integrity problems. This is just for reads
> though, so I guess it should be safe.
> 
>> @@ -278,6 +279,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
>>  		brq.data.blocks = req->nr_sectors;
>>  
>> +		if (disable_multi && brq.data.blocks > 1)
>> +			brq.data.blocks = 1;
>> +
> 
> A comment here would be nice.

Ok

> You also need to adjust the sg list when you change the block count.
> There was code there that did that previously, but it got removed in
> 2.6.27-rc1.

That is not necessary.  It is an optimisation.  In general, optimising an
error path serves no purpose.

>> @@ -312,6 +318,13 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  
>>  		mmc_queue_bounce_post(mq);
>>  
>> +		if (multi && rq_data_dir(req) == READ &&
>> +		    brq.data.error == -ETIMEDOUT) {
>> +			/* Redo read one sector at a time */
>> +			disable_multi = 1;
>> +			continue;
>> +		}
>> +
> 
> Some concerns here:
> 
> 1. "brq.data.blocks > 1" doesn't need to be optimised into its own
> variable. It just obscures things.

But you have to assume that no driver changes the 'blocks' variable e.g.
counts it down.  It is not an optimisation, it is just to improve
reliability and readability.  What does it obscure?

> 2. A comment here as well. Explain what this does and why it is safe
> (so people don't try to extend it to writes)

ok

> 3. You should check all errors, not just data.error and ETIMEDOUT.

No.  Data timeout is a special case.  The other errors are system errors.
If there is a command error or stop error (which is also a command error)
it means either there is a bug in the kernel or the controller or card
has failed to follow the specification.  Under those circumstances

Data timeout on the other hand just means the data could not be retrieved
- in the case we have seen because of ECC error.

> 4. You should first report the successfully transferred blocks as ok.

That is another optimisation of the error path i.e. not necessary.  It
is simpler to just start processing the request again - which the patch
does.

>> @@ -360,14 +373,21 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  #endif
>>  		}
>>  
>> -		if (brq.cmd.error || brq.data.error || brq.stop.error)
>> +		if (brq.cmd.error || brq.stop.error)
>>  			goto cmd_err;
> 
> Move your code to inside this if clause and you'll solve 3. and 4. in a
> neat manner.

Well, I do not agree with 3 and 4.

> You might also want to print something so that it is
> visible that the driver retried the transfer.

There are already two error messages per sector (one from this function
and one from '__blk_end_request()', so another message is too much.

>>  
>> -		/*
>> -		 * A block was successfully transferred.
>> -		 */
>> +		if (brq.data.error) {
>> +			if (brq.data.error == -ETIMEDOUT &&
>> +			    rq_data_dir(req) == READ) {
>> +				err = -EIO;
>> +				brq.data.bytes_xfered = brq.data.blksz;
>> +			} else
>> +				goto cmd_err;
>> +		} else
>> +			err = 0;
>> +
>>  		spin_lock_irq(&md->lock);
>> -		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
>> +		ret = __blk_end_request(req, err, brq.data.bytes_xfered);
>>  		spin_unlock_irq(&md->lock);
>>  	} while (ret);
>>  
> 
> Instead of this big song and dance routine, just have a dedicated piece
> of code for calling __blk_end_request() for the single sector failure.

Ok

Amended patch follows:


>From 318326b563f7c792fac92e7c93b0e02b353d0a0d Mon Sep 17 00:00:00 2001
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Thu, 16 Oct 2008 13:13:08 +0300
Subject: [PATCH] mmc_block: ensure all sectors that do not have errors are read

If a card encounters an ECC error while reading a sector it will
timeout.  Instead of reporting the entire I/O request as having
an error, redo the I/O one sector at a time so that all readable
sectors are provided to the upper layers.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   35 ++++++++++++++++++++++++++++++-----
 1 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 9998718..d3777cc 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -235,13 +235,14 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
 	struct mmc_blk_request brq;
-	int ret = 1;
+	int ret = 1, disable_multi = 0;
 
 	mmc_claim_host(card->host);
 
 	do {
 		struct mmc_command cmd;
 		u32 readcmd, writecmd, status = 0;
+		int multi;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -257,6 +258,14 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
@@ -266,10 +275,12 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
@@ -291,6 +302,13 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
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
@@ -362,12 +380,19 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 #endif
 		}
 
-		if (brq.cmd.error || brq.data.error || brq.stop.error)
+		if (brq.cmd.error || brq.stop.error)
+			goto cmd_err;
+
+		if (brq.data.error == -ETIMEDOUT && rq_data_dir(req) == READ) {
+			spin_lock_irq(&md->lock);
+			ret = __blk_end_request(req, -EIO, brq.data.blksz);
+			spin_unlock_irq(&md->lock);
+			continue;
+		}
+
+		if (brq.cmd.error)
 			goto cmd_err;
 
-		/*
-		 * A block was successfully transferred.
-		 */
 		spin_lock_irq(&md->lock);
 		ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
-- 
1.5.4.3
