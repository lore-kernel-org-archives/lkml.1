Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZISIbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZISIbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZISIby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZISIbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:31:50 -0400
Message-ID: <4AB496ED.7010800@redhat.com>
Date: Sat, 19 Sep 2009 11:31:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Mark Langsdorf <mark.langsdorf@amd.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent immediate process rescheduling
References: <200909181449.12311.mark.langsdorf@amd.com>	 <20090918195455.GC11726@elte.hu> <1253304203.10538.64.camel@laptop>
In-Reply-To: <1253304203.10538.64.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 11:03 PM, Peter Zijlstra wrote:
> On Fri, 2009-09-18 at 21:54 +0200, Ingo Molnar wrote:
>
>    
>>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>>> index 652e8bd..4fad08f 100644
>>> --- a/kernel/sched_fair.c
>>> +++ b/kernel/sched_fair.c
>>> @@ -353,11 +353,25 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>>>   static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
>>>   {
>>>   	struct rb_node *left = cfs_rq->rb_leftmost;
>>> +	struct sched_entity *se, *curr;
>>>
>>>   	if (!left)
>>>   		return NULL;
>>>
>>> -	return rb_entry(left, struct sched_entity, run_node);
>>> +	se = rb_entry(left, struct sched_entity, run_node);
>>> +	curr =&current->se;
>>> +
>>> +	/*
>>> +	 * Don't select the entity who just tried to schedule away
>>> +	 * if there's another entity available.
>>> +	 */
>>> +	if (unlikely(se == curr&&  cfs_rq->nr_running>  1)) {
>>> +		struct rb_node *next_node = rb_next(&curr->run_node);
>>> +		if (next_node)
>>> +			se = rb_entry(next_node, struct sched_entity, run_node);
>>> +	}
>>> +
>>> +	return se;
>>>   }
>>>        
> Really hate this change though,. doesn't seem right to not pick the same
> task again if its runnable. Bad for cache footprint.
>
> The scenario is quite common for stuff like:
>
> CPU0                                      CPU1
>
> set_task_state(TASK_INTERRUPTIBLE)
>
> if (cond)
>    goto out;
>                                       <--- ttwu()
> schedule();
>
>    

I agree, yielding should be explicitly requested.

Also, on a heavily overcommitted box an undirected yield might take 
quite a long time to find the thread that's holding the lock.  I think a 
yield_to() will be a lot better:

- we can pick one of the vcpus belonging to the same guest to improve 
the probability that the lock actually get released
- we avoid an issue when the other vcpus are on different runqueues (in 
which case the current patch does nothing)
- we can fix the accounting by donating vruntime from current to the 
yielded-to vcpu


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

