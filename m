Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXGHDuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXGHDuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbXGHDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49238 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755582AbXGHDuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:17 -0400
Message-Id: <20070708035016.643212528@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:49:55 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 03/10] SLUB: Do not use page->mapping
Content-Disposition: inline; filename=slub_free_up_mapping
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After moving the lockless_freelist to kmem_cache_cpu we no longer need
page->lockless_freelist. Restructure the use of the struct page fields in
such a way that we never touch the mapping field.

This is turn allows us to remove the special casing of SLUB when determining
the mapping of a page (needed for corner cases of virtual caches machines that
need to flush caches of processors mapping a page).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h       |    4 ----
 include/linux/mm_types.h |    9 ++-------
 mm/slub.c                |    2 --
 3 files changed, 2 insertions(+), 13 deletions(-)

Index: linux-2.6.22-rc6-mm1/include/linux/mm.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/mm.h	2007-07-05 19:05:02.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/mm.h	2007-07-05 19:05:24.000000000 -0700
@@ -632,10 +632,6 @@ static inline struct address_space *page
 	VM_BUG_ON(PageSlab(page));
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-#ifdef CONFIG_SLUB
-	else if (unlikely(PageSlab(page)))
-		mapping = NULL;
-#endif
 	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;
Index: linux-2.6.22-rc6-mm1/include/linux/mm_types.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/mm_types.h	2007-07-05 19:00:19.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/mm_types.h	2007-07-05 19:05:24.000000000 -0700
@@ -49,13 +49,8 @@ struct page {
 #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
 	    spinlock_t ptl;
 #endif
-	    struct {			/* SLUB uses */
-	    	void **lockless_freelist;
-		struct kmem_cache *slab;	/* Pointer to slab */
-	    };
-	    struct {
-		struct page *first_page;	/* Compound pages */
-	    };
+	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+	    struct page *first_page;	/* Compound tail pages */
 	};
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-05 19:05:16.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-05 19:05:24.000000000 -0700
@@ -1109,7 +1109,6 @@ static struct page *new_slab(struct kmem
 		atomic_long_inc(&n->nr_slabs);
 
 	page->inuse = 0;
-	page->lockless_freelist = NULL;
 	page->offset = s->offset / sizeof(void *);
 	page->slab = s;
 
@@ -1163,7 +1162,6 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		- pages);
 
-	page->mapping = NULL;
 	__free_pages(page, s->order);
 }
 

-- 
