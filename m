Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbYLLO2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbYLLO2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbYLLO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:27:49 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34959 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758638AbYLLO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:27:48 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <494184AA.8090509@cs.helsinki.fi>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
	 <494184AA.8090509@cs.helsinki.fi>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Dec 2008 14:27:45 +0000
Message-Id: <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 14:27:46.0130 (UTC) FILETIME=[CD393320:01C95C65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 23:22 +0200, Pekka Enberg wrote:
> Catalin Marinas wrote:
> > @@ -2610,6 +2611,13 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
> >  		/* Slab management obj is off-slab. */
> >  		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
> >  					      local_flags & ~GFP_THISNODE, nodeid);
> > +		/*
> > +		 * Only scan the list member to avoid false negatives
> > +		 * (especially caused by the s_mem pointer)
> > +		 */
> 
> Heh, I run into this part again and as I have a long term memory of a 
> goldfish I had to look up the discussion we had. So may I suggest you 
> change the comment to:
> 
> /*
>   * If the first object in the slab is leaked (it's allocated but no
>   * one has a reference to it), we want to make sure kmemleak does not
>   * treat the ->s_mem pointer as a reference to the object. Otherwise
>   * we will not report the leak.
>   */

OK, thanks. It's more verbose but it makes it pretty clear.

> > +		memleak_scan_area(slabp, offsetof(struct slab, list),
> > +				  sizeof(struct list_head),
> > +				  local_flags & ~GFP_THISNODE);
> >  		if (!slabp)
> >  			return NULL;
> >  	} else {
> > @@ -3195,6 +3203,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
> >  		STATS_INC_ALLOCMISS(cachep);
> >  		objp = cache_alloc_refill(cachep, flags);
> >  	}
> > +	/* avoid false negatives */
> > +	memleak_erase(&ac->entry[ac->avail]);
> 
> For this, maybe something like this:
> 
> /*
>   * To avoid a false negative, if an object that is in one of the
>   * per-CPU caches is leaked, we need to make sure kmemleak doesn't
>   * treat the array pointers as a reference to the object.
>   */

OK.

> >  	return objp;
> >  }
> >  
> 
> Do you take care of the per-node lists as well?

I can't figure out what other location should be erased.

-- 
Catalin

