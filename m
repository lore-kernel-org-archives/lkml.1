Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYBKRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYBKRVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYBKRVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:21:38 -0500
Received: from www.tglx.de ([62.245.132.106]:46792 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYBKRVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:21:37 -0500
Date: Mon, 11 Feb 2008 18:21:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/1] CPA: Flush the caches when setting pages not
 present v2
In-Reply-To: <20080211216.571751871@suse.de>
Message-ID: <alpine.LFD.1.00.0802111803290.12988@apollo.tec.linutronix.de>
References: <20080211216.571751871@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:
> The AMD64 pci-gart code sets pages not present to prevent
> cache coherency problems.  When doing this it is safer to flush the 
> caches too so that there are no cache lines left over from when 
> the pages were still mapped. 
> 
> So consider clearing of the present bit as a cache flush indicator.
>
> Note that debug pagealloc marks pages regularly not present either, but it won't
> call this because it calls directly into a lower level function.
> 
> I have not actually seen failures from this, but it seems safer 
> to do it this way.
> 
> v2: Force WBINVD in this case because CLFLUSH does not work for !P pages.
>     Improve description slightly.

This is suboptimal though, as it will trigger a wbinvd() everytime
when we hit a non present pte in a range, whether we did set the entry
in question to not present or not.

The gart code unmapping is a special case. This only happens during
boot, so adding a wbinvd() to the gart code is solving this issue
without imposing it on other use cases.

Another solution for this would be to change the mapping to uncached
before unmapping, so we could avoid the wbinvd() completely.

index 65f6acb..bccdf14 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -749,6 +749,10 @@ void __init gart_iommu_init(void)
 	 */
 	set_memory_np((unsigned long)__va(iommu_bus_base),
 				iommu_size >> PAGE_SHIFT);
+	/*
+	 * Flush caches, so we do not have stale cachelines around:
+	 */
+	wbinvd();
 
 	/*
 	 * Try to workaround a bug (thanks to BenH)

Thanks,
	tglx
 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/pageattr.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pageattr.c
> +++ linux/arch/x86/mm/pageattr.c
> @@ -122,6 +122,14 @@ static void cpa_flush_range(unsigned lon
>  		 */
>  		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
>  			clflush_cache_range((void *) addr, PAGE_SIZE);
> +		else {
> +			/*
> +			 * Make sure there are no left overs of pages
> +			 * set non present in the cache.
> +			 */
> +			cpa_flush_all(cache);
> +			return;
> +		}
>  	}
>  }
>  
> @@ -670,9 +678,16 @@ static int __change_page_attr_set_clr(st
>  	return 0;
>  }
>  
> -static inline int cache_attr(pgprot_t attr)
> +static inline int cache_attr(pgprot_t set, pgprot_t clr)
>  {
> -	return pgprot_val(attr) &
> +	/*
> +	 * Clearing pages is usually done for cache cohereny reasons
> +	 * (except for pagealloc debug, but that doesn't call this anyways)
> +	 * It's safer to flush the caches in this case too.
> +	 */
> +	if (pgprot_val(clr) & _PAGE_PRESENT)
> +		return 1;
> +	return pgprot_val(set) &
>  		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
>  }
>  
> @@ -709,7 +724,7 @@ static int change_page_attr_set_clr(unsi
>  	 * No need to flush, when we did not set any of the caching
>  	 * attributes:
>  	 */
> -	cache = cache_attr(mask_set);
> +	cache = cache_attr(mask_set, mask_clr);
>  
>  	/*
>  	 * On success we use clflush, when the CPU supports it to
> 
