Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXCNNig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXCNNig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXCNNif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:38:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:48174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbXCNNib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:38:31 -0400
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Message-Id: <20070314112540.13798.97719.sendpatchset@linux.site>
In-Reply-To: <20070314112529.13798.35417.sendpatchset@linux.site>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
Subject: [patch 2/5] fs: introduce new aops and infrastructure
Date: Wed, 14 Mar 2007 14:38:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce write_begin, write_end, and perform_write aops.

These are intended to replace prepare_write and commit_write with more
flexible alternatives that are also able to avoid the buffered write
deadlock problems efficiently (which prepare_write is unable to do).

 Documentation/filesystems/Locking |    9 +
 Documentation/filesystems/vfs.txt |   38 ++++++
 drivers/block/loop.c              |   69 ++++-------
 fs/buffer.c                       |  144 ++++++++++++++++++++----
 fs/libfs.c                        |   40 ++++++
 fs/namei.c                        |   47 ++-----
 fs/splice.c                       |  106 +----------------
 include/linux/buffer_head.h       |    7 +
 include/linux/fs.h                |   29 ++++
 include/linux/pagemap.h           |    2 
 mm/filemap.c                      |  228 ++++++++++++++++++++++++++++++++++----
 11 files changed, 494 insertions(+), 225 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -449,6 +449,17 @@ struct address_space_operations {
 	 */
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
 	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
+
+	int (*write_begin)(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, int intr,
+				struct page **pagep, void **fsdata);
+	int (*write_end)(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata);
+
+	int (*perform_write)(struct file *, struct address_space *,
+				struct iov_iter *, loff_t);
+
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
@@ -463,6 +474,18 @@ struct address_space_operations {
 	int (*launder_page) (struct page *);
 };
 
+/*
+ * pagecache_write_begin/pagecache_write_end must be used by general code
+ * to write into the pagecache.
+ */
+int pagecache_write_begin(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, int intr,
+				struct page **pagep, void **fsdata);
+
+int pagecache_write_end(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata);
+
 struct backing_dev_info;
 struct address_space {
 	struct inode		*host;		/* owner: inode, block_device */
@@ -1902,6 +1925,12 @@ extern int simple_prepare_write(struct f
 			unsigned offset, unsigned to);
 extern int simple_commit_write(struct file *file, struct page *page,
 				unsigned offset, unsigned to);
+extern int simple_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, int intr,
+			struct page **pagep, void **fsdata);
+extern int simple_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata);
 
 extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2049,6 +2049,88 @@ inline int generic_write_checks(struct f
 }
 EXPORT_SYMBOL(generic_write_checks);
 
+int pagecache_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, int intr,
+				struct page **pagep, void **fsdata)
+{
+	const struct address_space_operations *aops = mapping->a_ops;
+
+	if (aops->write_begin)
+		return aops->write_begin(file, mapping, pos, len, intr, pagep, fsdata);
+	else {
+		int ret;
+		pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+		struct inode *inode = mapping->host;
+		struct page *page;
+again:
+		page = __grab_cache_page(mapping, index);
+		*pagep = page;
+		if (!page)
+			return -ENOMEM;
+
+		if (intr && !PageUptodate(page)) {
+			/*
+			 * There is no way to resolve a short write situation
+			 * for a !Uptodate page (except by double copying in
+			 * the caller done by generic_perform_write_2copy).
+			 *
+			 * Instead, we have to bring it uptodate here.
+			 */
+			ret = aops->readpage(file, page);
+			page_cache_release(page);
+			if (ret) {
+				if (ret == AOP_TRUNCATED_PAGE)
+					goto again;
+				return ret;
+			}
+			goto again;
+		}
+
+		ret = aops->prepare_write(file, page, offset, offset+len);
+		if (ret) {
+			if (ret != AOP_TRUNCATED_PAGE)
+				unlock_page(page);
+			page_cache_release(page);
+			if (pos + len > inode->i_size)
+				vmtruncate(inode, inode->i_size);
+			if (ret == AOP_TRUNCATED_PAGE)
+				goto again;
+		}
+		return ret;
+	}
+}
+EXPORT_SYMBOL(pagecache_write_begin);
+
+int pagecache_write_end(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	const struct address_space_operations *aops = mapping->a_ops;
+	int ret;
+
+	if (aops->write_begin)
+		ret = aops->write_end(file, mapping, pos, len, copied, page, fsdata);
+	else {
+		int ret;
+		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+		struct inode *inode = mapping->host;
+
+		flush_dcache_page(page);
+		ret = aops->commit_write(file, page, offset, offset+len);
+		if (ret < 0) {
+			unlock_page(page);
+			page_cache_release(page);
+			if (pos + len > inode->i_size)
+				vmtruncate(inode, inode->i_size);
+		} else
+			ret = copied;
+	}
+
+	return copied;
+}
+EXPORT_SYMBOL(pagecache_write_end);
+
 ssize_t
 generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long *nr_segs, loff_t pos, loff_t *ppos,
@@ -2092,8 +2174,7 @@ EXPORT_SYMBOL(generic_file_direct_write)
  * Find or create a page at the given pagecache position. Return the locked
  * page. This function is specifically for buffered writes.
  */
-static struct page *__grab_cache_page(struct address_space *mapping,
-							pgoff_t index)
+struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index)
 {
 	int status;
 	struct page *page;
@@ -2115,19 +2196,14 @@ repeat:
 	return page;
 }
 
-ssize_t
-generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos, loff_t *ppos,
-		size_t count, ssize_t written)
+static ssize_t generic_perform_write_2copy(struct file *file,
+				struct iov_iter *i, loff_t pos)
 {
-	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct inode 	*inode = mapping->host;
-	long		status = 0;
-	struct iov_iter i;
-
-	iov_iter_init(&i, iov, nr_segs, count, written);
+	struct inode *inode = mapping->host;
+	long status = 0;
+	ssize_t written = 0;
 
 	do {
 		struct page *src_page;
@@ -2140,7 +2216,7 @@ generic_file_buffered_write(struct kiocb
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
-						iov_iter_count(&i));
+						iov_iter_count(i));
 
 		/*
 		 * a non-NULL src_page indicates that we're doing the
@@ -2158,7 +2234,7 @@ generic_file_buffered_write(struct kiocb
 		 * to check that the address is actually valid, when atomic
 		 * usercopies are used, below.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(&i))) {
+		if (unlikely(iov_iter_fault_in_readable(i))) {
 			status = -EFAULT;
 			break;
 		}
@@ -2189,7 +2265,7 @@ generic_file_buffered_write(struct kiocb
 			 * same reason as we can't take a page fault with a
 			 * page locked (as explained below).
 			 */
-			copied = iov_iter_copy_from_user(src_page, &i,
+			copied = iov_iter_copy_from_user(src_page, i,
 								offset, bytes);
 			if (unlikely(copied == 0)) {
 				status = -EFAULT;
@@ -2228,7 +2304,7 @@ generic_file_buffered_write(struct kiocb
 			 * really matter.
 			 */
 			pagefault_disable();
-			copied = iov_iter_copy_from_user_atomic(page, &i,
+			copied = iov_iter_copy_from_user_atomic(page, i,
 								offset, bytes);
 			pagefault_enable();
 		} else {
@@ -2254,9 +2330,9 @@ generic_file_buffered_write(struct kiocb
 		if (src_page)
 			page_cache_release(src_page);
 
-		iov_iter_advance(&i, copied);
-		written += copied;
+		iov_iter_advance(i, copied);
 		pos += copied;
+		written += copied;
 
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
@@ -2280,13 +2356,119 @@ fs_write_aop_error:
 			continue;
 		else
 			break;
-	} while (iov_iter_count(&i));
-	*ppos = pos;
+	} while (iov_iter_count(i));
+
+	return written ? written : status;
+}
+
+static ssize_t generic_perform_write(struct file *file,
+				struct iov_iter *i, loff_t pos)
+{
+	struct address_space *mapping = file->f_mapping;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	long status = 0;
+	ssize_t written = 0;
+
+	do {
+		struct page *page;
+		pgoff_t index;		/* Pagecache index for current page */
+		unsigned long offset;	/* Offset into pagecache page */
+		unsigned long bytes;	/* Bytes to write to page */
+		size_t copied;		/* Bytes copied from user */
+		void *fsdata;
+
+		offset = (pos & (PAGE_CACHE_SIZE - 1));
+		index = pos >> PAGE_CACHE_SHIFT;
+		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
+						iov_iter_count(i));
+
+again:
+
+		/*
+		 * Bring in the user page that we will copy from _first_.
+		 * Otherwise there's a nasty deadlock on copying from the
+		 * same page as we're writing to, without it being marked
+		 * up-to-date.
+		 *
+		 * Not only is this an optimisation, but it is also required
+		 * to check that the address is actually valid, when atomic
+		 * usercopies are used, below.
+		 */
+		if (unlikely(iov_iter_fault_in_readable(i))) {
+			status = -EFAULT;
+			break;
+		}
+
+		status = a_ops->write_begin(file, mapping, pos, bytes, 1,
+						&page, &fsdata);
+		if (unlikely(status))
+			break;
+
+		pagefault_disable();
+		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
+		pagefault_enable();
+		flush_dcache_page(page);
+
+		status = a_ops->write_end(file, mapping, pos, bytes, copied,
+						page, fsdata);
+		if (unlikely(status < 0))
+			break;
+		copied = status;
+
+		cond_resched();
+
+		if (unlikely(copied == 0)) {
+			/*
+			 * If we were unable to copy any data at all, we must
+			 * fall back to a single segment length write.
+			 *
+			 * If we didn't fallback here, we could livelock
+			 * because not all segments in the iov can be copied at
+			 * once without a pagefault.
+			 */
+			bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
+						iov_iter_single_seg_count(i));
+			goto again;
+		}
+		iov_iter_advance(i, copied);
+		pos += copied;
+		written += copied;
+
+		balance_dirty_pages_ratelimited(mapping);
+
+	} while (iov_iter_count(i));
+
+	return written ? written : status;
+}
+
+ssize_t
+generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos, loff_t *ppos,
+		size_t count, ssize_t written)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	struct inode 	*inode = mapping->host;
+	long		status = 0;
+	struct iov_iter i;
+
+	iov_iter_init(&i, iov, nr_segs, count, written);
+	if (a_ops->perform_write)
+		status = a_ops->perform_write(file, mapping, &i, pos);
+	else if (a_ops->write_begin)
+		status = generic_perform_write(file, &i, pos);
+	else
+		status = generic_perform_write_2copy(file, &i, pos);
 
-	/*
-	 * For now, when the user asks for O_SYNC, we'll actually give O_DSYNC
-	 */
 	if (likely(status >= 0)) {
+		written += status;
+		*ppos = pos + status;
+
+		/*
+		 * For now, when the user asks for O_SYNC, we'll actually give
+		 * O_DSYNC
+		 */
 		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 			if (!a_ops->writepage || !is_sync_kiocb(iocb))
 				status = generic_osync_inode(inode, mapping,
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1846,36 +1846,50 @@ static int __block_prepare_write(struct 
 		} while ((bh = bh->b_this_page) != head);
 		return 0;
 	}
+
 	/* Error case: */
-	/*
-	 * Zero out any newly allocated blocks to avoid exposing stale
-	 * data.  If BH_New is set, we know that the block was newly
-	 * allocated in the above loop.
-	 */
-	bh = head;
+	page_zero_new_buffers(page, from, to);
+	return err;
+}
+
+void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
+{
+	unsigned int block_start, block_end;
+	struct buffer_head *head, *bh;
+
+	BUG_ON(!PageLocked(page));
+	if (!page_has_buffers(page))
+		return;
+
+	bh = head = page_buffers(page);
 	block_start = 0;
 	do {
-		block_end = block_start+blocksize;
-		if (block_end <= from)
-			goto next_bh;
-		if (block_start >= to)
-			break;
+		block_end = block_start + bh->b_size;
+
 		if (buffer_new(bh)) {
-			void *kaddr;
+			if (block_end > from && block_start < to) {
+				if (!PageUptodate(page)) {
+					unsigned start, end;
+					void *kaddr;
+
+					start = max(from, block_start);
+					end = min(to, block_end);
+
+					kaddr = kmap_atomic(page, KM_USER0);
+					memset(kaddr+start, 0, block_end-end);
+					flush_dcache_page(page);
+					kunmap_atomic(kaddr, KM_USER0);
+					set_buffer_uptodate(bh);
+				}
 
-			clear_buffer_new(bh);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr+block_start, 0, bh->b_size);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-			set_buffer_uptodate(bh);
-			mark_buffer_dirty(bh);
+				clear_buffer_new(bh);
+				mark_buffer_dirty(bh);
+			}
 		}
-next_bh:
+
 		block_start = block_end;
 		bh = bh->b_this_page;
 	} while (bh != head);
-	return err;
 }
 
 static int __block_commit_write(struct inode *inode, struct page *page,
@@ -1899,6 +1913,7 @@ static int __block_commit_write(struct i
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
+		clear_buffer_new(bh);
 	}
 
 	/*
@@ -1912,6 +1927,93 @@ static int __block_commit_write(struct i
 	return 0;
 }
 
+int block_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, int intr,
+			struct page **pagep, void **fsdata,
+			get_block_t *get_block)
+{
+	struct inode *inode = mapping->host;
+	int status = 0;
+	struct page *page;
+	pgoff_t index;
+	unsigned start, end;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + len;
+
+	page = *pagep;
+	if (page == NULL) {
+		page = __grab_cache_page(mapping, index);
+		if (!page) {
+			status = -ENOMEM;
+			goto out;
+		}
+		*pagep = page;
+	}
+
+	status = __block_prepare_write(inode, page, start, end, get_block);
+	if (unlikely(status)) {
+		ClearPageUptodate(page);
+
+		unlock_page(page);
+		page_cache_release(page);
+
+		/*
+		 * prepare_write() may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
+		goto out;
+	}
+
+out:
+	return status;
+}
+
+int block_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	unsigned start;
+
+	start = pos & (PAGE_CACHE_SIZE - 1);
+
+	if (unlikely(copied < len))
+		page_zero_new_buffers(page, start+copied, start+len);
+	flush_dcache_page(page);
+
+	/* This could be a short (even 0-length) commit */
+	__block_commit_write(inode, page, start, start+copied);
+
+	/*
+	 * The buffers that were written will now be uptodate, so we don't
+	 * have to worry about a readpage reading them again.
+	 * XXX: however I'm not sure about partial writes to buffers. Must
+	 * recheck that, and hopefully we can remove the below test.
+	 */
+	if (!PageUptodate(page))
+		copied = 0;
+
+	unlock_page(page);
+	mark_page_accessed(page); /* XXX: put this in caller? */
+	page_cache_release(page);
+
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold i_mutex.
+	 */
+	if (pos+copied > inode->i_size) {
+		i_size_write(inode, pos+copied);
+		mark_inode_dirty(inode);
+	}
+
+	return copied;
+}
+
 /*
  * Generic "read page" function for block devices that have the normal
  * get_block functionality. This is most of the block device filesystems.
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h
+++ linux-2.6/include/linux/buffer_head.h
@@ -202,6 +202,13 @@ void block_invalidatepage(struct page *p
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
+int block_write_begin(struct file *, struct address_space *,
+				loff_t, unsigned, int,
+				struct page **, void **, get_block_t*);
+int block_write_end(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page *, void *);
+void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
 int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
 int cont_prepare_write(struct page*, unsigned, unsigned, get_block_t*,
 				loff_t *);
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -85,6 +85,8 @@ unsigned find_get_pages_contig(struct ad
 unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 			int tag, unsigned int nr_pages, struct page **pages);
 
+struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index);
+
 /*
  * Returns locked page at given index in given cache, creating it if needed.
  */
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -342,6 +342,24 @@ int simple_prepare_write(struct file *fi
 	return 0;
 }
 
+int simple_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, int intr,
+			struct page **pagep, void **fsdata)
+{
+	struct page *page;
+	pgoff_t index;
+	unsigned from;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+
+	return simple_prepare_write(file, page, from, from+len);
+}
+
 int simple_commit_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
@@ -360,6 +378,28 @@ int simple_commit_write(struct file *fil
 	return 0;
 }
 
+int simple_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+
+	/* zero the stale part of the page if we did a short copy */
+	if (copied < len) {
+		void *kaddr = kmap_atomic(page, KM_USER0);
+		memset(kaddr + from + copied, 0, len - copied);
+		flush_dcache_page(page);
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+
+	simple_commit_write(file, page, from, from+copied);
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	return copied;
+}
+
 int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
 {
 	struct inode *inode;
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c
+++ linux-2.6/drivers/block/loop.c
@@ -206,11 +206,10 @@ lo_do_transfer(struct loop_device *lo, i
  * space operations prepare_write and commit_write.
  */
 static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
-		int bsize, loff_t pos, struct page *page)
+		int bsize, loff_t pos, struct page *unused)
 {
 	struct file *file = lo->lo_backing_file; /* kudos to NFsckingS */
 	struct address_space *mapping = file->f_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
 	pgoff_t index;
 	unsigned offset, bv_offs;
 	int len, ret;
@@ -222,67 +221,47 @@ static int do_lo_send_aops(struct loop_d
 	len = bvec->bv_len;
 	while (len > 0) {
 		sector_t IV;
-		unsigned size;
+		unsigned size, copied;
 		int transfer_result;
+		struct page *page;
+		void *fsdata;
 
 		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
 		size = PAGE_CACHE_SIZE - offset;
 		if (size > len)
 			size = len;
-		page = grab_cache_page(mapping, index);
-		if (unlikely(!page))
+
+		ret = pagecache_write_begin(file, mapping, pos, size, 1,
+							&page, &fsdata);
+		if (ret)
 			goto fail;
-		ret = aops->prepare_write(file, page, offset,
-					  offset + size);
-		if (unlikely(ret)) {
-			if (ret == AOP_TRUNCATED_PAGE) {
-				page_cache_release(page);
-				continue;
-			}
-			goto unlock;
-		}
+
 		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
 				bvec->bv_page, bv_offs, size, IV);
-		if (unlikely(transfer_result)) {
-			char *kaddr;
+		copied = size;
+		if (unlikely(transfer_result))
+			copied = 0;
+
+		ret = pagecache_write_end(file, mapping, pos, size, copied,
+							page, fsdata);
+		if (ret < 0)
+			goto fail;
+		if (ret < copied)
+			copied = ret;
 
-			/*
-			 * The transfer failed, but we still write the data to
-			 * keep prepare/commit calls balanced.
-			 */
-			printk(KERN_ERR "loop: transfer error block %llu\n",
-			       (unsigned long long)index);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + offset, 0, size);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
-		flush_dcache_page(page);
-		ret = aops->commit_write(file, page, offset,
-					 offset + size);
-		if (unlikely(ret)) {
-			if (ret == AOP_TRUNCATED_PAGE) {
-				page_cache_release(page);
-				continue;
-			}
-			goto unlock;
-		}
 		if (unlikely(transfer_result))
-			goto unlock;
-		bv_offs += size;
-		len -= size;
+			goto fail;
+
+		bv_offs += copied;
+		len -= copied;
 		offset = 0;
 		index++;
-		pos += size;
-		unlock_page(page);
-		page_cache_release(page);
+		pos += copied;
 	}
 	ret = 0;
 out:
 	mutex_unlock(&mapping->host->i_mutex);
 	return ret;
-unlock:
-	unlock_page(page);
-	page_cache_release(page);
 fail:
 	ret = -1;
 	goto out;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2688,53 +2688,30 @@ int __page_symlink(struct inode *inode, 
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
+	void *fsdata;
 	int err;
 	char *kaddr;
 
 retry:
-	err = -ENOMEM;
-	page = find_or_create_page(mapping, 0, gfp_mask);
-	if (!page)
-		goto fail;
-	err = mapping->a_ops->prepare_write(NULL, page, 0, len-1);
-	if (err == AOP_TRUNCATED_PAGE) {
-		page_cache_release(page);
-		goto retry;
-	}
+	err = pagecache_write_begin(NULL, mapping, 0, PAGE_CACHE_SIZE, 0,
+							&page, &fsdata);
 	if (err)
-		goto fail_map;
+		goto fail;
+
 	kaddr = kmap_atomic(page, KM_USER0);
 	memcpy(kaddr, symname, len-1);
+	memset(kaddr+len-1, 0, PAGE_CACHE_SIZE-(len-1));
 	kunmap_atomic(kaddr, KM_USER0);
-	err = mapping->a_ops->commit_write(NULL, page, 0, len-1);
-	if (err == AOP_TRUNCATED_PAGE) {
-		page_cache_release(page);
-		goto retry;
-	}
-	if (err)
-		goto fail_map;
-	/*
-	 * Notice that we are _not_ going to block here - end of page is
-	 * unmapped, so this will only try to map the rest of page, see
-	 * that it is unmapped (typically even will not look into inode -
-	 * ->i_size will be enough for everything) and zero it out.
-	 * OTOH it's obviously correct and should make the page up-to-date.
-	 */
-	if (!PageUptodate(page)) {
-		err = mapping->a_ops->readpage(NULL, page);
-		if (err != AOP_TRUNCATED_PAGE)
-			wait_on_page_locked(page);
-	} else {
-		unlock_page(page);
-	}
-	page_cache_release(page);
+
+	err = pagecache_write_end(NULL, mapping, 0, PAGE_CACHE_SIZE, PAGE_CACHE_SIZE,
+							page, fsdata);
 	if (err < 0)
 		goto fail;
+	if (err < PAGE_CACHE_SIZE)
+		goto retry;
+
 	mark_inode_dirty(inode);
 	return 0;
-fail_map:
-	unlock_page(page);
-	page_cache_release(page);
 fail:
 	return err;
 }
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -559,7 +559,7 @@ static int pipe_to_file(struct pipe_inod
 	struct address_space *mapping = file->f_mapping;
 	unsigned int offset, this_len;
 	struct page *page;
-	pgoff_t index;
+	void *fsdata;
 	int ret;
 
 	/*
@@ -569,13 +569,13 @@ static int pipe_to_file(struct pipe_inod
 	if (unlikely(ret))
 		return ret;
 
-	index = sd->pos >> PAGE_CACHE_SHIFT;
 	offset = sd->pos & ~PAGE_CACHE_MASK;
 
 	this_len = sd->len;
 	if (this_len + offset > PAGE_CACHE_SIZE)
 		this_len = PAGE_CACHE_SIZE - offset;
 
+#if 0
 	/*
 	 * Reuse buf page, if SPLICE_F_MOVE is set and we are doing a full
 	 * page.
@@ -587,86 +587,11 @@ static int pipe_to_file(struct pipe_inod
 		 * locked on successful return.
 		 */
 		if (buf->ops->steal(pipe, buf))
-			goto find_page;
+#endif
 
-		page = buf->page;
-		if (add_to_page_cache(page, mapping, index, GFP_KERNEL)) {
-			unlock_page(page);
-			goto find_page;
-		}
-
-		page_cache_get(page);
-
-		if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-			lru_cache_add(page);
-	} else {
-find_page:
-		page = find_lock_page(mapping, index);
-		if (!page) {
-			ret = -ENOMEM;
-			page = page_cache_alloc_cold(mapping);
-			if (unlikely(!page))
-				goto out_ret;
-
-			/*
-			 * This will also lock the page
-			 */
-			ret = add_to_page_cache_lru(page, mapping, index,
-						    GFP_KERNEL);
-			if (unlikely(ret))
-				goto out;
-		}
-
-		/*
-		 * We get here with the page locked. If the page is also
-		 * uptodate, we don't need to do more. If it isn't, we
-		 * may need to bring it in if we are not going to overwrite
-		 * the full page.
-		 */
-		if (!PageUptodate(page)) {
-			if (this_len < PAGE_CACHE_SIZE) {
-				ret = mapping->a_ops->readpage(file, page);
-				if (unlikely(ret))
-					goto out;
-
-				lock_page(page);
-
-				if (!PageUptodate(page)) {
-					/*
-					 * Page got invalidated, repeat.
-					 */
-					if (!page->mapping) {
-						unlock_page(page);
-						page_cache_release(page);
-						goto find_page;
-					}
-					ret = -EIO;
-					goto out;
-				}
-			} else
-				SetPageUptodate(page);
-		}
-	}
-
-	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
-	if (unlikely(ret)) {
-		loff_t isize = i_size_read(mapping->host);
-
-		if (ret != AOP_TRUNCATED_PAGE)
-			unlock_page(page);
-		page_cache_release(page);
-		if (ret == AOP_TRUNCATED_PAGE)
-			goto find_page;
-
-		/*
-		 * prepare_write() may have instantiated a few blocks
-		 * outside i_size.  Trim these off again.
-		 */
-		if (sd->pos + this_len > isize)
-			vmtruncate(mapping->host, isize);
-
-		goto out_ret;
-	}
+	ret = pagecache_write_begin(file, mapping, sd->pos, sd->len, 0, &page, &fsdata);
+	if (unlikely(ret))
+		goto out;
 
 	if (buf->page != page) {
 		/*
@@ -676,28 +601,13 @@ find_page:
 		char *dst = kmap_atomic(page, KM_USER1);
 
 		memcpy(dst + offset, src + buf->offset, this_len);
-		flush_dcache_page(page);
 		kunmap_atomic(dst, KM_USER1);
 		buf->ops->unmap(pipe, buf, src);
 	}
 
-	ret = mapping->a_ops->commit_write(file, page, offset, offset+this_len);
-	if (!ret) {
-		/*
-		 * Return the number of bytes written and mark page as
-		 * accessed, we are now done!
-		 */
-		ret = this_len;
-		mark_page_accessed(page);
-		balance_dirty_pages_ratelimited(mapping);
-	} else if (ret == AOP_TRUNCATED_PAGE) {
-		page_cache_release(page);
-		goto find_page;
-	}
+	ret = pagecache_write_end(file, mapping, sd->pos, sd->len, sd->len, page, fsdata);
+
 out:
-	page_cache_release(page);
-	unlock_page(page);
-out_ret:
 	return ret;
 }
 
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking
+++ linux-2.6/Documentation/filesystems/Locking
@@ -176,15 +176,18 @@ prototypes:
 locking rules:
 	All except set_page_dirty may block
 
-			BKL	PageLocked(page)
+			BKL	PageLocked(page)	i_sem
 writepage:		no	yes, unlocks (see below)
 readpage:		no	yes, unlocks
 sync_page:		no	maybe
 writepages:		no
 set_page_dirty		no	no
 readpages:		no
-prepare_write:		no	yes
-commit_write:		no	yes
+prepare_write:		no	yes			yes
+commit_write:		no	yes			yes
+write_begin:		no	locks the page		yes
+write_end:		no	yes, unlocks		yes
+perform_write:		no	n/a			yes
 bmap:			yes
 invalidatepage:		no	yes
 releasepage:		no	yes
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt
+++ linux-2.6/Documentation/filesystems/vfs.txt
@@ -534,6 +534,14 @@ struct address_space_operations {
 			struct list_head *pages, unsigned nr_pages);
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
 	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
+	int (*write_begin)(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, int intr,
+				struct page **pagep, void **fsdata);
+	int (*write_end)(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata);
+	int (*perform_write)(struct file *, struct address_space *,
+				struct iov_iter *, loff_t);
 	sector_t (*bmap)(struct address_space *, sector_t);
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
@@ -629,6 +637,36 @@ struct address_space_operations {
         operations.  It should avoid returning an error if possible -
         errors should have been handled by prepare_write.
 
+  write_begin: This is intended as a replacement for prepare_write. Called
+        by the generic buffered write code to ask the filesystem to prepare
+        to write len bytes at the given offset in the file. intr is a boolean
+        that specifies whether or not the filesystem must be prepared to
+        handle a short write (ie. write_end called with less than len bytes
+        written).
+
+        The filesystem must return the locked pagecache page for the caller
+        to write into.
+
+        A void * may be returned in fsdata, which then gets passed into
+        write_end.
+
+        Returns < 0 on failure, in which case all cleanup must be done and
+        write_end not called. 0 on success, in which case write_end must
+        be called.
+
+  write_end: After a successful write_begin, and data copy, write_end must
+        be called. len is the original len passed to write_begin, and copied
+        is the amount that was able to be copied (they must be equal if
+        write_begin was called with intr == 0).
+
+        The filesystem must take care of unlocking the page and dropping its
+        refcount, and updating i_size.
+
+        Returns < 0 on failure, otherwise the number of bytes (<= 'copied')
+        that were able to be copied into the file.
+
+  perform_write:
+
   bmap: called by the VFS to map a logical block offset within object to
   	physical block number. This method is used by the FIBMAP
   	ioctl and for working with swap-files.  To be able to swap to
