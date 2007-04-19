Return-Path: <linux-kernel-owner+w=401wt.eu-S1766855AbXDSQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766855AbXDSQgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766859AbXDSQfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48149 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766855AbXDSQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:15 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163515.11948.44138.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 2/8] Basic allocation for higher order page cache pages
Date: Thu, 19 Apr 2007 09:35:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Add basic allocation functions

Extend __page_cache_alloc to take an order parameter and
modify caller sites. Modify mapping_set_gfp_mask to set
__GFP_COMP if the mapping requires higher order allocations.

put_page() is already capable of handling compound pages. So
there are no changes needed to release higher order page
cache pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/pagemap.h |   15 +++++++++------
 mm/filemap.c            |    9 +++++----
 2 files changed, 14 insertions(+), 10 deletions(-)

Index: linux-2.6.21-rc7/include/linux/pagemap.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-18 21:21:56.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-18 21:29:02.000000000 -0700
@@ -32,6 +32,8 @@ static inline void mapping_set_gfp_mask(
 {
 	m->flags = (m->flags & ~(__force unsigned long)__GFP_BITS_MASK) |
 				(__force unsigned long)mask;
+	if (m->order)
+		m->flags |= __GFP_COMP;
 }
 
 /*
@@ -40,7 +42,7 @@ static inline void mapping_set_gfp_mask(
  * throughput (it can then be mapped into user
  * space in smaller chunks for same flexibility).
  *
- * Or rather, it _will_ be done in larger chunks.
+ * This is the base page size
  */
 #define PAGE_CACHE_SHIFT	PAGE_SHIFT
 #define PAGE_CACHE_SIZE		PAGE_SIZE
@@ -52,22 +54,23 @@ static inline void mapping_set_gfp_mask(
 void release_pages(struct page **pages, int nr, int cold);
 
 #ifdef CONFIG_NUMA
-extern struct page *__page_cache_alloc(gfp_t gfp);
+extern struct page *__page_cache_alloc(gfp_t gfp, int order);
 #else
-static inline struct page *__page_cache_alloc(gfp_t gfp)
+static inline struct page *__page_cache_alloc(gfp_t gfp, int order)
 {
-	return alloc_pages(gfp, 0);
+	return alloc_pages(gfp, order);
 }
 #endif
 
 static inline struct page *page_cache_alloc(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x));
+	return __page_cache_alloc(mapping_gfp_mask(x), x->order);
 }
 
 static inline struct page *page_cache_alloc_cold(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
+	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD,
+		x->order);
 }
 
 typedef int filler_t(void *, struct page *);
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-18 21:21:56.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-18 21:28:30.000000000 -0700
@@ -467,13 +467,13 @@ int add_to_page_cache_lru(struct page *p
 }
 
 #ifdef CONFIG_NUMA
-struct page *__page_cache_alloc(gfp_t gfp)
+struct page *__page_cache_alloc(gfp_t gfp, int order)
 {
 	if (cpuset_do_page_mem_spread()) {
 		int n = cpuset_mem_spread_node();
-		return alloc_pages_node(n, gfp, 0);
+		return alloc_pages_node(n, gfp, order);
 	}
-	return alloc_pages(gfp, 0);
+	return alloc_pages(gfp, order);
 }
 EXPORT_SYMBOL(__page_cache_alloc);
 #endif
@@ -803,7 +803,8 @@ grab_cache_page_nowait(struct address_sp
 		page_cache_release(page);
 		return NULL;
 	}
-	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS);
+	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS,
+		mapping->order);
 	if (page && add_to_page_cache_lru(page, mapping, index, GFP_KERNEL)) {
 		page_cache_release(page);
 		page = NULL;
