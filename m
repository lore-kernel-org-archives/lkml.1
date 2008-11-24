Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbYKXIOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbYKXIOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYKXIO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:14:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYKXIO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:14:28 -0500
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <1227269248.7015.31.camel@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201135l7b83404etb311a7b62390dd19@mail.gmail.com>
	 <1227269248.7015.31.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Nov 2008 10:16:04 +0200
Message-Id: <1227514564.3718.17.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Fri, 2008-11-21 at 12:07 +0000, Catalin Marinas wrote:
> > > +/*
> > > + * Object allocation
> > > + */
> > > +static void *fast_cache_alloc(struct fast_cache *cache)
> [...]
> > The slab allocators are pretty fast as well. Is there a reason you
> > can't use kmalloc() or kmem_cache_alloc() for this? 
> 
> The reason for the internal allocator wasn't speed, I would be happy to
> use the main one. The past kmemleak versions used the slab allocator and
> I was getting lockdep reports about the l3->list_lock via the
> cache_grow() and memleak_alloc() functions, IIRC. At that time I also
> had another lock held during radix_tree_insert (this function calling
> kmem_cache_alloc), so some of these problems might have gone away now
> with a finer-grained locking and some RCU usage (actually no locks
> should be held when calling the alloc functions from kmemleak).

OK, but I don't really see any fundamental reason why we couldn't do
this. I mean, from my point of view, it would be better to add
specialized hooks (i.e. separate allocation paths for the kmemleak hooks
that avoid any issues) inside the SLAB allocators rather than invent a
separate allocator. As an example, 

﻿On Fri, 2008-11-21 at 12:07 +0000, Catalin Marinas wrote:
> It seems that the flags are propagated inside the slab allocator so it
> is also possible to miss some slab-internal allocations we would like to
> track (like slabmgmt objects in a list) or get too many recursive calls
> via memleak_alloc().

I'm not sure I understand this. Which flags are you talking about? I do
see you might run into locking trouble with calling kmalloc() within
kmalloc() but most of that should go away if kmemleak hooks use a
separate cache, no?

﻿On Fri, 2008-11-21 at 12:07 +0000, Catalin Marinas wrote:
> > You can fix the
> > recursion problem by adding a new GFP_NOLEAKTRACK flag that makes sure
> > memleak hooks are not invoked if it's set.
> 
> But this flag doesn't get passed to kfree. An option would be to use a
> kmem_cache and a SLAB_NOLEAKTRACE bit so that it can be checked via
> kmem_cache_free().

Right, of course. And I guess that's better for kmemleak anyway, as it
has fixed size objects.

However, just to drive my point home, another option would be to reuse
the non-tracing kmalloc functions we did for kmemtrace which needs to
tackle the recursion problem as well:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=shortlog;h=topic/kmemtrace

﻿On Fri, 2008-11-21 at 12:07 +0000, Catalin Marinas wrote:
> If you don't think the above issues are real problems, I'm happy to give
> it a try.

Yes, please. If you run into problems, let me know if I can help out.

		Pekka

