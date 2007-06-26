Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbXFZIWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbXFZIWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXFZIVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:21:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbXFZIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:21:52 -0400
Date: Tue, 26 Jun 2007 01:18:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 21/26] Slab defragmentation: support dentry
 defragmentation
Message-Id: <20070626011845.bfd4efe0.akpm@linux-foundation.org>
In-Reply-To: <20070618095918.404020641@sgi.com>
References: <20070618095838.238615343@sgi.com>
	<20070618095918.404020641@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 02:58:59 -0700 clameter@sgi.com wrote:

> get() uses the dcache lock and then works with dget_locked to obtain a
> reference to the dentry. An additional complication is that the dentry
> may be in process of being freed or it may just have been allocated.
> We add an additional flag to d_flags to be able to determined the
> status of an object.
> 
> kick() is called after get() has been used and after the slab has dropped
> all of its own locks. The dentry pruning for unused entries works in a
> straighforward way.
> 
> ...
>
> +/*
> + * Slab has dropped all the locks. Get rid of the
> + * refcount we obtained earlier and also rid of the
> + * object.
> + */
> +static void kick_dentries(struct kmem_cache *s, int nr, void **v, void *private)
> +{
> +	struct dentry *dentry;
> +	int abort = 0;
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
> +	 * be freed. We  need the dcache_lock.
> +	 */
> +	spin_lock(&dcache_lock);
> +	for (i = 0; i < nr; i++) {
> +		dentry = v[i];
> +		if (!dentry)
> +			continue;
> +
> +		if (abort)
> +			goto put_dentry;
> +
> +		spin_lock(&dentry->d_lock);
> +		if (atomic_read(&dentry->d_count) > 1) {
> +			/*
> +			 * Reference count was increased.
> +			 * We need to abandon the freeing of
> +			 * objects.
> +			 */
> +			abort = 1;

It's unobvious why the entire shrink effort is abandoned if one busy dentry
is encountered.  Please flesh the comment out explaining this.

> +			spin_unlock(&dentry->d_lock);
> +put_dentry:
> +			spin_unlock(&dcache_lock);
> +			dput(dentry);
> +			spin_lock(&dcache_lock);
> +			continue;
> +		}
> +
> +		/* Remove from LRU */
> +		if (!list_empty(&dentry->d_lru)) {
> +			dentry_stat.nr_unused--;
> +			list_del_init(&dentry->d_lru);
> +		}
> +		/* Drop the entry */
> +		prune_one_dentry(dentry, 1);
> +	}
> +	spin_unlock(&dcache_lock);
> +
> +	/*
> +	 * dentries are freed using RCU so we need to wait until RCU
> +	 * operations arei complete
> +	 */
> +	if (!abort)
> +		synchronize_rcu();
> +}

