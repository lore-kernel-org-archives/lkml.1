Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXB0XVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXB0XVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXB0XR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:17:59 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:51040 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXB0XRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:17:40 -0500
Message-Id: <20070227231644.084963200@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:54 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 12/22] fuse: fix page invalidation
Content-Disposition: inline; filename=fuse_invalidate_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Other than truncate, there are two cases, when fuse tries to get rid
of cached pages:

 a) in open, if KEEP_CACHE flag is not set)
 b) in getattr, if file size changed spontaneously

Until now invalidate_mapping_pages() were used, which didn't get rid
of mapped pages.  This is wrong, and becomes more wrong as dirty pages
are introduced.  So instead properly invalidate all pages with
invalidate_inode_pages2().  If the size of the file shrunk, truncate
pages outside the new size beforehand.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 14:41:11.000000000 +0100
@@ -86,7 +86,7 @@ void fuse_finish_open(struct inode *inod
 	if (outarg->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		invalidate_inode_pages2(inode->i_mapping);
 	ff->fh = outarg->fh;
 	file->private_data = fuse_file_get(ff);
 }
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-02-27 14:41:11.000000000 +0100
@@ -112,17 +112,22 @@ static int fuse_remount_fs(struct super_
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	if (S_ISREG(inode->i_mode) && i_size_read(inode) != attr->size)
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	loff_t oldsize = i_size_read(inode);
+
+	spin_lock(&fc->lock);
+	i_size_write(inode, attr->size);
+	spin_unlock(&fc->lock);
+	if (S_ISREG(inode->i_mode)) {
+		if (oldsize > attr->size)
+			fuse_vmtruncate(inode, attr->size);
+		invalidate_inode_pages2(inode->i_mapping);
+	}
 
 	inode->i_ino     = attr->ino;
 	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
-	spin_lock(&fc->lock);
-	i_size_write(inode, attr->size);
-	spin_unlock(&fc->lock);
 	inode->i_blocks  = attr->blocks;
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/dir.c	2007-02-27 14:41:11.000000000 +0100
@@ -979,7 +979,7 @@ static void iattr_to_fattr(struct iattr 
 	}
 }
 
-static void fuse_vmtruncate(struct inode *inode, loff_t offset)
+void fuse_vmtruncate(struct inode *inode, loff_t offset)
 {
 	struct address_space *mapping = inode->i_mapping;
 	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-02-27 14:41:11.000000000 +0100
@@ -565,3 +565,8 @@ int fuse_ctl_add_conn(struct fuse_conn *
  * Remove connection from control filesystem
  */
 void fuse_ctl_remove_conn(struct fuse_conn *fc);
+
+/**
+ * Truncate inode
+ */
+void fuse_vmtruncate(struct inode *inode, loff_t offset);

--
