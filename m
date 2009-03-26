Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZCZIeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZCZIeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZCZIdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:33:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54128 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbZCZIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:33:48 -0400
Date: Thu, 26 Mar 2009 10:33:43 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, akinobu.mita@gmail.com, mingo@elte.hu,
       mpm@selenic.com, npiggin@suse.de, rientjes@google.com,
       wangcong@zeuux.org, yanmin_zhang@linux.intel.com
Subject: [GIT PULL] SLAB updates for 2.6.30-rc1
Message-ID: <Pine.LNX.4.64.0903261032480.21843@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696229367-1631196429-1238056423=:21843"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696229367-1631196429-1238056423=:21843
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

Please pull the latest SLAB three which contains the following changes:

  - SLOB locking fix (Nick Pigging)

  - Bump up page allocator pass-through threshold to PAGE_SIZE * 2 to fix a
    netperf regression (Zhang Yanmin, Christoph Lameter)

  - Per-cache 'min_partial' tunable (David Rientjes)

  - Assorted cleanups to SLUB and SLOB (Akinobu Mita, Americo Wang)

Thanks!

		Pekka

The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

Akinobu Mita (1):
      slub: use get_track()

Américo Wang (1):
      slob: clean up the code

Christoph Lameter (1):
      SLUB: Introduce and use SLUB_MAX_SIZE and SLUB_PAGE_SHIFT constants

David Rientjes (3):
      slub: move min_partial to struct kmem_cache
      slub: add min_partial sysfs tunable
      slub: rename calculate_min_partial() to set_min_partial()

Nick Piggin (1):
      slob: fix lockup in slob_free()

Pekka Enberg (3):
      SLUB: Use ->objsize from struct kmem_cache_cpu in slab_free()
      SLUB: Do not pass 8k objects through to the page allocator
      Merge branches 'topic/slob/cleanups', 'topic/slob/fixes', 'topic/slub/core', 'topic/slub/cleanups' and 'topic/slub/perf' into for-linus

Zhang Yanmin (1):
      SLUB: Fix default slab order for big object sizes

 include/linux/slub_def.h |   21 +++++++++--
 mm/slob.c                |   43 +++++++++++++++---------
 mm/slub.c                |   82 +++++++++++++++++++++++++++++-----------------
 3 files changed, 96 insertions(+), 50 deletions(-)

 include/linux/slub_def.h |   21 +++++++++--
 mm/slob.c                |   43 +++++++++++++++---------
 mm/slub.c                |   82 +++++++++++++++++++++++++++++-----------------
 3 files changed, 96 insertions(+), 50 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 2f5c16b..e37b6aa 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -46,7 +46,6 @@ struct kmem_cache_cpu {
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
-	unsigned long min_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_t nr_slabs;
@@ -89,6 +88,7 @@ struct kmem_cache {
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
+	unsigned long min_partial;
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SLUB_DEBUG
@@ -121,10 +121,23 @@ struct kmem_cache {
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 
 /*
+ * Maximum kmalloc object size handled by SLUB. Larger object allocations
+ * are passed through to the page allocator. The page allocator "fastpath"
+ * is relatively slow so we need this value sufficiently high so that
+ * performance critical objects are allocated through the SLUB fastpath.
+ *
+ * This should be dropped to PAGE_SIZE / 2 once the page allocator
+ * "fastpath" becomes competitive with the slab allocator fastpaths.
+ */
+#define SLUB_MAX_SIZE (2 * PAGE_SIZE)
+
+#define SLUB_PAGE_SHIFT (PAGE_SHIFT + 2)
+
+/*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
  */
-extern struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1];
+extern struct kmem_cache kmalloc_caches[SLUB_PAGE_SHIFT];
 
 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -212,7 +225,7 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
-		if (size > PAGE_SIZE)
+		if (size > SLUB_MAX_SIZE)
 			return kmalloc_large(size, flags);
 
 		if (!(flags & SLUB_DMA)) {
@@ -234,7 +247,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	if (__builtin_constant_p(size) &&
-		size <= PAGE_SIZE && !(flags & SLUB_DMA)) {
+		size <= SLUB_MAX_SIZE && !(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
diff --git a/mm/slob.c b/mm/slob.c
index 52bc8a2..0bfa680 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -126,9 +126,9 @@ static LIST_HEAD(free_slob_medium);
 static LIST_HEAD(free_slob_large);
 
 /*
- * slob_page: True for all slob pages (false for bigblock pages)
+ * is_slob_page: True for all slob pages (false for bigblock pages)
  */
-static inline int slob_page(struct slob_page *sp)
+static inline int is_slob_page(struct slob_page *sp)
 {
 	return PageSlobPage((struct page *)sp);
 }
@@ -143,6 +143,11 @@ static inline void clear_slob_page(struct slob_page *sp)
 	__ClearPageSlobPage((struct page *)sp);
 }
 
+static inline struct slob_page *slob_page(const void *addr)
+{
+	return (struct slob_page *)virt_to_page(addr);
+}
+
 /*
  * slob_page_free: true for pages on free_slob_pages list.
  */
@@ -230,7 +235,7 @@ static int slob_last(slob_t *s)
 	return !((unsigned long)slob_next(s) & ~PAGE_MASK);
 }
 
-static void *slob_new_page(gfp_t gfp, int order, int node)
+static void *slob_new_pages(gfp_t gfp, int order, int node)
 {
 	void *page;
 
@@ -247,12 +252,17 @@ static void *slob_new_page(gfp_t gfp, int order, int node)
 	return page_address(page);
 }
 
+static void slob_free_pages(void *b, int order)
+{
+	free_pages((unsigned long)b, order);
+}
+
 /*
  * Allocate a slob block within a given slob_page sp.
  */
 static void *slob_page_alloc(struct slob_page *sp, size_t size, int align)
 {
-	slob_t *prev, *cur, *aligned = 0;
+	slob_t *prev, *cur, *aligned = NULL;
 	int delta = 0, units = SLOB_UNITS(size);
 
 	for (prev = NULL, cur = sp->free; ; prev = cur, cur = slob_next(cur)) {
@@ -349,10 +359,10 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 
 	/* Not enough space: must allocate a new page */
 	if (!b) {
-		b = slob_new_page(gfp & ~__GFP_ZERO, 0, node);
+		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
 		if (!b)
-			return 0;
-		sp = (struct slob_page *)virt_to_page(b);
+			return NULL;
+		sp = slob_page(b);
 		set_slob_page(sp);
 
 		spin_lock_irqsave(&slob_lock, flags);
@@ -384,7 +394,7 @@ static void slob_free(void *block, int size)
 		return;
 	BUG_ON(!size);
 
-	sp = (struct slob_page *)virt_to_page(block);
+	sp = slob_page(block);
 	units = SLOB_UNITS(size);
 
 	spin_lock_irqsave(&slob_lock, flags);
@@ -393,10 +403,11 @@ static void slob_free(void *block, int size)
 		/* Go directly to page allocator. Do not pass slob allocator */
 		if (slob_page_free(sp))
 			clear_slob_page_free(sp);
+		spin_unlock_irqrestore(&slob_lock, flags);
 		clear_slob_page(sp);
 		free_slob_page(sp);
 		free_page((unsigned long)b);
-		goto out;
+		return;
 	}
 
 	if (!slob_page_free(sp)) {
@@ -476,7 +487,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 	} else {
 		void *ret;
 
-		ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
+		ret = slob_new_pages(gfp | __GFP_COMP, get_order(size), node);
 		if (ret) {
 			struct page *page;
 			page = virt_to_page(ret);
@@ -494,8 +505,8 @@ void kfree(const void *block)
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
-	sp = (struct slob_page *)virt_to_page(block);
-	if (slob_page(sp)) {
+	sp = slob_page(block);
+	if (is_slob_page(sp)) {
 		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
@@ -513,8 +524,8 @@ size_t ksize(const void *block)
 	if (unlikely(block == ZERO_SIZE_PTR))
 		return 0;
 
-	sp = (struct slob_page *)virt_to_page(block);
-	if (slob_page(sp)) {
+	sp = slob_page(block);
+	if (is_slob_page(sp)) {
 		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		return SLOB_UNITS(*m) * SLOB_UNIT;
@@ -573,7 +584,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 	if (c->size < PAGE_SIZE)
 		b = slob_alloc(c->size, flags, c->align, node);
 	else
-		b = slob_new_page(flags, get_order(c->size), node);
+		b = slob_new_pages(flags, get_order(c->size), node);
 
 	if (c->ctor)
 		c->ctor(b);
@@ -587,7 +598,7 @@ static void __kmem_cache_free(void *b, int size)
 	if (size < PAGE_SIZE)
 		slob_free(b, size);
 	else
-		free_pages((unsigned long)b, get_order(size));
+		slob_free_pages(b, get_order(size));
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
diff --git a/mm/slub.c b/mm/slub.c
index 0280eee..c65a4ed 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -374,14 +374,8 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 static void set_track(struct kmem_cache *s, void *object,
 			enum track_item alloc, unsigned long addr)
 {
-	struct track *p;
-
-	if (s->offset)
-		p = object + s->offset + sizeof(void *);
-	else
-		p = object + s->inuse;
+	struct track *p = get_track(s, object, alloc);
 
-	p += alloc;
 	if (addr) {
 		p->addr = addr;
 		p->cpu = smp_processor_id();
@@ -1335,7 +1329,7 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
 		n = get_node(s, zone_to_nid(zone));
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
-				n->nr_partial > n->min_partial) {
+				n->nr_partial > s->min_partial) {
 			page = get_partial_node(n);
 			if (page)
 				return page;
@@ -1387,7 +1381,7 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 		slab_unlock(page);
 	} else {
 		stat(c, DEACTIVATE_EMPTY);
-		if (n->nr_partial < n->min_partial) {
+		if (n->nr_partial < s->min_partial) {
 			/*
 			 * Adding an empty slab to the partial slabs in order
 			 * to avoid page allocator overhead. This slab needs
@@ -1724,7 +1718,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	c = get_cpu_slab(s, smp_processor_id());
 	debug_check_no_locks_freed(object, c->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(object, s->objsize);
+		debug_check_no_obj_freed(object, c->objsize);
 	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
@@ -1844,6 +1838,7 @@ static inline int calculate_order(int size)
 	int order;
 	int min_objects;
 	int fraction;
+	int max_objects;
 
 	/*
 	 * Attempt to find best configuration for a slab. This
@@ -1856,6 +1851,9 @@ static inline int calculate_order(int size)
 	min_objects = slub_min_objects;
 	if (!min_objects)
 		min_objects = 4 * (fls(nr_cpu_ids) + 1);
+	max_objects = (PAGE_SIZE << slub_max_order)/size;
+	min_objects = min(min_objects, max_objects);
+
 	while (min_objects > 1) {
 		fraction = 16;
 		while (fraction >= 4) {
@@ -1865,7 +1863,7 @@ static inline int calculate_order(int size)
 				return order;
 			fraction /= 2;
 		}
-		min_objects /= 2;
+		min_objects --;
 	}
 
 	/*
@@ -1928,17 +1926,6 @@ static void
 init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 {
 	n->nr_partial = 0;
-
-	/*
-	 * The larger the object size is, the more pages we want on the partial
-	 * list to avoid pounding the page allocator excessively.
-	 */
-	n->min_partial = ilog2(s->size);
-	if (n->min_partial < MIN_PARTIAL)
-		n->min_partial = MIN_PARTIAL;
-	else if (n->min_partial > MAX_PARTIAL)
-		n->min_partial = MAX_PARTIAL;
-
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
@@ -2181,6 +2168,15 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 }
 #endif
 
+static void set_min_partial(struct kmem_cache *s, unsigned long min)
+{
+	if (min < MIN_PARTIAL)
+		min = MIN_PARTIAL;
+	else if (min > MAX_PARTIAL)
+		min = MAX_PARTIAL;
+	s->min_partial = min;
+}
+
 /*
  * calculate_sizes() determines the order and the distribution of data within
  * a slab object.
@@ -2319,6 +2315,11 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	if (!calculate_sizes(s, -1))
 		goto error;
 
+	/*
+	 * The larger the object size is, the more pages we want on the partial
+	 * list to avoid pounding the page allocator excessively.
+	 */
+	set_min_partial(s, ilog2(s->size));
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -2475,7 +2476,7 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  *		Kmalloc subsystem
  *******************************************************************/
 
-struct kmem_cache kmalloc_caches[PAGE_SHIFT + 1] __cacheline_aligned;
+struct kmem_cache kmalloc_caches[SLUB_PAGE_SHIFT] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
 static int __init setup_slub_min_order(char *str)
@@ -2537,7 +2538,7 @@ panic:
 }
 
 #ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT + 1];
+static struct kmem_cache *kmalloc_caches_dma[SLUB_PAGE_SHIFT];
 
 static void sysfs_add_func(struct work_struct *w)
 {
@@ -2658,7 +2659,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large(size, flags);
 
 	s = get_slab(size, flags);
@@ -2686,7 +2687,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large_node(size, flags, node);
 
 	s = get_slab(size, flags);
@@ -2986,7 +2987,7 @@ void __init kmem_cache_init(void)
 		caches++;
 	}
 
-	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++) {
+	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
 		create_kmalloc_cache(&kmalloc_caches[i],
 			"kmalloc", 1 << i, GFP_KERNEL);
 		caches++;
@@ -3023,7 +3024,7 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++)
+	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++)
 		kmalloc_caches[i]. name =
 			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
 
@@ -3223,7 +3224,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large(size, gfpflags);
 
 	s = get_slab(size, gfpflags);
@@ -3239,7 +3240,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 {
 	struct kmem_cache *s;
 
-	if (unlikely(size > PAGE_SIZE))
+	if (unlikely(size > SLUB_MAX_SIZE))
 		return kmalloc_large_node(size, gfpflags, node);
 
 	s = get_slab(size, gfpflags);
@@ -3836,6 +3837,26 @@ static ssize_t order_show(struct kmem_cache *s, char *buf)
 }
 SLAB_ATTR(order);
 
+static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%lu\n", s->min_partial);
+}
+
+static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
+				 size_t length)
+{
+	unsigned long min;
+	int err;
+
+	err = strict_strtoul(buf, 10, &min);
+	if (err)
+		return err;
+
+	set_min_partial(s, min);
+	return length;
+}
+SLAB_ATTR(min_partial);
+
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
 	if (s->ctor) {
@@ -4151,6 +4172,7 @@ static struct attribute *slab_attrs[] = {
 	&object_size_attr.attr,
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
+	&min_partial_attr.attr,
 	&objects_attr.attr,
 	&objects_partial_attr.attr,
 	&total_objects_attr.attr,
---696229367-1631196429-1238056423=:21843--
