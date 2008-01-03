Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYACQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYACQsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYACQse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:48:34 -0500
Received: from waste.org ([66.93.16.53]:56461 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYACQsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:48:33 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080103085239.GA10813@elte.hu>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 10:46:58 -0600
Message-Id: <1199378818.8274.25.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 09:52 +0100, Ingo Molnar wrote:
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > Which means that SLOB could also trivially implement the same thing, 
> > > with no new #ifdef'fery or other crud.
> > 
> > Except SLOB's emulation of slabs is so thin, it doesn't have the 
> > relevant information. We have a very small struct kmem_cache, which I 
> > suppose could contain a counter. But we don't have anything like the 
> > kmalloc slabs, so you'd only be getting half the picture anyway. The 
> > output of slabtop would simply be misleading because there are no 
> > underlying "slabs" in the first place.
> 
> i think SLOB/embedded is sufficiently special that a "no /proc/slabinfo" 
> restriction is perfectly supportable. (for instance it's only selectable 
> if CONFIG_EMBEDDED=y) If a SLOB user has any memory allocation problems 
> it's worth going to the bigger allocators anyway, to get all the 
> debugging goodies.
> 
> btw., do you think it would be worth/possible to have build mode for 
> SLUB that is acceptably close to the memory efficiency of SLOB? (and 
> hence work towards unifying all the 3 allocators into SLUB in essence)

There are three downsides with the slab-like approach: internal
fragmentation, under-utilized slabs, and pinning.

The first is the situation where we ask for a kmalloc of 33 bytes and
get 64. I think the average kmalloc wastes about 30% trying to fit into
power-of-two buckets. We can tune our buckets a bit, but I think in
general trying to back kmalloc with slabs is problematic. SLOB has a
2-byte granularity up to the point where it just hands things off to the
page allocator.

If we tried to add more slabs to fill the gaps, we'd exacerbate the
second problem: because only one type of object can go on a slab, a lot
of slabs are half-full. SLUB's automerging of slabs helps some here, but
is still restricted to objects of the same size.

And finally, there's the whole pinning problem: we can have a cache like
the dcache grow very large and then contract, but still have most of its
slabs used by pinned dentries. Christoph has some rather hairy patches
to address this, but SLOB doesn't have much of a problem here - those
pages are still available to allocate other objects on.

By comparison, SLOB's big downsides are that it's not O(1) and it has a
single lock. But it's currently fast enough to keep up with SLUB on
kernel compiles on my 2G box and Nick had an allocator benchmark where
scalability didn't fall off until beyond 4 CPUs.

> right now we are far away from it - SLUB has an order of magnitude 
> larger .o than SLOB, even on UP. I'm wondering why that is so - SLUB's 
> data structures _are_ quite compact and could in theory be used in a 
> SLOB-alike way. Perhaps one problem is that much of SLUB's debugging 
> code is always built in?

I think we should probably just accept that it makes sense to have more
than one allocator. A 64MB single CPU machine is very, very different
than a 64TB 4096-CPU machine. On one of those, it probably makes some
sense to burn some memory for maximum scalability.

-- 
Mathematics is the supreme nostalgia of our time.

