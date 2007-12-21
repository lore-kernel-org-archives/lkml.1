Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbXLUWMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbXLUWMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbXLUWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:11:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53484 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754006AbXLUWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:11:54 -0500
Date: Fri, 21 Dec 2007 14:11:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
 <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
 <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Linus Torvalds wrote:

> If you aren't even motivated to fix the problems that have been reported, 
> then SLUB isn't even a _potential_ solution, it's purely a problem, and 
> since I am not IN THE LEAST interested in having three different 
> allocators around, SLUB is going to get axed.

Not motivated? I have analyzed the problem in detail and when it comes 
down to it  there is not much impact that I can see in real life 
applications. I have always responded to the regression reported also via 
TPC-C. There is still no answer to my post at 
http://lkml.org/lkml/2007/10/27/245

SLAB has similar issues when freeing to remote nodes under NUMA. Its 
even worse since the lock is not per slab page but per slab cache. The 
alien caches that are then used have one lock per node.

> In other words, here's the low-down:
> 
>  a) either SLUB can replace SLAB, or SLUB is going away
> 
>     This isn't open for discussion, Christoph. This was the rule back when 
>     it got merged in the first place.

It obviously can replace it and has replaced it for awhile now.

>  b) if SLUB performs worse than SLAB on real loads (TPC-C certainly being 
>     one, and while hackbench may be borderline, it's certainly less 
>     borderline than others), then SLUB cannot replace SLAB.

Looks like I need to find someone to get that going here to be able to 
test under it.

>  c) If you aren't even interested in trying to fix it and are ignoring 
>     the reports, there is not even a _potential_ for SLUB for getting over 
>     these problems, and I should disable it and we should get over it as 
>     soon as possible, and this whole discussion is pretty much ended.

I have looked at this issue under various circumstances for the last week. 
Nothing really convinced me that this is so serious. Could not figure 
out if its really worth anything about but if you put it that way then of 
course it is.
 
> The main reason for SLUB in the first place was SGI concerns. You seem to 
> think that _only_ SGI concerns matter. Wrong. If SLUB remains a SGI-only 
> thing and you don't fix it for other users, then SLUB gets reverted from 
> the standard kernel.

The reason for SLUB was dysfunctional behavior of SLAB in many areas. It 
was not just SGI's concerns that drove it.

> That's all. And it's not really worth discussing. 

Well still SLUB is really superior to SLAB in many ways....

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
  gets worse the more processors and NUMA nodes are in the system.

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
  may have to be implemented.

- SLAB requires memory to be set aside for queues (processors
  times number of slabs times queue size).
  SLUB requires none of that.

- SLUB merges slab caches with similar characteristics to
  reduce the memory footprint even further.

- SLAB performs object level NUMA management which creates
  a complex allocator complexity. SLUB manages NUMA on the level of
  slab pages.

- SLUB allows remote node defragmentation to avoid the buildup
  of large partial lists on a single node.

- SLUB can actively reduce the fragmentation of slabs through
  slab cache specific callbacks (not merged yet)

- SLUB has resiliency features that allow it to isolate a problem
  object and continue after diagnostics have been performed.

- SLUB creates rarely used DMA caches on demand instead of creating
  them all on bootup (SLAB).
