Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXDMWVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXDMWVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030860AbXDMWVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:21:43 -0400
Received: from holomorphy.com ([66.93.40.71]:53456 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030468AbXDMWVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:21:41 -0400
Date: Fri, 13 Apr 2007 15:21:51 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413222151.GD8915@holomorphy.com>
References: <20070413202100.GA9957@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413202100.GA9957@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> This project is a complete rewrite of the Linux task scheduler. My goal
> is to address various feature requests and to fix deficiencies in the
> vanilla scheduler that were suggested/found in the past few years, both
> for desktop scheduling and for server scheduling workloads.
> [ QuickStart: apply the patch to v2.6.21-rc6, recompile, reboot. The
>   new scheduler will be active by default and all tasks will default
>   to the new SCHED_FAIR interactive scheduling class. ]

A pleasant surprise, though I did see it coming.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> Highlights are:
>  - the introduction of Scheduling Classes: an extensible hierarchy of
>    scheduler modules. These modules encapsulate scheduling policy
>    details and are handled by the scheduler core without the core
>    code assuming about them too much.

It probably needs further clarification that they're things on the order
of SCHED_FIFO, SCHED_RR, SCHED_NORMAL, etc.; some prioritization amongst
the classes is furthermore assumed, and so on. They're not quite
capable of being full-blown alternative policies, though quite a bit
can be crammed into them.

There are issues with the per- scheduling class data not being very
well-abstracted. A union for per-class data might help, if not a
dynamically allocated scheduling class -private structure. Getting
an alternative policy floating around that actually clashes a little
with the stock data in the task structure would help clarify what's
needed.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>  - sched_fair.c implements the 'CFS desktop scheduler': it is a
>    replacement for the vanilla scheduler's SCHED_OTHER interactivity
>    code.
>    i'd like to give credit to Con Kolivas for the general approach here:
>    he has proven via RSDL/SD that 'fair scheduling' is possible and that
>    it results in better desktop scheduling. Kudos Con!

Bob Mullens banged out a virtual deadline interactive task scheduler
for Multics back in 1976 or thereabouts. ISTR the name Ferranti in
connection with deadline task scheduling for UNIX in particular. I've
largely seen deadline schedulers as a realtime topic, though. In any
event, it's not so radical as to lack a fair number of precedents.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>    The CFS patch uses a completely different approach and implementation
>    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
>    that of RSDL/SD, which is a high standard to meet :-) Testing
>    feedback is welcome to decide this one way or another. [ and, in any
>    case, all of SD's logic could be added via a kernel/sched_sd.c module
>    as well, if Con is interested in such an approach. ]
>    CFS's design is quite radical: it does not use runqueues, it uses a
>    time-ordered rbtree to build a 'timeline' of future task execution,
>    and thus has no 'array switch' artifacts (by which both the vanilla
>    scheduler and RSDL/SD are affected).

A binomial heap would likely serve your purposes better than rbtrees.
It's faster to have the next item to dequeue at the root of the tree
structure rather than a leaf, for one. There are, of course, other
priority queue structures (e.g. van Emde Boas) able to exploit the
limited precision of the priority key for faster asymptotics, though
actual performance is an open question.

Another advantage of heaps is that they support decreasing priorities
directly, so that instead of removal and reinsertion, a less invasive
movement within the tree is possible. This nets additional constant
factor improvements beyond those for the next item to dequeue for the
case where a task remains runnable, but is preempted and its priority
decreased while it remains runnable.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>    CFS uses nanosecond granularity accounting and does not rely on any
>    jiffies or other HZ detail. Thus the CFS scheduler has no notion of
>    'timeslices' and has no heuristics whatsoever. There is only one
>    central tunable:
>          /proc/sys/kernel/sched_granularity_ns
>    which can be used to tune the scheduler from 'desktop' (low
>    latencies) to 'server' (good batching) workloads. It defaults to a
>    setting suitable for desktop workloads. SCHED_BATCH is handled by the
>    CFS scheduler module too.

I like not relying on timeslices. Timeslices ultimately get you into
a 2.4.x -like epoch expiry scenarios and introduce a number of RR-esque
artifacts therefore.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>    due to its design, the CFS scheduler is not prone to any of the
>    'attacks' that exist today against the heuristics of the stock
>    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
>    work fine and do not impact interactivity and produce the expected
>    behavior.

I'm always suspicious of these claims. A moderately formal regression
test suite needs to be assembled and the testcases rather seriously
cleaned up so they e.g. run for a deterministic period of time, have
their parameters passable via command-line options instead of editing
and recompiling, don't need Lindenting to be legible, and so on. With
that in hand, a battery of regression tests can be run against scheduler
modifications to verify their correctness and to detect any disturbance
in scheduling semantics they might cause.

A very serious concern is that while a fresh scheduler may pass all
these tests, later modifications may later cause failures unnoticed
because no one's doing the regression tests and there's no obvious
test suite for testing types to latch onto. Another is that the
testcases themselves may bitrot if they're not maintainable code.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>    the CFS scheduler has a much stronger handling of nice levels and
>    SCHED_BATCH: both types of workloads should be isolated much more
>    agressively than under the vanilla scheduler.

Speaking of regression tests, let's please at least state intended
nice semantics and get a regression test for CPU bandwidth distribution
by nice levels going.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>    ( another rdetail: due to nanosec accounting and timeline sorting,
>      sched_yield() support is very simple under CFS, and in fact under
>      CFS sched_yield() behaves much better than under any other
>      scheduler i have tested so far. )

And there's another one. sched_yield() semantics need a regression test
more transparent than VolanoMark or other macrobenchmarks.

At some point we really need to decide what our sched_yield() is
intended to do and get something out there to detect whether it's
behaving as intended.


On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
>  - reworked/sanitized SMP load-balancing: the runqueue-walking
>    assumptions are gone from the load-balancing code now, and
>    iterators of the scheduling modules are used. The balancing code got
>    quite a bit simpler as a result.

The SMP load balancing class operations strike me as unusual and likely
to trip over semantic issues in alternative scheduling classes. Getting
some alternative scheduling classes out there to clarify the issues
would help here, too.


A more general question here is what you mean by "completely fair;"
there doesn't appear to be inter-tgrp, inter-pgrp, inter-session,
or inter-user fairness going on, though one might argue those are
relatively obscure notions of fairness. Complete fairness arguably
precludes static prioritization by nice levels, so there is also
that. There is also the issue of what a fair CPU bandwidth distribution
between tasks of varying desired in-isolation CPU utilization might be.
I suppose my thorniest point is where the demonstration of fairness is
as, say, a testcase. Perhaps it's fair now; when will we find out when
that fairness has been disturbed?

What these things mean when there are multiple CPU's to schedule across
may also be of concern.

I propose the following two testcases:
(1) CPU bandwidth distribution of CPU-bound tasks of varying nice levels
	Create a number of tasks at varying nice levels. Measure the
	CPU bandwidth allocated to each.
	Success depends on intent: we decide up-front that a given nice
	level should correspond to a given share of CPU bandwidth.
	Check to see how far from the intended distribution of CPU
	bandwidth according to those decided-up-front shares the actual
	distribution of CPU bandwidth is for the test.

(2) CPU bandwidth distribution of tasks with varying CPU demands
	Create a number of tasks that would in isolation consume
	varying %cpu. Measure the CPU bandwidth allocated to each.
	Success depends on intent here, too. Decide up-front that a
	given %cpu that would be consumed in isolation should
	correspond to a given share of CPU bandwidth and check the
	actual distribution of CPU bandwidth vs. what was intended.
	Note that the shares need not linearly correspond to the
	%cpu; various sorts of things related to interactivity will
	make this nonlinear.

A third testcase for sched_yield() should be brewed up.

These testcases are oblivious to SMP. This will demand that a scheduling
policy integrate with load balancing to the extent that load balancing
occurs for the sake of distributing CPU bandwidth according to nice level.
Some explicit decision should be made regarding that.


-- wli
