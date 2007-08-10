Return-Path: <linux-kernel-owner+w=401wt.eu-S940816AbXHJQIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940816AbXHJQIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940194AbXHJQFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:05:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940177AbXHJQFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/16] CacheFiles: Add a hook to write a single page of data
	to an inode [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:05:27 +0100
Message-ID: <20070810160527.24698.16482.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an address space operation to write one single page of data to an inode at
a page-aligned location (thus permitting the implementation to be highly
optimised).

This is used by CacheFiles to store the contents of netfs pages into their
backing file pages.

Supply a generic implementation for this that uses the prepare_write() and
commit_write() address_space operations to bound a copy directly into the page
cache.

Hook the Ext2 and Ext3 operations to the generic implementation.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 fs/ext2/inode.c    |    2 +
 fs/ext3/inode.c    |    3 ++
 include/linux/fs.h |    7 ++++
 mm/filemap.c       |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 0079b2c..b3e4b50 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -695,6 +695,7 @@ const struct address_space_operations ext2_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 const struct address_space_operations ext2_aops_xip = {
@@ -713,6 +714,7 @@ const struct address_space_operations ext2_nobh_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 /*
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index de4e316..93809eb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1713,6 +1713,7 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.write_one_page	= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
@@ -1727,6 +1728,7 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.write_one_page	= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
@@ -1740,6 +1742,7 @@ static const struct address_space_operations ext3_journalled_aops = {
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
+	.write_one_page	= generic_file_buffered_write_one_page,
 };
 
 void ext3_set_aops(struct inode *inode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6bf1395..1b1f288 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -433,6 +433,11 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	/* write the contents of the source page over the page at the specified
+	 * index in the target address space (the source page does not need to
+	 * be related to the target address space) */
+	int (*write_one_page)(struct address_space *, pgoff_t, struct page *);
+
 };
 
 struct backing_dev_info;
@@ -1669,6 +1674,8 @@ extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
 		unsigned long *, loff_t, loff_t *, size_t, size_t);
 extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
+extern int generic_file_buffered_write_one_page(struct address_space *,
+						pgoff_t, struct page *);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 extern void do_generic_mapping_read(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 7b96487..5e419a2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2032,6 +2032,101 @@ zero_length_segment:
 }
 EXPORT_SYMBOL(generic_file_buffered_write);
 
+/**
+ * generic_file_buffered_write_one_page - Write a single page of data to an
+ *	inode
+ * @mapping - The address space of the target inode
+ * @index - The target page in the target inode to fill
+ * @source - The data to write into the target page
+ *
+ * Write the data from the source page to the page in the nominated address
+ * space at the @index specified.  Note that the file will not be extended if
+ * the page crosses the EOF marker, in which case only the first part of the
+ * page will be written.
+ *
+ * The @source page does not need to have any association with the file or the
+ * target page offset.
+ */
+int generic_file_buffered_write_one_page(struct address_space *mapping,
+					 pgoff_t index,
+					 struct page *source)
+{
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	struct pagevec	lru_pvec;
+	struct page *page, *cached_page = NULL;
+	unsigned psize;
+	loff_t isize;
+	long status = 0;
+
+	pagevec_init(&lru_pvec, 0);
+
+	page = __grab_cache_page(mapping, index, &cached_page, &lru_pvec);
+	if (!page) {
+		BUG_ON(cached_page);
+		return -ENOMEM;
+	}
+
+	psize = PAGE_CACHE_SIZE;
+	isize = i_size_read(mapping->host);
+	if ((isize >> PAGE_SHIFT) == index)
+		psize = isize & (PAGE_SIZE - 1);
+
+	status = a_ops->prepare_write(NULL, page, 0, psize);
+	if (unlikely(status)) {
+		isize = i_size_read(mapping->host);
+
+		if (status != AOP_TRUNCATED_PAGE)
+			unlock_page(page);
+		page_cache_release(page);
+		if (status == AOP_TRUNCATED_PAGE)
+			goto sync;
+
+		/* prepare_write() may have instantiated a few blocks outside
+		 * i_size.  Trim these off again.
+		 */
+		if ((1ULL << (index + 1)) > isize)
+			vmtruncate(mapping->host, isize);
+		goto sync;
+	}
+
+	copy_highpage(page, source);
+	flush_dcache_page(page);
+
+	status = a_ops->commit_write(NULL, page, 0, psize);
+	if (status == AOP_TRUNCATED_PAGE) {
+		page_cache_release(page);
+		goto sync;
+	}
+
+	if (status > 0)
+		status = 0;
+
+	unlock_page(page);
+	mark_page_accessed(page);
+	page_cache_release(page);
+	if (status < 0)
+		return status;
+
+	balance_dirty_pages_ratelimited(mapping);
+	cond_resched();
+
+sync:
+	if (cached_page)
+		page_cache_release(cached_page);
+
+	/* the caller must handle O_SYNC themselves, but we handle S_SYNC and
+	 * MS_SYNCHRONOUS here */
+	if (unlikely(IS_SYNC(mapping->host)) && !a_ops->writepage)
+		status = generic_osync_inode(mapping->host, mapping,
+					     OSYNC_METADATA | OSYNC_DATA);
+
+	/* the caller must handle O_DIRECT for themselves */
+
+	pagevec_lru_add(&lru_pvec);
+	return status;
+}
+EXPORT_SYMBOL(generic_file_buffered_write_one_page);
+
 static ssize_t
 __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t *ppos)

