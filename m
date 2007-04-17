Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXDQH4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXDQH4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXDQH4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:56:33 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4564 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXDQH4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:56:32 -0400
Message-ID: <46247DAB.1060808@shadowen.org>
Date: Tue, 17 Apr 2007 08:56:27 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> 
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> 
> This project is a complete rewrite of the Linux task scheduler. My goal
> is to address various feature requests and to fix deficiencies in the
> vanilla scheduler that were suggested/found in the past few years, both
> for desktop scheduling and for server scheduling workloads.
> 
> [ QuickStart: apply the patch to v2.6.21-rc6, recompile, reboot. The
>   new scheduler will be active by default and all tasks will default
>   to the new SCHED_FAIR interactive scheduling class. ]
> 
> Highlights are:
> 
>  - the introduction of Scheduling Classes: an extensible hierarchy of
>    scheduler modules. These modules encapsulate scheduling policy
>    details and are handled by the scheduler core without the core
>    code assuming about them too much.
> 
>  - sched_fair.c implements the 'CFS desktop scheduler': it is a
>    replacement for the vanilla scheduler's SCHED_OTHER interactivity
>    code.
> 
>    i'd like to give credit to Con Kolivas for the general approach here:
>    he has proven via RSDL/SD that 'fair scheduling' is possible and that
>    it results in better desktop scheduling. Kudos Con!
> 
>    The CFS patch uses a completely different approach and implementation
>    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
>    that of RSDL/SD, which is a high standard to meet :-) Testing
>    feedback is welcome to decide this one way or another. [ and, in any
>    case, all of SD's logic could be added via a kernel/sched_sd.c module
>    as well, if Con is interested in such an approach. ]
> 
>    CFS's design is quite radical: it does not use runqueues, it uses a
>    time-ordered rbtree to build a 'timeline' of future task execution,
>    and thus has no 'array switch' artifacts (by which both the vanilla
>    scheduler and RSDL/SD are affected).
> 
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
> 
>    due to its design, the CFS scheduler is not prone to any of the
>    'attacks' that exist today against the heuristics of the stock
>    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
>    work fine and do not impact interactivity and produce the expected
>    behavior.
> 
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
> 
> the core scheduler got smaller by more than 700 lines:
> 
>  kernel/sched.c | 1454 ++++++++++++++++------------------------------------------------
>  1 file changed, 372 insertions(+), 1082 deletions(-)
> 
> and even adding all the scheduling modules, the total size impact is
> relatively small:
> 
>  18 files changed, 1454 insertions(+), 1133 deletions(-)
> 
> most of the increase is due to extensive comments. The kernel size
> impact is in fact a small negative:
> 
>    text    data     bss     dec     hex filename
>   23366    4001      24   27391    6aff kernel/sched.o.vanilla
>   24159    2705      56   26920    6928 kernel/sched.o.CFS
> 
> (this is mainly due to the benefit of getting rid of the expired array
> and its data structure overhead.)
> 
> thanks go to Thomas Gleixner and Arjan van de Ven for review of this
> patchset.
> 
> as usual, any sort of feedback, bugreports, fixes and suggestions are
> more than welcome,

Pushed this through the test.kernel.org and nothing new blew up.
Notably the kernbench figures are within expectations even on the bigger
numa systems, commonly badly affected by balancing problems in the
schedular.

I see there is a second one out, I'll push that one through too.

-apw
