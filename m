Return-Path: <linux-kernel-owner+w=401wt.eu-S1030863AbXDMWcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863AbXDMWcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDMWcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:32:09 -0400
Received: from 1wt.eu ([62.212.114.60]:1794 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030863AbXDMWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:32:07 -0400
Date: Sat, 14 Apr 2007 00:31:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413223131.GA1642@1wt.eu>
References: <20070413202100.GA9957@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413202100.GA9957@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
(...)
>    CFS's design is quite radical: it does not use runqueues, it uses a
>    time-ordered rbtree to build a 'timeline' of future task execution,
>    and thus has no 'array switch' artifacts (by which both the vanilla
>    scheduler and RSDL/SD are affected).

I have a high confidence this will work better : I've been using
time-ordered trees in userland projects for several years, and never
found anything better. To be honnest, I never understood the concept
behind the array switch, but as I never felt brave enough to hack
something in this kernel area, I simply preferred to shut up (not
enough knowledge and not enough time).

However, I have been using a very fast struct timeval-ordered RADIX
tree. I found generic rbtree code to generally be slower, certainly
because of the call to a function with arguments on every node. Both
trees are O(log(n)), the rbtree being balanced and the radix tree
being unbalanced. If you're interested, I can try to see how that
would fit (but not this week-end).

Also, I had spent much time in the past doing paper work on how to
improve fairness between interactive tasks and batch tasks. I came
up with the conclusion that for perfectness, tasks should not be
ordered by their expected wakeup time, but by their expected completion
time, which automatically takes account of their allocated and used
timeslice. It would also allow both types of workloads to share equal
CPU time with better responsiveness for the most interactive one through
the reallocation of a "credit" for the tasks which have not consumed
all of their timeslices. I remember we had discussed this with Mike
about one year ago when he fixed lots of problems in mainline scheduler.
The downside is that I never found how to make this algo fit in
O(log(n)). I always ended in something like O(n.log(n)) IIRC.

But maybe this is overkill for real life anyway. Given that a basic two
arrays switch (which I never understood) was sufficient for many people,
probably that a basic tree will be an order of magnitude better.

>    CFS uses nanosecond granularity accounting and does not rely on any
>    jiffies or other HZ detail. Thus the CFS scheduler has no notion of
>    'timeslices' and has no heuristics whatsoever. There is only one
>    central tunable:
> 
>          /proc/sys/kernel/sched_granularity_ns
> 
>    which can be used to tune the scheduler from 'desktop' (low
>    latencies) to 'server' (good batching) workloads. It defaults to a
>    setting suitable for desktop workloads. SCHED_BATCH is handled by the
>    CFS scheduler module too.

I find this useful, but to be fair with Mike and Con, they both have
proposed similar tuning knobs in the past and you said you did not want
to add that complexity for admins. People can sometimes be demotivated
by seeing their proposals finally used by people who first rejected them. 
And since both Mike and Con both have done a wonderful job in that area,
we need their experience and continued active participation more than ever.

>    due to its design, the CFS scheduler is not prone to any of the
>    'attacks' that exist today against the heuristics of the stock
>    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
>    work fine and do not impact interactivity and produce the expected
>    behavior.

I'm very pleased to read this. Because as I have already said it, my major
concern with 2.6 was the stock scheduler. Recently, RSDL fixed most of the
basic problems for me to the point that I switched the default lilo entry
on my notebook to 2.6 ! I hope that whatever the next scheduler will be,
we'll definitely get rid of any heuristics. Heuristics are good in 95% of
situations and extremely bad in the remaining 5%. I prefer something
reasonably good in 100% of situations.

>    the CFS scheduler has a much stronger handling of nice levels and
>    SCHED_BATCH: both types of workloads should be isolated much more
>    agressively than under the vanilla scheduler.
> 
>    ( another rdetail: due to nanosec accounting and timeline sorting,
>      sched_yield() support is very simple under CFS, and in fact under
>      CFS sched_yield() behaves much better than under any other
>      scheduler i have tested so far. )
> 
>  - sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler
>    way than the vanilla scheduler does. It uses 100 runqueues (for all
>    100 RT priority levels, instead of 140 in the vanilla scheduler)
>    and it needs no expired array.
> 
>  - reworked/sanitized SMP load-balancing: the runqueue-walking
>    assumptions are gone from the load-balancing code now, and
>    iterators of the scheduling modules are used. The balancing code got
>    quite a bit simpler as a result.

Will this have any impact on NUMA/HT/multi-core/etc... ?

> the core scheduler got smaller by more than 700 lines:

Well done !

Cheers,
Willy

