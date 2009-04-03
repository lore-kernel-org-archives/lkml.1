Return-Path: <linux-kernel-owner+w=401wt.eu-S935181AbZDCP66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935181AbZDCP66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbZDCPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56511 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703AbZDCPzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/41] FS-Cache: Recruit a page flags for cache management
	[ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:07 +0100
Message-ID: <20090403155507.28714.13233.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recruit a page flag to aid in cache management.  The following extra flag is
defined:

 (1) PG_fscache (PG_private_2)

     The marked page is backed by a local cache and is pinning resources in the
     cache driver.

If PG_fscache is set, then things that checked for PG_private will now also
check for that.  This includes things like truncation and page invalidation.
The function page_has_private() had been added to make the checks for both
PG_private and PG_private_2 at the same time.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/splice.c                |    3 ++-
 include/linux/page-flags.h |   38 +++++++++++++++++++++++++++++++++-----
 mm/filemap.c               |    3 +++
 mm/migrate.c               |   10 +++++-----
 mm/readahead.c             |    9 +++++----
 mm/swap.c                  |    4 ++--
 mm/truncate.c              |   10 +++++-----
 mm/vmscan.c                |    6 +++---
 8 files changed, 58 insertions(+), 25 deletions(-)


diff --git a/fs/splice.c b/fs/splice.c
index 4ed0ba4..dd727d4 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -59,7 +59,8 @@ static int page_cache_pipe_buf_steal(struct pipe_inode_info *pipe,
 		 */
 		wait_on_page_writeback(page);
 
-		if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
+		if (page_has_private(page) &&
+		    !try_to_release_page(page, GFP_KERNEL))
 			goto out_unlock;
 
 		/*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9d99e74..62214c7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -82,6 +82,7 @@ enum pageflags {
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
+	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_writeback,		/* Page is under writeback */
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
 	PG_head,		/* A head page */
@@ -108,6 +109,12 @@ enum pageflags {
 	/* Filesystems */
 	PG_checked = PG_owner_priv_1,
 
+	/* Two page bits are conscripted by FS-Cache to maintain local caching
+	 * state.  These bits are set on pages belonging to the netfs's inodes
+	 * when those inodes are being locally cached.
+	 */
+	PG_fscache = PG_private_2,	/* page backed by cache */
+
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
 	PG_savepinned = PG_dirty,
@@ -194,8 +201,6 @@ PAGEFLAG(Checked, checked)		/* Used by some filesystems */
 PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
-PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
-	__SETPAGEFLAG(Private, private)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobPage, slob_page)
@@ -205,6 +210,16 @@ __PAGEFLAG(SlubFrozen, slub_frozen)
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
+
+/*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
@@ -384,9 +399,10 @@ static inline void __ClearPageTail(struct page *page)
  * these flags set.  It they are, there is a problem.
  */
 #define PAGE_FLAGS_CHECK_AT_FREE \
-	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
-	 1 << PG_buddy | 1 << PG_writeback | 1 << PG_reserved | \
-	 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
+	(1 << PG_lru	 | 1 << PG_locked    | \
+	 1 << PG_private | 1 << PG_private_2 | \
+	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
+	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
 	 __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
@@ -397,4 +413,16 @@ static inline void __ClearPageTail(struct page *page)
 #define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
 
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
diff --git a/mm/filemap.c b/mm/filemap.c
index 126d397..cbc5772 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2463,6 +2463,9 @@ EXPORT_SYMBOL(generic_file_aio_write);
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
index a9eff3f..068655d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -250,7 +250,7 @@ out:
  * The number of remaining references must be:
  * 1 for anonymous pages without a mapping
  * 2 for pages with a mapping
- * 3 for pages with a mapping and PagePrivate set.
+ * 3 for pages with a mapping and PagePrivate/PagePrivate2 set.
  */
 static int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page)
@@ -270,7 +270,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	expected_count = 2 + !!PagePrivate(page);
+	expected_count = 2 + !!page_has_private(page);
 	if (page_count(page) != expected_count ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
@@ -386,7 +386,7 @@ EXPORT_SYMBOL(fail_migrate_page);
 
 /*
  * Common logic to directly migrate a single page suitable for
- * pages that do not use PagePrivate.
+ * pages that do not use PagePrivate/PagePrivate2.
  *
  * Pages are locked upon entry and exit.
  */
@@ -522,7 +522,7 @@ static int fallback_migrate_page(struct address_space *mapping,
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (PagePrivate(page) &&
+	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
@@ -655,7 +655,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!page->mapping) {
-		if (!PageAnon(page) && PagePrivate(page)) {
+		if (!PageAnon(page) && page_has_private(page)) {
 			/*
 			 * Go direct to try_to_free_buffers() here because
 			 * a) that's what try_to_release_page() would do anyway
diff --git a/mm/readahead.c b/mm/readahead.c
index 6be9275..133b6d5 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -33,14 +33,15 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
 
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
 		if (!trylock_page(page))
 			BUG();
 		page->mapping = mapping;
diff --git a/mm/swap.c b/mm/swap.c
index 6e83084..bede23c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -448,8 +448,8 @@ void pagevec_strip(struct pagevec *pvec)
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 
-		if (PagePrivate(page) && trylock_page(page)) {
-			if (PagePrivate(page))
+		if (page_has_private(page) && trylock_page(page)) {
+			if (page_has_private(page))
 				try_to_release_page(page, 0);
 			unlock_page(page);
 		}
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
index 06e7269..4252449 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -283,7 +283,7 @@ static inline int page_mapping_inuse(struct page *page)
 
 static inline int is_page_cache_freeable(struct page *page)
 {
-	return page_count(page) - !!PagePrivate(page) == 2;
+	return page_count(page) - !!page_has_private(page) == 2;
 }
 
 static int may_write_to_queue(struct backing_dev_info *bdi)
@@ -367,7 +367,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 		 * Some data journaling orphaned pages can have
 		 * page->mapping == NULL while being dirty with clean buffers.
 		 */
-		if (PagePrivate(page)) {
+		if (page_has_private(page)) {
 			if (try_to_free_buffers(page)) {
 				ClearPageDirty(page);
 				printk("%s: orphaned page\n", __func__);
@@ -727,7 +727,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * process address space (page_count == 1) it can be freed.
 		 * Otherwise, leave the page on the LRU so it is swappable.
 		 */
-		if (PagePrivate(page)) {
+		if (page_has_private(page)) {
 			if (!try_to_release_page(page, sc->gfp_mask))
 				goto activate_locked;
 			if (!mapping && page_count(page) == 1) {

