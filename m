Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbZC3UkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbZC3UkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbZC3UkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:40:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbZC3UkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:40:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=R1/MS/6meSE5l8RXGPQnNQ229SFzCKBoZ3+4SMkv6eXTd+F/D5koS7UXPnO+uCUa6
	MeZSZ9egoOVofiOKIJMsA==
Date: Mon, 30 Mar 2009 13:38:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <20090330155419.GC27169@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0903301329290.21074@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <1238397091.26742.35.camel@penberg-laptop> <20090330155419.GC27169@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Mel Gorman wrote:

> netperf and tbench will both pound the sl*b allocator far more than sysbench
> will in my opinion although I don't have figures on-hand to back that up. In
> the case of netperf, it might be particular obvious if the client is on one
> CPU and the server on another because I believe that means all allocs happen
> on one CPU and all frees on another.
> 

My results are for two 16-core 64G machines on the same rack, one running 
netserver and the other running netperf.

> I have a vague concern that such a tunable needs to exist at all though
> and wonder what workloads it can hurt when set to 20 for example versus any
> other value.
> 

The tunable needs to exist unless a counter proposal is made that fixes 
this slub performance degradation compared to using slab.  I'd be very 
interested to hear other proposals on how to detect and remedy such 
situations in the allocator without the addition of a tunable.

As I mentioned previously in response to Pekka, it won't cause a further 
regression if sane SLAB_THRASHING_THRESHOLD and slab_thrash_ratio values 
are chosen.  The rules are pretty simple as described by the 
implementation: if a cpu slab can only allocate 20% of its objects three 
times in a row, we're going to choose a more free slab for the partial 
list while holding list_lock as opposed to constantly contending on it.  
This is particularly important for the netperf benchmark because the only 
cpu slabs that thrash are the ones with NUMA locality to the cpu taking 
the networking interrupt (because remote_node_defrag_ratio was unchanged 
from its default, meaning we avoid remote node defragmentation 98% of the 
time).

I haven't measured the fastpath implications of non-thrashing caches (the 
increment in the alloc fastpath and the conditional in the alloc slowpath 
for partial list sorting) yet, but your suggested experiments should show 
that quite well.
