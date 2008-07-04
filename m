Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbYGDClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbYGDClT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYGDClD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:41:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbYGDClB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:41:01 -0400
Message-ID: <486D8D48.6050701@cn.fujitsu.com>
Date: Fri, 04 Jul 2008 10:39:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: jha@email.unc.edu, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "James H. Anderson" <anderson@cs.unc.edu>, jeffay@cs.unc.edu
Subject: Re: [PATCH] sched: fix unfairness when upgrade weight
References: <48687CDB.5070702@cn.fujitsu.com>	<1215035379.28676.32.camel@lappy.programming.kicks-ass.net> <20080703073035.5w35c70kjc4o0s4c@webmail4.isis.unc.edu>
In-Reply-To: <20080703073035.5w35c70kjc4o0s4c@webmail4.isis.unc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Hi Lai,
> 
> On Mon, 2008-06-30 at 14:27 +0800, Lai Jiangshan wrote:
>> When two or more process upgrade their priority,
>> unfairness will happen, several of them may get all cpu-usage,
>> and the other cannot be scheduled to run for a long time.
>>
>> example:
>> # (create 2 processes and set affinity to cpu#0)
>> # renice 19 pid1 pid2
>> # renice -19 pid1 pid2
>>
>> step3 upgrade the 2 processes' weight, these 2 processes should
>> share the cpu#0 as soon as possible after step3, and any of them
>> should get 50% cpu-usage. But sometimes one of them gets all cpu-usage
>> for tens of seconds before they share the cpu#0.
>>
>> fair-group example:
>> # mkdir 1 2 (create 2 fair-groups)
>> # (create 2 processes and set affinity to cpu#0)
>> # echo pid1 > 1/tasks ; echo pid2 > 2/tasks
>> # echo 2 > 1/cpu.shares ; echo 2 > 2/cpu.shares
>> # echo $((2**18)) > 1/cpu.shares ; echo $((2**18)) > 2/cpu.shares
>>
>> The reason why such unfairness happened:
>>
>> When a sched_entity is running, if its weight is low, its vruntime
>> increases by a large value every time and if its weight
>> is high, its vruntime increases by a small value.
>>
>> So when the two sched_entity's weight is low, they will still 
>> fairness even if difference of their vruntime is large, but if
>> their weight are upgraded, this large difference of vruntime
>> will bring unfairness.
>>
>> example:
>> se1's vruntime         se2's vruntime
>>     1000M               (R) 1020M
>> 	(assume vruntime is increases by about 50M every time)
>> (R) 1050M                   1020M 
>>     1050M               (R) 1070M
>> (R) 1100M                   1070M
>>     1100M               (R) 1120M 
>> 	(fairness, even if difference of their vruntime is large)
>> 	(upgrade their weight, vruntime is increases by about 10K)
>> (R) 1100M+10K               1120M
>> (R) 1100M+20K               1120M
>> (R) 1100M+30K               1120M
>> (R) 1100M+40K               1120M
>> (R) 1100M+50K               1120M
>> 	(se1 gets all cpu-usage for long time (mybe about tens
>> of seconds))
>> 	(unfairness, difference=20M is too large for new weight)
> 
> My initial response to this email was: sure, that's because you cannot
> renice two tasks atomically - we'll just have to live with that.
> 
> However after a bit more thought it occurred to me this is because we're
> changing the weight of a task with non-zero lag.
> 


IMO, that's because the next runtime of a se is *predetermined*(use
se->vruntime to determine its next runtime).

So the solution of this problem is that the next runtime must be
redetermined when weight is changed.

And my solution use MIN(cfs_rq->min_vruntime, 
cfs_rq->curr->vruntime, __pick_next_entity(cfs_rq)->vruntime)
as "current vruntime", and I suppose that pre_delta_exec < TICK_NSEC
(I suppose that local irq is disabled too long is a rare phenomena)

(And I suppose the value wakeup_gran is very small value too,
"current vruntime" is not so accurate)

But my solution don't redetermined se's next runtime when weight
is degraded. It's a big weakness.


> I think the proper solution to this problem is to scale the lag
> according to the change in weights. But lets ask James, who is an expert
> in this area.
> 
> 
> So while I think you're right in that we have an issue, I don't like
> your solution.
> 
> How about something like these patches (compile tested only).
> 


How your solution fix this:
se1's weight is biger than se2's weight at first

and then we upgrade se2's weight:
se1 = cfs_rq->curr(not in rbtree), se2 is *the only* node in the rbtree,
and se1's vruntime=1000M,  se2's vruntime = 1020M

But se2's vruntime still is 1020M after se2's weight is upgraded in your solution.

Unfairness still happen(difference=20M is too large for biger weight in).

Some times (cfs_rq->min_vruntime - cfq_rq->curr->vruntime) is a large
difference for huge weight.

>  
> +static void prio_changed_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
> +		unsigned long old_weight, unsigned long new_weight)
> +{
> +	u64 avg;
> +	s64 lag;
> +
> +	if (old_weight == new_weight)
> +		return;
> +
> +	dequeue_entity(cfs_rq, se, 0);
> +
> +	avg = avg_vruntime(cfs_rq);
> +	lag = (s64)(se->vruntime - avg);
> +
> +	lag *= new_weight;

why  lag = lag * new_weight; ?

> +	lag = div_s64(lag, old_weight);
> +
> +	se->vruntime = avg + lag;

how about (s64)(se->vruntime - avg) > 0?
and how about (s64)(se->vruntime - avg) < 0?

> +
> +	enqueue_entity(cfs_rq, se, 0);
> +}
> +


----------
I suggest that combine your solution and mine:
use cfs_rq->curr_vruntime to track carefully the "current vruntime"
of this cfs_rq and:

static void prio_changed_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
		unsigned long old_weight, unsigned long new_weight)
{
	u64 cfs_vruntime;
	u64 vdelta_exec;

	if (old_weight == new_weight)
		return;

	dequeue_entity(cfs_rq, se, 0);

	cfs_vruntime = cfs_rq->curr_vruntime;
	vdelta_exec = (s64)(se->vruntime - cfs_vruntime);

	if (likely(((s64)vdelta_exec) > 0)) {
		vdelta_exec *= old_weight;
		vdelta_exec = div_u64(vdelta_exec, new_weight);
	}

	se->vruntime = cfs_vruntime + vdelta_exec;

	enqueue_entity(cfs_rq, se, 0);
}

