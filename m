Return-Path: <linux-kernel-owner+w=401wt.eu-S965464AbXCFSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965464AbXCFSIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXCFSGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:06:12 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:60822 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965447AbXCFSGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:06:04 -0500
Message-Id: <20070306180548.179598369@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 Mar 2007 19:04:44 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: [patch 1/8] fix race in clear_page_dirty_for_io()
Content-Disposition: inline; filename=split_set_page_dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix race in clear_page_dirty_for_io() as suggested by Linus.

Split the page dirtying into two phases:

  1) done for each dirtying attempt
  2) done only when the page's dirty flag changed from clean to dirty

For 1 a_ops->set_page_dirty() is used (couldn't find a better name).
For 2 a_ops->page_dirtied() is introduced.

__set_page_dirty_buffers() is renamed to block_set_page_dirty() and
only does phase 1 (buffer head dirtying).

__set_page_dirty_nobuffers() only did phase 2, make this into
generic_page_dirtied().  This doesn't set the dirty flag.

A new function __set_page_dirty() sets the dirty flag, and if page was
clean before, calls a_ops->page_dirtied.

set_page_dirty() calls a_ops->set_page_dirty() and then calls
__set_page_dirty().  The imlementation is slightly different, so that
mapping is not recalculated so many times.

clear_page_dirty_for_io can now be done race free, by first clearing
the page dirty flag, and if dirty page accounting is enabled,
write-prtotecting the ptes.  If some of the ptes were dirty/writable
it calls a_ops->set_page_dirty.

If a_ops->set_page_dirty is NULL, fall back to block_set_page_dirty().
If a_ops->page_dirtied is NULL, fall back to generic_page_dirtied().

Two new functions are introduced, both no-ops:

  simple_set_page_dirty()
  simple_page_dirtied()

These are for the cases, when either method doesn't need to do
anything.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/arch/x86_64/kernel/functionlist
===================================================================
--- linux.orig/arch/x86_64/kernel/functionlist	2007-03-06 15:28:19.000000000 +0100
+++ linux/arch/x86_64/kernel/functionlist	2007-03-06 15:28:26.000000000 +0100
@@ -78,7 +78,6 @@
 *(.text.free_pages_and_swap_cache)
 *(.text.generic_fillattr)
 *(.text.__block_prepare_write)
-*(.text.__set_page_dirty_nobuffers)
 *(.text.link_path_walk)
 *(.text.find_get_pages_tag)
 *(.text.ide_do_request)
Index: linux/drivers/block/rd.c
===================================================================
--- linux.orig/drivers/block/rd.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/drivers/block/rd.c	2007-03-06 15:28:26.000000000 +0100
@@ -178,23 +178,13 @@ static int ramdisk_writepages(struct add
 	return 0;
 }
 
-/*
- * ramdisk blockdev pages have their own ->set_page_dirty() because we don't
- * want them to contribute to dirty memory accounting.
- */
-static int ramdisk_set_page_dirty(struct page *page)
-{
-	if (!TestSetPageDirty(page))
-		return 1;
-	return 0;
-}
-
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= ramdisk_prepare_write,
 	.commit_write	= ramdisk_commit_write,
 	.writepage	= ramdisk_writepage,
-	.set_page_dirty	= ramdisk_set_page_dirty,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= simple_page_dirtied,
 	.writepages	= ramdisk_writepages,
 };
 
Index: linux/fs/afs/file.c
===================================================================
--- linux.orig/fs/afs/file.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/afs/file.c	2007-03-06 15:28:26.000000000 +0100
@@ -35,7 +35,8 @@ const struct inode_operations afs_file_i
 
 const struct address_space_operations afs_fs_aops = {
 	.readpage	= afs_file_readpage,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= generic_page_dirtied,
 	.releasepage	= afs_file_releasepage,
 	.invalidatepage	= afs_file_invalidatepage,
 };
Index: linux/fs/buffer.c
===================================================================
--- linux.orig/fs/buffer.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/buffer.c	2007-03-06 15:28:26.000000000 +0100
@@ -683,7 +683,7 @@ void mark_buffer_dirty_inode(struct buff
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
 /*
- * Add a page to the dirty page list.
+ * Set page's buffers dirty.
  *
  * It is a sad fact of life that this function is called from several places
  * deeply under spinlocking.  It may not sleep.
@@ -693,7 +693,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  * not have buffers then when they are later attached they will all be set
  * dirty.
  *
- * The buffers are dirtied before the page is dirtied.  There's a small race
+ * This function is called before the page is dirtied.  There's a small race
  * window in which a writepage caller may see the page cleanness but not the
  * buffer dirtiness.  That's fine.  If this code were to set the page dirty
  * before the buffers, a concurrent writepage caller could clear the page dirty
@@ -707,12 +707,12 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  * FIXME: may need to call ->reservepage here as well.  That's rather up to the
  * address_space though.
  */
-int __set_page_dirty_buffers(struct page *page)
+void block_set_page_dirty(struct page *page)
 {
-	struct address_space * const mapping = page_mapping(page);
+	struct address_space *mapping = page_mapping(page);
 
 	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
+		return;
 
 	spin_lock(&mapping->private_lock);
 	if (page_has_buffers(page)) {
@@ -725,24 +725,8 @@ int __set_page_dirty_buffers(struct page
 		} while (bh != head);
 	}
 	spin_unlock(&mapping->private_lock);
-
-	if (TestSetPageDirty(page))
-		return 0;
-
-	write_lock_irq(&mapping->tree_lock);
-	if (page->mapping) {	/* Race with truncate? */
-		if (mapping_cap_account_dirty(mapping)) {
-			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			task_io_account_write(PAGE_CACHE_SIZE);
-		}
-		radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-	}
-	write_unlock_irq(&mapping->tree_lock);
-	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-	return 1;
 }
-EXPORT_SYMBOL(__set_page_dirty_buffers);
+EXPORT_SYMBOL(block_set_page_dirty);
 
 /*
  * Write out and wait upon a list of buffers.
@@ -1144,7 +1128,7 @@ __getblk_slow(struct block_device *bdev,
 void fastcall mark_buffer_dirty(struct buffer_head *bh)
 {
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
-		__set_page_dirty_nobuffers(bh->b_page);
+		__set_page_dirty(bh->b_page);
 }
 
 /*
@@ -1497,7 +1481,7 @@ EXPORT_SYMBOL(block_invalidatepage);
 
 /*
  * We attach and possibly dirty the buffers atomically wrt
- * __set_page_dirty_buffers() via private_lock.  try_to_free_buffers
+ * block_set_page_dirty() via private_lock.  try_to_free_buffers
  * is already excluded via the page lock.
  */
 void create_empty_buffers(struct page *page,
@@ -1607,12 +1591,12 @@ static int __block_write_full_page(struc
 	}
 
 	/*
-	 * Be very careful.  We have no exclusion from __set_page_dirty_buffers
+	 * Be very careful.  We have no exclusion from block_set_page_dirty
 	 * here, and the (potentially unmapped) buffers may become dirty at
 	 * any time.  If a buffer becomes dirty here after we've inspected it
 	 * then we just miss that fact, and the page stays dirty.
 	 *
-	 * Buffers outside i_size may be dirtied by __set_page_dirty_buffers;
+	 * Buffers outside i_size may be dirtied by block_set_page_dirty;
 	 * handle that here by just cleaning them.
 	 */
 
@@ -2775,7 +2759,7 @@ int sync_dirty_buffer(struct buffer_head
  *
  * The same applies to regular filesystem pages: if all the buffers are
  * clean then we set the page clean and proceed.  To do that, we require
- * total exclusion from __set_page_dirty_buffers().  That is obtained with
+ * total exclusion from block_set_page_dirty().  That is obtained with
  * private_lock.
  *
  * try_to_free_buffers() is non-blocking.
@@ -2844,7 +2828,7 @@ int try_to_free_buffers(struct page *pag
 	 * the page also.
 	 *
 	 * private_lock must be held over this entire operation in order
-	 * to synchronise against __set_page_dirty_buffers and prevent the
+	 * to synchronise against block_set_page_dirty and prevent the
 	 * dirty bit from being lost.
 	 */
 	if (ret)
Index: linux/fs/cifs/file.c
===================================================================
--- linux.orig/fs/cifs/file.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/cifs/file.c	2007-03-06 15:28:26.000000000 +0100
@@ -2027,7 +2027,8 @@ const struct address_space_operations ci
 	.writepages = cifs_writepages,
 	.prepare_write = cifs_prepare_write,
 	.commit_write = cifs_commit_write,
-	.set_page_dirty = __set_page_dirty_nobuffers,
+	.set_page_dirty = simple_set_page_dirty,
+	.page_dirtied = generic_page_dirtied,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
@@ -2043,7 +2044,8 @@ const struct address_space_operations ci
 	.writepages = cifs_writepages,
 	.prepare_write = cifs_prepare_write,
 	.commit_write = cifs_commit_write,
-	.set_page_dirty = __set_page_dirty_nobuffers,
+	.set_page_dirty = simple_set_page_dirty,
+	.page_dirtied = generic_page_dirtied,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
Index: linux/fs/ext3/inode.c
===================================================================
--- linux.orig/fs/ext3/inode.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/ext3/inode.c	2007-03-06 15:28:26.000000000 +0100
@@ -1761,10 +1761,9 @@ out:
  * So what we do is to mark the page "pending dirty" and next time writepage
  * is called, propagate that into the buffers appropriately.
  */
-static int ext3_journalled_set_page_dirty(struct page *page)
+static void ext3_journalled_set_page_dirty(struct page *page)
 {
 	SetPageChecked(page);
-	return __set_page_dirty_nobuffers(page);
 }
 
 static const struct address_space_operations ext3_ordered_aops = {
@@ -1803,6 +1802,7 @@ static const struct address_space_operat
 	.prepare_write	= ext3_prepare_write,
 	.commit_write	= ext3_journalled_commit_write,
 	.set_page_dirty	= ext3_journalled_set_page_dirty,
+	.page_dirtied	= generic_page_dirtied,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
Index: linux/fs/ext4/inode.c
===================================================================
--- linux.orig/fs/ext4/inode.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/ext4/inode.c	2007-03-06 15:28:26.000000000 +0100
@@ -1760,10 +1760,9 @@ out:
  * So what we do is to mark the page "pending dirty" and next time writepage
  * is called, propagate that into the buffers appropriately.
  */
-static int ext4_journalled_set_page_dirty(struct page *page)
+static void ext4_journalled_set_page_dirty(struct page *page)
 {
 	SetPageChecked(page);
-	return __set_page_dirty_nobuffers(page);
 }
 
 static const struct address_space_operations ext4_ordered_aops = {
@@ -1802,6 +1801,7 @@ static const struct address_space_operat
 	.prepare_write	= ext4_prepare_write,
 	.commit_write	= ext4_journalled_commit_write,
 	.set_page_dirty	= ext4_journalled_set_page_dirty,
+	.page_dirtied	= generic_page_dirtied,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_invalidatepage,
 	.releasepage	= ext4_releasepage,
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/fuse/file.c	2007-03-06 15:28:26.000000000 +0100
@@ -625,11 +625,10 @@ static int fuse_file_mmap(struct file *f
 	return generic_file_mmap(file, vma);
 }
 
-static int fuse_set_page_dirty(struct page *page)
+static void fuse_page_dirtied(struct page *page)
 {
-	printk("fuse_set_page_dirty: should not happen\n");
+	printk("fuse_page_dirtied: should not happen\n");
 	dump_stack();
-	return 0;
 }
 
 static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
@@ -820,7 +819,8 @@ static const struct address_space_operat
 	.prepare_write	= fuse_prepare_write,
 	.commit_write	= fuse_commit_write,
 	.readpages	= fuse_readpages,
-	.set_page_dirty	= fuse_set_page_dirty,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= fuse_page_dirtied,
 	.bmap		= fuse_bmap,
 };
 
Index: linux/fs/hostfs/hostfs_kern.c
===================================================================
--- linux.orig/fs/hostfs/hostfs_kern.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/hostfs/hostfs_kern.c	2007-03-06 15:28:26.000000000 +0100
@@ -518,7 +518,8 @@ int hostfs_commit_write(struct file *fil
 static const struct address_space_operations hostfs_aops = {
 	.writepage 	= hostfs_writepage,
 	.readpage	= hostfs_readpage,
-	.set_page_dirty = __set_page_dirty_nobuffers,
+	.set_page_dirty = simple_set_page_dirty,
+	.page_dirtied	= generic_page_dirtied,
 	.prepare_write	= hostfs_prepare_write,
 	.commit_write	= hostfs_commit_write
 };
Index: linux/fs/hugetlbfs/inode.c
===================================================================
--- linux.orig/fs/hugetlbfs/inode.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/hugetlbfs/inode.c	2007-03-06 15:28:26.000000000 +0100
@@ -451,12 +451,11 @@ static int hugetlbfs_symlink(struct inod
 /*
  * mark the head page dirty
  */
-static int hugetlbfs_set_page_dirty(struct page *page)
+static void hugetlbfs_set_page_dirty(struct page *page)
 {
 	struct page *head = (struct page *)page_private(page);
 
 	SetPageDirty(head);
-	return 0;
 }
 
 static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -545,6 +544,7 @@ static const struct address_space_operat
 	.prepare_write	= hugetlbfs_prepare_write,
 	.commit_write	= hugetlbfs_commit_write,
 	.set_page_dirty	= hugetlbfs_set_page_dirty,
+	.page_dirtied	= simple_page_dirtied,
 };
 
 
Index: linux/fs/jfs/jfs_metapage.c
===================================================================
--- linux.orig/fs/jfs/jfs_metapage.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/jfs/jfs_metapage.c	2007-03-06 15:28:26.000000000 +0100
@@ -583,7 +583,8 @@ const struct address_space_operations jf
 	.sync_page	= block_sync_page,
 	.releasepage	= metapage_releasepage,
 	.invalidatepage	= metapage_invalidatepage,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= generic_page_dirtied,
 };
 
 struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
Index: linux/fs/libfs.c
===================================================================
--- linux.orig/fs/libfs.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/libfs.c	2007-03-06 15:28:26.000000000 +0100
@@ -357,6 +357,21 @@ int simple_commit_write(struct file *fil
 	return 0;
 }
 
+/*
+ * For address_spaces which do not use buffers
+ */
+void simple_set_page_dirty(struct page *page)
+{
+}
+
+/*
+ * For address spaces which don't need the dirty radix tree tag, and
+ * the inode dirtiness
+ */
+void simple_page_dirtied(struct page *page)
+{
+}
+
 int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
 {
 	static struct super_operations s_ops = {.statfs = simple_statfs};
@@ -615,6 +630,8 @@ EXPORT_SYMBOL(dcache_readdir);
 EXPORT_SYMBOL(generic_read_dir);
 EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_commit_write);
+EXPORT_SYMBOL(simple_set_page_dirty);
+EXPORT_SYMBOL(simple_page_dirtied);
 EXPORT_SYMBOL(simple_dir_inode_operations);
 EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
Index: linux/fs/mpage.c
===================================================================
--- linux.orig/fs/mpage.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/mpage.c	2007-03-06 15:28:26.000000000 +0100
@@ -490,7 +490,7 @@ __mpage_writepage(struct bio *bio, struc
 			if (!buffer_mapped(bh)) {
 				/*
 				 * unmapped dirty buffers are created by
-				 * __set_page_dirty_buffers -> mmapped data
+				 * block_set_page_dirty -> mmapped data
 				 */
 				if (buffer_dirty(bh))
 					goto confused;
Index: linux/fs/nfs/write.c
===================================================================
--- linux.orig/fs/nfs/write.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/nfs/write.c	2007-03-06 15:28:26.000000000 +0100
@@ -406,7 +406,7 @@ static void
 nfs_redirty_request(struct nfs_page *req)
 {
 	clear_bit(PG_FLUSHING, &req->wb_flags);
-	__set_page_dirty_nobuffers(req->wb_page);
+	__set_page_dirty(req->wb_page);
 }
 
 /*
@@ -716,7 +716,7 @@ int nfs_updatepage(struct file *file, st
 	}
 
 	status = nfs_writepage_setup(ctx, page, offset, count);
-	__set_page_dirty_nobuffers(page);
+	__set_page_dirty(page);
 
         dprintk("NFS:      nfs_updatepage returns %d (isize %Ld)\n",
 			status, (long long)i_size_read(inode));
@@ -1481,7 +1481,7 @@ int nfs_wb_page(struct inode *inode, str
 	return nfs_wb_page_priority(inode, page, FLUSH_STABLE);
 }
 
-int nfs_set_page_dirty(struct page *page)
+void nfs_set_page_dirty(struct page *page)
 {
 	struct nfs_page *req;
 
@@ -1491,7 +1491,6 @@ int nfs_set_page_dirty(struct page *page
 		set_bit(PG_NEED_FLUSH, &req->wb_flags);
 		nfs_release_request(req);
 	}
-	return __set_page_dirty_nobuffers(page);
 }
 
 
Index: linux/fs/ntfs/aops.c
===================================================================
--- linux.orig/fs/ntfs/aops.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/ntfs/aops.c	2007-03-06 15:28:26.000000000 +0100
@@ -613,12 +613,12 @@ static int ntfs_write_block(struct page 
 	iblock = initialized_size >> blocksize_bits;
 
 	/*
-	 * Be very careful.  We have no exclusion from __set_page_dirty_buffers
+	 * Be very careful.  We have no exclusion from block_set_page_dirty
 	 * here, and the (potentially unmapped) buffers may become dirty at
 	 * any time.  If a buffer becomes dirty here after we've inspected it
 	 * then we just miss that fact, and the page stays dirty.
 	 *
-	 * Buffers outside i_size may be dirtied by __set_page_dirty_buffers;
+	 * Buffers outside i_size may be dirtied by block_set_page_dirty;
 	 * handle that here by just cleaning them.
 	 */
 
@@ -673,7 +673,7 @@ static int ntfs_write_block(struct page 
 				// Update initialized size in the attribute and
 				// in the inode.
 				// Again, for each page do:
-				//	__set_page_dirty_buffers();
+				//	block_set_page_dirty();
 				// page_cache_release()
 				// We don't need to wait on the writes.
 				// Update iblock.
@@ -1570,9 +1570,10 @@ const struct address_space_operations nt
 						   disk request queue. */
 #ifdef NTFS_RW
 	.writepage	= ntfs_writepage,	/* Write dirty page to disk. */
-	.set_page_dirty	= __set_page_dirty_nobuffers,	/* Set the page dirty
+	.set_page_dirty	= simple_set_page_dirty,/* Set the page dirty
 						   without touching the buffers
 						   belonging to the page. */
+	.page_dirtied	= generic_page_dirtied,
 #endif /* NTFS_RW */
 	.migratepage	= buffer_migrate_page,	/* Move a page cache page from
 						   one physical page to an
@@ -1634,7 +1635,7 @@ void mark_ntfs_record_dirty(struct page 
 		set_buffer_dirty(bh);
 	} while ((bh = bh->b_this_page) != head);
 	spin_unlock(&mapping->private_lock);
-	__set_page_dirty_nobuffers(page);
+	__set_page_dirty(page);
 	if (unlikely(buffers_to_free)) {
 		do {
 			bh = buffers_to_free->b_this_page;
Index: linux/fs/ntfs/file.c
===================================================================
--- linux.orig/fs/ntfs/file.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/ntfs/file.c	2007-03-06 15:28:26.000000000 +0100
@@ -1786,7 +1786,7 @@ err_out:
 			 * Put the page on mapping->dirty_pages, but leave its
 			 * buffers' dirty state as-is.
 			 */
-			__set_page_dirty_nobuffers(page);
+			__set_page_dirty(page);
 			err = 0;
 		} else
 			ntfs_error(vi->i_sb, "Page is not uptodate.  Written "
Index: linux/fs/ramfs/file-mmu.c
===================================================================
--- linux.orig/fs/ramfs/file-mmu.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/ramfs/file-mmu.c	2007-03-06 15:28:26.000000000 +0100
@@ -31,7 +31,8 @@ const struct address_space_operations ra
 	.readpage	= simple_readpage,
 	.prepare_write	= simple_prepare_write,
 	.commit_write	= simple_commit_write,
-	.set_page_dirty = __set_page_dirty_no_writeback,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= simple_page_dirtied,
 };
 
 const struct file_operations ramfs_file_operations = {
Index: linux/fs/ramfs/file-nommu.c
===================================================================
--- linux.orig/fs/ramfs/file-nommu.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/ramfs/file-nommu.c	2007-03-06 15:28:26.000000000 +0100
@@ -32,7 +32,8 @@ const struct address_space_operations ra
 	.readpage		= simple_readpage,
 	.prepare_write		= simple_prepare_write,
 	.commit_write		= simple_commit_write,
-	.set_page_dirty		= __set_page_dirty_no_writeback,
+	.set_page_dirty		= simple_set_page_dirty,
+	.page_dirtied		= simple_page_dirtied,
 };
 
 const struct file_operations ramfs_file_operations = {
Index: linux/fs/reiserfs/inode.c
===================================================================
--- linux.orig/fs/reiserfs/inode.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/reiserfs/inode.c	2007-03-06 15:28:26.000000000 +0100
@@ -2838,14 +2838,13 @@ static void reiserfs_invalidatepage(stru
 	return;
 }
 
-static int reiserfs_set_page_dirty(struct page *page)
+static void reiserfs_set_page_dirty(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	if (reiserfs_file_data_log(inode)) {
+	if (reiserfs_file_data_log(inode))
 		SetPageChecked(page);
-		return __set_page_dirty_nobuffers(page);
-	}
-	return __set_page_dirty_buffers(page);
+	else
+		block_set_page_dirty(page);
 }
 
 /*
@@ -3012,4 +3011,5 @@ const struct address_space_operations re
 	.bmap = reiserfs_aop_bmap,
 	.direct_IO = reiserfs_direct_IO,
 	.set_page_dirty = reiserfs_set_page_dirty,
+	.page_dirtied = generic_page_dirtied,
 };
Index: linux/include/linux/buffer_head.h
===================================================================
--- linux.orig/include/linux/buffer_head.h	2007-03-06 15:28:19.000000000 +0100
+++ linux/include/linux/buffer_head.h	2007-03-06 15:28:26.000000000 +0100
@@ -308,7 +308,7 @@ static inline void lock_buffer(struct bu
 		__lock_buffer(bh);
 }
 
-extern int __set_page_dirty_buffers(struct page *page);
+extern void block_set_page_dirty(struct page *page);
 
 #else /* CONFIG_BLOCK */
 
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-03-06 15:28:19.000000000 +0100
+++ linux/include/linux/fs.h	2007-03-06 15:36:44.000000000 +0100
@@ -404,8 +404,11 @@ struct address_space_operations {
 	/* Write back some dirty pages from this mapping. */
 	int (*writepages)(struct address_space *, struct writeback_control *);
 
-	/* Set a page dirty.  Return true if this dirtied it */
-	int (*set_page_dirty)(struct page *page);
+	/* Called for each page dirtying attempt, before dirty flag is set */
+	void (*set_page_dirty)(struct page *page);
+
+	/* Called if the page state has changed from clean to dirty */
+	void (*page_dirtied)(struct page *page);
 
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
@@ -1869,6 +1872,9 @@ extern int simple_prepare_write(struct f
 			unsigned offset, unsigned to);
 extern int simple_commit_write(struct file *file, struct page *page,
 				unsigned offset, unsigned to);
+extern void simple_set_page_dirty(struct page *page);
+extern void simple_page_dirtied(struct page *page);
+extern void generic_page_dirtied(struct page *page);
 
 extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h	2007-03-06 15:28:19.000000000 +0100
+++ linux/include/linux/mm.h	2007-03-06 15:29:22.000000000 +0100
@@ -785,8 +785,7 @@ void print_bad_pte(struct vm_area_struct
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
 
-int __set_page_dirty_nobuffers(struct page *page);
-int __set_page_dirty_no_writeback(struct page *page);
+int __set_page_dirty(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 int FASTCALL(set_page_dirty(struct page *page));
Index: linux/include/linux/nfs_fs.h
===================================================================
--- linux.orig/include/linux/nfs_fs.h	2007-03-06 15:28:19.000000000 +0100
+++ linux/include/linux/nfs_fs.h	2007-03-06 15:28:26.000000000 +0100
@@ -421,7 +421,7 @@ extern int  nfs_flush_incompatible(struc
 extern int  nfs_updatepage(struct file *, struct page *, unsigned int, unsigned int);
 extern int nfs_writeback_done(struct rpc_task *, struct nfs_write_data *);
 extern void nfs_writedata_release(void *);
-extern int nfs_set_page_dirty(struct page *);
+extern void nfs_set_page_dirty(struct page *);
 
 /*
  * Try to write back everything synchronously (but check the
Index: linux/mm/filemap.c
===================================================================
--- linux.orig/mm/filemap.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/mm/filemap.c	2007-03-06 15:28:26.000000000 +0100
@@ -60,7 +60,7 @@ generic_file_direct_IO(int rw, struct ki
  * Lock ordering:
  *
  *  ->i_mmap_lock		(vmtruncate)
- *    ->private_lock		(__free_pte->__set_page_dirty_buffers)
+ *    ->private_lock		(__free_pte->block_set_page_dirty)
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->mapping->tree_lock
  *
@@ -101,7 +101,7 @@ generic_file_direct_IO(int rw, struct ki
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
  *    ->inode_lock		(page_remove_rmap->set_page_dirty)
  *    ->inode_lock		(zap_pte_range->set_page_dirty)
- *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
+ *    ->private_lock		(zap_pte_range->block_set_page_dirty)
  *
  *  ->task->proc_lock
  *    ->dcache_lock		(proc_pid_lookup)
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/mm/page-writeback.c	2007-03-06 15:29:22.000000000 +0100
@@ -734,22 +734,8 @@ int write_one_page(struct page *page, in
 EXPORT_SYMBOL(write_one_page);
 
 /*
- * For address_spaces which do not use buffers nor write back.
- */
-int __set_page_dirty_no_writeback(struct page *page)
-{
-	if (!PageDirty(page))
-		SetPageDirty(page);
-	return 0;
-}
-
-/*
- * For address_spaces which do not use buffers.  Just tag the page as dirty in
- * its radix tree.
- *
- * This is also used when a single buffer is being dirtied: we want to set the
- * page dirty in that case, but not all the buffers.  This is a "bottom-up"
- * dirtying, whereas __set_page_dirty_buffers() is a "top-down" dirtying.
+ * Tag page dirty in the radix tree and perform dirty page accounting
+ * if required.  Finally mark the inode dirty
  *
  * Most callers have locked the page, which pins the address_space in memory.
  * But zap_pte_range() does not lock the page, however in that case the
@@ -758,36 +744,49 @@ int __set_page_dirty_no_writeback(struct
  * We take care to handle the case where the page was truncated from the
  * mapping by re-checking page_mapping() insode tree_lock.
  */
-int __set_page_dirty_nobuffers(struct page *page)
+void generic_page_dirtied(struct page *page)
 {
-	if (!TestSetPageDirty(page)) {
-		struct address_space *mapping = page_mapping(page);
-		struct address_space *mapping2;
-
-		if (!mapping)
-			return 1;
+	struct address_space *mapping;
 
-		write_lock_irq(&mapping->tree_lock);
-		mapping2 = page_mapping(page);
-		if (mapping2) { /* Race with truncate? */
-			BUG_ON(mapping2 != mapping);
-			if (mapping_cap_account_dirty(mapping)) {
-				__inc_zone_page_state(page, NR_FILE_DIRTY);
-				task_io_account_write(PAGE_CACHE_SIZE);
-			}
-			radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-		}
-		write_unlock_irq(&mapping->tree_lock);
-		if (mapping->host) {
-			/* !PageAnon && !swapper_space */
-			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	write_lock_irq(&mapping->tree_lock);
+	mapping = page_mapping(page);
+	if (mapping) { /* Race with truncate? */
+		if (mapping_cap_account_dirty(mapping)) {
+			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			task_io_account_write(PAGE_CACHE_SIZE);
 		}
+		radix_tree_tag_set(&mapping->page_tree,
+				   page_index(page), PAGECACHE_TAG_DIRTY);
+	}
+	write_unlock_irq(&mapping->tree_lock);
+	if (mapping && mapping->host) {
+		/* !swapper_space */
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	}
+}
+EXPORT_SYMBOL(generic_page_dirtied);
+
+/* The page was dirtied just now */
+static void page_dirtied(struct address_space *mapping, struct page *page)
+{
+	if (mapping->a_ops->page_dirtied)
+		mapping->a_ops->page_dirtied(page);
+	else
+		generic_page_dirtied(page);
+}
+
+/* Set page dirty without calling  a_ops->set_page_dirty */
+int __set_page_dirty(struct page *page)
+{
+	if (!TestSetPageDirty(page)) {
+		struct address_space *mapping = page_mapping(page);
+		if (mapping)
+			page_dirtied(mapping, page);
 		return 1;
 	}
 	return 0;
 }
-EXPORT_SYMBOL(__set_page_dirty_nobuffers);
+EXPORT_SYMBOL(__set_page_dirty);
 
 /*
  * When a writepage implementation decides that it doesn't want to write this
@@ -797,25 +796,36 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
 	wbc->pages_skipped++;
-	return __set_page_dirty_nobuffers(page);
+	return __set_page_dirty(page);
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
 /*
- * If the mapping doesn't provide a set_page_dirty a_op, then
- * just fall through and assume that it wants buffer_heads.
+ * If the mapping doesn't provide a set_page_dirty a_op, then assume
+ * that it wants buffer_heads.
  */
+static void set_dirty_every_time(struct address_space *mapping,
+				 struct page *page)
+{
+	if (mapping->a_ops->set_page_dirty)
+		mapping->a_ops->set_page_dirty(page);
+#ifdef CONFIG_BLOCK
+	else
+		block_set_page_dirty(page);
+#endif
+}
+
 int fastcall set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
 	if (likely(mapping)) {
-		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
-#ifdef CONFIG_BLOCK
-		if (!spd)
-			spd = __set_page_dirty_buffers;
-#endif
-		return (*spd)(page);
+		set_dirty_every_time(mapping, page);
+		if (!TestSetPageDirty(page)) {
+			page_dirtied(mapping, page);
+			return 1;
+		}
+		return 0;
 	}
 	if (!PageDirty(page)) {
 		if (!TestSetPageDirty(page))
@@ -862,48 +872,18 @@ EXPORT_SYMBOL(set_page_dirty_lock);
  */
 int clear_page_dirty_for_io(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	if (TestClearPageDirty(page)) {
+		struct address_space *mapping = page_mapping(page);
+
+		if (mapping && mapping_cap_account_dirty(mapping)) {
+			if (page_mkclean(page))
+				set_dirty_every_time(mapping, page);
 
-	if (mapping && mapping_cap_account_dirty(mapping)) {
-		/*
-		 * Yes, Virginia, this is indeed insane.
-		 *
-		 * We use this sequence to make sure that
-		 *  (a) we account for dirty stats properly
-		 *  (b) we tell the low-level filesystem to
-		 *      mark the whole page dirty if it was
-		 *      dirty in a pagetable. Only to then
-		 *  (c) clean the page again and return 1 to
-		 *      cause the writeback.
-		 *
-		 * This way we avoid all nasty races with the
-		 * dirty bit in multiple places and clearing
-		 * them concurrently from different threads.
-		 *
-		 * Note! Normally the "set_page_dirty(page)"
-		 * has no effect on the actual dirty bit - since
-		 * that will already usually be set. But we
-		 * need the side effects, and it can help us
-		 * avoid races.
-		 *
-		 * We basically use the page "master dirty bit"
-		 * as a serialization point for all the different
-		 * threads doing their things.
-		 *
-		 * FIXME! We still have a race here: if somebody
-		 * adds the page back to the page tables in
-		 * between the "page_mkclean()" and the "TestClearPageDirty()",
-		 * we might have it mapped without the dirty bit set.
-		 */
-		if (page_mkclean(page))
-			set_page_dirty(page);
-		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			return 1;
 		}
-		return 0;
+		return 1;
 	}
-	return TestClearPageDirty(page);
+	return 0;
 }
 EXPORT_SYMBOL(clear_page_dirty_for_io);
 
Index: linux/mm/rmap.c
===================================================================
--- linux.orig/mm/rmap.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/mm/rmap.c	2007-03-06 15:29:22.000000000 +0100
@@ -30,7 +30,7 @@
  *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
  *             swap_lock (in swap_duplicate, swap_info_get)
  *               mmlist_lock (in mmput, drain_mmlist and others)
- *               mapping->private_lock (in __set_page_dirty_buffers)
+ *               mapping->private_lock (in block_set_page_dirty)
  *               inode_lock (in set_page_dirty's __mark_inode_dirty)
  *                 sb_lock (within inode_lock in fs/fs-writeback.c)
  *                 mapping->tree_lock (widely used, in set_page_dirty,
Index: linux/mm/shmem.c
===================================================================
--- linux.orig/mm/shmem.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/mm/shmem.c	2007-03-06 15:28:26.000000000 +0100
@@ -2316,7 +2316,8 @@ static void destroy_inodecache(void)
 
 static const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
-	.set_page_dirty	= __set_page_dirty_no_writeback,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= simple_page_dirtied,
 #ifdef CONFIG_TMPFS
 	.prepare_write	= shmem_prepare_write,
 	.commit_write	= simple_commit_write,
Index: linux/mm/swap_state.c
===================================================================
--- linux.orig/mm/swap_state.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/mm/swap_state.c	2007-03-06 15:28:26.000000000 +0100
@@ -27,7 +27,8 @@
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
 	.sync_page	= block_sync_page,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= simple_set_page_dirty,
+	.page_dirtied	= generic_page_dirtied,
 	.migratepage	= migrate_page,
 };
 
Index: linux/fs/nfs/file.c
===================================================================
--- linux.orig/fs/nfs/file.c	2007-03-06 15:28:19.000000000 +0100
+++ linux/fs/nfs/file.c	2007-03-06 15:28:26.000000000 +0100
@@ -328,6 +328,7 @@ const struct address_space_operations nf
 	.readpage = nfs_readpage,
 	.readpages = nfs_readpages,
 	.set_page_dirty = nfs_set_page_dirty,
+	.page_dirtied = generic_page_dirtied,
 	.writepage = nfs_writepage,
 	.writepages = nfs_writepages,
 	.prepare_write = nfs_prepare_write,
Index: linux/Documentation/filesystems/Locking
===================================================================
--- linux.orig/Documentation/filesystems/Locking	2007-03-06 15:29:38.000000000 +0100
+++ linux/Documentation/filesystems/Locking	2007-03-06 15:36:20.000000000 +0100
@@ -161,7 +161,8 @@ prototypes:
 	int (*readpage)(struct file *, struct page *);
 	int (*sync_page)(struct page *);
 	int (*writepages)(struct address_space *, struct writeback_control *);
-	int (*set_page_dirty)(struct page *page);
+	void (*set_page_dirty)(struct page *page);
+	void (*page_dirtied)(struct page *page);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
@@ -174,7 +175,7 @@ prototypes:
 	int (*launder_page) (struct page *);
 
 locking rules:
-	All except set_page_dirty may block
+	All except set_page_dirty and page_dirtied may block
 
 			BKL	PageLocked(page)
 writepage:		no	yes, unlocks (see below)
@@ -182,6 +183,7 @@ readpage:		no	yes, unlocks
 sync_page:		no	maybe
 writepages:		no
 set_page_dirty		no	no
+page_dirtied		no	no
 readpages:		no
 prepare_write:		no	yes
 commit_write:		no	yes
@@ -263,10 +265,10 @@ nr_to_write is NULL, all dirty pages mus
 writepages should _only_ write pages which are present on
 mapping->io_pages.
 
-	->set_page_dirty() is called from various places in the kernel
-when the target page is marked as needing writeback.  It may be called
-under spinlock (it cannot block) and is sometimes called with the page
-not locked.
+	->set_page_dirty() and ->page_dirtied() are called from various
+places in the kernel when the target page is marked as needing writeback.
+They may be called under spinlock (they cannot block) and sometimes called
+with the page not locked.
 
 	->bmap() is currently used by legacy ioctl() (FIBMAP) provided by some
 filesystems and by the swapper. The latter will eventually go away. All
Index: linux/Documentation/filesystems/vfs.txt
===================================================================
--- linux.orig/Documentation/filesystems/vfs.txt	2007-03-06 15:33:45.000000000 +0100
+++ linux/Documentation/filesystems/vfs.txt	2007-03-06 15:49:01.000000000 +0100
@@ -504,8 +504,8 @@ address_space has finer control of write
 
 The read process essentially only requires 'readpage'.  The write
 process is more complicated and uses prepare_write/commit_write or
-set_page_dirty to write data into the address_space, and writepage,
-sync_page, and writepages to writeback data to storage.
+set_page_dirty/page_dirtied to write data into the address_space,
+and writepage, sync_page, and writepages to writeback data to storage.
 
 Adding and removing pages to/from an address_space is protected by the
 inode's i_mutex.
@@ -529,7 +529,8 @@ struct address_space_operations {
 	int (*readpage)(struct file *, struct page *);
 	int (*sync_page)(struct page *);
 	int (*writepages)(struct address_space *, struct writeback_control *);
-	int (*set_page_dirty)(struct page *page);
+	void (*set_page_dirty)(struct page *page);
+	void (*page_dirtied)(struct page *page);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
@@ -587,13 +588,19 @@ struct address_space_operations {
   	instead.  This will choose pages from the address space that are
   	tagged as DIRTY and will pass them to ->writepage.
 
-  set_page_dirty: called by the VM to set a page dirty.
-        This is particularly needed if an address space attaches
-        private data to a page, and that data needs to be updated when
-        a page is dirtied.  This is called, for example, when a memory
-	mapped page gets modified.
-	If defined, it should set the PageDirty flag, and the
-        PAGECACHE_TAG_DIRTY tag in the radix tree.
+  set_page_dirty: called by the VM to set a page dirty.  This is particularly
+	needed if an address space attaches private data to a page, and that
+	data needs to be updated when a page is dirtied.  This is called, for
+	example, when a memory mapped page gets modified.  This method is
+	called before setting the PG_Dirty flag for the page, and sometimes
+	even independently(see clear_page_dirty_for_io()).  The default for
+	this operation is block_set_page_dirty().
+
+  page_dirtied: called by the VM after the PG_Dirty flag for a page has been
+	toggled from clear to dirty.  This can be used to set the
+	PAGECACHE_TAG_DIRTY tag in the radix tree, account the number of dirty
+	pages and to set the I_DIRTY_PAGES flag in the inode.  The default for
+	this operation is generic_page_dirtied().
 
   readpages: called by the VM to read pages associated with the address_space
   	object. This is essentially just a vector version of

--
