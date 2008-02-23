Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYBWCSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYBWCSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbYBWCSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:18:38 -0500
Received: from waste.org ([66.93.16.53]:35900 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbYBWCSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:18:37 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Matt Mackall <mpm@selenic.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, haveblue@us.ibm.com
In-Reply-To: <20080220135743.GA10127@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 10:18:16 +0800
Message-Id: <1203733096.14838.154.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the delay, travelling)

On Wed, 2008-02-20 at 14:57 +0100, Hans Rosenfeld wrote:
> The current code for /proc/pid/pagemap does not work with huge pages (on
> x86). The code will make no difference between a normal pmd and a huge
> page pmd, trying to parse the contents of the huge page as ptes. Another
> problem is that there is no way to get information about the page size a
> specific mapping uses.
> 
> Also, the current way the "not present" and "swap" bits are encoded in
> the returned pfn isn't very clean, especially not if this interface is
> going to be extended.

Fair.

> I propose to change /proc/pid/pagemap to return a pseudo-pte instead of
> just a raw pfn. The pseudo-pte will contain:
> 
> - 58 bits for the physical address of the first byte in the page, even
>   less bits would probably be sufficient for quite a while
> 
> - 4 bits for the page size, with 0 meaning native page size (4k on x86,
>   8k on alpha, ...) and values 1-15 being specific to the architecture
>   (I used 1 for 2M, 2 for 4M and 3 for 1G for x86)
> 
> - a "swap" bit indicating that a not present page is paged out, with the
>   physical address field containing page file number and block number
>   just like before
> 
> - a "present" bit just like in a real pte

This is ok-ish, but I can't say I like it much. Especially the page size
field.

But I don't really have many ideas here. Perhaps having a bit saying
"this entry is really a continuation of the previous one". Then any page
size can be trivially represented. This might also make the code on both
sides simpler?
  
> By shortening the field for the physical address, some more interesting
> information could be included, like read/write permissions and the like.
> The page size could also be returned directly, 6 bits could be used to
> express any page shift in a 64 bit system, but I found the encoded page
> size more useful for my specific use case.
> 
> 
> The attached patch changes the /proc/pid/pagemap code to use such a
> pseudo-pte. The huge page handling is currently limited to 2M/4M pages
> on x86, 1G pages will need some more work. To keep the simple mapping of
> virtual addresses to file index intact, any huge page pseudo-pte is
> replicated in the user buffer to map the equivalent range of small
> pages. 
> 
> Note that I had to move the pmd_pfn() macro from asm-x86/pgtable_64.h to
> asm-x86/pgtable.h, it applies to both 32 bit and 64 bit x86.
> 
> Other architectures will probably need other changes to support huge
> pages and return the page size.
> 
> I think that the definition of the pseudo-pte structure and the page
> size codes should be made available through a header file, but I didn't
> do this for now.
> 
> Signed-Off-By: Hans Rosenfeld <hans.rosenfeld@amd.com>
> 
> ---
>  fs/proc/task_mmu.c           |   68 +++++++++++++++++++++++++++++------------
>  include/asm-x86/pgtable.h    |    2 +
>  include/asm-x86/pgtable_64.h |    1 -
>  3 files changed, 50 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 49958cf..58af588 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -527,16 +527,23 @@ struct pagemapread {
>  	char __user *out, *end;
>  };
>  
> -#define PM_ENTRY_BYTES sizeof(u64)
> -#define PM_RESERVED_BITS    3
> -#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
> -#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
> -#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
> -#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
> -#define PM_SWAP             PM_SPECIAL(2LL)
> -#define PM_END_OF_BUFFER    1
> -
> -static int add_to_pagemap(unsigned long addr, u64 pfn,
> +struct ppte {
> +	uint64_t paddr:58;
> +	uint64_t psize:4;
> +	uint64_t swap:1;
> +	uint64_t present:1;
> +};
> +
> +#ifdef CONFIG_X86
> +#define PM_PSIZE_1G      3
> +#define PM_PSIZE_4M      2
> +#define PM_PSIZE_2M      1
> +#endif
> +
> +#define PM_ENTRY_BYTES   sizeof(struct ppte)
> +#define PM_END_OF_BUFFER 1
> +
> +static int add_to_pagemap(unsigned long addr, struct ppte ppte,
>  			  struct pagemapread *pm)
>  {
>  	/*
> @@ -545,13 +552,13 @@ static int add_to_pagemap(unsigned long addr, u64 pfn,
>  	 * the pfn.
>  	 */
>  	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
> -		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
> +		if (copy_to_user(pm->out, &ppte, pm->end - pm->out))
>  			return -EFAULT;
>  		pm->out = pm->end;
>  		return PM_END_OF_BUFFER;
>  	}
>  
> -	if (put_user(pfn, pm->out))
> +	if (copy_to_user(pm->out, &ppte, sizeof(ppte)))
>  		return -EFAULT;
>  	pm->out += PM_ENTRY_BYTES;
>  	return 0;
> @@ -564,7 +571,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
>  	unsigned long addr;
>  	int err = 0;
>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
> -		err = add_to_pagemap(addr, PM_NOT_PRESENT, pm);
> +		err = add_to_pagemap(addr, (struct ppte) {0, 0, 0, 0}, pm);
>  		if (err)
>  			break;
>  	}
> @@ -574,7 +581,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
>  u64 swap_pte_to_pagemap_entry(pte_t pte)
>  {
>  	swp_entry_t e = pte_to_swp_entry(pte);
> -	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> +	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
>  }
>  
>  static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> @@ -584,16 +591,37 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	int err = 0;
>  
> +#ifdef CONFIG_X86
> +	if (pmd_huge(*pmd)) {
> +		struct ppte ppte = { 
> +			.paddr = pmd_pfn(*pmd) << PAGE_SHIFT,
> +			.psize = (HPAGE_SHIFT == 22 ?
> +				  PM_PSIZE_4M : PM_PSIZE_2M),
> +			.swap  = 0,
> +			.present = 1,
> +		};
> +
> +		for(; addr != end; addr += PAGE_SIZE) {
> +			err = add_to_pagemap(addr, ppte, pm);
> +			if (err)
> +				return err;
> +		}
> +	} else
> +#endif
>  	for (; addr != end; addr += PAGE_SIZE) {
> -		u64 pfn = PM_NOT_PRESENT;
> +		struct ppte ppte = { 0, 0, 0, 0};
> +
>  		pte = pte_offset_map(pmd, addr);
> -		if (is_swap_pte(*pte))
> -			pfn = swap_pte_to_pagemap_entry(*pte);
> -		else if (pte_present(*pte))
> -			pfn = pte_pfn(*pte);
> +		if (is_swap_pte(*pte)) {
> +			ppte.swap = 1;
> +			ppte.paddr = swap_pte_to_pagemap_entry(*pte);
> +		} else if (pte_present(*pte)) {
> +			ppte.present = 1;
> +			ppte.paddr = pte_pfn(*pte) << PAGE_SHIFT;
> +		}
>  		/* unmap so we're not in atomic when we copy to userspace */
>  		pte_unmap(pte);
> -		err = add_to_pagemap(addr, pfn, pm);
> +		err = add_to_pagemap(addr, ppte, pm);
>  		if (err)
>  			return err;
>  	}
> diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
> index 174b877..76bc8a8 100644
> --- a/include/asm-x86/pgtable.h
> +++ b/include/asm-x86/pgtable.h
> @@ -181,6 +181,8 @@ static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
>  		      pgprot_val(pgprot)) & __supported_pte_mask);
>  }
>  
> +#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
> +
>  static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  {
>  	pteval_t val = pte_val(pte);
> diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
> index 02bd4aa..094a538 100644
> --- a/include/asm-x86/pgtable_64.h
> +++ b/include/asm-x86/pgtable_64.h
> @@ -216,7 +216,6 @@ static inline int pud_large(pud_t pte)
>  #define pmd_none(x)	(!pmd_val(x))
>  #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
>  #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
> -#define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
>  
>  #define pte_to_pgoff(pte) ((pte_val(pte) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
>  #define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) | _PAGE_FILE })
> -- 
> 1.5.3.7
> 
-- 
Mathematics is the supreme nostalgia of our time.

