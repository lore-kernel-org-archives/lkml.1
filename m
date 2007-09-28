Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbXI1VFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbXI1VFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXI1VFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:05:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36590 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbXI1VF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:05:29 -0400
Date: Fri, 28 Sep 2007 22:05:27 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-ID: <20070928210527.GB30404@skynet.ie>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (28/09/07 10:33), Christoph Lameter didst pronounce:
> On Fri, 28 Sep 2007, Nick Piggin wrote:
> 
> > On Wednesday 19 September 2007 13:36, Christoph Lameter wrote:
> > > SLAB_VFALLBACK can be specified for selected slab caches. If fallback is
> > > available then the conservative settings for higher order allocations are
> > > overridden. We then request an order that can accomodate at mininum
> > > 100 objects. The size of an individual slab allocation is allowed to reach
> > > up to 256k (order 6 on i386, order 4 on IA64).
> > 
> > How come SLUB wants such a big amount of objects? I thought the
> > unqueued nature of it made it better than slab because it minimised
> > the amount of cache hot memory lying around in slabs...
> 
> The more objects in a page the more the fast path runs. The more the fast 
> path runs the lower the cache footprint and the faster the overall 
> allocations etc.
> 
> SLAB can be configured for large queues holdings lots of objects. 
> SLUB can only reach the same through large pages because it does not 
> have queues.

Large pages, flood gates etc. Be wary.

SLUB has to run 100% reliable or things go whoops. SLUB regularly depends on
atomic allocations and cannot take the necessary steps to get the contiguous
pages if it gets into trouble. This means that something like lumpy reclaim
cannot help you in it's current state.

We currently do not take the per-emptive steps with kswapd to ensure the
high-order pages are free. We also don't do something like have users that
can sleep keep the watermarks high. I had considered the possibility but
didn't have the justification for the complexity.

Minimally, SLUB by default should continue to use order-0 pages. Peter has
managed to bust order-1 pages with mem=128MB. Admittedly, it was a really
hostile workload but the point remains. It was artifically worked around
with min_free_kbytes (value set based on pageblock_order, could also have
been artifically worked around by dropping pageblock_order) and he eventually
caused order-0 failures so the workload is pretty damn hostile to everything.

> One could add the ability to manage pools of cpu slabs but 
> that would be adding yet another layer to compensate for the problem of 
> the small pages.

A compromise may be to have per-cpu lists for higher-order pages in the page
allocator itself as they can be easily drained unlike the SLAB queues. The
thing to watch for would be excessive IPI calls which would offset any
performance gained by SLUB using larger pages.

> Reliable large page allocations means that we can get rid 
> of these layers and the many workarounds that we have in place right now.
> 

They are not reliable yet, particularly for atomic allocs.

> The unqueued nature of SLUB reduces memory requirements and in general the 
> more efficient code paths of SLUB offset the advantage that SLAB can reach 
> by being able to put more objects onto its queues. SLAB necessarily 
> introduces complexity and cache line use through the need to manage those 
> queues.
> 
> > vmalloc is incredibly slow and unscalable at the moment. I'm still working
> > on making it more scalable and faster -- hopefully to a point where it would
> > actually be usable for this... but you still get moved off large TLBs, and
> > also have to inevitably do tlb flushing.
> 
> Again I have not seen any fallbacks to vmalloc in my testing. What we are 
> doing here is mainly to address your theoretical cases that we so far have 
> never seen to be a problem and increase the reliability of allocations of
> page orders larger than 3 to a usable level. So far I have so far not 
> dared to enable orders larger than 3 by default.
> 
> AFAICT The performance of vmalloc is not really relevant. If this would 
> become an issue then it would be possible to reduce the orders used to 
> avoid fallbacks.
> 

If we're falling back to vmalloc ever, there is a danger that the
problem is postponed until vmalloc space is consumed. More an issue for
32 bit.

> > Or do you have SLUB at a point where performance is comparable to SLAB,
> > and this is just a possible idea for more performance?
> 
> AFAICT SLUBs performance is superior to SLAB in most cases and it was like 
> that from the beginning. I am still concerned about several corner cases 
> though (I think most of them are going to be addressed by the per cpu 
> patches in mm). Having a comparable or larger amount of per cpu objects as 
> SLAB is something that also could address some of these concerns and could 
> increase performance much further.
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
