Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYB0RoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYB0RoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYB0RoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:44:15 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55889 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbYB0RoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:44:14 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Dave Hansen <haveblue@us.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
In-Reply-To: <20080226202533.GD5963@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com>
	 <1203733096.14838.154.camel@cinder.waste.org>
	 <1203791461.11305.135.camel@nimitz.home.sr71.net>
	 <20080225120951.GA5963@escobedo.amd.com>
	 <1203964750.28196.7.camel@nimitz.home.sr71.net>
	 <20080226202533.GD5963@escobedo.amd.com>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 09:44:04 -0800
Message-Id: <1204134244.5207.28.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 21:25 +0100, Hans Rosenfeld wrote:
> On Mon, Feb 25, 2008 at 10:39:10AM -0800, Dave Hansen wrote:
> > Did you read my suggestion?  We use one bit in the pte to specify that
> > its a large page mapping, then specify a mask to apply to the address to
> > get the *first* mapping of the large page, where you're find the actual
> > physical address.  That keeps us from having to worry about specifying
> > *both* the page size and the pfn in the same pte.
> 
> I did read it, but I don't see the point. I think we have enough bits in
> that pseudo pte to include both the page size and the address/pfn.

I'm just worried that once we establish the format, we can't really
change it.  We have enough room in the pseudo-pte now, but what happens
when the next group of people pop up that want something else from this
interface.  Right now we have normal memory, swap, and hugetlb pages.

What if people want migration ptes marked next?  I'm not sure those fit
into what you have here.

It all fits today, I'm just worried about tomorrow. :(

> +static int add_huge_to_pagemap(unsigned long addr, unsigned long end,
> +			       struct pagemap_ppte ppte, struct pagemapread *pm)
> +{
> +	int err;
> +
> +	for (; addr != end; addr += PAGE_SIZE) {
> +		err = add_to_pagemap(addr, ppte, pm);
> +		if (err)
> +			return err;
> +	}
> +}
> +	
>  static int pagemap_pte_hole(unsigned long start, unsigned long end,
>  				void *private)
>  {
> @@ -574,7 +581,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
>  u64 swap_pte_to_pagemap_entry(pte_t pte)
>  {
>  	swp_entry_t e = pte_to_swp_entry(pte);
> -	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> +	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
>  }

Is there any way to do unions of bitfields?  It seems a bit silly that
we have this bitfield, and then subdivide the bitfield for the swap
entries.  

>  static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> @@ -584,16 +591,23 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	int err = 0;
> 
> -	for (; addr != end; addr += PAGE_SIZE) {
> -		u64 pfn = PM_NOT_PRESENT;
> +	if (pmd_huge(*pmd))
> +		add_huge_to_pagemap(addr, end, pmd_to_ppte(pmd), pm);

Could you make this work with other architectures' large pages as well?
I'd hate to leave ia64, MIPS and powerpc out in the cold.  powerpc at
least has large pmds, it just doesn't really expose them to generic
code.  

> +	else	for (; addr != end; addr += PAGE_SIZE) {
> +		struct pagemap_ppte ppte = { 0, 0, 0, 0};

Didn't you define a macro for this above?  Can you re-use it?

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
> +			ppte.pshift = PAGE_SHIFT;
> +			ppte.paddr = pte_pfn(*pte) << PAGE_SHIFT;
> +		}

Why do we bother wasting space in paddr by shifting up the physical
address?  We know the bottom PAGE_SHIFT bits are empty, so doesn't this
just waste them?

The bitfields are nice, and I do see they've spread to generic code.
So, I won't object to them, but please do double-check that they don't
cause any problems, especially with compilers that you might not be
using.

>  		/* unmap so we're not in atomic when we copy to userspace */
>  		pte_unmap(pte);
> -		err = add_to_pagemap(addr, pfn, pm);
> +		err = add_to_pagemap(addr, ppte, pm);
>  		if (err)
>  			return err;
>  	}
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 44ef329..d7df89d 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -195,6 +195,12 @@ static inline int pmd_none_or_clear_bad(pmd_t *pmd)
>  	}
>  	return 0;
>  }
> +
> +/* dummy for !x86 */
> +#ifndef pmd_to_ppte
> +#define pmd_to_ppte(x) ((struct pagemap_ppte) {0, 0, 0, 0})
> +#endif

I'm really not a fan of the #ifndef style for these headers.  I think it
makes it really hard to figure out where definitions come from.  

I do think it would be best to keep al the ppte stuff isolated to the
pagemap files as much as humanly possible.  There's not much of a reason
to pollute these generic (and already full) headers with our /proc
crap. :)

>  #endif /* CONFIG_MMU */
> 
>  /*
> diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
> index 174b877..7a446e0 100644
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
> @@ -242,6 +244,20 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
> 
>  #ifndef __ASSEMBLY__
> 
> +#include <linux/pagemap_ppte.h>
> +
> +static inline struct pagemap_ppte pmd_to_ppte(pmd_t *pmd)
> +{
> +	struct pagemap_ppte ppte = {
> +		.paddr   = pmd_pfn(*pmd) << PAGE_SHIFT,
> +		.pshift  = HPAGE_SHIFT,
> +		.swap    = 0,
> +		.present = 1,
> +	};
> +
> +	return ppte;
> +}

Could you investigate this a bit on the other architectures and perhaps
code up something that will at least compile on the others and not just
punt?  I just want to make sure that this approach can be extended to
them easily and we don't have to rewrite it. :)

My only other concern is that we're still wobbling on this interface and
it's about to get mainline-released.  Should we turn it off in mainline
so that we don't establish an ABI that we know we're going to change
shortly anyway?

-- Dave

