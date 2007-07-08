Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbXGHDvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbXGHDvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbXGHDuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49244 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755638AbXGHDuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:18 -0400
Message-Id: <20070708035016.869389788@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:49:56 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 04/10] SLUB: Move page->offset to kmem_cache_cpu->offset
Content-Disposition: inline; filename=slub_move_offset_to_cpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need the offset during slab_alloc and slab_free. In both cases we also
reference the cacheline of the kmem_cache_cpu structure. We can therefore
move the offset field into the kmem_cache_cpu structure freeing up 16 bits
in the page flags.

Moving the offset allows an allocation from slab_alloc() without
touching the page struct in the hot path.

The only thing left in slab_free() that touches the page struct cacheline for
per cpu freeing is the checking of SlabDebug(page). The next patch deals with
that.

Use the available 16 bits to broaden page->inuse. That way we can have more
than 64k objects per slab and can get rid of the checks for that limitation.

No need anymore to shrink the order of slabs if we boot with 2M sized slabs
(slub_min_order=9).

No need anymore to switch off the offset calculation for very large slabs
since the field in the kmem_cache_cpu structure is 32 bits and so the offset
field can now handle slab sizes of up to 8GB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm_types.h |    5 ---
 include/linux/slub_def.h |    1 
 mm/slub.c                |   75 ++++++++++-------------------------------------
 3 files changed, 19 insertions(+), 62 deletions(-)

Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-06 23:35:49.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-07 12:02:41.000000000 -0700
@@ -207,11 +207,6 @@ static inline void ClearSlabDebug(struct
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
-/*
- * The page->inuse field is 16 bit thus we have this limitation
- */
-#define MAX_OBJECTS_PER_SLAB 65535
-
 /* Internal SLUB flags */
 #define __OBJECT_POISON 0x80000000	/* Poison object */
 
@@ -741,11 +736,6 @@ static int check_slab(struct kmem_cache 
 		slab_err(s, page, "Not a valid slab page");
 		return 0;
 	}
-	if (page->offset * sizeof(void *) != s->offset) {
-		slab_err(s, page, "Corrupted offset %lu",
-			(unsigned long)(page->offset * sizeof(void *)));
-		return 0;
-	}
 	if (page->inuse > s->objects) {
 		slab_err(s, page, "inuse %u > max %u",
 			s->name, page->inuse, s->objects);
@@ -884,8 +874,6 @@ bad:
 		slab_fix(s, "Marking all objects used");
 		page->inuse = s->objects;
 		page->freelist = NULL;
-		/* Fix up fields that may be corrupted */
-		page->offset = s->offset / sizeof(void *);
 	}
 	return 0;
 }
@@ -1001,30 +989,12 @@ __setup("slub_debug", setup_slub_debug);
 static void kmem_cache_open_debug_check(struct kmem_cache *s)
 {
 	/*
-	 * The page->offset field is only 16 bit wide. This is an offset
-	 * in units of words from the beginning of an object. If the slab
-	 * size is bigger then we cannot move the free pointer behind the
-	 * object anymore.
-	 *
-	 * On 32 bit platforms the limit is 256k. On 64bit platforms
-	 * the limit is 512k.
-	 *
-	 * Debugging or ctor may create a need to move the free
-	 * pointer. Fail if this happens.
+	 * Enable debugging if selected on the kernel commandline.
 	 */
-	if (s->objsize >= 65535 * sizeof(void *)) {
-		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
-				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
-		BUG_ON(s->ctor);
-	}
-	else
-		/*
-		 * Enable debugging if selected on the kernel commandline.
-		 */
-		if (slub_debug && (!slub_debug_slabs ||
-		    strncmp(slub_debug_slabs, s->name,
-		    	strlen(slub_debug_slabs)) == 0))
-				s->flags |= slub_debug;
+	if (slub_debug && (!slub_debug_slabs ||
+	    strncmp(slub_debug_slabs, s->name,
+	    	strlen(slub_debug_slabs)) == 0))
+			s->flags |= slub_debug;
 }
 #else
 static inline void setup_object_debug(struct kmem_cache *s,
@@ -1109,7 +1079,6 @@ static struct page *new_slab(struct kmem
 		atomic_long_inc(&n->nr_slabs);
 
 	page->inuse = 0;
-	page->offset = s->offset / sizeof(void *);
 	page->slab = s;
 
 	start = page_address(page);
@@ -1410,10 +1379,10 @@ static void deactivate_slab(struct kmem_
 
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
-		c->freelist = c->freelist[page->offset];
+		c->freelist = c->freelist[c->offset];
 
 		/* And put onto the regular freelist */
-		object[page->offset] = page->freelist;
+		object[c->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
@@ -1509,7 +1478,7 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->page->offset];
+	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
@@ -1561,7 +1530,7 @@ debug:
 		goto another_slab;
 
 	c->page->inuse++;
-	c->page->freelist = object[c->page->offset];
+	c->page->freelist = object[c->offset];
 	slab_unlock(c->page);
 	return object;
 }
@@ -1592,7 +1561,7 @@ static void __always_inline *slab_alloc(
 
 	else {
 		object = c->freelist;
-		c->freelist = object[c->page->offset];
+		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
 
@@ -1625,7 +1594,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-					void *x, void *addr)
+				void *x, void *addr, unsigned int offset)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1635,7 +1604,7 @@ static void __slab_free(struct kmem_cach
 	if (unlikely(SlabDebug(page)))
 		goto debug;
 checks_ok:
-	prior = object[page->offset] = page->freelist;
+	prior = object[offset] = page->freelist;
 	page->freelist = object;
 	page->inuse--;
 
@@ -1695,10 +1664,10 @@ static void __always_inline slab_free(st
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	if (likely(page == c->page && !SlabDebug(page))) {
-		object[page->offset] = c->freelist;
+		object[c->offset] = c->freelist;
 		c->freelist = object;
 	} else
-		__slab_free(s, page, x, addr);
+		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
 }
@@ -1794,8 +1763,7 @@ static inline int slab_order(int size, i
 	 * If we would create too many object per slab then reduce
 	 * the slab order even if it goes below slub_min_order.
 	 */
-	while (min_order > 0 &&
-		(PAGE_SIZE << min_order) >= MAX_OBJECTS_PER_SLAB * size)
+	while (min_order > 0 && PAGE_SIZE << min_order)
 			min_order--;
 
 	for (order = max(min_order,
@@ -1812,9 +1780,6 @@ static inline int slab_order(int size, i
 		if (rem <= slab_size / fract_leftover)
 			break;
 
-		/* If the next size is too high then exit now */
-		if (slab_size * 2 >= MAX_OBJECTS_PER_SLAB * size)
-			break;
 	}
 
 	return order;
@@ -1894,6 +1859,7 @@ static void init_kmem_cache_cpu(struct k
 {
 	c->page = NULL;
 	c->freelist = NULL;
+	c->offset = s->offset / sizeof(void *);
 	c->node = 0;
 }
 
@@ -2115,14 +2081,7 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->objects = (PAGE_SIZE << s->order) / size;
 
-	/*
-	 * Verify that the number of objects is within permitted limits.
-	 * The page->inuse field is only 16 bit wide! So we cannot have
-	 * more than 64k objects per slab.
-	 */
-	if (!s->objects || s->objects > MAX_OBJECTS_PER_SLAB)
-		return 0;
-	return 1;
+	return !!s->objects;
 
 }
 
Index: linux-2.6.22-rc6-mm1/include/linux/mm_types.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/mm_types.h	2007-07-06 23:35:49.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/mm_types.h	2007-07-06 23:35:50.000000000 -0700
@@ -24,10 +24,7 @@ struct page {
 					 * to show when page is mapped
 					 * & limit reverse map searches.
 					 */
-		struct {	/* SLUB uses */
-			short unsigned int inuse;
-			short unsigned int offset;
-		};
+		unsigned int inuse;	/* SLUB: Nr of objects */
 	};
 	union {
 	    struct {
Index: linux-2.6.22-rc6-mm1/include/linux/slub_def.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/slub_def.h	2007-07-06 23:35:49.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/slub_def.h	2007-07-07 12:01:39.000000000 -0700
@@ -15,6 +15,7 @@ struct kmem_cache_cpu {
 	void **freelist;
 	struct page *page;
 	int node;
+	unsigned int offset;
 	/* Lots of wasted space */
 } ____cacheline_aligned_in_smp;
 

-- 
