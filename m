Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbZGPTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbZGPTOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbZGPTOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:14:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbZGPTOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:14:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NRqLVnZWdm/jZ13v1ODS6CNEcR9QIobH7UD7p7pHTQNKGPIGnWAYIwdfz2wY5LAcD
	k1Up7nzD+iWp2Avq9enXw==
Date: Thu, 16 Jul 2009 12:14:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] page-allocator: Ensure that processes that have been
 OOM killed exit the page allocator (resend)
In-Reply-To: <20090716110328.GB22499@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0907161202500.27201@chino.kir.corp.google.com>
References: <20090715104944.GC9267@csn.ul.ie> <alpine.DEB.2.00.0907151326350.22582@chino.kir.corp.google.com> <20090716110328.GB22499@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Mel Gorman wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4b8552e..b381a6b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1830,8 +1830,6 @@ rebalance:
>  			if (order > PAGE_ALLOC_COSTLY_ORDER &&
>  						!(gfp_mask & __GFP_NOFAIL))
>  				goto nopage;
> -
> -			goto restart;
>  		}
>  	}
>  
> 

This isn't right (and not only because it'll add a compiler warning 
because `restart' is now unused).

This would immediately fail any allocation that triggered the oom killer 
and ended up being selected that isn't __GFP_NOFAIL, even if it would have 
succeeded without even killing any task simply because it allocates 
without watermarks.

It will also, coupled with your earlier patch, inappropriately warn about 
an infinite loop with __GFP_NOFAIL even though it hasn't even attempted to 
loop once since that decision is now handled by should_alloc_retry().

The liklihood of such an infinite loop, considering only one thread per 
system (or cpuset) can be TIF_MEMDIE at a time, is very low.  I've never 
seen memory reserves completely depleted such that the next high-priority 
allocation wouldn't succeed so that current could handle its pending 
SIGKILL.

You get the same behavior with my patch, but are allowed to try the high 
priority allocation again for the attempt that triggered the oom killer 
(and not only subsequent ones).
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1789,6 +1789,10 @@ rebalance:
 	if (p->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* Avoid allocations with no watermarks from looping endlessly */
+	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
