Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZBMMGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZBMMGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZBMMGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:06:05 -0500
Received: from 36-99-st.zelcom.ru ([80.92.99.36]:60207 "EHLO edward.zelnet.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753827AbZBMMGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:06:01 -0500
From: Edward Shishkin <edward.shishkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18837.24585.940650.679535@edward.zelnet.ru>
Date: Fri, 13 Feb 2009 14:56:57 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Ryan Hope <rmh3093@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Edward Shishkin <edward.shishkin@gmail.com>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: [patch 3/4] reiser4: use set_page_dirty_notag
X-Mailer: VM 7.17 under 21.5  (beta28) "fuki" (+CVS-20070806) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the core library functions set_page_dirty_notag()
and __set_page_dirty_nobuffers() instead of intenal
reiser4_set_page_dirty().

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
---
 fs/reiser4/as_ops.c                      |   31 +++++--------------------------
 fs/reiser4/entd.c                        |    2 +-
 fs/reiser4/page_cache.c                  |   21 ---------------------
 fs/reiser4/page_cache.h                  |    2 --
 fs/reiser4/plugin/file/cryptcompress.c   |    6 +++---
 fs/reiser4/plugin/file/file.c            |   12 ++----------
 fs/reiser4/plugin/item/extent_file_ops.c |    2 +-
 fs/reiser4/txnmgr.c                      |    2 +-
 fs/reiser4/wander.c                      |    9 +++++----
 9 files changed, 18 insertions(+), 69 deletions(-)

--- mmotm.orig/fs/reiser4/as_ops.c
+++ mmotm/fs/reiser4/as_ops.c
@@ -67,33 +67,12 @@ int reiser4_set_page_dirty(struct page *
 	assert("vs-1734", (page->mapping &&
 			   page->mapping->host &&
 			   reiser4_get_super_fake(page->mapping->host->i_sb) !=
-			   page->mapping->host
-			   && reiser4_get_cc_fake(page->mapping->host->i_sb) !=
-			   page->mapping->host
-			   && reiser4_get_bitmap_fake(page->mapping->host->i_sb) !=
+			   page->mapping->host &&
+			   reiser4_get_cc_fake(page->mapping->host->i_sb) !=
+			   page->mapping->host &&
+			   reiser4_get_bitmap_fake(page->mapping->host->i_sb) !=
 			   page->mapping->host));
-
-	if (!TestSetPageDirty(page)) {
-		struct address_space *mapping = page->mapping;
-
-		if (mapping) {
-			spin_lock_irq(&mapping->tree_lock);
-
-			/* check for race with truncate */
-			if (page->mapping) {
-				assert("vs-1652", page->mapping == mapping);
-				if (mapping_cap_account_dirty(mapping))
-					inc_zone_page_state(page,
-							NR_FILE_DIRTY);
-				radix_tree_tag_set(&mapping->page_tree,
-						   page->index,
-						   PAGECACHE_TAG_REISER4_MOVED);
-			}
-			spin_unlock_irq(&mapping->tree_lock);
-			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-		}
-	}
-	return 0;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /* ->invalidatepage method for reiser4 */
--- mmotm.orig/fs/reiser4/entd.c
+++ mmotm/fs/reiser4/entd.c
@@ -277,7 +277,7 @@ int write_page_by_ent(struct page *page,
 	 * page. Re-dirty page before unlocking so that if ent thread fails to
 	 * write it - it will remain dirty
 	 */
-	reiser4_set_page_dirty_internal(page);
+	set_page_dirty_notag(page);
 
 	/*
 	 * pin inode in memory, unlock page, entd_flush will iput. We can not
--- mmotm.orig/fs/reiser4/page_cache.c
+++ mmotm/fs/reiser4/page_cache.c
@@ -458,27 +458,6 @@ static struct bio *page_bio(struct page 
 		return ERR_PTR(RETERR(-ENOMEM));
 }
 
-/* this function is internally called by jnode_make_dirty() */
-int reiser4_set_page_dirty_internal(struct page *page)
-{
-	struct address_space *mapping;
-
-	mapping = page->mapping;
-	BUG_ON(mapping == NULL);
-
-	if (!TestSetPageDirty(page)) {
-		if (mapping_cap_account_dirty(mapping))
-			inc_zone_page_state(page, NR_FILE_DIRTY);
-
-		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-	}
-
-	/* znode must be dirty ? */
-	if (mapping->host == reiser4_get_super_fake(mapping->host->i_sb))
-		assert("", JF_ISSET(jprivate(page), JNODE_DIRTY));
-	return 0;
-}
-
 #if 0
 static int can_hit_entd(reiser4_context *ctx, struct super_block *s)
 {
--- mmotm.orig/fs/reiser4/page_cache.h
+++ mmotm/fs/reiser4/page_cache.h
@@ -18,8 +18,6 @@ extern void reiser4_done_formatted_fake(
 
 extern reiser4_tree *reiser4_tree_by_page(const struct page *);
 
-extern int reiser4_set_page_dirty_internal(struct page *);
-
 #define reiser4_submit_bio(rw, bio) submit_bio((rw), (bio))
 
 extern void reiser4_wait_page_writeback(struct page *);
--- mmotm.orig/fs/reiser4/plugin/file/cryptcompress.c
+++ mmotm/fs/reiser4/plugin/file/cryptcompress.c
@@ -1260,7 +1260,7 @@ static void set_cluster_pages_dirty(stru
 		assert("edward-968", pg != NULL);
 		lock_page(pg);
 		assert("edward-1065", PageUptodate(pg));
-		reiser4_set_page_dirty_internal(pg);
+		set_page_dirty_notag(pg);
 		unlock_page(pg);
 		mark_page_accessed(pg);
 	}
@@ -2027,7 +2027,7 @@ static int write_hole(struct inode *inod
 		lock_page(page);
 		zero_user(page, pg_off, to_pg);
 		SetPageUptodate(page);
-		reiser4_set_page_dirty_internal(page);
+		set_page_dirty_notag(page);
 		mark_page_accessed(page);
 		unlock_page(page);
 
@@ -2747,7 +2747,7 @@ static loff_t do_write_cryptcompress(str
 				goto err2;
 			}
 			SetPageUptodate(clust.pages[i]);
-			reiser4_set_page_dirty_internal(clust.pages[i]);
+			set_page_dirty_notag(clust.pages[i]);
 			flush_dcache_page(clust.pages[i]);
 			mark_page_accessed(clust.pages[i]);
 			unlock_page(clust.pages[i]);
--- mmotm.orig/fs/reiser4/plugin/file/file.c
+++ mmotm/fs/reiser4/plugin/file/file.c
@@ -912,12 +912,9 @@ int write_end_unix_file(struct file *fil
  *
  * As a result of (3) ->writepage may be called on a dirty page without
  * jnode. Such page is called "anonymous" in reiser4. Certain work-loads
- * (iozone) generate huge number of anonymous pages. Emergency flush handles
- * this situation by creating jnode for anonymous page, starting IO on the
- * page, and marking jnode with JNODE_KEEPME bit so that it's not thrown out of
- * memory. Such jnode is also called anonymous.
+ * (iozone) generate huge number of anonymous pages.
  *
- * reiser4_sync_sb() method tries to insert anonymous pages and jnodes into
+ * reiser4_sync_sb() method tries to insert anonymous pages into
  * tree. This is done by capture_anonymous_*() functions below.
  */
 
@@ -996,11 +993,6 @@ capture_anonymous_pages(struct address_s
 	*index = pvec.pages[i - 1]->index + 1;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
-		/*
-		 * tag PAGECACHE_TAG_REISER4_MOVED will be cleared by
-		 * reiser4_set_page_dirty_internal which is called when jnode is
-		 * captured
-		 */
 		result = capture_anonymous_page(pvec.pages[i]);
 		if (result == 1)
 			nr++;
--- mmotm.orig/fs/reiser4/plugin/item/extent_file_ops.c
+++ mmotm/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1073,7 +1073,7 @@ ssize_t reiser4_write_extent(struct file
 		}
 
 		flush_dcache_page(page);
-		reiser4_set_page_dirty_internal(page);
+		set_page_dirty_notag(page);
 		unlock_page(page);
 		nr_dirty++;
 
--- mmotm.orig/fs/reiser4/txnmgr.c
+++ mmotm/fs/reiser4/txnmgr.c
@@ -2426,7 +2426,7 @@ void znode_make_dirty(znode * z)
 		spin_unlock_jnode(node);
 		/* reiser4 file write code calls set_page_dirty for
 		 * unformatted nodes, for formatted nodes we do it here. */
-		reiser4_set_page_dirty_internal(page);
+		set_page_dirty_notag(page);
 		page_cache_release(page);
 		/* bump version counter in znode */
 		z->version = znode_build_version(jnode_get_tree(node));
--- mmotm.orig/fs/reiser4/wander.c
+++ mmotm/fs/reiser4/wander.c
@@ -16,10 +16,11 @@
    This code guarantees that those blocks that are defined to be part of an
    atom either all take effect or none of them take effect.
 
-   Relocate set nodes are submitted to write by the jnode_flush() routine, and
-   the overwrite set is submitted by reiser4_write_log().  This is because with
-   the overwrite set we seek to optimize writes, and with the relocate set we
-   seek to cause disk order to correlate with the parent first pre-order.
+   The "relocate set" of nodes are submitted to write by the jnode_flush()
+   routine, and the "overwrite set" is submitted by reiser4_write_log().
+   This is because with the overwrite set we seek to optimize writes, and
+   with the relocate set we seek to cause disk order to correlate with the
+   "parent first order" (preorder).
 
    reiser4_write_log() allocates and writes wandered blocks and maintains
    additional on-disk structures of the atom as wander records (each wander
