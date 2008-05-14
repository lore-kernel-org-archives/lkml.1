Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYENV0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYENV0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYENV0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:26:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53629 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750988AbYENV0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:26:41 -0400
Date: Wed, 14 May 2008 14:26:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <1210798978.4093.82.camel@calx>
Message-ID: <Pine.LNX.4.64.0805141405350.19073@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> 
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> 
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> 
 <482B2617.5010605@firstfloor.org>  <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
  <1210789112.4093.14.camel@calx>  <Pine.LNX.4.64.0805141220440.16223@schroedinger.engr.sgi.com>
  <1210794563.4093.57.camel@calx>  <Pine.LNX.4.64.0805141333060.18231@schroedinger.engr.sgi.com>
 <1210798978.4093.82.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matt Mackall wrote:

> First, we should obviously always expire all queues when we hit low
> water marks as it'll be cheaper/faster than other forms of reclaim.

Hmmm... I tried a scheme like that awhile back but it did not improve 
performance. The cost of queuing the object degraded the fast path (Note 
SLUB object queuing is fundamentally different due to no in slab 
metadata structure).

> Second, if our queues were per-slab (this might be hard, I realize), we
> can sweep the queue at alloc time.

In that case we dirty the same cacheline that we also need to take the 
page lock. Wonder if there would be any difference? The freelist is 
essentially a kind of per page queue (As pointed out by Ingo in the past).

> We can also sweep before falling back to the page allocator. That should
> guarantee that delayed frees don't negatively impact fragmentation.

That would introduce additional complexity for the NUMA case because now 
we would need to distinguish between the nodes that these objects came 
from. So we would have to scan the queue and classify the objects? Or 
determine the object node when queueing them and put them into an remote 
node queue? Sounds similar to all the trouble that we ended up with 
in SLAB.

> And lastly, we can always have a periodic thread/timer/workqueue
> operation.

I have had enough trouble in the last years with the 2 second hiccups that 
come with SLAB and that affect timing sensitive operations between 
processors in a SMP configuration and also cause trouble for applications 
that require fast network latencies. I'd rather avoid that.
 
> So far this is a bunch of hand-waving but I think this ends up basically
> being an anti-magazine. A magazine puts a per-cpu queue on the alloc
> side which costs on both the alloc and free side, regardless of whether
> the workload demands it. This puts a per-cpu queue on the free side that
> we can bypass in the cache-friendly case. I think that's a step in the
> right direction.

I think if you want queues for an SMP only system, do not care too much 
about memory use, dont do any frequent allocations on multicore systems 
and can tolerate the hiccups because your application does not care (most 
enterprise apps are constructed that way) or if you are running benchmarks 
that only access a limited dataset that fits into SLABs queues amd 
avoid touch the contenst of objects then the SLAB concept is the right way 
to go.

If we would strip the NUMA stuff out and make it an SMP only allocator for 
enterprise apps then the code may become much smaller and simpler. I guess 
Arjan suggested something similar in the past. But that would result in 
SLAB no longer being a general allocator.
