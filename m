Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYKUMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYKUMHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYKUMHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:07:33 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51754 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbYKUMHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:07:32 -0500
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <84144f020811201135l7b83404etb311a7b62390dd19@mail.gmail.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201135l7b83404etb311a7b62390dd19@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 21 Nov 2008 12:07:28 +0000
Message-Id: <1227269248.7015.31.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 12:07:29.0263 (UTC) FILETIME=[B9B477F0:01C94BD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 21:35 +0200, Pekka Enberg wrote:
> On Thu, Nov 20, 2008 at 1:30 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > +#ifdef CONFIG_SMP
> > +#define cache_line_align(x)    L1_CACHE_ALIGN(x)
> > +#else
> > +#define cache_line_align(x)    (x)
> > +#endif
> 
> Maybe we should be put to <linux/cache.h> and call it cache_line_align_in_smp()?

Yes, it makes sense.

> > +/*
> > + * Object allocation
> > + */
> > +static void *fast_cache_alloc(struct fast_cache *cache)
[...]
> The slab allocators are pretty fast as well. Is there a reason you
> can't use kmalloc() or kmem_cache_alloc() for this? 

The reason for the internal allocator wasn't speed, I would be happy to
use the main one. The past kmemleak versions used the slab allocator and
I was getting lockdep reports about the l3->list_lock via the
cache_grow() and memleak_alloc() functions, IIRC. At that time I also
had another lock held during radix_tree_insert (this function calling
kmem_cache_alloc), so some of these problems might have gone away now
with a finer-grained locking and some RCU usage (actually no locks
should be held when calling the alloc functions from kmemleak).

It seems that the flags are propagated inside the slab allocator so it
is also possible to miss some slab-internal allocations we would like to
track (like slabmgmt objects in a list) or get too many recursive calls
via memleak_alloc().

> You can fix the
> recursion problem by adding a new GFP_NOLEAKTRACK flag that makes sure
> memleak hooks are not invoked if it's set.

But this flag doesn't get passed to kfree. An option would be to use a
kmem_cache and a SLAB_NOLEAKTRACE bit so that it can be checked via
kmem_cache_free().

If you don't think the above issues are real problems, I'm happy to give
it a try.

-- 
Catalin

