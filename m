Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752466AbYLRJ6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYLRJ6D (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYLRJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:57:52 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49290 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYLRJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:57:51 -0500
Subject: Re: [patch v2] slub: avoid leaking caches or refcounts on sysfs
	error
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0812172208160.11934@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0812172208160.11934@chino.kir.corp.google.com>
Date: Thu, 18 Dec 2008 11:57:48 +0200
Message-Id: <1229594268.1047.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 2008-12-17 at 22:09 -0800, David Rientjes wrote:
> Pekka,
> 
> Here's an updated version of the patch I sent to LKML earlier this 
> evening.  It includes a kfree() for the kmalloc'd kmem_cache when the 
> sysfs link couldn't added.

Looks good to me. I queued it up for 2.6.29. Thanks!

		Pekka

> slub: avoid leaking caches or refcounts on sysfs error
> 
> If a slab cache is mergeable and the sysfs alias cannot be added, the
> target cache shall have its refcount decremented.  kmem_cache_create()
> will return NULL, so if kmem_cache_destroy() is ever called on the target
> cache, it will never be freed if the refcount has been leaked.
> 
> Likewise, if a slab cache is not mergeable and the sysfs link cannot be
> added, the new cache shall be removed from the slab_caches list.
> kmem_cache_create() will return NULL, so it will be impossible to call
> kmem_cache_destroy() on it.
> 
> Both of these operations require slub_lock since refcount of all slab
> caches and slab_caches are protected by the lock.
> 
> In the mergeable case, it would be better to restore objsize and offset
> back to their original values, but this could race with another merge
> since slub_lock was dropped.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/slub.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3123,8 +3123,12 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
>  		up_write(&slub_lock);
>  
> -		if (sysfs_slab_alias(s, name))
> +		if (sysfs_slab_alias(s, name)) {
> +			down_write(&slub_lock);
> +			s->refcount--;
> +			up_write(&slub_lock);
>  			goto err;
> +		}
>  		return s;
>  	}
>  
> @@ -3134,8 +3138,13 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  				size, align, flags, ctor)) {
>  			list_add(&s->list, &slab_caches);
>  			up_write(&slub_lock);
> -			if (sysfs_slab_add(s))
> +			if (sysfs_slab_add(s)) {
> +				down_write(&slub_lock);
> +				list_del(&s->list);
> +				up_write(&slub_lock);
> +				kfree(s);
>  				goto err;
> +			}
>  			return s;
>  		}
>  		kfree(s);

