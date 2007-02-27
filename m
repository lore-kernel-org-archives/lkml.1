Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbXB0XTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbXB0XTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXB0XSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:14 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:51122 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbXB0XSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:06 -0500
Message-Id: <20070227231713.209106582@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:59 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 17/22] fuse: writable shared mmap support
Content-Disposition: inline; filename=fuse_writable_mmap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Change fuse_file_mmap() to allow shared writable mappings.  Change the
->set_page_dirty address space operation to __set_page_dirty_nobuffers.

In fuse_fsync() sync the inode's dirty data.

It is important, that after all writable file are closed, no more
dirty pages remain for the inode.  So write back dirty pages from
munmap().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 14:41:12.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 14:41:12.000000000 +0100
@@ -253,6 +253,11 @@ int fuse_fsync_common(struct file *file,
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	/* Wait for all outstanding writes, before sending the FSYNC request */
+	err = write_inode_now(de->d_inode, 0);
+	if (err)
+		return err;
+
 	if ((!isdir && fc->no_fsync) || (isdir && fc->no_fsyncdir))
 		return 0;
 
@@ -764,21 +769,39 @@ static int fuse_launder_page(struct page
 	return err;
 }
 
-static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
+static void fuse_vma_close(struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED)) {
-		if ((vma->vm_flags & VM_WRITE))
-			return -ENODEV;
-		else
-			vma->vm_flags &= ~VM_MAYWRITE;
-	}
-	return generic_file_mmap(file, vma);
+	/*
+	 * Write back dirty pages now, because there may not
+	 * be any suitable open files later
+	 */
+	filemap_write_and_wait(vma->vm_file->f_mapping);
 }
 
-static int fuse_set_page_dirty(struct page *page)
+static struct vm_operations_struct fuse_file_vm_ops = {
+	.close		= fuse_vma_close,
+	.nopage		= filemap_nopage,
+	.populate	= filemap_populate,
+};
+
+static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	printk("fuse_set_page_dirty: should not happen\n");
-	dump_stack();
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
+		struct inode *inode = file->f_dentry->d_inode;
+		struct fuse_conn *fc = get_fuse_conn(inode);
+		struct fuse_inode *fi = get_fuse_inode(inode);
+		struct fuse_file *ff = file->private_data;
+		/*
+		 * file may be written through mmap, so chain it onto the
+		 * inodes's write_file list
+		 */
+		spin_lock(&fc->lock);
+		if (list_empty(&ff->write_entry))
+			list_add(&ff->write_entry, &fi->write_files);
+		spin_unlock(&fc->lock);
+	}
+	file_accessed(file);
+	vma->vm_ops = &fuse_file_vm_ops;
 	return 0;
 }
 
@@ -972,7 +995,7 @@ static const struct address_space_operat
 	.prepare_write	= fuse_prepare_write,
 	.commit_write	= fuse_commit_write,
 	.readpages	= fuse_readpages,
-	.set_page_dirty	= fuse_set_page_dirty,
+	.set_page_dirty	= __set_page_dirty_nobuffers,
 	.bmap		= fuse_bmap,
 };
 

--
