Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbXFDTB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbXFDTB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760413AbXFDTBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:01:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34947 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760236AbXFDTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:01:08 -0400
Date: Mon, 4 Jun 2007 12:01:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Linus Torvalds wrote:

> Ok, I just noticed that this still has a bug: not just kfree(), but 
> krealloc() needs to treat ZERO_SIZE_PTR properly.


SLUB: Return ZERO_SIZE_PTR for kmalloc(0) V2

Instead of returning the smallest available object return ZERO_SIZE_PTR.

A ZERO_SIZE_PTR can be legitimately used as an object pointer as long
as it is not deferenced. The dereference of ZERO_SIZE_PTR causes a
distinctive fault.
kfree can handle a ZERO_SIZE_PTR in the same way as NULL.

This enables functions to use zero sized object. e.g. n = number of objects.


	objects = kmalloc(n * sizeof(object));

	for (i = 0; i < n; i++)
		objects[i].x = y;

	kfree(objects);

In addition to the warning that is already there for kmalloc(0) this patch
will cause the code to fail if there is an attempt to access objects in the
zero sized array.

V1->V2:
- Add support for ZERO_SIZE_PTR to krealloc
- Add support for ZERO_SIZE_PTR to ksize
- Fix spelling
- Insure we do an unsigned comparison in kfree.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   29 ++++++++++++++++++++++-------
 mm/slub.c                |   26 ++++++++++++++++++--------
 2 files changed, 40 insertions(+), 15 deletions(-)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-06-01 18:08:32.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-06-04 11:49:59.000000000 -0700
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
+ * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
+ * Both make kfree a no-op.
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
+++ slub/mm/slub.c	2007-06-04 11:59:41.000000000 -0700
@@ -2286,7 +2286,7 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	if (s)
 		return slab_alloc(s, flags, -1, __builtin_return_address(0));
-	return NULL;
+	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2297,16 +2297,20 @@ void *__kmalloc_node(size_t size, gfp_t 
 
 	if (s)
 		return slab_alloc(s, flags, node, __builtin_return_address(0));
-	return NULL;
+	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
 size_t ksize(const void *object)
 {
-	struct page *page = get_object_page(object);
+	struct page *page;
 	struct kmem_cache *s;
 
+	if (object == ZERO_SIZE_PTR)
+		return 0;
+
+	page = get_object_page(object);
 	BUG_ON(!page);
 	s = page->slab;
 	BUG_ON(!s);
@@ -2338,7 +2342,13 @@ void kfree(const void *x)
 	struct kmem_cache *s;
 	struct page *page;
 
-	if (!x)
+	/*
+	 * This has to be an unsigned comparison. According to Linus
+	 * some gcc version treat a pointer as a signed entity. Then
+	 * this comparison would be true for all "negative" pointers
+	 * (which would cover the whole upper half of the address space).
+	 */
+	if ((unsigned long)x <= (unsigned long)ZERO_SIZE_PTR)
 		return;
 
 	page = virt_to_head_page(x);
@@ -2443,12 +2453,12 @@ void *krealloc(const void *p, size_t new
 	void *ret;
 	size_t ks;
 
-	if (unlikely(!p))
+	if (unlikely(!p || p == ZERO_SIZE_PTR))
 		return kmalloc(new_size, flags);
 
 	if (unlikely(!new_size)) {
 		kfree(p);
-		return NULL;
+		return ZERO_SIZE_PTR;
 	}
 
 	ks = ksize(p);
@@ -2707,7 +2717,7 @@ void *__kmalloc_track_caller(size_t size
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
@@ -2718,7 +2728,7 @@ void *__kmalloc_node_track_caller(size_t
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	return slab_alloc(s, gfpflags, node, caller);
 }
