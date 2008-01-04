Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYADVgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYADVgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYADVgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:36:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52552 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753895AbYADVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:36:34 -0500
Date: Fri, 4 Jan 2008 13:36:30 -0800 (PST)
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
In-Reply-To: <1199480150.3821.23.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801041321490.12189@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801041223250.11479@schroedinger.engr.sgi.com>
 <1199480150.3821.23.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Matt Mackall wrote:

> > needs to know the size. So it is not possible in SLOB to use 
> > kmem_cache_alloc on an object and then free it using kfree?
> 
> Indeed. Mismatching allocator and deallocator is bug, even if it happens
> to work for SLAB/SLUB.

Was the kernel audited for this case? I saw some rather scary uses of slab 
objects for I/O purposes come up during SLUB development.

> Yes. You've got (most of) a fix. It's overly-complicated and SLOB
> doesn't need it. How many ways do I need to say this?

So SLOB is then not able to compact memory after an updatedb run? The 
memory must stay dedicated to slab uses. SLOB memory can be filled 
up with objects of other slab types but it cannot be reused for page 
cache and anonymous pages etc. Slab defrag is freeing memory back to the 
page allocator with SLUB. That is *not* provided by SLOB. Could be made to 
work though.

> > Well that increase if you need to align the object. For kmalloc this 
> > usually means cache line align a power of two object right? So we have a 
> > cacheline size of overhead?
> 
> a) alignment doesn't increase memory use because the memory before the
> object is still allocatable

Ok so we end up with lots of small holes on a list that has to be scanned 
to find free memory?

> b) kmallocs aren't aligned!

>From mm/slob.c:

#ifndef ARCH_KMALLOC_MINALIGN
#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
#endif

void *__kmalloc_node(size_t size, gfp_t gfp, int node)
{
        unsigned int *m;
        int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);

(IMHO it would be safer to set the minimum default to __alignof__(unsigned 
long long) like SLAB/SLUB).



Ok. So lets try a worst case scenario. If we do a 128 byte kmalloc then we 
can allocate the following number of object from one 4k slab

SLUB 32	    (all memory of the 4k page is used for 128 byte objects)
SLAB 29/30  (management structure occupies first two/three objects)
SLOB 30(?)  (Alignment results in object being 136 byte of effective size,
		we have 16 bytes leftover that could be used for a
		very small allocation. Right?)
