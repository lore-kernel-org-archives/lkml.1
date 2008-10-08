Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYJHTrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYJHTrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbYJHTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:46:53 -0400
Received: from gw.goop.org ([64.81.55.164]:60307 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbYJHTqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:46:52 -0400
Message-ID: <48ED0E22.8080809@goop.org>
Date: Wed, 08 Oct 2008 12:46:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yinghai@kernel.org
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping initialization
 a two pass sequence
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com> <48EA798D.1090303@goop.org> <20081007015833.GO15609@linux-os.sc.intel.com> <48EB8008.1020700@goop.org> <20081007205845.GP15609@linux-os.sc.intel.com>
In-Reply-To: <20081007205845.GP15609@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Tue, Oct 07, 2008 at 08:28:08AM -0700, Jeremy Fitzhardinge wrote:
>   
>> Well, that's OK.  We just need to preserve the original page permissions
>> when fragmenting the large mappings.  (This isn't a case that affects
>> Xen, because it will already be 4k mappings.)
>>     
>
> Jeremy, Can you please check if the appended patch fixes your issue and Ack
> it? Test booted on three different 64bit platforms with and without
> DEBUG_PAGEALLOC.
>   

This patch works fine under Xen.  Thanks for the quick fix.

Tested-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J

>   
>> Great.  Also, do you think you'll have a chance to look at unifying the
>> 32 and 64 bit code (where 32 uses the 64-bit version)?
>>     
>
> 32bit can't use the 64-bit version. 64bit uses large pages in the
> static mapping setup by head_64.S while the 32bit uses small mappings.
> I am also not sure why the Xen 32bit didn't break. With or with out may
> recent changes, 32bit kernel is always doing set_pte() and doesn't seem
> to care about the previous mappings. So what is special with 32bit xen
> that doesn't cause this failure. Thanks.
>
> ---
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x64, cpa: modify kernel physical mapping initialization to satisfy Xen
>
> Jeremy Fitzhardinge wrote:
>
>   
>> I'd noticed that current tip/master hasn't been booting under Xen, and I
>> just got around to bisecting it down to this change.
>>
>> commit 065ae73c5462d42e9761afb76f2b52965ff45bd6
>> Author: Suresh Siddha <suresh.b.siddha@intel.com>
>>
>>    x86, cpa: make the kernel physical mapping initialization a two pass sequence
>>
>> This patch is causing Xen to fail various pagetable updates because it
>> ends up remapping pagetables to RW, which Xen explicitly prohibits (as
>> that would allow guests to make arbitrary changes to pagetables, rather
>> than have them mediated by the hypervisor).
>>     
>
> Instead of making init a two pass sequence, to satisfy the Intel's TLB
> Application note (developer.intel.com/design/processor/applnots/317080.pdf
> Section 6 page 26), we preserve the original page permissions
> when fragmenting the large mappings and don't touch the existing memory
> mapping (which satisfies Xen's requirements).
>
> Only open issue is: on a native linux kernel, we will go back to mapping
> the first 0-1GB kernel identity mapping as executable (because of the
> static mapping setup in head_64.S). We can fix this in a different
> patch if needed.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>
> Index: tip/arch/x86/mm/init_64.c
> ===================================================================
> --- tip.orig/arch/x86/mm/init_64.c	2008-10-07 13:30:06.000000000 -0700
> +++ tip/arch/x86/mm/init_64.c	2008-10-07 13:30:29.000000000 -0700
> @@ -323,10 +323,9 @@
>  	early_iounmap(adr, PAGE_SIZE);
>  }
>  
> -static int physical_mapping_iter;
> -
>  static unsigned long __meminit
> -phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
> +phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
> +	      pgprot_t prot)
>  {
>  	unsigned pages = 0;
>  	unsigned long last_map_addr = end;
> @@ -344,35 +343,40 @@
>  			break;
>  		}
>  
> +		/*
> +		 * We will re-use the existing mapping.
> +		 * Xen for example has some special requirements, like mapping
> +		 * pagetable pages as RO. So assume someone who pre-setup
> +		 * these mappings are more intelligent.
> +		 */
>  		if (pte_val(*pte))
> -			goto repeat_set_pte;
> +			continue;
>  
>  		if (0)
>  			printk("   pte=%p addr=%lx pte=%016lx\n",
>  			       pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
>  		pages++;
> -repeat_set_pte:
> -		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
> +		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, prot));
>  		last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
>  	}
>  
> -	if (physical_mapping_iter == 1)
> -		update_page_count(PG_LEVEL_4K, pages);
> +	update_page_count(PG_LEVEL_4K, pages);
>  
>  	return last_map_addr;
>  }
>  
>  static unsigned long __meminit
> -phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end)
> +phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end,
> +		pgprot_t prot)
>  {
>  	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
>  
> -	return phys_pte_init(pte, address, end);
> +	return phys_pte_init(pte, address, end, prot);
>  }
>  
>  static unsigned long __meminit
>  phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
> -			 unsigned long page_size_mask)
> +	      unsigned long page_size_mask, pgprot_t prot)
>  {
>  	unsigned long pages = 0;
>  	unsigned long last_map_addr = end;
> @@ -383,6 +387,7 @@
>  		unsigned long pte_phys;
>  		pmd_t *pmd = pmd_page + pmd_index(address);
>  		pte_t *pte;
> +		pgprot_t new_prot = prot;
>  
>  		if (address >= end) {
>  			if (!after_bootmem) {
> @@ -396,45 +401,58 @@
>  			if (!pmd_large(*pmd)) {
>  				spin_lock(&init_mm.page_table_lock);
>  				last_map_addr = phys_pte_update(pmd, address,
> -								end);
> +								end, prot);
>  				spin_unlock(&init_mm.page_table_lock);
>  				continue;
>  			}
> -			goto repeat_set_pte;
> +			/*
> +			 * If we are ok with PG_LEVEL_2M mapping, then we will
> +			 * use the existing mapping,
> +			 *
> +			 * Otherwise, we will split the large page mapping but
> +			 * use the same existing protection bits except for
> +			 * large page, so that we don't violate Intel's TLB
> +			 * Application note (317080) which says, while changing
> +			 * the page sizes, new and old translations should
> +			 * not differ with respect to page frame and
> +			 * attributes.
> +			 */
> +			if (page_size_mask & (1 << PG_LEVEL_2M))
> +				continue;
> +			new_prot = pte_pgprot(pte_clrhuge(* (pte_t *)pmd));
>  		}
>  
>  		if (page_size_mask & (1<<PG_LEVEL_2M)) {
>  			pages++;
> -repeat_set_pte:
>  			spin_lock(&init_mm.page_table_lock);
>  			set_pte((pte_t *)pmd,
> -				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
> +				pfn_pte(address >> PAGE_SHIFT,
> +					__pgprot(pgprot_val(prot) | _PAGE_PSE)));
>  			spin_unlock(&init_mm.page_table_lock);
>  			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
>  			continue;
>  		}
>  
>  		pte = alloc_low_page(&pte_phys);
> -		last_map_addr = phys_pte_init(pte, address, end);
> +		last_map_addr = phys_pte_init(pte, address, end, new_prot);
>  		unmap_low_page(pte);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
>  		spin_unlock(&init_mm.page_table_lock);
>  	}
> -	if (physical_mapping_iter == 1)
> -		update_page_count(PG_LEVEL_2M, pages);
> +	update_page_count(PG_LEVEL_2M, pages);
>  	return last_map_addr;
>  }
>  
>  static unsigned long __meminit
>  phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
> -			 unsigned long page_size_mask)
> +		unsigned long page_size_mask, pgprot_t prot)
>  {
>  	pmd_t *pmd = pmd_offset(pud, 0);
>  	unsigned long last_map_addr;
>  
> -	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask);
> +	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask, prot);
>  	__flush_tlb_all();
>  	return last_map_addr;
>  }
> @@ -451,6 +469,7 @@
>  		unsigned long pmd_phys;
>  		pud_t *pud = pud_page + pud_index(addr);
>  		pmd_t *pmd;
> +		pgprot_t prot = PAGE_KERNEL;
>  
>  		if (addr >= end)
>  			break;
> @@ -464,16 +483,28 @@
>  		if (pud_val(*pud)) {
>  			if (!pud_large(*pud)) {
>  				last_map_addr = phys_pmd_update(pud, addr, end,
> -							 page_size_mask);
> +							 page_size_mask, prot);
>  				continue;
>  			}
> -
> -			goto repeat_set_pte;
> +			/*
> +			 * If we are ok with PG_LEVEL_1G mapping, then we will
> +			 * use the existing mapping.
> +			 *
> +			 * Otherwise, we will split the gbpage mapping but use
> +			 * the same existing protection  bits except for large
> +			 * page, so that we don't violate Intel's TLB
> +			 * Application note (317080) which says, while changing
> +			 * the page sizes, new and old translations should
> +			 * not differ with respect to page frame and
> +			 * attributes.
> +			 */
> +			if (page_size_mask & (1 << PG_LEVEL_1G))
> +				continue;
> +			prot = pte_pgprot(pte_clrhuge(* (pte_t *)pud));
>  		}
>  
>  		if (page_size_mask & (1<<PG_LEVEL_1G)) {
>  			pages++;
> -repeat_set_pte:
>  			spin_lock(&init_mm.page_table_lock);
>  			set_pte((pte_t *)pud,
>  				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
> @@ -483,7 +514,8 @@
>  		}
>  
>  		pmd = alloc_low_page(&pmd_phys);
> -		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask);
> +		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
> +					      prot);
>  		unmap_low_page(pmd);
>  
>  		spin_lock(&init_mm.page_table_lock);
> @@ -492,8 +524,7 @@
>  	}
>  	__flush_tlb_all();
>  
> -	if (physical_mapping_iter == 1)
> -		update_page_count(PG_LEVEL_1G, pages);
> +	update_page_count(PG_LEVEL_1G, pages);
>  
>  	return last_map_addr;
>  }
> @@ -558,54 +589,15 @@
>  		direct_gbpages = 0;
>  }
>  
> -static int is_kernel(unsigned long pfn)
> -{
> -	unsigned long pg_addresss = pfn << PAGE_SHIFT;
> -
> -	if (pg_addresss >= (unsigned long) __pa(_text) &&
> -	    pg_addresss < (unsigned long) __pa(_end))
> -		return 1;
> -
> -	return 0;
> -}
> -
>  static unsigned long __init kernel_physical_mapping_init(unsigned long start,
>  						unsigned long end,
>  						unsigned long page_size_mask)
>  {
>  
> -	unsigned long next, last_map_addr;
> -	u64 cached_supported_pte_mask = __supported_pte_mask;
> -	unsigned long cache_start = start;
> -	unsigned long cache_end = end;
> -
> -	/*
> -	 * First iteration will setup identity mapping using large/small pages
> -	 * based on page_size_mask, with other attributes same as set by
> -	 * the early code in head_64.S
> -	 *
> -	 * Second iteration will setup the appropriate attributes
> -	 * as desired for the kernel identity mapping.
> -	 *
> -	 * This two pass mechanism conforms to the TLB app note which says:
> -	 *
> -	 *     "Software should not write to a paging-structure entry in a way
> -	 *      that would change, for any linear address, both the page size
> -	 *      and either the page frame or attributes."
> -	 *
> -	 * For now, only difference between very early PTE attributes used in
> -	 * head_64.S and here is _PAGE_NX.
> -	 */
> -	BUILD_BUG_ON((__PAGE_KERNEL_LARGE & ~__PAGE_KERNEL_IDENT_LARGE_EXEC)
> -		     != _PAGE_NX);
> -	__supported_pte_mask &= ~(_PAGE_NX);
> -	physical_mapping_iter = 1;
> +	unsigned long next, last_map_addr = end;
>  
> -repeat:
> -	last_map_addr = cache_end;
> -
> -	start = (unsigned long)__va(cache_start);
> -	end = (unsigned long)__va(cache_end);
> +	start = (unsigned long)__va(start);
> +	end = (unsigned long)__va(end);
>  
>  	for (; start < end; start = next) {
>  		pgd_t *pgd = pgd_offset_k(start);
> @@ -617,21 +609,11 @@
>  			next = end;
>  
>  		if (pgd_val(*pgd)) {
> -			/*
> -			 * Static identity mappings will be overwritten
> -			 * with run-time mappings. For example, this allows
> -			 * the static 0-1GB identity mapping to be mapped
> -			 * non-executable with this.
> -			 */
> -			if (is_kernel(pte_pfn(*((pte_t *) pgd))))
> -				goto realloc;
> -
>  			last_map_addr = phys_pud_update(pgd, __pa(start),
>  						 __pa(end), page_size_mask);
>  			continue;
>  		}
>  
> -realloc:
>  		pud = alloc_low_page(&pud_phys);
>  		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
>  						 page_size_mask);
> @@ -643,15 +625,6 @@
>  	}
>  	__flush_tlb_all();
>  
> -	if (physical_mapping_iter == 1) {
> -		physical_mapping_iter = 2;
> -		/*
> -		 * Second iteration will set the actual desired PTE attributes.
> -		 */
> -		__supported_pte_mask = cached_supported_pte_mask;
> -		goto repeat;
> -	}
> -
>  	return last_map_addr;
>  }
>  
>   

