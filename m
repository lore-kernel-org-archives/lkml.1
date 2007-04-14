Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXDNCEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXDNCEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 22:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160999AbXDNCEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 22:04:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:51225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030342AbXDNCEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 22:04:50 -0400
Date: Sat, 14 Apr 2007 04:04:24 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414020424.GB14544@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413202100.GA9957@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> 
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch

Always good to see another contender ;)

> 
> This project is a complete rewrite of the Linux task scheduler. My goal
> is to address various feature requests and to fix deficiencies in the
> vanilla scheduler that were suggested/found in the past few years, both
> for desktop scheduling and for server scheduling workloads.
> 
> [ QuickStart: apply the patch to v2.6.21-rc6, recompile, reboot. The
>   new scheduler will be active by default and all tasks will default
>   to the new SCHED_FAIR interactive scheduling class. ]

I don't know why there is such noise about fairness right now... I
thought fairness was one of the fundamental properties of a good CPU
scheduler, and my scheduler definitely always aims for that above most
other things. Why not just keep SCHED_OTHER?


> Highlights are:
> 
>  - the introduction of Scheduling Classes: an extensible hierarchy of
>    scheduler modules. These modules encapsulate scheduling policy
>    details and are handled by the scheduler core without the core
>    code assuming about them too much.

Don't really like this, but anyway...


>  - sched_fair.c implements the 'CFS desktop scheduler': it is a
>    replacement for the vanilla scheduler's SCHED_OTHER interactivity
>    code.
> 
>    i'd like to give credit to Con Kolivas for the general approach here:
>    he has proven via RSDL/SD that 'fair scheduling' is possible and that
>    it results in better desktop scheduling. Kudos Con!

I guess the 2.4 and earlier scheduler kind of did that as well.


>    The CFS patch uses a completely different approach and implementation
>    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
>    that of RSDL/SD, which is a high standard to meet :-) Testing
>    feedback is welcome to decide this one way or another. [ and, in any
>    case, all of SD's logic could be added via a kernel/sched_sd.c module
>    as well, if Con is interested in such an approach. ]

Comment about the code: shouldn't you be requeueing the task in the rbtree
wherever you change wait_runtime? eg. task_new_fair? (I've only had a quick
look so far).


>    CFS's design is quite radical: it does not use runqueues, it uses a
>    time-ordered rbtree to build a 'timeline' of future task execution,
>    and thus has no 'array switch' artifacts (by which both the vanilla
>    scheduler and RSDL/SD are affected).
> 
>    CFS uses nanosecond granularity accounting and does not rely on any
>    jiffies or other HZ detail. Thus the CFS scheduler has no notion of
>    'timeslices' and has no heuristics whatsoever.

Well, I guess there is still some mechanism to decide which process is most
eligible to run? ;) Considering that question has no "right" answer for
SCHED_OTHER scheduling, I guess you could say it has heuristics. But granted
they are obviously fairly elegant in contrast to the O(1) scheduler ;)


> There is only one
>    central tunable:
> 
>          /proc/sys/kernel/sched_granularity_ns

Suppose you have 2 CPU hogs running, is sched_granularity_ns the
frequency at which they will context switch?


>    ( another rdetail: due to nanosec accounting and timeline sorting,
>      sched_yield() support is very simple under CFS, and in fact under
>      CFS sched_yield() behaves much better than under any other
>      scheduler i have tested so far. )

What is better behaviour for sched_yield?

Thanks,
Nick
