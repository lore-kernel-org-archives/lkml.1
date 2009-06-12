Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbZFLBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbZFLBVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZFLBUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:20:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52001 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbZFLBUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:20:53 -0400
Message-ID: <4A31AD0C.8050201@cn.fujitsu.com>
Date: Fri, 12 Jun 2009 09:19:08 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ:optimize the cfq_should_preempt()
References: <4A2E4088.1010403@cn.fujitsu.com> <x49iqj4q8al.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49iqj4q8al.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer said:
> Shan Wei <shanwei@cn.fujitsu.com> writes:
> 
>> The patch don't fix bug, just optimizes the cfq_should_preempt()
>> to preempt higher priority queue.
>>
>> Additionally, the comment above cfq_preempt_queue() is outdated.
>>
>>
>> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
>> ---
>>  block/cfq-iosched.c |   17 +++++------------
>>  1 files changed, 5 insertions(+), 12 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index a55a9bd..427f522 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -1993,10 +1993,10 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>>  	if (cfq_slice_used(cfqq))
>>  		return 1;
>>  
>> -	if (cfq_class_idle(new_cfqq))
>> -		return 0;
>> -
>> -	if (cfq_class_idle(cfqq))
>> +	/*
>> +	 * if new_cfqq is of higher priority, preempting the active queue.
>> +	 */
>> +	if (new_cfqq->ioprio_class < cfqq->ioprio_class)
>>  		return 1;
> 
> Prior to this patch, if both queues were idle, the first if statement
> would evaluate to true and we would return 0.  With your patch, we fall
> through to the rest of the logic in the function.  In such a case, I
> don't think this is an optimiation.  I can't say how likely this is to
> happen, though.
> 
> What other justfication do you have for this change?  Were you able to
> measure a performance difference?
> 

The optimization is just to merge code. 
Sorry, I have not done a performance test.

See the commend: 
	/*
	 * not the active queue - expire current slice if it is
	 * idle and has expired it's mean thinktime or this new queue
	 * has some old slice time left and is of higher priority or
	 * this new queue is RT and the current one is BE
	 */

I understand the comment that if it can meet the any one of the following 3 conditions,
expire current slice.
1)it(current active queue) is idle and has expired it's mean thinktime
  (IDLE is lower than any other priority)
2)this new queue has some old slice time left and is of higher priority
3)this new queue is RT and the current one is BE(RT is higher than BE)

So, firstly, the queue of higher priority should preempt the one of lower priority,
and then check the requests type(sync or metadata) for same priority queues.
Base on this point, merge/optimize the original code to deal with queue priority.
What I understand is right? If both queues are idle, why not to check request type?

When the request of new_cfqq is BE&&SYNC, and cfqq is RT&&ASYNC in original code,
new_cfqq will preempt the cfqq. 
Is the behaviour that higher priority queue is preempted is in reason? 
May I miss something?

Thanks
Shan Wei

> Cheers,
> Jeff
> 
>

