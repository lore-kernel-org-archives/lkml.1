Return-Path: <linux-kernel-owner+w=401wt.eu-S1030348AbXBTSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348AbXBTSqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030355AbXBTSq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:46:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030348AbXBTSq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:46:27 -0500
Message-ID: <45DB4201.3040108@redhat.com>
Date: Tue, 20 Feb 2007 13:46:25 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] memory mapped files not updating timestamps v2
Content-Type: multipart/mixed;
 boundary="------------030700030804030804040203"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030700030804030804040203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

Attached are some changes to address the problem that modifications to
the contents of a file, made via an mmap'd region, do not cause the
modification time on the file to be updated.  This lack can cause corruption
by allowing backup software to not detect files which should be backed up.
This also represents a potential security hole because it allows a file 
to be
modified with no corresponding change in the file modification or change
time fields.

The changes add support to detect when the modification time needs to be
updated by placing a hook in __set_pages_dirty_buffers and
__set_pages_dirty_nobuffers.  One of these two routines will be invoked
when the dirty bit is detected in the pte.  The hook sets a new bit in the
address_space mapping struct indicating that the file which is associated
with that part of the address space needs to have its modification and
change time attributes updated.

The new bit described above is used in various system calls to cause the
modification and change times to be updated.  These are the msync and fsync
system calls.  Additionally, these two timestamps will be updated if a
sync or other inode flushing operation occurs as part of normal system
operations.

This support is updated from the previous version by adding support to
correctly update the timestamps on block special devices.

These changes were tested in two ways.  One was to simply create a file,
write(2) to it, close it, and then test to ensure that the file modification
time does not change after the file is closed.  Another was a program which
creates a file, mmap's it, modifies the mapped pages, and then either 
msync's
the region, fsync's the file, sync's the system, abruptly exits, or simply
munmap's the files.  This program shows the file mtime and ctime fields at
various times and these times were used to ensure that they did change and
did change in expected ways.

   Thanx...

      ps

Signed-off-by: Peter Staubach <staubach@redhat.com>


--------------030700030804030804040203
Content-Type: text/plain;
 name="mmap_mctime.devel.v2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mmap_mctime.devel.v2"

--- linux-2.6.20.i686/fs/buffer.c.org
+++ linux-2.6.20.i686/fs/buffer.c
@@ -710,6 +710,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 int __set_page_dirty_buffers(struct page *page)
 {
 	struct address_space * const mapping = page_mapping(page);
+	int ret = 0;
 
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
@@ -727,7 +728,7 @@ int __set_page_dirty_buffers(struct page
 	spin_unlock(&mapping->private_lock);
 
 	if (TestSetPageDirty(page))
-		return 0;
+		goto out;
 
 	write_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
@@ -740,7 +741,11 @@ int __set_page_dirty_buffers(struct page
 	}
 	write_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-	return 1;
+	ret = 1;
+out:
+	if (page_mapped(page))
+		set_bit(AS_MCTIME, &mapping->flags);
+	return ret;
 }
 EXPORT_SYMBOL(__set_page_dirty_buffers);
 
--- linux-2.6.20.i686/fs/fs-writeback.c.org
+++ linux-2.6.20.i686/fs/fs-writeback.c
@@ -167,6 +167,13 @@ __sync_single_inode(struct inode *inode,
 
 	spin_unlock(&inode_lock);
 
+	if (test_and_clear_bit(AS_MCTIME, &mapping->flags)) {
+		if (S_ISBLK(inode->i_mode))
+			bd_inode_update_time(inode);
+		else
+			inode_update_time(inode);
+	}
+
 	ret = do_writepages(mapping, wbc);
 
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
--- linux-2.6.20.i686/fs/inode.c.org
+++ linux-2.6.20.i686/fs/inode.c
@@ -1201,8 +1201,8 @@ void touch_atime(struct vfsmount *mnt, s
 EXPORT_SYMBOL(touch_atime);
 
 /**
- *	file_update_time	-	update mtime and ctime time
- *	@file: file accessed
+ *	inode_update_time	-	update mtime and ctime time
+ *	@inode: file accessed
  *
  *	Update the mtime and ctime members of an inode and mark the inode
  *	for writeback.  Note that this function is meant exclusively for
@@ -1212,9 +1212,8 @@ EXPORT_SYMBOL(touch_atime);
  *	timestamps are handled by the server.
  */
 
-void file_update_time(struct file *file)
+void inode_update_time(struct inode *inode)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
 	int sync_it = 0;
 
@@ -1238,7 +1237,7 @@ void file_update_time(struct file *file)
 		mark_inode_dirty_sync(inode);
 }
 
-EXPORT_SYMBOL(file_update_time);
+EXPORT_SYMBOL(inode_update_time);
 
 int inode_needs_sync(struct inode *inode)
 {
--- linux-2.6.20.i686/fs/block_dev.c.org
+++ linux-2.6.20.i686/fs/block_dev.c
@@ -608,6 +608,22 @@ void bdput(struct block_device *bdev)
 
 EXPORT_SYMBOL(bdput);
  
+void bd_inode_update_time(struct inode *inode)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct list_head *p;
+
+	if (bdev == NULL)
+		return;
+
+	spin_lock(&bdev_lock);
+	list_for_each(p, &bdev->bd_inodes) {
+		inode = list_entry(p, struct inode, i_devices);
+		inode_update_time(inode);
+	}
+	spin_unlock(&bdev_lock);
+}
+
 static struct block_device *bd_acquire(struct inode *inode)
 {
 	struct block_device *bdev;
--- linux-2.6.20.i686/include/linux/fs.h.org
+++ linux-2.6.20.i686/include/linux/fs.h
@@ -1488,6 +1488,7 @@ extern struct block_device *bdget(dev_t)
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
+extern void bd_inode_update_time(struct inode *);
 extern struct block_device *open_by_devnum(dev_t, unsigned);
 extern const struct address_space_operations def_blk_aops;
 #else
@@ -1892,7 +1893,11 @@ extern int buffer_migrate_page(struct ad
 extern int inode_change_ok(struct inode *, struct iattr *);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
 
-extern void file_update_time(struct file *file);
+extern void inode_update_time(struct inode *inode);
+static inline void file_update_time(struct file *file)
+{
+	inode_update_time(file->f_dentry->d_inode);
+}
 
 static inline ino_t parent_ino(struct dentry *dentry)
 {
--- linux-2.6.20.i686/include/linux/pagemap.h.org
+++ linux-2.6.20.i686/include/linux/pagemap.h
@@ -16,8 +16,9 @@
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
  * allocation mode flags.
  */
-#define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
+#define AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
 #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
+#define AS_MCTIME	(__GFP_BITS_SHIFT + 2)	/* need m/ctime change */
 
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
--- linux-2.6.20.i686/mm/page-writeback.c.org
+++ linux-2.6.20.i686/mm/page-writeback.c
@@ -760,8 +760,10 @@ int __set_page_dirty_no_writeback(struct
  */
 int __set_page_dirty_nobuffers(struct page *page)
 {
+	struct address_space *mapping = page_mapping(page);
+	int ret = 0;
+
 	if (!TestSetPageDirty(page)) {
-		struct address_space *mapping = page_mapping(page);
 		struct address_space *mapping2;
 
 		if (!mapping)
@@ -783,9 +785,11 @@ int __set_page_dirty_nobuffers(struct pa
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 		}
-		return 1;
+		ret = 1;
 	}
-	return 0;
+	if (page_mapped(page))
+		set_bit(AS_MCTIME, &mapping->flags);
+	return ret;
 }
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
--- linux-2.6.20.i686/mm/msync.c.org
+++ linux-2.6.20.i686/mm/msync.c
@@ -12,6 +12,7 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/pagemap.h>
 
 /*
  * MS_SYNC syncs the entire file - including mappings.
@@ -77,11 +78,16 @@ asmlinkage long sys_msync(unsigned long 
 		}
 		file = vma->vm_file;
 		start = vma->vm_end;
-		if ((flags & MS_SYNC) && file &&
-				(vma->vm_flags & VM_SHARED)) {
+		if ((flags & (MS_SYNC|MS_ASYNC)) &&
+		    file && (vma->vm_flags & VM_SHARED)) {
 			get_file(file);
 			up_read(&mm->mmap_sem);
-			error = do_fsync(file, 0);
+			error = 0;
+			if (flags & MS_SYNC)
+				error = do_fsync(file, 0);
+			else if (test_and_clear_bit(AS_MCTIME,
+					       &file->f_mapping->flags))
+				file_update_time(file);
 			fput(file);
 			if (error || start >= end)
 				goto out;

--------------030700030804030804040203--
