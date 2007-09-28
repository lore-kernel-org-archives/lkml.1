Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXI1Rdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXI1Rdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXI1Rd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:33:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55390 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753401AbXI1Rd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:33:28 -0400
Date: Fri, 28 Sep 2007 10:33:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <200709280742.38262.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com>
 <200709280742.38262.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Nick Piggin wrote:

> On Wednesday 19 September 2007 13:36, Christoph Lameter wrote:
> > SLAB_VFALLBACK can be specified for selected slab caches. If fallback is
> > available then the conservative settings for higher order allocations are
> > overridden. We then request an order that can accomodate at mininum
> > 100 objects. The size of an individual slab allocation is allowed to reach
> > up to 256k (order 6 on i386, order 4 on IA64).
> 
> How come SLUB wants such a big amount of objects? I thought the
> unqueued nature of it made it better than slab because it minimised
> the amount of cache hot memory lying around in slabs...

The more objects in a page the more the fast path runs. The more the fast 
path runs the lower the cache footprint and the faster the overall 
allocations etc.

SLAB can be configured for large queues holdings lots of objects. 
SLUB can only reach the same through large pages because it does not 
have queues. One could add the ability to manage pools of cpu slabs but 
that would be adding yet another layer to compensate for the problem of 
the small pages. Reliable large page allocations means that we can get rid 
of these layers and the many workarounds that we have in place right now.

The unqueued nature of SLUB reduces memory requirements and in general the 
more efficient code paths of SLUB offset the advantage that SLAB can reach 
by being able to put more objects onto its queues. SLAB necessarily 
introduces complexity and cache line use through the need to manage those 
queues.

> vmalloc is incredibly slow and unscalable at the moment. I'm still working
> on making it more scalable and faster -- hopefully to a point where it would
> actually be usable for this... but you still get moved off large TLBs, and
> also have to inevitably do tlb flushing.

Again I have not seen any fallbacks to vmalloc in my testing. What we are 
doing here is mainly to address your theoretical cases that we so far have 
never seen to be a problem and increase the reliability of allocations of
page orders larger than 3 to a usable level. So far I have so far not 
dared to enable orders larger than 3 by default.

AFAICT The performance of vmalloc is not really relevant. If this would 
become an issue then it would be possible to reduce the orders used to 
avoid fallbacks.

> Or do you have SLUB at a point where performance is comparable to SLAB,
> and this is just a possible idea for more performance?

AFAICT SLUBs performance is superior to SLAB in most cases and it was like 
that from the beginning. I am still concerned about several corner cases 
though (I think most of them are going to be addressed by the per cpu 
patches in mm). Having a comparable or larger amount of per cpu objects as 
SLAB is something that also could address some of these concerns and could 
increase performance much further.
