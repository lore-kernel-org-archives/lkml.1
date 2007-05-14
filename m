Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbXENT3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbXENT3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXENT2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:28:47 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:3338 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755753AbXENT2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:28:46 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
	 <20070514161224.GC11115@waste.org>
	 <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
	 <1179164453.2942.26.camel@lappy>
	 <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 21:28:32 +0200
Message-Id: <1179170912.2942.37.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 10:57 -0700, Christoph Lameter wrote:
> On Mon, 14 May 2007, Peter Zijlstra wrote:
> 
> > On Mon, 2007-05-14 at 09:29 -0700, Christoph Lameter wrote:
> > > On Mon, 14 May 2007, Matt Mackall wrote:
> > > 
> > > > privileged thread                      unprivileged greedy process
> > > > kmem_cache_alloc(...)
> > > >    adds new slab page from lowmem pool
> > > 
> > > Yes but it returns an object for the privileged thread. Is that not 
> > > enough?
> > 
> > No, because we reserved memory for n objects, and like matt illustrates
> > most of those that will be eaten by the greedy process.
> > We could reserve 1 page per object but that rather bloats the reserve.
> 
> 1 slab per object not one page. But yes thats some bloat.
> 
> You can pull the big switch (only on a SLUB slab I fear) to switch 
> off the fast path. Do SetSlabDebug() when allocating a precious 
> allocation that should not be gobbled up by lower level processes. 
> Then you can do whatever you want in the __slab_alloc debug section and we 
> wont care because its not the hot path.

One allocator is all I need; it would just be grand if all could be
supported.

So what you suggest is not placing the 'emergency' slab into the regular
place so that normal allocations will not be able to find it. Then if an
emergency allocation cannot be satified by the regular path, we fall
back to the slow path and find the emergency slab.

> SLAB is a bit different. There we already have issues with the fast path 
> due to the attempt to handle numa policies at the object level. SLUB fixes 
> that issue (if we can avoid you hot path patch). It intentionally does 
> defer all special object handling to the slab level to increase NUMA 
> performance. If you do the same to SLAB then you will get the NUMA 
> troubles propagated to the SMP and UP level.

I could hack in a similar reserve slab; by catching the failure of the
regular allocation path. It'd not make it prettier though.

The thing is; I'm not needing any speed, as long as the machine stay
alive I'm good. However others are planing to build a full reserve based
allocator to properly fix the places that now use __GFP_NOFAIL and
situation such as in add_to_swap().

A well, one thing at a time. I'll hack this up.

