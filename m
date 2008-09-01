Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYIAH3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYIAH3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYIAH3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:29:10 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:34091 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751089AbYIAH3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:29:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2vaVYpf6u1UIyPEC9HcrAmvfmY5K2A4onnllWbX2rsd6jxZ/ZzwM3EmtPzdmyiUka85lQha5QABJz2+pPG7rGpLnfBTLpnZfMllObvJ0xWTkN8tzecWEMTaN7gL0aWeRtwmT+9hmHorGOEm+zrLvk8snzZoHWpJ/Do/gr18o0Hs=  ;
X-YMail-OSG: b1LX1.UVM1mPpAj.19gRsDJwamnX25WjH464ySvFCtY4WooCM7lCFPnELIMffBmvzYMP93N9Jav9.kihxuEjx2GVRmNzq7pc_U5VNsgR09UPrMC_7pJJkfZGfhDTPozLgDhrbutnzrPhIGBI4koGa8_Q
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 3/3] dentries: dentry defragmentation
Date: Mon, 1 Sep 2008 17:28:56 +1000
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
References: <20080825212035.861870487@quilx.com> <20080825212053.734467711@quilx.com>
In-Reply-To: <20080825212053.734467711@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011728.57276.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't come with any numbers or test cases or results?

On Tuesday 26 August 2008 07:20, Christoph Lameter wrote:
> The dentry pruning for unused entries works in a straightforward way. It
> could be made more aggressive if one would actually move dentries instead
> of just reclaiming them.
>
> Cc: Alexander Viro <viro@ftp.linux.org.uk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>
> ---
>  fs/dcache.c |  101
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++- 1 file
> changed, 100 insertions(+), 1 deletion(-)
>
> Index: linux-next/fs/dcache.c
> ===================================================================
> --- linux-next.orig/fs/dcache.c	2008-08-25 15:55:24.000000000 -0500
> +++ linux-next/fs/dcache.c	2008-08-25 15:59:46.000000000 -0500
> @@ -32,6 +32,7 @@
>  #include <linux/seqlock.h>
>  #include <linux/swap.h>
>  #include <linux/bootmem.h>
> +#include <linux/backing-dev.h>
>  #include "internal.h"
>
>
> @@ -163,7 +164,10 @@
>
>  	list_del(&dentry->d_u.d_child);
>  	dentry_stat.nr_dentry--;	/* For d_free, below */
> -	/*drops the locks, at that point nobody can reach this dentry */
> +	/*
> +	 * drops the locks, at that point nobody (aside from defrag)
> +	 * can reach this dentry
> +	 */
>  	dentry_iput(dentry);
>  	parent = dentry->d_parent;
>  	d_free(dentry);
> @@ -2270,6 +2274,100 @@
>  		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
>  }
>
> +/*
> + * The slab allocator is holding off frees. We can safely examine
> + * the object without the danger of it vanishing from under us.
> + */
> +static void *get_dentries(struct kmem_cache *s, int nr, void **v)
> +{
> +	struct dentry *dentry;
> +	int i;
> +
> +	spin_lock(&dcache_lock);
> +	for (i = 0; i < nr; i++) {
> +		dentry = v[i];
> +
> +		/*
> +		 * Three sorts of dentries cannot be reclaimed:
> +		 *
> +		 * 1. dentries that are in the process of being allocated
> +		 *    or being freed. In that case the dentry is neither
> +		 *    on the LRU nor hashed.
> +		 *
> +		 * 2. Fake hashed entries as used for anonymous dentries
> +		 *    and pipe I/O. The fake hashed entries have d_flags
> +		 *    set to indicate a hashed entry. However, the
> +		 *    d_hash field indicates that the entry is not hashed.
> +		 *
> +		 * 3. dentries that have a backing store that is not
> +		 *    writable. This is true for tmpsfs and other in
> +		 *    memory filesystems. Removing dentries from them
> +		 *    would loose dentries for good.
> +		 */
> +		if ((d_unhashed(dentry) && list_empty(&dentry->d_lru)) ||
> +		   (!d_unhashed(dentry) && hlist_unhashed(&dentry->d_hash)) ||
> +		   (dentry->d_inode &&
> +		   !mapping_cap_writeback_dirty(dentry->d_inode->i_mapping)))
> +			/* Ignore this dentry */
> +			v[i] = NULL;
> +		else
> +			/* dget_locked will remove the dentry from the LRU */
> +			dget_locked(dentry);
> +	}
> +	spin_unlock(&dcache_lock);
> +	return NULL;
> +}
> +
> +/*
> + * Slab has dropped all the locks. Get rid of the refcount obtained
> + * earlier and also free the object.
> + */
> +static void kick_dentries(struct kmem_cache *s,
> +				int nr, void **v, void *private)
> +{
> +	struct dentry *dentry;
> +	int i;
> +
> +	/*
> +	 * First invalidate the dentries without holding the dcache lock
> +	 */
> +	for (i = 0; i < nr; i++) {
> +		dentry = v[i];
> +
> +		if (dentry)
> +			d_invalidate(dentry);
> +	}
> +
> +	/*
> +	 * If we are the last one holding a reference then the dentries can
> +	 * be freed. We need the dcache_lock.
> +	 */
> +	spin_lock(&dcache_lock);
> +	for (i = 0; i < nr; i++) {
> +		dentry = v[i];
> +		if (!dentry)
> +			continue;
> +
> +		spin_lock(&dentry->d_lock);
> +		if (atomic_read(&dentry->d_count) > 1) {
> +			spin_unlock(&dentry->d_lock);
> +			spin_unlock(&dcache_lock);
> +			dput(dentry);
> +			spin_lock(&dcache_lock);
> +			continue;
> +		}
> +
> +		prune_one_dentry(dentry);
> +	}
> +	spin_unlock(&dcache_lock);
> +
> +	/*
> +	 * dentries are freed using RCU so we need to wait until RCU
> +	 * operations are complete.
> +	 */
> +	synchronize_rcu();
> +}
> +
>  static void __init dcache_init(void)
>  {
>  	int loop;
> @@ -2279,6 +2377,7 @@
>  		dcache_ctor);
>
>  	register_shrinker(&dcache_shrinker);
> +	kmem_cache_setup_defrag(dentry_cache, get_dentries, kick_dentries);
>
>  	/* Hash may have been set up in dcache_init_early */
>  	if (!hashdist)
