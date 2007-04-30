Return-Path: <linux-kernel-owner+w=401wt.eu-S1946409AbXD3QlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946409AbXD3QlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946410AbXD3QlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:41:07 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:50242 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946403AbXD3QlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:41:00 -0400
Subject: Re: [PATCH] change global zonelist order v4 [2/2] auto
	configuration
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, clameter@sgi.com
In-Reply-To: <20070427151722.dfd142b1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070427144530.ae42ee25.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070427151722.dfd142b1.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 30 Apr 2007 12:26:57 -0400
Message-Id: <1177950417.5623.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 15:17 +0900, KAMEZAWA Hiroyuki wrote:
> Add auto zone ordering configuration.
> 
> This function will select ZONE_ORDER_NODE when
> 
> - There are only ZONE_DMA or ZONE_DMA32.
> (or) size of (ZONE_DMA/DMA32) > (System Total Memory)/2
> (or) Assume Node(A)
> 	* Node (A)'s total memory > System Total Memory/num_of_node+1
> 	(and) Node (A)'s ZONE_DMA/DMA32 occupies 60% of Node(A)'s memory.
> 
> otherwise, ZONE_ORDER_ZONE is selected.
> 
> Note: a user can specifiy this ordering from boot option.
                   specify
> 
> Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Minor editorial [spelling, ...] comments.

Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
> ---
>  mm/page_alloc.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 43 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc7-mm2/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.21-rc7-mm2.orig/mm/page_alloc.c	2007-04-27 15:39:49.000000000 +0900
> +++ linux-2.6.21-rc7-mm2/mm/page_alloc.c	2007-04-27 15:55:51.000000000 +0900
> @@ -2211,8 +2211,50 @@
>  
>  static int estimate_zonelist_order(void)
>  {
> -	/* dummy, just select node order. */
> -	return ZONELIST_ORDER_NODE;
> +	int nid, zone_type;
> +	unsigned long low_kmem_size,total_size;
> +	struct zone *z;
> +	int average_size;
> +	/* ZONE_DMA and ZONE_DMA32 can be very small area in the sytem.
> +	   If they are really small and used heavily,
> +	   the system can fall into OOM very easily.
> +	   This function detect ZONE_DMA/DMA32 size and confgigure
                           detects                        configures
> +	   zone ordering */
> +	/* Is there ZONE_NORMAL ? (ex. ppc has only DMA zone..) */
> +	low_kmem_size = 0;
> +	total_size = 0;
> +	for_each_online_node(nid) {
> +		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
> +			z = &NODE_DATA(nid)->node_zones[zone_type];
> +			if (populated_zone(z)) {
> +				if (zone_type < ZONE_NORMAL)
> +					low_kmem_size += z->present_pages;
> +				total_size += z->present_pages;
> +			}
> +		}
> +	}
> +	if (!low_kmem_size ||  /* there is no DMA area. */
> +	    !low_kmem_size > total_size/2) /* DMA/DMA32 is big. */
> +		return ZONELIST_ORDER_NODE;
> +	/* look into each node's config. where all processes starts... */
> +	/* average size..a bit smaller than real average size */
> +	average_size = total_size / (num_online_nodes() + 1);
> +	for_each_online_node(nid) {
> +		low_kmem_size = 0;
> +		total_size = 0;
> +		for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
> +			z = &NODE_DATA(nid)->node_zones[zone_type];
> +			if (populated_zone(z)) {
> +				if (zone_type < ZONE_NORMAL)
> +					low_kmem_size += z->present_pages;
> +				total_size += z->present_pages;
> +			}
> +		}
> +		if (total_size > average_size && /* ignore unbalanced node */
> +		    low_kmem_size > total_size * 60/100)
> +			return ZONELIST_ORDER_NODE;
> +	}
> +	return ZONELIST_ORDER_ZONE;
>  }
>  
> 
> 

