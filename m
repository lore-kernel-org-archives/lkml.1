Return-Path: <linux-kernel-owner+w=401wt.eu-S1765531AbYEUHTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765531AbYEUHTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYEUHTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:19:05 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34708 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbYEUHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:19:03 -0400
X-Greylist: delayed 1540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 03:19:03 EDT
Message-Id: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Wed, 21 May 2008 15:52:04 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] VFS: Pagecache usage optimization on pagesize !=
  blocksize environment
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

When we read some part of a file through pagecache, if there is a pagecache 
of corresponding index but this page is not uptodate, read IO is issued and
this page will be uptodate.
I think this is good for pagesize == blocksize environment but there is room
for improvement on pagesize != blocksize environment. Because in this case
a page can have multiple buffers and even if a page is not uptodate, some buffers 
can be uptodate. So I suggest that when all buffers which correspond to a part
of a file that we want to read are uptodate, use this pagecache and copy data
from this pagecache to user buffer even if a page is not uptodate. This can
reduce read IO and improve system throughput.

I did a performance test using the sysbench.

#sysbench --num-threads=4 --max-requests=120000 --test=fileio --file-num=1 --file-block-size=1K --file-total-size=100M --file-test-mode=rndrw --file-fsync-freq=0 --file-rw-ratio=0.5 run

The result was:

	-- 2.6.26-rc3
	Operations performed:  40002 Read, 79998 Write, 1 Other = 120001 Total
	Read 39.064Mb  Written 78.123Mb  Total transferred 117.19Mb  (375Kb/sec)
	  375.00 Requests/sec executed

	Test execution summary:
	    total time:                          320.0027s
	    total number of events:              120000
	    total time taken by event execution: 1231.5564
	    per-request statistics:
	         min:                            0.0000s
	         avg:                            0.0103s
	         max:                            2.7605s
	         approx.  95 percentile:         0.0381s


	-- 2.6.26-rc3-patched
	Operations performed:  40002 Read, 79998 Write, 1 Other = 120001 Total
	Read 39.064Mb  Written 78.123Mb  Total transferred 117.19Mb  (409.78Kb/sec)
	  409.78 Requests/sec executed

	Test execution summary:
	    total time:                          292.8406s
	    total number of events:              120000
	    total time taken by event execution: 1106.3995
	    per-request statistics:
	         min:                            0.0000s
	         avg:                            0.0092s
	         max:                            3.7366s
	         approx.  95 percentile:         0.0327s

 
	arch:i386 
	filesystem:ext3
	blocksize:1024 bytes
	Memory: 1GB

Random read/write throughput was somewhat improved with following patch.
Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.26-rc3.org/fs/buffer.c linux-2.6.26-rc3/fs/buffer.c
--- linux-2.6.26-rc3.org/fs/buffer.c	2008-05-19 11:35:10.000000000 +0900
+++ linux-2.6.26-rc3/fs/buffer.c	2008-05-19 14:29:25.000000000 +0900
@@ -2084,6 +2084,48 @@ int generic_write_end(struct file *file,
 EXPORT_SYMBOL(generic_write_end);
 
 /*
+ * check_buffers_uptodate checks whether buffers within a page are
+ * uptodate or not.
+ *
+ * Returns true if all buffers which correspond to a file portion
+ * we want to read are uptodate.
+ */
+int check_buffers_uptodate(unsigned long from,
+			read_descriptor_t *desc, struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned long block_start, block_end, blocksize;
+	unsigned long to;
+	struct buffer_head *bh, *head;
+	int ret = 1;
+
+	blocksize = 1 << inode->i_blkbits;
+	to = from + desc->count;
+	if (to > PAGE_CACHE_SIZE)
+		to = PAGE_CACHE_SIZE;
+	if (from < blocksize && to > PAGE_CACHE_SIZE - blocksize)
+		return 0;
+
+	head = page_buffers(page);
+
+	for (bh = head, block_start = 0; bh != head || !block_start;
+	     block_start = block_end, bh = bh->b_this_page) {
+		block_end = block_start + blocksize;
+		if (block_end <= from || block_start >= to)
+			continue;
+		else {
+			if (!buffer_uptodate(bh)) {
+				ret = 0;
+				break;
+			}
+			if (block_end >= to)
+				break;
+		}
+	}
+	return ret;
+}
+
+/*
  * Generic "read page" function for block devices that have the normal
  * get_block functionality. This is most of the block device filesystems.
  * Reads the page asynchronously --- the unlock_buffer() and
diff -Nrup linux-2.6.26-rc3.org/include/linux/buffer_head.h linux-2.6.26-rc3/include/linux/buffer_head.h
--- linux-2.6.26-rc3.org/include/linux/buffer_head.h	2008-05-19 11:35:11.000000000 +0900
+++ linux-2.6.26-rc3/include/linux/buffer_head.h	2008-05-19 12:13:46.000000000 +0900
@@ -205,6 +205,8 @@ void block_invalidatepage(struct page *p
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
+int check_buffers_uptodate(unsigned long from,
+			read_descriptor_t *desc, struct page *page);
 int block_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);
diff -Nrup linux-2.6.26-rc3.org/mm/filemap.c linux-2.6.26-rc3/mm/filemap.c
--- linux-2.6.26-rc3.org/mm/filemap.c	2008-05-19 11:35:11.000000000 +0900
+++ linux-2.6.26-rc3/mm/filemap.c	2008-05-19 14:29:23.000000000 +0900
@@ -932,8 +932,16 @@ find_page:
 					ra, filp, page,
 					index, last_index - index);
 		}
-		if (!PageUptodate(page))
-			goto page_not_up_to_date;
+		if (!PageUptodate(page)) {
+			if (inode->i_blkbits == PAGE_CACHE_SHIFT)
+				goto page_not_up_to_date;
+			if (TestSetPageLocked(page))
+				goto page_not_up_to_date;
+			if (!page_has_buffers(page) ||
+			      !check_buffers_uptodate(offset, desc, page))
+				goto page_not_up_to_date_locked;
+			unlock_page(page);
+		}
 page_ok:
 		/*
 		* i_size must be checked after we know the page is Uptodate.
@@ -1003,6 +1011,7 @@ page_not_up_to_date:
 		if (lock_page_killable(page))
 			goto readpage_eio;
 
+page_not_up_to_date_locked:
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
 			unlock_page(page);

