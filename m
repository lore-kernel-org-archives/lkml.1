Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYAJRud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYAJRud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYAJRuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:50:24 -0500
Received: from waste.org ([66.93.16.53]:59017 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663AbYAJRuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:50:23 -0500
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 10 Jan 2008 11:49:25 -0600
Message-Id: <1199987366.5331.92.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 08:13 -0800, Linus Torvalds wrote:
> 
> On Thu, 10 Jan 2008, Pekka J Enberg wrote:
> > 
> > We probably don't have the same version of GCC which perhaps affects 
> > memory layout (struct sizes) and thus allocation patterns?
> 
> No, struct sizes will not change with compiler versions - that would 
> create binary incompatibilities for libraries etc.
> 
> So apart from the kernel itself working around some old gcc bugs by making 
> spinlocks have different size depending on the compiler version, sizes of 
> structures should be the same (as long as the configuration is the same, 
> of course).
> 
> However, a greedy first-fit allocator will be *very* sensitive to 
> allocation pattern differences, so timing will probably make a big 
> difference. In contrast, SLUB and SLAB both use fixed sizes per allocation 
> queue, which makes them almost totally impervious to any allocation 
> pattern from different allocation sizes (they still end up caring about 
> the pattern *within* one size, but those tend to be much stabler).
> 
> There really is a reason why traditional heaps with first-fit are almost 
> never used for any real loads.
> 
> (I'm not a fan of slabs per se - I think all the constructor/destructor 
> crap is just that: total crap - but the size/type binning is a big deal, 
> and I think SLOB was naïve to think a pure first-fit makes any sense. Now 
> you guys are size-binning by just two or three bins, and it seems to make 
> a difference for some loads, but compared to SLUB/SLAB it's a total hack).

Here I'm going to differ with you. The premises of the SLAB concept
(from the original paper) are: 

a) fragmentation of conventional allocators gets worse over time
b) grouping objects of the same -type- (not size) together should mean
they have similar lifetimes and thereby keep fragmentation low
c) slabs can be O(1)
d) constructors and destructors are cache-friendly

There's some truth to (a), but the problem has been quite overstated,
pre-SLAB Linux kernels and countless other systems run for years. And
(b) is known to be false, you just have to look at our dcache and icache
pinning. (c) of course is a whole separate argument and often trumps the
others. And (d) is pretty much crap now too.

And as it happens, SLOB basically always beats SLAB on size.

SLUB only wins when it starts merging caches of different -types- based
on -size-, effectively throwing out the whole (b) concept. Which is
good, because its wrong. So SLUB starts to look a lot like a purely
size-binned allocator.

> I would suggest that if you guys are really serious about memory use, try 
> to do a size-based heap thing, and do best-fit in that heap. Or just some 
> really simple size-based binning, eg
> 
> 	if (size > 2*PAGE_SIZE)
> 		goto page_allocator;

I think both SLOB and SLUB punt everything >= PAGE_SIZE off to the page
allocator.

> 	bin = lookup_bin[(size+31) >> 5]
> 
> or whatever. Because first-fit is *known* to be bad.

It is known to be crummy, but it is NOT known to actually be worse than
the SLAB/SLUB approach when you consider both internal and external
fragmentation. Power-of-two ala SLAB kmalloc basically guarantees your
internal fragmentation will be 30% or so.

In fact, first-fit is known to be pretty good if the ratio of object
size to arena size is reasonable. I've already shown a system booting
with 6% overhead compared to SLUB's 35% (and SLAB's nearly 70%). The
fragmentation measurements for the small object list are in fact quite
nice. Not the best benchmark, but it certainly shows that there's
substantial room for improvement.

Where it hurts is larger objects (task structs, SKBs), which are also a
problem for SLAB/SLUB and I don't think any variation on the search
order is going to help there. If we threw 64k pages at it, those
problems might very well disappear. Hell, it's pretty tempting to throw
vmalloc at it, especially on small boxes..

> At try to change it to address-ordered first-fit or something (which is 
> much more complex than just plain LIFO, but hey, that's life).

Will think about that. Most of the literature here is of limited
usefulness - even Knuth didn't look at 4k heaps, let alone collections
of them.

> I haven't checked much, but I *think* SLOB is just basic first-fit 
> (perhaps the "next-fit" variation?) Next-fit is known to be EVEN WORSE 
> than the simple first-fit when it comes to fragmentation (so no, Knuth was 
> not always right - let's face it, much of Knuth is simply outdated).

The SLOB allocator is inherently two-level. I'm using a next-fit-like
approach to decide which heap (page) to use and first-fit within that
heap.

-- 
Mathematics is the supreme nostalgia of our time.

