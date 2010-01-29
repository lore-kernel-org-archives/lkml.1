Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435Ab0A2Uv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0A2Uv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310Ab0A2Uv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:29 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42843 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab0A2UvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:22 -0500
Message-Id: <20100129204959.624858615@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:34 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Add get() and kick() methods
Content-Disposition: inline; filename=slub_add_get_and_kick
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the two methods needed for defragmentation and add the display of the
methods via the proc interface.

Add documentation explaining the use of these methods and the prototypes
for slab.h. Add functions to setup the defrag methods for a slab cache.

Add empty functions for SLAB/SLOB. The API is generic so it
could be theoretically implemented for either allocator.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/slab.h     |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/slub_def.h |    3 ++
 mm/slub.c                |   29 ++++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2010-01-29 10:27:09.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2010-01-29 10:27:17.000000000 -0600
@@ -88,6 +88,9 @@ struct kmem_cache {
 	gfp_t allocflags;	/* gfp flags to use on each alloc */
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(void *);
+	kmem_defrag_get_func *get;
+	kmem_defrag_kick_func *kick;
+
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	unsigned long min_partial;
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-01-29 10:27:14.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-01-29 10:27:17.000000000 -0600
@@ -2976,6 +2976,19 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+void kmem_cache_setup_defrag(struct kmem_cache *s,
+	kmem_defrag_get_func get, kmem_defrag_kick_func kick)
+{
+	/*
+	 * Defragmentable slabs must have a ctor otherwise objects may be
+	 * in an undetermined state after they are allocated.
+	 */
+	BUG_ON(!s->ctor);
+	s->get = get;
+	s->kick = kick;
+}
+EXPORT_SYMBOL(kmem_cache_setup_defrag);
+
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
  * the remaining slabs by the number of items in use. The slabs with the
@@ -3288,7 +3301,7 @@ static int slab_unmergeable(struct kmem_
 	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
 		return 1;
 
-	if (s->ctor)
+	if (s->ctor || s->kick || s->get)
 		return 1;
 
 	/*
@@ -4098,6 +4111,20 @@ static ssize_t ops_show(struct kmem_cach
 		x += sprint_symbol(buf + x, (unsigned long)s->ctor);
 		x += sprintf(buf + x, "\n");
 	}
+
+	if (s->get) {
+		x += sprintf(buf + x, "get : ");
+		x += sprint_symbol(buf + x,
+				(unsigned long)s->get);
+		x += sprintf(buf + x, "\n");
+	}
+
+	if (s->kick) {
+		x += sprintf(buf + x, "kick : ");
+		x += sprint_symbol(buf + x,
+				(unsigned long)s->kick);
+		x += sprintf(buf + x, "\n");
+	}
 	return x;
 }
 SLAB_ATTR_RO(ops);
Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2009-11-13 09:34:39.000000000 -0600
+++ linux-2.6/include/linux/slab.h	2010-01-29 10:27:17.000000000 -0600
@@ -140,6 +140,56 @@ void kzfree(const void *);
 size_t ksize(const void *);
 
 /*
+ * Function prototypes passed to kmem_cache_defrag() to enable defragmentation
+ * and targeted reclaim in slab caches.
+ */
+
+/*
+ * kmem_cache_defrag_get_func() is called with locks held so that the slab
+ * objects cannot be freed. We are in an atomic context and no slab
+ * operations may be performed. The purpose of kmem_cache_defrag_get_func()
+ * is to obtain a stable refcount on the objects, so that they cannot be
+ * removed until kmem_cache_kick_func() has handled them.
+ *
+ * Parameters passed are the number of objects to process and an array of
+ * pointers to objects for which we need references.
+ *
+ * Returns a pointer that is passed to the kick function. If any objects
+ * cannot be moved then the pointer may indicate a failure and
+ * then kick can simply remove the references that were already obtained.
+ *
+ * The object pointer array passed is also passed to kmem_cache_defrag_kick().
+ * The function may remove objects from the array by setting pointers to
+ * NULL. This is useful if we can determine that an object is already about
+ * to be removed. In that case it is often impossible to obtain the necessary
+ * refcount.
+ */
+typedef void *kmem_defrag_get_func(struct kmem_cache *, int, void **);
+
+/*
+ * kmem_cache_defrag_kick_func is called with no locks held and interrupts
+ * enabled. Sleeping is possible. Any operation may be performed in kick().
+ * kmem_cache_defrag should free all the objects in the pointer array.
+ *
+ * Parameters passed are the number of objects in the array, the array of
+ * pointers to the objects and the pointer returned by kmem_cache_defrag_get().
+ *
+ * Success is checked by examining the number of remaining objects in the slab.
+ */
+typedef void kmem_defrag_kick_func(struct kmem_cache *, int, void **, void *);
+
+/*
+ * kmem_cache_setup_defrag() is used to setup callbacks for a slab cache.
+ */
+#ifdef CONFIG_SLUB
+void kmem_cache_setup_defrag(struct kmem_cache *, kmem_defrag_get_func,
+						kmem_defrag_kick_func);
+#else
+static inline void kmem_cache_setup_defrag(struct kmem_cache *s,
+	kmem_defrag_get_func get, kmem_defrag_kick_func kiok) {}
+#endif
+
+/*
  * Allocator specific definitions. These are mainly used to establish optimized
  * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by
  * selecting the appropriate general cache at compile time.

-- 
