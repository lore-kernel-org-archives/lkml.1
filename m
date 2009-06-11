Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZFKN7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZFKN7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZFKN7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:59:34 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34981 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750856AbZFKN7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:59:34 -0400
Date: Thu, 11 Jun 2009 09:58:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mingo@elte.hu, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
In-Reply-To: <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
Message-ID: <alpine.DEB.1.10.0906110954030.29827@gentwo.org>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Pekka J Enberg wrote:

>  	setup_nr_cpu_ids();
>  	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
>
> +	build_all_zonelists();
> +	page_alloc_init();
> +
> +	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
> +	parse_early_param();
> +	parse_args("Booting kernel", static_command_line, __start___param,
> +		   __stop___param - __start___param,
> +		   &unknown_bootoption);
> +	/*
> +	 * These use large bootmem allocations and must precede
> +	 * kmem_cache_init()
> +	 */
> +	pidhash_init();
> +	vfs_caches_init_early();
> +	/*
> +	 * Set up kernel memory allocators
> +	 */
> +	mem_init();
> +	kmem_cache_init();
> +	vmalloc_init();

Good they are all together. Maybe we can come up with an mm_init()?

> @@ -603,7 +616,6 @@ asmlinkage void __init start_kernel(void)
>  	/* init some links before init_ISA_irqs() */
>  	early_irq_init();
>  	init_IRQ();
> -	pidhash_init();
>  	init_timers();
>  	hrtimers_init();
>  	softirq_init();
> @@ -645,14 +657,10 @@ asmlinkage void __init start_kernel(void)
>  		initrd_start = 0;
>  	}
>  #endif
> -	vmalloc_init();
> -	vfs_caches_init_early();
>  	cpuset_init_early();
>  	page_cgroup_init();
> -	mem_init();
>  	enable_debug_pagealloc();
>  	cpu_hotplug_init();
> -	kmem_cache_init();
>  	kmemtrace_init();
>  	debug_objects_mem_init();
>  	idr_init_cache();

Therefore potential breakage is in cpusets, hotplug and control groups.
Have any of these been tested with these patches? NUMA?

> diff --git a/mm/slub.c b/mm/slub.c
> index 5e805a6..c1815a6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2557,13 +2557,16 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
>  	if (gfp_flags & SLUB_DMA)
>  		flags = SLAB_CACHE_DMA;
>
> -	down_write(&slub_lock);
> +	/*
> +	 * This function is called with IRQs disabled during early-boot on
> +	 * single CPU so there's no need to take slub_lock here.
> +	 */
>  	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,

This function is also called later when kmalloc caches are
created on demand.
