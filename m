Return-Path: <linux-kernel-owner+w=401wt.eu-S1765790AbXLNEIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765790AbXLNEIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXLNEID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:08:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:42700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185AbXLNEIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:08:01 -0500
Date: Thu, 13 Dec 2007 20:07:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <20071208195211.GA3727@elte.hu>
Message-ID: <Pine.LNX.4.64.0712131954440.30721@schroedinger.engr.sgi.com>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
 <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
 <20071208100950.a3547868.akpm@linux-foundation.org>
 <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
 <20071208195211.GA3727@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Ingo Molnar wrote:

> 
> > Good. Although we should perhaps look at that reported performance 
> > problem with SLUB. It looks like SLUB will do a memclear() for the 
> > area twice (first for the whole page, then for the thing it allocated) 
> > for the slow case. Maybe that exacerbates the problem.
> 
> i dont think the SLUB problem could be explained purely via a double 
> memset(). [which ought to be extremely fast anyway] We are talking about 
> a 10 times slowdown on a 64-way box of a workload that is fairly 
> common-sense. (tasks sending messages to each other via bog standard 
> means)
> 
> while i dont want to jump to conclusions without looking at some 
> profiles, i think the SLUB performance regression is indicative of the 
> following fallacy: "SLAB can be done significantly simpler while keeping 
> the same performance".

Well this is double crap. First of all SLUB does not do memclear twice. 
There is no reason to assume that SLUB has the problem just because SLOB 
hat that. A "fix" for that nonexistent problem went into Linus tree. WTH 
is going on?

SLUB was done because of a series of problem with the basic concepts of 
SLAB that treaten it usability in the future.
 
> I couldnt point to any particular aspect of SLAB that i could 
> characterise as "needless bloat".

I agree, SLABs architecture is pretty tight and I was one of those who 
helped it along to be that way.

However, SLAB is just fundamentally wrong for todays machine. The key 
problem today is cacheline fetch latency and that problem will increase 
significantly in the future. Sure under some circumstances that exploit 
the fact that SLAB sometimes gets its guesses on the cpu cache right SLAB 
can still win but the more processors and nodes we get the more it will 
become difficult to keep SLAB around and the more it will become 
difficult to establish what cachelines are in the cpu cache.

> I think we should we make SLAB the default for v2.6.24 ...

If you guarantee that all the regression of SLAB vs. SLUB are addressed 
then thats fine but AFAICT that is not possible.

Here is a list of some of the benefits of SLUB just in case we forgot:


- SLUB is performance wise much faster than SLAB. This can be more than a
  factor of 10 (case of concurrent allocations / frees on multiple
  processors). See http://lkml.org/lkml/2007/10/27/245

- Single threaded allocation speed is up to double that of SLAB

- Remote freeing of objectcs in a NUMA systems is typically 30% faster.

- Debugging on SLAB is difficult. Requires recompile of the kernel
  and the resulting output is difficult to interpret. SLUB can apply
  debugging options to a subset of the slabcaches in order to allow
  the system to work with maximum speed. This is necessary to detect
  difficult to reproduce race conditions.

- SLAB can capture huge amounts of memory in its queues. The problem
  gets worse the more processors and NUMA nodes are in the system. The 
  amount of memory limits the number of per cpu objects one can configure.

- SLAB requires a pass through all slab caches every 2 seconds to
  expire objects. This is a problem both for realtime and MPI jobs
  that cannot take such a processor outage.

- SLAB does not have a sophisticated slabinfo tool to report the
  state of slab objects on the system. Can provide details of
  object use.

- SLAB requires the update of two words for freeing
  and allocation. SLUB can do that by updating a single
  word which allows to avoid enabling and disabling interrupts if
  the processor supports an atomic instruction for that purpose.
  This is important for realtime kernels where special measures
  may have to be implemented if one wants to disable interrupts.

- SLAB requires memory to be set aside for queues (processors
  times number of slabs times queue size). SLUB requires none of that.

- SLUB merges slab caches with similar characteristics to
  reduce the memory footprint even further.

- SLAB performs object level NUMA management which creates
  a complex allocator complexity. SLUB manages NUMA on the level of
  slab pages reducing object management overhead.

- SLUB allows remote node defragmentation to avoid the buildup
  of large partial lists on a single node.

- SLUB can actively reduce the fragmentation of slabs through
  slab cache specific callbacks (not merged yet)

- SLUB has resiliency features that allow it to isolate a problem
  object and continue after diagnostics have been performed.

- SLUB creates rarely used DMA caches on demand instead of creating
  them all on bootup (SLAB).

