Return-Path: <linux-kernel-owner+w=401wt.eu-S936125AbYBWITa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936125AbYBWITa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765795AbYBWIJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:29 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763879AbYBWII7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:59 -0500
Date: Sat, 23 Feb 2008 00:06:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hans Rosenfeld" <hans.rosenfeld@amd.com>
Cc: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
 return page size
Message-Id: <20080223000626.9df16d25.akpm@linux-foundation.org>
In-Reply-To: <20080220135743.GA10127@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 14:57:43 +0100 "Hans Rosenfeld" <hans.rosenfeld@amd.com> wrote:

> The current code for /proc/pid/pagemap does not work with huge pages (on
> x86). The code will make no difference between a normal pmd and a huge
> page pmd, trying to parse the contents of the huge page as ptes. Another
> problem is that there is no way to get information about the page size a
> specific mapping uses.
> 
> Also, the current way the "not present" and "swap" bits are encoded in
> the returned pfn isn't very clean, especially not if this interface is
> going to be extended.
> 
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
>   
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

If we're going to do this, we need to do it *fast*.  Once 2.6.25 goes out
our hands are tied.

That means talking with the maintainers of other hugepage-capable
architectures.

> +struct ppte {
> +	uint64_t paddr:58;
> +	uint64_t psize:4;
> +	uint64_t swap:1;
> +	uint64_t present:1;
> +};

This is part of the exported kernel interface and hence should be in a
header somewhere, shouldn't it?  The old stuff should have been too.

u64 is a bit more conventional than uint64_t, and if we move this to a
userspace-visible header then __u64 is the type to use, I think.  Although
one would expect uint64_t to be OK as well.

> +#ifdef CONFIG_X86
> +#define PM_PSIZE_1G      3
> +#define PM_PSIZE_4M      2
> +#define PM_PSIZE_2M      1
> +#endif

No, we should factor this correctly and get the CONFIG_X86 stuff out of here.

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

You can remove the ifdefs here and then for each hugepage-capable
architecture add a 

	struct ppte pmd_to_ppte(pmd_t *pmd);

and call that.  Something like that.

ppte isn't a very well-chosen name, especially if we export this to
userspace.

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

Matt?  Help?
