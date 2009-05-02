Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZEBXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZEBXvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 19:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZEBXvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 19:51:38 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:19052 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZEBXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 19:51:37 -0400
MIME-Version: 1.0
In-Reply-To: <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
Date: Sat, 2 May 2009 19:51:36 -0400
Message-ID: <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
From: Kyle Moffett <kyle@moffetthome.net>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After digging through this a bit, I would recommend rewriting this
whole part.  The part that definitely needs to go is the vmalloc() of
your whole LRU at once.

Here's some code I've been fiddling around with for a while.  It uses
a kmem_cache and a shrinker callback (although it does need a small
patch to the shrinker code) to provide a dynamically sized LRU list
for fixed-size objects.

This hasn't even been compile-tested, and it probably has some minor
locking errors, but it should have enough comments to make up for it.
This explicitly does *NOT* have your custom hash-lookup code in it,
with the premise that generally that part should be left up to
whatever architecture best fits the user of the LRU list.

I did design it so that it is suitable for usage with a lockless-RCU
hash-lookup.  The user would need to make sure to specify
SLAB_DESTROY_BY_RCU in the flags field and make sure to include some
kind of generation counter (see the various docs on
SLAB_DESTROY_BY_RCU).  On the other hand it would also work fine with
a single spinlock used to control updates of the lookup datastructure.

The user will need to use spin_trylock() or similar in their ->evict()
callback, as that is called with the internal list spinlock held.  On
the other hand, if one CPU has their lookup table locked and is trying
to lru_cache_get() an object, there's not a whole lot that another CPU
can do to free anything referenced by that lookup table anyways.  I
don't see it as a big issue.

Nowhere-near-signed-off-by: Kyle Moffett <kyle@moffetthome.net>

struct lru_cache_type {
	const char *name;
	size_t size, align;
	unsigned long flags;
	int seeks;

	/*
	 * Return nonzero if the passed object may be evicted (IE: freed).
	 * Otherwise return zero and it will be "touched" (IE: moved to the
	 * tail of the LRU) so that later scans will try other objects.
	 *
	 * If you return nonero from this function, "obj" will be immediately
	 * kmem_cache_free()d.
	 */
	unsigned int (*evict)(struct lru_cache *lc, void *obj);
};

struct lru_cache {
	const struct lru_cache_type *type;
	size_t offset;

	struct kmem_cache *cache;
	struct shrinker shrinker;

	/* The least-recently used item in the LRU is at the head */
	spinlock_t lock;
	struct list_head lru;
	struct list_head in_use;
	unsigned long nr_lru;
	unsigned long nr_in_use;
};

struct lru_cache_elem {
	/* The node is either on the LRU or on this in-use list */
	struct list_head node;
	const struct lru_cache *lc;
	atomic_t refcount;
}

/*
 * FIXME:  Needs a patch to make the shinker->shrink() function take an extra
 * argument with the address of the "struct shrinker".
 */
static int lru_cache_shrink__(struct shrinker *s, int nr_scan, gfp_t flags)
{
	return lru_cache_shrink(container_of(s, struct lru_cache, shrinker),
				nr_scan, flags);
}

int lru_cache_create(struct lru_cache *lc, const struct lru_cache_type *type)
{
	/* Align the size so an lru_cache_elem can sit at the end */
	size_t align = MAX(type->align, __alignof__(struct lru_cache_elem));
	size_t size = ALIGN(type->size, __alignof__(struct lru_cache_elem));
	lc->offset = size;

	/* Now add space for that element */
	size += sizeof(struct lru_cache_elem);

	/* Initialize internal fields */
	lc->type = type;
	INIT_LIST_HEAD(&lc->lru);
	INIT_LIST_HEAD(&lc->in_use);
	lc->nr_lru = 0;
	lc->nr_in_use = 0;

	/* Allocate the fixed-sized-object cache */
	lc->cache = kmem_cache_create(type->name, size, align,
			type->flags, NULL);
	if (!lc->cache)
		return -ENOMEM;

	/* Now initialize and register our shrinker */
	lc->shrinker.shrink = &lru_cache_shrink;
	lc->shrinker.seeks = type->seeks;
	register_shrinker(&lc->shrinker);

	return 0;
}

/*
 * Before you can call this function, you must free all of the objects on the
 * LRU list (which in turn means they must all have zeroed refcounts), and
 * you must ensure that no other functions will be called on this lru-cache.
 */
void lru_cache_destroy(struct lru_cache *lc)
{
	BUG_ON(lc->nr_lru);
	BUG_ON(lc->nr_in_use);
	BUG_ON(!list_empty(&lc->lru));
	BUG_ON(!list_empty(&lc->in_use));

	unregister_shrinker(&lc->shrinker);
	kmem_cache_destroy(lc->cache);
	lc->cache = NULL;
}

void *lru_cache_alloc(struct lru_cache *lc, gfp_t flags)
{
	struct lru_cache_elem *elem;
	void *obj = kmem_cache_alloc(lc->cache, flags);
	if (!obj)
		return NULL;

	elem = obj + lc->offset;
	atomic_set(&elem->refcount, 1);
	elem->lc = lc;
	smp_wmb();

	spin_lock(&lc->lock);
	list_add_tail(&elem->node, &lc->in_use);
	lc->in_use++;
	spin_unlock(&lc->lock);

	return obj;
}

/*
 * You must ensure that the lru object has a zero refcount and can no longer
 * be looked up before calling lru_cache_free().  Specifically, you must
 * ensure that lru_cache_get() cannot be called on this object.
 */
void lru_cache_free(struct lru_cache *lc, void *obj)
{
	struct lru_cache_elem *elem = obj + lc->offset;
	BUG_ON(elem->lc != lc);

	spin_lock(&lc->lock);
	BUG_ON(atomic_read(&elem->refcount));
	list_del(&elem->node);
	lc->nr_lru--;
	spin_unlock(&lc->lock);

	kmem_cache_free(lc->cache, obj);
}

/*
 * This may be called at any time between lru_cache_create() and
 * lru_cache_destroy() by the shrinker code to reduce our memory usage.
 */
int lru_cache_shrink(struct lru_cache *lc, int nr_scan, gfp_t flags)
{
	struct lru_cache_elem *elem, *n;
	unsigned long nr_lru;
	int nr_left = nr_scan;

	spin_lock(&lc->lock);

	/* Try to scan the number of requested objects */
	list_for_each_entry_safe(elem, n, &lc->lru, node) {
		void *obj;
		if (!nr_left--)
			break;

		/* Sanity check */
		BUG_ON(atomic_read(&elem->refcount));

		/* Ask them if we can free this item */
		obj = ((void *)elem) - lc->offset;
		if (!lc->type->evict(lc, obj)) {
			/*
			 * They wouldn't let us free it, so move it to the
			 * other end of the LRU so we can keep scanning.
			 */
			list_del(&elem->node);
			list_add_tail(&elem->node, &lc->lru);
			continue;
		}

		/* Remove this node from the LRU and free it */
		list_del(&elem->node);
		lc->nr_lru--;
		kmem_cache_free(obj);
	}

	nr_lru = lc->nr_lru;
	spin_unlock(&lc->lock);

	/* Now if we were asked to scan, tell the kmem_cache to shrink */
	if (nr_scan)
		kmem_cache_shrink(lc->cache);

	return (nr_lru < (unsigned long)INT_MAX) ? (int)nr_lru : INT_MAX;
}

/* Use this function if you already have a reference to "obj" */
void *lru_cache_get__(struct lru_cache *lc, void *obj)
{
	struct lru_cache_elem *elem = obj + lc->offset;
	BUG_ON(elem->lc != lc);
	atomic_inc(&elem->refcount);
	return obj;
}

/*
 * If you do not already have a reference to "obj", you must wrap the
 * combined lookup + lru_cache_get() in rcu_read_lock/unlock().
 */
void *lru_cache_get(struct lru_cache *lc, void *obj)
{
	struct lru_cache_elem *elem = obj + lc->offset;
	BUG_ON(elem->lc != lc);

	/* Fastpath:  If it's already referenced just add another one */
	if (atomic_inc_not_zero(&elem->refcount))
		return obj;

	/* Slowpath:  Need to lock the lru-cache and mark the object used */
	spin_lock(&lc->lock);

	/* One more attempt at the fastpath, now that we've got the lock */
	if (atomic_inc_not_zero(&elem->refcount))
		goto out;

	/*
	 * Ok, it has a zero refcount and we've got the lock, anybody else in
	 * here trying to lru_cache_get() this object will wait until we are
	 * done.
	 */

	/* Remove it from the LRU */
	BUG_ON(!lc->nr_lru);
	list_del(&elem->node);
	lc->nr_lru--;

	/* Add it to the in-use list */
	list_add_tail(&elem->node, &lc->in_use);
	lc->nr_in_use++;

	/* Acquire a reference */
	atomic_set(&elem->refcount, 1);

out:
	spin_unlock(&lc->lock);
	return obj;
}

/* This releases one reference */
void lru_cache_put(struct lru_cache *lc, void *obj)
{
	struct lru_cache_elem *elem = obj + lc->offset;
	BUG_ON(elem->lc != lc);
	BUG_ON(!atomic_read(&elem->refcount));

	/* Drop the refcount; if it's still nonzero, we're done */
	if (atomic_dec_return(&elem->refcount))
		return;

	/* We need to take the lru-cache lock to make sure we release it */
	spin_lock(&lc->lock);
	if (atomic_read(&elem->refcount))
		goto out;

	/*
	 * Ok, it has a zero refcount and we hold the lock, anybody trying to
	 * lru_cache_get() this object will block until we're done.
	 */

	/* Remove it from the in-use list */
	BUG_ON(!lc->nr_in_use);
	list_del(&elem->node);
	lc->nr_in_use--;

	/* Add it to the LRU list */
	list_add_tail(&elem->node, &lc->lru);
	lc->nr_lru++;

out:
	spin_unlock(&lc->lock);
}
