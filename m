Return-Path: <linux-kernel-owner+w=401wt.eu-S935225AbYD1PI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935225AbYD1PI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934996AbYD1PID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:08:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51463 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYD1PH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:07:58 -0400
Date: Mon, 28 Apr 2008 18:07:47 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: clameter@sgi.com, linux-kernel@vger.kernel.org, mpm@selenic.com,
       yi.li@analog.com, cooloney@kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vegard.nossum@gmail.com,
       yanmin.zhang@intel.com
Subject: [GIT PULL] SLUB/SLOB updates for 2.6.26
Message-ID: <Pine.LNX.4.64.0804281800510.18490@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

It contains some SLUB/SLOB fixes and the variable order page allocation 
patches to SLUB that lets the allocator fallback to smaller order 
allocations on memory pressure while letting high CPU count machines use 
large orders by default.

                Pekka

Christoph Lameter (13):
      slub: free_list() cleanup
      slub: Dump list of objects not freed on kmem_cache_close()
      slub: Store max number of objects in the page struct.
      slub: for_each_object must be passed the number of objects in a slab
      slub: Add kmem_cache_order_objects struct
      slub: Update statistics handling for variable order slabs
      slub: Fallback to minimal order during slab page allocation
      slub: Drop fallback to page allocator method
      slub: Make the order configurable for each slab cache
      slub: Simplify any_slab_object checks
      slub: Drop DEFAULT_MAX_ORDER / DEFAULT_MIN_OBJECTS
      slub: Calculate min_objects based on number of processors.
      slub: pack objects denser

Pekka Enberg (1):
      slub: improve kmem_cache_destroy() error message

Yi Li (1):
      slob: fix bug - when slob allocates "struct kmem_cache", it does not force alignment.

 Documentation/vm/slabinfo.c |   27 +--
 include/linux/mm_types.h    |    5 +-
 include/linux/slub_def.h    |   16 ++-
 mm/slob.c                   |    3 +-
 mm/slub.c                   |  481 ++++++++++++++++++++++++++-----------------
 5 files changed, 318 insertions(+), 214 deletions(-)

diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index 22d7e3e..d3ce295 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -31,7 +31,7 @@ struct slabinfo {
 	int hwcache_align, object_size, objs_per_slab;
 	int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
-	unsigned long partial, objects, slabs;
+	unsigned long partial, objects, slabs, objects_partial, objects_total;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
 	unsigned long free_frozen, free_add_partial, free_remove_partial;
@@ -540,7 +540,8 @@ void slabcache(struct slabinfo *s)
 		return;
 
 	store_size(size_str, slab_size(s));
-	snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs, s->partial, s->cpu_slabs);
+	snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs - s->cpu_slabs,
+						s->partial, s->cpu_slabs);
 
 	if (!line++)
 		first_line();
@@ -776,7 +777,6 @@ void totals(void)
 		unsigned long used;
 		unsigned long long wasted;
 		unsigned long long objwaste;
-		long long objects_in_partial_slabs;
 		unsigned long percentage_partial_slabs;
 		unsigned long percentage_partial_objs;
 
@@ -790,18 +790,11 @@ void totals(void)
 		wasted = size - used;
 		objwaste = s->slab_size - s->object_size;
 
-		objects_in_partial_slabs = s->objects -
-			(s->slabs - s->partial - s ->cpu_slabs) *
-			s->objs_per_slab;
-
-		if (objects_in_partial_slabs < 0)
-			objects_in_partial_slabs = 0;
-
 		percentage_partial_slabs = s->partial * 100 / s->slabs;
 		if (percentage_partial_slabs > 100)
 			percentage_partial_slabs = 100;
 
-		percentage_partial_objs = objects_in_partial_slabs * 100
+		percentage_partial_objs = s->objects_partial * 100
 							/ s->objects;
 
 		if (percentage_partial_objs > 100)
@@ -823,8 +816,8 @@ void totals(void)
 			min_objects = s->objects;
 		if (used < min_used)
 			min_used = used;
-		if (objects_in_partial_slabs < min_partobj)
-			min_partobj = objects_in_partial_slabs;
+		if (s->objects_partial < min_partobj)
+			min_partobj = s->objects_partial;
 		if (percentage_partial_slabs < min_ppart)
 			min_ppart = percentage_partial_slabs;
 		if (percentage_partial_objs < min_ppartobj)
@@ -848,8 +841,8 @@ void totals(void)
 			max_objects = s->objects;
 		if (used > max_used)
 			max_used = used;
-		if (objects_in_partial_slabs > max_partobj)
-			max_partobj = objects_in_partial_slabs;
+		if (s->objects_partial > max_partobj)
+			max_partobj = s->objects_partial;
 		if (percentage_partial_slabs > max_ppart)
 			max_ppart = percentage_partial_slabs;
 		if (percentage_partial_objs > max_ppartobj)
@@ -864,7 +857,7 @@ void totals(void)
 
 		total_objects += s->objects;
 		total_used += used;
-		total_partobj += objects_in_partial_slabs;
+		total_partobj += s->objects_partial;
 		total_ppart += percentage_partial_slabs;
 		total_ppartobj += percentage_partial_objs;
 
@@ -1160,6 +1153,8 @@ void read_slab_dir(void)
 			slab->hwcache_align = get_obj("hwcache_align");
 			slab->object_size = get_obj("object_size");
 			slab->objects = get_obj("objects");
+			slab->objects_partial = get_obj("objects_partial");
+			slab->objects_total = get_obj("objects_total");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
 			slab->partial = get_obj("partial");
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index af190ce..e0bd223 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -42,7 +42,10 @@ struct page {
 					 * to show when page is mapped
 					 * & limit reverse map searches.
 					 */
-		unsigned int inuse;	/* SLUB: Nr of objects */
+		struct {		/* SLUB */
+			u16 inuse;
+			u16 objects;
+		};
 	};
 	union {
 	    struct {
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 79d59c9..71e43a1 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -29,6 +29,7 @@ enum stat_item {
 	DEACTIVATE_TO_HEAD,	/* Cpu slab was moved to the head of partials */
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
+	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
@@ -48,11 +49,21 @@ struct kmem_cache_node {
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_t nr_slabs;
+	atomic_long_t total_objects;
 	struct list_head full;
 #endif
 };
 
 /*
+ * Word size structure that can be atomically updated or read and that
+ * contains both the order and the number of objects that a slab of the
+ * given order would contain.
+ */
+struct kmem_cache_order_objects {
+	unsigned long x;
+};
+
+/*
  * Slab cache management.
  */
 struct kmem_cache {
@@ -61,7 +72,7 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
-	int order;		/* Current preferred allocation order */
+	struct kmem_cache_order_objects oo;
 
 	/*
 	 * Avoid an extra cache line for UP, SMP and for the node local to
@@ -70,7 +81,8 @@ struct kmem_cache {
 	struct kmem_cache_node local_node;
 
 	/* Allocation and freeing of slabs */
-	int objects;		/* Number of objects in slab */
+	struct kmem_cache_order_objects max;
+	struct kmem_cache_order_objects min;
 	gfp_t allocflags;	/* gfp flags to use on each alloc */
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(struct kmem_cache *, void *);
diff --git a/mm/slob.c b/mm/slob.c
index e2c3c0e..6038cba 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -533,7 +533,8 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 {
 	struct kmem_cache *c;
 
-	c = slob_alloc(sizeof(struct kmem_cache), flags, 0, -1);
+	c = slob_alloc(sizeof(struct kmem_cache),
+		flags, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
 		c->name = name;
diff --git a/mm/slub.c b/mm/slub.c
index 39592b5..d821ce6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -149,25 +149,6 @@ static inline void ClearSlabDebug(struct page *page)
 /* Enable to test recovery from slab corruption on boot */
 #undef SLUB_RESILIENCY_TEST
 
-#if PAGE_SHIFT <= 12
-
-/*
- * Small page size. Make sure that we do not fragment memory
- */
-#define DEFAULT_MAX_ORDER 1
-#define DEFAULT_MIN_OBJECTS 4
-
-#else
-
-/*
- * Large page machines are customarily able to handle larger
- * page orders.
- */
-#define DEFAULT_MAX_ORDER 2
-#define DEFAULT_MIN_OBJECTS 8
-
-#endif
-
 /*
  * Mininum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
@@ -204,8 +185,6 @@ static inline void ClearSlabDebug(struct page *page)
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
 #define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
-#define __KMALLOC_CACHE		0x20000000 /* objects freed using kfree */
-#define __PAGE_ALLOC_FALLBACK	0x10000000 /* Allow fallback to page alloc */
 
 /* Not all arches define cache_line_size */
 #ifndef cache_line_size
@@ -301,7 +280,7 @@ static inline int check_valid_pointer(struct kmem_cache *s,
 		return 1;
 
 	base = page_address(page);
-	if (object < base || object >= base + s->objects * s->size ||
+	if (object < base || object >= base + page->objects * s->size ||
 		(object - base) % s->size) {
 		return 0;
 	}
@@ -327,8 +306,8 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 }
 
 /* Loop over all objects in a slab */
-#define for_each_object(__p, __s, __addr) \
-	for (__p = (__addr); __p < (__addr) + (__s)->objects * (__s)->size;\
+#define for_each_object(__p, __s, __addr, __objects) \
+	for (__p = (__addr); __p < (__addr) + (__objects) * (__s)->size;\
 			__p += (__s)->size)
 
 /* Scan freelist */
@@ -341,6 +320,26 @@ static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
 	return (p - addr) / s->size;
 }
 
+static inline struct kmem_cache_order_objects oo_make(int order,
+						unsigned long size)
+{
+	struct kmem_cache_order_objects x = {
+		(order << 16) + (PAGE_SIZE << order) / size
+	};
+
+	return x;
+}
+
+static inline int oo_order(struct kmem_cache_order_objects x)
+{
+	return x.x >> 16;
+}
+
+static inline int oo_objects(struct kmem_cache_order_objects x)
+{
+	return x.x & ((1 << 16) - 1);
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 /*
  * Debug settings:
@@ -451,8 +450,8 @@ static void print_tracking(struct kmem_cache *s, void *object)
 
 static void print_page_info(struct page *page)
 {
-	printk(KERN_ERR "INFO: Slab 0x%p used=%u fp=0x%p flags=0x%04lx\n",
-		page, page->inuse, page->freelist, page->flags);
+	printk(KERN_ERR "INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
+		page, page->objects, page->inuse, page->freelist, page->flags);
 
 }
 
@@ -652,6 +651,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct page *page, u8 *p)
 				p + off, POISON_INUSE, s->size - off);
 }
 
+/* Check the pad bytes at the end of a slab page */
 static int slab_pad_check(struct kmem_cache *s, struct page *page)
 {
 	u8 *start;
@@ -664,20 +664,20 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
 		return 1;
 
 	start = page_address(page);
-	end = start + (PAGE_SIZE << s->order);
-	length = s->objects * s->size;
-	remainder = end - (start + length);
+	length = (PAGE_SIZE << compound_order(page));
+	end = start + length;
+	remainder = length % s->size;
 	if (!remainder)
 		return 1;
 
-	fault = check_bytes(start + length, POISON_INUSE, remainder);
+	fault = check_bytes(end - remainder, POISON_INUSE, remainder);
 	if (!fault)
 		return 1;
 	while (end > fault && end[-1] == POISON_INUSE)
 		end--;
 
 	slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
-	print_section("Padding", start, length);
+	print_section("Padding", end - remainder, remainder);
 
 	restore_bytes(s, "slab padding", POISON_INUSE, start, end);
 	return 0;
@@ -739,15 +739,24 @@ static int check_object(struct kmem_cache *s, struct page *page,
 
 static int check_slab(struct kmem_cache *s, struct page *page)
 {
+	int maxobj;
+
 	VM_BUG_ON(!irqs_disabled());
 
 	if (!PageSlab(page)) {
 		slab_err(s, page, "Not a valid slab page");
 		return 0;
 	}
-	if (page->inuse > s->objects) {
+
+	maxobj = (PAGE_SIZE << compound_order(page)) / s->size;
+	if (page->objects > maxobj) {
+		slab_err(s, page, "objects %u > max %u",
+			s->name, page->objects, maxobj);
+		return 0;
+	}
+	if (page->inuse > page->objects) {
 		slab_err(s, page, "inuse %u > max %u",
-			s->name, page->inuse, s->objects);
+			s->name, page->inuse, page->objects);
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
@@ -764,8 +773,9 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 	int nr = 0;
 	void *fp = page->freelist;
 	void *object = NULL;
+	unsigned long max_objects;
 
-	while (fp && nr <= s->objects) {
+	while (fp && nr <= page->objects) {
 		if (fp == search)
 			return 1;
 		if (!check_valid_pointer(s, page, fp)) {
@@ -777,7 +787,7 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 			} else {
 				slab_err(s, page, "Freepointer corrupt");
 				page->freelist = NULL;
-				page->inuse = s->objects;
+				page->inuse = page->objects;
 				slab_fix(s, "Freelist cleared");
 				return 0;
 			}
@@ -788,10 +798,20 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 		nr++;
 	}
 
-	if (page->inuse != s->objects - nr) {
+	max_objects = (PAGE_SIZE << compound_order(page)) / s->size;
+	if (max_objects > 65535)
+		max_objects = 65535;
+
+	if (page->objects != max_objects) {
+		slab_err(s, page, "Wrong number of objects. Found %d but "
+			"should be %d", page->objects, max_objects);
+		page->objects = max_objects;
+		slab_fix(s, "Number of objects adjusted.");
+	}
+	if (page->inuse != page->objects - nr) {
 		slab_err(s, page, "Wrong object count. Counter is %d but "
-			"counted were %d", page->inuse, s->objects - nr);
-		page->inuse = s->objects - nr;
+			"counted were %d", page->inuse, page->objects - nr);
+		page->inuse = page->objects - nr;
 		slab_fix(s, "Object count adjusted.");
 	}
 	return search == NULL;
@@ -845,7 +865,7 @@ static inline unsigned long slabs_node(struct kmem_cache *s, int node)
 	return atomic_long_read(&n->nr_slabs);
 }
 
-static inline void inc_slabs_node(struct kmem_cache *s, int node)
+static inline void inc_slabs_node(struct kmem_cache *s, int node, int objects)
 {
 	struct kmem_cache_node *n = get_node(s, node);
 
@@ -855,14 +875,17 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node)
 	 * dilemma by deferring the increment of the count during
 	 * bootstrap (see early_kmem_cache_node_alloc).
 	 */
-	if (!NUMA_BUILD || n)
+	if (!NUMA_BUILD || n) {
 		atomic_long_inc(&n->nr_slabs);
+		atomic_long_add(objects, &n->total_objects);
+	}
 }
-static inline void dec_slabs_node(struct kmem_cache *s, int node)
+static inline void dec_slabs_node(struct kmem_cache *s, int node, int objects)
 {
 	struct kmem_cache_node *n = get_node(s, node);
 
 	atomic_long_dec(&n->nr_slabs);
+	atomic_long_sub(objects, &n->total_objects);
 }
 
 /* Object debug checks for alloc/free paths */
@@ -910,7 +933,7 @@ bad:
 		 * as used avoids touching the remaining objects.
 		 */
 		slab_fix(s, "Marking all objects used");
-		page->inuse = s->objects;
+		page->inuse = page->objects;
 		page->freelist = NULL;
 	}
 	return 0;
@@ -1060,31 +1083,52 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
 
 static inline unsigned long slabs_node(struct kmem_cache *s, int node)
 							{ return 0; }
-static inline void inc_slabs_node(struct kmem_cache *s, int node) {}
-static inline void dec_slabs_node(struct kmem_cache *s, int node) {}
+static inline void inc_slabs_node(struct kmem_cache *s, int node,
+							int objects) {}
+static inline void dec_slabs_node(struct kmem_cache *s, int node,
+							int objects) {}
 #endif
+
 /*
  * Slab allocation and freeing
  */
+static inline struct page *alloc_slab_page(gfp_t flags, int node,
+					struct kmem_cache_order_objects oo)
+{
+	int order = oo_order(oo);
+
+	if (node == -1)
+		return alloc_pages(flags, order);
+	else
+		return alloc_pages_node(node, flags, order);
+}
+
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page *page;
-	int pages = 1 << s->order;
+	struct kmem_cache_order_objects oo = s->oo;
 
 	flags |= s->allocflags;
 
-	if (node == -1)
-		page = alloc_pages(flags, s->order);
-	else
-		page = alloc_pages_node(node, flags, s->order);
-
-	if (!page)
-		return NULL;
+	page = alloc_slab_page(flags | __GFP_NOWARN | __GFP_NORETRY, node,
+									oo);
+	if (unlikely(!page)) {
+		oo = s->min;
+		/*
+		 * Allocation may have failed due to fragmentation.
+		 * Try a lower order alloc if possible
+		 */
+		page = alloc_slab_page(flags, node, oo);
+		if (!page)
+			return NULL;
 
+		stat(get_cpu_slab(s, raw_smp_processor_id()), ORDER_FALLBACK);
+	}
+	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		pages);
+		1 << oo_order(oo));
 
 	return page;
 }
@@ -1111,7 +1155,7 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (!page)
 		goto out;
 
-	inc_slabs_node(s, page_to_nid(page));
+	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab = s;
 	page->flags |= 1 << PG_slab;
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
@@ -1121,10 +1165,10 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
-		memset(start, POISON_INUSE, PAGE_SIZE << s->order);
+		memset(start, POISON_INUSE, PAGE_SIZE << compound_order(page));
 
 	last = start;
-	for_each_object(p, s, start) {
+	for_each_object(p, s, start, page->objects) {
 		setup_object(s, page, last);
 		set_freepointer(s, last, p);
 		last = p;
@@ -1140,13 +1184,15 @@ out:
 
 static void __free_slab(struct kmem_cache *s, struct page *page)
 {
-	int pages = 1 << s->order;
+	int order = compound_order(page);
+	int pages = 1 << order;
 
 	if (unlikely(SlabDebug(page))) {
 		void *p;
 
 		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page))
+		for_each_object(p, s, page_address(page),
+						page->objects)
 			check_object(s, page, p, 0);
 		ClearSlabDebug(page);
 	}
@@ -1158,7 +1204,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
-	__free_pages(page, s->order);
+	__free_pages(page, order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
@@ -1184,7 +1230,7 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 
 static void discard_slab(struct kmem_cache *s, struct page *page)
 {
-	dec_slabs_node(s, page_to_nid(page));
+	dec_slabs_node(s, page_to_nid(page), page->objects);
 	free_slab(s, page);
 }
 
@@ -1519,7 +1565,7 @@ load_freelist:
 		goto debug;
 
 	c->freelist = object[c->offset];
-	c->page->inuse = s->objects;
+	c->page->inuse = c->page->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
 unlock_out:
@@ -1556,27 +1602,6 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
-
-	/*
-	 * No memory available.
-	 *
-	 * If the slab uses higher order allocs but the object is
-	 * smaller than a page size then we can fallback in emergencies
-	 * to the page allocator via kmalloc_large. The page allocator may
-	 * have failed to obtain a higher order page and we can try to
-	 * allocate a single page if the object fits into a single page.
-	 * That is only possible if certain conditions are met that are being
-	 * checked when a slab is created.
-	 */
-	if (!(gfpflags & __GFP_NORETRY) &&
-				(s->flags & __PAGE_ALLOC_FALLBACK)) {
-		if (gfpflags & __GFP_WAIT)
-			local_irq_enable();
-		object = kmalloc_large(s->objsize, gfpflags);
-		if (gfpflags & __GFP_WAIT)
-			local_irq_disable();
-		return object;
-	}
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -1777,8 +1802,8 @@ static struct page *get_object_page(const void *x)
  * take the list_lock.
  */
 static int slub_min_order;
-static int slub_max_order = DEFAULT_MAX_ORDER;
-static int slub_min_objects = DEFAULT_MIN_OBJECTS;
+static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
+static int slub_min_objects;
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
@@ -1793,7 +1818,7 @@ static int slub_nomerge;
  * system components. Generally order 0 allocations should be preferred since
  * order 0 does not cause fragmentation in the page allocator. Larger objects
  * be problematic to put into order 0 slabs because there may be too much
- * unused space left. We go to a higher order if more than 1/8th of the slab
+ * unused space left. We go to a higher order if more than 1/16th of the slab
  * would be wasted.
  *
  * In order to reach satisfactory performance we must ensure that a minimum
@@ -1818,6 +1843,9 @@ static inline int slab_order(int size, int min_objects,
 	int rem;
 	int min_order = slub_min_order;
 
+	if ((PAGE_SIZE << min_order) / size > 65535)
+		return get_order(size * 65535) - 1;
+
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
 			order <= max_order; order++) {
@@ -1852,8 +1880,10 @@ static inline int calculate_order(int size)
 	 * we reduce the minimum objects required in a slab.
 	 */
 	min_objects = slub_min_objects;
+	if (!min_objects)
+		min_objects = 4 * (fls(nr_cpu_ids) + 1);
 	while (min_objects > 1) {
-		fraction = 8;
+		fraction = 16;
 		while (fraction >= 4) {
 			order = slab_order(size, min_objects,
 						slub_max_order, fraction);
@@ -2095,7 +2125,7 @@ static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 	init_tracking(kmalloc_caches, n);
 #endif
 	init_kmem_cache_node(n);
-	inc_slabs_node(kmalloc_caches, node);
+	inc_slabs_node(kmalloc_caches, node, page->objects);
 
 	/*
 	 * lockdep requires consistent irq usage for each lock
@@ -2171,11 +2201,12 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
  * calculate_sizes() determines the order and the distribution of data within
  * a slab object.
  */
-static int calculate_sizes(struct kmem_cache *s)
+static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	unsigned long flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
+	int order;
 
 	/*
 	 * Round up object size to the next word boundary. We can only
@@ -2259,26 +2290,16 @@ static int calculate_sizes(struct kmem_cache *s)
 	 */
 	size = ALIGN(size, align);
 	s->size = size;
+	if (forced_order >= 0)
+		order = forced_order;
+	else
+		order = calculate_order(size);
 
-	if ((flags & __KMALLOC_CACHE) &&
-			PAGE_SIZE / size < slub_min_objects) {
-		/*
-		 * Kmalloc cache that would not have enough objects in
-		 * an order 0 page. Kmalloc slabs can fallback to
-		 * page allocator order 0 allocs so take a reasonably large
-		 * order that will allows us a good number of objects.
-		 */
-		s->order = max(slub_max_order, PAGE_ALLOC_COSTLY_ORDER);
-		s->flags |= __PAGE_ALLOC_FALLBACK;
-		s->allocflags |= __GFP_NOWARN;
-	} else
-		s->order = calculate_order(size);
-
-	if (s->order < 0)
+	if (order < 0)
 		return 0;
 
 	s->allocflags = 0;
-	if (s->order)
+	if (order)
 		s->allocflags |= __GFP_COMP;
 
 	if (s->flags & SLAB_CACHE_DMA)
@@ -2290,9 +2311,12 @@ static int calculate_sizes(struct kmem_cache *s)
 	/*
 	 * Determine the number of objects per slab
 	 */
-	s->objects = (PAGE_SIZE << s->order) / size;
+	s->oo = oo_make(order, size);
+	s->min = oo_make(get_order(size), size);
+	if (oo_objects(s->oo) > oo_objects(s->max))
+		s->max = s->oo;
 
-	return !!s->objects;
+	return !!oo_objects(s->oo);
 
 }
 
@@ -2308,7 +2332,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	s->align = align;
 	s->flags = kmem_cache_flags(size, flags, name, ctor);
 
-	if (!calculate_sizes(s))
+	if (!calculate_sizes(s, -1))
 		goto error;
 
 	s->refcount = 1;
@@ -2325,7 +2349,7 @@ error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
 			"order=%u offset=%u flags=%lx\n",
-			s->name, (unsigned long)size, s->size, s->order,
+			s->name, (unsigned long)size, s->size, oo_order(s->oo),
 			s->offset, flags);
 	return 0;
 }
@@ -2371,26 +2395,52 @@ const char *kmem_cache_name(struct kmem_cache *s)
 }
 EXPORT_SYMBOL(kmem_cache_name);
 
+static void list_slab_objects(struct kmem_cache *s, struct page *page,
+							const char *text)
+{
+#ifdef CONFIG_SLUB_DEBUG
+	void *addr = page_address(page);
+	void *p;
+	DECLARE_BITMAP(map, page->objects);
+
+	bitmap_zero(map, page->objects);
+	slab_err(s, page, "%s", text);
+	slab_lock(page);
+	for_each_free_object(p, s, page->freelist)
+		set_bit(slab_index(p, s, addr), map);
+
+	for_each_object(p, s, addr, page->objects) {
+
+		if (!test_bit(slab_index(p, s, addr), map)) {
+			printk(KERN_ERR "INFO: Object 0x%p @offset=%tu\n",
+							p, p - addr);
+			print_tracking(s, p);
+		}
+	}
+	slab_unlock(page);
+#endif
+}
+
 /*
- * Attempt to free all slabs on a node. Return the number of slabs we
- * were unable to free.
+ * Attempt to free all partial slabs on a node.
  */
-static int free_list(struct kmem_cache *s, struct kmem_cache_node *n,
-			struct list_head *list)
+static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 {
-	int slabs_inuse = 0;
 	unsigned long flags;
 	struct page *page, *h;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry_safe(page, h, list, lru)
+	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
 			list_del(&page->lru);
 			discard_slab(s, page);
-		} else
-			slabs_inuse++;
+			n->nr_partial--;
+		} else {
+			list_slab_objects(s, page,
+				"Objects remaining on kmem_cache_close()");
+		}
+	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
-	return slabs_inuse;
 }
 
 /*
@@ -2407,8 +2457,8 @@ static inline int kmem_cache_close(struct kmem_cache *s)
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		n->nr_partial -= free_list(s, n, &n->partial);
-		if (slabs_node(s, node))
+		free_partial(s, n);
+		if (n->nr_partial || slabs_node(s, node))
 			return 1;
 	}
 	free_kmem_cache_nodes(s);
@@ -2426,8 +2476,11 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (!s->refcount) {
 		list_del(&s->list);
 		up_write(&slub_lock);
-		if (kmem_cache_close(s))
-			WARN_ON(1);
+		if (kmem_cache_close(s)) {
+			printk(KERN_ERR "SLUB %s: %s called for cache that "
+				"still has objects.\n", s->name, __func__);
+			dump_stack();
+		}
 		sysfs_slab_remove(s);
 	} else
 		up_write(&slub_lock);
@@ -2486,7 +2539,7 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
 
 	down_write(&slub_lock);
 	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
-			flags | __KMALLOC_CACHE, NULL))
+								flags, NULL))
 		goto panic;
 
 	list_add(&s->list, &slab_caches);
@@ -2734,8 +2787,9 @@ int kmem_cache_shrink(struct kmem_cache *s)
 	struct kmem_cache_node *n;
 	struct page *page;
 	struct page *t;
+	int objects = oo_objects(s->max);
 	struct list_head *slabs_by_inuse =
-		kmalloc(sizeof(struct list_head) * s->objects, GFP_KERNEL);
+		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
 	if (!slabs_by_inuse)
@@ -2748,7 +2802,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		if (!n->nr_partial)
 			continue;
 
-		for (i = 0; i < s->objects; i++)
+		for (i = 0; i < objects; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
 
 		spin_lock_irqsave(&n->list_lock, flags);
@@ -2780,7 +2834,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		 * Rebuild the partial list with the slabs filled up most
 		 * first and the least used slabs at the end.
 		 */
-		for (i = s->objects - 1; i >= 0; i--)
+		for (i = objects - 1; i >= 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
@@ -3001,9 +3055,6 @@ static int slab_unmergeable(struct kmem_cache *s)
 	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
 		return 1;
 
-	if ((s->flags & __PAGE_ALLOC_FALLBACK))
-		return 1;
-
 	if (s->ctor)
 		return 1;
 
@@ -3196,7 +3247,8 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 }
 
 #if (defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)) || defined(CONFIG_SLABINFO)
-static unsigned long count_partial(struct kmem_cache_node *n)
+static unsigned long count_partial(struct kmem_cache_node *n,
+					int (*get_count)(struct page *))
 {
 	unsigned long flags;
 	unsigned long x = 0;
@@ -3204,10 +3256,25 @@ static unsigned long count_partial(struct kmem_cache_node *n)
 
 	spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry(page, &n->partial, lru)
-		x += page->inuse;
+		x += get_count(page);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
+
+static int count_inuse(struct page *page)
+{
+	return page->inuse;
+}
+
+static int count_total(struct page *page)
+{
+	return page->objects;
+}
+
+static int count_free(struct page *page)
+{
+	return page->objects - page->inuse;
+}
 #endif
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
@@ -3222,7 +3289,7 @@ static int validate_slab(struct kmem_cache *s, struct page *page,
 		return 0;
 
 	/* Now we know that a valid freelist exists */
-	bitmap_zero(map, s->objects);
+	bitmap_zero(map, page->objects);
 
 	for_each_free_object(p, s, page->freelist) {
 		set_bit(slab_index(p, s, addr), map);
@@ -3230,7 +3297,7 @@ static int validate_slab(struct kmem_cache *s, struct page *page,
 			return 0;
 	}
 
-	for_each_object(p, s, addr)
+	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))
 			if (!check_object(s, page, p, 1))
 				return 0;
@@ -3296,7 +3363,7 @@ static long validate_slab_cache(struct kmem_cache *s)
 {
 	int node;
 	unsigned long count = 0;
-	unsigned long *map = kmalloc(BITS_TO_LONGS(s->objects) *
+	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
 				sizeof(unsigned long), GFP_KERNEL);
 
 	if (!map)
@@ -3499,14 +3566,14 @@ static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc)
 {
 	void *addr = page_address(page);
-	DECLARE_BITMAP(map, s->objects);
+	DECLARE_BITMAP(map, page->objects);
 	void *p;
 
-	bitmap_zero(map, s->objects);
+	bitmap_zero(map, page->objects);
 	for_each_free_object(p, s, page->freelist)
 		set_bit(slab_index(p, s, addr), map);
 
-	for_each_object(p, s, addr)
+	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))
 			add_location(t, s, get_track(s, p, alloc));
 }
@@ -3596,22 +3663,23 @@ static int list_locations(struct kmem_cache *s, char *buf,
 }
 
 enum slab_stat_type {
-	SL_FULL,
-	SL_PARTIAL,
-	SL_CPU,
-	SL_OBJECTS
+	SL_ALL,			/* All slabs */
+	SL_PARTIAL,		/* Only partially allocated slabs */
+	SL_CPU,			/* Only slabs used for cpu caches */
+	SL_OBJECTS,		/* Determine allocated objects not slabs */
+	SL_TOTAL		/* Determine object capacity not slabs */
 };
 
-#define SO_FULL		(1 << SL_FULL)
+#define SO_ALL		(1 << SL_ALL)
 #define SO_PARTIAL	(1 << SL_PARTIAL)
 #define SO_CPU		(1 << SL_CPU)
 #define SO_OBJECTS	(1 << SL_OBJECTS)
+#define SO_TOTAL	(1 << SL_TOTAL)
 
 static ssize_t show_slab_objects(struct kmem_cache *s,
 			    char *buf, unsigned long flags)
 {
 	unsigned long total = 0;
-	int cpu;
 	int node;
 	int x;
 	unsigned long *nodes;
@@ -3622,56 +3690,60 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 		return -ENOMEM;
 	per_cpu = nodes + nr_node_ids;
 
-	for_each_possible_cpu(cpu) {
-		struct page *page;
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+	if (flags & SO_CPU) {
+		int cpu;
 
-		if (!c)
-			continue;
+		for_each_possible_cpu(cpu) {
+			struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
-		page = c->page;
-		node = c->node;
-		if (node < 0)
-			continue;
-		if (page) {
-			if (flags & SO_CPU) {
-				if (flags & SO_OBJECTS)
-					x = page->inuse;
+			if (!c || c->node < 0)
+				continue;
+
+			if (c->page) {
+					if (flags & SO_TOTAL)
+						x = c->page->objects;
+				else if (flags & SO_OBJECTS)
+					x = c->page->inuse;
 				else
 					x = 1;
+
 				total += x;
-				nodes[node] += x;
+				nodes[c->node] += x;
 			}
-			per_cpu[node]++;
+			per_cpu[c->node]++;
 		}
 	}
 
-	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = get_node(s, node);
+	if (flags & SO_ALL) {
+		for_each_node_state(node, N_NORMAL_MEMORY) {
+			struct kmem_cache_node *n = get_node(s, node);
+
+		if (flags & SO_TOTAL)
+			x = atomic_long_read(&n->total_objects);
+		else if (flags & SO_OBJECTS)
+			x = atomic_long_read(&n->total_objects) -
+				count_partial(n, count_free);
 
-		if (flags & SO_PARTIAL) {
-			if (flags & SO_OBJECTS)
-				x = count_partial(n);
 			else
-				x = n->nr_partial;
+				x = atomic_long_read(&n->nr_slabs);
 			total += x;
 			nodes[node] += x;
 		}
 
-		if (flags & SO_FULL) {
-			int full_slabs = atomic_long_read(&n->nr_slabs)
-					- per_cpu[node]
-					- n->nr_partial;
+	} else if (flags & SO_PARTIAL) {
+		for_each_node_state(node, N_NORMAL_MEMORY) {
+			struct kmem_cache_node *n = get_node(s, node);
 
-			if (flags & SO_OBJECTS)
-				x = full_slabs * s->objects;
+			if (flags & SO_TOTAL)
+				x = count_partial(n, count_total);
+			else if (flags & SO_OBJECTS)
+				x = count_partial(n, count_inuse);
 			else
-				x = full_slabs;
+				x = n->nr_partial;
 			total += x;
 			nodes[node] += x;
 		}
 	}
-
 	x = sprintf(buf, "%lu", total);
 #ifdef CONFIG_NUMA
 	for_each_node_state(node, N_NORMAL_MEMORY)
@@ -3686,14 +3758,6 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 static int any_slab_objects(struct kmem_cache *s)
 {
 	int node;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
-
-		if (c && c->page)
-			return 1;
-	}
 
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
@@ -3701,7 +3765,7 @@ static int any_slab_objects(struct kmem_cache *s)
 		if (!n)
 			continue;
 
-		if (n->nr_partial || atomic_long_read(&n->nr_slabs))
+		if (atomic_read(&n->total_objects))
 			return 1;
 	}
 	return 0;
@@ -3743,15 +3807,27 @@ SLAB_ATTR_RO(object_size);
 
 static ssize_t objs_per_slab_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->objects);
+	return sprintf(buf, "%d\n", oo_objects(s->oo));
 }
 SLAB_ATTR_RO(objs_per_slab);
 
+static ssize_t order_store(struct kmem_cache *s,
+				const char *buf, size_t length)
+{
+	int order = simple_strtoul(buf, NULL, 10);
+
+	if (order > slub_max_order || order < slub_min_order)
+		return -EINVAL;
+
+	calculate_sizes(s, order);
+	return length;
+}
+
 static ssize_t order_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->order);
+	return sprintf(buf, "%d\n", oo_order(s->oo));
 }
-SLAB_ATTR_RO(order);
+SLAB_ATTR(order);
 
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
@@ -3772,7 +3848,7 @@ SLAB_ATTR_RO(aliases);
 
 static ssize_t slabs_show(struct kmem_cache *s, char *buf)
 {
-	return show_slab_objects(s, buf, SO_FULL|SO_PARTIAL|SO_CPU);
+	return show_slab_objects(s, buf, SO_ALL);
 }
 SLAB_ATTR_RO(slabs);
 
@@ -3790,10 +3866,22 @@ SLAB_ATTR_RO(cpu_slabs);
 
 static ssize_t objects_show(struct kmem_cache *s, char *buf)
 {
-	return show_slab_objects(s, buf, SO_FULL|SO_PARTIAL|SO_CPU|SO_OBJECTS);
+	return show_slab_objects(s, buf, SO_ALL|SO_OBJECTS);
 }
 SLAB_ATTR_RO(objects);
 
+static ssize_t objects_partial_show(struct kmem_cache *s, char *buf)
+{
+	return show_slab_objects(s, buf, SO_PARTIAL|SO_OBJECTS);
+}
+SLAB_ATTR_RO(objects_partial);
+
+static ssize_t total_objects_show(struct kmem_cache *s, char *buf)
+{
+	return show_slab_objects(s, buf, SO_ALL|SO_TOTAL);
+}
+SLAB_ATTR_RO(total_objects);
+
 static ssize_t sanity_checks_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_DEBUG_FREE));
@@ -3873,7 +3961,7 @@ static ssize_t red_zone_store(struct kmem_cache *s,
 	s->flags &= ~SLAB_RED_ZONE;
 	if (buf[0] == '1')
 		s->flags |= SLAB_RED_ZONE;
-	calculate_sizes(s);
+	calculate_sizes(s, -1);
 	return length;
 }
 SLAB_ATTR(red_zone);
@@ -3892,7 +3980,7 @@ static ssize_t poison_store(struct kmem_cache *s,
 	s->flags &= ~SLAB_POISON;
 	if (buf[0] == '1')
 		s->flags |= SLAB_POISON;
-	calculate_sizes(s);
+	calculate_sizes(s, -1);
 	return length;
 }
 SLAB_ATTR(poison);
@@ -3911,7 +3999,7 @@ static ssize_t store_user_store(struct kmem_cache *s,
 	s->flags &= ~SLAB_STORE_USER;
 	if (buf[0] == '1')
 		s->flags |= SLAB_STORE_USER;
-	calculate_sizes(s);
+	calculate_sizes(s, -1);
 	return length;
 }
 SLAB_ATTR(store_user);
@@ -4042,7 +4130,7 @@ STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
 STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
-
+STAT_ATTR(ORDER_FALLBACK, order_fallback);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4051,6 +4139,8 @@ static struct attribute *slab_attrs[] = {
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
 	&objects_attr.attr,
+	&objects_partial_attr.attr,
+	&total_objects_attr.attr,
 	&slabs_attr.attr,
 	&partial_attr.attr,
 	&cpu_slabs_attr.attr,
@@ -4093,6 +4183,7 @@ static struct attribute *slab_attrs[] = {
 	&deactivate_to_head_attr.attr,
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
+	&order_fallback_attr.attr,
 #endif
 	NULL
 };
@@ -4379,7 +4470,8 @@ static int s_show(struct seq_file *m, void *p)
 	unsigned long nr_partials = 0;
 	unsigned long nr_slabs = 0;
 	unsigned long nr_inuse = 0;
-	unsigned long nr_objs;
+	unsigned long nr_objs = 0;
+	unsigned long nr_free = 0;
 	struct kmem_cache *s;
 	int node;
 
@@ -4393,14 +4485,15 @@ static int s_show(struct seq_file *m, void *p)
 
 		nr_partials += n->nr_partial;
 		nr_slabs += atomic_long_read(&n->nr_slabs);
-		nr_inuse += count_partial(n);
+		nr_objs += atomic_long_read(&n->total_objects);
+		nr_free += count_partial(n, count_free);
 	}
 
-	nr_objs = nr_slabs * s->objects;
-	nr_inuse += (nr_slabs - nr_partials) * s->objects;
+	nr_inuse = nr_objs - nr_free;
 
 	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d", s->name, nr_inuse,
-		   nr_objs, s->size, s->objects, (1 << s->order));
+		   nr_objs, s->size, oo_objects(s->oo),
+		   (1 << oo_order(s->oo)));
 	seq_printf(m, " : tunables %4u %4u %4u", 0, 0, 0);
 	seq_printf(m, " : slabdata %6lu %6lu %6lu", nr_slabs, nr_slabs,
 		   0UL);
