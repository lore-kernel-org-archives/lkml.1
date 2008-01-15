Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYAOXzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYAOXzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYAOXtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:49:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbYAOXsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:48:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/26] CacheFiles: Add a hook to write a single page of data
	to an inode
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:48:28 +0000
Message-ID: <20080115234828.22183.9122.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an address space operation to write one single page of data to an inode at
a page-aligned location (thus permitting the implementation to be highly
optimised).  The data source is a single page.

This is used by CacheFiles to store the contents of netfs pages into their
backing file pages.

Supply a generic implementation for this that uses the write_begin() and
write_end() address_space operations to bind a copy directly into the page
cache.

Hook the Ext2 and Ext3 operations to the generic implementation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext2/inode.c    |    2 ++
 fs/ext3/inode.c    |    3 +++
 include/linux/fs.h |    7 ++++++
 mm/filemap.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 0 deletions(-)


diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index b1ab32a..cfa56e6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -796,6 +796,7 @@ const struct address_space_operations ext2_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 const struct address_space_operations ext2_aops_xip = {
@@ -814,6 +815,7 @@ const struct address_space_operations ext2_nobh_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 /*
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index bc918d3..435c684 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1780,6 +1780,7 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.write_one_page	= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
@@ -1794,6 +1795,7 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.write_one_page	= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
@@ -1807,6 +1809,7 @@ static const struct address_space_operations ext3_journalled_aops = {
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
+	.write_one_page	= generic_file_buffered_write_one_page,
 };
 
 void ext3_set_aops(struct inode *inode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 850d3fc..a3c3369 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -479,6 +479,11 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	/* write the contents of the source page over the page at the specified
+	 * index in the target address space (the source page does not need to
+	 * be related to the target address space) */
+	int (*write_one_page)(struct address_space *, pgoff_t, struct page *);
+
 };
 
 /*
@@ -1801,6 +1806,8 @@ extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
 		unsigned long *, loff_t, loff_t *, size_t, size_t);
 extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
+extern int generic_file_buffered_write_one_page(struct address_space *,
+						pgoff_t, struct page *);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 extern void do_generic_mapping_read(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index a86569f..ed74864 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2333,6 +2333,67 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
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
+	struct page *page;
+	unsigned len;
+	loff_t isize, pos;
+	void *fsdata;
+	int ret;
+
+	pos = index;
+	pos <<= PAGE_CACHE_SHIFT;
+
+	len = PAGE_CACHE_SIZE;
+	isize = i_size_read(mapping->host);
+	if ((isize >> PAGE_CACHE_SHIFT) == index)
+		len = isize & (PAGE_CACHE_SIZE - 1);
+
+	ret = pagecache_write_begin(NULL, mapping, pos, len,
+				    AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+	if (ret < 0)
+		goto sync;
+
+	copy_highpage(page, source);
+
+	ret = pagecache_write_end(NULL, mapping, pos, len, len, page, fsdata);
+	if (ret < 0)
+		goto sync;
+
+	balance_dirty_pages_ratelimited(mapping);
+	cond_resched();
+
+sync:
+	/* the caller must handle O_SYNC themselves, but we handle S_SYNC and
+	 * MS_SYNCHRONOUS here */
+	if (unlikely(IS_SYNC(mapping->host)) && !a_ops->writepage)
+		ret = generic_osync_inode(mapping->host, mapping,
+					     OSYNC_METADATA | OSYNC_DATA);
+
+	/* the caller must handle O_DIRECT for themselves */
+
+	return ret;
+}
+EXPORT_SYMBOL(generic_file_buffered_write_one_page);
+
 static ssize_t
 __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t *ppos)

