Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbXIYXrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbXIYXrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXIYXnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942AbXIYXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:53 -0400
Message-Id: <20070925234252.667509837@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:19 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Content-Disposition: inline; filename=vcompound_slub_support
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLAB_VFALLBACK can be specified for selected slab caches. If fallback is
available then the conservative settings for higher order allocations are
overridden. We then request an order that can accomodate at mininum
100 objects. The size of an individual slab allocation is allowed to reach
up to 256k (order 6 on i386, order 4 on IA64).

Implementing fallback requires special handling of virtual mappings in
the free path. However, the impact is minimal since we already check the
address if its NULL or ZERO_SIZE_PTR. No additional cachelines are
touched if we do not fall back. However, if we need to handle a virtual
compound page then walk the kernel page table in the free paths to
determine the page struct.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slab.h     |    1 
 include/linux/slub_def.h |    1 
 mm/slub.c                |   52 +++++++++++++++++++++++++++--------------------
 3 files changed, 32 insertions(+), 22 deletions(-)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2007-09-24 20:34:14.000000000 -0700
+++ linux-2.6/include/linux/slab.h	2007-09-24 20:35:09.000000000 -0700
@@ -19,6 +19,7 @@
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
  */
 #define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
+#define SLAB_VFALLBACK		0x00000200UL	/* May fall back to vmalloc */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-09-24 20:34:14.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-09-24 20:35:09.000000000 -0700
@@ -285,7 +285,7 @@ static inline int check_valid_pointer(st
 	if (!object)
 		return 1;
 
-	base = page_address(page);
+	base = page_to_addr(page);
 	if (object < base || object >= base + s->objects * s->size ||
 		(object - base) % s->size) {
 		return 0;
@@ -470,7 +470,7 @@ static void slab_fix(struct kmem_cache *
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
-	u8 *addr = page_address(page);
+	u8 *addr = page_to_addr(page);
 
 	print_tracking(s, p);
 
@@ -648,7 +648,7 @@ static int slab_pad_check(struct kmem_ca
 	if (!(s->flags & SLAB_POISON))
 		return 1;
 
-	start = page_address(page);
+	start = page_to_addr(page);
 	end = start + (PAGE_SIZE << s->order);
 	length = s->objects * s->size;
 	remainder = end - (start + length);
@@ -1049,11 +1049,7 @@ static struct page *allocate_slab(struct
 	struct page * page;
 	int pages = 1 << s->order;
 
-	if (s->order)
-		flags |= __GFP_COMP;
-
-	if (s->flags & SLAB_CACHE_DMA)
-		flags |= SLUB_DMA;
+	flags |= s->gfpflags;
 
 	if (node == -1)
 		page = alloc_pages(flags, s->order);
@@ -1107,7 +1103,7 @@ static struct page *new_slab(struct kmem
 			SLAB_STORE_USER | SLAB_TRACE))
 		SetSlabDebug(page);
 
-	start = page_address(page);
+	start = page_to_addr(page);
 	end = start + s->objects * s->size;
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1139,7 +1135,7 @@ static void __free_slab(struct kmem_cach
 		void *p;
 
 		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page))
+		for_each_object(p, s, page_to_addr(page))
 			check_object(s, page, p, 0);
 		ClearSlabDebug(page);
 	}
@@ -1789,10 +1785,9 @@ static inline int slab_order(int size, i
 	return order;
 }
 
-static inline int calculate_order(int size)
+static inline int calculate_order(int size, int min_objects, int max_order)
 {
 	int order;
-	int min_objects;
 	int fraction;
 
 	/*
@@ -1803,13 +1798,12 @@ static inline int calculate_order(int si
 	 * First we reduce the acceptable waste in a slab. Then
 	 * we reduce the minimum objects required in a slab.
 	 */
-	min_objects = slub_min_objects;
 	while (min_objects > 1) {
 		fraction = 8;
 		while (fraction >= 4) {
 			order = slab_order(size, min_objects,
-						slub_max_order, fraction);
-			if (order <= slub_max_order)
+						max_order, fraction);
+			if (order <= max_order)
 				return order;
 			fraction /= 2;
 		}
@@ -1820,8 +1814,8 @@ static inline int calculate_order(int si
 	 * We were unable to place multiple objects in a slab. Now
 	 * lets see if we can place a single object there.
 	 */
-	order = slab_order(size, 1, slub_max_order, 1);
-	if (order <= slub_max_order)
+	order = slab_order(size, 1, max_order, 1);
+	if (order <= max_order)
 		return order;
 
 	/*
@@ -2068,10 +2062,24 @@ static int calculate_sizes(struct kmem_c
 	size = ALIGN(size, align);
 	s->size = size;
 
-	s->order = calculate_order(size);
+	if (s->flags & SLAB_VFALLBACK)
+		s->order = calculate_order(size, 100, 18 - PAGE_SHIFT);
+	else
+		s->order = calculate_order(size, slub_min_objects,
+							slub_max_order);
+
 	if (s->order < 0)
 		return 0;
 
+	if (s->order)
+		s->gfpflags |= __GFP_COMP;
+
+	if (s->flags & SLAB_VFALLBACK)
+		s->gfpflags |= __GFP_VFALLBACK;
+
+	if (s->flags & SLAB_CACHE_DMA)
+		s->flags |= SLUB_DMA;
+
 	/*
 	 * Determine the number of objects per slab
 	 */
@@ -2814,7 +2822,7 @@ static int validate_slab(struct kmem_cac
 						unsigned long *map)
 {
 	void *p;
-	void *addr = page_address(page);
+	void *addr = page_to_addr(page);
 
 	if (!check_slab(s, page) ||
 			!on_freelist(s, page, NULL))
@@ -3056,7 +3064,7 @@ static int add_location(struct loc_track
 
 				cpu_set(track->cpu, l->cpus);
 			}
-			node_set(page_to_nid(virt_to_page(track)), l->nodes);
+			node_set(page_to_nid(addr_to_page(track)), l->nodes);
 			return 1;
 		}
 
@@ -3087,14 +3095,14 @@ static int add_location(struct loc_track
 	cpus_clear(l->cpus);
 	cpu_set(track->cpu, l->cpus);
 	nodes_clear(l->nodes);
-	node_set(page_to_nid(virt_to_page(track)), l->nodes);
+	node_set(page_to_nid(addr_to_page(track)), l->nodes);
 	return 1;
 }
 
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc)
 {
-	void *addr = page_address(page);
+	void *addr = page_to_addr(page);
 	DECLARE_BITMAP(map, s->objects);
 	void *p;
 
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-09-24 20:34:14.000000000 -0700
+++ linux-2.6/include/linux/slub_def.h	2007-09-24 20:35:09.000000000 -0700
@@ -31,6 +31,7 @@ struct kmem_cache {
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
 	int order;
+	int gfpflags;		/* Allocation flags */
 
 	/*
 	 * Avoid an extra cache line for UP, SMP and for the node local to

-- 
