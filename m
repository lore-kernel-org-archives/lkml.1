Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXLNMtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXLNMtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXLNMtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:49:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41068 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXLNMtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:49:31 -0500
Date: Fri, 14 Dec 2007 13:49:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071214124900.GB31931@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org> <20071208195211.GA3727@elte.hu> <Pine.LNX.4.64.0712131954440.30721@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712131954440.30721@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> > I think we should we make SLAB the default for v2.6.24 ...
> 
> If you guarantee that all the regression of SLAB vs. SLUB are 
> addressed then thats fine but AFAICT that is not possible.

huh? You got the ordering wrong ;-) SLUB needs to resolve all 
regressions relative to SLAB. (or at least have a really good 
explanation about why it regresses)

> Here is a list of some of the benefits of SLUB just in case we forgot:
> 
> - SLUB is performance wise much faster than SLAB. This can be more than a
>   factor of 10 (case of concurrent allocations / frees on multiple
>   processors). See http://lkml.org/lkml/2007/10/27/245

which is of little help if it regresses on other workloads. As we've 
seen it, SLUB can be more than 10 times slower on hackbench. You can 
tune SLUB to use 2MB pages but of course that's not a production level 
system. OTOH, have you tried to tune SLAB in the above benchmark?

> - Single threaded allocation speed is up to double that of SLAB

link?

> - Remote freeing of objectcs in a NUMA systems is typically 30% faster.
> 
> - Debugging on SLAB is difficult. Requires recompile of the kernel
>   and the resulting output is difficult to interpret. SLUB can apply
>   debugging options to a subset of the slabcaches in order to allow
>   the system to work with maximum speed. This is necessary to detect
>   difficult to reproduce race conditions.

that's not a fundamental property of SLAB. It would be an about 10 lines 
hack to enable SLAB debugging switchable-on runtime, with the boot flag 
defaulting to 'off'.

> - SLAB can capture huge amounts of memory in its queues. The problem
>   gets worse the more processors and NUMA nodes are in the system. The 
>   amount of memory limits the number of per cpu objects one can 
>   configure.

well that's the nature of caches, but it could be improved: restrict 
alien caches along cpusets and demand-allocate them.

> - SLAB requires a pass through all slab caches every 2 seconds to
>   expire objects. This is a problem both for realtime and MPI jobs 
>   that cannot take such a processor outage.

the moment you start capturing more memory in SLUB's per cpu queues 
(which do exist), you will have the same sort of problem.

> - SLAB does not have a sophisticated slabinfo tool to report the
>   state of slab objects on the system. Can provide details of object 
>   use.

again, not a fundamental property of SLAB.

> - SLAB requires the update of two words for freeing
>   and allocation. SLUB can do that by updating a single word which 
>   allows to avoid enabling and disabling interrupts if the processor 
>   supports an atomic instruction for that purpose. This is important 
>   for realtime kernels where special measures may have to be 
>   implemented if one wants to disable interrupts.

i do appreciate that :-) SLUB was rather easy to "port" to PREEMPT_RT: 
it did not need a single line of change. The SLAB portion is a lot 
scarier:

  dione:~linux-rt.q> diffstat patches/rt-slab-new.patch
    1 file changed, 319 insertions(+), 177 deletions(-)

> - SLAB requires memory to be set aside for queues (processors
>   times number of slabs times queue size). SLUB requires none of that.
>
> - SLUB merges slab caches with similar characteristics to
>   reduce the memory footprint even further.
> 
> - SLAB performs object level NUMA management which creates
>   a complex allocator complexity. SLUB manages NUMA on the level of 
>   slab pages reducing object management overhead.
> 
> - SLUB allows remote node defragmentation to avoid the buildup
>   of large partial lists on a single node.
> 
> - SLUB can actively reduce the fragmentation of slabs through
>   slab cache specific callbacks (not merged yet)
> 
> - SLUB has resiliency features that allow it to isolate a problem
>   object and continue after diagnostics have been performed.

all of these are neat.

How about renaming it to SLAB2 instead of SLUB? The "unqueued" bit is 
just stupid NIH syndrome. It's _of course_ queued because it has to. "It 
does not have _THAT_ queue as SLAB used to have" is just a silly excuse.

> - SLUB creates rarely used DMA caches on demand instead of creating
>   them all on bootup (SLAB).

actually, this might be a bug. the DMA caches should be created right 
away and filled with a small amount of objects due to stupid 16MB 
limitations with certain hardware. Later on a GFP_DMA request might not 
be fulfillable. (because that zone is filled up pretty quickly)

	Ingo
