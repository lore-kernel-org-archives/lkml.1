Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZF3Tga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZF3Tga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZF3TgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:36:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbZF3TgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:36:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cCGIhjvHqPhbeBmTRFmThFrgo1laSlNWDCPW2QPVJxbAnKexl/KR73sIyUlqKMFo2
	vp8t1rx9Nw8OrjJon7GqA==
Date: Tue, 30 Jun 2009 12:35:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, arjan@infradead.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090630110011.GB17561@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0906301216180.16312@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie>
 <20090629122029.93cdcc39.akpm@linux-foundation.org> <20090630110011.GB17561@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Mel Gorman wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 175a67a..5f4656e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -230,14 +230,21 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>  		/*
>  		 * This task already has access to memory reserves and is
>  		 * being killed. Don't allow any other task access to the
> -		 * memory reserve.
> +		 * memory reserve unless the current process is the one
> +		 * selected for OOM-killing. If the current process has
> +		 * been OOM-killed and we are OOM again, another process
> +		 * needs to be considered for OOM-kill
>  		 *
>  		 * Note: this may have a chance of deadlock if it gets
>  		 * blocked waiting for another task which itself is waiting
>  		 * for memory. Is there a better alternative?
>  		 */
> -		if (test_tsk_thread_flag(p, TIF_MEMDIE))
> -			return ERR_PTR(-1UL);
> +		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
> +			if (p == current)
> +				continue;
> +			else
> +				return ERR_PTR(-1UL);
> +		}
>  
>  		/*
>  		 * This is in the process of releasing memory so wait for it

This will panic the machine if current is the only user thread running or 
eligible for oom kill (all others could have mm's with OOM_DISABLE set).  
Currently, such tasks can exit or kthreads can free memory so that the oom 
is recoverable.

The problem with this approach is that it increases the liklihood that 
memory reserves will be totally depleted when several threads are 
competing for them.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5d714f8..5896469 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1539,6 +1539,14 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
>  	if (gfp_mask & __GFP_NORETRY)
>  		return 0;
>  
> +	/* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
> +	if (test_thread_flag(TIF_MEMDIE)) {
> +		if (gfp_mask & __GFP_NOFAIL)
> +			WARN(1, "Potential infinite loop with __GFP_NOFAIL");
> +		else
> +			return 0;
> +	}
> +

There's a second bug in the refactored page allocator: when the oom killer 
is invoked and it happens to kill current, alloc_flags is never updated 
because it loops back to `restart', which is past gfp_to_alloc_flags().

When that is fixed with the patch below, gfp_mask & __GFP_NOFAIL will 
never be true here in your scenario, where the oom killer kills current, 
because __alloc_pages_high_priority() will infinitely loop.

>  	/*
>  	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
>  	 * means __GFP_NOFAIL, but that may not be true in other
> 

This is needed for 2.6.31-rc2.


mm: update alloc_flags after oom killer has been called

It is possible for the oom killer to select current as the task to kill.  
When this happens, alloc_flags needs to be updated accordingly to set 
ALLOC_NO_WATERMARKS so the subsequent allocation attempt may use memory 
reserves as the result of its thread having TIF_MEMDIE set if the 
allocation is not __GFP_NOMEMALLOC.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1756,6 +1756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
+restart:
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
@@ -1763,7 +1764,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-restart:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
