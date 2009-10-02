Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZJBOQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZJBOQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZJBOQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:16:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55119 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZJBOQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:16:12 -0400
Date: Fri, 2 Oct 2009 15:16:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
	out of zone_wait_table_init()
Message-ID: <20091002141618.GO21906@csn.ul.ie>
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091001212559.879284755@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 05:25:33PM -0400, cl@linux-foundation.org wrote:
> Explicitly initialize the pagesets after the per cpu areas have been
> initialized. This is necessary in order to be able to use per cpu
> operations in later patches.
> 

Can you be more explicit about this? I think the reasoning is as follows

A later patch will use DEFINE_PER_CPU which allocates memory later in
the boot-cycle after zones have already been initialised. Without this
patch, use of DEFINE_PER_CPU would result in invalid memory accesses
during pageset initialisation.

Have another question below as well.

> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  arch/ia64/kernel/setup.c       |    1 +
>  arch/powerpc/kernel/setup_64.c |    1 +
>  arch/sparc/kernel/smp_64.c     |    1 +
>  arch/x86/kernel/setup_percpu.c |    2 ++
>  include/linux/mm.h             |    1 +
>  mm/page_alloc.c                |   40 +++++++++++++++++++++++++++++-----------
>  mm/percpu.c                    |    2 ++
>  7 files changed, 37 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/mm/page_alloc.c	2009-10-01 09:36:19.000000000 -0500
> @@ -3270,23 +3270,42 @@ void zone_pcp_update(struct zone *zone)
>  	stop_machine(__zone_pcp_update, zone, NULL);
>  }
>  
> -static __meminit void zone_pcp_init(struct zone *zone)
> +/*
> + * Early setup of pagesets.
> + *
> + * In the NUMA case the pageset setup simply results in all zones pcp
> + * pointer being directed at a per cpu pageset with zero batchsize.
> + *

The batchsize becomes 1, not 0 if you look at setup_pageset() but that aside,
it's unclear from the comment *why* the batchsize is 1 in the NUMA case.
Maybe something like the following?

=====
In the NUMA case, the boot_pageset is used until the slab allocator is
available to allocate per-zone pagesets as each CPU is brought up. At
this point, the batchsize is set to 1 to prevent pages "leaking" onto the
boot_pageset freelists.
=====

Otherwise, nothing in the patch jumped out at me other than to double
check CPU-up events actually result in process_zones() being called and
that boot_pageset is not being accidentally used in the long term.

> + * This means that every free and every allocation occurs directly from
> + * the buddy allocator tables.
> + *
> + * The pageset never queues pages during early boot and is therefore usable
> + * for every type of zone.
> + */
> +__meminit void setup_pagesets(void)
>  {
>  	int cpu;
> -	unsigned long batch = zone_batchsize(zone);
> +	struct zone *zone;
>  
> -	for (cpu = 0; cpu < NR_CPUS; cpu++) {
> +	for_each_zone(zone) {
>  #ifdef CONFIG_NUMA
> -		/* Early boot. Slab allocator not functional yet */
> -		zone_pcp(zone, cpu) = &boot_pageset[cpu];
> -		setup_pageset(&boot_pageset[cpu],0);
> +		unsigned long batch = 0;
> +
> +		for (cpu = 0; cpu < NR_CPUS; cpu++) {
> +			/* Early boot. Slab allocator not functional yet */
> +			zone_pcp(zone, cpu) = &boot_pageset[cpu];
> +		}
>  #else
> -		setup_pageset(zone_pcp(zone,cpu), batch);
> +		unsigned long batch = zone_batchsize(zone);
>  #endif
> +
> +		for_each_possible_cpu(cpu)
> +			setup_pageset(zone_pcp(zone, cpu), batch);
> +
> +		if (zone->present_pages)
> +			printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%lu\n",
> +				zone->name, zone->present_pages, batch);
>  	}
> -	if (zone->present_pages)
> -		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%lu\n",
> -			zone->name, zone->present_pages, batch);
>  }
>  
>  __meminit int init_currently_empty_zone(struct zone *zone,
> @@ -3841,7 +3860,6 @@ static void __paginginit free_area_init_
>  
>  		zone->prev_priority = DEF_PRIORITY;
>  
> -		zone_pcp_init(zone);
>  		for_each_lru(l) {
>  			INIT_LIST_HEAD(&zone->lru[l].list);
>  			zone->reclaim_stat.nr_saved_scan[l] = 0;
> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/include/linux/mm.h	2009-10-01 09:36:19.000000000 -0500
> @@ -1060,6 +1060,7 @@ extern void show_mem(void);
>  extern void si_meminfo(struct sysinfo * val);
>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>  extern int after_bootmem;
> +extern void setup_pagesets(void);
>  
>  #ifdef CONFIG_NUMA
>  extern void setup_per_cpu_pageset(void);
> Index: linux-2.6/arch/ia64/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/setup.c	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/arch/ia64/kernel/setup.c	2009-10-01 09:35:39.000000000 -0500
> @@ -864,6 +864,7 @@ void __init
>  setup_per_cpu_areas (void)
>  {
>  	/* start_kernel() requires this... */
> +	setup_pagesets();
>  }
>  #endif
>  
> Index: linux-2.6/arch/powerpc/kernel/setup_64.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/setup_64.c	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/arch/powerpc/kernel/setup_64.c	2009-10-01 09:35:39.000000000 -0500
> @@ -578,6 +578,7 @@ static void ppc64_do_msg(unsigned int sr
>  		snprintf(buf, 128, "%s", msg);
>  		ppc_md.progress(buf, 0);
>  	}
> +	setup_pagesets();
>  }
>  
>  /* Print a boot progress message. */
> Index: linux-2.6/arch/sparc/kernel/smp_64.c
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/smp_64.c	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/arch/sparc/kernel/smp_64.c	2009-10-01 09:35:39.000000000 -0500
> @@ -1486,4 +1486,5 @@ void __init setup_per_cpu_areas(void)
>  	of_fill_in_cpu_data();
>  	if (tlb_type == hypervisor)
>  		mdesc_fill_in_cpu_data(cpu_all_mask);
> +	setup_pagesets();
>  }
> Index: linux-2.6/arch/x86/kernel/setup_percpu.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup_percpu.c	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/arch/x86/kernel/setup_percpu.c	2009-10-01 09:35:39.000000000 -0500
> @@ -269,4 +269,6 @@ void __init setup_per_cpu_areas(void)
>  
>  	/* Setup cpu initialized, callin, callout masks */
>  	setup_cpu_local_masks();
> +
> +	setup_pagesets();
>  }
> Index: linux-2.6/mm/percpu.c
> ===================================================================
> --- linux-2.6.orig/mm/percpu.c	2009-10-01 08:54:19.000000000 -0500
> +++ linux-2.6/mm/percpu.c	2009-10-01 09:35:39.000000000 -0500
> @@ -2062,5 +2062,7 @@ void __init setup_per_cpu_areas(void)
>  	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
>  	for_each_possible_cpu(cpu)
>  		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
> +
> +	setup_pagesets();
>  }
>  #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
