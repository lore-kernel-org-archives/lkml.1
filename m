Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYE0Ik5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYE0Ik5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYE0Iku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:40:50 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48552 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbYE0Iks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:40:48 -0400
Message-Id: <6.0.0.20.2.20080527172732.05447770@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 27 May 2008 17:38:34 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] VFS: Pagecache usage optimization on
  pagesize!=blocksize environment
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080522010355.32590474.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
 <20080521001930.202446eb.akpm@linux-foundation.org>
 <6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
 <20080522010355.32590474.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

>> +int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
>> +					unsigned long from)
>> +{
>> +	struct inode *inode = page->mapping->host;
>> +	unsigned long block_start, block_end, blocksize;
>> +	unsigned long to;
>
>These functions can get quite confusing, and the appropriate use of
>types can help.
>
>For offsets within a page I'd suggest `unsigned'.  I expect that the
>32-bit quantities are more efficient on at least some 64-bit machines.
>
>For page indices use pgoff_t.
>
>For byte-offset-within-a-file use loff_t.
>
>For byte-range-within-a-file use size_t.
>
>Be careful about overflows and truncation when shifting, comparing,
>assigning, etc.  Be sure that the code is still correct outside the
>4Gbyte mark on 32-bit and outside the 4Gpage mark on 64-bit.
>
>It doesn't hurt at all to put each variable definition on its own line
>with a little comment off to the right.  It helps to mention what the
>variable's units are too - bytes/pages/sectors/etc.


>> +	head = page_buffers(page);
>> +
>> +	for (bh = head, block_start = 0; bh != head || !block_start;
>> +	     block_start = block_end, bh = bh->b_this_page) {
>> +		block_end = block_start + blocksize;
>> +		if (block_end <= from || block_start >= to)
>> +			continue;
>
>Oh dear, you've copied one of my least favourite parts of the VFS :(
>Just look at it!
>
>Do you think it can be simplified or clarified?


I cleaned up and simplified block_is_partially_uptodate.
Following patch is for linux-2.6.26-rc4.
Please review my patch.
Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.26-rc4.org/fs/buffer.c linux-2.6.26-rc4/fs/buffer.c
--- linux-2.6.26-rc4.org/fs/buffer.c	2008-05-27 14:36:21.000000000 +0900
+++ linux-2.6.26-rc4/fs/buffer.c	2008-05-27 14:38:20.000000000 +0900
@@ -2084,6 +2084,52 @@ int generic_write_end(struct file *file,
 EXPORT_SYMBOL(generic_write_end);
 
 /*
+ * block_is_partially_uptodate checks whether buffers within a page are
+ * uptodate or not.
+ *
+ * Returns true if all buffers which correspond to a file portion
+ * we want to read are uptodate.
+ */
+int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
+					unsigned long from)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned block_start, block_end, blocksize;
+	unsigned to;
+	struct buffer_head *bh, *head;
+	int ret = 1;
+
+	if (!page_has_buffers(page))
+		return 0;
+
+	blocksize = 1 << inode->i_blkbits;
+	to = min_t(unsigned, PAGE_CACHE_SIZE - from, desc->count);
+	to = from + to;
+	if (from < blocksize && to > PAGE_CACHE_SIZE - blocksize)
+		return 0;
+
+	head = page_buffers(page);
+	bh = head;
+	block_start = 0;
+	do {
+		block_end = block_start + blocksize;
+		if (block_end > from && block_start < to) {
+			if (!buffer_uptodate(bh)) {
+				ret = 0;
+				break;
+			}
+			if (block_end >= to)
+				break;
+		}
+		block_start = block_end;
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	return ret;
+}
+EXPORT_SYMBOL(block_is_partially_uptodate);
+
+/*
  * Generic "read page" function for block devices that have the normal
  * get_block functionality. This is most of the block device filesystems.
  * Reads the page asynchronously --- the unlock_buffer() and
diff -Nrup linux-2.6.26-rc4.org/fs/ext2/inode.c linux-2.6.26-rc4/fs/ext2/inode.c
--- linux-2.6.26-rc4.org/fs/ext2/inode.c	2008-05-27 14:36:21.000000000 +0900
+++ linux-2.6.26-rc4/fs/ext2/inode.c	2008-05-27 14:38:20.000000000 +0900
@@ -791,6 +791,7 @@ const struct address_space_operations ex
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate	= block_is_partially_uptodate,
 };
 
 const struct address_space_operations ext2_aops_xip = {
diff -Nrup linux-2.6.26-rc4.org/fs/ext3/inode.c linux-2.6.26-rc4/fs/ext3/inode.c
--- linux-2.6.26-rc4.org/fs/ext3/inode.c	2008-05-27 14:36:21.000000000 +0900
+++ linux-2.6.26-rc4/fs/ext3/inode.c	2008-05-27 14:38:20.000000000 +0900
@@ -1767,44 +1767,47 @@ static int ext3_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext3_ordered_aops = {
-	.readpage	= ext3_readpage,
-	.readpages	= ext3_readpages,
-	.writepage	= ext3_ordered_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext3_write_begin,
-	.write_end	= ext3_ordered_write_end,
-	.bmap		= ext3_bmap,
-	.invalidatepage	= ext3_invalidatepage,
-	.releasepage	= ext3_releasepage,
-	.direct_IO	= ext3_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_ordered_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_ordered_write_end,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.direct_IO		= ext3_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
-	.readpage	= ext3_readpage,
-	.readpages	= ext3_readpages,
-	.writepage	= ext3_writeback_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext3_write_begin,
-	.write_end	= ext3_writeback_write_end,
-	.bmap		= ext3_bmap,
-	.invalidatepage	= ext3_invalidatepage,
-	.releasepage	= ext3_releasepage,
-	.direct_IO	= ext3_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_writeback_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_writeback_write_end,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.direct_IO		= ext3_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
-	.readpage	= ext3_readpage,
-	.readpages	= ext3_readpages,
-	.writepage	= ext3_journalled_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext3_write_begin,
-	.write_end	= ext3_journalled_write_end,
-	.set_page_dirty	= ext3_journalled_set_page_dirty,
-	.bmap		= ext3_bmap,
-	.invalidatepage	= ext3_invalidatepage,
-	.releasepage	= ext3_releasepage,
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_journalled_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_journalled_write_end,
+	.set_page_dirty		= ext3_journalled_set_page_dirty,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 void ext3_set_aops(struct inode *inode)
diff -Nrup linux-2.6.26-rc4.org/fs/ext4/inode.c linux-2.6.26-rc4/fs/ext4/inode.c
--- linux-2.6.26-rc4.org/fs/ext4/inode.c	2008-05-27 14:36:21.000000000 +0900
+++ linux-2.6.26-rc4/fs/ext4/inode.c	2008-05-27 14:38:20.000000000 +0900
@@ -1817,44 +1817,47 @@ static int ext4_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext4_ordered_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_ordered_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_write_begin,
-	.write_end	= ext4_ordered_write_end,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_invalidatepage,
-	.releasepage	= ext4_releasepage,
-	.direct_IO	= ext4_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_ordered_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_write_begin,
+	.write_end		= ext4_ordered_write_end,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.direct_IO		= ext4_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext4_writeback_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_writeback_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_write_begin,
-	.write_end	= ext4_writeback_write_end,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_invalidatepage,
-	.releasepage	= ext4_releasepage,
-	.direct_IO	= ext4_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_writeback_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_write_begin,
+	.write_end		= ext4_writeback_write_end,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.direct_IO		= ext4_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_journalled_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_write_begin,
-	.write_end	= ext4_journalled_write_end,
-	.set_page_dirty	= ext4_journalled_set_page_dirty,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_invalidatepage,
-	.releasepage	= ext4_releasepage,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_journalled_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_write_begin,
+	.write_end		= ext4_journalled_write_end,
+	.set_page_dirty		= ext4_journalled_set_page_dirty,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 void ext4_set_aops(struct inode *inode)
diff -Nrup linux-2.6.26-rc4.org/include/linux/buffer_head.h linux-2.6.26-rc4/include/linux/buffer_head.h
--- linux-2.6.26-rc4.org/include/linux/buffer_head.h	2008-05-27 14:36:22.000000000 +0900
+++ linux-2.6.26-rc4/include/linux/buffer_head.h	2008-05-27 14:38:20.000000000 +0900
@@ -205,6 +205,8 @@ void block_invalidatepage(struct page *p
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
+int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
+				unsigned long from);
 int block_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);
diff -Nrup linux-2.6.26-rc4.org/include/linux/fs.h linux-2.6.26-rc4/include/linux/fs.h
--- linux-2.6.26-rc4.org/include/linux/fs.h	2008-05-27 14:36:22.000000000 +0900
+++ linux-2.6.26-rc4/include/linux/fs.h	2008-05-27 14:38:20.000000000 +0900
@@ -439,6 +439,27 @@ static inline size_t iov_iter_count(stru
 	return i->count;
 }
 
+/*
+ * "descriptor" for what we're up to with a read.
+ * This allows us to use the same read code yet
+ * have multiple different users of the data that
+ * we read from a file.
+ *
+ * The simplest case just copies the data to user
+ * mode.
+ */
+typedef struct {
+	size_t written;
+	size_t count;
+	union {
+		char __user *buf;
+		void *data;
+	} arg;
+	int error;
+} read_descriptor_t;
+
+typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
+		unsigned long, unsigned long);
 
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
@@ -480,6 +501,8 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
+					unsigned long);
 };
 
 /*
@@ -1186,27 +1209,6 @@ struct block_device_operations {
 	struct module *owner;
 };
 
-/*
- * "descriptor" for what we're up to with a read.
- * This allows us to use the same read code yet
- * have multiple different users of the data that
- * we read from a file.
- *
- * The simplest case just copies the data to user
- * mode.
- */
-typedef struct {
-	size_t written;
-	size_t count;
-	union {
-		char __user * buf;
-		void *data;
-	} arg;
-	int error;
-} read_descriptor_t;
-
-typedef int (*read_actor_t)(read_descriptor_t *, struct page *, unsigned long, unsigned long);
-
 /* These macros are for out of kernel modules to test that
  * the kernel supports the unlocked_ioctl and compat_ioctl
  * fields in struct file_operations. */
diff -Nrup linux-2.6.26-rc4.org/mm/filemap.c linux-2.6.26-rc4/mm/filemap.c
--- linux-2.6.26-rc4.org/mm/filemap.c	2008-05-27 14:36:23.000000000 +0900
+++ linux-2.6.26-rc4/mm/filemap.c	2008-05-27 14:38:20.000000000 +0900
@@ -932,8 +932,17 @@ find_page:
 					ra, filp, page,
 					index, last_index - index);
 		}
-		if (!PageUptodate(page))
-			goto page_not_up_to_date;
+		if (!PageUptodate(page)) {
+			if (inode->i_blkbits == PAGE_CACHE_SHIFT ||
+					!mapping->a_ops->is_partially_uptodate)
+				goto page_not_up_to_date;
+			if (TestSetPageLocked(page))
+				goto page_not_up_to_date;
+			if (!mapping->a_ops->is_partially_uptodate(page,
+								desc, offset))
+				goto page_not_up_to_date_locked;
+			unlock_page(page);
+		}
 page_ok:
 		/*
 		 * i_size must be checked after we know the page is Uptodate.
@@ -1003,6 +1012,7 @@ page_not_up_to_date:
 		if (lock_page_killable(page))
 			goto readpage_eio;
 
+page_not_up_to_date_locked:
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
 			unlock_page(page);

