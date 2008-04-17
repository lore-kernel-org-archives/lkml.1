Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYDQFZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYDQFZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYDQFZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:25:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55148 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYDQFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:25:31 -0400
Date: Thu, 17 Apr 2008 08:25:28 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLUB fixes for 2.6.26
Message-ID: <Pine.LNX.4.64.0804170823430.1685@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB/SLUB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Nothing fancy here, just assorted collection of small fixes and cleanups to
SLUB.

                Pekka

Christoph Lameter (5):
      slub: Reduce #ifdef ZONE_DMA by moving kmalloc_caches_dma near dma logic
      slub: Deal with config variable dependencies
      slub: Fixes to per cpu stat output in sysfs
      slub: Move map/flag clearing to __free_slab
      slub: No need for per node slab counters if !SLUB_DEBUG

Pekka Enberg (1):
      slub: Initialize per-cpu stats

 include/linux/slub_def.h |    2 +-
 init/Kconfig             |    2 +-
 lib/Kconfig.debug        |    2 +-
 mm/slub.c                |   97 ++++++++++++++++++++++++++++++----------------
 4 files changed, 67 insertions(+), 36 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index b00c1c7..79d59c9 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -45,9 +45,9 @@ struct kmem_cache_cpu {
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
-	atomic_long_t nr_slabs;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
+	atomic_long_t nr_slabs;
 	struct list_head full;
 #endif
 };
diff --git a/init/Kconfig b/init/Kconfig
index a97924b..7fccf09 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -763,7 +763,7 @@ endmenu		# General setup
 config SLABINFO
 	bool
 	depends on PROC_FS
-	depends on SLAB || SLUB
+	depends on SLAB || SLUB_DEBUG
 	default y
 
 config RT_MUTEXES
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0796c1a..eef557d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -211,7 +211,7 @@ config SLUB_DEBUG_ON
 config SLUB_STATS
 	default n
 	bool "Enable SLUB performance statistics"
-	depends on SLUB
+	depends on SLUB && SLUB_DEBUG && SYSFS
 	help
 	  SLUB statistics are useful to debug SLUBs allocation behavior in
 	  order find ways to optimize the allocator. This should never be
diff --git a/mm/slub.c b/mm/slub.c
index acc975f..7f8aaa2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -837,6 +837,35 @@ static void remove_full(struct kmem_cache *s, struct page *page)
 	spin_unlock(&n->list_lock);
 }
 
+/* Tracking of the number of slabs for debugging purposes */
+static inline unsigned long slabs_node(struct kmem_cache *s, int node)
+{
+	struct kmem_cache_node *n = get_node(s, node);
+
+	return atomic_long_read(&n->nr_slabs);
+}
+
+static inline void inc_slabs_node(struct kmem_cache *s, int node)
+{
+	struct kmem_cache_node *n = get_node(s, node);
+
+	/*
+	 * May be called early in order to allocate a slab for the
+	 * kmem_cache_node structure. Solve the chicken-egg
+	 * dilemma by deferring the increment of the count during
+	 * bootstrap (see early_kmem_cache_node_alloc).
+	 */
+	if (!NUMA_BUILD || n)
+		atomic_long_inc(&n->nr_slabs);
+}
+static inline void dec_slabs_node(struct kmem_cache *s, int node)
+{
+	struct kmem_cache_node *n = get_node(s, node);
+
+	atomic_long_dec(&n->nr_slabs);
+}
+
+/* Object debug checks for alloc/free paths */
 static void setup_object_debug(struct kmem_cache *s, struct page *page,
 								void *object)
 {
@@ -1028,6 +1057,11 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
 	return flags;
 }
 #define slub_debug 0
+
+static inline unsigned long slabs_node(struct kmem_cache *s, int node)
+							{ return 0; }
+static inline void inc_slabs_node(struct kmem_cache *s, int node) {}
+static inline void dec_slabs_node(struct kmem_cache *s, int node) {}
 #endif
 /*
  * Slab allocation and freeing
@@ -1066,7 +1100,6 @@ static void setup_object(struct kmem_cache *s, struct page *page,
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page *page;
-	struct kmem_cache_node *n;
 	void *start;
 	void *last;
 	void *p;
@@ -1078,9 +1111,7 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (!page)
 		goto out;
 
-	n = get_node(s, page_to_nid(page));
-	if (n)
-		atomic_long_inc(&n->nr_slabs);
+	inc_slabs_node(s, page_to_nid(page));
 	page->slab = s;
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
@@ -1125,6 +1156,8 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	__ClearPageSlab(page);
+	reset_page_mapcount(page);
 	__free_pages(page, s->order);
 }
 
@@ -1151,11 +1184,7 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 
 static void discard_slab(struct kmem_cache *s, struct page *page)
 {
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-
-	atomic_long_dec(&n->nr_slabs);
-	reset_page_mapcount(page);
-	__ClearPageSlab(page);
+	dec_slabs_node(s, page_to_nid(page));
 	free_slab(s, page);
 }
 
@@ -1886,15 +1915,18 @@ static void init_kmem_cache_cpu(struct kmem_cache *s,
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
+#ifdef CONFIG_SLUB_STATS
+	memset(c->stat, 0, NR_SLUB_STAT_ITEMS * sizeof(unsigned));
+#endif
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
 {
 	n->nr_partial = 0;
-	atomic_long_set(&n->nr_slabs, 0);
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
+	atomic_long_set(&n->nr_slabs, 0);
 	INIT_LIST_HEAD(&n->full);
 #endif
 }
@@ -2063,7 +2095,7 @@ static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 	init_tracking(kmalloc_caches, n);
 #endif
 	init_kmem_cache_node(n);
-	atomic_long_inc(&n->nr_slabs);
+	inc_slabs_node(kmalloc_caches, node);
 
 	/*
 	 * lockdep requires consistent irq usage for each lock
@@ -2376,7 +2408,7 @@ static inline int kmem_cache_close(struct kmem_cache *s)
 		struct kmem_cache_node *n = get_node(s, node);
 
 		n->nr_partial -= free_list(s, n, &n->partial);
-		if (atomic_long_read(&n->nr_slabs))
+		if (slabs_node(s, node))
 			return 1;
 	}
 	free_kmem_cache_nodes(s);
@@ -2409,10 +2441,6 @@ EXPORT_SYMBOL(kmem_cache_destroy);
 struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
-#ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT + 1];
-#endif
-
 static int __init setup_slub_min_order(char *str)
 {
 	get_option(&str, &slub_min_order);
@@ -2472,6 +2500,7 @@ panic:
 }
 
 #ifdef CONFIG_ZONE_DMA
+static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT + 1];
 
 static void sysfs_add_func(struct work_struct *w)
 {
@@ -2688,21 +2717,6 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
-#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SLABINFO)
-static unsigned long count_partial(struct kmem_cache_node *n)
-{
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
-		x += page->inuse;
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
-}
-#endif
-
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
  * the remaining slabs by the number of items in use. The slabs with the
@@ -2816,7 +2830,7 @@ static void slab_mem_offline_callback(void *arg)
 			 * and offline_pages() function shoudn't call this
 			 * callback. So, we must fail.
 			 */
-			BUG_ON(atomic_long_read(&n->nr_slabs));
+			BUG_ON(slabs_node(s, offline_node));
 
 			s->node[offline_node] = NULL;
 			kmem_cache_free(kmalloc_caches, n);
@@ -3181,6 +3195,21 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	return slab_alloc(s, gfpflags, node, caller);
 }
 
+#if (defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)) || defined(CONFIG_SLABINFO)
+static unsigned long count_partial(struct kmem_cache_node *n)
+{
+	unsigned long flags;
+	unsigned long x = 0;
+	struct page *page;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru)
+		x += page->inuse;
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return x;
+}
+#endif
+
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
 static int validate_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
@@ -3979,10 +4008,12 @@ static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
 
 	len = sprintf(buf, "%lu", sum);
 
+#ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
 		if (data[cpu] && len < PAGE_SIZE - 20)
-			len += sprintf(buf + len, " c%d=%u", cpu, data[cpu]);
+			len += sprintf(buf + len, " C%d=%u", cpu, data[cpu]);
 	}
+#endif
 	kfree(data);
 	return len + sprintf(buf + len, "\n");
 }
