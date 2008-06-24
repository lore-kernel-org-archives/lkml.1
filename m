Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYFXBjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYFXBjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYFXBjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:39:18 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:19428 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYFXBjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:39:17 -0400
Message-Id: <4860261A.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 23 Jun 2008 20:39:22 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <peterz@infradead.org>,
       <tglx@linutronix.de>, "David Bahi" <DBahi@novell.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at
	least one task has moved over
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
 <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
 <200806241050.12028.nickpiggin@yahoo.com.au>
In-Reply-To: <200806241050.12028.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

>>> On Mon, Jun 23, 2008 at  8:50 PM, in message
<200806241050.12028.nickpiggin@yahoo.com.au>, Nick Piggin
<nickpiggin@yahoo.com.au> wrote: 
> On Tuesday 24 June 2008 09:04, Gregory Haskins wrote:
>> Inspired by Peter Zijlstra.
> 
> Is this really getting tested well?   Because at least for SCHED_OTHER
> tasks,

Note that this only affects SCHED_OTHER.  RT tasks are handled with a different algorithm.

> the newidle balancer is still supposed to be relatively
> conservative and not over balance too much.

In our testing, newidle is degrading the system (at least for certain workloads).  Oprofile was
showing that newidle can account for 60-80% of the CPU during our benchmark runs. Turning
off newidle *completely* by commenting out idle_balance() boosts netperf performance by
200% for our 8-core to 8-core UDP transaction test. Obviously neutering it is not sustainable
as a general solution, so we are trying to reduce its negative impact.

It is not clear whether the problem is that newidle is over-balancing the system, or that newidle
is simply running too frequently as a symptom of a system that has a high frequency of context
switching (such as -rt).  I  suspected the latter, so I was attracted to Peter's idea based
on the concept of shortening the time we execute this function.  But I have to admit, unlike 1/3
and 2/3 which I have carefully benchmarked individually and know make a positive performance
impact, I pulled this in more on theory.  I will try to benchmark this individually as well.

> By the time you have
> done all this calculation and reached here, it will be a loss to only
> move one task if you could have moved two and halved your newidle
> balance rate...

Thats an interesting point that I did not consider, but note that a very significant chunk of the overhead
I believe comes from the double_lock/move_tasks code after the algorithmic complexity is completed.

I believe the primary motivation of this patch is related to reducing the overall latency in the schedule()
critical section.  Currently this operation can perform an unbounded move_task operation in a
preempt-disabled region (which, as an aside, is always SCHED_OTHER related).

Since the bare minimum requirement is to move at least one task, I think this is a tradeoff: newidle
balance-rate vs critical-section depth.  For RT obviously we put more weight on the latter, but perhaps
this is not a mainline worthy concept afterall.  I will defer to Peter to comment further.

Thanks for the review, Nick.

Regards,
-Greg

> 
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  kernel/sched.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 3efbbc5..c8e8520 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2775,6 +2775,10 @@ static int move_tasks(struct rq *this_rq, int
>> this_cpu, struct rq *busiest, max_load_move - total_load_moved,
>>  				sd, idle, all_pinned, &this_best_prio);
>>  		class = class->next;
>> +
>> +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
>> +			break;
>> +
>>  	} while (class && max_load_move > total_load_moved);
>>
>>  	return total_load_moved > 0;
>>
>> --


