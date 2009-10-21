Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZJUVGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZJUVGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZJUVGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:06:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47663 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZJUVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:06:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PNGflPU1Aa/8T7q2x1iDc1gaS0ngpPZ4p6B8EC6aq2jd4Rl7GEhUkrpUmzL/fEIuB
	iDSM7aWUC3rywsPhx3mgQ==
Date: Wed, 21 Oct 2009 14:06:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: [PATCH] SLUB: Don't drop __GFP_NOFAIL completely from allocate_slab()
 (was: Re: [Bug #14265] ifconfig: page allocation failure. order:5,ode:0x8020
 w/ e100)
In-Reply-To: <20091021200442.GA2987@bizet.domek.prywatny>
Message-ID: <alpine.DEB.2.00.0910211400140.20010@chino.kir.corp.google.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.rP.2MTxKB@chimera> <20091021200442.GA2987@bizet.domek.prywatny>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009, Karol Lewandowski wrote:

> commit d6849591e042bceb66f1b4513a1df6740d2ad762
> Author: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> Date:   Wed Oct 21 21:01:20 2009 +0200
> 
>     SLUB: Don't drop __GFP_NOFAIL completely from allocate_slab()
>     
>     Commit ba52270d18fb17ce2cf176b35419dab1e43fe4a3 unconditionally
>     cleared __GFP_NOFAIL flag on all allocations.
>     

No, it clears __GFP_NOFAIL from the first allocation of oo_order(s->oo).  
If that fails (and it's easy to fail, it has __GFP_NORETRY), another 
allocation is attempted with oo_order(s->min), for which __GFP_NOFAIL 
would be preserved if that's the slab cache's allocflags.

>     Preserve this flag on second attempt to allocate page (with possibly
>     decreased order).
>     
>     This should help with bugs #14265, #14141 and similar.
>     
>     Signed-off-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b627675..ac5db65 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1084,7 +1084,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  {
>  	struct page *page;
>  	struct kmem_cache_order_objects oo = s->oo;
> -	gfp_t alloc_gfp;
> +	gfp_t alloc_gfp, nofail;
>  
>  	flags |= s->allocflags;
>  
> @@ -1092,6 +1092,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	 * Let the initial higher-order allocation fail under memory pressure
>  	 * so we fall-back to the minimum order allocation.
>  	 */
> +	nofail = flags & __GFP_NOFAIL;
>  	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
>  
>  	page = alloc_slab_page(alloc_gfp, node, oo);
> @@ -1100,8 +1101,10 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  		/*
>  		 * Allocation may have failed due to fragmentation.
>  		 * Try a lower order alloc if possible
> +		 *
> +		 * Preserve __GFP_NOFAIL flag if previous allocation failed.
>  		 */
> -		page = alloc_slab_page(flags, node, oo);
> +		page = alloc_slab_page(flags | nofail, node, oo);
>  		if (!page)
>  			return NULL;
>  
> 

This does nothing.  You may have missed that the lower order allocation is 
passing 'flags' (which is a union of the gfp flags passed to 
allocate_slab() based on the allocation context and the cache's 
allocflags), and not alloc_gfp where __GFP_NOFAIL is masked.

Nack.

Note: slub isn't going to be a culprit in order 5 allocation failures 
since they have kmalloc passthrough to the page allocator.
