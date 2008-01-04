Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYADU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYADU5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYADU5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:57:06 -0500
Received: from waste.org ([66.93.16.53]:56477 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbYADU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:57:04 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801041223250.11479@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801041223250.11479@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 04 Jan 2008 14:55:50 -0600
Message-Id: <1199480150.3821.23.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-04 at 12:34 -0800, Christoph Lameter wrote:
> On Thu, 3 Jan 2008, Matt Mackall wrote:
> 
> > > The advantage of SLOB is to be able to put objects of multiple sizes into 
> > > the same slab page. That advantage goes away once we have more than a few 
> > > objects per slab because SLUB can store object in a denser way than SLOB.
> > 
> > Ugh, Christoph. Can you please stop repeating this falsehood? I'm sick
> > and tired of debunking it. There is no overhead for any objects with
> > externally-known size. So unless SLUB actually has negative overhead,
> > this just isn't true.
> 
> Hmmm.. Seems that I still do not understand how it is possible then to mix 
> objects of different sizes in the same slab page. Somehow the allocator 
> needs to know the size. So it is not possible in SLOB to use 
> kmem_cache_alloc on an object and then free it using kfree?

Indeed. Mismatching allocator and deallocator is bug, even if it happens
to work for SLAB/SLUB.

> > > Well if you just have a few dentries then they are likely all pinned. A 
> > > large number of dentries will typically result in reclaimable slabs.
> > > The slab defrag patchset not only deals with the dcache issue but provides 
> > > similar solutions for inode and buffer_heads. Support for other slabs that
> > > defragment can be added by providing two hooks per slab.
> > 
> > What's your point? Slabs have a inherent pinning problem that's ugly to
> > combat. SLOB doesn't.
> 
> I thought we were talking about pinning problems of dentries. How are 
> slabs pinned and why does it matter?

If a slab contains a dentry that is pinned, it can only be used for
other dentries and cannot be recycled for other allocations. If updatedb
comes along and fills memory with dentry slabs, many of which get
permanently pinned, then you have wasted memory.

>  If slabs are pineed by a dentry that 
> is pinned then the slab page will be filled up with other dentries that 
> are not pinned. The slab defrag approach causes a coalescing of objects 
> around slabs that have pinned objects.

Yes. You've got (most of) a fix. It's overly-complicated and SLOB
doesn't need it. How many ways do I need to say this?


> > SLOB:
> > - internal overhead for kmalloc is 2 bytes (or 3 for odd-sized objects)
> 
> Well that increase if you need to align the object. For kmalloc this 
> usually means cache line align a power of two object right? So we have a 
> cacheline size of overhead?

a) alignment doesn't increase memory use because the memory before the
object is still allocatable
b) kmallocs aren't aligned!

> > - internal overhead for kmem_cache_alloc is 0 bytes (or 1 for odd-sized
> > objects)
> 
> You are not aligning to a double word boundary? This will create issues on 
> certain platforms.

The alignment minimum varies per arch. SLOB can go down to 2 bytes.

> > SLAB/SLUB
> > - internal overhead for kmalloc averages about 30%
> 
> I think that is valid for a random object size distribution?

It's a measurement from memory. But it roughly agrees with what you'd
expect from a random distribution.

> > The only time SLAB/SLUB can win in efficiency (assuming they're using
> > the same page size) is when all your kmallocs just happen to be powers
> > of two. Which, assuming any likely distribution of string or other
> > object sizes, isn't often.
> 
> In case of SLAB that is true. In case of SLUB we could convert the 
> kmallocs to kmem_cache_alloc. The newly created slab would in all 
> likelyhood be an alias of an already existing structure and thus be 
> essentially free. In that fashion SLUB can (in a limited way) put objects 
> for different slab caches into the same slab page too.

Uh, no. You'd need a new slab for every multiple of 2 bytes. And then
you'd just be making the underused and pinned slab problems worse.

-- 
Mathematics is the supreme nostalgia of our time.

