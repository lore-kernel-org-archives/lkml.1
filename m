Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYJ0P1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYJ0P1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYJ0P1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:27:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30666 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYJ0P1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:27:24 -0400
Message-ID: <4905DF57.6040902@nokia.com>
Date: Mon, 27 Oct 2008 17:33:43 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
References: <48F7411F.3020109@nokia.com> <20081026121155.69692474@mjolnir.drzeus.cx>
In-Reply-To: <20081026121155.69692474@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2008 15:26:33.0170 (UTC) FILETIME=[64804B20:01C93848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Thu, 16 Oct 2008 16:26:55 +0300
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> In particular, if the card gets an ECC error it will
>> timeout, in which case it is much more helpful to see
>> an ECC error rather than a timeout error.
>>
>> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
>> ---

Thank you for looking at the patch.

> Woo. I think you're the first I've seen that has been able to trigger
> an actual card error. :)

Well, my impression is that they are quite easy to break

> As for the patch, I like the idea but I'm not entirely satisfied with
> the implementation.
> 
>> +static void print_data_error(struct mmc_blk_request *brq, struct mmc_card *card,
>> +			     struct request *req)
>> +{
>> +	struct mmc_command cmd;
>> +	char *emsg;
>> +	u32 status;
>> +	int status_err = 0;
>> +
>> +	if (brq->data.error != -ETIMEDOUT || mmc_host_is_spi(card->host))
>> +		goto out_print;
>> +
> 
> The error codes are more of a hint than anything else, so you should
> check the status for all non-zero codes. You should also not just check
> data.error, but all of them.

OK but the error bits are cleared as soon as the status has been reported,
which is in the command response or, in the case of timeout, the response
to the next command.  Reading the status after that shows nothing.  The
status would have to be fished out of brq->mrq.cmd->resp[0].

ETIMEDOUT is a special case because it is not a hint for the error, it is
rather the normal response to an error - so it seemed very misleading to me.

> And why exclude spi?

I don't have SPI, so I can't test it.  AFAICT timeouts are not meant to happen
with SPI so it is a genuine error.

The SPI error reporting is a little different.  The non-SPI code that I wrote
certainly won't work for SPI.  I may look at doing something for SPI.

>> +	if (brq->mrq.stop)
>> +		/* 'Stop' response contains card status */
>> +		status = brq->mrq.stop->resp[0];
>> +	else {
>> +		cmd.opcode = MMC_SEND_STATUS;
>> +		cmd.arg = card->rca << 16;
>> +		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
>> +		status_err = mmc_wait_for_cmd(card->host, &cmd, 0);
>> +		if (status_err)
>> +			goto out_print;
>> +		status = cmd.resp[0];
>> +	}
> 
> Errors can occur on writes as well, so I suggest accumulating the
> status bits instead of trying to get the entire set in one go. I.e.:
> 
> status = 0;
> if (mrq.stop)
> 	status |= mrq.stop.resp[0];
> while (card not ready)
> 	status |= send_status();
> 
> IOW, you should do this in the main handler (that already has the
> status loop for writes).
> 

The nesting may get too deep and the control paths too complicated
if it is done in the main handler, but I will see what I can do.
Ideally the loop needs some limit to prevent a misbehaving card
locking up the driver.

>> +
>> +	emsg = (status & R1_CARD_ECC_FAILED) ? "ECC" : "I/O";
>> +
> 
> There are also some other error codes that can be of interest.
> "Internal controller error" for example.

Do you mean CC_ERROR?  I picked out ECC errors because NAND will get
ECC errors if the NAND page was not written cleanly (e.g. if the power
went off during the write)  I guess a good card should recover the
old data and never report ECC errors, but that is a separate issue.

> (it's probably also better to state "Unknown" error and not "I/O" for
> the fallback)

"Unknown" is for unknown error codes, so I don't think it is appropriate.
In this case we are simply not bothering to break down all the errors bits.

>> @@ -281,10 +322,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>  			       req->rq_disk->disk_name, brq.cmd.error);
>>  		}
>>  
>> -		if (brq.data.error) {
>> -			printk(KERN_ERR "%s: error %d transferring data\n",
>> -			       req->rq_disk->disk_name, brq.data.error);
>> -		}
>> +		if (brq.data.error)
>> +			print_data_error(&brq, card, req);
>>  
> 
> Please keep the old message and add this as a new extra piece of
> information. It is helpful for debugging to see both what the driver
> and the card reported.

It already does that.

