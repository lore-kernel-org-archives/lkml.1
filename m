Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZCZJo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZCZJo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZCZJnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:43:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49632 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZCZJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:43:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nxtmh3GZgAIYf7+skl1hmCeDr44mjgJupJqFoGjxk/qONzzpO9C47UJs7bsczAeC2
	Ixb87D3cthe8TSp0qiXhA==
Date: Thu, 26 Mar 2009 02:42:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/3] slub: scan partial list for free slabs when thrashing
In-Reply-To: <alpine.DEB.2.00.0903260240390.1454@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903260241150.1454@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903260240390.1454@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To determine when a slab is actually thrashing, it's insufficient to only
look at the most recent allocation path.  It's perfectly valid to swap
the cpu slab with a partial slab that contains very few free objects if
the goal is to quickly fill it since slub no longer needs to track such
slabs.

This is inefficient if an object will immediately be freed so that the
full slab must be readded to the partial list.  With certain object
allocation and freeing patterns, it is possible to spend more time
processing the partial list than utilizing the fastpaths.

We already have a per-cache min_free_watermark setting that is
configurable from userspace, which helps determine when we have excessive
partial list handling.  When a slab does not fulfill its watermark, it
suggests that the cache may be thrashing.  A pre-defined value,
SLAB_THRASHING_THRESHOLD (which defaults to 3), is implemented to be used
in conjunction with this statistic to determine when a slab is actually
thrashing.

Whenever a cpu cache satisfies a fastpath allocation, a fastpath counter
is incrememted.  This counter is cleared whenever the slowpath is
invoked.  This tracks how many fastpath allocations the cpu slab has
fulfilled before it must be refilled.

When the slowpath must be invoked, a slowpath counter is incremented if
the cpu slab did not fulfill the thrashing watermark.  Otherwise, it is
decremented.

When the slowpath counter is greater than or equal to
SLAB_THRASHING_THRESHOLD, the partial list is scanned for a slab that
will be able to fulfill at least the number of objects required to not
be considered thrashing.  If no such slabs are available, the remote
nodes are defragmented (if allowed) or a new slab is allocated.

If a cpu slab must be swapped because the allocation is for a different
node, both counters are cleared since this doesn't indicate any
thrashing behavior.

When /sys/kernel/slab/cache/slab_thrash_ratio is not set, this does not
include any functional change other than the incrementing of a fastpath
counter for the per-cpu cache.

A new statistic, /sys/kernel/slab/cache/deferred_partial, indicates how
many times a partial list was deferred because no slabs could satisfy
the requisite number of objects for CONFIG_SLUB_STATS kernels.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/slub_def.h |    3 +
 mm/slub.c                |   93 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 76 insertions(+), 20 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -30,6 +30,7 @@ enum stat_item {
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
+	DEFERRED_PARTIAL,	/* Defer local partial list for lack of objs */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
@@ -38,6 +39,8 @@ struct kmem_cache_cpu {
 	int node;		/* The node of the page (or -1 for debug) */
 	unsigned int offset;	/* Freepointer offset (in word units) */
 	unsigned int objsize;	/* Size of an object (from kmem_cache) */
+	u16 fastpath_allocs;	/* Consecutive fast allocs before slowpath */
+	u16 slowpath_allocs;	/* Consecutive slow allocs before watermark */
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -134,6 +134,19 @@
  */
 #define MAX_PARTIAL 10
 
+/*
+ * Number of successive slowpath allocations that have failed to allocate at
+ * least the number of objects in the fastpath to not be slab thrashing (as
+ * defined by the cache's slab thrash ratio).
+ *
+ * When an allocation follows the slowpath, it increments a counter in its cpu
+ * cache.  If this counter exceeds the threshold, the partial list is scanned
+ * for a slab that will satisfy at least the cache's min_free_watermark in
+ * order for it to be used.  Otherwise, the slab with the most free objects is
+ * used.
+ */
+#define SLAB_THRASHING_THRESHOLD 3
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 
@@ -1252,28 +1265,30 @@ static void remove_partial(struct kmem_cache *s, struct page *page)
 }
 
 /*
- * Lock slab and remove from the partial list.
+ * Remove from the partial list.
  *
- * Must hold list_lock.
+ * Must hold n->list_lock and slab_lock(page).
  */
-static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
-							struct page *page)
+static inline void freeze_slab(struct kmem_cache_node *n, struct page *page)
 {
-	if (slab_trylock(page)) {
-		list_del(&page->lru);
-		n->nr_partial--;
-		__SetPageSlubFrozen(page);
-		return 1;
-	}
-	return 0;
+	list_del(&page->lru);
+	n->nr_partial--;
+	__SetPageSlubFrozen(page);
+}
+
+static inline int skip_partial(struct kmem_cache *s, struct page *page)
+{
+	return (page->objects - page->inuse) < s->min_free_watermark;
 }
 
 /*
  * Try to allocate a partial slab from a specific node.
  */
-static struct page *get_partial_node(struct kmem_cache_node *n)
+static struct page *get_partial_node(struct kmem_cache *s,
+				     struct kmem_cache_node *n, int thrashing)
 {
 	struct page *page;
+	int locked = 0;
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
@@ -1286,9 +1301,28 @@ static struct page *get_partial_node(struct kmem_cache_node *n)
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry(page, &n->partial, lru)
-		if (lock_and_freeze_slab(n, page))
+		if (slab_trylock(page)) {
+			/*
+			 * When the cpu cache is partial list thrashing, it's
+			 * necessary to replace the cpu slab with one that will
+			 * accommodate at least s->min_free_watermark objects
+			 * to avoid excessive list_lock contention and cache
+			 * polluting.
+			 *
+			 * If no such slabs exist on the partial list, remote
+			 * nodes are defragmented if allowed.
+			 */
+			if (thrashing && skip_partial(s, page)) {
+				slab_unlock(page);
+				locked++;
+				continue;
+			}
+			freeze_slab(n, page);
 			goto out;
+		}
 	page = NULL;
+	if (locked)
+		stat(get_cpu_slab(s, raw_smp_processor_id()), DEFERRED_PARTIAL);
 out:
 	spin_unlock(&n->list_lock);
 	return page;
@@ -1297,7 +1331,8 @@ out:
 /*
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
-static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
+static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
+				    int thrashing)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
@@ -1336,7 +1371,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 				n->nr_partial > n->min_partial) {
-			page = get_partial_node(n);
+			page = get_partial_node(s, n, thrashing);
 			if (page)
 				return page;
 		}
@@ -1348,16 +1383,17 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
 /*
  * Get a partial page, lock it and return it.
  */
-static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
+static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node,
+				int thrashing)
 {
 	struct page *page;
 	int searchnode = (node == -1) ? numa_node_id() : node;
 
-	page = get_partial_node(get_node(s, searchnode));
+	page = get_partial_node(s, get_node(s, searchnode), thrashing);
 	if (page || (flags & __GFP_THISNODE))
 		return page;
 
-	return get_any_partial(s, flags);
+	return get_any_partial(s, flags, thrashing);
 }
 
 /*
@@ -1509,6 +1545,7 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 {
 	void **object;
 	struct page *new;
+	int is_empty = 0;
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1517,7 +1554,8 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		goto new_slab;
 
 	slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
+	is_empty = node_match(c, node);
+	if (unlikely(!is_empty))
 		goto another_slab;
 
 	stat(c, ALLOC_REFILL);
@@ -1542,7 +1580,17 @@ another_slab:
 	deactivate_slab(s, c);
 
 new_slab:
-	new = get_partial(s, gfpflags, node);
+	if (is_empty) {
+		if (c->fastpath_allocs < s->min_free_watermark)
+			c->slowpath_allocs++;
+		else if (c->slowpath_allocs)
+			c->slowpath_allocs--;
+	} else
+		c->slowpath_allocs = 0;
+	c->fastpath_allocs = 0;
+
+	new = get_partial(s, gfpflags, node,
+			  c->slowpath_allocs > SLAB_THRASHING_THRESHOLD);
 	if (new) {
 		c->page = new;
 		stat(c, ALLOC_FROM_PARTIAL);
@@ -1611,6 +1659,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	else {
 		object = c->freelist;
 		c->freelist = object[c->offset];
+		c->fastpath_allocs++;
 		stat(c, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
@@ -1919,6 +1968,8 @@ static void init_kmem_cache_cpu(struct kmem_cache *s,
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
+	c->fastpath_allocs = 0;
+	c->slowpath_allocs = 0;
 #ifdef CONFIG_SLUB_STATS
 	memset(c->stat, 0, NR_SLUB_STAT_ITEMS * sizeof(unsigned));
 #endif
@@ -4172,6 +4223,7 @@ STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
+STAT_ATTR(DEFERRED_PARTIAL, deferred_partial);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4226,6 +4278,7 @@ static struct attribute *slab_attrs[] = {
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
 	&order_fallback_attr.attr,
+	&deferred_partial_attr.attr,
 #endif
 	NULL
 };
