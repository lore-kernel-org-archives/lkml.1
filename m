Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXLNLx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXLNLx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXLNLxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:53:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45815 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763398AbXLNLxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:53:48 -0500
Date: Fri, 14 Dec 2007 11:53:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC]handle error of rmqueue_bulk
Message-ID: <20071214115346.GC11046@csn.ul.ie>
References: <1197623337.3732.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1197623337.3732.1.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/12/07 17:08), Shaohua Li didst pronounce:
> if rmqueue_bulk fails, we might get page with wrong migratetype,
> shouldn't we consider the case? 
> 

No. It is not a page allocation failure when this occurs, at worst
fragmentation gets a little worse. At this point, it is known the
per-cpu list contains pages so if one of the appropriate migrate type
cannot be found, fragmentation is allowed to get a little worse instead
of failing.

> Thanks,
> Shaohua
> 
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c	2007-12-14 16:44:35.000000000 +0800
> +++ linux/mm/page_alloc.c	2007-12-14 16:45:42.000000000 +0800
> @@ -1067,8 +1067,12 @@ again:
>  
>  		/* Allocate more to the pcp list if necessary */
>  		if (unlikely(&page->lru == &pcp->list)) {
> -			pcp->count += rmqueue_bulk(zone, 0,
> +			int cn;
> +			cn = rmqueue_bulk(zone, 0,
>  					pcp->batch, &pcp->list, migratetype);
> +			if (unlikely(!cn))
> +				goto failed;
> +			pcp->count += cn;
>  			page = list_entry(pcp->list.next, struct page, lru);
>  		}
>  
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
