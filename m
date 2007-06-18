Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbXFRKGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbXFRKGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761451AbXFRJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47917 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760175AbXFRJ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:19 -0400
Message-Id: <20070618095919.344572612@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:59:03 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 25/26] SLUB: Add an object counter to the kmem_cache_cpu structure
Content-Disposition: inline; filename=slub_performance_cpuslab_counter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kmem_cache_cpu structure is now 2 1/2 words. Allocation sizes are rounded
to word boundaries so we can place an additional integer in the
kmem_cache_structure without increasing its size.

The counter is useful to keep track of the numbers of objects left in the
lockless per cpu list. If we have this number then the merging of the
per cpu objects back into the slab (when a slab is deactivated) can be very fast
since we have no need anymore to count the objects.

Pros:
	- The benefit is that requests to rapidly changing node numbers
	  from a single processor are improved on NUMA.
	  Switching from a slab on one node to another becomes faster
	  since the back spilling of objects is simplified.

Cons:
	- Additional need to increase and decrease a counter in slab_alloc
	  and slab_free. But the counter is in a cacheline already written to
	  so its cheap to do.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    1 
 mm/slub.c                |   48 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 11 deletions(-)

Index: linux-2.6.22-rc4-mm2/include/linux/slub_def.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/slub_def.h	2007-06-17 23:51:36.000000000 -0700
+++ linux-2.6.22-rc4-mm2/include/linux/slub_def.h	2007-06-18 00:45:54.000000000 -0700
@@ -14,6 +14,7 @@
 struct kmem_cache_cpu {
 	void **lockless_freelist;
 	struct page *page;
+	int objects;	/* Saved page->inuse */
 	int node;
 	/* Lots of wasted space */
 } ____cacheline_aligned_in_smp;
Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-18 00:40:04.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-18 00:45:54.000000000 -0700
@@ -1398,23 +1398,47 @@ static void unfreeze_slab(struct kmem_ca
 static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	struct page *page = c->page;
+
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(c->lockless_freelist)) {
-		void **object;
+	if (unlikely(c->lockless_freelist)) {
 
-		/* Retrieve object from cpu_freelist */
-		object = c->lockless_freelist;
-		c->lockless_freelist = c->lockless_freelist[page->offset];
+		/*
+		 * Special case in which no remote frees have occurred.
+		 * Then we can simply have the lockless_freelist become
+		 * the page->freelist and put the counter back.
+		 */
+		if (!page->freelist) {
+			page->freelist = c->lockless_freelist;
+			page->inuse = c->objects;
+			c->lockless_freelist = NULL;
+		} else {
 
-		/* And put onto the regular freelist */
-		object[page->offset] = page->freelist;
-		page->freelist = object;
-		page->inuse--;
+			/*
+			 * Objects both on page freelist and cpu freelist.
+			 * We need to merge both lists. By doing that
+			 * we reverse the object order in the slab.
+			 * Sigh. But we rarely get here.
+			 */
+			while (c->lockless_freelist) {
+				void **object;
+
+				/* Retrieve object from lockless freelist */
+				object = c->lockless_freelist;
+				c->lockless_freelist =
+					c->lockless_freelist[page->offset];
+
+				/* And put onto the regular freelist */
+				object[page->offset] = page->freelist;
+				page->freelist = object;
+				page->inuse--;
+			}
+		}
 	}
+
 	c->page = NULL;
 	unfreeze_slab(s, page);
 }
@@ -1508,6 +1532,7 @@ load_freelist:
 
 	object = c->page->freelist;
 	c->lockless_freelist = object[c->page->offset];
+	c->objects = c->page->inuse + 1;
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
@@ -1583,14 +1608,14 @@ static void __always_inline *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->page || !c->lockless_freelist ||
-					!node_match(c, node)))
+	if (unlikely(!c->lockless_freelist || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
 		object = c->lockless_freelist;
 		c->lockless_freelist = object[c->page->offset];
+		c->objects++;
 	}
 	local_irq_restore(flags);
 
@@ -1697,6 +1722,7 @@ static void __always_inline slab_free(st
 	if (likely(page == c->page && !SlabDebug(page))) {
 		object[page->offset] = c->lockless_freelist;
 		c->lockless_freelist = object;
+		c->objects--;
 	} else
 		__slab_free(s, page, x, addr);
 

-- 
