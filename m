Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYGSMbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYGSMbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYGSMax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:30:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYGSMav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:30:51 -0400
Date: Sat, 19 Jul 2008 15:30:40 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 3/8] slub: Add get() and kick() methods
Message-ID: <Pine.LNX.4.64.0807191530260.13345@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Add the two methods needed for defragmentation and add the display of the
methods via the proc interface.

Add documentation explaining the use of these methods and the prototypes
for slab.h. Add functions to setup the defrag methods for a slab cache.

Add empty functions for SLAB/SLOB. The API is generic so it
could be theoretically implemented for either allocator.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h     |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/slub_def.h |    3 ++
 mm/slub.c                |   29 +++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9aa90a6..7f71b2c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -101,6 +101,56 @@ void kfree(const void *);
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
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 6f8d25f..8b1b6cd 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -86,6 +86,9 @@ struct kmem_cache {
 	gfp_t allocflags;	/* gfp flags to use on each alloc */
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(struct kmem_cache *, void *);
+	kmem_defrag_get_func *get;
+	kmem_defrag_kick_func *kick;
+
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	int defrag_ratio;	/*
diff --git a/mm/slub.c b/mm/slub.c
index f21ffb9..1c256e2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2775,6 +2775,19 @@ void kfree(const void *x)
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
@@ -3068,7 +3081,7 @@ static int slab_unmergeable(struct kmem_cache *s)
 	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
 		return 1;
 
-	if (s->ctor)
+	if (s->ctor || s->kick || s->get)
 		return 1;
 
 	/*
@@ -3852,6 +3865,20 @@ static ssize_t ops_show(struct kmem_cache *s, char *buf)
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
-- 
1.5.4.3

