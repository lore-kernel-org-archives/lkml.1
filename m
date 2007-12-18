Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbXLRPZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbXLRPZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbXLRPZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:25:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:36256 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756195AbXLRPZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:25:07 -0500
Date: Tue, 18 Dec 2007 16:25:05 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: mark.fasheh@oracle.com
Subject: [PATCH] [RFC] Handle i_size > s_maxbytes gracefully
Message-ID: <20071218152504.GD31091@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  it can happen there are files larger than s_maxbytes on a fs. Attached
patch tries to make VFS/mm handle this gracefully. More details in the
changelog. Any comments / objections?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Although we don't allow writes over s_maxbytes, it can happen that a file's
size is larger than s_maxbytes. For example we can write the file from
a computer with a different architecture (which has larger s_maxbytes),
boot a kernel with a different set of config options (CONFIG_LBD...), etc.
Thus we have to make sure we don't crash / corrupt data when seeing such
file (page offset of the last page needn't fit into pgoff_t). Firstly, we
make read() and mmap() return error when user tries to access the file
above s_maxbytes, secondly we introduce a function i_size_read_trunc() which
returns min(i_size, s_maxbytes) and use it when determining maximal page
offset we are interested in.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..3861118 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1623,7 +1623,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 
 	BUG_ON(!PageLocked(page));
 
-	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
+	last_block = (i_size_read_trunc(inode) - 1) >> inode->i_blkbits;
 
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, blocksize,
@@ -2084,7 +2084,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 	head = page_buffers(page);
 
 	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
+	lblock = (i_size_read_trunc(inode)+blocksize-1) >> inode->i_blkbits;
 	bh = head;
 	nr = 0;
 	i = 0;
@@ -2347,7 +2347,7 @@ block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
 	int ret = -EINVAL;
 
 	lock_page(page);
-	size = i_size_read(inode);
+	size = i_size_read_trunc(inode);
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_offset(page) > size)) {
 		/* page got truncated out from underneath us */
@@ -2603,7 +2603,7 @@ int nobh_writepage(struct page *page, get_block_t *get_block,
 			struct writeback_control *wbc)
 {
 	struct inode * const inode = page->mapping->host;
-	loff_t i_size = i_size_read(inode);
+	loff_t i_size = i_size_read_trunc(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
 	int ret;
@@ -2803,7 +2803,7 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 			struct writeback_control *wbc)
 {
 	struct inode * const inode = page->mapping->host;
-	loff_t i_size = i_size_read(inode);
+	loff_t i_size = i_size_read_trunc(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index acf0da1..8223868 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -525,8 +525,8 @@ static int get_more_blocks(struct dio *dio)
 
 		create = dio->rw & WRITE;
 		if (dio->lock_type == DIO_LOCKING) {
-			if (dio->block_in_file < (i_size_read(dio->inode) >>
-							dio->blkbits))
+			if (dio->block_in_file < (i_size_read_trunc(dio->inode)
+							>> dio->blkbits))
 				create = 0;
 		} else if (dio->lock_type == DIO_NO_LOCKING) {
 			create = 0;
@@ -870,7 +870,8 @@ do_holes:
 				 * Be sure to account for a partial block as the
 				 * last block in the file
 				 */
-				i_size_aligned = ALIGN(i_size_read(dio->inode),
+				i_size_aligned =
+					ALIGN(i_size_read_trunc(dio->inode),
 							1 << blkbits);
 				if (dio->block_in_file >=
 						i_size_aligned >> blkbits) {
@@ -961,7 +962,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->next_block_for_io = -1;
 
 	dio->iocb = iocb;
-	dio->i_size = i_size_read(inode);
+	dio->i_size = i_size_read_trunc(inode);
 
 	spin_lock_init(&dio->bio_lock);
 	dio->refcount = 1;
diff --git a/fs/mpage.c b/fs/mpage.c
index d54f8f8..c666089 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -190,7 +190,8 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 
 	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
 	last_block = block_in_file + nr_pages * blocks_per_page;
-	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
+	last_block_in_file = (i_size_read_trunc(inode) + blocksize - 1) >>
+				blkbits;
 	if (last_block > last_block_in_file)
 		last_block = last_block_in_file;
 	page_block = 0;
@@ -468,7 +469,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 	struct block_device *boundary_bdev = NULL;
 	int length;
 	struct buffer_head map_bh;
-	loff_t i_size = i_size_read(inode);
+	loff_t i_size = i_size_read_trunc(inode);
 	int ret = 0;
 
 	if (page_has_buffers(page)) {
diff --git a/fs/read_write.c b/fs/read_write.c
index ea1f94c..ed91acc 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include <linux/mount.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -263,6 +264,11 @@ ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 		return -EINVAL;
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
 		return -EFAULT;
+	if (unlikely(*pos + count > file->f_vfsmnt->mnt_sb->s_maxbytes)) {
+		if (*pos >= file->f_vfsmnt->mnt_sb->s_maxbytes)
+			return -EOVERFLOW;
+		count = file->f_vfsmnt->mnt_sb->s_maxbytes - *pos;
+	}
 
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..d24ef6c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1394,6 +1394,16 @@ static inline void inode_dec_link_count(struct inode *inode)
 	mark_inode_dirty(inode);
 }
 
+/* Truncate i_size at s_maxbytes so that pagecache doesn't have problems */
+static inline loff_t i_size_read_trunc(const struct inode *inode)
+{
+	loff_t i_size = i_size_read(inode);
+
+	if (unlikely(inode->i_sb->s_maxbytes < i_size))
+		return inode->i_sb->s_maxbytes;
+	return i_size;
+}
+
 extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
 static inline void file_accessed(struct file *file)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 188cf5f..eb97b9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -362,7 +362,7 @@ EXPORT_SYMBOL(sync_page_range_nolock);
  */
 int filemap_fdatawait(struct address_space *mapping)
 {
-	loff_t i_size = i_size_read(mapping->host);
+	loff_t i_size = i_size_read_trunc(mapping->host);
 
 	if (i_size == 0)
 		return 0;
@@ -912,7 +912,7 @@ page_ok:
 		 * another truncate extends the file - this is desired though).
 		 */
 
-		isize = i_size_read(inode);
+		isize = i_size_read_trunc(inode);
 		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 		if (unlikely(!isize || index > end_index)) {
 			page_cache_release(page);
@@ -1298,7 +1298,8 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int did_readaround = 0;
 	int ret = 0;
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = (i_size_read_trunc(inode) + PAGE_CACHE_SIZE - 1) >>
+		PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
@@ -1373,7 +1374,7 @@ retry_find:
 		goto page_not_uptodate;
 
 	/* Must recheck i_size under page lock */
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = (i_size_read_trunc(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
 		page_cache_release(page);
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 32132f3..df26ef5 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -63,7 +63,7 @@ do_xip_mapping_read(struct address_space *mapping,
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
-	isize = i_size_read(inode);
+	isize = i_size_read_trunc(inode);
 	if (!isize)
 		goto out;
 
@@ -219,7 +219,7 @@ static int xip_file_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 
 	/* XXX: are VM_FAULT_ codes OK? */
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = (i_size_read_trunc(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index facc1a7..b2ee331 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -980,6 +980,13 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 			if (locks_verify_locked(inode))
 				return -EAGAIN;
 
+			/*
+			 * Make sure we don't map more than fs is able to handle
+			 */
+			if ((((loff_t)pgoff) << PAGE_SHIFT) + len >
+			    inode->i_sb->s_maxbytes)
+				return -EINVAL;
+
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
diff --git a/mm/readahead.c b/mm/readahead.c
index c9c50ca..8ec8d4a 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -131,7 +131,7 @@ __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	LIST_HEAD(page_pool);
 	int page_idx;
 	int ret = 0;
-	loff_t isize = i_size_read(inode);
+	loff_t isize = i_size_read_trunc(inode);
 
 	if (isize == 0)
 		goto out;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f071648..88d3bb1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1082,7 +1082,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 	 */
 	probe_block = 0;
 	page_no = 0;
-	last_block = i_size_read(inode) >> blkbits;
+	last_block = i_size_read_trunc(inode) >> blkbits;
 	while ((probe_block + blocks_per_page) <= last_block &&
 			page_no < sis->max) {
 		unsigned block_in_page;
@@ -1517,7 +1517,7 @@ asmlinkage long sys_swapon(const char __user * specialfile, int swap_flags)
 		goto bad_swap;
 	}
 
-	swapfilesize = i_size_read(inode) >> PAGE_SHIFT;
+	swapfilesize = i_size_read_trunc(inode) >> PAGE_SHIFT;
 
 	/*
 	 * Read the swap header.
