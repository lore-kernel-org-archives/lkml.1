Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYFGT4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYFGT4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYFGT4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:56:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYFGT4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:56:47 -0400
Date: Sat, 7 Jun 2008 15:56:20 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm 04/25] free swap space on swap-in/activation
Message-ID: <20080607155620.733f1b01@bree.surriel.com>
In-Reply-To: <20080606180430.38bf1d82.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.570020389@redhat.com>
	<20080606180430.38bf1d82.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:04:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 06 Jun 2008 16:28:42 -0400
> Rik van Riel <riel@redhat.com> wrote:
> > From: Rik van Riel <riel@redhat.com>
> > 
> > Free swap cache entries when swapping in pages if vm_swap_full()
> > [swap space > 1/2 used].  Uses new pagevec to reduce pressure
> > on locks.
> > 
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
> > 
> > ---
> >  include/linux/pagevec.h |    1 +
> >  include/linux/swap.h    |    6 ++++++
> >  mm/swap.c               |   18 ++++++++++++++++++
> >  mm/swapfile.c           |   25 ++++++++++++++++++++++---
> >  mm/vmscan.c             |    7 +++++++
> >  5 files changed, 54 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
> > ===================================================================
> > --- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-23 14:21:33.000000000 -0400
> > +++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-23 14:21:33.000000000 -0400
> > @@ -619,6 +619,9 @@ free_it:
> >  		continue;
> >  
> >  activate_locked:
> > +		/* Not a candidate for swapping, so reclaim swap space. */
> > +		if (PageSwapCache(page) && vm_swap_full())
> 
> The patch puts rather a lot of pressure onto vm_swap_full().  We might
> want to look into optimising that.
> 
> - Is the 50% thing optimum?  Could go higher and perhaps should be
>   based on amount-of-memory.
> 
> - Can precalculate the fraction rather than doing it inline all the time.

I do not know if 50% is optimum.  It is just what the upstream kernel
has had since 2.4.10 or so.  Before that it used to be 75%.  This same
percentage is used to free swap spaces at swapin time.
 
> - Can make total_swap_pages __read_mostly and have a think about
>   nr_swap_pages too.

I wonder if we wouldn't be off best simply placing the two on their
own cache line.  After all, they are often handled together.

I believe that should be a separate patch though, since I am not
changing that situation from what is already upstream and this
patch series contains more than enough stuff already.

> - Can completely optimise the thing away if !CONFIG_SWAP.
> 
> 
> Has all this code been tested with CONFIG_SWAP=n?

With CONFIG_SWAP=n the macro PageSwapCache(page) will always be
declared false due to the declarations in page-flags.h.  That
means that vm_swap_full() will be evaluated and the compiler
should leave it out.

#ifdef CONFIG_SWAP
PAGEFLAG(SwapCache, swapcache)
#else
PAGEFLAG_FALSE(SwapCache)
#endif

> > +void pagevec_swap_free(struct pagevec *pvec)

> What's going on here.
> 
> Normally we'll bump a page's refcount to account for its presence in a
> pagevec.  This code doesn't do that.
> 
> Is it safe?  If so, how come?

It is safe because the callers already hold an extra reference to
each page.  I have added a full kerneldoc comment to this function
to explain that.

-- 
All rights reversed.
