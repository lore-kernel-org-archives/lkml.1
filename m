Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZEKKkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZEKKkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZEKKkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:40:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60748 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbZEKKkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:40:32 -0400
Date: Mon, 11 May 2009 11:40:29 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-ID: <20090511104029.GB19847@csn.ul.ie>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 03:46:39PM -0700, David Rientjes wrote:
> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_alloc.c |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1547,7 +1547,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  		goto out;
>  
>  	/* The OOM killer will not help higher order allocs */
> -	if (order > PAGE_ALLOC_COSTLY_ORDER)
> +	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
>  		goto out;
>  
>  	/* Exhausted what can be done so it's blamo time */
> @@ -1763,16 +1763,12 @@ rebalance:
>  					migratetype);
>  			if (page)
>  				goto got_pg;
> +			if ((gfp_mask & __GFP_NOFAIL) ||
> +					order <= PAGE_ALLOC_COSTLY_ORDER)
> +				goto restart;
>  

Can this get a comment explaining the intention like the code you are
removing had? Something like this?

/*
 * The OOM killer only triggers for lower order allocation
 * requests and when __GFP_NOFAIL is specified to prevent
 * endlessly looping. Only retry the allocation if the OOM
 * killer was used.
 */

Otherwise, it looks ok.

Acked-by: Mel Gorman <mel@csn.ul.ie>

One related question, what is doing a costly-high-order allocation request
with __GFP_NOFAIL specified?

> -			/*
> -			 * The OOM killer does not trigger for high-order allocations
> -			 * but if no progress is being made, there are no other
> -			 * options and retrying is unlikely to help
> -			 */
> -			if (order > PAGE_ALLOC_COSTLY_ORDER)
> -				goto nopage;
> -
> -			goto restart;
> +			/* No freeing is possible so just fail */
> +			goto nopage;


>  		}
>  	}
>  
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
