Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbZFBF5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbZFBF5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbZFBF5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:57:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317AbZFBF5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:57:36 -0400
Date: Mon, 1 Jun 2009 22:56:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090601225602.3482cd0d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 18:31:14 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_alloc.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
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
> @@ -1765,11 +1765,13 @@ rebalance:
>  				goto got_pg;
>  
>  			/*
> -			 * The OOM killer does not trigger for high-order allocations
> -			 * but if no progress is being made, there are no other
> -			 * options and retrying is unlikely to help
> +			 * The OOM killer does not trigger for high-order
> +			 * ~__GFP_NOFAIL allocations so if no progress is being
> +			 * made, there are no other options and retrying is
> +			 * unlikely to help.
>  			 */
> -			if (order > PAGE_ALLOC_COSTLY_ORDER)
> +			if (order > PAGE_ALLOC_COSTLY_ORDER &&
> +						!(gfp_mask & __GFP_NOFAIL))
>  				goto nopage;
>  
>  			goto restart;

I really think/hope/expect that this is unneeded.

Do we know of any callsites which do greater-than-order-0 allocations
with GFP_NOFAIL?  If so, we should fix them.

Then just ban order>0 && GFP_NOFAIL allocations.
