Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYAITqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYAITqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAITqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:46:01 -0500
Received: from styx.suse.cz ([82.119.242.94]:36151 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751893AbYAITqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:46:00 -0500
Date: Wed, 9 Jan 2008 20:45:58 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH] Handle i_size > s_maxbytes correctly
Message-ID: <20080109194557.GC2215@duck.suse.cz>
References: <20071220175104.GA11911@duck.suse.cz> <20071222001206.9d34cc78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222001206.9d34cc78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Andrew,

On Sat 22-12-07 00:12:06, Andrew Morton wrote:
> On Thu, 20 Dec 2007 18:51:04 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > Although we don't allow writes over s_maxbytes, it can happen that a file's
> > size is larger than s_maxbytes. For example we can write the file from a
> > computer with a different architecture (which has larger s_maxbytes), boot
> > a kernel with a different set of config options (CONFIG_LBD...), or if two
> > nodes in a [Ocfs2, and likely Gfs2] cluster have mounted the same file
> > system and have different s_maxbytes.  Thus we have to make sure we don't
> > crash / corrupt data when seeing such file (page offset of the last page
> > needn't fit into pgoff_t). Firstly, we make read() and mmap() return error
> > when user tries to access the file above s_maxbytes, secondly we introduce
> > a function i_size_read_trunc() which returns min(i_size, s_maxbytes) and
> > use it when determining maximal page offset we are interested in.
> > 
> > ...
> >
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1623,7 +1623,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
> >  
> >  	BUG_ON(!PageLocked(page));
> >  
> > -	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
> > +	last_block = (i_size_read_trunc(inode) - 1) >> inode->i_blkbits;
> >  
> > ...
> >
> > +/* Truncate i_size at s_maxbytes so that pagecache doesn't have problems */
> > +static inline loff_t i_size_read_trunc(const struct inode *inode)
> > +{
> > +	loff_t i_size = i_size_read(inode);
> > +
> > +	if (unlikely(inode->i_sb->s_maxbytes < i_size))
> > +		return inode->i_sb->s_maxbytes;
> > +	return i_size;
> > +}
> > +
> 
> This patch takes the total text size of the affected nine files from 74167
> bytes up to 75066 on i386.  This is core, core kernel.  Ouch.
> 
> It's also pretty fragile.  We now have i_size_read()s and
> i_size_read_trunc()s sprinkled all over the place with no obvious rules to
> determine when we should use one versus the other.
> 
> uninlining i_size_read_trunc() is obviously the first thing to look at but
> the cost is still appreciable and boy the problem which is being fixed here
> is rare and obscure.
> 
> Can we look at alternatives please?  What about just failing the open
> attempt?
  So I've given some more time to this problem. The patch in the end of
this email is the result. Instead of introducing i_size_read_trunc()
function, it introduces two functions for conversion of an offset into
index / block number and these functions handle overflows. The impact on
the text size is a bit smaller now (600 bytes on i386 without LFS, 74 bytes
on x86_64), impact on run time should be smaller (we don't have to grab
s_maxbytes) and use of these functions should be more obvious as well
(whenever you convert an offset to a page index / block and the conversion
can overflow, you can use these auxiliary functions). I agree this is still
not ideal (given the rarity of the problem) so below I discuss another
possibility.
  Don't allow files with i_size > s_maxbytes in VFS at all. For local
filesystems we can just check this on open and everything is fine but with
remote filesystems such as OCFS2 (or even NFS) filesize can be changed on
the fly from a different machine. So to avoid problems we can either
introduce some locking to prevent changes of i_size from other machines
while we are in critical sections (awww, I really don't think this is
better) or truncate i_size to s_maxbytes when we update i_size from what
we've received via network / shared storage (but then we'd have to track
whether user truncated file to some size or whether fs truncated it just
for safety and apps could be confused too).
  Any suggestions for further improvement or other solutions welcome :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Although we don't allow writes over s_maxbytes, it can happen that a file's
size is larger than s_maxbytes. For example we can write the file from a
computer with a different architecture (which has larger s_maxbytes), boot a
kernel with a different set of config options (CONFIG_LBD...), or if two nodes
in a [Ocfs2, and likely Gfs2] cluster have mounted the same file system and
have different s_maxbytes.  Thus we have to make sure we don't crash / corrupt
data when seeing such file (page offset of the last page needn't fit into
pgoff_t, block offset into sector_t). Firstly, we make read() and mmap() return
error when user tries to access the file above s_maxbytes, secondly we
introduce functions offset_to_index_max() and offset_to_block_max() which
return maximum number fitting into pgoff_t or sector_t, respectively, in
case the number computed from i_size would overflow.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Mark Fasheh <mark.fasheh@oracle.com>

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..4323a6d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1623,7 +1623,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 
 	BUG_ON(!PageLocked(page));
 
-	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
+	last_block = offset_to_block_max(i_size_read(inode) - 1,
+			inode->i_blkbits);
 
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, blocksize,
@@ -2084,7 +2085,8 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 	head = page_buffers(page);
 
 	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
+	lblock = offset_to_block_max(i_size_read(inode)+blocksize-1,
+			inode->i_blkbits);
 	bh = head;
 	nr = 0;
 	i = 0;
@@ -2604,7 +2606,7 @@ int nobh_writepage(struct page *page, get_block_t *get_block,
 {
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
-	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	const pgoff_t end_index = offset_to_index_max(i_size);
 	unsigned offset;
 	int ret;
 
@@ -2804,7 +2806,7 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 {
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
-	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	const pgoff_t end_index = offset_to_index_max(i_size);
 	unsigned offset;
 
 	/* Is the page fully inside i_size? */
diff --git a/fs/mpage.c b/fs/mpage.c
index d54f8f8..4d1d12c 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -190,7 +190,8 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 
 	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
 	last_block = block_in_file + nr_pages * blocks_per_page;
-	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
+	last_block_in_file = offset_to_block_max(i_size_read(inode) +
+			blocksize - 1, blkbits);
 	if (last_block > last_block_in_file)
 		last_block = last_block_in_file;
 	page_block = 0;
@@ -526,7 +527,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 	 */
 	BUG_ON(!PageUptodate(page));
 	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
-	last_block = (i_size - 1) >> blkbits;
+	last_block = offset_to_block_max(i_size - 1, blkbits);
 	map_bh.b_page = page;
 	for (page_block = 0; page_block < blocks_per_page; ) {
 
@@ -557,7 +558,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 	first_unmapped = page_block;
 
 page_is_mapped:
-	end_index = i_size >> PAGE_CACHE_SHIFT;
+	end_index = offset_to_index_max(i_size);
 	if (page->index >= end_index) {
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
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
index b3ec4a4..826e718 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1394,6 +1394,17 @@ static inline void inode_dec_link_count(struct inode *inode)
 	mark_inode_dirty(inode);
 }
 
+/* Convert byte offset to block number, if number would overflow
+ * sector_t, return maximum value fitting there. */
+static inline sector_t offset_to_block_max(loff_t off, int shift)
+{
+	loff_t block = off >> shift;
+
+	if (unlikely(block != (sector_t)block))
+		return ~(sector_t)0;
+	return block;
+}
+
 extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
 static inline void file_accessed(struct file *file)
 {
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index db8a410..adfd195 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -148,6 +148,19 @@ static inline loff_t page_offset(struct page *page)
 	return ((loff_t)page->index) << PAGE_CACHE_SHIFT;
 }
 
+/*
+ * Return index of a page on given offset, if index would overflow pgoff_t,
+ * return the maximum number fitting there.
+ */
+static inline pgoff_t offset_to_index_max(loff_t off)
+{
+	loff_t index = off >> PAGE_CACHE_SHIFT;
+
+	if (unlikely(index != (pgoff_t)index))
+		return ~((pgoff_t)0);
+	return index;
+}
+
 static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 					unsigned long address)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 01e260f..e37be0c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -380,7 +380,7 @@ int filemap_fdatawait(struct address_space *mapping)
 		return 0;
 
 	return wait_on_page_writeback_range(mapping, 0,
-				(i_size - 1) >> PAGE_CACHE_SHIFT);
+				offset_to_index_max(i_size - 1));
 }
 EXPORT_SYMBOL(filemap_fdatawait);
 
@@ -925,7 +925,7 @@ page_ok:
 		 */
 
 		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		end_index = offset_to_index_max(isize - 1);
 		if (unlikely(!isize || index > end_index)) {
 			page_cache_release(page);
 			goto out;
@@ -1310,7 +1310,7 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int did_readaround = 0;
 	int ret = 0;
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = offset_to_index_max(i_size_read(inode) + PAGE_CACHE_SIZE - 1);
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
@@ -1385,7 +1385,7 @@ retry_find:
 		goto page_not_uptodate;
 
 	/* Must recheck i_size under page lock */
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = offset_to_index_max(i_size_read(inode) + PAGE_CACHE_SIZE - 1);
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
 		page_cache_release(page);
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 5fa3fbf..e264b37 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -68,7 +68,7 @@ do_xip_mapping_read(struct address_space *mapping,
 	if (!isize)
 		goto out;
 
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+	end_index = offset_to_index_max(isize - 1);
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
@@ -220,7 +220,7 @@ static int xip_file_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 
 	/* XXX: are VM_FAULT_ codes OK? */
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = offset_to_index_max(i_size_read(inode) + PAGE_CACHE_SIZE - 1);
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 15678aa..e28ca6e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -983,6 +983,13 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
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
index c9c50ca..67ccd91 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -136,7 +136,7 @@ __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	if (isize == 0)
 		goto out;
 
-	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+	end_index = offset_to_index_max(isize - 1);
 
 	/*
 	 * Preallocate as many pages as we will need.
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f071648..0951c7a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1082,7 +1082,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 	 */
 	probe_block = 0;
 	page_no = 0;
-	last_block = i_size_read(inode) >> blkbits;
+	last_block = offset_to_block_max(i_size_read(inode), blkbits);
 	while ((probe_block + blocks_per_page) <= last_block &&
 			page_no < sis->max) {
 		unsigned block_in_page;
@@ -1517,6 +1517,7 @@ asmlinkage long sys_swapon(const char __user * specialfile, int swap_flags)
 		goto bad_swap;
 	}
 
+	/* This can possibly overflow but we discover that later */
 	swapfilesize = i_size_read(inode) >> PAGE_SHIFT;
 
 	/*
