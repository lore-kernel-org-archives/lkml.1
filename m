Return-Path: <linux-kernel-owner+w=401wt.eu-S1765624AbXHFSfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765624AbXHFSfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXHFSfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:35:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38732 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbXHFSfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:35:42 -0400
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708061052160.24256@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	 <Pine.LNX.4.64.0708061052160.24256@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 20:33:51 +0200
Message-Id: <1186425231.11797.84.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 10:56 -0700, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Peter Zijlstra wrote:
> 
> > We want a guarantee for N bytes from kmalloc(), this translates to a demand
> > on the slab allocator for 2*N+m (due to the power-of-two nature of kmalloc 
> > slabs), where m is the meta-data needed by the allocator itself.
> 
> The guarantee occurs in what context? Looks like its global here but 
> allocations may be restricted to a cpuset context? What happens in a 
> GFP_THISNODE allocation? Or a memory policy restricted allocations?

>From what I could understand of the low level network allocations these
try to be node affine at best and are not subject to mempolicies due to
taking place from irq context.

> > So we need functions translating our demanded kmalloc space into a page
> > reserve limit, and then need to provide a reserve of pages.
> 
> Only kmalloc? What about skb heads and such?

kmalloc is the hardest thing to get right, there are also functions to
calculate the reserves for kmem_cache like allocations, see
kmem_estimate_pages().

> > And we need to ensure that once we hit the reserve, the slab allocator honours
> > the reserve's access. That is, a regular allocation may not get objects from
> > a slab allocated from the reserves.
> 
> From a cpuset we may hit the reserves since cpuset memory is out and then 
> the rest of the system fails allocations?

No, do see patch 2/10. What we do is we fail cpuset local allocations,
_except_ PF_MEMALLOC (or __GFP_MEMALLOC). These will break out of the
mempolicy bounds before dipping into the reserves.

This has the effect that all nodes will be low before we hit the
reserves. Also, given that PF_MEMALLOC will usually use only a little
amount of memory the impact of breaking out of these bounds is quite
limited.

