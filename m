Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZEDUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZEDUCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZEDUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:02:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZEDUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:02:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rpy6cBXJZU69aql/NgAS5+5qVBOIECpdQJo3m4RUtXooe40g+syC7xac+q9BrNLic
	fPqFeaTWGAhOpzTUoaxsQ==
Date: Mon, 4 May 2009 13:02:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Wu Fengguang <fengguang.wu@intel.com>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905042151.07953.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905041253380.23036@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905041702.23291.rjw@sisk.pl> <alpine.DEB.2.00.0905040939400.10707@chino.kir.corp.google.com> <200905042151.07953.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Rafael J. Wysocki wrote:

> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -1599,7 +1599,8 @@ nofail_alloc:
>  					zonelist, high_zoneidx, alloc_flags);
>  		if (page)
>  			goto got_pg;
> -	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> +	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)
> +			&& !(gfp_mask & __GFP_NO_OOM_KILL)) {
>  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
>  			schedule_timeout_uninterruptible(1);
>  			goto restart;
> Index: linux-2.6/include/linux/gfp.h
> ===================================================================
> --- linux-2.6.orig/include/linux/gfp.h
> +++ linux-2.6/include/linux/gfp.h
> @@ -51,8 +51,9 @@ struct vm_area_struct;
>  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
>  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> +#define __GFP_NO_OOM_KILL ((__force gfp_t)0x200000u)  /* Don't invoke out_of_memory() */
>  
> -#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
> +#define __GFP_BITS_SHIFT 22	/* Number of __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>  
>  /* This equals 0, but use constants in case they ever change */
> 

Yeah, that's much better, thanks.  There's currently concerns about adding 
a new gfp flag in another thread (__GFP_PANIC), though, so you might find 
some resistance in adding a flag with a very specific and limited use cae.

I think you might have better luck in doing

	struct zone *z;

	for_each_populated_zone(z)
		zone_set_flag(z, ZONE_OOM_LOCKED);
	
if all other tasks are really in D state at this point since oom killer 
serialization is done with try locks in the page allocator.  This is 
equivalent to __GFP_NO_OOM_KILL.
