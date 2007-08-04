Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbXHDDG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbXHDDG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXHDDGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:06:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43336 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751151AbXHDDGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:06:48 -0400
Date: Fri, 3 Aug 2007 20:06:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>
Subject: [PATCH] Categorize GFP flags
Message-ID: <Pine.LNX.4.64.0708032003360.10851@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The function of GFP_LEVEL_MASK seems to be unclear. In order to clear up the
mystery we get rid of it and replace GFP_LEVEL_MASK with 3 sets of GFP flags:

GFP_RECLAIM_MASK	Flags used to control page allocator reclaim behavior.

GFP_CONSTRAINT_MASK	Flags used to limit where allocations can occur.

GFP_SLAB_BUG_MASK	Flags that the slab allocator BUG()s on.

These replace the uses of GFP_LEVEL mask in the slab allocators and in
vmalloc.c.

The use of the flags not included in these sets may occur as a result of a
slab allocation standing in for a page allocation when constructing scatter
gather lists. Extraneous flags are cleared and not passed through to the
page allocator. __GFP_MOVABLE/RECLAIMABLE, __GFP_COLD and __GFP_COMP will
now be ignored if passed to a slab allocator.

Change the allocation of allocator meta data in SLAB and vmalloc to not pass
through flags listed in GFP_CONSTRAINT_MASK. SLAB already removes the
__GFP_THISNODE flag for such allocations. Generalize that to also cover
vmalloc. The use of GFP_CONSTRAINT_MASK also includes __GFP_HARDWALL.

The impact of allocator metadata placement on access latency to the
cachelines of the object itself is minimal since metadata is only referenced
on alloc and free. The attempt is still made to place the meta data optimally
but we consistently allow fallback both in SLAB and vmalloc (SLUB does not
need to allocate metadata like that).

Allocator metadata may serve multiple in kernel users and thus should not
be subject to the limitations arising from a single allocation context.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/gfp.h |   23 +++++++++++++----------
 mm/slab.c           |    6 +++---
 mm/slub.c           |    5 +++--
 mm/vmalloc.c        |    5 +++--
 4 files changed, 22 insertions(+), 17 deletions(-)

Index: linux-2.6.23-rc1-mm2/include/linux/gfp.h
===================================================================
--- linux-2.6.23-rc1-mm2.orig/include/linux/gfp.h	2007-08-03 18:55:29.000000000 -0700
+++ linux-2.6.23-rc1-mm2/include/linux/gfp.h	2007-08-03 19:21:07.000000000 -0700
@@ -54,16 +54,6 @@ struct vm_area_struct;
 #define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
-/* if you forget to add the bitmask here kernel will crash, period */
-#define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
-			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
-			__GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
-			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| \
-			__GFP_RECLAIMABLE|__GFP_MOVABLE)
-
-/* This mask makes up all the page movable related flags */
-#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
-
 /* This equals 0, but use constants in case they ever change */
 #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
 /* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
@@ -92,6 +82,19 @@ struct vm_area_struct;
 #define GFP_THISNODE	((__force gfp_t)0)
 #endif
 
+/* This mask makes up all the page movable related flags */
+#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
+
+/* Control page allocator reclaim behavior */
+#define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
+			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
+			__GFP_NORETRY|__GFP_NOMEMALLOC)
+
+/* Control allocation constraints */
+#define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
+
+/* Do not use these with a slab allocator */
+#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
 /* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
    platforms, used as appropriate on others */
Index: linux-2.6.23-rc1-mm2/mm/slab.c
===================================================================
--- linux-2.6.23-rc1-mm2.orig/mm/slab.c	2007-08-03 18:55:27.000000000 -0700
+++ linux-2.6.23-rc1-mm2/mm/slab.c	2007-08-03 18:55:45.000000000 -0700
@@ -2768,9 +2768,9 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
+	BUG_ON(flags & GFP_SLAB_BUG_MASK);
+	local_flags = (flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK));
 
-	local_flags = (flags & GFP_LEVEL_MASK);
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
 	l3 = cachep->nodelists[nodeid];
@@ -2807,7 +2807,7 @@ static int cache_grow(struct kmem_cache 
 
 	/* Get slab management. */
 	slabp = alloc_slabmgmt(cachep, objp, offset,
-			local_flags & ~GFP_THISNODE, nodeid);
+			local_flags & ~GFP_CONSTRAINT_MASK, nodeid);
 	if (!slabp)
 		goto opps1;
 
Index: linux-2.6.23-rc1-mm2/mm/slub.c
===================================================================
--- linux-2.6.23-rc1-mm2.orig/mm/slub.c	2007-08-03 18:55:27.000000000 -0700
+++ linux-2.6.23-rc1-mm2/mm/slub.c	2007-08-03 18:55:45.000000000 -0700
@@ -1088,12 +1088,13 @@ static struct page *new_slab(struct kmem
 	void *last;
 	void *p;
 
-	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
+	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
 	if (flags & __GFP_WAIT)
 		local_irq_enable();
 
-	page = allocate_slab(s, flags & GFP_LEVEL_MASK, node);
+	page = allocate_slab(s,
+		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 	if (!page)
 		goto out;
 
Index: linux-2.6.23-rc1-mm2/mm/vmalloc.c
===================================================================
--- linux-2.6.23-rc1-mm2.orig/mm/vmalloc.c	2007-08-03 18:55:27.000000000 -0700
+++ linux-2.6.23-rc1-mm2/mm/vmalloc.c	2007-08-03 18:55:45.000000000 -0700
@@ -190,7 +190,8 @@ static struct vm_struct *__get_vm_area_n
 	if (unlikely(!size))
 		return NULL;
 
-	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_LEVEL_MASK, node);
+	area = kmalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);
+
 	if (unlikely(!area))
 		return NULL;
 
@@ -439,7 +440,7 @@ void *__vmalloc_area_node(struct vm_stru
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_LEVEL_MASK) | __GFP_ZERO,
+				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
 				node);
 	}
 	area->pages = pages;
