Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXDOP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXDOP0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXDOP0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:26:55 -0400
Received: from holomorphy.com ([66.93.40.71]:60707 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbXDOP0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:26:54 -0400
Date: Sun, 15 Apr 2007 08:26:43 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415152643.GH8915@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415124527.GP943@1wt.eu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 02:45:27PM +0200, Willy Tarreau wrote:
> Now I hope he and Bill will get over this and accept to work on improving
> this scheduler, because I really find it smarter than a dumb O(1). I even
> agree with Mike that we now have a solid basis for future work. But for
> this, maybe a good starting point would be to remove the selfish printk
> at boot, revert useless changes (SCHED_NORMAL->SCHED_FAIR come to mind)
> and improve the documentation a bit so that people can work together on
> the new design, without feeling like their work will only server to
> promote X or Y.

While I appreciate people coming to my defense, or at least the good
intentions behind such, my only actual interest in pointing out
4-year-old work is getting some acknowledgment of having done something
relevant at all. Sometimes it has "I told you so" value. At other times
it's merely clarifying what went on when people refer to it since in a
number of cases the patches are no longer extant, so they can't
actually look at it to get an idea of what was or wasn't done. At other
times I'm miffed about not being credited, whether I should've been or
whether dead and buried code has an implementation of the same idea
resurfacing without the author(s) having any knowledge of my prior work.

One should note that in this case, the first work of mine this trips
over (scheduling classes) was never publicly posted as it was only a
part of the original plugsched (an alternate scheduler implementation
devised to demonstrate plugsched's flexibility with respect to
scheduling policies), and a part that was dropped by subsequent
maintainers. The second work of mine this trips over, a virtual deadline
scheduler named "vdls," was also never publicly posted. Both are from
around the same time period, which makes them approximately 4 years dead.
Neither of the codebases are extant, having been lost in a transition
between employers, though various people recall having been sent them
privately, and plugsched survives in a mutated form as maintained by
Peter Williams, who's been very good about acknowledging my original
contribution.

If I care to become a direct participant in scheduler work, I can do so
easily enough.

I'm not entirely sure what this is about a basis for future work. By
and large one should alter the API's and data structures to fit the
policy being implemented. While the array swapping was nice for
algorithmically improving 2.4.x -style epoch expiry, most algorithms
not based on the 2.4.x scheduler (in however mutated a form) should use
a different queue structure, in fact, one designed around their
policy's specific algorithmic needs. IOW, when one alters the scheduler,
one should also alter the queue data structure appropriately. I'd not
expect the priority queue implementation in cfs to continue to be used
unaltered as it matures, nor would I expect any significant modification
of the scheduler to necessarily use a similar one.

By and large I've been mystified as to why there is such a penchant for
preserving the existing queue structures in the various scheduler
patches floating around. I am now every bit as mystified at the point
of view that seems to be emerging that a change of queue structure is
particularly significant. These are all largely internal changes to
sched.c, and as such, rather small changes in and of themselves. While
they do tend to have user-visible effects, from this point of view
even changing out every line of sched.c is effectively a micropatch.

Something more significant might be altering the schedule() API to
take a mandatory description of the intention of the call to it, or
breaking up schedule() into several different functions to distinguish
between different sorts of uses of it to which one would then respond
differently. Also more significant would be adding a new state beyond
TASK_INTERRUPTIBLE, TASK_UNINTERRUPTIBLE, and TASK_RUNNING for some
tasks to respond only to fatal signals, then sweeping TASK_UNINTERRUPTIBLE
users to use the new state and handle those fatal signals. While not
quite as ostentatious in their user-visible effects as SCHED_OTHER
policy affairs, they are tremendously more work than switching out the
implementation of a single C file, and so somewhat more respectable.

Even as scheduling semantics go, these are micropatches. So SCHED_OTHER
changes a little. Where are the gang schedulers? Where are the batch
schedulers (SCHED_BATCH is not truly such)? Where are the isochronous
(frame) schedulers? I suppose there is some CKRM work that actually has
a semantic impact despite being largely devoted to SCHED_OTHER, and
there's some spufs gang scheduling going on, though not all that much.
And to reiterate a point from other threads, even as SCHED_OTHER
patches go, I see precious little verification that things like the
semantics of nice numbers or other sorts of CPU bandwidth allocation
between competing tasks of various natures are staying the same while
other things are changed, or at least being consciously modified in
such a fashion as to improve them. I've literally only seen one or two
tests (and rather inflexible ones with respect to sleep and running
time mixtures) with any sort of quantification of how CPU bandwidth is
distributed get run on all this.

So from my point of view, there's a lot of churn and craziness going on
in one tiny corner of the kernel and people don't seem to have a very
solid grip on what effects their changes have or how they might
potentially break userspace. So I've developed a sudden interest in
regression testing of the scheduler in order to ensure that various sorts
of semantics on which userspace relies are not broken, and am trying to
spark more interest in general in nailing down scheduling semantics and
verifying that those semantics are honored and remain honored by whatever
future scheduler implementations might be merged.

Thus far, the laundry list of semantics I'd like to have nailed down
are specifically:

(1) CPU bandwidth allocation according to nice numbers
(2) CPU bandwidth allocation among mixtures of tasks with varying
	sleep/wakeup behavior e.g. that consume some percentage of cpu
	in isolation, perhaps also varying the granularity of their
	sleep/wakeup patterns
(3) sched_yield(), so multitier userspace locking doesn't go haywire
(4) How these work with SMP; most people agree it should be mostly the
	same as it works on UP, but it's not being verified, as most
	testcases are barely SMP-aware if at all, and corner cases
	where proportionality breaks down aren't considered

The sorts of like explicit decisions I'd like to be made for these are:
(1) In a mixture of tasks with varying nice numbers, a given nice number
	corresponds to some share of CPU bandwidth. Implementations
	should not have the freedom to change this arbitrarily according
	to some intention.
(2) A given scheduler _implementation_ intends to distribute CPU
	bandwidth among mixtures of tasks that would each consume some
	percentage of the CPU in isolation varying across tasks in some
	particular pattern. For example, maybe some scheduler
	implementation assigns a share of 1/%cpu to a task that would
	consume %cpu in isolation, for a CPU bandwidth allocation of
	(1/%cpu)/(sum 1/%cpu(t)) as t ranges over all competing tasks
	(this is not to say that such a policy makes sense).
(3) sched_yield() is intended to result in some particular scheduling
	pattern in a given scheduler implementation. For instance, an
	implementation may intend that a set of CPU hogs calling
	sched_yield() between repeatedly printf()'ing their pid's will
	see their printf()'s come out in an approximately consistent
	order as the scheduler cycles between them.
(4) What an implementation intends to do with respect to SMP CPU
	bandwidth allocation when precise emulation of UP behavior is
	impossible, considering sched_yield() scheduling patterns when
	possible as well. For instance, perhaps an implementation
	intends to ensure equal CPU bandwidth among competing CPU-bound
	tasks of equal priority at all costs, and so triggers migration
	and/or load balancing to make it so. Or perhaps an implementation
	intends to ensure precise sched_yield() ordering at all costs
	even on SMP. Some sort of specification of the intention, then
	a verification that the intention is carried out in a testcase.

Also, if there's a semantic issue to be resolved, I want it to have
something describing it and verifying it. For instance, characterizing
whatever sort of scheduling artifacts queue-swapping causes in the
mainline scheduler and then a testcase to demonstrate the artifact and
its resolution in a given scheduler rewrite would be a good design
statement and verification. For instance, if someone wants to go back
to queue-swapping or other epoch expiry semantics, it would make them
(and hopefully everyone else) conscious of the semantic issue the
change raises, or possibly serve as a demonstration that the artifacts
can be mitigated in some implementation retaining epoch expiry semantics.

As I become aware of more potential issues I'll add more to my laundry
list, and I'll hammer out testcases as I go. My concern with the
scheduler is that this sort of basic functionality may be significantly
disturbed with no one noticing at all until a distro issues a prerelease
and benchmarks go haywire, and furthermore that changes to this kind of
basic behavior may be signs of things going awry, particularly as more
churn happens.

So now that I've clarified my role in all this to date and my point of
view on it, it should be clear that accepting something and working on
some particular scheduler implementation don't make sense as
suggestions to me.


-- wli
