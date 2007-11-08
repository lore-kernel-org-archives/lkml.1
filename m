Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbXKHOHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbXKHOHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbXKHOHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:07:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34477 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955AbXKHOHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:07:08 -0500
Date: Thu, 8 Nov 2007 14:07:05 +0000
To: Zou Nan hai <nanhai.zou@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [Patch] Allocate sparse vmemmap block above 4G
Message-ID: <20071108140705.GA2591@skynet.ie>
References: <1194483127.3046.1471.camel@linux-znh>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1194483127.3046.1471.camel@linux-znh>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/11/07 08:52), Zou Nan hai didst pronounce:
> Resend the patch for more people to review
> 
> On some single node x64 system with huge amount of physical memory e.g >
> 64G. the memmap size maybe very big. 
> 
> If the memmap is allocated from low pages, it may occupies too much
> memory below 4G. 
> then swiotlb could fail to reserve bounce buffer under 4G which will
> lead to boot failure.
> 
> This patch will first try to allocate memmap memory above 4G in sparse
> vmemmap code. 
> If it failed, it will allocate memmap above MAX_DMA_ADDRESS. 
> This patch is against 2.6.24-rc1-git14
> 

You never state that you depend on the strict_goal patch either here or in
a leader mail. The usual way of getting peoples attention is to have three
mails. In your case it would be

[PATCH 0/2] Allocate vmemmap from highmem where possible
[PATCH 1/2] Strictly place bootmem allocations when requested
[PATCH 2/2] Allocate sparse vmemmap block above 4G on x86_64

Maybe you have gone through all this already and I'm coming so late that I
missed it all. If that is the case, sorry for the noise.

> Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff -Nraup a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> --- a/arch/x86/mm/init_64.c	2007-11-06 15:16:12.000000000 +0800
> +++ b/arch/x86/mm/init_64.c	2007-11-06 15:55:50.000000000 +0800
> @@ -448,6 +448,13 @@ void online_page(struct page *page)
>  	num_physpages++;
>  }
>  
> +void * __meminit alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size,
> +        unsigned long align)
> +{

Wrong markup there I believe. The __meminit markup is for functions
that are needed at runtime when memory is hot-added or hot-removed.
Bootmem functions do not qualify. __init is sufficient.

The name is confusing as well. I don't know what a high node is, but I
think you mean alloc_bootmem_highmem  or alloc_bootmem_highmem_zone.
That in *itself* is confusing on x86_64 because the memory above 4GiB is
ZONE_NORMAL, not ZONE_HIGHMEM. Calling it alloc_bootmem_nondma() makes
it worse.

I think you need to rework this to have an arch-specific function
like arch_alloc_vmemmap_block() that by default allocates with
____alloc_bootmem_node() and otherwise uses an arch-specific function.
In this case, it would know to call __alloc_bootmem_core() with the proper
addressing limits.

> +        return __alloc_bootmem_core(pgdat->bdata, size,
> +                        align, (4UL*1024*1024*1024), 0, 1);
> +}

More magic values, both the 4GiB address here and the magic "1" at the
end are problems.

> +
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  /*
>   * Memory is added always to NORMAL zone. This means you will never get
> diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
> --- a/include/linux/bootmem.h	2007-11-06 16:06:31.000000000 +0800
> +++ b/include/linux/bootmem.h	2007-11-06 15:50:36.000000000 +0800
> @@ -61,6 +61,10 @@ extern void *__alloc_bootmem_core(struct
>  				  unsigned long limit,
>  				  int strict_goal);
>  
> +extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
> +                unsigned long size,
> +                unsigned long align);
> +

Confusing. Your declaration here makes it look like a bootmem API
function but it is an arch-specific function that only exists for
x86-64. I know it gets overridden later when a weak symbol but the more
common approach is to have Kconfig define something like
ARCH_HIGHMEM_VMEMMAP and

#ifdef CONFIG_ARCH_HIGHMEM_VMEMMAP
extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
                unsigned long size,
                unsigned long align);
#else
static inline void *alloc_bootmem_high_node(pg_data_t *pgdat,
		unsigned long size,
		unsigned long align) {
	return NULL;
}
#endif /* CONFIG_ARCH_HIGHMEM_VMEMMAP

It's be similar if you have an arch-specific callback for vmalloc block
allocations instead of extending the bootmem API.

>
>  #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
>  extern void reserve_bootmem(unsigned long addr, unsigned long size);
>  #define alloc_bootmem(x) \
> diff -Nraup a/mm/bootmem.c b/mm/bootmem.c
> --- a/mm/bootmem.c	2007-11-06 16:06:31.000000000 +0800
> +++ b/mm/bootmem.c	2007-11-06 15:49:20.000000000 +0800
> @@ -492,3 +492,11 @@ void * __init __alloc_bootmem_low_node(p
>  	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
>  				    ARCH_LOW_ADDRESS_LIMIT, 0);
>  }
> +
> +__attribute__((weak)) __meminit

__meminit vs _init again

> +void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size,
> +        unsigned long align)
> +{
> +        return NULL;
> +}
> +
> diff -Nraup a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> --- a/mm/sparse-vmemmap.c	2007-11-06 15:16:12.000000000 +0800
> +++ b/mm/sparse-vmemmap.c	2007-11-06 16:08:52.000000000 +0800
> @@ -43,9 +43,13 @@ void * __meminit vmemmap_alloc_block(uns
>  		if (page)
>  			return page_address(page);
>  		return NULL;
> -	} else
> +	} else {
> +		void *p = alloc_bootmem_high_node(NODE_DATA(node), size, size);
> +		if (p)
> +			return p;
>  		return __alloc_bootmem_node(NODE_DATA(node), size, size,
>  				__pa(MAX_DMA_ADDRESS));

If you had an arch-specific function, I guess this would turn into

	} else {
		return arch_vmemmap_alloc_block(...);
	}

> +	}
>  }
>  
>  void __meminit vmemmap_verify(pte_t *pte, int node,
> 
> 
> 
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
