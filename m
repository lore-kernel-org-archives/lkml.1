Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378Ab0A2Uvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0A2Uvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363Ab0A2Uva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:30 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42823 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0A2UvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:22 -0500
Message-Id: <20100129205000.826486289@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:36 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Slab defrag core
Content-Disposition: inline; filename=slub_defrag_core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab defragmentation may occur:

1. Unconditionally when kmem_cache_shrink is called on a slab cache by the
   kernel calling kmem_cache_shrink.

2. Through the use of the slabinfo command.

3. Per node defrag conditionally when kmem_cache_defrag(<node>) is called
   (can be called from reclaim code with a later patch).

   Defragmentation is only performed if the fragmentation of the slab
   is lower than the specified percentage. Fragmentation ratios are measured
   by calculating the percentage of objects in use compared to the total
   number of objects that the slab page can accomodate.

   The scanning of slab caches is optimized because the
   defragmentable slabs come first on the list. Thus we can terminate scans
   on the first slab encountered that does not support defragmentation.

   kmem_cache_defrag() takes a node parameter. This can either be -1 if
   defragmentation should be performed on all nodes, or a node number.

A couple of functions must be setup via a call to kmem_cache_setup_defrag()
in order for a slabcache to support defragmentation. These are

kmem_defrag_get_func (void *get(struct kmem_cache *s, int nr, void **objects))

	Must obtain a reference to the listed objects. SLUB guarantees that
	the objects are still allocated. However, other threads may be blocked
	in slab_free() attempting to free objects in the slab. These may succeed
	as soon as get() returns to the slab allocator. The function must
	be able to detect such situations and void the attempts to free such
	objects (by for example voiding the corresponding entry in the objects
	array).

	No slab operations may be performed in get(). Interrupts
	are disabled. What can be done is very limited. The slab lock
	for the page that contains the object is taken. Any attempt to perform
	a slab operation may lead to a deadlock.

	kmem_defrag_get_func returns a private pointer that is passed to
	kmem_defrag_kick_func(). Should we be unable to obtain all references
	then that pointer may indicate to the kick() function that it should
	not attempt any object removal or move but simply remove the
	reference counts.

kmem_defrag_kick_func (void kick(struct kmem_cache *, int nr, void **objects,
							void *get_result))

	After SLUB has established references to the objects in a
	slab it will then drop all locks and use kick() to move objects out
	of the slab. The existence of the object is guaranteed by virtue of
	the earlier obtained references via kmem_defrag_get_func(). The
	callback may perform any slab operation since no locks are held at
	the time of call.

	The callback should remove the object from the slab in some way. This
	may be accomplished by reclaiming the object and then running
	kmem_cache_free() or reallocating it and then running
	kmem_cache_free(). Reallocation is advantageous because the partial
	slabs were just sorted to have the partial slabs with the most objects
	first. Reallocation is likely to result in filling up a slab in
	addition to freeing up one slab. A filled up slab can also be removed
	from the partial list. So there could be a double effect.

	kmem_defrag_kick_func() does not return a result. SLUB will check
	the number of remaining objects in the slab. If all objects were
	removed then the slab is freed and we have reduced the overall
	fragmentation of the slab cache.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/slab.h |    3 
 mm/slub.c            |  265 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 215 insertions(+), 53 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-01-29 10:27:21.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-01-29 10:27:24.000000000 -0600
@@ -132,10 +132,10 @@
 
 /*
  * Maximum number of desirable partial slabs.
- * The existence of more partial slabs makes kmem_cache_shrink
- * sort the partial list by the number of objects in the.
+ * More slabs cause kmem_cache_shrink to sort the slabs by objects
+ * and triggers slab defragmentation.
  */
-#define MAX_PARTIAL 10
+#define MAX_PARTIAL 20
 
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
@@ -3012,76 +3012,235 @@ void kmem_cache_setup_defrag(struct kmem
 EXPORT_SYMBOL(kmem_cache_setup_defrag);
 
 /*
- * kmem_cache_shrink removes empty slabs from the partial lists and sorts
- * the remaining slabs by the number of items in use. The slabs with the
- * most items in use come first. New allocations will then fill those up
- * and thus they can be removed from the partial lists.
+ * Vacate all objects in the given slab.
  *
- * The slabs with the least items are placed last. This results in them
- * being allocated from last increasing the chance that the last objects
- * are freed in them.
+ * The scratch aread passed to list function is sufficient to hold
+ * struct listhead times objects per slab. We use it to hold void ** times
+ * objects per slab plus a bitmap for each object.
  */
-int kmem_cache_shrink(struct kmem_cache *s)
+static int kmem_cache_vacate(struct page *page, void *scratch)
 {
-	int node;
-	int i;
-	struct kmem_cache_node *n;
-	struct page *page;
-	struct page *t;
-	int objects = oo_objects(s->max);
-	struct list_head *slabs_by_inuse =
-		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
+	void **vector = scratch;
+	void *p;
+	void *addr = page_address(page);
+	struct kmem_cache *s;
+	unsigned long *map;
+	int leftover;
+	int count;
+	void *private;
 	unsigned long flags;
+	unsigned long objects;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
+	local_irq_save(flags);
+	slab_lock(page);
 
-	flush_all(s);
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		n = get_node(s, node);
+	BUG_ON(!PageSlab(page));	/* Must be s slab page */
+	BUG_ON(!SlabFrozen(page));	/* Slab must have been frozen earlier */
+
+	s = page->slab;
+	objects = page->objects;
+	map = scratch + objects * sizeof(void **);
+	if (!page->inuse || !s->kick)
+		goto out;
+
+	/* Determine used objects */
+	bitmap_fill(map, objects);
+	for_each_free_object(p, s, page->freelist)
+		__clear_bit(slab_index(p, s, addr), map);
+
+	/* Build vector of pointers to objects */
+	count = 0;
+	memset(vector, 0, objects * sizeof(void **));
+	for_each_object(p, s, addr, objects)
+		if (test_bit(slab_index(p, s, addr), map))
+			vector[count++] = p;
+
+	private = s->get(s, count, vector);
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
+	 * Perform the KICK callbacks to remove the objects.
+	 */
+	s->kick(s, count, vector, private);
+
+	local_irq_save(flags);
+	slab_lock(page);
+out:
+	/*
+	 * Check the result and unfreeze the slab
+	 */
+	leftover = page->inuse;
+	unfreeze_slab(s, page, leftover > 0);
+	local_irq_restore(flags);
+	return leftover;
+}
+
+/*
+ * Remove objects from a list of slab pages that have been gathered.
+ * Must be called with slabs that have been isolated before.
+ *
+ * kmem_cache_reclaim() is never called from an atomic context. It
+ * allocates memory for temporary storage. We are holding the
+ * slub_lock semaphore which prevents another call into
+ * the defrag logic.
+ */
+int kmem_cache_reclaim(struct list_head *zaplist)
+{
+	int freed = 0;
+	void **scratch;
+	struct page *page;
+	struct page *page2;
+
+	if (list_empty(zaplist))
+		return 0;
+
+	scratch = alloc_scratch();
+	if (!scratch)
+		return 0;
+
+	list_for_each_entry_safe(page, page2, zaplist, lru) {
+		list_del(&page->lru);
+		if (kmem_cache_vacate(page, scratch) == 0)
+			freed++;
+	}
+	kfree(scratch);
+	return freed;
+}
+
+/*
+ * Shrink the slab cache on a particular node of the cache
+ * by releasing slabs with zero objects and trying to reclaim
+ * slabs with less than the configured percentage of objects allocated.
+ */
+static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
+							unsigned long limit)
+{
+	unsigned long flags;
+	struct page *page, *page2;
+	LIST_HEAD(zaplist);
+	int freed = 0;
+	struct kmem_cache_node *n = get_node(s, node);
 
-		if (!n->nr_partial)
+	if (n->nr_partial <= limit)
+		return 0;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry_safe(page, page2, &n->partial, lru) {
+		if (!slab_trylock(page))
+			/* Busy slab. Get out of the way */
 			continue;
 
-		for (i = 0; i < objects; i++)
-			INIT_LIST_HEAD(slabs_by_inuse + i);
+		if (page->inuse) {
+			if (page->inuse * 100 >=
+					s->defrag_ratio * page->objects) {
+				slab_unlock(page);
+				/* Slab contains enough objects */
+				continue;
+			}
 
-		spin_lock_irqsave(&n->list_lock, flags);
+			list_move(&page->lru, &zaplist);
+			if (s->kick) {
+				n->nr_partial--;
+				SetSlabFrozen(page);
+			}
+			slab_unlock(page);
+		} else {
+			/* Empty slab page */
+			list_del(&page->lru);
+			n->nr_partial--;
+			slab_unlock(page);
+			discard_slab(s, page);
+			freed++;
+		}
+	}
 
+	if (!s->kick)
 		/*
-		 * Build lists indexed by the items in use in each slab.
+		 * No defrag methods. By simply putting the zaplist at the
+		 * end of the partial list we can let them simmer longer
+		 * and thus increase the chance of all objects being
+		 * reclaimed.
 		 *
-		 * Note that concurrent frees may occur while we hold the
-		 * list_lock. page->inuse here is the upper limit.
+		 * We have effectively sorted the partial list and put
+		 * the slabs with more objects first. As soon as they
+		 * are allocated they are going to be removed from the
+		 * partial list.
 		 */
-		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			if (!page->inuse && slab_trylock(page)) {
-				/*
-				 * Must hold slab lock here because slab_free
-				 * may have freed the last object and be
-				 * waiting to release the slab.
-				 */
-				list_del(&page->lru);
-				n->nr_partial--;
-				slab_unlock(page);
-				discard_slab(s, page);
-			} else {
-				list_move(&page->lru,
-				slabs_by_inuse + page->inuse);
-			}
-		}
+		list_splice(&zaplist, n->partial.prev);
+
+
+	spin_unlock_irqrestore(&n->list_lock, flags);
+
+	if (s->kick)
+		freed += kmem_cache_reclaim(&zaplist);
+
+	return freed;
+}
+
+/*
+ * Defrag slabs conditional on the amount of fragmentation in a page.
+ */
+int kmem_cache_defrag(int node)
+{
+	struct kmem_cache *s;
+	unsigned long slabs = 0;
+
+	/*
+	 * kmem_cache_defrag may be called from the reclaim path which may be
+	 * called for any page allocator alloc. So there is the danger that we
+	 * get called in a situation where slub already acquired the slub_lock
+	 * for other purposes.
+	 */
+	if (!down_read_trylock(&slub_lock))
+		return 0;
+
+	list_for_each_entry(s, &slab_caches, list) {
+		unsigned long reclaimed = 0;
 
 		/*
-		 * Rebuild the partial list with the slabs filled up most
-		 * first and the least used slabs at the end.
+		 * Defragmentable caches come first. If the slab cache is not
+		 * defragmentable then we can stop traversing the list.
 		 */
-		for (i = objects - 1; i >= 0; i--)
-			list_splice(slabs_by_inuse + i, n->partial.prev);
+		if (!s->kick)
+			break;
 
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		if (node == -1) {
+			int nid;
+
+			for_each_node_state(nid, N_NORMAL_MEMORY)
+				reclaimed += __kmem_cache_shrink(s, nid,
+								MAX_PARTIAL);
+		} else
+			reclaimed = __kmem_cache_shrink(s, node, MAX_PARTIAL);
+
+		slabs += reclaimed;
 	}
+	up_read(&slub_lock);
+	return slabs;
+}
+EXPORT_SYMBOL(kmem_cache_defrag);
+
+/*
+ * kmem_cache_shrink removes empty slabs from the partial lists.
+ * If the slab cache supports defragmentation then objects are
+ * reclaimed.
+ */
+int kmem_cache_shrink(struct kmem_cache *s)
+{
+	int node;
+
+	flush_all(s);
+	for_each_node_state(node, N_NORMAL_MEMORY)
+		__kmem_cache_shrink(s, node, 0);
 
-	kfree(slabs_by_inuse);
 	return 0;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2010-01-29 10:27:17.000000000 -0600
+++ linux-2.6/include/linux/slab.h	2010-01-29 10:27:24.000000000 -0600
@@ -180,13 +180,16 @@ typedef void kmem_defrag_kick_func(struc
 
 /*
  * kmem_cache_setup_defrag() is used to setup callbacks for a slab cache.
+ * kmem_cache_defrag() performs the actual defragmentation.
  */
 #ifdef CONFIG_SLUB
 void kmem_cache_setup_defrag(struct kmem_cache *, kmem_defrag_get_func,
 						kmem_defrag_kick_func);
+int kmem_cache_defrag(int node);
 #else
 static inline void kmem_cache_setup_defrag(struct kmem_cache *s,
 	kmem_defrag_get_func get, kmem_defrag_kick_func kiok) {}
+static inline int kmem_cache_defrag(int node) { return 0; }
 #endif
 
 /*

-- 
