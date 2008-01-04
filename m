Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYADCV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYADCV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYADCVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:21:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60859 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752441AbYADCVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:21:47 -0500
Date: Thu, 3 Jan 2008 18:21:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <1199378818.8274.25.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
 <1199378818.8274.25.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008, Matt Mackall wrote:

> There are three downsides with the slab-like approach: internal
> fragmentation, under-utilized slabs, and pinning.
> 
> The first is the situation where we ask for a kmalloc of 33 bytes and
> get 64. I think the average kmalloc wastes about 30% trying to fit into
> power-of-two buckets. We can tune our buckets a bit, but I think in
> general trying to back kmalloc with slabs is problematic. SLOB has a
> 2-byte granularity up to the point where it just hands things off to the
> page allocator.

The 2 byte overhead of SLOB becomes a liability when it comes to correctly 
aligning power of two sized object. SLOB has to add two bytes and then 
align the combined object (argh!). SLUB can align these without a 2 byte 
overhead. In some configurations this results in SLUB using even less 
memory than SLOB. See f.e. Pekka's test at 
http://marc.info/?l=linux-kernel&m=118405559214029&w=2

> If we tried to add more slabs to fill the gaps, we'd exacerbate the
> second problem: because only one type of object can go on a slab, a lot
> of slabs are half-full. SLUB's automerging of slabs helps some here, but
> is still restricted to objects of the same size.

The advantage of SLOB is to be able to put objects of multiple sizes into 
the same slab page. That advantage goes away once we have more than a few 
objects per slab because SLUB can store object in a denser way than SLOB.
 
> And finally, there's the whole pinning problem: we can have a cache like
> the dcache grow very large and then contract, but still have most of its
> slabs used by pinned dentries. Christoph has some rather hairy patches
> to address this, but SLOB doesn't have much of a problem here - those
> pages are still available to allocate other objects on.

Well if you just have a few dentries then they are likely all pinned. A 
large number of dentries will typically result in reclaimable slabs.
The slab defrag patchset not only deals with the dcache issue but provides 
similar solutions for inode and buffer_heads. Support for other slabs that
defragment can be added by providing two hooks per slab.

 > By comparison, SLOB's big downsides are that it's not O(1) and it has a
> single lock. But it's currently fast enough to keep up with SLUB on
> kernel compiles on my 2G box and Nick had an allocator benchmark where
> scalability didn't fall off until beyond 4 CPUs.

Both SLOB and SLAB suffer from the single lock problem. SLOB does it for 
every item allocated. SLAB does it for every nth item allocated. Given 
a fast allocation from multiple processors both will generate a bouncing 
cacheline. SLUB can take pages from the page allocator pools and allocate 
all objects from it without taking a lock.

> > right now we are far away from it - SLUB has an order of magnitude 
> > larger .o than SLOB, even on UP. I'm wondering why that is so - SLUB's 
> > data structures _are_ quite compact and could in theory be used in a 
> > SLOB-alike way. Perhaps one problem is that much of SLUB's debugging 
> > code is always built in?
> 
> I think we should probably just accept that it makes sense to have more
> than one allocator. A 64MB single CPU machine is very, very different
> than a 64TB 4096-CPU machine. On one of those, it probably makes some
> sense to burn some memory for maximum scalability.

I still have trouble to see that SLOB still has much to offer. An embedded 
allocator that in many cases has more allocation overhead than the default 
one? Ok you still have advantages if allocations are rounded up to the 
next power of two for a kmalloc and because of the combining of different 
types of allocations in a single slab if there are an overall small number 
of allocations. If one would create a custom slab for the worst problems 
there then this may also go away.
