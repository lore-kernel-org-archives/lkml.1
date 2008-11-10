Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYKJINl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYKJINl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYKJINb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:13:31 -0500
Received: from smtp.nokia.com ([192.100.122.230]:53601 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYKJINa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:13:30 -0500
Message-ID: <4917EF03.8060308@nokia.com>
Date: Mon, 10 Nov 2008 10:21:23 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have errors
 are read
References: <48F74121.1020409@nokia.com> <20081026123228.26d2a86a@mjolnir.drzeus.cx> <4908727F.5080003@nokia.com>
In-Reply-To: <4908727F.5080003@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2008 08:13:20.0329 (UTC) FILETIME=[31580390:01C9430C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Hunter wrote:
> Pierre Ossman wrote:
>> On Thu, 16 Oct 2008 16:26:57 +0300
>> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
>>
>>> If a card encounters an ECC error while reading a sector it will
>>> timeout.  Instead of reporting the entire I/O request as having
>>> an error, redo the I/O one sector at a time so that all readable
>>> sectors are provided to the upper layers.
>>>
>>> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
>>> ---
>>
>> We actually had something like this on the table some time ago. It got
>> scrapped because of data integrity problems. This is just for reads
>> though, so I guess it should be safe.
>>
>>> @@ -278,6 +279,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, 
>>> struct request *req)
>>>          brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
>>>          brq.data.blocks = req->nr_sectors;
>>>  
>>> +        if (disable_multi && brq.data.blocks > 1)
>>> +            brq.data.blocks = 1;
>>> +
>>
>> A comment here would be nice.
> 
> Ok
> 
>> You also need to adjust the sg list when you change the block count.
>> There was code there that did that previously, but it got removed in
>> 2.6.27-rc1.
> 
> That is not necessary.  It is an optimisation.  In general, optimising an
> error path serves no purpose.
> 
>>> @@ -312,6 +318,13 @@ static int mmc_blk_issue_rq(struct mmc_queue 
>>> *mq, struct request *req)
>>>  
>>>          mmc_queue_bounce_post(mq);
>>>  
>>> +        if (multi && rq_data_dir(req) == READ &&
>>> +            brq.data.error == -ETIMEDOUT) {
>>> +            /* Redo read one sector at a time */
>>> +            disable_multi = 1;
>>> +            continue;
>>> +        }
>>> +
>>
>> Some concerns here:
>>
>> 1. "brq.data.blocks > 1" doesn't need to be optimised into its own
>> variable. It just obscures things.
> 
> But you have to assume that no driver changes the 'blocks' variable e.g.
> counts it down.  It is not an optimisation, it is just to improve
> reliability and readability.  What does it obscure?
> 
>> 2. A comment here as well. Explain what this does and why it is safe
>> (so people don't try to extend it to writes)
> 
> ok
> 
>> 3. You should check all errors, not just data.error and ETIMEDOUT.
> 
> No.  Data timeout is a special case.  The other errors are system errors.
> If there is a command error or stop error (which is also a command error)
> it means either there is a bug in the kernel or the controller or card
> has failed to follow the specification.  Under those circumstances
> 
> Data timeout on the other hand just means the data could not be retrieved
> - in the case we have seen because of ECC error.
> 
>> 4. You should first report the successfully transferred blocks as ok.
> 
> That is another optimisation of the error path i.e. not necessary.  It
> is simpler to just start processing the request again - which the patch
> does.
> 
>>> @@ -360,14 +373,21 @@ static int mmc_blk_issue_rq(struct mmc_queue 
>>> *mq, struct request *req)
>>>  #endif
>>>          }
>>>  
>>> -        if (brq.cmd.error || brq.data.error || brq.stop.error)
>>> +        if (brq.cmd.error || brq.stop.error)
>>>              goto cmd_err;
>>
>> Move your code to inside this if clause and you'll solve 3. and 4. in a
>> neat manner.
> 
> Well, I do not agree with 3 and 4.
> 
>> You might also want to print something so that it is
>> visible that the driver retried the transfer.
> 
> There are already two error messages per sector (one from this function
> and one from '__blk_end_request()', so another message is too much.
> 
>>>  
>>> -        /*
>>> -         * A block was successfully transferred.
>>> -         */
>>> +        if (brq.data.error) {
>>> +            if (brq.data.error == -ETIMEDOUT &&
>>> +                rq_data_dir(req) == READ) {
>>> +                err = -EIO;
>>> +                brq.data.bytes_xfered = brq.data.blksz;
>>> +            } else
>>> +                goto cmd_err;
>>> +        } else
>>> +            err = 0;
>>> +
>>>          spin_lock_irq(&md->lock);
>>> -        ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
>>> +        ret = __blk_end_request(req, err, brq.data.bytes_xfered);
>>>          spin_unlock_irq(&md->lock);
>>>      } while (ret);
>>>  
>>
>> Instead of this big song and dance routine, just have a dedicated piece
>> of code for calling __blk_end_request() for the single sector failure.
> 
> Ok
> 
> Amended patch follows:

What is the status of this patch?

