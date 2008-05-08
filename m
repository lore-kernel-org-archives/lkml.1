Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYEHVCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYEHVCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYEHVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:02:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48560 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYEHVCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:02:30 -0400
Date: Fri, 9 May 2008 00:02:24 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
cc: clameter@sgi.com, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kmemcheck: prepare for SLAB hooks
Message-ID: <Pine.LNX.4.64.0805090000540.28488@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Make mm/slub_kmemcheck.c more generic in preparation for adding kmemcheck hooks
to SLAB which does not use compound pages by default and has slightly different
way for keeping track of object size than SLUB.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slub_kmemcheck.h |   19 +++++++++++--------
 mm/slub.c                      |    8 ++++----
 mm/slub_kmemcheck.c            |   23 ++++++++++-------------
 3 files changed, 25 insertions(+), 25 deletions(-)

Index: kmemcheck/include/linux/slub_kmemcheck.h
===================================================================
--- kmemcheck.orig/include/linux/slub_kmemcheck.h	2008-05-08 23:50:38.000000000 +0300
+++ kmemcheck/include/linux/slub_kmemcheck.h	2008-05-08 23:50:45.000000000 +0300
@@ -3,28 +3,31 @@
 
 #ifdef CONFIG_KMEMCHECK
 void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-			   struct page *page);
-void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page);
-void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object);
-void kmemcheck_slab_free(struct kmem_cache *s, void *object);
+			   struct page *page, int order);
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size);
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
 #else
 static inline void
 kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-		       struct page *page)
+		       struct page *page, int order)
 {
 }
 
 static inline void
-kmemcheck_free_shadow(struct kmem_cache *s, struct page *page)
+kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
 {
 }
 
 static inline void
-kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object)
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+		     size_t size)
 {
 }
 
-static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object)
+static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object,
+				       size_t size)
 {
 }
 #endif /* CONFIG_KMEMCHECK */
Index: kmemcheck/mm/slub.c
===================================================================
--- kmemcheck.orig/mm/slub.c	2008-05-08 23:49:15.000000000 +0300
+++ kmemcheck/mm/slub.c	2008-05-08 23:50:45.000000000 +0300
@@ -1126,7 +1126,7 @@
 	}
 
 	if (kmemcheck_enabled && !(s->flags & SLAB_NOTRACK))
-		kmemcheck_alloc_shadow(s, flags, node, page);
+		kmemcheck_alloc_shadow(s, flags, node, page, compound_order(page));
 
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
@@ -1202,7 +1202,7 @@
 	}
 
 	if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK))
-		kmemcheck_free_shadow(s, page);
+		kmemcheck_free_shadow(s, page, compound_order(page));
 
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -1654,7 +1654,7 @@
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, c->objsize);
 
-	kmemcheck_slab_alloc(s, gfpflags, object);
+	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
 	return object;
 }
 
@@ -1757,7 +1757,7 @@
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
-	kmemcheck_slab_free(s, object);
+	kmemcheck_slab_free(s, object, c->objsize);
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
Index: kmemcheck/mm/slub_kmemcheck.c
===================================================================
--- kmemcheck.orig/mm/slub_kmemcheck.c	2008-05-08 23:50:38.000000000 +0300
+++ kmemcheck/mm/slub_kmemcheck.c	2008-05-08 23:50:45.000000000 +0300
@@ -5,12 +5,11 @@
 #include <linux/slub_kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
-			   struct page *page)
+			   struct page *page, int order)
 {
 	struct page *shadow;
-	int order, pages;
+	int pages;
 
-	order = compound_order(page);
 	pages = 1 << order;
 
 	/*
@@ -52,12 +51,11 @@
 		pages);
 }
 
-void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page)
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
 {
 	struct page *shadow = virt_to_page(page->shadow);
-	int order, pages;
+	int pages;
 
-	order = compound_order(page);
 	pages = 1 << order;
 
 	kmemcheck_show_pages(page, pages);
@@ -71,8 +69,8 @@
 	__free_pages(shadow, order);
 }
 
-void
-kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object)
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size)
 {
 	if (gfpflags & __GFP_ZERO)
 		return;
@@ -88,22 +86,21 @@
 		 * faults are not acceptable, the slab cache itself
 		 * should be marked NOTRACK.
 		 */
-		kmemcheck_mark_initialized(object, s->objsize);
+		kmemcheck_mark_initialized(object, size);
 	} else if (!s->ctor) {
 		/*
 		 * New objects should be marked uninitialized before
 		 * they're returned to the called.
 		 */
-		kmemcheck_mark_uninitialized(object, s->objsize);
+		kmemcheck_mark_uninitialized(object, size);
 	}
 }
 
-void
-kmemcheck_slab_free(struct kmem_cache *s, void *object)
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size)
 {
 	/* TODO: RCU freeing is unsupported for now; hide false positives. */
 	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
-		kmemcheck_mark_freed(object, s->objsize);
+		kmemcheck_mark_freed(object, size);
 }
 
 #ifdef CONFIG_KMEMCHECK_SELFTEST
