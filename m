Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYLDN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYLDN0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYLDN01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:26:27 -0500
Received: from smtp.nokia.com ([192.100.105.134]:35646 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYLDN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:26:26 -0500
Message-ID: <4937DCAF.3010806@nokia.com>
Date: Thu, 04 Dec 2008 15:35:43 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
References: <48F7411F.3020109@nokia.com>	<20081026121155.69692474@mjolnir.drzeus.cx>	<49083B1C.6060803@nokia.com> <20081130194845.4abd0cb8@mjolnir.drzeus.cx>
In-Reply-To: <20081130194845.4abd0cb8@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2008 13:26:04.0989 (UTC) FILETIME=[DBDDE6D0:01C95613]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Wed, 29 Oct 2008 12:29:48 +0200
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> Add command response and card status to error
>> messages.
>>
>> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
>> ---
>>  drivers/mmc/card/block.c |   56 ++++++++++++++++++++++++++++++++++++++++-----
>>  1 files changed, 49 insertions(+), 7 deletions(-)
>>
>>
>> Pierre
>>
>> This patch amends error messages for all error codes and is independent of SPI.
> 
> Looks good. It's ready to queue up except for two very small details
> (see below).

Sorry for not responding sooner.  The mail got lost and I only just noticed it.

>> Status values are not OR'd together from different commands as that would
>> muddy the waters for anyone trying to understand the nature of the error.
> 
> I suppose. I'm just generally uneasy about error handling in SD/MMC as
> the specs aren't that clear. :)
> 
>> Waiting for the card to become ready after an error is also not included,
>> as it is not in the standards and is a separate issue anyway.
> 
> What do you mean?

You had suggested

	while (card not ready)
		status |= send_status();

and I didn't do it, because of the reasons given above.

> This will handle your case of seeing read errors, but for write errors
> we probably need to wait for the write to complete fully. But that's
> something that can be added later...

Multiblock writes are terminated with a stop command when an error occurs,
and there is a loop waiting on the status whether an error occurs or not.

>>  
>> +static u32 get_card_status(struct mmc_card *card, struct request *req)
>> +{
>> +	struct mmc_command cmd;
>> +	int err;
>> +
>> +	/* SEND STATUS command is not supported by SDIO */
>> +	if (mmc_card_sdio(card))
>> +		return 0;
>> +
> 
> This is redundant. We never bind to a SDIO card.

OK

>>  		if (brq.data.error) {
>> -			printk(KERN_ERR "%s: error %d transferring data\n",
>> -			       req->rq_disk->disk_name, brq.data.error);
>> +			if (brq.data.error == -ETIMEDOUT) {
>> +				/* 'Stop' response contains card status */
>> +				if (brq.mrq.stop)
>> +					status = brq.mrq.stop->resp[0];
>> +				printk(KERN_ERR "%s: error transferring data,"
>> +				       " sector %u, nr %u, card status %#x\n",
>> +				       req->rq_disk->disk_name,
>> +				       (unsigned)req->sector,
>> +				       (unsigned)req->nr_sectors, status);
>> +			} else {
>> +				printk(KERN_ERR "%s: error %d transferring data,"
>> +				       " sector %u, nr %u, card status %#x\n",
>> +				       req->rq_disk->disk_name, brq.data.error,
>> +				       (unsigned)req->sector,
>> +				       (unsigned)req->nr_sectors, status);
>> +			}
>>  		}
> 
> Do we need the two different printk:s? It would reduce the code a bit
> if you just let the if clause modify the status value.

OK


From: Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Thu, 16 Oct 2008 12:55:25 +0300
Subject: [PATCH] mmc_block: print better error messages

Add command response and card status to error
messages.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 3d067c3..2998112 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -209,6 +209,23 @@ static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 	return blocks;
 }
 
+static u32 get_card_status(struct mmc_card *card, struct request *req)
+{
+	struct mmc_command cmd;
+	int err;
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
@@ -220,7 +237,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 	do {
 		struct mmc_command cmd;
-		u32 readcmd, writecmd;
+		u32 readcmd, writecmd, status = 0;
 
 		memset(&brq, 0, sizeof(struct mmc_blk_request));
 		brq.mrq.cmd = &brq.cmd;
@@ -275,19 +292,32 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
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
+			if (brq.data.error == -ETIMEDOUT && brq.mrq.stop)
+				/* 'Stop' response contains card status */
+				status = brq.mrq.stop->resp[0];
+			printk(KERN_ERR "%s: error %d transferring data,"
+			       " sector %u, nr %u, card status %#x\n",
+			       req->rq_disk->disk_name, brq.data.error,
+			       (unsigned)req->sector,
+			       (unsigned)req->nr_sectors, status);
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

