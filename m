Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZJZSNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZJZSNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZJZSNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:13:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZJZSNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:13:11 -0400
Date: Mon, 26 Oct 2009 19:13:14 +0100
From: Jan Kara <jack@suse.cz>
To: WU Fengguang <wfg@mail.ustc.edu.cn>
Cc: npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hch@infradead.org, chris.mason@oracle.com
Subject: [RFC] [PATCH] Avoid livelock for fsync
Message-ID: <20091026181314.GE7233@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  on my way back from Kernel Summit, I've coded the attached patch which
implements livelock avoidance for write_cache_pages. We tag patches that
should be written in the beginning of write_cache_pages and then write
only tagged pages (see the patch for details). The patch is based on Nick's
idea.
  The next thing I've aimed at with this patch is a simplification of
current writeback code. Basically, with this patch I think we can just rip
out all the range_cyclic and nr_to_write (or other "fairness logic"). The
rationalle is following:
  What we want to achieve with fairness logic is that when a page is
dirtied, it gets written to disk within some reasonable time (like 30s or
so). We track dirty time on per-inode basis only because keeping it
per-page is simply too expensive. So in this setting fairness between
inodes really does not make any sence - why should be a page in a file
penalized and written later only because there are lots of other dirty
pages in the file? It is enough to make sure that we don't write one file
indefinitely when there are new dirty pages continuously created - and my
patch achieves that.
  So with my patch we can make write_cache_pages always write from
range_start (or 0) to range_end (or EOF) and write all tagged pages. Also
after changing balance_dirty_pages() so that a throttled process does not
directly submit the IO (Fengguang has the patches for this), we can
completely remove the nr_to_write logic because nothing really uses it
anymore. Thus also the requeue_io logic should go away etc...
  Fengguang, do you have the series somewhere publicly available? You had
there a plenty of changes and quite some of them are not needed when the
above is done. So could you maybe separate out the balance_dirty_pages
change and I'd base my patch and further simplifications on top of that?
Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--UlVJffcvxoiEqYs2
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-Implement-writeback-livelock-avoidance-using-pag.patch"

>From cf9ee78989c8db475cc41180eac3dbf74b35980b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Sat, 24 Oct 2009 09:17:52 +0200
Subject: [PATCH] mm: Implement writeback livelock avoidance using page tagging

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
 mm/page-writeback.c        |   70 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..6959d65 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -679,6 +679,7 @@ struct block_device {
  */
 #define PAGECACHE_TAG_DIRTY	0
 #define PAGECACHE_TAG_WRITEBACK	1
+#define PAGECACHE_TAG_TOWRITE	2
 
 int mapping_tagged(struct address_space *mapping, int tag);
 
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index c5da749..a7bc41b 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -55,7 +55,7 @@ static inline int radix_tree_is_indirect_ptr(void *ptr)
 
 /*** radix-tree API starts here ***/
 
-#define RADIX_TREE_MAX_TAGS 2
+#define RADIX_TREE_MAX_TAGS 3
 
 /* root tags are stored in gfp_mask, shifted by __GFP_BITS_SHIFT */
 struct radix_tree_root {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2c5d792..a19fd5a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -803,6 +803,51 @@ void __init page_writeback_init(void)
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
+	struct pagevec pvec;
+	int nr_pages, i;
+	struct page *page;
+
+	pagevec_init(&pvec, 0);
+	while (start <= end) {
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &start,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - start, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (!nr_pages)
+			return;
+
+		spin_lock_irq(&mapping->tree_lock);
+		for (i = 0; i < nr_pages; i++) {
+			page = pvec.pages[i];
+			/* Raced with someone freeing the page? */
+			if (page->mapping != mapping)
+				continue;
+			if (page->index > end)
+				break;
+			radix_tree_tag_set(&mapping->page_tree,
+				page_index(page), PAGECACHE_TAG_TOWRITE);
+		}
+		spin_unlock_irq(&mapping->tree_lock);
+	}
+}
+EXPORT_SYMBOL(tag_pages_for_writeback);
+
+/**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
@@ -816,6 +861,13 @@ void __init page_writeback_init(void)
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
@@ -856,12 +908,13 @@ int write_cache_pages(struct address_space *mapping,
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
@@ -984,6 +1037,18 @@ continue_unlock:
 		wbc->nr_to_write = nr_to_write;
 	}
 
+	/* Debugging aid */
+	{
+	int i;
+	index = 0;
+	end = -1;
+	nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+		      PAGECACHE_TAG_TOWRITE,
+		      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+	for (i = 0; i < nr_pages; i++)
+		printk("Seeing tagged page %lu, state %lu\n", pvec.pages[i]->index, pvec.pages[i]->flags);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
@@ -1327,6 +1392,9 @@ int test_set_page_writeback(struct page *page)
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
1.6.0.2


--UlVJffcvxoiEqYs2--
