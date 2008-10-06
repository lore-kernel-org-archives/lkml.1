Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYJFUsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYJFUsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYJFUs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:48:28 -0400
Received: from gw.goop.org ([64.81.55.164]:41516 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbYJFUs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:48:27 -0400
Message-ID: <48EA798D.1090303@goop.org>
Date: Mon, 06 Oct 2008 13:48:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping initialization
 a two pass sequence
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com>
In-Reply-To: <20080923211444.369122000@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> In the first pass, kernel physical mapping will be setup using large or
> small pages but uses the same PTE attributes as that of the early
> PTE attributes setup by early boot code in head_[32|64].S
>
> After flushing TLB's, we go through the second pass, which setups the
> direct mapped PTE's with the appropriate attributes (like NX, GLOBAL etc)
> which are runtime detectable.
>
> This two pass mechanism conforms to the TLB app note which says:
>
> "Software should not write to a paging-structure entry in a way that would
>  change, for any linear address, both the page size and either the page frame
>  or attributes."
>   

I'd noticed that current tip/master hasn't been booting under Xen, and I 
just got around to bisecting it down to this change.

This patch is causing Xen to fail various pagetable updates because it 
ends up remapping pagetables to RW, which Xen explicitly prohibits (as 
that would allow guests to make arbitrary changes to pagetables, rather 
than have them mediated by the hypervisor).

A few things strike me about this patch:

   1. It's high time we unified the physical memory mapping code, and it
      would have been better to do so before making a change of this
      kind to the code.
   2. The existing code already avoided overwriting a pagetable entry
      unless the page size changed.  Wouldn't it be easier to construct
      the mappings first, using the old code, then do a CPA call to set
      the NX bit appropriately?
   3. The actual implementation is pretty ugly; adding a global variable
      and hopping about with goto does not improve this code.

What are the downsides of not following the TLB app note's advice?  Does 
it cause real failures?  Could we revert this patch and address the 
problem some other way?  Which app note is this, BTW?  The one I have on 
hand, "TLBs, Paging-Structure Caches, and Their Invalidation", Apr 2007, 
does not seem to mention this restriction.

As it is, I suspect it will take a non-trivial amount of work to restore 
Xen with this code in place (touching this code is always non-trivial).  
I haven't looked into it in depth yet, but there's a few stand out "bad 
for Xen" pieces of code here.  (And I haven't tested 32-bit yet.)

Quick rules for keeping Xen happy here:

   1. Xen provides its own initial pagetable; the head_64.S one is
      unused when booting under Xen.
   2. Xen requires that any pagetable page must always be mapped RO, so
      we're careful to not replace an existing mapping with a new one,
      in case the existing mapping is a pagetable one.
   3. Xen never uses large pages, and the hypervisor will fail any
      attempt to do so.


> Index: tip/arch/x86/mm/init_64.c
> ===================================================================
> --- tip.orig/arch/x86/mm/init_64.c	2008-09-22 15:59:31.000000000 -0700
> +++ tip/arch/x86/mm/init_64.c	2008-09-22 15:59:37.000000000 -0700
> @@ -323,6 +323,8 @@
>  	early_iounmap(adr, PAGE_SIZE);
>  }
>  
> +static int physical_mapping_iter;
> +
>  static unsigned long __meminit
>  phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
>  {
> @@ -343,16 +345,19 @@
>  		}
>  
>  		if (pte_val(*pte))
> -			continue;
> +			goto repeat_set_pte;
>   

This looks troublesome.  The code was explicitly avoiding resetting a 
pte which had already been set.  This change will make it overwrite the 
mapping with PAGE_KERNEL, which will break Xen if the mapping was 
previously RO.

>  
>  		if (0)
>  			printk("   pte=%p addr=%lx pte=%016lx\n",
>  			       pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
> +		pages++;
> +repeat_set_pte:
>  		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
>  		last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
> -		pages++;
>  	}
> -	update_page_count(PG_LEVEL_4K, pages);
> +
> +	if (physical_mapping_iter == 1)
> +		update_page_count(PG_LEVEL_4K, pages);
>  
>  	return last_map_addr;
>  }
> @@ -371,7 +376,6 @@
>  {
>  	unsigned long pages = 0;
>  	unsigned long last_map_addr = end;
> -	unsigned long start = address;
>  
>  	int i = pmd_index(address);
>  
> @@ -394,15 +398,14 @@
>  				last_map_addr = phys_pte_update(pmd, address,
>  								end);
>  				spin_unlock(&init_mm.page_table_lock);
> +				continue;
>  			}
> -			/* Count entries we're using from level2_ident_pgt */
> -			if (start == 0)
> -				pages++;
> -			continue;
> +			goto repeat_set_pte;
>  		}
>  
>  		if (page_size_mask & (1<<PG_LEVEL_2M)) {
>  			pages++;
> +repeat_set_pte:
>  			spin_lock(&init_mm.page_table_lock);
>  			set_pte((pte_t *)pmd,
>  				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
> @@ -419,7 +422,8 @@
>  		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
>  		spin_unlock(&init_mm.page_table_lock);
>  	}
> -	update_page_count(PG_LEVEL_2M, pages);
> +	if (physical_mapping_iter == 1)
> +		update_page_count(PG_LEVEL_2M, pages);
>  	return last_map_addr;
>  }
>  
> @@ -458,14 +462,18 @@
>  		}
>  
>  		if (pud_val(*pud)) {
> -			if (!pud_large(*pud))
> +			if (!pud_large(*pud)) {
>  				last_map_addr = phys_pmd_update(pud, addr, end,
>  							 page_size_mask);
> -			continue;
> +				continue;
> +			}
> +
> +			goto repeat_set_pte;
>  		}
>  
>  		if (page_size_mask & (1<<PG_LEVEL_1G)) {
>  			pages++;
> +repeat_set_pte:
>  			spin_lock(&init_mm.page_table_lock);
>  			set_pte((pte_t *)pud,
>  				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
> @@ -483,7 +491,9 @@
>  		spin_unlock(&init_mm.page_table_lock);
>  	}
>  	__flush_tlb_all();
> -	update_page_count(PG_LEVEL_1G, pages);
> +
> +	if (physical_mapping_iter == 1)
> +		update_page_count(PG_LEVEL_1G, pages);
>  
>  	return last_map_addr;
>  }
> @@ -547,15 +557,54 @@
>  		direct_gbpages = 0;
>  }
>  
> +static int is_kernel(unsigned long pfn)
> +{
> +	unsigned long pg_addresss = pfn << PAGE_SHIFT;
> +
> +	if (pg_addresss >= (unsigned long) __pa(_text) &&
> +	    pg_addresss <= (unsigned long) __pa(_end))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static unsigned long __init kernel_physical_mapping_init(unsigned long start,
>  						unsigned long end,
>  						unsigned long page_size_mask)
>  {
>  
> -	unsigned long next, last_map_addr = end;
> +	unsigned long next, last_map_addr;
> +	u64 cached_supported_pte_mask = __supported_pte_mask;
> +	unsigned long cache_start = start;
> +	unsigned long cache_end = end;
> +
> +	/*
> +	 * First iteration will setup identity mapping using large/small pages
> +	 * based on page_size_mask, with other attributes same as set by
> +	 * the early code in head_64.S
>   

We can't assume here that the pagetables we're modifying are necessarily 
the head_64.S ones.

> +	 *
> +	 * Second iteration will setup the appropriate attributes
> +	 * as desired for the kernel identity mapping.
> +	 *
> +	 * This two pass mechanism conforms to the TLB app note which says:
> +	 *
> +	 *     "Software should not write to a paging-structure entry in a way
> +	 *      that would change, for any linear address, both the page size
> +	 *      and either the page frame or attributes."
> +	 *
> +	 * For now, only difference between very early PTE attributes used in
> +	 * head_64.S and here is _PAGE_NX.
> +	 */
> +	BUILD_BUG_ON((__PAGE_KERNEL_LARGE & ~__PAGE_KERNEL_IDENT_LARGE_EXEC)
> +		     != _PAGE_NX);
> +	__supported_pte_mask &= ~(_PAGE_NX);
> +	physical_mapping_iter = 1;
>  
> -	start = (unsigned long)__va(start);
> -	end = (unsigned long)__va(end);
> +repeat:
> +	last_map_addr = cache_end;
> +
> +	start = (unsigned long)__va(cache_start);
> +	end = (unsigned long)__va(cache_end);
>  
>  	for (; start < end; start = next) {
>  		pgd_t *pgd = pgd_offset_k(start);
> @@ -567,11 +616,21 @@
>  			next = end;
>  
>  		if (pgd_val(*pgd)) {
> +			/*
> +			 * Static identity mappings will be overwritten
> +			 * with run-time mappings. For example, this allows
> +			 * the static 0-1GB identity mapping to be mapped
> +			 * non-executable with this.
> +			 */
> +			if (is_kernel(pte_pfn(*((pte_t *) pgd))))
> +				goto realloc;
>   

This is definitely a Xen-breaker, but removing this is not sufficient on 
its own.  Is this actually related to the rest of the patch, or a 
gratuitous throw-in change?

> +
>  			last_map_addr = phys_pud_update(pgd, __pa(start),
>  						 __pa(end), page_size_mask);
>  			continue;
>  		}
>  
> +realloc:
>  		pud = alloc_low_page(&pud_phys);
>  		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
>  						 page_size_mask);
> @@ -581,6 +640,16 @@
>  		pgd_populate(&init_mm, pgd, __va(pud_phys));
>  		spin_unlock(&init_mm.page_table_lock);
>  	}
> +	__flush_tlb_all();
> +
> +	if (physical_mapping_iter == 1) {
> +		physical_mapping_iter = 2;
> +		/*
> +		 * Second iteration will set the actual desired PTE attributes.
> +		 */
> +		__supported_pte_mask = cached_supported_pte_mask;
> +		goto repeat;
> +	}
>  
>  	return last_map_addr;
>  }
>
>   

Thanks,
    J
