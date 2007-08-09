Return-Path: <linux-kernel-owner+w=401wt.eu-S939724AbXHIQGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939724AbXHIQGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXHIQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:05:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbXHIQFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:05:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/14] FS-Cache: Recruit a couple of page flags for cache
	management [try #2]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Aug 2007 17:04:49 +0100
Message-ID: <20070809160449.17906.55114.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
References: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recruit a couple of page flags to aid in cache management.  The following extra
flags are defined:

 (1) PG_fscache (PG_owner_priv_2)

     The marked page is backed by a local cache and is pinning resources in the
     cache driver.

 (2) PG_fscache_write (PG_owner_priv_3)

     The marked page is being written to the local cache.  The page may not be
     modified whilst this is in progress.

If PG_fscache is set, then things that checked for PG_private will now also
check for that.  This includes things like truncation and page invalidation.
The function page_has_private() had been added to detect this.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/splice.c                |    2 +-
 include/linux/page-flags.h |   30 +++++++++++++++++++++++++++++-
 include/linux/pagemap.h    |   11 +++++++++++
 mm/filemap.c               |   16 ++++++++++++++++
 mm/migrate.c               |    2 +-
 mm/page_alloc.c            |    3 +++
 mm/readahead.c             |    9 +++++----
 mm/swap.c                  |    4 ++--
 mm/swap_state.c            |    4 ++--
 mm/truncate.c              |   10 +++++-----
 mm/vmscan.c                |    2 +-
 11 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index c010a72..ae4f5b7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -58,7 +58,7 @@ static int page_cache_pipe_buf_steal(struct pipe_inode_info *pipe,
 		 */
 		wait_on_page_writeback(page);
 
-		if (PagePrivate(page))
+		if (page_has_private(page))
 			try_to_release_page(page, GFP_KERNEL);
 
 		/*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 209d3a4..eaf9854 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -83,19 +83,24 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
+#define PG_owner_priv_2		13	/* Owner use. If pagecache, fs may use */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
+#define PG_owner_priv_3		18	/* Owner use. If pagecache, fs may use */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
 
-/* PG_owner_priv_1 users should have descriptive aliases */
+/* PG_owner_priv_1/2/3 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 #define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
+#define PG_fscache		PG_owner_priv_2	/* Backed by local cache */
+#define PG_fscache_write	PG_owner_priv_3	/* Writing to local cache */
+
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -199,6 +204,18 @@ static inline void SetPageUptodate(struct page *page)
 #define TestClearPageWriteback(page) test_and_clear_bit(PG_writeback,	\
 							&(page)->flags)
 
+#define PageFsCache(page)	test_bit(PG_fscache, &(page)->flags)
+#define SetPageFsCache(page)	set_bit(PG_fscache, &(page)->flags)
+#define ClearPageFsCache(page)	clear_bit(PG_fscache, &(page)->flags)
+#define TestSetPageFsCache(page) test_and_set_bit(PG_fscache, &(page)->flags)
+#define TestClearPageFsCache(page) test_and_clear_bit(PG_fscache, &(page)->flags)
+
+#define PageFsCacheWrite(page)		test_bit(PG_fscache_write, &(page)->flags)
+#define SetPageFsCacheWrite(page)	set_bit(PG_fscache_write, &(page)->flags)
+#define ClearPageFsCacheWrite(page)	clear_bit(PG_fscache_write, &(page)->flags)
+#define TestSetPageFsCacheWrite(page)	test_and_set_bit(PG_fscache_write, &(page)->flags)
+#define TestClearPageFsCacheWrite(page)	test_and_clear_bit(PG_fscache_write, &(page)->flags)
+
 #define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
 #define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
 #define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
@@ -272,4 +289,15 @@ static inline void set_page_writeback(struct page *page)
 	test_set_page_writeback(page);
 }
 
+/**
+ * page_has_private - Determine if page has private stuff
+ * @page: The page to be checked
+ *
+ * Determine if a page has private stuff, indicating that release routines
+ * should be invoked upon it.
+ */
+#define page_has_private(page)			\
+	((page)->flags & ((1 << PG_private) |	\
+			  (1 << PG_fscache)))
+
 #endif	/* PAGE_FLAGS_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 8a83537..d1049b6 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -208,6 +208,17 @@ static inline void wait_on_page_writeback(struct page *page)
 
 extern void end_page_writeback(struct page *page);
 
+/* 
+ * Wait for a page to finish being written to a local cache
+ */
+static inline void wait_on_page_fscache_write(struct page *page)
+{
+	if (PageFsCacheWrite(page))
+		wait_on_page_bit(page, PG_fscache_write);
+}
+
+extern void end_page_fscache_write(struct page *page);
+
 /*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
  *
diff --git a/mm/filemap.c b/mm/filemap.c
index 6cf700d..7b96487 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -557,6 +557,19 @@ void end_page_writeback(struct page *page)
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
+ * end_page_fscache_write - End writing page to cache
+ * @page: the page
+ */
+void end_page_fscache_write(struct page *page)
+{
+	if (!TestClearPageFsCacheWrite(page))
+		BUG();
+	smp_mb__after_clear_bit();
+	wake_up_page(page, PG_fscache_write);
+}
+EXPORT_SYMBOL(end_page_fscache_write);
+
+/**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
  *
@@ -2243,6 +2256,9 @@ out:
  * (presumably at page->private).  If the release was successful, return `1'.
  * Otherwise return zero.
  *
+ * This may also be called if PG_fscache is set on a page, indicating that the
+ * page is known to the local caching routines.
+ *
  * The @gfp_mask argument specifies whether I/O may be performed to release
  * this page (__GFP_IO), and whether the call may block (__GFP_WAIT).
  *
diff --git a/mm/migrate.c b/mm/migrate.c
index 37c73b9..828cacf 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -544,7 +544,7 @@ static int fallback_migrate_page(struct address_space *mapping,
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (PagePrivate(page) &&
+	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3da85b8..96a42d1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -208,6 +208,7 @@ static void bad_page(struct page *page)
 	dump_stack();
 	page->flags &= ~(1 << PG_lru	|
 			1 << PG_private |
+			1 << PG_fscache	|
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_dirty	|
@@ -445,6 +446,7 @@ static inline int free_pages_check(struct page *page)
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private |
+			1 << PG_fscache	|
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_slab	|
@@ -593,6 +595,7 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private	|
+			1 << PG_fscache	|
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_dirty	|
diff --git a/mm/readahead.c b/mm/readahead.c
index 12d1378..8b5e017 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -54,14 +54,15 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
 
 /*
  * see if a page needs releasing upon read_cache_pages() failure
- * - the caller of read_cache_pages() may have set PG_private before calling,
- *   such as the NFS fs marking pages that are cached locally on disk, thus we
- *   need to give the fs a chance to clean up in the event of an error
+ * - the caller of read_cache_pages() may have set PG_private or PG_fscache
+ *   before calling, such as the NFS fs marking pages that are cached locally
+ *   on disk, thus we need to give the fs a chance to clean up in the event of
+ *   an error
  */
 static void read_cache_pages_invalidate_page(struct address_space *mapping,
 					     struct page *page)
 {
-	if (PagePrivate(page)) {
+	if (page_has_private(page)) {
 		if (TestSetPageLocked(page))
 			BUG();
 		page->mapping = mapping;
diff --git a/mm/swap.c b/mm/swap.c
index d3cb966..498d0c1 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -412,8 +412,8 @@ void pagevec_strip(struct pagevec *pvec)
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 
-		if (PagePrivate(page) && !TestSetPageLocked(page)) {
-			if (PagePrivate(page))
+		if (page_has_private(page) && !TestSetPageLocked(page)) {
+			if (page_has_private(page))
 				try_to_release_page(page, 0);
 			unlock_page(page);
 		}
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 67daecb..93667ef 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -75,7 +75,7 @@ static int __add_to_swap_cache(struct page *page, swp_entry_t entry,
 	int error;
 
 	BUG_ON(PageSwapCache(page));
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		write_lock_irq(&swapper_space.tree_lock);
@@ -126,7 +126,7 @@ void __delete_from_swap_cache(struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!PageSwapCache(page));
 	BUG_ON(PageWriteback(page));
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 
 	radix_tree_delete(&swapper_space.page_tree, page_private(page));
 	set_page_private(page, 0);
diff --git a/mm/truncate.c b/mm/truncate.c
index 5cdfbc1..5555cb0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -48,7 +48,7 @@ void do_invalidatepage(struct page *page, unsigned long offset)
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_page(page, partial, PAGE_CACHE_SIZE - partial, KM_USER0);
-	if (PagePrivate(page))
+	if (page_has_private(page))
 		do_invalidatepage(page, partial);
 }
 
@@ -97,7 +97,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
-	if (PagePrivate(page))
+	if (page_has_private(page))
 		do_invalidatepage(page, 0);
 
 	remove_from_page_cache(page);
@@ -122,7 +122,7 @@ invalidate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, 0))
+	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
 	ret = remove_mapping(mapping, page);
@@ -344,14 +344,14 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
 	write_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
 		goto failed;
 
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 	__remove_from_page_cache(page);
 	write_unlock_irq(&mapping->tree_lock);
 	ClearPageUptodate(page);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d419e10..de851f4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -548,7 +548,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * process address space (page_count == 1) it can be freed.
 		 * Otherwise, leave the page on the LRU so it is swappable.
 		 */
-		if (PagePrivate(page)) {
+		if (page_has_private(page)) {
 			if (!try_to_release_page(page, sc->gfp_mask))
 				goto activate_locked;
 			if (!mapping && page_count(page) == 1)

