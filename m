Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXDTH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXDTH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXDTH2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:28:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2060 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbXDTH2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:28:21 -0400
Date: Fri, 20 Apr 2007 09:26:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420072626.GA32119@1wt.eu>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au> <20070420044850.GA31438@1wt.eu> <46285781.7090205@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46285781.7090205@bigpond.net.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 04:02:41PM +1000, Peter Williams wrote:
> Willy Tarreau wrote:
> >On Fri, Apr 20, 2007 at 10:10:45AM +1000, Peter Williams wrote:
> >>Ingo Molnar wrote:
> >>>- bugfix: use constant offset factor for nice levels instead of 
> >>>  sched_granularity_ns. Thus nice levels work even if someone sets 
> >>>  sched_granularity_ns to 0. NOTE: nice support is still naive, i'll 
> >>>  address the many nice level related suggestions in -v4.
> >>I have a suggestion I'd like to make that addresses both nice and 
> >>fairness at the same time.  As I understand the basic principle behind 
> >>this scheduler it to work out a time by which a task should make it onto 
> >>the CPU and then place it into an ordered list (based on this value) of 
> >>tasks waiting for the CPU.  I think that this is a great idea and my 
> >>suggestion is with regard to a method for working out this time that 
> >>takes into account both fairness and nice.
> >>
> >>First suppose we have the following metrics available in addition to 
> >>what's already provided.
> >>
> >>rq->avg_weight_load /* a running average of the weighted load on the CPU 
> >>*/
> >>p->avg_cpu_per_cycle /* the average time in nsecs that p spends on the 
> >>CPU each scheduling cycle */
> >>
> >>where a scheduling cycle for a task starts when it is placed on the 
> >>queue after waking or being preempted and ends when it is taken off the 
> >>CPU either voluntarily or after being preempted.  So 
> >>p->avg_cpu_per_cycle is just the average amount of time p spends on the 
> >>CPU each time it gets on to the CPU.  Sorry for the long explanation 
> >>here but I just wanted to make sure there was no chance that "scheduling 
> >>cycle" would be construed as some mechanism being imposed on the 
> >>scheduler.)
> >>
> >>We can then define:
> >>
> >>effective_weighted_load = max(rq->raw_weighted_load, 
> >>rq->avg_weighted_load)
> >>
> >>If p is just waking (i.e. it's not on the queue and its load_weight is 
> >>not included in rq->raw_weighted_load) and we need to queue it, we say 
> >>that the maximum time (in all fairness) that p should have to wait to 
> >>get onto the CPU is:
> >>
> >>expected_wait = p->avg_cpu_per_cycle * effective_weighted_load / 
> >>p->load_weight
> >>
> >>Calculating p->avg_cpu_per_cycle costs one add, one multiply and one 
> >>shift right per scheduling cycle of the task.  An additional cost is 
> >>that you need a shift right to get the nanosecond value from value 
> >>stored in the task struct. (i.e. the above code is simplified to give 
> >>the general idea).  The average would be number of cycles based rather 
> >>than time based and (happily) this simplifies the calculations.
> >>
> >>If the expected time to get onto the CPU (i.e. expected_wait plus the 
> >>current time) for p is earlier than the equivalent time for the 
> >>currently running task then preemption of that task would be justified.
> >
> >I 100% agree on this method because I came to nearly the same conclusion on
> >paper about 1 year ago. What I'd like to add is that the expected wake up 
> >time
> >is not the most precise criterion for fairness.
> 
> It's not the expected wake up time being computed.  It's the expected 
> time that the task is selected to run after being put on the queue 
> (either as a result of waking or being pre-empted).

Sorry, maybe I've not chosen the appropriate words. When I said "wakeup time",
I meant "the date at which the task must reach the CPU". They are the same
when the task is alone, but different when other tasks are run before.

But my goal definitely was to avoid using this alone and use the expected
completion time instead, from which the "on CPU" date can be computed.

The on-CPU time should be reduced if the task ran too long on previous
iterations, and enlarged if the task did not consume all of its last
timeslice, hence the idea behind the credit. I think that it is important
for streaming processes (eg: mp3 players) which will not always consume
the same amount of CPU but are very close to an average after across a
few timeslices.

[...]

> In practice, it might be prudent to use the idea of maximum expected "on 
> CPU" time instead of the average (especially if you're going to use this 
> for triggering pre-emption).

yes

> This would be the average plus two or 
> three time the standard deviation and has the down side that you have to 
> calculate the standard deviation and that means a square root (of course 
> we could use some less mathematically rigorous metric to approximate the 
> standard deviation).

You just have not to do the square root, and compare the unsquared values
instead.

> The advantage would be that streamer type programs 
> such as audio/video applications would have very small standard 
> deviations and would hence get earlier expected "on CPU" times than 
> other tasks with similar averages but more random distribution.

I like this idea.

Regards,
Willy

