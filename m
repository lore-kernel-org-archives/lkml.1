Return-Path: <linux-kernel-owner+w=401wt.eu-S1762731AbXKOJjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762731AbXKOJjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 04:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbXKOJjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 04:39:31 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4723 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760309AbXKOJj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:39:29 -0500
Date: Thu, 15 Nov 2007 09:39:15 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1 (memory hotplug x86_64/vmemmap  fix)
Message-ID: <20071115093851.GA2513@shadowen.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:29:19PM +0900, KAMEZAWA Hiroyuki wrote:
> Fixes for memory hotplug compile and .section handling.
> 
> This patch fixes following bugs
> ==
> WARNING: vmlinux.o(.text+0x1d07c): Section mismatch: reference to .init.text:f
> ind_e820_area (between 'init_memory_mapping' and 'arch_add_memory')
> WARNING: vmlinux.o(.text+0x946b5): Section mismatch: reference to .init.text:
> __alloc_bootmem_node (between 'vmemmap_alloc_block' and 'vmemmap_pgd_populate')
> 
> ERROR: "memory_add_physaddr_to_nid" [drivers/acpi/acpi_memhotplug.ko] undefined!
> make[1]: *** [__modpost
> ==
> 
> This patch does
>  1. export memory_add_physaddr_to_nid().
>  2. changes __init to __init_refok find_early_table_space() (x86/mm/init_64.c)
>  3. changes __init_refok to __meminit in mm/sparse.c (This is bug.)

Can you explain "this is bug" for me.  The routine was __init_refok and
therefore ! __init and therefore always present.  The logic there must
guarentee it only calls the bootmem allocator in early boot, and the logic
has not changed with the annotation change so it should have been safe.
If by "this is bug" you are saying this is the cause of the warning then
yes that is true, else could you elaborate.

>  4. add wrapper function to call bootmem allocator without warning.
> 
>  After seeing "3", I thought simple __init_refok is dangerous and decided to
>  add wrapper function to call bootmem, is this style acceptable ?

The point of that wrapper being you only allow calls to that one function
to be __init_refok, and all other function calls in the calling function
will be checked as that function remains __init/__meminit or not as
appropriate.  That seems like a good idea.

Also any code which is __init_refok is implicitly in its own section.
I assume that means it cannot be __init, ie any function so declared will
never be freed even if otherwise it might be __init.  In this case the
calling function would naturally be __meminit, ie __init if hotplug is
not enabled.  Moving the one call to a separate function makes the code
non-__init'able smaller.  That sounds good too.

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>  arch/x86/mm/init_64.c |    2 +-
>  arch/x86/mm/srat_64.c |    1 +
>  mm/sparse-vmemmap.c   |   13 ++++++++++++-
>  mm/sparse.c           |   12 ++++++++++--
>  4 files changed, 24 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.24-rc2-mm1/arch/x86/mm/srat_64.c
> ===================================================================
> --- linux-2.6.24-rc2-mm1.orig/arch/x86/mm/srat_64.c
> +++ linux-2.6.24-rc2-mm1/arch/x86/mm/srat_64.c
> @@ -562,3 +562,4 @@ int memory_add_physaddr_to_nid(u64 start
>  	return ret;
>  }
>  
> +EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
> Index: linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.24-rc2-mm1.orig/arch/x86/mm/init_64.c
> +++ linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
> @@ -319,7 +319,7 @@ static void __meminit phys_pud_init(pud_
>  	__flush_tlb();
>  } 
>  
> -static void __init find_early_table_space(unsigned long end)
> +static void __init_refok find_early_table_space(unsigned long end)
>  {
>  	unsigned long puds, pmds, tables, start;
>  
> Index: linux-2.6.24-rc2-mm1/mm/sparse.c
> ===================================================================
> --- linux-2.6.24-rc2-mm1.orig/mm/sparse.c
> +++ linux-2.6.24-rc2-mm1/mm/sparse.c
> @@ -55,7 +55,15 @@ static inline void set_section_nid(unsig
>  #endif
>  
>  #ifdef CONFIG_SPARSEMEM_EXTREME
> -static struct mem_section noinline __init_refok *sparse_index_alloc(int nid)
> +/*
> + * for avoiding section mismatch.
> + */
> +static void __init_refok *__call_bootmem_alloc(int nid, int array_size)

This indirect makes sense for the sparse safety aspect, only letting the
caller use this one routine.  I wonder if the name should be more
explicit.  earlyonly_bootmem_alloc() or something, so that a later
reader knows from the call site that this is magical and care needs to
be exercised here.

As this is local to this file, this should also be static I presume.  Or
indeed perhaps if we picked a namespace such as the proposed earlyonly_
for functions with this annotation we could have just one copy, and
reduce code size.

> +{
> +	return alloc_bootmem_node(NODE_DATA(nid), array_size);
> +}
> +
> +static struct mem_section noinline __meminit *sparse_index_alloc(int nid)
>  {
>  	struct mem_section *section = NULL;
>  	unsigned long array_size = SECTIONS_PER_ROOT *
> @@ -64,7 +72,7 @@ static struct mem_section noinline __ini
>  	if (slab_is_available())
>  		section = kmalloc_node(array_size, GFP_KERNEL, nid);
>  	else
> -		section = alloc_bootmem_node(NODE_DATA(nid), array_size);
> +		section = __call_bootmem_alloc(nid, array_size);
>  
>  	if (section)
>  		memset(section, 0, array_size);
> Index: linux-2.6.24-rc2-mm1/mm/sparse-vmemmap.c
> ===================================================================
> --- linux-2.6.24-rc2-mm1.orig/mm/sparse-vmemmap.c
> +++ linux-2.6.24-rc2-mm1/mm/sparse-vmemmap.c
> @@ -30,6 +30,17 @@
>  #include <asm/pgtable.h>
>  
>  /*
> + * wrapper for calling bootmem alloc from __meminit code.
> + */
> +void __init_refok *__call_alloc_bootmem(int node,
> +			int size, int align, int goal)
> +{
> +	return __alloc_bootmem_node(NODE_DATA(node), size, align, goal);
> +}
> +

Same comment on naming here, static etc.

> +
> +
> +/*
>   * Allocate a block of memory to be used to back the virtual memory map
>   * or to back the page tables that are used to create the mapping.
>   * Uses the main allocators if they are available, else bootmem.
> @@ -44,7 +55,7 @@ void * __meminit vmemmap_alloc_block(uns
>  			return page_address(page);
>  		return NULL;
>  	} else
> -		return __alloc_bootmem_node(NODE_DATA(node), size, size,
> +		return __call_alloc_bootmem(node, size, size,
>  				__pa(MAX_DMA_ADDRESS));
>  }

Reviewed-by: Andy Whitcroft <apw@shadowen.org>

-apw
