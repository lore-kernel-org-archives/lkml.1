Return-Path: <linux-kernel-owner+w=401wt.eu-S1763124AbXEQFU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763124AbXEQFU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbXEQFT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:19:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47342 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755726AbXEQFTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:19:25 -0400
Message-Id: <20070517051924.603494647@sgi.com>
References: <20070517051659.055631233@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 May 2007 22:17:01 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, dgc@sgi.com
Subject: [patch 2/3] SLUB: Implement targeted reclaim and partial list defragmentation
Content-Disposition: inline; filename=get_ref_kick
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Targeted reclaim allows to target a single slab for reclaim. This is done by
calling

kmem_cache_vacate(page);

It will return 1 on success, 0 if the operation failed.

The vacate functionality is also used for slab shrinking. During the shrink
operation SLUB will generate a list sorted by the number of objects in use.

We extract pages off that list that are only filled less than a quarter. These
objects are then processed using kmem_cache_vacate.

In order for a slabcache to support this functionality a couple of functions
must be defined via kmem_cache_ops. These are

int get(struct kmem_cache *s, void *)

	Must obtain a reference to the indicated object. SLUB guarantees that
	the objects is still allocated. However, another thread may be blocked
	in slab_free attempting to free the same object. It may succeed as
	soon as get() returns to the slab allocator. The function must
	detect this situation and return 1 if that is the case.
	If the object cannot be freed then a negative -Exx code must be
	returned indicating the reason for the failure.
	get() return 0 on success.

	No slab operations may be performed in get_reference(). Interrupts
	are disabled. What can be done is very limited. The slab lock
	for the page with the object is taken. Any attempt to perform a slab
	operation may lead to a deadlock.

void put(struct kmem_cache *, void *)

	Used to restore the reference count obtained by get() if the reclaim
	logic decides to abandon the attempt to vacate all objects in a slab.
	This is usually the case if get() indicates that an object is not
	freeable.
	put() is optional. If it is not defined then it is assumed that we
	can simply abandon get()s on slab objects.

int kick(struct kmem_cache *, void *)

	After SLUB has established references to the remaining objects in a
	slab it will drop all locks and then use kick() on each of the
	objects. The existence of the object is guaranteed by virtue of the
	earlier obtained reference. The callback may perform any slab operation
	since no locks are held at the time of call.
	Function must return 0 if the object was successfully freed.
	Return -Exxx to indicate that the object is not freeable and to stop
	further attempt to free objects in this slab.

	The callback should remove the object from the slab in some way. This
	may be accomplished by reclaiming the object and then running
	kmem_cache_free() or reallocating it and then running
	kmem_cache_free(). Reallocation is advantageous because the partial
	slabs were just sorted to have the partial slabs with the most objects
	first. Allocation is likely to result in filling up a slab so that
	it can be removed from the partial list.

void sync(void)

	After all objects have been removed by kick()s this function will be
	called to ensure that all free operations have completed. Typically
	the function called here is synchronize_rcu() if the slab cache uses
	RCU to free objects. The function is optional. If it is not specified
	then no synchronization is done before removing the slab.

If a kmem_cache_vacate on a page fails then the slab has usually a pretty
low usage ratio. Go through the slab and resequence the freelist so that
object addresses increase as we allocate objects. This will trigger the
cacheline prefetcher and increase allocations speed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slab.h |   34 +++++
 mm/slab.c            |    9 +
 mm/slob.c            |    9 +
 mm/slub.c            |  304 +++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 346 insertions(+), 10 deletions(-)

Index: slub/include/linux/slab.h
===================================================================
--- slub.orig/include/linux/slab.h	2007-05-16 22:12:43.000000000 -0700
+++ slub/include/linux/slab.h	2007-05-16 22:12:44.000000000 -0700
@@ -39,6 +39,39 @@ void __init kmem_cache_init(void);
 int slab_is_available(void);
 
 struct kmem_cache_ops {
+	/*
+	 * Called with slab lock held and interrupts disabled.
+	 * No slab operation may be performed.
+	 *
+	 * Return 0 if reference was successfully obtained
+	 * Return 1 if a concurrent kmem_cache_free is waiting to free object
+	 * Return -errcode if it is not possible to free the object.
+	 * 		No reference was obtained.
+	 */
+	int (*get)(struct kmem_cache *, void *);
+
+	/*
+	 * Use to restore the reference count if we abandon the
+	 * attempt to vacate a slab page due to an unmovable
+	 * object.
+	 */
+	void (*put)(struct kmem_cache *, void *);
+
+	/*
+	 * Called with no locks held and interrupts enabled.
+	 * Any operation may be performed in kick_object.
+	 *
+	 * Return 0 for success
+	 * Return -errcode aborts further kicks to objects in the slab
+	 */
+	int (*kick)(struct kmem_cache *, void *);
+
+	/*
+	 * Callback to make sure that all object freeing is complete.
+	 * If the slab destroys objects by RCU then this needs to be
+	 * set to synchronize_rcu().
+	 */
+	void (*sync)(void);
 };
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
@@ -53,6 +86,7 @@ void kmem_cache_free(struct kmem_cache *
 unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
 int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
+int kmem_cache_vacate(struct page *);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-16 22:12:43.000000000 -0700
+++ slub/mm/slub.c	2007-05-16 22:12:44.000000000 -0700
@@ -1043,12 +1043,11 @@ static struct page *new_slab(struct kmem
 	n = get_node(s, page_to_nid(page));
 	if (n)
 		atomic_long_inc(&n->nr_slabs);
+
+	page->inuse = 0;
+	page->lockless_freelist = NULL;
 	page->offset = s->offset / sizeof(void *);
 	page->slab = s;
-	page->flags |= 1 << PG_slab;
-	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
-			SLAB_STORE_USER | SLAB_TRACE))
-		SetSlabDebug(page);
 
 	start = page_address(page);
 	end = start + s->objects * s->size;
@@ -1066,11 +1065,20 @@ static struct page *new_slab(struct kmem
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
-	page->lockless_freelist = NULL;
-	page->inuse = 0;
-out:
-	if (flags & __GFP_WAIT)
-		local_irq_disable();
+
+	/*
+	 * page->inuse must be visible when PageSlab(page) becomes
+	 * true for targeted reclaim
+	 */
+	smp_wmb();
+	__SetPageSlab(page);
+	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
+			SLAB_STORE_USER | SLAB_TRACE))
+		SetSlabDebug(page);
+
+ out:
+ 	if (flags & __GFP_WAIT)
+ 		local_irq_disable();
 	return page;
 }
 
@@ -2323,6 +2331,218 @@ void kfree(const void *x)
 EXPORT_SYMBOL(kfree);
 
 /*
+ * Order the freelist so that addresses increase as object are allocated.
+ * This is useful to trigger the cpu cacheline prefetching logic.
+ */
+void resequence_freelist(struct kmem_cache *s, struct page *page)
+{
+	void *p;
+	void *last;
+	void *addr = page_address(page);
+	DECLARE_BITMAP(map, s->objects);
+
+	bitmap_zero(map, s->objects);
+
+	/* Figure out which objects are on the freelist */
+	for_each_free_object(p, s, page->freelist)
+		set_bit(slab_index(p, s, addr), map);
+
+	last = NULL;
+	for_each_object(p, s, addr)
+		if (test_bit(slab_index(p, s, addr), map)) {
+			if (last)
+				set_freepointer(s, last, p);
+			else
+				page->freelist = p;
+			last = p;
+		}
+
+	if (last)
+		set_freepointer(s, last, NULL);
+	else
+		page->freelist = NULL;
+}
+
+/*
+ * Vacate all objects in the given slab.
+ *
+ * Slab must be locked and frozen. Interrupts are disabled (flags must
+ * be passed).
+ *
+ * Will drop and regain and drop the slab lock. At the end the slab will
+ * either be freed or returned to the partial lists.
+ *
+ * Returns the number of remaining objects
+ */
+static int __kmem_cache_vacate(struct kmem_cache *s,
+		struct page *page, unsigned long flags)
+{
+	void *p;
+	void *addr = page_address(page);
+	DECLARE_BITMAP(map, s->objects);
+	int leftover;
+
+	if (!page->inuse)
+		return 0;
+
+	/* Determine free objects */
+	bitmap_fill(map, s->objects);
+	for_each_free_object(p, s, page->freelist)
+		__clear_bit(slab_index(p, s, addr), map);
+
+	/*
+	 * Get a refcount for all used objects. If that fails then
+	 * no KICK callback can be performed.
+	 */
+	for_each_object(p, s, addr) {
+		int i = slab_index(p, s, addr);
+
+		if (test_bit(i, map)) {
+			int x = s->ops->get(s, p);
+
+			if (x > 0)
+				/*
+				 * Concurrent free in progress, there is no
+				 * need to do the kick call for this
+				 * object
+				 */
+				__clear_bit(i, map);
+
+			if (x >= 0)
+				continue;
+
+			/*
+			 * Unfreeable object encountered. We have no chance
+			 * to free up all objects. So free none.
+			 * Drop refcounts.
+			 */
+			if (s->ops->put) {
+				while (p > addr) {
+					p -= s->size;
+					if (test_bit(slab_index(p, s, addr),
+								map))
+						s->ops->put(s, p);
+				}
+			}
+			goto out;
+		}
+	}
+
+	/*
+	 * Got references. Now we can drop the slab lock. The slab
+	 * is frozen so it cannot vanish from under us nor will
+	 * allocations be performed on the slab. However, unlocking the
+	 * slab will allow concurrent slab_frees to proceed.
+	 */
+	slab_unlock(page);
+	local_irq_restore(flags);
+
+	/*
+	 * Perform the KICK callbacks to remove the objects. This is
+	 * expected to remove objects in the slab.
+	 */
+	for_each_object(p, s, addr)
+		if (test_bit(slab_index(p, s, addr), map)) {
+			int x =	s->ops->kick(s, p);
+
+			if (x < 0)
+				/* Unfreeable object. Abort kicks */
+				break;
+		}
+
+	/*
+	 * Insure deletion operations have completed.
+	 */
+	if (s->ops->sync)
+		s->ops->sync();
+
+	/*
+	 * Check the result and unfreeze the slab
+	 */
+	local_irq_save(flags);
+	slab_lock(page);
+out:
+	leftover = page->inuse;
+	if (leftover > 0)
+		/*
+		 * Cannot free. Lets at least optimize the freelist. We have
+		 * likely touched all the cachelines with the free pointers
+		 * already so it is cheap to do here.
+		 */
+		resequence_freelist(s, page);
+	unfreeze_slab(s, page);
+	local_irq_restore(flags);
+	return leftover;
+}
+
+/*
+ * Get a page off a list and freeze it. Must be holding slab lock.
+ */
+static void freeze_from_list(struct kmem_cache *s, struct page *page)
+{
+	if (page->inuse < s->objects)
+		remove_partial(s, page);
+	else if (s->flags & SLAB_STORE_USER)
+		remove_full(s, page);
+	SetSlabFrozen(page);
+}
+
+/*
+ * Attempt to free objects in a page. Return 1 if succesful.
+ */
+int kmem_cache_vacate(struct page *page)
+{
+	unsigned long flags;
+	struct kmem_cache *s;
+	int vacated = 0;
+
+	/*
+	 * Get a reference to the page. Return if its freed or being freed.
+	 * This is necessary to make sure that the page does not vanish
+	 * from under us before we are able to check the result.
+	 */
+	if (!get_page_unless_zero(page))
+		return 0;
+
+	if (!PageSlab(page))
+		goto out;
+
+	local_irq_save(flags);
+	slab_lock(page);
+
+	/*
+	 * We may now have locked a page that may be in various stages of
+	 * being freed. If the PageSlab bit is off then we have already
+	 * reached the page allocator. If page->inuse is zero then we are
+	 * in SLUB but freeing or allocating the page.
+	 * page->inuse is never modified without the slab lock held.
+	 *
+	 * Also abort if the page happens to be already frozen. If its
+	 * frozen then a concurrent vacate may be in progress.
+	 */
+	if (!PageSlab(page) || SlabFrozen(page) || !page->inuse)
+		goto out_locked;
+
+	/*
+	 * We are holding a lock on a slab page and all operations on the
+	 * slab are blocking.
+	 */
+	s = page->slab;
+	if (!s->ops->get || !s->ops->kick)
+		goto out_locked;
+	freeze_from_list(s, page);
+	vacated = __kmem_cache_vacate(s, page, flags) == 0;
+out:
+	put_page(page);
+	return vacated;
+out_locked:
+	slab_unlock(page);
+	local_irq_restore(flags);
+	goto out;
+
+}
+
+/*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
  * the remaining slabs by the number of items in use. The slabs with the
  * most items in use come first. New allocations will then fill those up
@@ -2337,11 +2557,12 @@ int kmem_cache_shrink(struct kmem_cache 
 	int node;
 	int i;
 	struct kmem_cache_node *n;
-	struct page *page;
+	struct page *page, *page2;
 	struct page *t;
 	struct list_head *slabs_by_inuse =
 		kmalloc(sizeof(struct list_head) * s->objects, GFP_KERNEL);
 	unsigned long flags;
+	LIST_HEAD(zaplist);
 
 	if (!slabs_by_inuse)
 		return -ENOMEM;
@@ -2392,8 +2613,43 @@ int kmem_cache_shrink(struct kmem_cache 
 		for (i = s->objects - 1; i >= 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
+		/*
+		 * If we have no functions available to defragment the slabs
+		 * then we are done.
+		 */
+		if (!s->ops->get || !s->ops->kick)
+			goto out;
+
+		/* Take objects with just a few objects off the tail */
+		while (n->nr_partial > MAX_PARTIAL) {
+			page = container_of(n->partial.prev, struct page, lru);
+
+			/*
+			 * We are holding the list_lock so we can only
+			 * trylock the slab
+			 */
+			if (page->inuse > s->objects / 4)
+				break;
+
+			if (!slab_trylock(page))
+				break;
+
+			list_move(&page->lru, &zaplist);
+			n->nr_partial--;
+			SetSlabFrozen(page);
+			slab_unlock(page);
+		}
 	out:
 		spin_unlock_irqrestore(&n->list_lock, flags);
+
+		/* Now we can free objects in the slabs on the zaplist */
+		list_for_each_entry_safe(page, page2, &zaplist, lru) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			slab_lock(page);
+			__kmem_cache_vacate(s, page, flags);
+		}
 	}
 
 	kfree(slabs_by_inuse);
@@ -3229,6 +3485,34 @@ static ssize_t ops_show(struct kmem_cach
 		x += sprint_symbol(buf + x, (unsigned long)s->ctor);
 		x += sprintf(buf + x, "\n");
 	}
+
+	if (s->ops->get) {
+		x += sprintf(buf + x, "get : ");
+		x += sprint_symbol(buf + x,
+				(unsigned long)s->ops->get);
+		x += sprintf(buf + x, "\n");
+	}
+
+	if (s->ops->put) {
+		x += sprintf(buf + x, "put : ");
+		x += sprint_symbol(buf + x,
+				(unsigned long)s->ops->put);
+		x += sprintf(buf + x, "\n");
+	}
+
+	if (s->ops->kick) {
+		x += sprintf(buf + x, "kick : ");
+		x += sprint_symbol(buf + x,
+				(unsigned long)s->ops->kick);
+		x += sprintf(buf + x, "\n");
+	}
+
+	if (s->ops->sync) {
+		x += sprintf(buf + x, "sync : ");
+		x += sprint_symbol(buf + x,
+				(unsigned long)s->ops->sync);
+		x += sprintf(buf + x, "\n");
+	}
 	return x;
 }
 SLAB_ATTR_RO(ops);
Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-05-16 22:14:34.000000000 -0700
+++ slub/mm/slab.c	2007-05-16 22:14:47.000000000 -0700
@@ -2516,6 +2516,15 @@ int kmem_cache_shrink(struct kmem_cache 
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
+/*
+ * SLAB does not support slab defragmentation
+ */
+int kmem_cache_vacate(struct page *page)
+{
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_vacate);
+
 /**
  * kmem_cache_destroy - delete a cache
  * @cachep: the cache to destroy
Index: slub/mm/slob.c
===================================================================
--- slub.orig/mm/slob.c	2007-05-16 22:13:41.000000000 -0700
+++ slub/mm/slob.c	2007-05-16 22:14:19.000000000 -0700
@@ -394,6 +394,15 @@ int kmem_cache_shrink(struct kmem_cache 
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
+/*
+ * SLOB does not support slab defragmentation
+ */
+int kmem_cache_vacate(struct page *page)
+{
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_vacate);
+
 int kmem_ptr_validate(struct kmem_cache *a, const void *b)
 {
 	return 0;

-- 
