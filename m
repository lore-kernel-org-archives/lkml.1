Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbXKHPXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbXKHPXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbXKHPX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:23:28 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38028 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188AbXKHPX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:23:27 -0500
Date: Thu, 8 Nov 2007 15:23:24 +0000
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 20/23] dentries: Add constructor
Message-ID: <20071108152324.GF2591@skynet.ie>
References: <20071107011130.382244340@sgi.com> <20071107011231.453090374@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071107011231.453090374@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/11/07 17:11), Christoph Lameter didst pronounce:
> In order to support defragmentation on the dentry cache we need to have
> a determined object state at all times. Without a constructor the object
> would have a random state after allocation.
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
> So provide a constructor.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Seems to be some garbling on there in the signed-off lines.

> ---
>  fs/dcache.c |   26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c	2007-11-06 12:56:56.000000000 -0800
> +++ linux-2.6/fs/dcache.c	2007-11-06 12:57:01.000000000 -0800
> @@ -870,6 +870,16 @@ static struct shrinker dcache_shrinker =
>  	.seeks = DEFAULT_SEEKS,
>  };
>  
> +void dcache_ctor(struct kmem_cache *s, void *p)
> +{
> +	struct dentry *dentry = p;
> +
> +	spin_lock_init(&dentry->d_lock);
> +	dentry->d_inode = NULL;
> +	INIT_LIST_HEAD(&dentry->d_lru);
> +	INIT_LIST_HEAD(&dentry->d_alias);
> +}
> +

Is there any noticable overhead to the constructor?

>  /**
>   * d_alloc	-	allocate a dcache entry
>   * @parent: parent of entry to allocate
> @@ -907,8 +917,6 @@ struct dentry *d_alloc(struct dentry * p
>  
>  	atomic_set(&dentry->d_count, 1);
>  	dentry->d_flags = DCACHE_UNHASHED;
> -	spin_lock_init(&dentry->d_lock);
> -	dentry->d_inode = NULL;
>  	dentry->d_parent = NULL;
>  	dentry->d_sb = NULL;
>  	dentry->d_op = NULL;
> @@ -918,9 +926,7 @@ struct dentry *d_alloc(struct dentry * p
>  	dentry->d_cookie = NULL;
>  #endif
>  	INIT_HLIST_NODE(&dentry->d_hash);
> -	INIT_LIST_HEAD(&dentry->d_lru);
>  	INIT_LIST_HEAD(&dentry->d_subdirs);
> -	INIT_LIST_HEAD(&dentry->d_alias);
>  
>  	if (parent) {
>  		dentry->d_parent = dget(parent);
> @@ -2096,14 +2102,10 @@ static void __init dcache_init(void)
>  {
>  	int loop;
>  
> -	/* 
> -	 * A constructor could be added for stable state like the lists,
> -	 * but it is probably not worth it because of the cache nature
> -	 * of the dcache. 
> -	 */
> -	dentry_cache = KMEM_CACHE(dentry,
> -		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
> -	
> +	dentry_cache = kmem_cache_create("dentry_cache", sizeof(struct dentry),
> +		0, SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD,
> +		dcache_ctor);
> +
>  	register_shrinker(&dcache_shrinker);
>  
>  	/* Hash may have been set up in dcache_init_early */

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
