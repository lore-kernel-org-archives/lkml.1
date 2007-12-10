Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXLJItg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXLJItg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLJIt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:49:29 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:43056 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXLJIt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:49:28 -0500
X-Greylist: delayed 1543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2007 03:49:28 EST
Message-Id: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Mon, 10 Dec 2007 16:52:46 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] dio: falling through to buffered I/O when invalidation
  of a page fails
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Current dio has some problems:
1, In ext3 ordered, dio write can return with EIO because of the race 
between invalidation of
a page and jbd. jbd pins the bhs while committing journal so 
try_to_release_page fails when jbd
is committing the transaction.

Past discussion about this issue is as follows.
http://marc.info/?t=119343431200004&r=1&w=2
http://marc.info/?t=112656762800002&r=1&w=2

2, invalidate_inode_pages2_range() sets ret=-EIO when invalidate_complete_page2()
fails, but this ret is cleared if do_launder_page() succeed on a page of 
next index.
In this case, dio is carried out even if invalidate_complete_page2() fails 
on some pages.
This can cause inconsistency between memory and blocks on HDD because the page
cache still exists.

I solved problems above by introducing invalidate_inode_pages3_range() and 
falling
through to buffered I/O when invalidation of a page failed.
We can distinguish between failure of page invalidation and other errors
with the return value of invalidate_inode_pages3_range(). When invalidation 
of a page
fails, this function exits immediately so that inconsistency between memory and
HDD blocks can be avoided and the number of the cached page that should be
acquired again is smaller.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.24-rc4.org/include/linux/fs.h 
linux-2.6.24-rc4/include/linux/fs.h
--- linux-2.6.24-rc4.org/include/linux/fs.h	2007-12-06 12:05:30.000000000 +0900
+++ linux-2.6.24-rc4/include/linux/fs.h	2007-12-06 12:06:38.000000000 +0900
@@ -1670,6 +1670,8 @@ static inline void invalidate_remote_ino
  extern int invalidate_inode_pages2(struct address_space *mapping);
  extern int invalidate_inode_pages2_range(struct address_space *mapping,
  					 pgoff_t start, pgoff_t end);
+extern int invalidate_inode_pages3_range(struct address_space *mapping,
+					 pgoff_t start, pgoff_t end);
  extern int write_inode_now(struct inode *, int);
  extern int filemap_fdatawrite(struct address_space *);
  extern int filemap_flush(struct address_space *);
diff -Nrup linux-2.6.24-rc4.org/mm/filemap.c linux-2.6.24-rc4/mm/filemap.c
--- linux-2.6.24-rc4.org/mm/filemap.c	2007-12-06 12:05:31.000000000 +0900
+++ linux-2.6.24-rc4/mm/filemap.c	2007-12-06 12:06:38.000000000 +0900
@@ -2491,14 +2491,18 @@ generic_file_direct_IO(int rw, struct ki
  	/*
  	 * After a write we want buffered reads to be sure to go to disk to get
  	 * the new data.  We invalidate clean cached page from the region we're
-	 * about to write.  We do this *before* the write so that we can return
-	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	 * about to write.
+	 * If invalidation of any pages fails, we return 0 so that we can fall
+	 * through to buffered I/O.
  	 */
  	if (rw == WRITE && mapping->nrpages) {
-		retval = invalidate_inode_pages2_range(mapping,
+		retval = invalidate_inode_pages3_range(mapping,
  					offset >> PAGE_CACHE_SHIFT, end);
-		if (retval)
+		if (retval) {
+			if (retval > 0)
+				retval = 0;
  			goto out;
+		}
  	}

  	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
diff -Nrup linux-2.6.24-rc4.org/mm/truncate.c linux-2.6.24-rc4/mm/truncate.c
--- linux-2.6.24-rc4.org/mm/truncate.c	2007-12-06 12:05:31.000000000 +0900
+++ linux-2.6.24-rc4/mm/truncate.c	2007-12-07 12:14:13.000000000 +0900
@@ -452,6 +452,86 @@ int invalidate_inode_pages2_range(struct
  EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);

  /**
+ * invalidate_inode_pages3_range - remove range of pages from an address_space
+ * @mapping: the address_space
+ * @start: the page offset 'from' which to invalidate
+ * @end: the page offset 'to' which to invalidate (inclusive)
+ *
+ * Any pages which are found to be mapped into pagetables are unmapped prior to
+ * invalidation.
+ *
+ * When a page can not be invalidated, this function exits immediately.
+ *
+ * Returns 1 if any pages could not be invalidated.
+ */
+int invalidate_inode_pages3_range(struct address_space *mapping,
+				  pgoff_t start, pgoff_t end)
+{
+	struct pagevec pvec;
+	pgoff_t next;
+	int i;
+	int ret = 0;
+	int did_range_unmap = 0;
+	int wrapped = 0;
+
+	pagevec_init(&pvec, 0);
+	next = start;
+	while (next <= end && !ret && !wrapped &&
+		pagevec_lookup(&pvec, mapping, next,
+			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+			pgoff_t page_index;
+
+			lock_page(page);
+			if (page->mapping != mapping) {
+				unlock_page(page);
+				continue;
+			}
+			page_index = page->index;
+			next = page_index + 1;
+			if (next == 0)
+				wrapped = 1;
+			if (page_index > end) {
+				unlock_page(page);
+				break;
+			}
+			wait_on_page_writeback(page);
+			if (page_mapped(page)) {
+				if (!did_range_unmap) {
+					/*
+					 * Zap the rest of the file in one hit.
+					 */
+					unmap_mapping_range(mapping,
+					   (loff_t)page_index<<PAGE_CACHE_SHIFT,
+					   (loff_t)(end - page_index + 1)
+							<< PAGE_CACHE_SHIFT,
+					    0);
+					did_range_unmap = 1;
+				} else {
+					/*
+					 * Just zap this page
+					 */
+					unmap_mapping_range(mapping,
+					  (loff_t)page_index<<PAGE_CACHE_SHIFT,
+					  PAGE_CACHE_SIZE, 0);
+				}
+			}
+			BUG_ON(page_mapped(page));
+			ret = do_launder_page(mapping, page);
+			if (ret == 0 && !invalidate_complete_page2(mapping, page))
+				ret = 1;
+			unlock_page(page);
+		}
+		if (!ret)
+			pagevec_release(&pvec);
+		cond_resched();
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(invalidate_inode_pages3_range);
+
+/**
   * invalidate_inode_pages2 - remove all pages from an address_space
   * @mapping: the address_space
   * 

