Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYGRMtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYGRMtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYGRMs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:48:56 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:13359 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYGRMsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:48:55 -0400
Message-Id: <488059F8.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 06:53:12 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: remove extraneous load manipulations
References: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
 <20080703213711.1275.56107.stgit@lsg.lsg.lab.novell.com>
 <1216384754.28405.31.camel@twins>
In-Reply-To: <1216384754.28405.31.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Fri, Jul 18, 2008 at  8:39 AM, in message <1216384754.28405.31.camel@twins>,
Peter Zijlstra <peterz@infradead.org> wrote: 
> On Thu, 2008-07-03 at 15:37 -0600, Gregory Haskins wrote:
>> commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b reverted some patches
>> in the scheduler, but it looks like it may have left a few redundant
>> calls to inc_load/dec_load remain in set_user_nice (since the
>>  dequeue_task/enqueue_task take care of the load.  This could result
>> in the load values being off since the load may change while dequeued.
> 
> I just checked out v2.6.25.10 but cannot see dequeue_task() do it.

Perhaps I was trying to hit a moving target, or did not have enough coffee that day ;)

I will look again to see if I made a mistake.

Thanks Peter,

-Greg

> 
> deactivate_task() otoh does do it.
> 
> static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
> {
> 	p->sched_class->dequeue_task(rq, p, sleep);
> 	p->se.on_rq = 0;
> }
> 
> vs
> 
> static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
> {
> 	if (task_contributes_to_load(p))
> 		rq->nr_uninterruptible++;
> 
> 	dequeue_task(rq, p, sleep);
> 	dec_nr_running(p, rq);
> }
> 
> where
> 
> static void dec_nr_running(struct task_struct *p, struct rq *rq)
> {
> 	rq->nr_running--;
> 	dec_load(rq, p);
> }
> 
> And since set_user_nice() actually changes the load we'd better not
> forget to do this dec/inc load stuff.
> 
> So I'm thinking this patch would actually break stuff.
> 
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Ingo Molnar <mingo@elte.hu>
>> ---
>> 
>>  kernel/sched.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 31f91d9..b046754 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -4679,10 +4679,8 @@ void set_user_nice(struct task_struct *p, long nice)
>>  		goto out_unlock;
>>  	}
>>  	on_rq = p->se.on_rq;
>> -	if (on_rq) {
>> +	if (on_rq)
>>  		dequeue_task(rq, p, 0);
>> -		dec_load(rq, p);
>> -	}
>>  
>>  	p->static_prio = NICE_TO_PRIO(nice);
>>  	set_load_weight(p);
>> @@ -4692,7 +4690,7 @@ void set_user_nice(struct task_struct *p, long nice)
>>  
>>  	if (on_rq) {
>>  		enqueue_task(rq, p, 0);
>> -		inc_load(rq, p);
>> +
>>  		/*
>>  		 * If the task increased its priority or is running and
>>  		 * lowered its priority, then reschedule its CPU:
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


