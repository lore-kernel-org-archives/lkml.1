Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZJAUtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZJAUtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZJAUtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:49:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38483 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZJAUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:49:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=q89G58JOGOvwm85lsKnEmSSTr3AZlHAFXu4uDACAeVcs4Sz8oUMeFFOw2E2jYxkZI
	AQNiFK7FW4vslbffaimnA==
Date: Thu, 1 Oct 2009 13:49:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 30/31] Fix use of uninitialized variable in
 cache_grow()
In-Reply-To: <1254406257-16735-1-git-send-email-sjayaraman@suse.de>
Message-ID: <alpine.DEB.1.00.0910011341280.27559@chino.kir.corp.google.com>
References: <1254406257-16735-1-git-send-email-sjayaraman@suse.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Suresh Jayaraman wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This fixes a bug in reserve-slub.patch.
> 
> If cache_grow() was called with objp != NULL then the 'reserve' local
> variable wasn't initialized. This resulted in ac->reserve being set to
> a rubbish value.  Due to this in some circumstances huge amounts of
> slab pages were allocated (due to slab_force_alloc() returning true),
> which caused atomic page allocation failures and slowdown of the
> system.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  mm/slab.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: mmotm/mm/slab.c
> ===================================================================
> --- mmotm.orig/mm/slab.c
> +++ mmotm/mm/slab.c
> @@ -2760,7 +2760,7 @@ static int cache_grow(struct kmem_cache
>  	size_t offset;
>  	gfp_t local_flags;
>  	struct kmem_list3 *l3;
> -	int reserve;
> +	int reserve = -1;
>  
>  	/*
>  	 * Be lazy and only check for valid flags here,  keeping it out of the
> @@ -2816,7 +2816,8 @@ static int cache_grow(struct kmem_cache
>  	if (local_flags & __GFP_WAIT)
>  		local_irq_disable();
>  	check_irq_off();
> -	slab_set_reserve(cachep, reserve);
> +	if (reserve != -1)
> +		slab_set_reserve(cachep, reserve);
>  	spin_lock(&l3->list_lock);
>  
>  	/* Make slab active. */

Given the patch description, shouldn't this be a test for objp != NULL 
instead, then?

If so, it doesn't make sense because reserve will only be initialized when 
objp == NULL in the call to kmem_getpages() from cache_grow().


The title of the patch suggests this is just dealing with an uninitialized 
auto variable so the anticipated change would be from "int reserve" to 
"int uninitialized_var(result)".
