Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYJKRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYJKRhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761485AbYJKRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:37:32 -0400
Received: from nebensachen.de ([195.34.83.29]:53678 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761483AbYJKRhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:37:31 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Block: Fix handling of stopped queues and a plugging issue
Date: Sat, 11 Oct 2008 19:36:15 +0200
Message-ID: <87tzbjhw4w.fsf@denkblock.local>
References: <87zllnound.fsf@denkblock.local>
	<20081010091708.GY19428@kernel.dk>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:081011:jens.axboe@oracle.com::dULHNhtBlUkxWQJl:000000000000000000000000000000000000000063r8
X-Hashcash: 1:20:081011:linux-kernel@vger.kernel.org::0O6ya/cV2LBhtj5i:00000000000000000000000000000000008pc
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Oct 02 2008, Elias Oltmanns wrote:
>> Make sure that ->request_fn() really isn't called on queues that are
>> supposed to be stopped. While at it, don't remove the plug in
>> __blk_run_queue() unconditionally since this might lead to system hangs.
>
> What system hangs, can you detail it?

Good question. As it turns out, I got hold of the wrong end of the stick
entirely. Originally, I thought that requests might get enqueued later
and not processed in a timely manner because the queue wasn't plugged.
However, the olny way to do that is through __elv_add_request() and
there it's probably the responsibility of the caller to make sure that
the queue either is plugged or processed straight away. I, for one, have
fallen into that trap and didn't take that into account in my shock
protection code.

>
>> 
>> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>> ---
>> Applies to your devel tree.
>> 
>>  block/blk-core.c |    6 +++---
>>  block/elevator.c |   12 +++++++-----
>>  2 files changed, 10 insertions(+), 8 deletions(-)
>> 
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 2d053b5..ecc5443 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -404,14 +404,14 @@ EXPORT_SYMBOL(blk_sync_queue);
>>   */
>>  void __blk_run_queue(struct request_queue *q)
>>  {
>> -	blk_remove_plug(q);
>> -
>>  	/*
>>  	 * Only recurse once to avoid overrunning the stack, let the unplug
>>  	 * handling reinvoke the handler shortly if we already got there.
>>  	 */
>> -	if (!elv_queue_empty(q))
>> +	if (!elv_queue_empty(q) && likely(!blk_queue_stopped(q))) {
>> +		blk_remove_plug(q);
>>  		blk_invoke_request_fn(q);
>> +	}
>
> Doing
>
>         if (foo && likely(bar))
>
> doesn't make a lot of sense, you need to move the entire block or just
> don't do it. Just don't add it :-)

Right. So the change in this function will just be

-	if (!elv_queue_empty(q))
+	if (!elv_queue_empty(q) && !blk_queue_stopped(q))

since there is no harm in removing the plug unconditionally after all.

>
>>  }
>>  EXPORT_SYMBOL(__blk_run_queue);
>>  
>> diff --git a/block/elevator.c b/block/elevator.c
>> index 0451892..43a4257 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -611,8 +611,10 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
>>  		 *   with anything.  There's no point in delaying queue
>>  		 *   processing.
>>  		 */
>> -		blk_remove_plug(q);
>> -		q->request_fn(q);
>> +		if (likely(!blk_queue_stopped(q))) {
>> +			blk_remove_plug(q);
>> +			q->request_fn(q);
>> +		}
>>  		break;
>>  
>>  	case ELEVATOR_INSERT_SORT:
>> @@ -950,7 +952,8 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
>>  		    blk_ordered_cur_seq(q) == QUEUE_ORDSEQ_DRAIN &&
>>  		    blk_ordered_req_seq(first_rq) > QUEUE_ORDSEQ_DRAIN) {
>>  			blk_ordered_complete_seq(q, QUEUE_ORDSEQ_DRAIN, 0);
>> -			q->request_fn(q);
>> +			if (likely(!blk_queue_stopped(q)))
>> +				q->request_fn(q);
>>  		}
>>  	}
>>  }
>
> I wonder if most of these should not just be blk_start_queueing(), would
> clean things up.

Yes, I wondered about that too. Especially in the case of elv_insert()
though, I wasn't quite sure whether you'd prefer to inline the check
there since this seems to be a fast path. If you don't think it worth
the extra code, I'll just use blk_start_queueing() in these cases too.

Regards,

Elias
