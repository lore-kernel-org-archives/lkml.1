Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZJGN4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZJGN4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbZJGN43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:56:29 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:32931 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803AbZJGN43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:56:29 -0400
X-Trace: 267412527/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.16.54/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.16.54
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAFc6zEpQKRA2/2dsb2JhbACBUtRhhCoEgVQ
X-IronPort-AV: E=Sophos;i="4.44,519,1249254000"; 
   d="scan'208";a="267412527"
Date: Wed, 7 Oct 2009 14:55:40 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Jan Beulich <JBeulich@novell.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust gfp mask passed on nested vmalloc() invocation 
 (v2)
In-Reply-To: <4ACCA98202000078000187DF@vpn.id2.novell.com>
Message-ID: <Pine.LNX.4.64.0910071451090.4695@sister.anvils>
References: <4ACCA98202000078000187DF@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Jan Beulich wrote:

> - avoid wasting more precious resources (DMA or DMA32 pools), when
>   being called through vmalloc_32{,_user}()
> - explicitly allow using high memory here even if the outer allocation
>   request doesn't allow it, unless is collides with __GFP_ZERO
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                            that's no longer an issue in the patch
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The patch looks good to me now, much nicer, thanks:
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> 
> ---
>  mm/vmalloc.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.32-rc3/mm/vmalloc.c	2009-10-05 11:59:56.000000000 +0200
> +++ 2.6.32-rc3-vmalloc-nested-gfp/mm/vmalloc.c	2009-10-07 14:39:38.000000000 +0200
> @@ -1410,6 +1410,7 @@ static void *__vmalloc_area_node(struct 
>  {
>  	struct page **pages;
>  	unsigned int nr_pages, array_size, i;
> +	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
>  
>  	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
>  	array_size = (nr_pages * sizeof(struct page *));
> @@ -1417,13 +1418,11 @@ static void *__vmalloc_area_node(struct 
>  	area->nr_pages = nr_pages;
>  	/* Please note that the recursion is strictly bounded. */
>  	if (array_size > PAGE_SIZE) {
> -		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
> +		pages = __vmalloc_node(array_size, nested_gfp | __GFP_HIGHMEM,
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
