Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZCXBdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZCXBdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 21:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZCXBdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 21:33:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49892 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZCXBdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 21:33:11 -0400
Date: Tue, 24 Mar 2009 10:31:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       riel@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix vmscan to take care of nodemask
Message-Id: <20090324103139.07af98f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090323114814.GB6484@csn.ul.ie>
References: <20090323100356.e980d266.kamezawa.hiroyu@jp.fujitsu.com>
	<20090323114814.GB6484@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 11:48:14 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Mon, Mar 23, 2009 at 10:03:56AM +0900, KAMEZAWA Hiroyuki wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > try_to_free_pages() scans zonelist but doesn't take care of nodemask which is
> > passed to alloc_pages_nodemask(). This makes try_to_free_pages() less effective.
> > 
> 
> Hmm, do you mind if I try expanding that changelog a bit?
> 
> ====
> 
> try_to_free_pages() is used for the direct reclaim of up to
> SWAP_CLUSTER_MAX pages when watermarks are low. The caller to
> alloc_pages_nodemask() can specify a nodemask of nodes that are allowed
> to be used but this is not passed to try_to_free_pages(). This can lead
> to the unnecessary reclaim of pages that are unusable by the caller and
> in the worst case lead to allocation failure as progress was not been
> made where it is needed.
> 
> This patch passes the nodemask used for alloc_pages_nodemask() to
> try_to_free_pages().
> 
> ====
> 
> ?

Thank you. I gradly use your text :)

> 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  fs/buffer.c          |    2 +-
> >  include/linux/swap.h |    2 +-
> >  mm/page_alloc.c      |    3 ++-
> >  mm/vmscan.c          |   14 ++++++++++++--
> >  4 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > Index: mmotm-2.6.29-Mar21/mm/vmscan.c
> > ===================================================================
> > --- mmotm-2.6.29-Mar21.orig/mm/vmscan.c
> > +++ mmotm-2.6.29-Mar21/mm/vmscan.c
> > @@ -79,6 +79,9 @@ struct scan_control {
> >  	/* Which cgroup do we reclaim from */
> >  	struct mem_cgroup *mem_cgroup;
> >  
> > +	/* Nodemask */
> > +	nodemask_t	*nodemask;
> > +
> 
> That comment is not a whole pile of help
> 
> /*
>  * nodemask of nodes allowed by the caller. Note that nodemask==NULL
>  * means scal all nods
>  */
> 
> ?
> 
ok.

> >  	/* Pluggable isolate pages callback */
> >  	unsigned long (*isolate_pages)(unsigned long nr, struct list_head *dst,
> >  			unsigned long *scanned, int order, int mode,
> > @@ -1544,7 +1547,9 @@ static void shrink_zones(int priority, s
> >  	struct zone *zone;
> >  
> >  	sc->all_unreclaimable = 1;
> > -	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> > +	/* Note: sc->nodemask==NULL means scan all node */
> 
> Your choice, but I moved this comment to scan_control. I don't mind
> where it is really.
> 
ok.


> > +	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
> > +					sc->nodemask) {
> >  		if (!populated_zone(zone))
> >  			continue;
> >  		/*
> > @@ -1689,7 +1694,7 @@ out:
> >  }
> >  
> >  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> > -								gfp_t gfp_mask)
> > +				gfp_t gfp_mask, nodemask_t *nodemask)
> >  {
> >  	struct scan_control sc = {
> >  		.gfp_mask = gfp_mask,
> > @@ -1700,6 +1705,7 @@ unsigned long try_to_free_pages(struct z
> >  		.order = order,
> >  		.mem_cgroup = NULL,
> >  		.isolate_pages = isolate_pages_global,
> > +		.nodemask = nodemask,
> >  	};
> >  
> >  	return do_try_to_free_pages(zonelist, &sc);
> > @@ -1720,6 +1726,7 @@ unsigned long try_to_free_mem_cgroup_pag
> >  		.order = 0,
> >  		.mem_cgroup = mem_cont,
> >  		.isolate_pages = mem_cgroup_isolate_pages,
> > +		.nodemask = NULL,
> 
> While strictly speaking, this is unnecessary, I prefer it because it
> tells a reader that "yes, I really meant it to be NULL".
> 
> >  	};
> >  	struct zonelist *zonelist;
> >  
> > @@ -1769,6 +1776,7 @@ static unsigned long balance_pgdat(pg_da
> >  		.order = order,
> >  		.mem_cgroup = NULL,
> >  		.isolate_pages = isolate_pages_global,
> > +		.nodemask = NULL,
> >  	};
> >  	/*
> >  	 * temp_priority is used to remember the scanning priority at which
> > @@ -2112,6 +2120,7 @@ unsigned long shrink_all_memory(unsigned
> >  		.may_unmap = 0,
> >  		.may_writepage = 1,
> >  		.isolate_pages = isolate_pages_global,
> > +		.nodemask = NULL,
> >  	};
> >  
> >  	current->reclaim_state = &reclaim_state;
> > @@ -2298,6 +2307,7 @@ static int __zone_reclaim(struct zone *z
> >  		.swappiness = vm_swappiness,
> >  		.order = order,
> >  		.isolate_pages = isolate_pages_global,
> > +		.nodemask = NULL,
> >  	};
> >  	unsigned long slab_reclaimable;
> >  
> > Index: mmotm-2.6.29-Mar21/include/linux/swap.h
> > ===================================================================
> > --- mmotm-2.6.29-Mar21.orig/include/linux/swap.h
> > +++ mmotm-2.6.29-Mar21/include/linux/swap.h
> > @@ -213,7 +213,7 @@ static inline void lru_cache_add_active_
> >  
> >  /* linux/mm/vmscan.c */
> >  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> > -					gfp_t gfp_mask);
> > +					gfp_t gfp_mask, nodemask_t *mask);
> >  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
> >  						  gfp_t gfp_mask, bool noswap,
> >  						  unsigned int swappiness);
> > Index: mmotm-2.6.29-Mar21/mm/page_alloc.c
> > ===================================================================
> > --- mmotm-2.6.29-Mar21.orig/mm/page_alloc.c
> > +++ mmotm-2.6.29-Mar21/mm/page_alloc.c
> > @@ -1598,7 +1598,8 @@ nofail_alloc:
> >  	reclaim_state.reclaimed_slab = 0;
> >  	p->reclaim_state = &reclaim_state;
> >  
> > -	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
> > +	did_some_progress = try_to_free_pages(zonelist, order,
> > +						gfp_mask, nodemask);
> >  
> >  	p->reclaim_state = NULL;
> >  	lockdep_clear_current_reclaim_state();
> > Index: mmotm-2.6.29-Mar21/fs/buffer.c
> > ===================================================================
> > --- mmotm-2.6.29-Mar21.orig/fs/buffer.c
> > +++ mmotm-2.6.29-Mar21/fs/buffer.c
> > @@ -476,7 +476,7 @@ static void free_more_memory(void)
> >  						&zone);
> >  		if (zone)
> >  			try_to_free_pages(node_zonelist(nid, GFP_NOFS), 0,
> > -						GFP_NOFS);
> > +						GFP_NOFS, NULL);
> >  	}
> >  }
> >  
> 
> Otherwise looks good. With a better changelog and a comment other than "/*
> nodemask */" explaining what nodemask is;
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> 

Thank you for review !

Regards,
-Kame


> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

