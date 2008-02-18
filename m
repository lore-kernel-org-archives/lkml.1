Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbYBRVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbYBRVBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYBRVBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:01:08 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:55405 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYBRVBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:01:07 -0500
Date: Mon, 18 Feb 2008 22:01:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander van Heukelum <heukelum@mailshack.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Solve section mismatch for free_area_init_core.
Message-ID: <20080218210115.GA24592@uranus.ravnborg.org>
References: <20080203172148.GA17875@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203172148.GA17875@mailshack.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

I have (triggered by Geert) spend some time reviewing this patch
and I see no better way to fix it.

So it gets my:

Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

Original mail is here:
http://lkml.org/lkml/2008/2/3/129

Can you take it in -mm so we get some testing coverage.

Thanks,
	Sam

On Sun, Feb 03, 2008 at 06:21:48PM +0100, Alexander van Heukelum wrote:
> Solve section mismatch for free_area_init_core:
> 
> WARNING: vmlinux.o(.meminit.text+0x649): 
> Section mismatch in reference from the 
> function free_area_init_core() to the function .init.text:setup_usemap()
> The function __meminit free_area_init_core() references
> a function __init setup_usemap().
> If free_area_init_core is only used by setup_usemap then
> annotate free_area_init_core with a matching annotation.
> 
> The warning is covers this stack of functions in mm/page_alloc.c:
> 
> alloc_bootmem_node must be marked __init.
> alloc_bootmem_node is used by setup_usemap, if !SPARSEMEM.
> (usemap_size is only used by setup_usemap, if !SPARSEMEM.)
> setup_usemap is only used by free_area_init_core.
> free_area_init_core is only used by free_area_init_node.
> 
> free_area_init_node is used by:
> arch/alpha/mm/numa.c: __init paging_init()
> arch/arm/mm/init.c: __init bootmem_init_node()
> arch/avr32/mm/init.c: __init paging_init()
> arch/cris/arch-v10/mm/init.c: __init paging_init()
> arch/cris/arch-v32/mm/init.c: __init paging_init()
> arch/m32r/mm/discontig.c: __init zone_sizes_init()
> arch/m32r/mm/init.c: __init zone_sizes_init()
> arch/m68k/mm/motorola.c: __init paging_init()
> arch/m68k/mm/sun3mmu.c: __init paging_init()
> arch/mips/sgi-ip27/ip27-memory.c: __init paging_init()
> arch/parisc/mm/init.c: __init paging_init()
> arch/sparc/mm/srmmu.c: __init srmmu_paging_init()
> arch/sparc/mm/sun4c.c: __init sun4c_paging_init()
> arch/sparc64/mm/init.c: __init paging_init()
> mm/page_alloc.c: __init free_area_init_nodes()
> mm/page_alloc.c: __init free_area_init()
> and
> mm/memory_hotplug.c: hotadd_new_pgdat()
> 
> hotadd_new_pgdat can not be an __init function, but:
> 
> It is compiled for MEMORY_HOTPLUG configurations only
> MEMORY_HOTPLUG depends on SPARSEMEM || X86_64_ACPI_NUMA
> X86_64_ACPI_NUMA depends on X86_64
> ARCH_FLATMEM_ENABLE depends on X86_32
> ARCH_DISCONTIGMEM_ENABLE depends on X86_32
> So X86_64_ACPI_NUMA implies SPARSEMEM, right?
> 
> So we can mark the stack of functions __init for !SPARSEMEM,
> but we must mark them __meminit for SPARSEMEM configurations.
> This is ok, because then the calls to alloc_bootmem_node are
> also avoided.
> 
> Compile-tested on:
> silly minimal config
> defconfig x86_32
> defconfig x86_64
> defconfig x86_64 -HIBERNATION +MEMORY_HOTPLUG
> 
> Comments?
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 953f941..5b46b32 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -47,4 +47,17 @@ static inline unsigned long page_order(struct page *page)
>  	VM_BUG_ON(!PageBuddy(page));
>  	return page_private(page);
>  }
> +
> +/*
> + * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
> + * so all functions starting at paging_init should be marked __init
> + * in those cases. SPARSEMEM, however, allows for memory hotplug,
> + * and alloc_bootmem_node is not used.
> + */
> +#ifdef CONFIG_SPARSEMEM
> +#define __paginginit __meminit
> +#else
> +#define __paginginit __init
> +#endif
> +
>  #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b2838c2..859be40 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3321,7 +3321,7 @@ static inline int pageblock_default_order(unsigned int order)
>   *   - mark all memory queues empty
>   *   - clear the memory bitmaps
>   */
> -static void __meminit free_area_init_core(struct pglist_data *pgdat,
> +static void __paginginit free_area_init_core(struct pglist_data *pgdat,
>  		unsigned long *zones_size, unsigned long *zholes_size)
>  {
>  	enum zone_type j;
> @@ -3445,7 +3445,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
>  #endif /* CONFIG_FLAT_NODE_MEM_MAP */
>  }
>  
> -void __meminit free_area_init_node(int nid, struct pglist_data *pgdat,
> +void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
>  		unsigned long *zones_size, unsigned long node_start_pfn,
>  		unsigned long *zholes_size)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
