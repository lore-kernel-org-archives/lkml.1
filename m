Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbYBTQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbYBTQVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765400AbYBTQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:11:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765011AbYBTQKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:10:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/37] FS-Cache: Recruit a couple of page flags for cache
	management
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:07:03 +0000
Message-ID: <20080220160702.4715.97008.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recruit a couple of page flags to aid in cache management.  The following extra
flags are defined:

 (1) PG_fscache (PG_private_2)

     The marked page is backed by a local cache and is pinning resources in the
     cache driver.

 (2) PG_fscache_write (PG_owner_priv_2)

     The marked page is being written to the local cache.  The page may not be
     modified whilst this is in progress.

If PG_fscache is set, then things that checked for PG_private will now also
check for that.  This includes things like truncation and page invalidation.
The function page_has_private() had been added to make the checks for both
PG_private and PG_private_2 at the same time.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/splice.c                |    2 +-
 include/linux/page-flags.h |   39 +++++++++++++++++++++++++++++++++++++--
 include/linux/pagemap.h    |   11 +++++++++++
 mm/filemap.c               |   18 ++++++++++++++++++
 mm/migrate.c               |    2 +-
 mm/page_alloc.c            |    3 +++
 mm/readahead.c             |    9 +++++----
 mm/swap.c                  |    4 ++--
 mm/swap_state.c            |    4 ++--
 mm/truncate.c              |   10 +++++-----
 mm/vmscan.c                |    2 +-
 11 files changed, 86 insertions(+), 18 deletions(-)


diff --git a/fs/splice.c b/fs/splice.c
index 9b559ee..f2a7a06 100644
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
index bbad43f..cc16c23 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -77,25 +77,32 @@
 #define PG_active		 6
 #define PG_slab			 7	/* slab debug (Suparna wants this) */
 
-#define PG_owner_priv_1		 8	/* Owner use. If pagecache, fs may use*/
+#define PG_owner_priv_1		 8	/* Owner use. fs may use in pagecache */
 #define PG_arch_1		 9
 #define PG_reserved		10
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
+#define PG_private_2		13	/* If pagecache, has fs aux data */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
+#define PG_owner_priv_2		18	/* Owner use. fs may use in pagecache */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
 #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
 
-/* PG_owner_priv_1 users should have descriptive aliases */
+/* PG_owner_priv_1/2 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 #define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
+#define PG_fscache_write	PG_owner_priv_2	/* Writing to local cache */
+
+/* PG_private_2 causes releasepage() and co to be invoked */
+#define PG_fscache		PG_private_2	/* Backed by local cache */
+
 
 #if (BITS_PER_LONG > 32)
 /*
@@ -235,6 +242,23 @@ static inline void SetPageUptodate(struct page *page)
 #define TestClearPageWriteback(page) test_and_clear_bit(PG_writeback,	\
 							&(page)->flags)
 
+#define PagePrivate2(page)	test_bit(PG_private_2, &(page)->flags)
+#define SetPagePrivate2(page)	set_bit(PG_private_2, &(page)->flags)
+#define ClearPagePrivate2(page)	clear_bit(PG_private_2, &(page)->flags)
+#define TestSetPagePrivate2(page) test_and_set_bit(PG_private_2, &(page)->flags)
+#define TestClearPagePrivate2(page) test_and_clear_bit(PG_private_2, \
+						      &(page)->flags)
+
+#define PageOwnerPriv2(page)		test_bit(PG_owner_priv_2, \
+						 &(page)->flags)
+#define SetPageOwnerPriv2(page)		set_bit(PG_owner_priv_2, &(page)->flags)
+#define ClearPageOwnerPriv2(page)	clear_bit(PG_owner_priv_2, \
+						  &(page)->flags)
+#define TestSetPageOwnerPriv2(page)	test_and_set_bit(PG_owner_priv_2, \
+							 &(page)->flags)
+#define TestClearPageOwnerPriv2(page)	test_and_clear_bit(PG_owner_priv_2, \
+							   &(page)->flags)
+
 #define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
 #define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
 #define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
@@ -308,4 +332,15 @@ static inline void set_page_writeback(struct page *page)
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
+			  (1 << PG_private_2)))
+
 #endif	/* PAGE_FLAGS_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d2fca80..c5df3ae 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -226,6 +226,17 @@ static inline void wait_on_page_writeback(struct page *page)
 extern void end_page_writeback(struct page *page);
 
 /*
+ * Wait for a PG_owner_priv_2 to become clear
+ */
+static inline void wait_on_page_owner_priv_2(struct page *page)
+{
+	if (PageOwnerPriv2(page))
+		wait_on_page_bit(page, PG_owner_priv_2);
+}
+
+extern void end_page_owner_priv_2(struct page *page);
+
+/*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
  *
  * This assumes that two userspace pages are always sufficient.  That's
diff --git a/mm/filemap.c b/mm/filemap.c
index 5c74b68..8951d67 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -587,6 +587,21 @@ void end_page_writeback(struct page *page)
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
+ * end_page_own - Clear PG_owner_priv_2 and wake up any waiters
+ * @page: the page
+ *
+ * Clear PG_owner_priv_2 and wake up any processes waiting for that event.
+ */
+void end_page_owner_priv_2(struct page *page)
+{
+	if (!TestClearPageOwnerPriv2(page))
+		BUG();
+	smp_mb__after_clear_bit();
+	wake_up_page(page, PG_owner_priv_2);
+}
+EXPORT_SYMBOL(end_page_owner_priv_2);
+
+/**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
  *
@@ -2562,6 +2577,9 @@ out:
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
index 75ae1fb..ba4a9b2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -546,7 +546,7 @@ static int fallback_migrate_page(struct address_space *mapping,
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (PagePrivate(page) &&
+	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75b9793..036e80a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -231,6 +231,7 @@ static void bad_page(struct page *page)
 	dump_stack();
 	page->flags &= ~(1 << PG_lru	|
 			1 << PG_private |
+			1 << PG_fscache	|
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_dirty	|
@@ -457,6 +458,7 @@ static inline int free_pages_check(struct page *page)
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private |
+			1 << PG_fscache	|
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_slab	|
@@ -606,6 +608,7 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 		(page->flags & (
 			1 << PG_lru	|
 			1 << PG_private	|
+			1 << PG_fscache	|
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_dirty	|
diff --git a/mm/readahead.c b/mm/readahead.c
index 75aa6b6..272ffc7 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -46,14 +46,15 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
 
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
index 710a20b..36aa619 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -457,8 +457,8 @@ void pagevec_strip(struct pagevec *pvec)
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
index ec42f01..c3509f2 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -73,7 +73,7 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		write_lock_irq(&swapper_space.tree_lock);
@@ -102,7 +102,7 @@ void __delete_from_swap_cache(struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!PageSwapCache(page));
 	BUG_ON(PageWriteback(page));
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 
 	radix_tree_delete(&swapper_space.page_tree, page_private(page));
 	set_page_private(page, 0);
diff --git a/mm/truncate.c b/mm/truncate.c
index c35c49e..78b22a1 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -49,7 +49,7 @@ void do_invalidatepage(struct page *page, unsigned long offset)
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
-	if (PagePrivate(page))
+	if (page_has_private(page))
 		do_invalidatepage(page, partial);
 }
 
@@ -98,7 +98,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return;
 
-	if (PagePrivate(page))
+	if (page_has_private(page))
 		do_invalidatepage(page, 0);
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
@@ -125,7 +125,7 @@ invalidate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, 0))
+	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
 	ret = remove_mapping(mapping, page);
@@ -347,14 +347,14 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
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
index a26dabd..e1cc660 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -607,7 +607,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * process address space (page_count == 1) it can be freed.
 		 * Otherwise, leave the page on the LRU so it is swappable.
 		 */
-		if (PagePrivate(page)) {
+		if (page_has_private(page)) {
 			if (!try_to_release_page(page, sc->gfp_mask))
 				goto activate_locked;
 			if (!mapping && page_count(page) == 1)

