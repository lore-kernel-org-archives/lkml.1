Return-Path: <linux-kernel-owner+w=401wt.eu-S2992675AbXDTNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992675AbXDTNPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993059AbXDTNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:15:50 -0400
Received: from holomorphy.com ([66.93.40.71]:38920 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992675AbXDTNPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:15:49 -0400
Date: Fri, 20 Apr 2007 06:15:44 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420131544.GG31925@holomorphy.com>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46280505.4020605@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
> I have a suggestion I'd like to make that addresses both nice and 
> fairness at the same time.  As I understand the basic principle behind 
> this scheduler it to work out a time by which a task should make it onto 
> the CPU and then place it into an ordered list (based on this value) of 
> tasks waiting for the CPU.  I think that this is a great idea and my 
> suggestion is with regard to a method for working out this time that 
> takes into account both fairness and nice.

Hmm. Let me take a look...


On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
> First suppose we have the following metrics available in addition to 
> what's already provided.
> rq->avg_weight_load /* a running average of the weighted load on the CPU */
> p->avg_cpu_per_cycle /* the average time in nsecs that p spends on the 
> CPU each scheduling cycle */

I'm suspicious of mean service times not paired with mean inter-arrival
times.


On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
> where a scheduling cycle for a task starts when it is placed on the 
> queue after waking or being preempted and ends when it is taken off the 
> CPU either voluntarily or after being preempted.  So 
> p->avg_cpu_per_cycle is just the average amount of time p spends on the 
> CPU each time it gets on to the CPU.  Sorry for the long explanation 
> here but I just wanted to make sure there was no chance that "scheduling 
> cycle" would be construed as some mechanism being imposed on the scheduler.)

I went and looked up priority queueing queueing theory garbage and
re-derived various things I needed. The basics check out. Probably no
one cares that I checked.


On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
> We can then define:
> effective_weighted_load = max(rq->raw_weighted_load, rq->avg_weighted_load)
> If p is just waking (i.e. it's not on the queue and its load_weight is 
> not included in rq->raw_weighted_load) and we need to queue it, we say 
> that the maximum time (in all fairness) that p should have to wait to 
> get onto the CPU is:
> expected_wait = p->avg_cpu_per_cycle * effective_weighted_load / 
> p->load_weight

This doesn't look right, probably because the scaling factor of
p->avg_cpu_per_cycle is the reciprocal of its additive contribution to
the ->avg_weight_load as opposed to a direct estimate of its initial
delay or waiting time before completing its current requested service.

p->load_weight/effective_weighted_load more properly represents an
entitlement to CPU bandwidth.
	p->avg_cpu_per_cycle/(p->load_weight/effective_weighted_load)
would be more like the expected time spent on the runqueue (whether
waiting to run or actually running) for a time interval spent in a
runnable state and the expected time runnable and waiting to run in such
an interval would be
	p->avg_cpu_per_cycle*(1-effective_weighted_load/p->load_weight),

Neither represents the initial delay between entering the runqeueue and
first acquiring the CPU, but that's a bit hard to figure out without
deciding the scheduling policy up-front anyway.

This essentially doesn't look correct because while you want to enforce
the CPU bandwidth allocation, this doesn't have much to do with that
apart from the CPU bandwidth appearing as a term. It's more properly
a rate of service as opposed to a time at which anything should happen
or a number useful for predicting such. When service should begin more
properly depends on the other tasks in the system and a number of other
decisions that are part of the scheduling policy.

If you want to choose a "quasi-inter-arrival time" to achieve the
specified CPU bandwidth allocation, this would be it, but to use that
to actually enforce the CPU bandwidth allocation, you would need to
take into account the genuine inter-arrival time to choose an actual
time for service to begin. In other words, this should be a quota for
the task to have waited. If it's not waited long enough, then it should
be delayed by the difference to achieve the inter-arrival time you're
trying to enforce. If it's waited longer, it should be executed
sooner modulo other constraints, and perhaps even credited for future
scheduling cycles.

In order to partially avoid underallocating CPU bandwidth to p, one
should track the time last spent sleeping and do the following:
	last_sleep = now - p->last_went_to_sleep;
	wait = p->avg_cpu_per_cycle*effective_weighted_load/p->load_weight;
	wait = wait > last_sleep ? wait - last_sleep : 0;

By and large the scheduler can deterministically choose waits on the
runqueue but it doesn't actually do that. Some additional corrections
for delays beyond those decided up-front while on the runqueue or
getting scheduled early on the runqueue may also help, though I'm not
as interested in them as I am the one for sleep:
	last_wait = now - p->last_taken_off_the_cpu;
	wait = p->avg_cpu_per_cycle*effective_weighted_load/p->load_weight;
	if (wait > last_wait) /* didn't wait long enough? */
		wait += wait - last_wait; /* wait the difference longer */
	else if (wait < last_wait) /* waited too long? */
		/* wait less to make up the difference */
		wait -= wait > last_wait - wait ? last_wait - wait : wait;
Where ->last_taken_off_the_cpu represents the time the task was last
taken off the CPU for whatever reason (this may need to be done
differently to handle time variables).

In order to do better, longer-term history is required, but it can't be
a truly infinite history. To attempt to maintain an infinite history of
bandwidth underutilization to be credited too far in the future would
enable potentially long-term overutilization when such credits are
cashed en masse for a sustained period of time. At some point you have
to say "use it or lose it;" over a shorter period of time some smoothing
is still admissible and even desirable.

One might also consider debits owing to non-preemptibility or other
sorts of cpu bandwidth overutilization with similar caveats. A half-
life to an otherwise infinite history of credits and/or debits
specified in absolute time may be appropriate, though it's not quite as
computationally cheap as the above. The accounting for these credits
and debits would take the place of ->last_taken_off_the_cpu above.

Another attack on the problem of CPU bandwidth misallocation would be
to further credit or debit the task according to the ratio of actual
CPU bandwidth to allocated CPU bandwidth in order to compensate
for prior failures to enforce the allocation. Unfortunately, the result
of scaling the artificial inter-arrival time in the obvious way is
degenerate (independent of priority) so it can't be done that simply.
Perhaps it could be used solely to adjust the credit and debit history
contribution to the quasi-inter-arrival time or the difference used
somehow, but I don't care to make more complex proposals than the
first-order correction above (if it's even worthy of being called a
proposal or a correction) for either this or a time-decaying credit
and debit history or even debit accounting at all.

I'd be happy enough to see the correction term to subtract out sleeping
time (i.e. the code snippet with last_sleep). The rest and/or stronger
attempts to factor in sleeping time or bandwidth misallocation I don't
consider so significant, at least not without some demonstration there
is CPU bandwidth misallocation happening.


On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
> I appreciate that the notion of basing the expected wait on the task's 
> average cpu use per scheduling cycle is counter intuitive but I believe 
> that (if you think about it) you'll see that it actually makes sense.

I don't know. It sounds rather standard to me.


-- wli
