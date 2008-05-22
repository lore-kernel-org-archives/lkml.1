Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbYEVHe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbYEVHe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933852AbYEVHeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:34:12 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49734 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694AbYEVHeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:34:09 -0400
Message-Id: <6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 22 May 2008 16:31:15 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize
  !=blocksize environment
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080521001930.202446eb.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
 <20080521001930.202446eb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comment.

At 16:19 08/05/21, Andrew Morton wrote:
>That's not a terribly good benchmark, IMO.  It's too complex.
>
>To work out the best-case for a change like this I'd suggest a
>microbenchmark which does something such as seeking all around a file
>doing single-byte reads.
>

I will try microbenchmark later.

>See, the code which you have here is assuming that if PagePrivate is
>set, then the thing which is at page.private is a ring of buffer_heads.
>
>But this code (do_generic_file_read) doesn't know that!  Take a look at
>afs, nfs, perhaps other filesystems, grep for set_page_private().
>
>Only the address_space implementation (ie: the filesystem) knows
>whether page.private holds buffer_heads and only the
>address_space_operations functions are allowed to call into library
>functions which treat page.private as a buffer_head ring.
>
>Now, your code _may_ not crash, because perhaps there is no filesystem
>which puts something else into page.private which also uses
>do_generic_file_read().  But it's still wrong.
>
>I guess a suitable fix might be to implement the above using a new
>address_space_operations callback:
>
>	if (PagePrivate(page) && aops->is_partially_uptodate) {
>		if (aops->is_partially_uptodate(page, desc, offset))
>			<OK, we can copy the data>
>
>then implement a generic_file_is_partially_uptodate() in fs/buffer.c
>and wire that up in the filesystems.

I modified my patch based on your comment.

I added is_partially_uptodate method to address_space_operations, and
I registered block_is_partially_uptodate in fs/buffer.c to ext2,ext3,ext4's aops.
Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.26-rc3.org/fs/buffer.c linux-2.6.26-rc3/fs/buffer.c
--- linux-2.6.26-rc3.org/fs/buffer.c	2008-05-19 11:35:10.000000000 +0900
+++ linux-2.6.26-rc3/fs/buffer.c	2008-05-22 13:23:29.000000000 +0900
@@ -2084,6 +2084,51 @@ int generic_write_end(struct file *file,
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
+	unsigned long block_start, block_end, blocksize;
+	unsigned long to;
+	struct buffer_head *bh, *head;
+	int ret = 1;
+
+	if (!page_has_buffers(page))
+		return 0;
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
diff -Nrup linux-2.6.26-rc3.org/fs/ext2/inode.c linux-2.6.26-rc3/fs/ext2/inode.c
--- linux-2.6.26-rc3.org/fs/ext2/inode.c	2008-05-19 11:35:10.000000000 +0900
+++ linux-2.6.26-rc3/fs/ext2/inode.c	2008-05-22 12:39:46.000000000 +0900
@@ -791,6 +791,7 @@ const struct address_space_operations ex
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate	= block_is_partially_uptodate,
 };
 
 const struct address_space_operations ext2_aops_xip = {
diff -Nrup linux-2.6.26-rc3.org/fs/ext3/inode.c linux-2.6.26-rc3/fs/ext3/inode.c
--- linux-2.6.26-rc3.org/fs/ext3/inode.c	2008-05-19 11:35:10.000000000 +0900
+++ linux-2.6.26-rc3/fs/ext3/inode.c	2008-05-22 13:10:40.000000000 +0900
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
diff -Nrup linux-2.6.26-rc3.org/fs/ext4/inode.c linux-2.6.26-rc3/fs/ext4/inode.c
--- linux-2.6.26-rc3.org/fs/ext4/inode.c	2008-05-19 11:35:10.000000000 +0900
+++ linux-2.6.26-rc3/fs/ext4/inode.c	2008-05-22 13:13:17.000000000 +0900
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
diff -Nrup linux-2.6.26-rc3.org/include/linux/buffer_head.h linux-2.6.26-rc3/include/linux/buffer_head.h
--- linux-2.6.26-rc3.org/include/linux/buffer_head.h	2008-05-19 11:35:11.000000000 +0900
+++ linux-2.6.26-rc3/include/linux/buffer_head.h	2008-05-22 11:22:26.000000000 +0900
@@ -205,6 +205,8 @@ void block_invalidatepage(struct page *p
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
+int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
+				unsigned long from);
 int block_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);
diff -Nrup linux-2.6.26-rc3.org/include/linux/fs.h linux-2.6.26-rc3/include/linux/fs.h
--- linux-2.6.26-rc3.org/include/linux/fs.h	2008-05-19 11:35:11.000000000 +0900
+++ linux-2.6.26-rc3/include/linux/fs.h	2008-05-22 15:13:39.000000000 +0900
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
diff -Nrup linux-2.6.26-rc3.org/mm/filemap.c linux-2.6.26-rc3/mm/filemap.c
--- linux-2.6.26-rc3.org/mm/filemap.c	2008-05-19 11:35:11.000000000 +0900
+++ linux-2.6.26-rc3/mm/filemap.c	2008-05-22 12:34:58.000000000 +0900
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

