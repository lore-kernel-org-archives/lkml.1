Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYKTOo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYKTOo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYKTOmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:42:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40991 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbYKTOmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:42:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/45] FS-Cache: Recruit a couple of page flags for cache
	management [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:42:10 +0000
Message-ID: <20081120144210.10667.11143.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
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

 fs/splice.c                |    3 ++-
 include/linux/page-flags.h |   41 ++++++++++++++++++++++++++++++++++++-----
 include/linux/pagemap.h    |   14 ++++++++++++++
 mm/filemap.c               |   18 ++++++++++++++++++
 mm/migrate.c               |   10 +++++-----
 mm/readahead.c             |    9 +++++----
 mm/swap.c                  |    4 ++--
 mm/swap_state.c            |    4 ++--
 mm/swapfile.c              |    4 ++--
 mm/truncate.c              |   10 +++++-----
 mm/vmscan.c                |    6 +++---
 11 files changed, 94 insertions(+), 29 deletions(-)


diff --git a/fs/splice.c b/fs/splice.c
index 1abab5c..fd04e95 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -58,7 +58,8 @@ static int page_cache_pipe_buf_steal(struct pipe_inode_info *pipe,
 		 */
 		wait_on_page_writeback(page);
 
-		if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+		if (page_has_private(page) &&
+		    !try_to_release_page(page, GFP_KERNEL))
 			goto out_unlock;
 
 		/*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 74b9d90..da467b2 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -79,9 +79,11 @@ enum pageflags {
 	PG_active,
 	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
+	PG_owner_priv_2,	/* Owner use. fs may use in pagecache */
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
+	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_writeback,		/* Page is under writeback */
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
 	PG_head,		/* A head page */
@@ -106,6 +108,13 @@ enum pageflags {
 	/* Filesystems */
 	PG_checked = PG_owner_priv_1,
 
+	/* Two page bits are conscripted by FS-Cache to maintain local caching state.
+	 * These bits are set on pages belonging to the netfs's inodes when those
+	 * inodes are being locally cached.
+	 */
+	PG_fscache = PG_private_2,	/* page backed by cache */
+	PG_fscache_write = PG_owner_priv_2,	/* page being written to cache */
+
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
 	PG_savepinned = PG_dirty,
@@ -192,8 +201,6 @@ PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
-PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
-	__SETPAGEFLAG(Private, private)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobPage, slob_page)
@@ -203,6 +210,17 @@ __PAGEFLAG(SlubFrozen, slub_frozen)
 __PAGEFLAG(SlubDebug, slub_debug)
 
 /*
+ * Private page markings that may be used by the filesystem that owns the page
+ * for its own purposes.
+ * - PG_private and PG_private_2 cause releasepage() and co to be invoked
+ */
+PAGEFLAG(Private, private) __SETPAGEFLAG(Private, private)
+	__CLEARPAGEFLAG(Private, private)
+PAGEFLAG(Private2, private_2) TESTSCFLAG(Private2, private_2)
+PAGEFLAG(OwnerPriv1, owner_priv_1) TESTCLEARFLAG(OwnerPriv1, owner_priv_1)
+PAGEFLAG(OwnerPriv2, owner_priv_2) TESTSCFLAG(OwnerPriv2, owner_priv_2)
+
+/*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
@@ -372,9 +390,10 @@ static inline void __ClearPageTail(struct page *page)
 #define __PG_MLOCKED		0
 #endif
 
-#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
-			 1 << PG_buddy | 1 << PG_writeback | \
-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
+#define PAGE_FLAGS	(1 << PG_locked   | 1 << PG_lru       | \
+			 1 << PG_private  | 1 << PG_private_2 |	\
+			 1 << PG_buddy    | 1 << PG_writeback | \
+			 1 << PG_slab     | 1 << PG_swapcache | 1 << PG_active | \
 			 __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
@@ -399,4 +418,16 @@ static inline void __ClearPageTail(struct page *page)
 		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
 
 #endif /* !__GENERATING_BOUNDS_H */
+
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
index 709742b..9f51669 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -378,6 +378,20 @@ static inline void wait_on_page_writeback(struct page *page)
 
 extern void end_page_writeback(struct page *page);
 
+/**
+ * wait_on_page_owner_priv_2 - Wait for PG_owner_priv_2 to become clear
+ * @page: The page to monitor
+ *
+ * Wait for a PG_owner_priv_2 to become clear on the specified page.
+ */
+static inline void wait_on_page_owner_priv_2(struct page *page)
+{
+	if (PageOwnerPriv2(page))
+		wait_on_page_bit(page, PG_owner_priv_2);
+}
+
+extern void end_page_owner_priv_2(struct page *page);
+
 /*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
  *
diff --git a/mm/filemap.c b/mm/filemap.c
index f3e5f89..abfd70c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -603,6 +603,21 @@ void end_page_writeback(struct page *page)
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
+ * end_page_owner_priv_2 - Clear PG_owner_priv_2 and wake up any waiters
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
@@ -2452,6 +2467,9 @@ EXPORT_SYMBOL(generic_file_aio_write);
  * (presumably at page->private).  If the release was successful, return `1'.
  * Otherwise return zero.
  *
+ * This may also be called if PG_fscache is set on a page, indicating that the
+ * page is known to the local caching routines.
+ *
  * The @gfp_mask argument specifies whether I/O may be performed to release
  * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
  *
diff --git a/mm/migrate.c b/mm/migrate.c
index 9dd10da..f50093c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -264,7 +264,7 @@ out:
  * The number of remaining references must be:
  * 1 for anonymous pages without a mapping
  * 2 for pages with a mapping
- * 3 for pages with a mapping and PagePrivate set.
+ * 3 for pages with a mapping and PagePrivate/PagePrivate2 set.
  */
 static int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page)
@@ -284,7 +284,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	expected_count = 2 + !!PagePrivate(page);
+	expected_count = 2 + !!page_has_private(page);
 	if (page_count(page) != expected_count ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
@@ -407,7 +407,7 @@ EXPORT_SYMBOL(fail_migrate_page);
 
 /*
  * Common logic to directly migrate a single page suitable for
- * pages that do not use PagePrivate.
+ * pages that do not use PagePrivate/PagePrivate2.
  *
  * Pages are locked upon entry and exit.
  */
@@ -546,7 +546,7 @@ static int fallback_migrate_page(struct address_space *mapping,
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (PagePrivate(page) &&
+	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
@@ -676,7 +676,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!page->mapping) {
-		if (!PageAnon(page) && PagePrivate(page)) {
+		if (!PageAnon(page) && page_has_private(page)) {
 			/*
 			 * Go direct to try_to_free_buffers() here because
 			 * a) that's what try_to_release_page() would do anyway
diff --git a/mm/readahead.c b/mm/readahead.c
index a3366f3..34e8e99 100644
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
index 2152e48..80bc918 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -478,8 +478,8 @@ void pagevec_strip(struct pagevec *pvec)
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 
-		if (PagePrivate(page) && trylock_page(page)) {
-			if (PagePrivate(page))
+		if (page_has_private(page) && trylock_page(page)) {
+			if (page_has_private(page))
 				try_to_release_page(page, 0);
 			unlock_page(page);
 		}
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3353c90..0c1da6e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -74,8 +74,8 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
-	BUG_ON(PagePrivate(page));
 	BUG_ON(!PageSwapBacked(page));
+	BUG_ON(page_has_private(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		page_cache_get(page);
@@ -111,7 +111,7 @@ void __delete_from_swap_cache(struct page *page)
 	BUG_ON(!PageLocked(page));
 	BUG_ON(!PageSwapCache(page));
 	BUG_ON(PageWriteback(page));
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 
 	radix_tree_delete(&swapper_space.page_tree, page_private(page));
 	set_page_private(page, 0);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 90cb67a..72b8ccc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -350,7 +350,7 @@ static int remove_exclusive_swap_page_count(struct page *page, int count)
 	struct swap_info_struct * p;
 	swp_entry_t entry;
 
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 	BUG_ON(!PageLocked(page));
 
 	if (!PageSwapCache(page))
@@ -432,7 +432,7 @@ void free_swap_and_cache(swp_entry_t entry)
 	if (page) {
 		int one_user;
 
-		BUG_ON(PagePrivate(page));
+		BUG_ON(page_has_private(page));
 		one_user = (page_count(page) == 2);
 		/* Only cache user (+us), or swap space full? Free it! */
 		/* Also recheck PageSwapCache after page is locked (above) */
diff --git a/mm/truncate.c b/mm/truncate.c
index 1229211..55206fa 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -50,7 +50,7 @@ void do_invalidatepage(struct page *page, unsigned long offset)
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
-	if (PagePrivate(page))
+	if (page_has_private(page))
 		do_invalidatepage(page, partial);
 }
 
@@ -99,7 +99,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return;
 
-	if (PagePrivate(page))
+	if (page_has_private(page))
 		do_invalidatepage(page, 0);
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
@@ -126,7 +126,7 @@ invalidate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, 0))
+	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
 	clear_page_mlock(page);
@@ -348,7 +348,7 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return 0;
 
-	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
 	spin_lock_irq(&mapping->tree_lock);
@@ -356,7 +356,7 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 		goto failed;
 
 	clear_page_mlock(page);
-	BUG_ON(PagePrivate(page));
+	BUG_ON(page_has_private(page));
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
 	page_cache_release(page);	/* pagecache ref */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c141b3e..44abf78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -254,7 +254,7 @@ static inline int page_mapping_inuse(struct page *page)
 
 static inline int is_page_cache_freeable(struct page *page)
 {
-	return page_count(page) - !!PagePrivate(page) == 2;
+	return page_count(page) - !!page_has_private(page) == 2;
 }
 
 static int may_write_to_queue(struct backing_dev_info *bdi)
@@ -338,7 +338,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 		 * Some data journaling orphaned pages can have
 		 * page->mapping == NULL while being dirty with clean buffers.
 		 */
-		if (PagePrivate(page)) {
+		if (page_has_private(page)) {
 			if (try_to_free_buffers(page)) {
 				ClearPageDirty(page);
 				printk("%s: orphaned page\n", __func__);
@@ -708,7 +708,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * process address space (page_count == 1) it can be freed.
 		 * Otherwise, leave the page on the LRU so it is swappable.
 		 */
-		if (PagePrivate(page)) {
+		if (page_has_private(page)) {
 			if (!try_to_release_page(page, sc->gfp_mask))
 				goto activate_locked;
 			if (!mapping && page_count(page) == 1) {

