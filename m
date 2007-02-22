Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXBVMkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXBVMkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbXBVMkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:40:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52967 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064AbXBVMkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:40:23 -0500
Date: Thu, 22 Feb 2007 14:40:22 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, mpm@selenic.com, clameter@sgi.com,
       jsipek@fsl.cs.sunysb.edu
Subject: [PATCH 1/2] slab: introduce krealloc
Message-ID: <Pine.LNX.4.64.0702221439140.14523@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This introduce krealloc() that reallocates memory while keeping the
contents unchanged. The allocator avoids reallocation if the new size
fits the currently used cache. I also added a simple non-optimized
version for mm/slob.c for compatibility.

Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    1 +
 mm/slab.c            |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/slob.c            |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

Index: 2.6/include/linux/slab.h
===================================================================
--- 2.6.orig/include/linux/slab.h	2007-02-22 11:33:15.000000000 +0200
+++ 2.6/include/linux/slab.h	2007-02-22 11:33:39.000000000 +0200
@@ -72,6 +72,7 @@
  */
 void *__kmalloc(size_t, gfp_t);
 void *__kzalloc(size_t, gfp_t);
+void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 unsigned int ksize(const void *);
 
Index: 2.6/mm/slab.c
===================================================================
--- 2.6.orig/mm/slab.c	2007-02-22 11:33:15.000000000 +0200
+++ 2.6/mm/slab.c	2007-02-22 11:33:28.000000000 +0200
@@ -3737,6 +3737,53 @@
 #endif
 
 /**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ *
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	struct kmem_cache *cache, *new_cache;
+	void *ret;
+
+	if (unlikely(!p))
+		return kmalloc_track_caller(new_size, flags);
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return NULL;
+	}
+
+	cache = virt_to_cache(p);
+	new_cache = __find_general_cachep(new_size, flags);
+
+	/*
+ 	 * If new size fits in the current cache, bail out.
+ 	 */
+	if (likely(cache == new_cache))
+		return (void *)p;
+
+	/*
+ 	 * We are on the slow-path here so do not use __cache_alloc
+ 	 * because it bloats kernel text.
+ 	 */
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret) {
+		memcpy(ret, p, min(new_size, ksize(p)));
+		kfree(p);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
+/**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
  * @objp: The previously allocated object.
Index: 2.6/mm/slob.c
===================================================================
--- 2.6.orig/mm/slob.c	2007-02-22 11:33:15.000000000 +0200
+++ 2.6/mm/slob.c	2007-02-22 11:33:28.000000000 +0200
@@ -190,6 +190,39 @@
 }
 EXPORT_SYMBOL(__kmalloc);
 
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ *
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!p))
+		return kmalloc_track_caller(new_size, flags);
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return NULL;
+	}
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret) {
+		memcpy(ret, p, min(new_size, ksize(p)));
+		kfree(p);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
 void kfree(const void *block)
 {
 	bigblock_t *bb, **last = &bigblocks;
