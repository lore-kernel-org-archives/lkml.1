Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXENQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXENQNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbXENQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:13:35 -0400
Received: from waste.org ([66.93.16.53]:58767 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXENQNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:13:33 -0400
Date: Mon, 14 May 2007 11:12:24 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
Message-ID: <20070514161224.GC11115@waste.org>
References: <20070514131904.440041502@chello.nl> <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 08:53:21AM -0700, Christoph Lameter wrote:
> On Mon, 14 May 2007, Peter Zijlstra wrote:
> 
> > In the interest of creating a reserve based allocator; we need to make the slab
> > allocator (*sigh*, all three) fair with respect to GFP flags.
> 
> I am not sure what the point of all of this is. 
> 
> > That is, we need to protect memory from being used by easier gfp flags than it
> > was allocated with. If our reserve is placed below GFP_ATOMIC, we do not want a
> > GFP_KERNEL allocation to walk away with it - a scenario that is perfectly
> > possible with the current allocators.
> 
> Why does this have to handled by the slab allocators at all? If you have 
> free pages in the page allocator then the slab allocators will be able to 
> use that reserve.

If I understand this correctly:

privileged thread                      unprivileged greedy process
kmem_cache_alloc(...)
   adds new slab page from lowmem pool
do_io()
                                       kmem_cache_alloc(...)
                                       kmem_cache_alloc(...)
                                       kmem_cache_alloc(...)
                                       kmem_cache_alloc(...)
                                       kmem_cache_alloc(...)
                                       ...
                                          eats it all
kmem_cache_alloc(...) -> ENOMEM
   who ate my donuts?!

But I think this solution is somehow overkill. If we only care about
this issue in the OOM avoidance case, then our rank reduces to a
boolean.

-- 
Mathematics is the supreme nostalgia of our time.
