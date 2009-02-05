Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZBEKjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZBEKjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZBEKj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:39:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41646 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZBEKj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:39:28 -0500
Date: Thu, 5 Feb 2009 10:39:25 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, heiko.carstens@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-ID: <20090205103925.GE26878@csn.ul.ie>
References: <20090204.222651.26527737.davem@davemloft.net> <20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com> <20090205.012123.141238531.davem@davemloft.net> <20090205183409.1a12c23b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090205183409.1a12c23b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:34:09PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 05 Feb 2009 01:21:23 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Thu, 5 Feb 2009 18:06:17 +0900
> > 
> > > @@ -2632,7 +2633,8 @@ void __meminit memmap_init_zone(unsigned
> > >  		if (context == MEMMAP_EARLY) {
> > >  			if (!early_pfn_valid(pfn))
> > >  				continue;
> > > -			if (!early_pfn_in_nid(pfn, nid))
> > > +			tmp = early_pfn_in_nid(pfn, nid);
> > > +			if (tmp > -1 && tmp != nid)
> > 
> > early_pfn_in_nid() returns true or false, not the found nid
> > 
> > I think you meant to change this to call early_pfn_to_nid()
> > 
> sorry..
> 
> > I'll make that correction and test your patch.
> > 
> > BTW, if you make that conversion there is no need for
> > early_pfn_in_nid() since there will be no other users.
> > 
> 
> Thanks, maybe the patch will be like this.
> -Kame
> ==
> If a pfn is not in early_node_map[], memmap for it is not initialized.
> By this, PG_reserved is not set and the invalid memmap may sneak into buddy
> allocator.
> 

Under ordinary circumstances, it should not sneak into the buddy allocator. If
it is not initialised, then the page zone and node linkages will also not
be setup and none of the flags, critically PageBuddy, will never get set
either so it cannot merge. Things like move_freepages(), lumpy reclaim
and /proc/pagetypinfo read them though which is bad.

====
If a PFN is not in early_node_map[] then the struct page for it is not
initialised. If there are holes within a MAX_ORDER_NR_PAGES range of
pages, then PG_reserved will not be set. Code that walks PFNs within
MAX_ORDER_NR_PAGES will then use uninitialised struct pages.

To avoid any problems, this patch initialises holes within a MAX_ORDER_NR_PAGES
that valid memmap exists but is otherwise unused.
====

On a different note, deleting that BUG_ON would also have been safe in
this context as PageBuddy() would not have been set.

> To avoid that, initialize it with give nid if no early_node_map[] for pfn
> exists. PG_reserved will make this page unused.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/mmzone.h |    6 ------
>  mm/page_alloc.c        |    7 +++++--
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> Index: mmotm-2.6.29-Feb03/mm/page_alloc.c
> ===================================================================
> --- mmotm-2.6.29-Feb03.orig/mm/page_alloc.c
> +++ mmotm-2.6.29-Feb03/mm/page_alloc.c
> @@ -2618,6 +2618,7 @@ void __meminit memmap_init_zone(unsigned
>  	unsigned long end_pfn = start_pfn + size;
>  	unsigned long pfn;
>  	struct zone *z;
> +	int tmp;
>  

tmp is a horrible name and can be declared below

>  	if (highest_memmap_pfn < end_pfn - 1)
>  		highest_memmap_pfn = end_pfn - 1;
> @@ -2632,7 +2633,8 @@ void __meminit memmap_init_zone(unsigned
>  		if (context == MEMMAP_EARLY) {

int actual_nid;

or something similar to indicate it is the NID as identified by
early_node_map[].

>  			if (!early_pfn_valid(pfn))
>  				continue;
> -			if (!early_pfn_in_nid(pfn, nid))
> +			tmp = early_pfn_to_nid(pfn);
> +			if (tmp > -1 && tmp != nid)
>  				continue;
>  		}
>  		page = pfn_to_page(pfn);
> @@ -2999,8 +3001,9 @@ int __meminit early_pfn_to_nid(unsigned 
>  			return early_node_map[i].nid;
>  	}
>  
> -	return 0;
> +	return -1;
>  }

Ok, I think these changes are safe. I looked at the other callers of
early_pfn_in_nid() and to have any trouble, they would have to be
passing in PFNs that make no sense.

Because you check -1, I also see no way for memmap for nodes to be
accidentally initialised twice.

> +
>  #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
>  
>  /* Basic iterator support to walk early_node_map[] */
> Index: mmotm-2.6.29-Feb03/include/linux/mmzone.h
> ===================================================================
> --- mmotm-2.6.29-Feb03.orig/include/linux/mmzone.h
> +++ mmotm-2.6.29-Feb03/include/linux/mmzone.h
> @@ -1070,12 +1070,6 @@ void sparse_init(void);
>  #define sparse_index_init(_sec, _nid)  do {} while (0)
>  #endif /* CONFIG_SPARSEMEM */
>  
> -#ifdef CONFIG_NODES_SPAN_OTHER_NODES
> -#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
> -#else
> -#define early_pfn_in_nid(pfn, nid)	(1)
> -#endif
> -
>  #ifndef early_pfn_valid
>  #define early_pfn_valid(pfn)	(1)
>  #endif
> 

Other than the tmp thing which is pure cosmetic

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
