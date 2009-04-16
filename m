Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZDPOcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZDPOcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZDPOcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:32:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:37312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZDPOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:32:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: npiggin@suse.de, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] vfs: Add better VFS support for page_mkwrite when blocksize < pagesize
Date: Thu, 16 Apr 2009 16:32:06 +0200
Message-Id: <1239892327-9636-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_mkwrite() is meant to be used by filesystems to allocate blocks under a
page which is becoming writeably mmapped in some process address space. This
allows a filesystem to return a page fault if there is not enough space
available, user exceeds quota or similar problem happens, rather than silently
discarding data later when writepage is called.

On filesystems where blocksize < pagesize the situation is more complicated.
Think for example that blocksize = 1024, pagesize = 4096 and a process does:
  ftruncate(fd, 0);
  pwrite(fd, buf, 1024, 0);
  map = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
  map[0] = 'a';  ----> page_mkwrite() for index 0 is called
  ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
  fsync(fd); ----> writepage() for index 0 is called

At the moment page_mkwrite() is called, filesystem can allocate only one block
for the page because i_size == 1024. Otherwise it would create blocks beyond
i_size which is generally undesirable. But later at writepage() time, we would
like to have blocks allocated for the whole page (and in principle we have to
allocate them because user could have filled the page with data after the
second ftruncate()). This patch introduces a framework which allows filesystems
to handle this with a reasonable effort.

The idea is following: Before we extend i_size, we obtain a special lock blocking
page_mkwrite() on the page straddling i_size. Then we writeprotect the page,
change i_size and unlock the special lock. This way, page_mkwrite() is called for
a page each time a number of blocks needed to be allocated for a page increases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 |  127 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    4 ++
 include/linux/fs.h          |   11 +++-
 mm/filemap.c                |   10 +++-
 mm/memory.c                 |    2 +-
 5 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 13edf7a..0e52530 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -40,6 +40,7 @@
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 #include <linux/mpage.h>
+#include <linux/rmap.h>
 #include <linux/bit_spinlock.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
@@ -1956,9 +1957,11 @@ int block_write_begin(struct file *file, struct address_space *mapping,
 	page = *pagep;
 	if (page == NULL) {
 		ownpage = 1;
+		block_lock_hole_extend(inode, pos);
 		page = grab_cache_page_write_begin(mapping, index, flags);
 		if (!page) {
 			status = -ENOMEM;
+			block_unlock_hole_extend(inode);
 			goto out;
 		}
 		*pagep = page;
@@ -1973,6 +1976,7 @@ int block_write_begin(struct file *file, struct address_space *mapping,
 			unlock_page(page);
 			page_cache_release(page);
 			*pagep = NULL;
+			block_unlock_hole_extend(inode);
 
 			/*
 			 * prepare_write() may have instantiated a few blocks
@@ -2048,6 +2052,7 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 
 	unlock_page(page);
 	page_cache_release(page);
+	block_unlock_hole_extend(inode);
 
 	/*
 	 * Don't mark the inode dirty under page lock. First, it unnecessarily
@@ -2354,6 +2359,121 @@ int block_commit_write(struct page *page, unsigned from, unsigned to)
 }
 
 /*
+ * Lock inode with I_HOLE_EXTEND if the write is going to create a hole
+ * under a mmapped page. Also mark the page RO so that page_mkwrite()
+ * is called on the nearest write access to the page.
+ *
+ * @pos is offset to which write/truncate is happenning.
+ *
+ * Returns 1 if the lock has been acquired.
+ */
+int block_lock_hole_extend(struct inode *inode, loff_t pos)
+{
+	int bsize = 1 << inode->i_blkbits;
+	loff_t rounded_i_size;
+	struct page *page;
+	pgoff_t index;
+
+	WARN_ON(!mutex_is_locked(&inode->i_mutex));
+	/* Optimize for common case */
+	if (PAGE_CACHE_SIZE == bsize)
+		return 0;
+	/* Currently last page will not have any hole block created? */
+	rounded_i_size = (inode->i_size + bsize - 1) & ~bsize;
+	pos = pos & ~bsize;
+	if (pos <= rounded_i_size || !(rounded_i_size & (PAGE_CACHE_SIZE - 1)))
+		return 0;
+	printk("Protecting extend (%lu->%lu)\n", (unsigned long)inode->i_size, (unsigned long)pos);
+	spin_lock(&inode_lock);
+	/*
+	 * From now on, block_page_mkwrite() will block on the page straddling
+	 * i_size. Note that the page on which it blocks changes with the
+	 * change of i_size but that is fine since when new i_size is written
+	 * blocks for the hole will be allocated.
+	 */
+	inode->i_state |= I_HOLE_EXTEND;
+	spin_unlock(&inode_lock);
+
+	/*
+	 * Make sure page_mkwrite() is called on this page before
+	 * user is able to write any data beyond current i_size via
+	 * mmap.
+	 *
+	 * See clear_page_dirty_for_io() for details why set_page_dirty()
+	 * is needed.
+	 */
+	index = inode->i_size >> PAGE_CACHE_SHIFT;
+	page = find_lock_page(inode->i_mapping, index);
+	if (!page)
+		return 1;
+	if (page_mkclean(page))
+		set_page_dirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+	return 1;
+}
+EXPORT_SYMBOL(block_lock_hole_extend);
+
+/* New i_size creating hole has been written, unlock the inode */
+void block_unlock_hole_extend(struct inode *inode)
+{
+	/*
+	 * We want to clear the flag we could have set previously. Noone else
+	 * can change the flag so lockless read is reliable.
+	 */
+	if (inode->i_state & I_HOLE_EXTEND) {
+		spin_lock(&inode_lock);
+		inode->i_state &= ~I_HOLE_EXTEND;
+		spin_unlock(&inode_lock);
+		/* Prevent speculative execution through spin_unlock */
+		smp_mb();
+		wake_up_bit(&inode->i_state, __I_HOLE_EXTEND);
+	}
+}
+EXPORT_SYMBOL(block_unlock_hole_extend);
+
+void block_extend_i_size(struct inode *inode, loff_t pos, loff_t len)
+{
+	int locked;
+
+	locked = block_lock_hole_extend(inode, pos);
+	i_size_write(inode, pos + len);
+	if (locked)
+		block_unlock_hole_extend(inode);
+}
+EXPORT_SYMBOL(block_extend_i_size);
+
+int block_wait_on_hole_extend(struct inode *inode, loff_t pos)
+{
+	loff_t size;
+	int ret = 0;
+
+restart:
+	size = i_size_read(inode);
+	if (pos > size)
+		return -EINVAL;
+	if (pos + PAGE_CACHE_SIZE < size)
+		return ret;
+	/*
+	 * This page contains EOF; make sure we see i_state from the moment
+	 * after page table modification
+	 */
+	smp_rmb();
+	if (inode->i_state & I_HOLE_EXTEND) {
+		wait_queue_head_t *wqh;
+		DEFINE_WAIT_BIT(wqb, &inode->i_state, __I_HOLE_EXTEND);
+
+		printk("Waiting for extend to finish (%lu).\n", (unsigned long)pos);
+		wqh = bit_waitqueue(&inode->i_state, __I_HOLE_EXTEND);
+		__wait_on_bit(wqh, &wqb, inode_wait, TASK_UNINTERRUPTIBLE);
+		ret = 1;
+		goto restart;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(block_wait_on_hole_extend);
+
+/*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
  * be careful to check for EOF conditions here. We set the page up correctly
@@ -2378,6 +2498,13 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	loff_t size;
 	int ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 
+	block_wait_on_hole_extend(inode, page_offset(page));
+	/*
+	 * From this moment on a write creating a hole can happen
+	 * without us waiting for it. But because it writeprotects
+	 * the page, user cannot really write to the page until next
+	 * page_mkwrite() is called. And that one will wait.
+	 */
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73bb8..b466e4e 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -216,6 +216,10 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
+int block_lock_hole_extend(struct inode *inode, loff_t pos);
+void block_unlock_hole_extend(struct inode *inode);
+int block_wait_on_hole_extend(struct inode *inode, loff_t pos);
+void block_extend_i_size(struct inode *inode, loff_t pos, loff_t len);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 void block_sync_page(struct page *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 562d285..d5fd27f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -521,7 +521,7 @@ struct address_space_operations {
 	int (*write_end)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata);
-
+	void (*extend_i_size)(struct inode *, loff_t pos, loff_t len);
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
@@ -538,6 +538,8 @@ struct address_space_operations {
 					unsigned long);
 };
 
+void do_extend_i_size(struct inode *inode, loff_t pos, loff_t len);
+
 /*
  * pagecache_write_begin/pagecache_write_end must be used by general code
  * to write into the pagecache.
@@ -1534,7 +1536,8 @@ struct super_operations {
  * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
  * various stages of removing an inode.
  *
- * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
+ * Three bits are used for locking and completion notification, I_LOCK,
+ * I_HOLE_EXTEND and I_SYNC.
  *
  * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
  *			fdatasync().  i_atime is the usual cause.
@@ -1572,6 +1575,8 @@ struct super_operations {
  *			of inode dirty data.  Having a separate lock for this
  *			purpose reduces latency and prevents some filesystem-
  *			specific deadlocks.
+ * I_HOLE_EXTEND	A lock synchronizing extension of a file which creates
+ *			a hole under a mmapped page with page_mkwrite().
  *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
@@ -1588,6 +1593,8 @@ struct super_operations {
 #define I_LOCK			(1 << __I_LOCK)
 #define __I_SYNC		8
 #define I_SYNC			(1 << __I_SYNC)
+#define __I_HOLE_EXTEND		9
+#define I_HOLE_EXTEND		(1 << __I_HOLE_EXTEND)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 8bd4980..2ba1b6a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2078,6 +2078,14 @@ int pagecache_write_end(struct file *file, struct address_space *mapping,
 }
 EXPORT_SYMBOL(pagecache_write_end);
 
+void do_extend_i_size(struct inode *inode, loff_t pos, loff_t len)
+{
+	if (inode->i_mapping->a_ops->extend_i_size)
+		inode->i_mapping->a_ops->extend_i_size(inode, pos, len);
+	else
+		i_size_write(inode, pos + len);
+}
+
 ssize_t
 generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long *nr_segs, loff_t pos, loff_t *ppos,
@@ -2138,7 +2146,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	if (written > 0) {
 		loff_t end = pos + written;
 		if (end > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
-			i_size_write(inode,  end);
+			do_extend_i_size(inode, pos, written);
 			mark_inode_dirty(inode);
 		}
 		*ppos = end;
diff --git a/mm/memory.c b/mm/memory.c
index cf6873e..496cdf3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2344,7 +2344,7 @@ int vmtruncate(struct inode * inode, loff_t offset)
 			goto out_sig;
 		if (offset > inode->i_sb->s_maxbytes)
 			goto out_big;
-		i_size_write(inode, offset);
+		do_extend_i_size(inode, offset, 0);
 	} else {
 		struct address_space *mapping = inode->i_mapping;
 
-- 
1.6.0.2

