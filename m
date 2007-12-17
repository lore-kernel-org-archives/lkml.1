Return-Path: <linux-kernel-owner+w=401wt.eu-S964910AbXLQUOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964910AbXLQUOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935675AbXLQTys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:54:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56851 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936198AbXLQTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:54:47 -0500
Date: Mon, 17 Dec 2007 11:54:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <20071214124900.GB31931@elte.hu>
Message-ID: <Pine.LNX.4.64.0712171147580.13147@schroedinger.engr.sgi.com>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
 <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
 <20071208100950.a3547868.akpm@linux-foundation.org>
 <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
 <20071208195211.GA3727@elte.hu> <Pine.LNX.4.64.0712131954440.30721@schroedinger.engr.sgi.com>
 <20071214124900.GB31931@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Ingo Molnar wrote:

> which is of little help if it regresses on other workloads. As we've 
> seen it, SLUB can be more than 10 times slower on hackbench. You can 
> tune SLUB to use 2MB pages but of course that's not a production level 
> system. OTOH, have you tried to tune SLAB in the above benchmark?

Hackbench is one special use case and I was not aware of there being an 
issue there. AFAICT other workloads are fine. I still do not understand 
why the measures in SLUB to avoid lock contention do not take in this 
case. Need to run some more tests.

> > - Single threaded allocation speed is up to double that of SLAB
> 
> link?

Same as link as for the earlier numbers.

> > - Debugging on SLAB is difficult. Requires recompile of the kernel
> >   and the resulting output is difficult to interpret. SLUB can apply
> >   debugging options to a subset of the slabcaches in order to allow
> >   the system to work with maximum speed. This is necessary to detect
> >   difficult to reproduce race conditions.
> 
> that's not a fundamental property of SLAB. It would be an about 10 lines 
> hack to enable SLAB debugging switchable-on runtime, with the boot flag 
> defaulting to 'off'.

Well try it. Note that you need to avoid the runtime debugging result in a 
negative performance impact.
 
> > - SLAB can capture huge amounts of memory in its queues. The problem
> >   gets worse the more processors and NUMA nodes are in the system. The 
> >   amount of memory limits the number of per cpu objects one can 
> >   configure.
> 
> well that's the nature of caches, but it could be improved: restrict 
> alien caches along cpusets and demand-allocate them.

Maybe but that adds additional complexity. There are other issues with 
queues too.

> > - SLAB requires a pass through all slab caches every 2 seconds to
> >   expire objects. This is a problem both for realtime and MPI jobs 
> >   that cannot take such a processor outage.
> 
> the moment you start capturing more memory in SLUB's per cpu queues 
> (which do exist), you will have the same sort of problem.

There are no queues and thus no problem in SLUB. The per cpu slab is 
exactly one slab and cannot grow beyond that.

> > - SLAB requires the update of two words for freeing
> >   and allocation. SLUB can do that by updating a single word which 
> >   allows to avoid enabling and disabling interrupts if the processor 
> >   supports an atomic instruction for that purpose. This is important 
> >   for realtime kernels where special measures may have to be 
> >   implemented if one wants to disable interrupts.
> 
> i do appreciate that :-) SLUB was rather easy to "port" to PREEMPT_RT: 
> it did not need a single line of change. The SLAB portion is a lot 
> scarier:

Finally something positive. I think we can get to a point where SLUB can 
be the same on RT and non RT. 
 
> How about renaming it to SLAB2 instead of SLUB? The "unqueued" bit is 
> just stupid NIH syndrome. It's _of course_ queued because it has to. "It 
> does not have _THAT_ queue as SLAB used to have" is just a silly excuse.

Hmmm yes. At some point I want to remove SLAB and rename SLUB SLAB. Note 
that the queues (if you want to call the per slab page freelist queues) 
are significantly different.

> > - SLUB creates rarely used DMA caches on demand instead of creating
> >   them all on bootup (SLAB).
> 
> actually, this might be a bug. the DMA caches should be created right 
> away and filled with a small amount of objects due to stupid 16MB 
> limitations with certain hardware. Later on a GFP_DMA request might not 
> be fulfillable. (because that zone is filled up pretty quickly)

Use of SLAB DMA memory are exceedingly rare. Andi Kleen has removed 
almost all uses of slab DMA. The DMA must remain allocatable in order to 
allow allocations for legacy device drivers. If it fills up then we will 
have other issues.

