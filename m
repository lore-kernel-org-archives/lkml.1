Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbZK1G1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbZK1G1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 01:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZK1G1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 01:27:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:53789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751894AbZK1G1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 01:27:36 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX19jsqg6a31jLpQks3wg8kVTurKO4Ys0k7gvYOnw1e
	SsmwCttCBHWLM3
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Cc: Johannes Buchner <buchner.johannes@gmx.at>
Subject: [PATCH 1/4] reiser4: some changes from reiser4-2.6.31 patch
Date: Sat, 28 Nov 2009 19:28:01 +1300
Message-Id: <1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
References: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from
http://www.kernel.org/pub/linux/kernel/people/edward/reiser4/reiser4-for-2.6/
---
 fs/reiser4/carry.c     |    2 +-
 fs/reiser4/carry_ops.c |    2 +-
 fs/reiser4/coord.c     |    8 ++++----
 fs/reiser4/entd.c      |    2 +-
 fs/reiser4/super_ops.c |    2 +-
 fs/reiser4/znode.h     |    1 -
 include/linux/mm.h     |    1 +
 mm/filemap.c           |    4 +++-
 mm/page-writeback.c    |   26 ++++++++++++++++++++++++++
 9 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/fs/reiser4/carry.c b/fs/reiser4/carry.c
index f2f1422..13a03f4 100644
--- a/fs/reiser4/carry.c
+++ b/fs/reiser4/carry.c
@@ -1095,7 +1095,7 @@ static void fatal_carry_error(carry_level * doing UNUSED_ARG	/* carry level
  *
  * This function itself only manages changes in carry structures and delegates
  * all hard work (allocation of znode for new root, changes of parent and
- * sibling pointers to the reiser4_add_tree_root().
+ * sibling pointers) to the reiser4_add_tree_root().
  *
  * Locking: old tree root is locked by carry at this point. Fake znode is also
  * locked.
diff --git a/fs/reiser4/carry_ops.c b/fs/reiser4/carry_ops.c
index 0906dbd..4fe0e6e 100644
--- a/fs/reiser4/carry_ops.c
+++ b/fs/reiser4/carry_ops.c
@@ -2015,7 +2015,7 @@ static int carry_estimate_bitmaps(void)
 		int bytes;
 
 		bytes = capped_height() * (0 +	/* bnode should be added, but
-						 * its is private to bitmap.c,
+						 * it is private to bitmap.c,
 						 * skip for now. */
 					   2 * sizeof(jnode));
 						/* working and commit jnodes */
diff --git a/fs/reiser4/coord.c b/fs/reiser4/coord.c
index e37e2f9..5c34e0a 100644
--- a/fs/reiser4/coord.c
+++ b/fs/reiser4/coord.c
@@ -36,12 +36,12 @@ void coord_normalize(coord_t *coord)
 
 	coord_clear_iplug(coord);
 
-	if (node_is_empty(node))
+	if (node_is_empty(node)) {
 		coord_init_first_unit(coord, node);
-	 else if ((coord->between == AFTER_ITEM)
-		   || (coord->between == AFTER_UNIT))
+	} else if ((coord->between == AFTER_ITEM)
+		   || (coord->between == AFTER_UNIT)) {
 		return;
-	 else if (coord->item_pos == coord_num_items(coord)
+	} else if (coord->item_pos == coord_num_items(coord)
 		   && coord->between == BEFORE_ITEM) {
 		coord_dec_item_pos(coord);
 		coord->between = AFTER_ITEM;
diff --git a/fs/reiser4/entd.c b/fs/reiser4/entd.c
index 4ea64a8..f41f62d 100644
--- a/fs/reiser4/entd.c
+++ b/fs/reiser4/entd.c
@@ -241,7 +241,7 @@ static void entd_flush(struct super_block *super, struct wbq *rq)
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		generic_sync_sb_inodes(rq->wbc);
+		generic_sync_sb_inodes(super, rq->wbc);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
 	reiser4_writeout(super, rq->wbc);
diff --git a/fs/reiser4/super_ops.c b/fs/reiser4/super_ops.c
index efc2d7b..85e6841 100644
--- a/fs/reiser4/super_ops.c
+++ b/fs/reiser4/super_ops.c
@@ -412,7 +412,7 @@ static void reiser4_sync_inodes(struct super_block *super,
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(wbc);
+	generic_sync_sb_inodes(super, wbc);
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
diff --git a/fs/reiser4/znode.h b/fs/reiser4/znode.h
index 4894e92..7e84371 100644
--- a/fs/reiser4/znode.h
+++ b/fs/reiser4/znode.h
@@ -18,7 +18,6 @@
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/semaphore.h>
 #include <linux/pagemap.h>	/* for PAGE_CACHE_SIZE */
 #include <asm/atomic.h>
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e935946..f185d15 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -836,6 +836,7 @@ int redirty_page_for_writepage(struct writeback_control *wbc,
 void account_page_dirtied(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
+int set_page_dirty_notag(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
diff --git a/mm/filemap.c b/mm/filemap.c
index 429489b..e7c57d5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -139,6 +139,7 @@ void __remove_from_page_cache(struct page *page)
 		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 	}
 }
+EXPORT_SYMBOL(__remove_from_page_cache);
 
 void remove_from_page_cache(struct page *page)
 {
@@ -151,6 +152,7 @@ void remove_from_page_cache(struct page *page)
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 }
+EXPORT_SYMBOL(remove_from_page_cache);
 
 static int sync_page(void *word)
 {
@@ -800,7 +802,6 @@ repeat:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL(find_get_pages);
 
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
@@ -970,6 +971,7 @@ static void shrink_readahead_size_eio(struct file *filp,
 {
 	ra->ra_pages /= 4;
 }
+EXPORT_SYMBOL(find_get_pages);
 
 /**
  * do_generic_file_read - generic file read routine
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6d5d74f..8cfd5f0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1143,6 +1143,32 @@ int __set_page_dirty_nobuffers(struct page *page)
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
+ * set_page_dirty_notag() -- similar to __set_page_dirty_nobuffers()
+ * except it doesn't tag the page dirty in the page-cache radix tree.
+ * This means that the address space using this cannot use the regular
+ * filemap ->writepages() helpers and must provide its own means of
+ * tracking and finding non-tagged dirty pages.
+ *
+ * NOTE: furthermore, this version also doesn't handle truncate races.
+ */
+int set_page_dirty_notag(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	if (!TestSetPageDirty(page)) {
+		unsigned long flags;
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		local_irq_save(flags);
+		account_page_dirtied(page, mapping);
+		local_irq_restore(flags);
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(set_page_dirty_notag);
+
+/*
  * When a writepage implementation decides that it doesn't want to write this
  * page for some reason, it should redirty the locked page via
  * redirty_page_for_writepage() and it should then unlock the page and return 0
-- 
1.6.4.4

