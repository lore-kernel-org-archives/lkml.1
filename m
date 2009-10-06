Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZJFJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZJFJqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZJFJqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:46:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53153 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbZJFJqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:46:18 -0400
Date: Tue, 6 Oct 2009 10:45:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 13/20] this_cpu_ops: page allocator conversion
Message-ID: <20091006094544.GC18185@csn.ul.ie>
References: <20091001212521.123389189@gentwo.org> <20091001212600.068637154@gentwo.org> <20091002151437.GP21906@csn.ul.ie> <alpine.DEB.1.10.0910021331020.26189@gentwo.org> <20091005094527.GB12681@csn.ul.ie> <alpine.DEB.1.10.0910051040270.16359@gentwo.org> <alpine.DEB.1.10.0910051055120.16359@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910051055120.16359@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 10:55:49AM -0400, Christoph Lameter wrote:
> 
> Changes to this patch so far:
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c	2009-10-05 09:49:07.000000000 -0500
> +++ linux-2.6/mm/page_alloc.c	2009-10-05 09:48:43.000000000 -0500
> @@ -1098,8 +1098,6 @@ static void free_hot_cold_page(struct pa
>  	arch_free_page(page, 0);
>  	kernel_map_pages(page, 1, 0);
> 
> -	local_irq_save(flags);
> -	pcp = &this_cpu_ptr(zone->pageset)->pcp;
>  	migratetype = get_pageblock_migratetype(page);
>  	set_page_private(page, migratetype);
>  	if (unlikely(wasMlocked))

Why did you move local_irq_save() ? It should have stayed where it was
because VM counters are updated under the lock. Only the this_cpu_ptr
should be moving.

> @@ -1121,6 +1119,8 @@ static void free_hot_cold_page(struct pa
>  		migratetype = MIGRATE_MOVABLE;
>  	}
> 
> +	local_irq_save(flags);
> +	pcp = &this_cpu_ptr(zone->pageset)->pcp;
>  	if (cold)
>  		list_add_tail(&page->lru, &pcp->lists[migratetype]);
>  	else
> @@ -3120,7 +3120,8 @@ static struct notifier_block __cpuinitda
>  /*
>   * Allocate per cpu pagesets and initialize them.
>   * Before this call only boot pagesets were available.
> - * Boot pagesets will no longer be used after this call is complete.
> + * Boot pagesets will no longer be used by this processorr
> + * after setup_per_cpu_pageset().
>   */
>  void __init setup_per_cpu_pageset(void)
>  {
> @@ -3232,11 +3233,11 @@ __meminit void setup_pagesets(void)
>  		zone->pageset = &per_cpu_var(boot_pageset);
> 
>  		/*
> -		 * Special pagesets with zero elements so that frees
> +		 * Special pagesets with one element so that frees
>  		 * and allocations are not buffered at all.
>  		 */
>  		for_each_possible_cpu(cpu)
> -			setup_pageset(per_cpu_ptr(zone->pageset, cpu), 0);
> +			setup_pageset(per_cpu_ptr(zone->pageset, cpu), 1);
> 
>  	}
>  }
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
