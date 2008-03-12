Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYCLM3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYCLM3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYCLM3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:29:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46789 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYCLM3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:29:23 -0400
Date: Wed, 12 Mar 2008 12:29:20 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH rc5-mm1 1/3] mm-have-zonelist: fix memcg ooms
Message-ID: <20080312122920.GB25250@csn.ul.ie>
References: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/03/08 21:12), Hugh Dickins didst pronounce:
> Memcgroups up against their limit were OOMing unjustifiably on x86_32
> with highmem: pages ripe for freeing were not being found.
> 
> It's because the zonelist changes in vmscan.c now derive zone from gfp_mask,
> and the gfp mask being passed into try_to_free_mem_cgroup_pages is atuned
> to allocating a struct page_cgroup (__GFP_HIGHMEM masked off), whereas here
> we need to be scanning highmem zones.
> 
> Frankenstein a gfp_mask from GFP_HIGHUSER_MOVABLE and the mask passed in.
> 

Well spotted, but I have one query below.

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Same error was in -rc3-mm1, sorry for not sending fix in time for -rc5-mm1.
> The error comes 1 or 4 patches earlier, but this patch atop 2.6.25-rc5-mm1
> fits best just after
> mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
> 
> I've other GFP masking fixes or cleanups to come another day: this fixes
> just one clear bug, peculiar to the -mm tree, orthogonal to the rest.
> But two little do_try_to_free_pages cleanups follow on from this...
> 
>  mm/vmscan.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- 2.6.25-rc5-mm1/mm/vmscan.c	2008-03-11 14:19:36.000000000 +0000
> +++ linux/mm/vmscan.c	2008-03-11 20:09:05.000000000 +0000
> @@ -1444,7 +1444,6 @@ unsigned long try_to_free_mem_cgroup_pag
>  						gfp_t gfp_mask)
>  {
>  	struct scan_control sc = {
> -		.gfp_mask = gfp_mask,
>  		.may_writepage = !laptop_mode,
>  		.may_swap = 1,
>  		.swap_cluster_max = SWAP_CLUSTER_MAX,
> @@ -1454,9 +1453,10 @@ unsigned long try_to_free_mem_cgroup_pag
>  		.isolate_pages = mem_cgroup_isolate_pages,
>  	};
>  	struct zonelist *zonelist;
> -	int target_zone = gfp_zonelist(GFP_HIGHUSER_MOVABLE);
>  
> -	zonelist = &NODE_DATA(numa_node_id())->node_zonelists[target_zone];
> +	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> +			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> +	zonelist = NODE_DATA(numa_node_id())->node_zonelists;

While it is clear you are setting the mask to include HIGHMEM-related flags,
it's not as clear to me why you alter the zonelist as well. target_zone was
already based on HIGHMEM so what are you fixing there?

It should still work as ->node_zonelists[0] is a zonelist suitable for node
fallback as opposed to node_zonelists[1] which is for GFP_THISNODE but
maybe this was not quite what you intended?

Probably something obvious that will hit me the second I push send :)

>  	if (do_try_to_free_pages(zonelist, sc.gfp_mask, &sc))
>  		return 1;
>  	return 0;
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
