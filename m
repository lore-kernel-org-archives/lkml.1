Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYCMLTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYCMLTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 07:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYCMLTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 07:19:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48843 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbYCMLTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 07:19:40 -0400
Date: Thu, 13 Mar 2008 11:19:35 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] mm: allocate section_map for sparse_init
Message-ID: <20080313111934.GA12351@csn.ul.ie>
References: <86802c440803121051q20023badsf8e6e0571f4bb92e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <86802c440803121051q20023badsf8e6e0571f4bb92e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/03/08 10:51), Yinghai Lu didst pronounce:
> [PATCH] mm: allocate section_map for sparse_init
> 
> allocate section_map in bootmem instead of using __initdata.
> 
> need to apply it after
>         [PATCH] mm: fix boundary checking in free_bootmem_core
>         [PATCH] mm: make mem_map allocation continuous.
> 
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

> Index: linux-2.6/mm/sparse.c
> ===================================================================
> --- linux-2.6.orig/mm/sparse.c
> +++ linux-2.6/mm/sparse.c
> @@ -285,8 +285,6 @@ struct page __init *sparse_early_mem_map
>  	return NULL;
>  }
>  
> -/* section_map pointer array is 64k */
> -static __initdata struct page *section_map[NR_MEM_SECTIONS];
>  /*
>   * Allocate the accumulated non-linear sections, allocate a mem_map
>   * for each and record the physical to section mapping.
> @@ -296,6 +294,9 @@ void __init sparse_init(void)
>  	unsigned long pnum;
>  	struct page *map;
>  	unsigned long *usemap;
> +	struct page **section_map;
> +	int size;
> +	int node;
>  
>  	/*
>  	 * map is using big page (aka 2M in x86 64 bit)
> @@ -305,13 +306,17 @@ void __init sparse_init(void)
>  	 * then in big system, the memmory will have a lot hole...
>  	 * here try to allocate 2M pages continously.
>  	 */
> +	size = sizeof(struct page *) * NR_MEM_SECTIONS;
> +	section_map = alloc_bootmem(size);
> +	if (!section_map)
> +		panic("can not allocate section_map\n");
> +
>  	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  		if (!present_section_nr(pnum))
>  			continue;
>  		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
>  	}
>  
> -
>  	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  		if (!present_section_nr(pnum))
>  			continue;
> @@ -327,6 +332,9 @@ void __init sparse_init(void)
>  		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
>  								usemap);
>  	}
> +
> +	for_each_online_node(node)
> +		free_bootmem_node(NODE_DATA(node), __pa(section_map), size);

Why are you iterating every online node here instead of just calling
free_bootmem(__pa(section_map), size) ?

>  }
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
