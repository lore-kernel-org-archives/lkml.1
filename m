Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbXFZFYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbXFZFYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXFZFYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:24:32 -0400
Received: from waste.org ([66.93.16.53]:48180 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbXFZFYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:24:31 -0400
Date: Tue, 26 Jun 2007 00:24:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLOB allocator imcompatible SLAB
Message-ID: <20070626052419.GD11115@waste.org>
References: <m2tzt01kew.wl%ysato@users.sourceforge.jp> <20070622145635.GX11115@waste.org> <m2ejk05y7c.wl%ysato@users.sourceforge.jp> <468090B7.2080200@yahoo.com.au> <20070626045635.GC11115@waste.org> <46809D88.2080208@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46809D88.2080208@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 03:00:56PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >On Tue, Jun 26, 2007 at 02:06:15PM +1000, Nick Piggin wrote:
> >
> >>Yoshinori Sato wrote:
> >>
> >>>At Fri, 22 Jun 2007 09:56:35 -0500,
> >>>Matt Mackall wrote:
> >>>
> >>>
> >>>>On Fri, Jun 22, 2007 at 05:08:07PM +0900, Yoshinori Sato wrote:
> >>>>
> >>>>
> >>>>>Because the page which SLOB allocator got does not have PG_slab,
> >>>>
> >>>>This is for a NOMMU system?
> >>>
> >>>
> >>>Yes.
> >>>
> >>>
> >>>
> >>>>You're using an old kernel with an old version of SLOB. SLOB in newer
> >>>>kernels actually sets per-page flags. Nick, can you see any reason not
> >>>>to s/PG_active/PG_slab/ in the current code?
> >>
> >>The problem with this is that PG_private is used only for the SLOB
> >>part of the allocator and not the bigblock part.
> >
> >
> >That's fine, at least for the purposes of kobjsize. We only mark
> >actual SLOB-managed pages, kobjsize assumes the rest are alloc_pages
> >and that's indeed what they are.
> 
> OK, but that only makes it work in this case. I think we should
> either call PG_slab part of the kmem/kmalloc API and implement
> that, or say it isn't and make nommu do something else?
>
> >>We _could_ just bite the bullet and have SLOB set PG_slab, however
> >>that would encouarage more users of this flag which we should hope
> >>to get rid of one day.
> >>
> >>The real problem is that nommu wants to get the size of either
> >>kmalloc or alloc_pages objects and it needs to differentiate
> >>between them. So I would rather nommu to take its own page flag
> >>(could overload PG_swapcache, perhaps?), and set that flag on
> >>pages it allocates directly, then uses that to determine whether
> >>to call ksize or not.
> >
> >
> >I think we already established on the last go-round that the kobjsize
> >scheme was rather hopelessly broken anyway. 
> 
> I can't remember, but that would be another good reason to confine
> it to nommu.c wouldn't it?

(jogs brain)

When I last looked, we could tell statically whether pointers passed
to kobjsize were to alloc_pages or kmalloc or kmem_cache_alloc just
based on context.

But in some cases, we could actually pass in pointers to static data
structures (eg bits of init_task) and things that were in ROM and
being used for XIP or things that lived outside of the kernel's
address space. SLAB would deal with this kind of affront by checking
page flags and saying "sorry, not mine".

Beating some sense into nommu here is doable, but non-trivial.

Since we're actually fiddling with page flags at this point and
hijacking an arguably less-appropriate bit, I'm strongly tempted to
just use the SLAB bit.

-- 
Mathematics is the supreme nostalgia of our time.
