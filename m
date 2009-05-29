Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZE2VwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZE2VwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZE2VwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:52:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41498 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194AbZE2VwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:52:08 -0400
Date: Fri, 29 May 2009 22:52:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
Message-ID: <20090529225243.000642de@lxorguk.ukuu.org.uk>
In-Reply-To: <20090529213526.5B9EB1D028F@basil.firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
	<20090529213526.5B9EB1D028F@basil.firstfloor.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 23:35:26 +0200 (CEST)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Hardware poisoned pages need special handling in the VM and shouldn't be 
> touched again. This requires a new page flag. Define it here.
> 
> The page flags wars seem to be over, so it shouldn't be a problem
> to get a new one.
> 
> v2: Add TestSetHWPoison (suggested by Johannes Weiner)
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/page-flags.h |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/page-flags.h
> ===================================================================
> --- linux.orig/include/linux/page-flags.h	2009-05-29 23:32:10.000000000 +0200
> +++ linux/include/linux/page-flags.h	2009-05-29 23:32:10.000000000 +0200
> @@ -51,6 +51,9 @@
>   * PG_buddy is set to indicate that the page is free and in the buddy system
>   * (see mm/page_alloc.c).
>   *
> + * PG_hwpoison indicates that a page got corrupted in hardware and contains
> + * data with incorrect ECC bits that triggered a machine check. Accessing is
> + * not safe since it may cause another machine check. Don't touch!
>   */
>  
>  /*
> @@ -104,6 +107,9 @@
>  #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
>  	PG_uncached,		/* Page has been mapped as uncached */
>  #endif
> +#ifdef CONFIG_MEMORY_FAILURE
> +	PG_hwpoison,		/* hardware poisoned page. Don't touch */
> +#endif
>  	__NR_PAGEFLAGS,
>  
>  	/* Filesystems */
> @@ -273,6 +279,15 @@
>  PAGEFLAG_FALSE(Uncached)
>  #endif
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +PAGEFLAG(HWPoison, hwpoison)
> +TESTSETFLAG(HWPoison, hwpoison)
> +#define __PG_HWPOISON (1UL << PG_hwpoison)
> +#else
> +PAGEFLAG_FALSE(HWPoison)
> +#define __PG_HWPOISON 0
> +#endif
> +
>  static inline int PageUptodate(struct page *page)
>  {
>  	int ret = test_bit(PG_uptodate, &(page)->flags);
> @@ -403,7 +418,7 @@
>  	 1 << PG_private | 1 << PG_private_2 | \
>  	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
>  	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
> -	 __PG_UNEVICTABLE | __PG_MLOCKED)
> +	 __PG_HWPOISON  | __PG_UNEVICTABLE | __PG_MLOCKED)
>  
>  /*
>   * Flags checked when a page is prepped for return by the page allocator.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
