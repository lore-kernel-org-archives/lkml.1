Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbXFBBhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbXFBBhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXFBBhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:37:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60699 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757307AbXFBBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:37:48 -0400
Date: Fri, 1 Jun 2007 18:37:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of returning the smallest available object return ZERO_SIZE_PTR.

A ZERO_SIZE_PTR can be legitimately used as an object pointer as long
as it is not deferenced. The dereference of ZERO_SIZE_PTR causes a
distinctive fault. kfree will handle a ZERO_SIZE_PTR in the same way as 
NULL.

This enables functions to transparently use zero sized object. F.e.
if n = number of objects then the following code snippet will work
wether n = 0 or larger.

	objects = kmalloc(n * sizeof(object), GFP_KERNEL);

	for (i = 0; i < n; i++)
		objects[i].x = y;

	kfree(objects);

In addition to the warning for kmalloc(0) that is already there this patch 
will cause a failure if there is an attempt to access objects in the zero 
sized array.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   29 ++++++++++++++++++++++-------
 mm/slub.c                |   10 +++++-----
 2 files changed, 27 insertions(+), 12 deletions(-)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-06-01 18:08:32.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-06-01 18:22:56.000000000 -0700
@@ -74,14 +74,17 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(size_t size)
 {
+
 	/*
-	 * We should return 0 if size == 0 (which would result in the
-	 * kmalloc caller to get NULL) but we use the smallest object
-	 * here for legacy reasons. Just issue a warning so that
-	 * we can discover locations where we do 0 sized allocations.
+	 * The behavior for zero sized allocs changes. We no longer
+	 * allocate memory but return ZERO_SIZE_PTR.
+	 * WARN so that people can review and fix their code.
 	 */
 	WARN_ON_ONCE(size == 0);
 
+	if (!size)
+		return 0;
+
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
@@ -127,13 +130,25 @@ static inline struct kmem_cache *kmalloc
 #define SLUB_DMA 0
 #endif
 
+
+/*
+ * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
+ *
+ * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
+ *
+ * ZERO_SIZE_PTR can be passed to kfree() in the same way that NULL can.
+ * Both make kfree() a no-op.
+ */
+#define ZERO_SIZE_PTR ((void *)16)
+
+
 static inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return ZERO_SIZE_PTR;
 
 		return kmem_cache_alloc(s, flags);
 	} else
@@ -146,7 +161,7 @@ static inline void *kzalloc(size_t size,
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return ZERO_SIZE_PTR;
 
 		return kmem_cache_zalloc(s, flags);
 	} else
@@ -162,7 +177,7 @@ static inline void *kmalloc_node(size_t 
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return ZERO_SIZE_PTR;
 
 		return kmem_cache_alloc_node(s, flags, node);
 	} else
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-01 18:08:32.000000000 -0700
+++ slub/mm/slub.c	2007-06-01 18:22:56.000000000 -0700
@@ -2286,7 +2286,7 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	if (s)
 		return slab_alloc(s, flags, -1, __builtin_return_address(0));
-	return NULL;
+	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2297,7 +2297,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 
 	if (s)
 		return slab_alloc(s, flags, node, __builtin_return_address(0));
-	return NULL;
+	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2338,7 +2338,7 @@ void kfree(const void *x)
 	struct kmem_cache *s;
 	struct page *page;
 
-	if (!x)
+	if (x <= ZERO_SIZE_PTR)
 		return;
 
 	page = virt_to_head_page(x);
@@ -2707,7 +2707,7 @@ void *__kmalloc_track_caller(size_t size
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
@@ -2718,7 +2718,7 @@ void *__kmalloc_node_track_caller(size_t
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	return slab_alloc(s, gfpflags, node, caller);
 }
