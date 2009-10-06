Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbZJFV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbZJFV6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbZJFV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:58:54 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:41240 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbZJFV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:58:54 -0400
X-Trace: 271005612/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.109.156/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.109.156
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsFAA9ay0pPRW2c/2dsb2JhbACBUtMLhCoEgVM
X-IronPort-AV: E=Sophos;i="4.44,515,1249254000"; 
   d="scan'208";a="271005612"
Date: Tue, 6 Oct 2009 22:58:03 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Jan Beulich <JBeulich@novell.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust gfp mask passed on nested vmalloc() invocation
In-Reply-To: <4AC9E38E0200007800017F57@vpn.id2.novell.com>
Message-ID: <Pine.LNX.4.64.0910062241500.21409@sister.anvils>
References: <4AC9E38E0200007800017F57@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Jan Beulich wrote:

> - fix a latent bug resulting from blindly or-ing in __GFP_ZERO, since
>   the combination of this and __GFP_HIGHMEM (possibly passed into the
>   function) is forbidden in interrupt context
> - avoid wasting more precious resources (DMA or DMA32 pools), when
>   being called through vmalloc_32{,_user}()
> - explicitly allow using high memory here even if the outer allocation
>   request doesn't allow it, unless is collides with __GFP_ZERO
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

I thought vmalloc.c was a BUG_ON(in_interrupt()) zone?
The locking is all spin_lock stuff, not spin_lock_irq stuff.
That's probably why your "bug" has remained "latent".

Using HIGHMEM for internal arrays looks reasonable to me; but if
__GFP_ZERO were a problem, wouldn't it be much cleaner to skip the
"unless it collides" and #ifdef CONFIG_HIGHMEM !in_interrupt() stuff,
just memset the array returned from __vmalloc_node()?

Hugh

> 
> ---
>  mm/vmalloc.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.32-rc3/mm/vmalloc.c	2009-10-05 11:59:56.000000000 +0200
> +++ 2.6.32-rc3-vmalloc-nested-gfp/mm/vmalloc.c	2009-10-05 08:40:36.000000000 +0200
> @@ -1410,6 +1410,7 @@ static void *__vmalloc_area_node(struct 
>  {
>  	struct page **pages;
>  	unsigned int nr_pages, array_size, i;
> +	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
>  
>  	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
>  	array_size = (nr_pages * sizeof(struct page *));
> @@ -1417,13 +1418,16 @@ static void *__vmalloc_area_node(struct 
>  	area->nr_pages = nr_pages;
>  	/* Please note that the recursion is strictly bounded. */
>  	if (array_size > PAGE_SIZE) {
> -		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
> +#ifdef CONFIG_HIGHMEM
> +		/* See the comment in prep_zero_page(). */
> +		if (!in_interrupt())
> +			nested_gfp |= __GFP_HIGHMEM;
> +#endif
> +		pages = __vmalloc_node(array_size, nested_gfp,
>  				PAGE_KERNEL, node, caller);
>  		area->flags |= VM_VPAGES;
>  	} else {
> -		pages = kmalloc_node(array_size,
> -				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
> -				node);
> +		pages = kmalloc_node(array_size, nested_gfp, node);
>  	}
>  	area->pages = pages;
>  	area->caller = caller;
