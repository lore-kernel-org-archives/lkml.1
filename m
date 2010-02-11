Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0BKXGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:06:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:36686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab0BKXGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:06:32 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       fengguang.wu@intel.com, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] mm: Implement writeback livelock avoidance using page tagging
Date: Fri, 12 Feb 2010 00:06:23 +0100
Message-Id: <1265929584-5080-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1265929584-5080-1-git-send-email-jack@suse.cz>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We go though all sorts of hoops to avoid livelocking when we do
writeback on a mapping and someone steadily creates dirty pages
in that mapping. The motivation of this patch is to implement
a simple way to avoid livelocks (an thus we can rip out all the
methods we used previously).

The idea is simple: Tag all pages that should be written back
with a special tag (TOWRITE) in the radix tree. This can be done
rather quickly and thus livelocks should not happen in practice.
Then we start doing the hard work of locking pages and sending
them to disk only for those pages that have TOWRITE tag set.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h         |    1 +
 include/linux/radix-tree.h |    2 +-
 mm/page-writeback.c        |   37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1bcb27..da425f5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -681,6 +681,7 @@ struct block_device {
  */
 #define PAGECACHE_TAG_DIRTY	0
 #define PAGECACHE_TAG_WRITEBACK	1
+#define PAGECACHE_TAG_TOWRITE	2
 
 int mapping_tagged(struct address_space *mapping, int tag);
 
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 41fa087..c3f99b5 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -55,7 +55,7 @@ static inline int radix_tree_is_indirect_ptr(void *ptr)
 
 /*** radix-tree API starts here ***/
 
-#define RADIX_TREE_MAX_TAGS 2
+#define RADIX_TREE_MAX_TAGS 3
 
 /* root tags are stored in gfp_mask, shifted by __GFP_BITS_SHIFT */
 struct radix_tree_root {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0b19943..f37cbc2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -803,6 +803,30 @@ void __init page_writeback_init(void)
 }
 
 /**
+ * tag_pages_for_writeback - tag pages to be written by write_cache_pages
+ * @mapping: address space structure to write
+ * @start: starting page index
+ * @end: ending page index (inclusive)
+ *
+ * This function scans the page range from @start to @end and tags all pages
+ * that have DIRTY tag set with a special TOWRITE tag. The idea is that
+ * write_cache_pages (or whoever calls this function) will then use TOWRITE tag
+ * to identify pages eligible for writeback.  This mechanism is used to avoid
+ * livelocking of writeback by a process steadily creating new dirty pages in
+ * the file (thus it is important for this function to be damn quick so that it
+ * can tag pages faster than a dirtying process can create them).
+ */
+void tag_pages_for_writeback(struct address_space *mapping,
+			     pgoff_t start, pgoff_t end)
+{
+	spin_lock_irq(&mapping->tree_lock);
+	radix_tree_gang_tag_if_tagged(&mapping->page_tree, start, end,
+				PAGECACHE_TAG_DIRTY, PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&mapping->tree_lock);
+}
+EXPORT_SYMBOL(tag_pages_for_writeback);
+
+/**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
@@ -816,6 +840,13 @@ void __init page_writeback_init(void)
  * the call was made get new I/O started against them.  If wbc->sync_mode is
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
+ *
+ * To avoid livelocks (when other process dirties new pages), we first tag
+ * pages which should be written back with TOWRITE tag and only then start
+ * writing them. For data-integrity sync we have to be careful so that we do
+ * not miss some pages (e.g., because some other process has cleared TOWRITE
+ * tag we set). The rule we follow is that TOWRITE tag can be cleared only
+ * by the process clearing the DIRTY tag (and submitting the page for IO).
  */
 int write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
@@ -850,12 +881,13 @@ int write_cache_pages(struct address_space *mapping,
 		cycled = 1; /* ignore range_cyclic tests */
 	}
 retry:
+	tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
 		int i;
 
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			      PAGECACHE_TAG_DIRTY,
+			      PAGECACHE_TAG_TOWRITE,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0)
 			break;
@@ -1315,6 +1347,9 @@ int test_set_page_writeback(struct page *page)
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_DIRTY);
+		radix_tree_tag_clear(&mapping->page_tree,
+				     page_index(page),
+				     PAGECACHE_TAG_TOWRITE);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestSetPageWriteback(page);
-- 
1.6.4.2

