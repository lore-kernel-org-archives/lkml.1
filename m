Return-Path: <linux-kernel-owner+w=401wt.eu-S1763807AbXJETdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763807AbXJETdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760892AbXJETc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:32:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55612 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759272AbXJETc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:32:58 -0400
Date: Fri, 5 Oct 2007 12:32:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       David Chinner <dgc@sgi.com>, David Miller <davem@davemloft.net>,
       cebbert@redhat.com, willy@linux.intel.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <Pine.LNX.4.64.0710051229570.17562@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0710051231280.17562@schroedinger.engr.sgi.com>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net>
 <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net>
 <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk>
 <84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com>
 <20071005092822.GL5711@kernel.dk> <p73bqbd6cip.fsf@bingen.suse.de>
 <20071005123953.GS5711@kernel.dk> <Pine.LNX.4.64.0710051229570.17562@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2/2


SLUB: Allow foreign objects on the per cpu object lists.

In order to free objects we need to touch the page struct of the page that the
object belongs to. If this occurs too frequently then we could generate a bouncing
cacheline.

We do not want that to occur too frequently. We can avoid the page struct touching
for per cpu objects. Now we extend that to allow a limited number of objects that are
not part of the cpu slab. Allow up to 4 times the objects that fit into a page
in the per cpu list.

If the objects are allocated before we need to free them then we have saved touching
a page struct twice. The objects are presumably cache hot, so it is performance wise
good to recycle these locally.

Foreign objects are drained before deactivating cpu slabs and if too many objects
accumulate.

For kmem_cache_free() this also has the beneficial effect of getting virt_to_page()
operations eliminated or grouped together which may help reduce the cache footprint
and increase the speed of virt_to_page() lookups (they hopefully all come from the
same pages).

For kfree() we may have to do virt_to_page() in the worst case twice. Once grouped
together.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    1 
 mm/slub.c                |   82 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 68 insertions(+), 15 deletions(-)

Index: linux-2.6.23-rc8-mm2/include/linux/slub_def.h
===================================================================
--- linux-2.6.23-rc8-mm2.orig/include/linux/slub_def.h	2007-10-04 22:42:08.000000000 -0700
+++ linux-2.6.23-rc8-mm2/include/linux/slub_def.h	2007-10-04 22:43:19.000000000 -0700
@@ -16,6 +16,7 @@ struct kmem_cache_cpu {
 	struct page *page;
 	int node;
 	int remaining;
+	int drain_limit;
 	unsigned int offset;
 	unsigned int objsize;
 };
Index: linux-2.6.23-rc8-mm2/mm/slub.c
===================================================================
--- linux-2.6.23-rc8-mm2.orig/mm/slub.c	2007-10-04 22:42:08.000000000 -0700
+++ linux-2.6.23-rc8-mm2/mm/slub.c	2007-10-04 22:56:49.000000000 -0700
@@ -187,6 +187,12 @@ static inline void ClearSlabDebug(struct
  */
 #define MAX_PARTIAL 10
 
+/*
+ * How many times the number of objects per slab can accumulate on the
+ * per cpu objects list before we drain it.
+ */
+#define DRAIN_FACTOR 4
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 
@@ -1375,6 +1381,54 @@ static void unfreeze_slab(struct kmem_ca
 	}
 }
 
+static void __slab_free(struct kmem_cache *s, struct page *page,
+				void *x, void *addr, unsigned int offset);
+
+/*
+ * Drain freelist of objects foreign to the slab. Interrupts must be off.
+ *
+ * This is called
+ *
+ * 1. Before taking the slub lock when a cpu slab is to be deactivated.
+ *    Deactivation can only deal with native objects on the freelist.
+ *
+ * 2. If the number of objects in the per cpu structures grows beyond
+ *    3 times the objects that fit in a slab. In that case we need to throw
+ *    some objects away. Stripping the foreign objects does the job and
+ *    localizes any new the allocations.
+ */
+static void drain_foreign(struct kmem_cache *s, struct kmem_cache_cpu *c, void *addr)
+{
+	void **freelist = c->freelist;
+
+	if (unlikely(c->node < 0)) {
+		/* Slow path user */
+		__slab_free(s, virt_to_head_page(freelist), freelist, addr, c->offset);
+		freelist = NULL;
+		c->remaining--;
+	}
+
+	if (!freelist)
+		return;
+
+	c->freelist = NULL;
+	c->remaining = 0;
+
+	while (freelist) {
+		void **object = freelist;
+		struct page *page = virt_to_head_page(freelist);
+
+		freelist = freelist[c->offset];
+		if (page == c->page) {
+			/* Local object. Keep for future allocations */
+			object[c->offset] = c->freelist;
+			c->freelist = object;
+			c->remaining++;
+		} else
+			__slab_free(s, page, object, NULL, c->offset);
+	}
+}
+
 /*
  * Remove the cpu slab
  */
@@ -1405,6 +1459,7 @@ static void deactivate_slab(struct kmem_
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
+	drain_foreign(s, c, NULL);
 	slab_lock(c->page);
 	deactivate_slab(s, c);
 }
@@ -1480,6 +1535,7 @@ static void *__slab_alloc(struct kmem_ca
 	if (!c->page)
 		goto new_slab;
 
+	drain_foreign(s, c, NULL);
 	slab_lock(c->page);
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
@@ -1553,6 +1609,7 @@ debug:
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
 	c->node = -1;
+	c->remaining = s->objects * 64;
 	slab_unlock(c->page);
 	return object;
 }
@@ -1676,8 +1733,8 @@ debug:
  * If fastpath is not possible then fall back to __slab_free where we deal
  * with all sorts of special processing.
  */
-static void __always_inline slab_free(struct kmem_cache *s,
-			struct page *page, void *x, void *addr)
+static void __always_inline slab_free(struct kmem_cache *s, void *x,
+								void *addr)
 {
 	void **object = (void *)x;
 	unsigned long flags;
@@ -1686,23 +1743,17 @@ static void __always_inline slab_free(st
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && c->node >= 0)) {
-		object[c->offset] = c->freelist;
-		c->freelist = object;
-		c->remaining++;
-	} else
-		__slab_free(s, page, x, addr, c->offset);
-
+	object[c->offset] = c->freelist;
+	c->freelist = object;
+	c->remaining++;
+	if (unlikely(c->remaining >= c->drain_limit))
+		drain_foreign(s, c, addr);
 	local_irq_restore(flags);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
-	struct page *page;
-
-	page = virt_to_head_page(x);
-
-	slab_free(s, page, x, __builtin_return_address(0));
+	slab_free(s, x, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -1879,6 +1930,7 @@ static void init_kmem_cache_cpu(struct k
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
+	c->drain_limit = DRAIN_FACTOR * s->objects;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
@@ -2626,7 +2678,7 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, (void *)x, __builtin_return_address(0));
+	slab_free(page->slab, (void *)x, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kfree);
 

