Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYLKV1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYLKV1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYLKV0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:26:55 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33974 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbYLKV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:26:55 -0500
Message-ID: <494184AA.8090509@cs.helsinki.fi>
Date: Thu, 11 Dec 2008 23:22:50 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
 hooks
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas wrote:
> @@ -2610,6 +2611,13 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
>  		/* Slab management obj is off-slab. */
>  		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
>  					      local_flags & ~GFP_THISNODE, nodeid);
> +		/*
> +		 * Only scan the list member to avoid false negatives
> +		 * (especially caused by the s_mem pointer)
> +		 */

Heh, I run into this part again and as I have a long term memory of a 
goldfish I had to look up the discussion we had. So may I suggest you 
change the comment to:

/*
  * If the first object in the slab is leaked (it's allocated but no
  * one has a reference to it), we want to make sure kmemleak does not
  * treat the ->s_mem pointer as a reference to the object. Otherwise
  * we will not report the leak.
  */

> +		memleak_scan_area(slabp, offsetof(struct slab, list),
> +				  sizeof(struct list_head),
> +				  local_flags & ~GFP_THISNODE);
>  		if (!slabp)
>  			return NULL;
>  	} else {
> @@ -3195,6 +3203,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  		STATS_INC_ALLOCMISS(cachep);
>  		objp = cache_alloc_refill(cachep, flags);
>  	}
> +	/* avoid false negatives */
> +	memleak_erase(&ac->entry[ac->avail]);

For this, maybe something like this:

/*
  * To avoid a false negative, if an object that is in one of the
  * per-CPU caches is leaked, we need to make sure kmemleak doesn't
  * treat the array pointers as a reference to the object.
  */

>  	return objp;
>  }
>  

Do you take care of the per-node lists as well?
