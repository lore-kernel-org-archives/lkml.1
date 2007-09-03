Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbXICClA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbXICClA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbXICC3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:29:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58000 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbXICC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:29:05 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 21/32] Unionfs: mmap fixes
Date: Sun,  2 Sep 2007 22:20:44 -0400
Message-Id: <11887860583317-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Most important fixes prevent deadlocks especially under low-memory
conditions, when one is not supposed to cause more memory pressure; also
handle AOP_WRITEPAGE_ACTIVATE from lower file systems.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/file.c |    6 +-
 fs/unionfs/mmap.c |  132 ++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 98 insertions(+), 40 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 0555b6c..b55da4f 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -101,9 +101,6 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 
-	if ((err = unionfs_file_revalidate(file, 1)))
-		goto out;
-
 	/* This might be deferred to mmap's writepage */
 	willwrite = ((vma->vm_flags | VM_SHARED | VM_WRITE) == vma->vm_flags);
 	if ((err = unionfs_file_revalidate(file, willwrite)))
@@ -132,6 +129,9 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	if (!err)
+		/* copyup could cause parent dir times to change */
+		unionfs_copy_attr_times(file->f_path.dentry->d_parent->d_inode);
 	return err;
 }
 
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 969fd16..d26b572 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -21,7 +21,7 @@
 
 /*
  * Unionfs doesn't implement ->writepages, which is OK with the VFS and
- * nkeeps our code simpler and smaller.  Nevertheless, somehow, our own
+ * keeps our code simpler and smaller.  Nevertheless, somehow, our own
  * ->writepage must be called so we can sync the upper pages with the lower
  * pages: otherwise data changed at the upper layer won't get written to the
  * lower layer.
@@ -64,10 +64,31 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	inode = page->mapping->host;
 	lower_inode = unionfs_lower_inode(inode);
 
-	/* find lower page (returns a locked page) */
-	lower_page = grab_cache_page(lower_inode->i_mapping, page->index);
-	if (!lower_page)
+	/*
+	 * find lower page (returns a locked page)
+	 *
+	 * NOTE: we used to call grab_cache_page(), but that was unnecessary
+	 * as it would have tried to create a new lower page if it didn't
+	 * exist, leading to deadlocks (esp. under memory-pressure
+	 * conditions, when it is really a bad idea to *consume* more
+	 * memory).  Instead, we assume the lower page exists, and if we can
+	 * find it, then we ->writepage on it; if we can't find it, then it
+	 * couldn't have disappeared unless the kernel already flushed it,
+	 * in which case we're still OK.  This is especially correct if
+	 * wbc->sync_mode is WB_SYNC_NONE (as per
+	 * Documentation/filesystems/vfs.txt).  If we can't flush our page
+	 * because we can't find a lower page, then at least we re-mark our
+	 * page as dirty, and return AOP_WRITEPAGE_ACTIVATE as the VFS
+	 * expects us to.  (Note, if in the future it'd turn out that we
+	 * have to find a lower page no matter what, then we'd have to
+	 * resort to RAIF's page pointer flipping trick.)
+	 */
+	lower_page = find_lock_page(lower_inode->i_mapping, page->index);
+	if (!lower_page) {
+		err = AOP_WRITEPAGE_ACTIVATE;
+		set_page_dirty(page);
 		goto out;
+	}
 
 	/* get page address, and encode it */
 	kaddr = kmap(page);
@@ -85,24 +106,41 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 		wbc->for_writepages = 0;
 
 	/* call lower writepage (expects locked page) */
+	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
 	err = lower_inode->i_mapping->a_ops->writepage(lower_page, wbc);
 	wbc->for_writepages = saved_for_writepages; /* restore value */
 
-	/*
-	 * update mtime and ctime of lower level file system
-	 * unionfs' mtime and ctime are updated by generic_file_write
-	 */
-	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
-
-	page_cache_release(lower_page);	/* b/c grab_cache_page increased refcnt */
-
+	/* b/c find_lock_page locked it and ->writepage unlocks on success */
 	if (err)
+		unlock_page(lower_page);
+	/* b/c grab_cache_page increased refcnt */
+	page_cache_release(lower_page);
+
+	if (err < 0) {
 		ClearPageUptodate(page);
-	else
-		SetPageUptodate(page);
+		goto out;
+	}
+	if (err == AOP_WRITEPAGE_ACTIVATE) {
+		/*
+		 * Lower file systems such as ramfs and tmpfs, may return
+		 * AOP_WRITEPAGE_ACTIVATE so that the VM won't try to
+		 * (pointlessly) write the page again for a while.  But
+		 * those lower file systems also set the page dirty bit back
+		 * again.  So we mimic that behaviour here.
+		 */
+		if (PageDirty(lower_page))
+			set_page_dirty(page);
+		goto out;
+	}
+
+	/* all is well */
+	SetPageUptodate(page);
+	/* lower mtimes has changed: update ours */
+	unionfs_copy_attr_times(inode);
 
-out:
 	unlock_page(page);
+
+out:
 	return err;
 }
 
@@ -155,7 +193,9 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 	err = 0;
 
 	/* if vfs_read succeeded above, sync up our times */
-	fsstack_copy_attr_times(inode, lower_file->f_path.dentry->d_inode);
+	unionfs_copy_attr_times(inode);
+
+	flush_dcache_page(page);
 
 out:
 	if (err == 0)
@@ -170,16 +210,17 @@ static int unionfs_readpage(struct file *file, struct page *page)
 {
 	int err;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
-
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
 	err = unionfs_do_readpage(file, page);
 
-	if (!err)
+	if (!err) {
 		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
 			    unionfs_lower_dentry(file->f_path.dentry));
+		unionfs_copy_attr_times(file->f_path.dentry->d_inode);
+	}
 
 	/*
 	 * we have to unlock our page, b/c we _might_ have gotten a locked
@@ -198,11 +239,21 @@ static int unionfs_prepare_write(struct file *file, struct page *page,
 {
 	int err;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
-
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+	/*
+	 * This is the only place where we unconditionally copy the lower
+	 * attribute times before calling unionfs_file_revalidate.  The
+	 * reason is that our ->write calls do_sync_write which in turn will
+	 * call our ->prepare_write and then ->commit_write.  Before our
+	 * ->write is called, the lower mtimes are in sync, but by the time
+	 * the VFS calls our ->commit_write, the lower mtimes have changed.
+	 * Therefore, the only reasonable time for us to sync up from the
+	 * changed lower mtimes, and avoid an invariant violation warning,
+	 * is here, in ->prepare_write.
+	 */
+	unionfs_copy_attr_times(file->f_path.dentry->d_inode);
 	err = unionfs_file_revalidate(file, 1);
-
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 
 	return err;
 }
@@ -237,7 +288,8 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	page_data = (char *)kmap(page);
 	lower_file->f_pos = (page->index << PAGE_CACHE_SHIFT) + from;
 
-	/* SP: I use vfs_write instead of copying page data and the
+	/*
+	 * SP: I use vfs_write instead of copying page data and the
 	 * prepare_write/commit_write combo because file system's like
 	 * GFS/OCFS2 don't like things touching those directly,
 	 * calling the underlying write op, while a little bit slower, will
@@ -259,20 +311,15 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + to;
 	if (pos > i_size_read(inode))
 		i_size_write(inode, pos);
-
-	/*
-	 * update mtime and ctime of lower level file system
-	 * unionfs' mtime and ctime are updated by generic_file_write
-	 */
-	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
-
+	/* if vfs_write succeeded above, sync up our times */
+	unionfs_copy_attr_times(inode);
 	mark_inode_dirty_sync(inode);
 
 out:
 	if (err < 0)
 		ClearPageUptodate(page);
 
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;		/* assume all is ok */
 }
 
@@ -286,10 +333,19 @@ static void unionfs_sync_page(struct page *page)
 	inode = page->mapping->host;
 	lower_inode = unionfs_lower_inode(inode);
 
-	/* find lower page (returns a locked page) */
-	lower_page = grab_cache_page(lower_inode->i_mapping, page->index);
-	if (!lower_page)
+	/*
+	 * Find lower page (returns a locked page).
+	 *
+	 * NOTE: we used to call grab_cache_page(), but that was unnecessary
+	 * as it would have tried to create a new lower page if it didn't
+	 * exist, leading to deadlocks.  All our sync_page method needs to
+	 * do is ensure that pending I/O gets done.
+	 */
+	lower_page = find_lock_page(lower_inode->i_mapping, page->index);
+	if (!lower_page) {
+		printk(KERN_DEBUG "unionfs: find_lock_page failed\n");
 		goto out;
+	}
 
 	/* do the actual sync */
 	mapping = lower_page->mapping;
@@ -300,8 +356,10 @@ static void unionfs_sync_page(struct page *page)
 	if (mapping && mapping->a_ops && mapping->a_ops->sync_page)
 		mapping->a_ops->sync_page(lower_page);
 
-	unlock_page(lower_page);	/* b/c grab_cache_page locked it */
-	page_cache_release(lower_page);	/* b/c grab_cache_page increased refcnt */
+	/* b/c find_lock_page locked it */
+	unlock_page(lower_page);
+	/* b/c find_lock_page increased refcnt */
+	page_cache_release(lower_page);
 
 out:
 	return;
-- 
1.5.2.2.238.g7cbf2f2

