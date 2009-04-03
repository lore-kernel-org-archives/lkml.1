Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbZDCJme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbZDCJme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761855AbZDCJl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:41:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43349 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761620AbZDCJl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:41:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] CacheFiles: Revert the addition of write_one_page()
To: nickpiggin@yahoo.com.au, hch@infradead.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 10:41:43 +0100
Message-ID: <20090403094143.9510.80474.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
References: <20090403094138.9510.80681.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the addition of the write_one_page() address space op as CacheFiles now
uses the write() file op instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext2/inode.c    |    2 --
 fs/ext3/inode.c    |    3 ---
 include/linux/fs.h |    7 ------
 mm/filemap.c       |   61 ----------------------------------------------------
 4 files changed, 0 insertions(+), 73 deletions(-)


diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 2366895..b43b955 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -799,7 +799,6 @@ const struct address_space_operations ext2_aops = {
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate	= block_is_partially_uptodate,
-	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 const struct address_space_operations ext2_aops_xip = {
@@ -818,7 +817,6 @@ const struct address_space_operations ext2_nobh_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
-	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 /*
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 41e5d2d..716f964 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1812,7 +1812,6 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.direct_IO		= ext3_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
@@ -1828,7 +1827,6 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.direct_IO		= ext3_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
@@ -1843,7 +1841,6 @@ static const struct address_space_operations ext3_journalled_aops = {
 	.invalidatepage		= ext3_invalidatepage,
 	.releasepage		= ext3_releasepage,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 void ext3_set_aops(struct inode *inode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bf1f1e..a09e17c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -532,11 +532,6 @@ struct address_space_operations {
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
-
-	/* write the contents of the source page over the page at the specified
-	 * index in the target address space (the source page does not need to
-	 * be related to the target address space) */
-	int (*write_one_page)(struct address_space *, pgoff_t, struct page *);
 };
 
 /*
@@ -2138,8 +2133,6 @@ extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
 		unsigned long *, loff_t, loff_t *, size_t, size_t);
 extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
-extern int generic_file_buffered_write_one_page(struct address_space *,
-						pgoff_t, struct page *);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 extern int generic_segment_checks(const struct iovec *iov,
diff --git a/mm/filemap.c b/mm/filemap.c
index 15dda3c..a07d714 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2338,67 +2338,6 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 }
 EXPORT_SYMBOL(generic_file_buffered_write);
 
-/**
- * generic_file_buffered_write_one_page - Write a single page of data to an
- *	inode
- * @mapping - The address space of the target inode
- * @index - The target page in the target inode to fill
- * @source - The data to write into the target page
- *
- * Write the data from the source page to the page in the nominated address
- * space at the @index specified.  Note that the file will not be extended if
- * the page crosses the EOF marker, in which case only the first part of the
- * page will be written.
- *
- * The @source page does not need to have any association with the file or the
- * target page offset.
- */
-int generic_file_buffered_write_one_page(struct address_space *mapping,
-					 pgoff_t index,
-					 struct page *source)
-{
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct page *page;
-	unsigned len;
-	loff_t isize, pos;
-	void *fsdata;
-	int ret;
-
-	pos = index;
-	pos <<= PAGE_CACHE_SHIFT;
-
-	len = PAGE_CACHE_SIZE;
-	isize = i_size_read(mapping->host);
-	if ((isize >> PAGE_CACHE_SHIFT) == index)
-		len = isize & (PAGE_CACHE_SIZE - 1);
-
-	ret = pagecache_write_begin(NULL, mapping, pos, len,
-				    AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
-	if (ret < 0)
-		goto sync;
-
-	copy_highpage(page, source);
-
-	ret = pagecache_write_end(NULL, mapping, pos, len, len, page, fsdata);
-	if (ret < 0)
-		goto sync;
-
-	balance_dirty_pages_ratelimited(mapping);
-	cond_resched();
-
-sync:
-	/* the caller must handle O_SYNC themselves, but we handle S_SYNC and
-	 * MS_SYNCHRONOUS here */
-	if (unlikely(IS_SYNC(mapping->host)) && !a_ops->writepage)
-		ret = generic_osync_inode(mapping->host, mapping,
-					     OSYNC_METADATA | OSYNC_DATA);
-
-	/* the caller must handle O_DIRECT for themselves */
-
-	return ret;
-}
-EXPORT_SYMBOL(generic_file_buffered_write_one_page);
-
 static ssize_t
 __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t *ppos)

