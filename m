Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZDHA3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZDHA3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZDHA3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:29:45 -0400
Received: from relay3.sgi.com ([192.48.156.57]:37800 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbZDHA3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:29:44 -0400
Date: Tue, 7 Apr 2009 19:29:41 -0500
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
       rja@sgi.com
Subject: Re: [PATCH] [2/16] POISON: Add page flag for poisoned pages
Message-ID: <20090408002941.GA14041@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20090407509.382219156@firstfloor.org> <20090407150958.BA68F1D046D@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407150958.BA68F1D046D@basil.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 05:09:58PM +0200, Andi Kleen wrote:
> 
> Poisoned pages need special handling in the VM and shouldn't be touched 
> again. This requires a new page flag. Define it here.
> 
> The page flags wars seem to be over, so it shouldn't be a problem
> to get a new one. I hope.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/page-flags.h |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/page-flags.h
> ===================================================================
> --- linux.orig/include/linux/page-flags.h	2009-04-07 16:39:27.000000000 +0200
> +++ linux/include/linux/page-flags.h	2009-04-07 16:39:39.000000000 +0200
> @@ -51,6 +51,9 @@
>   * PG_buddy is set to indicate that the page is free and in the buddy system
>   * (see mm/page_alloc.c).
>   *
> + * PG_poison indicates that a page got corrupted in hardware and contains
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

Is it necessary to have this under CONFIG_MEMORY_FAILURE?

> +	PG_poison,		/* poisoned page. Don't touch */
> +#endif
>  	__NR_PAGEFLAGS,
>  
>  	/* Filesystems */
> @@ -273,6 +279,14 @@
>  PAGEFLAG_FALSE(Uncached)
>  #endif
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +PAGEFLAG(Poison, poison)
> +#define __PG_POISON (1UL << PG_poison)
> +#else
> +PAGEFLAG_FALSE(Poison)
> +#define __PG_POISON 0
> +#endif
> +
>  static inline int PageUptodate(struct page *page)
>  {
>  	int ret = test_bit(PG_uptodate, &(page)->flags);
> @@ -403,7 +417,7 @@
>  	 1 << PG_private | 1 << PG_private_2 | \
>  	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
>  	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
> -	 __PG_UNEVICTABLE | __PG_MLOCKED)
> +	 __PG_POISON  | __PG_UNEVICTABLE | __PG_MLOCKED)
>  
>  /*
>   * Flags checked when a page is prepped for return by the page allocator.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
