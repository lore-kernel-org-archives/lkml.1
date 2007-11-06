Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbXKFTwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbXKFTwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbXKFTwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:06 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52114 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755448AbXKFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:00 -0500
Message-Id: <20071106195159.020324807@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:50 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 06/28] cpu alloc: Remove SLUB fields
Content-Disposition: inline; filename=cpu_alloc_slub_remove_cpu_parameter
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
 mm/slub.c                |   50 +++++++++++++++--------------------------------
 2 files changed, 17 insertions(+), 36 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-11-05 22:41:15.000000000 -0800
+++ linux-2.6/include/linux/slub_def.h	2007-11-05 22:41:24.000000000 -0800
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
--- linux-2.6.orig/mm/slub.c	2007-11-05 22:41:15.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-11-05 22:42:28.000000000 -0800
@@ -274,13 +274,6 @@ static inline int check_valid_pointer(st
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
@@ -1573,8 +1566,8 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->offset];
-	c->page->inuse = c->objects;
+	c->freelist = get_freepointer(s, object);
+	c->page->inuse = s->objects;
 	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
 unlock_out:
@@ -1602,7 +1595,7 @@ debug:
 		goto another_slab;
 
 	c->page->inuse++;
-	c->page->freelist = object[c->offset];
+	c->page->freelist = get_freepointer(s, object);
 	c->node = -1;
 	goto unlock_out;
 }
@@ -1636,8 +1629,8 @@ static void __always_inline *slab_alloc(
 			}
 			break;
 		}
-	} while (cmpxchg_local(&c->freelist, object, object[c->offset])
-								!= object);
+	} while (cmpxchg_local(&c->freelist, object,
+			get_freepointer(s, object)) != object);
 	preempt_enable();
 #else
 	unsigned long flags;
@@ -1653,13 +1646,13 @@ static void __always_inline *slab_alloc(
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
@@ -1687,7 +1680,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node);
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct page *page,
-				void *x, void *addr, unsigned int offset)
+				void *x, void *addr)
 {
 	void *prior;
 	void **object = (void *)x;
@@ -1703,7 +1696,8 @@ static void __slab_free(struct kmem_cach
 	if (unlikely(state & SLABDEBUG))
 		goto debug;
 checks_ok:
-	prior = object[offset] = page->freelist;
+	prior = page->freelist;
+	set_freepointer(s, object, prior);
 	page->freelist = object;
 	page->inuse--;
 
@@ -1786,10 +1780,10 @@ static void __always_inline slab_free(st
 		 * since the freelist pointers are unique per slab.
 		 */
 		if (unlikely(page != c->page || c->node < 0)) {
-			__slab_free(s, page, x, addr, c->offset);
+			__slab_free(s, page, x, addr);
 			break;
 		}
-		object[c->offset] = freelist;
+		set_freepointer(s, object, freelist);
 	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
 	preempt_enable();
 #else
@@ -1799,10 +1793,10 @@ static void __always_inline slab_free(st
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
@@ -1984,9 +1978,6 @@ static void init_kmem_cache_cpu(struct k
 	c->page = NULL;
 	c->freelist = (void *)PAGE_MAPPING_ANON;
 	c->node = 0;
-	c->offset = s->offset / sizeof(void *);
-	c->objsize = s->objsize;
-	c->objects = s->objects;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
@@ -2978,21 +2969,14 @@ struct kmem_cache *kmem_cache_create(con
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
