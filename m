Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXDMWwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXDMWwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXDMWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:52:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbXDMWwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:52:34 -0400
Date: Sat, 14 Apr 2007 00:52:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413225216.GA11384@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413222151.GD8915@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* William Lee Irwin III <wli@holomorphy.com> wrote:

> On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> > [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> > i'm pleased to announce the first release of the "Modular Scheduler Core
> > and Completely Fair Scheduler [CFS]" patchset:
> >    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> > This project is a complete rewrite of the Linux task scheduler. My goal
> > is to address various feature requests and to fix deficiencies in the
> > vanilla scheduler that were suggested/found in the past few years, both
> > for desktop scheduling and for server scheduling workloads.
> > [ QuickStart: apply the patch to v2.6.21-rc6, recompile, reboot. The
> >   new scheduler will be active by default and all tasks will default
> >   to the new SCHED_FAIR interactive scheduling class. ]
> 
> A pleasant surprise, though I did see it coming.

hey ;)

> On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> > Highlights are:
> >  - the introduction of Scheduling Classes: an extensible hierarchy of
> >    scheduler modules. These modules encapsulate scheduling policy
> >    details and are handled by the scheduler core without the core
> >    code assuming about them too much.
> 
> It probably needs further clarification that they're things on the 
> order of SCHED_FIFO, SCHED_RR, SCHED_NORMAL, etc.; some prioritization 
> amongst the classes is furthermore assumed, and so on. [...]

yep - they are linked via sched_ops->next pointer, with NULL delimiting 
the last one.

> [...] They're not quite capable of being full-blown alternative 
> policies, though quite a bit can be crammed into them.

yeah, they are not full-blown: i extended them on-demand, for the 
specific purposes of sched_fair.c and sched_rt.c. More can be done too.

> There are issues with the per- scheduling class data not being very 
> well-abstracted. [...]

yes. It's on my TODO list: i'll work more on extending the cleanups to 
those fields too.

> A binomial heap would likely serve your purposes better than rbtrees. 
> It's faster to have the next item to dequeue at the root of the tree 
> structure rather than a leaf, for one. There are, of course, other 
> priority queue structures (e.g. van Emde Boas) able to exploit the 
> limited precision of the priority key for faster asymptotics, though 
> actual performance is an open question.

i'm caching the leftmost leaf, which serves as an alternate, task-pick 
centric root in essence.

> Another advantage of heaps is that they support decreasing priorities 
> directly, so that instead of removal and reinsertion, a less invasive 
> movement within the tree is possible. This nets additional constant 
> factor improvements beyond those for the next item to dequeue for the 
> case where a task remains runnable, but is preempted and its priority 
> decreased while it remains runnable.

yeah. (Note that in CFS i'm not decreasing priorities anywhere though - 
all the priority levels in CFS stay constant, fairness is not achieved 
via rotating priorities or similar, it is achieved via the accounting 
code.)

> On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> >    due to its design, the CFS scheduler is not prone to any of the
> >    'attacks' that exist today against the heuristics of the stock
> >    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
> >    work fine and do not impact interactivity and produce the expected
> >    behavior.
> 
> I'm always suspicious of these claims.  [...]

hey, sure - but please give it a go nevertheless, i _did_ test all these 
;)

> A moderately formal regression test suite needs to be assembled [...]

by all means feel free! ;)

> A more general question here is what you mean by "completely fair;"

by that i mean the most common-sense definition: with N tasks running 
each gets 1/N CPU time if observed for a reasonable amount of time. Now 
extend this to arbitrary scheduling patterns, the end result should 
still be completely fair, according to the fundamental 1/N(time) rule 
individually applied to all the small scheduling patterns that the 
scheduling patterns give. (this assumes that the scheduling patterns are 
reasonably independent of each other - if they are not then there's no 
reasonable definition of fairness that makes sense, and we might as well 
use the 1/N rule for those cases too.)

> there doesn't appear to be inter-tgrp, inter-pgrp, inter-session, or 
> inter-user fairness going on, though one might argue those are 
> relatively obscure notions of fairness. [...]

sure, i mainly concentrated on what we have in Linux today. The things 
you mention are add-ons that i can see handling via new scheduling 
classes: all the CKRM and containers type of CPU time management 
facilities.

> What these things mean when there are multiple CPU's to schedule 
> across may also be of concern.

that is handled by the existing smp-nice load balancer, that logic is 
preserved under CFS.

> These testcases are oblivious to SMP. This will demand that a 
> scheduling policy integrate with load balancing to the extent that 
> load balancing occurs for the sake of distributing CPU bandwidth 
> according to nice level. Some explicit decision should be made 
> regarding that.

this should already work reasonably fine with CFS: try massive_intr.c on 
an SMP box.

	Ingo
