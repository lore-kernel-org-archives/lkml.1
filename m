Return-Path: <linux-kernel-owner+w=401wt.eu-S1423187AbXDXWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423187AbXDXWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423174AbXDXWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43917 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423175AbXDXWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:07 -0400
Message-Id: <20070424222306.289124159@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:13 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [08/17] Define functions for page cache handling
Content-Disposition: inline; filename=var_pc_sizes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We use the macros PAGE_CACHE_SIZE PAGE_CACHE_SHIFT PAGE_CACHE_MASK
and PAGE_CACHE_ALIGN in various places in the kernel. These are useful
if one only want to support one page size in the page cache.

This patch provides a set of functions in order to provide the
ability to define new page size in the future.

All functions take an address_space pointer. Add a set of extended functions
that will be used to consolidate the hand crafted shifts and adds in use
right now.

New function			Related base page constant
---------------------------------------------------
page_cache_shift(a)		PAGE_CACHE_SHIFT
page_cache_size(a)		PAGE_CACHE_SIZE
page_cache_mask(a)		PAGE_CACHE_MASK
page_cache_index(a, pos)	Calculate page number from position
page_cache_next(addr, pos)	Page number of next page
page_cache_offset(a, pos)	Calculate offset into a page
page_cache_pos(a, index, offset)
				Form position based on page number
				and an offset.

The workings of these functions depend on CONFIG_LARGE_BLOCKSIZE. If set
then these sizes are dynamically calculated. Otherwise the functions will
provide constant results.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 block/Kconfig           |   17 +++++++
 include/linux/fs.h      |    5 ++
 include/linux/pagemap.h |  115 +++++++++++++++++++++++++++++++++++++++++++++---
 mm/filemap.c            |   12 ++---
 4 files changed, 139 insertions(+), 10 deletions(-)

Index: linux-2.6.21-rc7/include/linux/pagemap.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-24 11:31:49.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-24 11:37:21.000000000 -0700
@@ -32,6 +32,10 @@ static inline void mapping_set_gfp_mask(
 {
 	m->flags = (m->flags & ~(__force unsigned long)__GFP_BITS_MASK) |
 				(__force unsigned long)mask;
+#ifdef CONFIG_LARGE_BLOCKSIZE
+	if (m->order)
+		m->flags |= __GFP_COMP;
+#endif
 }
 
 /*
@@ -41,33 +45,134 @@ static inline void mapping_set_gfp_mask(
  * space in smaller chunks for same flexibility).
  *
  * Or rather, it _will_ be done in larger chunks.
+ *
+ * The following constants can be used if a filesystem only supports a single
+ * page size.
  */
 #define PAGE_CACHE_SHIFT	PAGE_SHIFT
 #define PAGE_CACHE_SIZE		PAGE_SIZE
 #define PAGE_CACHE_MASK		PAGE_MASK
 #define PAGE_CACHE_ALIGN(addr)	(((addr)+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)
 
+/*
+ * The next set of functions allow to write code that is capable of dealing
+ * with multiple page sizes.
+ */
+#ifdef CONFIG_LARGE_BLOCKSIZE
+static inline void set_mapping_order(struct address_space *a, int order)
+{
+	a->order = order;
+	a->shift = order + PAGE_SHIFT;
+	a->offset_mask = (1UL << a->shift) - 1;
+	if (order)
+		a->flags |= __GFP_COMP;
+}
+
+static inline int mapping_order(struct address_space *a)
+{
+	return a->order;
+}
+
+static inline int page_cache_shift(struct address_space *a)
+{
+	return a->shift;
+}
+
+static inline unsigned int page_cache_size(struct address_space *a)
+{
+	return a->offset_mask + 1;
+}
+
+static inline loff_t page_cache_mask(struct address_space *a)
+{
+	return ~a->offset_mask;
+}
+
+static inline unsigned int page_cache_offset(struct address_space *a,
+		loff_t pos)
+{
+	return pos & a->offset_mask;
+}
+#else
+/*
+ * Kernel configured for a fixed PAGE_SIZEd page cache
+ */
+static inline void set_mapping_order(struct address_space *a, int order)
+{
+	BUG_ON(order);
+}
+
+static inline int mapping_order(struct address_space *a)
+{
+	return 0;
+}
+
+static inline int page_cache_shift(struct address_space *a)
+{
+	return PAGE_SHIFT;
+}
+
+static inline unsigned int page_cache_size(struct address_space *a)
+{
+	return PAGE_SIZE;
+}
+
+static inline loff_t page_cache_mask(struct address_space *a)
+{
+	return (loff_t)PAGE_MASK;
+}
+
+static inline unsigned int page_cache_offset(struct address_space *a,
+		loff_t pos)
+{
+	return pos & ~PAGE_MASK;
+}
+#endif
+
+static inline pgoff_t page_cache_index(struct address_space *a,
+		loff_t pos)
+{
+	return pos >> page_cache_shift(a);
+}
+
+/*
+ * Index of the page starting on or after the given position.
+ */
+static inline pgoff_t page_cache_next(struct address_space *a,
+		loff_t pos)
+{
+	return page_cache_index(a, pos + page_cache_size(a) - 1);
+}
+
+static inline loff_t page_cache_pos(struct address_space *a,
+		pgoff_t index, unsigned long offset)
+{
+	return ((loff_t)index << page_cache_shift(a)) + offset;
+}
+
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
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
+	return __page_cache_alloc(mapping_gfp_mask(x),
+			mapping_order(x));
 }
 
 static inline struct page *page_cache_alloc_cold(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
+	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD,
+			mapping_order(x));
 }
 
 typedef int filler_t(void *, struct page *);
Index: linux-2.6.21-rc7/include/linux/fs.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/fs.h	2007-04-24 11:31:49.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/fs.h	2007-04-24 11:37:21.000000000 -0700
@@ -435,6 +435,11 @@ struct address_space {
 	struct inode		*host;		/* owner: inode, block_device */
 	struct radix_tree_root	page_tree;	/* radix tree of all pages */
 	rwlock_t		tree_lock;	/* and rwlock protecting it */
+#ifdef CONFIG_LARGE_BLOCKSIZE
+	unsigned int		order;		/* Page order of the pages in here */
+	unsigned int		shift;		/* Shift of index */
+	loff_t			offset_mask;	/* Mask to get to offset bits */
+#endif
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-24 11:31:49.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-24 11:37:21.000000000 -0700
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
@@ -672,7 +672,8 @@ repeat:
 	if (!page) {
 		if (!cached_page) {
 			cached_page =
-				__page_cache_alloc(gfp_mask);
+				__page_cache_alloc(gfp_mask,
+					mapping_order(mapping));
 			if (!cached_page)
 				return NULL;
 		}
@@ -805,7 +806,8 @@ grab_cache_page_nowait(struct address_sp
 		page_cache_release(page);
 		return NULL;
 	}
-	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS);
+	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS,
+				mapping_order(mapping));
 	if (page && add_to_page_cache_lru(page, mapping, index, GFP_KERNEL)) {
 		page_cache_release(page);
 		page = NULL;
Index: linux-2.6.21-rc7/block/Kconfig
===================================================================
--- linux-2.6.21-rc7.orig/block/Kconfig	2007-04-24 11:37:57.000000000 -0700
+++ linux-2.6.21-rc7/block/Kconfig	2007-04-24 11:40:23.000000000 -0700
@@ -49,6 +49,23 @@ config LSF
 
 	  If unsure, say Y.
 
+#
+# We do not support HIGHMEM because kmap does not support higher order pages
+# We do not support 32 bit because smaller machines are limited in memory
+# and fragmentation could easily occur. Also 32 bit machines typically
+# have restricted DMA areas which requires page bouncing.
+#
+config LARGE_BLOCKSIZE
+	bool "Support blocksizes larger than page size"
+	default n
+	depends on EXPERIMENTAL && !HIGHMEM && 64BIT
+	help
+	  Allows the page cache to support higher orders of pages. Higher
+	  order page cache pages may be useful to support special devices
+	  like CD or DVDs and Flash. Also to increase I/O performance.
+	  However, be aware that higher order pages may cause fragmentation
+	  which in turn may lead to OOM conditions.
+
 endif
 
 source block/Kconfig.iosched

--
