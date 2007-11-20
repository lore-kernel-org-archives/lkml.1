Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXKTBPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXKTBPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXKTBNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36852 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753117AbXKTBNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:33 -0500
Message-Id: <20071120011332.895723821@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:37 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 05/45] cpu alloc: Remove SLUB fields
Content-Disposition: inline; filename=cpu_alloc_remove_slub_fields
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the fields in kmem_cache_cpu that were used to cache data from
kmem_cache when they were in different cachelines. The cacheline that holds
the per cpu array pointer now also holds these values. We can cut down the
kmem_cache_cpu size to almost half.

The get_freepointer() and set_freepointer() functions that used to be only
intended for the slow path now are also useful for the hot path since access
to the field does not require an additional cacheline anymore. This results
in consistent use of setting the freepointer for objects throughout SLUB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/slub_def.h |    3 --
 mm/slub.c                |   48 +++++++++++++++--------------------------------
 2 files changed, 16 insertions(+), 35 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-11-19 15:53:25.869890760 -0800
+++ linux-2.6/include/linux/slub_def.h	2007-11-19 15:55:42.125640354 -0800
@@ -15,9 +15,6 @@ struct kmem_cache_cpu {
 	void **freelist;
 	struct page *page;
 	int node;
-	unsigned int offset;
-	unsigned int objsize;
-	unsigned int objects;
 };
 
 struct kmem_cache_node {
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-19 15:54:10.513640214 -0800
+++ linux-2.6/mm/slub.c	2007-11-19 15:55:42.125640354 -0800
@@ -273,13 +273,6 @@ static inline int check_valid_pointer(st
 	return 1;
 }
 
-/*
- * Slow version of get and set free pointer.
- *
- * This version requires touching the cache lines of kmem_cache which
- * we avoid to do in the fast alloc free paths. There we obtain the offset
- * from the page struct.
- */
 static inline void *get_freepointer(struct kmem_cache *s, void *object)
 {
 	return *(void **)(object + s->offset);
@@ -1438,10 +1431,10 @@ static void deactivate_slab(struct kmem_
 
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
-		c->freelist = c->freelist[c->offset];
+		c->freelist = get_freepointer(s, c->freelist);
 
 		/* And put onto the regular freelist */
-		object[c->offset] = page->freelist;
+		set_freepointer(s, object, page->freelist);
 		page->freelist = object;
 		page->inuse--;
 	}
@@ -1584,8 +1577,8 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->offset];
-	c->page->inuse = c->objects;
+	c->freelist = get_freepointer(s, object);
+	c->page->inuse = s->objects;
 	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
 unlock_out:
@@ -1613,7 +1606,7 @@ debug:
 		goto another_slab;
 
 	c->page->inuse++;
-	c->page->freelist = object[c->offset];
+	c->page->freelist = get_freepointer(s, object);
 	c->node = -1;
 	goto unlock_out;
 }
@@ -1646,7 +1639,7 @@ static void __always_inline *slab_alloc(
 			break;
 		}
 	} while (CPU_CMPXCHG(c->freelist, object,
-			object[__CPU_READ(c->offset)]) != object);
+			get_freepointer(s, object)) != object);
 #else
 	unsigned long flags;
 
@@ -1661,13 +1654,13 @@ static void __always_inline *slab_alloc(
 		}
 	} else {
 		object = c->freelist;
-		c->freelist = object[c->offset];
+		c->freelist = get_freepointer(s, object);
 	}
 	local_irq_restore(flags);
 #endif
 
 	if (unlikely((gfpflags & __GFP_ZERO)))
-		memset(object, 0, c->objsize);
+		memset(object, 0, s->objsize);
 out:
 	return object;
 }
@@ -1695,7 +1688,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-				void *x, void *addr, unsigned int offset)
+				void *x, void *addr)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1711,7 +1704,8 @@ static void __slab_free(struct kmem_cach
 	if (unlikely(state & SLABDEBUG))
 		goto debug;
 checks_ok:
-	prior = object[offset] = page->freelist;
+	prior = page->freelist;
+	set_freepointer(s, object, prior);
 	page->freelist = object;
 	page->inuse--;
 
@@ -1794,10 +1788,10 @@ static void __always_inline slab_free(st
 		 */
 		if (unlikely(page != __CPU_READ(c->page) ||
 					__CPU_READ(c->node) < 0)) {
-			__slab_free(s, page, x, addr, __CPU_READ(c->offset));
+			__slab_free(s, page, x, addr);
 			break;
 		}
-		object[__CPU_READ(c->offset)] = freelist;
+		set_freepointer(s, object, freelist);
 	} while (CPU_CMPXCHG(c->freelist, freelist, object) != freelist);
 #else
 	unsigned long flags;
@@ -1806,10 +1800,10 @@ static void __always_inline slab_free(st
 	debug_check_no_locks_freed(object, s->objsize);
 	c = THIS_CPU(s->cpu_slab);
 	if (likely(page == c->page && c->node >= 0)) {
-		object[c->offset] = c->freelist;
+		set_freepointer(s, object, c->freelist);
 		c->freelist = object;
 	} else
-		__slab_free(s, page, x, addr, c->offset);
+		__slab_free(s, page, x, addr);
 
 	local_irq_restore(flags);
 #endif
@@ -1991,9 +1985,6 @@ static void init_kmem_cache_cpu(struct k
 	c->page = NULL;
 	c->freelist = (void *)PAGE_MAPPING_ANON;
 	c->node = 0;
-	c->offset = s->offset / sizeof(void *);
-	c->objsize = s->objsize;
-	c->objects = s->objects;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
@@ -2985,21 +2976,14 @@ struct kmem_cache *kmem_cache_create(con
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
-		int cpu;
-
 		s->refcount++;
+
 		/*
 		 * Adjust the object sizes so that we clear
 		 * the complete object on kzalloc.
 		 */
 		s->objsize = max(s->objsize, (int)size);
 
-		/*
-		 * And then we need to update the object size in the
-		 * per cpu structures
-		 */
-		for_each_online_cpu(cpu)
-			CPU_PTR(s->cpu_slab, cpu)->objsize = s->objsize;
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 		if (sysfs_slab_alias(s, name))

-- 
