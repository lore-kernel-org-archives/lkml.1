Return-Path: <linux-kernel-owner+w=401wt.eu-S2992478AbXDTLCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992478AbXDTLCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992531AbXDTLCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:02:47 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:49692 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992478AbXDTLCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:02:46 -0400
Date: Fri, 20 Apr 2007 12:02:44 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 3/8] Flushing and zeroing higher order page cache pages
Message-ID: <20070420110244.GB12075@skynet.ie>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163520.11948.15503.sendpatchset@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070419163520.11948.15503.sendpatchset@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/04/07 09:35), Christoph Lameter didst pronounce:
> ---
>  include/linux/pagemap.h |   27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> Index: linux-2.6.21-rc7/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-18 22:08:36.000000000 -0700
> +++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-18 22:09:13.000000000 -0700
> @@ -210,6 +210,33 @@ static inline void wait_on_page_writebac
>  
>  extern void end_page_writeback(struct page *page);
>  
> +/* Support for clearing higher order pages */
> +static inline void clear_mapping_page(struct address_space *a,
> +						struct page *page)
> +{
> +	int nr_pages = 1 << a->order;
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		clear_highpage(page + i);
> +}

While this looks fine, it seems that clear_huge_page() and
clear_mapping_page() could share a common helper. I also note that
clear_huge_page() calls cond_reched() and this doesn't which may be the
type of different behavior we want to avoid.

That said, if this goes ahead, it might be an excuse to look at using
ramfs as the basis for hugetlbfs instead of it's current approach. I
believe using ramfs for hugepages is something that wli wants anyway.

> +
> +/*
> + * Support for flushing higher order pages.
> + *
> + * A bit stupid: On many platforms flushing the first page
> + * will flush any TLB starting there
> + */
> +static inline void flush_mapping_page(struct address_space *a,
> +						struct page *page)
> +{
> +	int nr_pages = 1 << a->order;
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		flush_dcache_page(page + i);
> +}
> +
>  /*
>   * Fault a userspace page into pagetables.  Return non-zero on a fault.
>   *

I suppose I'll see where this is used later in the patchset. It might be
easier to review if these helpers are introduced at the point they are
used.Not super-sure


> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
