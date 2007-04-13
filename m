Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXDMXai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXDMXai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161257AbXDMXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:30:37 -0400
Received: from holomorphy.com ([66.93.40.71]:44359 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161235AbXDMXaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:35 -0400
Date: Fri, 13 Apr 2007 16:30:49 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413233049.GW2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com> <20070413225216.GA11384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413225216.GA11384@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> A binomial heap would likely serve your purposes better than rbtrees. 
>> It's faster to have the next item to dequeue at the root of the tree 
>> structure rather than a leaf, for one. There are, of course, other 
>> priority queue structures (e.g. van Emde Boas) able to exploit the 
>> limited precision of the priority key for faster asymptotics, though 
>> actual performance is an open question.

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> i'm caching the leftmost leaf, which serves as an alternate, task-pick 
> centric root in essence.

I noticed that, yes. It seemed a better idea to me to use a data
structure that has what's needed built-in, but I suppose it's not gospel.


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Another advantage of heaps is that they support decreasing priorities 
>> directly, so that instead of removal and reinsertion, a less invasive 
>> movement within the tree is possible. This nets additional constant 
>> factor improvements beyond those for the next item to dequeue for the 
>> case where a task remains runnable, but is preempted and its priority 
>> decreased while it remains runnable.

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> yeah. (Note that in CFS i'm not decreasing priorities anywhere though - 
> all the priority levels in CFS stay constant, fairness is not achieved 
> via rotating priorities or similar, it is achieved via the accounting 
> code.)

Sorry, "priority" here would be from the POV of the queue data
structure. From the POV of the scheduler it would be resetting the
deadline or whatever the nomenclature cooked up for things is, most
obviously in requeue_task_fair() and task_tick_fair().


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> I'm always suspicious of these claims.  [...]

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> hey, sure - but please give it a go nevertheless, i _did_ test all these 
> ;)

The suspicion essentially centers around how long the state of affairs
will hold up because comprehensive re-testing is not noticeably done
upon updates to scheduling code or kernel point releases.


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> A moderately formal regression test suite needs to be assembled [...]

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> by all means feel free! ;)

I can only do so much, but I have done work to clean up other testcases
going around. I'm mostly looking at testcases as I go over them or
develop some interest in the subject and rewriting those that already
exist or hammering out new ones as I need them. The main contribution
toward this is that I've sort of made a mental note to stash the results
of the effort somewhere and pass them along to those who do regular
testing on kernels or otherwise import test suites into their collections.


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> A more general question here is what you mean by "completely fair;"

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> by that i mean the most common-sense definition: with N tasks running 
> each gets 1/N CPU time if observed for a reasonable amount of time. Now 
> extend this to arbitrary scheduling patterns, the end result should 
> still be completely fair, according to the fundamental 1/N(time) rule 
> individually applied to all the small scheduling patterns that the 
> scheduling patterns give. (this assumes that the scheduling patterns are 
> reasonably independent of each other - if they are not then there's no 
> reasonable definition of fairness that makes sense, and we might as well 
> use the 1/N rule for those cases too.)

I'd start with identically-behaving CPU-bound tasks here. It's easy
enough to hammer out a testcase that starts up N CPU-bound tasks, runs
them for a few minutes, stops them, collects statistics on their
runtime, and gives us an idea of whether 1/N came out properly. I'll
get around to that at some point.

Where it gets complex is when the behavior patterns vary, e.g. they're
not entirely CPU-bound and their desired in-isolation CPU utilization
varies, or when nice levels vary, or both vary. I went on about
testcases for those in particular in the prior post, though not both
at once. The nice level one in particular needs an up-front goal for
distribution of CPU bandwidth in a mixture of competing tasks with
varying nice levels.

There are different ways to define fairness, but a uniform distribution
of CPU bandwidth across a set of identical competing tasks is a good,
testable definition.


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> there doesn't appear to be inter-tgrp, inter-pgrp, inter-session, or 
>> inter-user fairness going on, though one might argue those are 
>> relatively obscure notions of fairness. [...]

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> sure, i mainly concentrated on what we have in Linux today. The things 
> you mention are add-ons that i can see handling via new scheduling 
> classes: all the CKRM and containers type of CPU time management 
> facilities.

At some point the CKRM and container people should be pinged to see
what (if anything) they need to achieve these sorts of things. It's
not clear to me that the specific cases I cited are considered
relevant to anyone. I presume that if they are, someone will pipe
up with a feature request. It was more a sort of catalogue of different
notions of fairness that could arise than any sort of suggestion.


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> What these things mean when there are multiple CPU's to schedule 
>> across may also be of concern.

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> that is handled by the existing smp-nice load balancer, that logic is 
> preserved under CFS.

Given the things going wrong, I'm curious as to whether that works, and
if so, how well. I'll drop that into my list of testcases that should be
arranged for, though I won't guarantee that I'll get to it myself in any
sort of timely fashion.

What this ultimately needs is specifying the semantics of nice levels
so that we can say that a mixture of competing tasks with varying nice
levels should have an ideal distribution of CPU bandwidth to check for.


* William Lee Irwin III <wli@holomorphy.com> wrote:
>> These testcases are oblivious to SMP. This will demand that a 
>> scheduling policy integrate with load balancing to the extent that 
>> load balancing occurs for the sake of distributing CPU bandwidth 
>> according to nice level. Some explicit decision should be made 
>> regarding that.

On Sat, Apr 14, 2007 at 12:52:16AM +0200, Ingo Molnar wrote:
> this should already work reasonably fine with CFS: try massive_intr.c on 
> an SMP box.

Where is massive_intr.c, BTW?


-- wli
