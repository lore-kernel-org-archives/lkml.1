Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYEIVv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYEIVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYEIVvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:51:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37654 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755562AbYEIVvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:51:17 -0400
Date: Fri, 9 May 2008 16:51:16 -0500
From: Russ Anderson <rja@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org, tony.luck@intel.com, clameter@sgi.com
Subject: Re: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v3
Message-ID: <20080509215116.GA32718@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080509151058.GC16523@sgi.com> <20080509131134.dae2bd65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509131134.dae2bd65.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 01:11:34PM -0700, Andrew Morton wrote:
> On Fri, 9 May 2008 10:10:58 -0500
> Russ Anderson <rja@sgi.com> wrote:
> 
> > Index: linus/mm/swap.c
> > ===================================================================
> > --- linus.orig/mm/swap.c	2008-05-09 09:19:40.466984064 -0500
> > +++ linus/mm/swap.c	2008-05-09 09:20:11.330791803 -0500
> > @@ -195,6 +195,8 @@ void lru_cache_add(struct page *page)
> >  	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
> >  
> >  	page_cache_get(page);
> > +	if (unlikely(PageMemError(page)))
> > +		return;		/* Don't add bad pages to the page list */
> >  	if (!pagevec_add(pvec, page))
> >  		__pagevec_lru_add(pvec);
> >  	put_cpu_var(lru_add_pvecs);
> > @@ -205,6 +207,8 @@ void lru_cache_add_active(struct page *p
> >  	struct pagevec *pvec = &get_cpu_var(lru_add_active_pvecs);
> >  
> >  	page_cache_get(page);
> > +	if (unlikely(PageMemError(page)))
> > +		return;		/* Don't add bad pages to the page list */
> >  	if (!pagevec_add(pvec, page))
> >  		__pagevec_lru_add_active(pvec);
> >  	put_cpu_var(lru_add_active_pvecs);
> 
> These PageMemError() tests are happening in some pretty darn hot paths. 
> But we've gone and added this overhead to a lot of architectures and
> configs which don't need it.
>
> Should we tighten that up?  Arrange for PageMemError() to evaluate to
> constant zero for all builds which don't actually implement "Migrate data
> off physical pages with correctable errors"?

Yes.

> Probably the way to implement that would be to add a new
> CONFIG_NEED_PAGE_MEM_ERROR and `select' that from the appropriate place in
> ia64 Kconfig.  Which is pretty nasty, but a) we're nasty that way rather
> often and b) this time it _is_ a hot-path, so some nastiness is
> justifiable.

Will do.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
