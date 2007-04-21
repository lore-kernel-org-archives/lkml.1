Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbXDUFH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbXDUFH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 01:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXDUFH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 01:07:29 -0400
Received: from holomorphy.com ([66.93.40.71]:54436 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbXDUFH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 01:07:28 -0400
Date: Fri, 20 Apr 2007 22:07:34 -0700
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
Message-ID: <20070421050734.GL31925@holomorphy.com>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420131544.GG31925@holomorphy.com> <4629596B.6020403@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4629596B.6020403@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> This essentially doesn't look correct because while you want to enforce
>> the CPU bandwidth allocation, this doesn't have much to do with that
>> apart from the CPU bandwidth appearing as a term. It's more properly
>> a rate of service as opposed to a time at which anything should happen
>> or a number useful for predicting such. When service should begin more
>> properly depends on the other tasks in the system and a number of other
>> decisions that are part of the scheduling policy.

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> This model takes all of those into consideration.  The idea is not just 
> to predict but to use the calculated time to decide when to boot the 
> current process of the CPU (if it doesn't leave voluntarily) and put 
> this one on.  This more or less removes the need to give each task a 
> predetermined chunk of CPU when they go on to the CPU.  This should, in 
> general, reduce the number context switches as tasks get to run until 
> they've finished what they're doing or another task becomes higher 
> priority rather than being booted off after an arbitrary time interval. 
>  (If this ever gets tried it will be interesting to see if this 
> prediction comes true.)
> BTW Even if Ingo doesn't choose to try this model, I'll probably make a 
> patch (way in the future after Ingo's changes are settled) to try it out 
> myself.

I think I smoked out what you were doing.


William Lee Irwin III wrote:
>> If you want to choose a "quasi-inter-arrival time" to achieve the
>> specified CPU bandwidth allocation, this would be it, but to use that
>> to actually enforce the CPU bandwidth allocation, you would need to
>> take into account the genuine inter-arrival time to choose an actual
>> time for service to begin. In other words, this should be a quota for
>> the task to have waited. If it's not waited long enough, then it should
>> be delayed by the difference to achieve the inter-arrival time you're
>> trying to enforce. If it's waited longer, it should be executed
>> sooner modulo other constraints, and perhaps even credited for future
>> scheduling cycles.

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> The idea isn't to enforce the bandwidth entitlement to the extent of 
> throttling tasks if they exceed their entitlement and there's no other 
> tasks ready to use the CPU.  This is mainly because the bandwidth 
> entitlement isn't fixed -- it's changing constantly as the number and 
> type of runnable tasks changes.

Well, a little hysteresis will end up throttling in such a manner
anyway as a side-effect, or you'll get anomalies. Say two tasks with
equal entitlements compete, where one sleeps for 1/3 of the time and
the other is fully CPU-bound. If only the times when they're in direct
competition are split 50/50, then the CPU-bound task gets 2/3 and the
sleeper 1/3, which is not the intended effect. I don't believe this
model will be very vulnerable to it, though.


William Lee Irwin III wrote:
>> In order to partially avoid underallocating CPU bandwidth to p, one
>> should track the time last spent sleeping and do the following:

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> Yes I made a mistake in omitting to take into account sleep interval. 
> See another e-mail to Ingo correcting this problem.

I took it to be less trivial of an error than it was. No big deal.


William Lee Irwin III wrote:
>> In order to do better, longer-term history is required,

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> The half life of the Kalman filter (roughly equivalent to a running 
> average) used to calculate the averages determines how much history is 
> taken into account.  It could be made configurable (at least, until 
> enough real life experience was available to decide on the best value to 
> use).

A Kalman filter would do better than a running average. I'm all for it.


William Lee Irwin III wrote:
>> To attempt to maintain an infinite history of
>> bandwidth underutilization to be credited too far in the future would
>> enable potentially long-term overutilization when such credits are
>> cashed en masse for a sustained period of time. At some point you have
>> to say "use it or lose it;" over a shorter period of time some smoothing
>> is still admissible and even desirable.

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> Yes, that's why I suggest a running average over the last few scheduling 
> cycles for the task.  But thinking about it some more I'm now not so 
> sure.  The lack of apparent "smoothness" when I've done this sort of 
> thing with raw rather than smooth data (in modifications to the current 
> dynamic priority based scheduler model) is usually noticed by running 
> top and seeing wildly fluctuating dynamic priorities.  I'm not sure that 
> the actual responsiveness of the system reflects this.  So I'm now 
> willing to reserve my judgement on this issue.

I'm thinking smoothing should be over a relatively short period of time,
probably shorter than human reflexes can discern.


William Lee Irwin III wrote:
>> One might also consider debits owing to non-preemptibility or other
>> sorts of cpu bandwidth overutilization with similar caveats. A half-
>> life to an otherwise infinite history of credits and/or debits
>> specified in absolute time may be appropriate, though it's not quite as
>> computationally cheap as the above. The accounting for these credits
>> and debits would take the place of ->last_taken_off_the_cpu above.

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> Credits shouldn't be necessary with this model if, instead of using the 
> average "on CPU" time per cycle for a pre-empted task when requeuing it, 
> you use the time period that it was "an CPU" before it was booted off as 
> this should compensate it correctly.

That was all about trying to do more in the vein of CPU bandwidth
allocation enforcement. It's not the only attack on the problem, and
may not even be a desirable one.


William Lee Irwin III wrote:
>> Another attack on the problem of CPU bandwidth misallocation would be
>> to further credit or debit the task according to the ratio of actual
>> CPU bandwidth to allocated CPU bandwidth in order to compensate
>> for prior failures to enforce the allocation.

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> The fact that the allocated CPU bandwidth is changing continuously makes 
> this not a good idea.  On a system where allocations were made directly 
> rather being a side effect of "nice" and the number of runnable 
> processes it might be the way to go.

Where it changes continuously the intended effect is some hysteresis.
I'm thinking of the CPU-bound task vs. the task that sleeps 1/3 of the
time and similar such cases. Interestingly, cfs seems to get the
intended allocation by maintaining an effectively infinite history.
This is another reason I think it's important to strive for the CPU
bandwidth allocation "correctness;" it's already been accomplished in
some respects, albeit without relative prioritization.

Maybe a good test for whether an extension for relative prioritization
works would be to make the load weights for each nice level configurable
via /proc/ and then see if the algorithm successfully allocates shares
of CPU bandwidth in various cases accordingly.


William Lee Irwin III wrote:
>> The rest and/or stronger
>> attempts to factor in sleeping time or bandwidth misallocation I don't
>> consider so significant, at least not without some demonstration there
>> is CPU bandwidth misallocation happening.

Right here I sort of downplayed trying too hard to enforce things, at
least computationally.


William Lee Irwin III wrote:
>> I don't know. It sounds rather standard to me.

On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> That's good to hear.
> I also think that (as Ingo would probably prefer) that this mechanism 
> might work without using averages i.e. just use the last "on CPU" time. 
>  If it does work it would have the advantage of being impervious to the 
> possible bad effects of CPU speed changes on those systems where this is 
> a feature.  When using averages, I think that special consideration 
> would need to be made for variable cpu speeds -- probably not that 
> difficult but additional overhead anyway.

Timekeeping needs adjustments for all that, so the scheduler should
just be able to call the timekeeping functions that need to be written
for it anyway.


On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> I've been giving some thought into a mechanism for pre-empting the 
> current task when another task's expected "on CPU" time arrives.  I 
> think that it would be sufficient for scheduler_tick() to compare the 
> current time (via sched_clock() or whatever) with the "on CPU" for the 
> next task on the queue and initiation pre-emption if it's later than 
> that time.  This increases the granularity a little but is compensated 
> for by the fact it will help with the situation where more than one task 
> on the queue has the same expected "on CPU" time in that each of them 
> would get at least a tick (if they needed it).

Another nicety is that you can pretty much predict when you're going to
need to preempt, so you can nuke the periodic scheduling interrupt and
use a one-shot timer for whenever the next preemption is meant to occur.
This nets power savings and less interrupt overhead for userspace.


On Sat, Apr 21, 2007 at 10:23:07AM +1000, Peter Williams wrote:
> If some form of precise timer was used (instead) to trigger pre-emption 
> then, where there is more than one task with the same expected "on CPU" 
> time, only the last would get any CPU (and that's only the case if some 
> infinite loop doesn't get created).

I think you can check for this and adjust their on-cpu times in various
ways and choose what order to run them in. I think it'd end up something
of a missed deadline policy.


-- wli
