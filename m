Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbXHFRfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbXHFRfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXHFRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:35:30 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:60812
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750823AbXHFRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:35:29 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
Date: Mon, 6 Aug 2007 10:35:18 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl>
In-Reply-To: <20070806102922.907530000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061035.18742.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 03:29, Peter Zijlstra wrote:
> In the interrest of getting swap over network working and posting in
> smaller series, here is the first series.
>
> This series lays the foundations needed to do reserve based
> allocation. Traditionally we have used mempools (and others like
> radix_tree_preload) to handle the problem.
>
> However this does not fit the network stack. It is built around
> variable sized allocations using kmalloc().
>
> This calls for a different approach.
>
> We want a guarantee for N bytes from kmalloc(), this translates to a
> demand on the slab allocator for 2*N+m (due to the power-of-two
> nature of kmalloc slabs), where m is the meta-data needed by the
> allocator itself.

Where does the 2* come from?  Isn't it exp2(ceil(log2(N + m)))?

> The slab allocator then puts a demand of P pages on the page
> allocator.
>
> So we need functions translating our demanded kmalloc space into a
> page reserve limit, and then need to provide a reserve of pages.
> 
> And we need to ensure that once we hit the reserve, the slab
> allocator honours the reserve's access. That is, a regular allocation
> may not get objects from a slab allocated from the reserves.

Patch [3/10] adds a new field to struct page.  I do not think this is 
necessary.   Allocating a page from reserve does not make it special.  
All we care about is that the total number of pages taken out of 
reserve is balanced by the total pages freed by a user of the reserve.

We do care about slab fragmentation in the sense that a slab page may be 
pinned in the slab by an unprivileged allocation and so that page may 
never be returned to the global page reserve.  One way to solve this is 
to have a per slabpage flag indicating the page came from reserve, and 
prevent mixing of privileged and unprivileged allocations on such a 
page.

> There is already a page reserve, but it does not fully comply with
> our needs. For example, it does not guarantee a strict level (due to
> the relative nature of ALLOC_HIGH and ALLOC_HARDER). Hence we augment
> this reserve with a strict limit.
>
> Furthermore a new __GFP flag is added to allow easy access to the
> reserves along-side the existing PF_MEMALLOC.
>
> Users of this infrastructure will need to do the necessary bean
> counting to ensure they stay within the requested limits.

This patch set is _way_ less intimidating than its predecessor.  
However, I see we have entered the era of sets of patch sets, since it 
is impossible to understand the need for this allocation infrastructure 
without reading the dependent network patch set.  Waiting with 
breathless anticipation.

Regards,

Daniel
