Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbXHCRvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbXHCRvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764701AbXHCRuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:50:13 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50664 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764689AbXHCRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:50:10 -0400
Message-Id: <20070803174922.695299505@szeredi.hu>
References: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:30 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 04/11] fuse: truncate on spontaneous size change
Content-Disposition: inline; filename=fuse_truncate_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Memory mappings were only truncated on an explicit truncate, but not
when the file size was changed externally.

Fix this by moving the truncation code from fuse_setattr to
fuse_change_attributes.

Yes, there are races between write and and external truncation, but we
can't really do anything about them.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-08-03 17:54:55.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-08-03 17:54:55.000000000 +0200
@@ -980,23 +980,6 @@ static void iattr_to_fattr(struct iattr 
 	}
 }
 
-static void fuse_vmtruncate(struct inode *inode, loff_t offset)
-{
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	int need_trunc;
-
-	spin_lock(&fc->lock);
-	need_trunc = inode->i_size > offset;
-	i_size_write(inode, offset);
-	spin_unlock(&fc->lock);
-
-	if (need_trunc) {
-		struct address_space *mapping = inode->i_mapping;
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-		truncate_inode_pages(mapping, offset);
-	}
-}
-
 /*
  * Set attributes, and at the same time refresh them.
  *
@@ -1014,7 +997,6 @@ static int fuse_setattr(struct dentry *e
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
 	int err;
-	int is_truncate = 0;
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
@@ -1024,7 +1006,6 @@ static int fuse_setattr(struct dentry *e
 
 	if (attr->ia_valid & ATTR_SIZE) {
 		unsigned long limit;
-		is_truncate = 1;
 		if (IS_SWAPFILE(inode))
 			return -ETXTBSY;
 		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
@@ -1051,21 +1032,20 @@ static int fuse_setattr(struct dentry *e
 	request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err) {
-		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
-			err = -EIO;
-		} else {
-			if (is_truncate)
-				fuse_vmtruncate(inode, outarg.attr.size);
-			fuse_change_attributes(inode, &outarg.attr);
-			fi->i_time = time_to_jiffies(outarg.attr_valid,
-						     outarg.attr_valid_nsec);
-		}
-	} else if (err == -EINTR)
-		fuse_invalidate_attr(inode);
+	if (err) {
+		if (err == -EINTR)
+			fuse_invalidate_attr(inode);
+		return err;
+	}
 
-	return err;
+	if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		make_bad_inode(inode);
+		return -EIO;
+	}
+
+	fuse_change_attributes(inode, &outarg.attr);
+	fi->i_time = time_to_jiffies(outarg.attr_valid, outarg.attr_valid_nsec);
+	return 0;
 }
 
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-08-03 17:54:54.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-08-03 17:54:55.000000000 +0200
@@ -109,20 +109,24 @@ static int fuse_remount_fs(struct super_
 	return 0;
 }
 
+static void fuse_truncate(struct address_space *mapping, loff_t offset)
+{
+	/* See vmtruncate() */
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(mapping, offset);
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+}
+
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	if (S_ISREG(inode->i_mode) && i_size_read(inode) != attr->size)
-		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	loff_t oldsize;
 
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
@@ -130,6 +134,17 @@ void fuse_change_attributes(struct inode
 	inode->i_mtime.tv_nsec  = attr->mtimensec;
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
+
+	spin_lock(&fc->lock);
+	oldsize = inode->i_size;
+	i_size_write(inode, attr->size);
+	spin_unlock(&fc->lock);
+
+	if (S_ISREG(inode->i_mode) && oldsize != attr->size) {
+		if (attr->size < oldsize)
+			fuse_truncate(inode->i_mapping, attr->size);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+	}
 }
 
 static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)

--
