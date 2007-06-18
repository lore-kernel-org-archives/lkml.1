Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXFRKBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXFRKBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760822AbXFRJ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58627 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759064AbXFRJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:15 -0400
Message-Id: <20070618095915.117833972@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:58:45 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 07/26] SLUB: Add some more inlines and #ifdef CONFIG_SLUB_DEBUG
Content-Disposition: inline; filename=slub_inlines_ifdefs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add #ifdefs around data structures only needed if debugging is compiled
into SLUB.

Add inlines to small functions to reduce code size.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    4 ++++
 mm/slub.c                |   13 +++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-17 18:11:59.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-17 18:12:04.000000000 -0700
@@ -259,9 +259,10 @@ static int sysfs_slab_add(struct kmem_ca
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void sysfs_slab_remove(struct kmem_cache *);
 #else
-static int sysfs_slab_add(struct kmem_cache *s) { return 0; }
-static int sysfs_slab_alias(struct kmem_cache *s, const char *p) { return 0; }
-static void sysfs_slab_remove(struct kmem_cache *s) {}
+static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
+static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
+							{ return 0; }
+static inline void sysfs_slab_remove(struct kmem_cache *s) {}
 #endif
 
 /********************************************************************
@@ -1405,7 +1406,7 @@ static void deactivate_slab(struct kmem_
 	unfreeze_slab(s, page);
 }
 
-static void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
+static inline void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
 {
 	slab_lock(page);
 	deactivate_slab(s, page, cpu);
@@ -1415,7 +1416,7 @@ static void flush_slab(struct kmem_cache
  * Flush cpu slab.
  * Called from IPI handler with interrupts disabled.
  */
-static void __flush_cpu_slab(struct kmem_cache *s, int cpu)
+static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct page *page = s->cpu_slab[cpu];
 
@@ -2174,7 +2175,7 @@ static int free_list(struct kmem_cache *
 /*
  * Release all resources used by a slab cache.
  */
-static int kmem_cache_close(struct kmem_cache *s)
+static inline int kmem_cache_close(struct kmem_cache *s)
 {
 	int node;
 
Index: linux-2.6.22-rc4-mm2/include/linux/slub_def.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/slub_def.h	2007-06-17 18:11:59.000000000 -0700
+++ linux-2.6.22-rc4-mm2/include/linux/slub_def.h	2007-06-17 18:12:04.000000000 -0700
@@ -16,7 +16,9 @@ struct kmem_cache_node {
 	unsigned long nr_partial;
 	atomic_long_t nr_slabs;
 	struct list_head partial;
+#ifdef CONFIG_SLUB_DEBUG
 	struct list_head full;
+#endif
 };
 
 /*
@@ -44,7 +46,9 @@ struct kmem_cache {
 	int align;		/* Alignment */
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
+#ifdef CONFIG_SLUB_DEBUG
 	struct kobject kobj;	/* For sysfs */
+#endif
 
 #ifdef CONFIG_NUMA
 	int defrag_ratio;

-- 
