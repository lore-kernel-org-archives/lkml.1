Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYE2LgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYE2LgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYE2Ldf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56713 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYE2Ld0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:26 -0400
Message-Id: <20080529113318.257547449@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:53 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 8/8] vfs: create file_remove_suid() helper
Content-Disposition: inline; filename=file_remove_suid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

All calls to remove_suid() are made with a file pointer.  This is not
accidental: similarly to file_update_time(), this function is called
when the file is written.

So simplify callers by passing the file pointer instead of the dentry.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c             |    2 +-
 fs/ntfs/file.c             |    2 +-
 fs/splice.c                |    4 ++--
 fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
 include/linux/fs.h         |    2 +-
 mm/filemap.c               |    7 ++++---
 mm/filemap_xip.c           |    2 +-
 7 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/ntfs/file.c
===================================================================
--- linux-2.6.orig/fs/ntfs/file.c	2008-05-29 12:46:19.000000000 +0200
+++ linux-2.6/fs/ntfs/file.c	2008-05-29 12:46:26.000000000 +0200
@@ -2118,7 +2118,7 @@ static ssize_t ntfs_file_aio_write_noloc
 		goto out;
 	if (!count)
 		goto out;
-	err = remove_suid(file->f_path.dentry);
+	err = file_remove_suid(file);
 	if (err)
 		goto out;
 	file_update_time(file);
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2008-05-29 12:46:19.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-05-29 12:46:26.000000000 +0200
@@ -762,7 +762,7 @@ generic_file_splice_write_nolock(struct 
 	ssize_t ret;
 	int err;
 
-	err = remove_suid(out->f_path.dentry);
+	err = file_remove_suid(out);
 	if (unlikely(err))
 		return err;
 
@@ -820,7 +820,7 @@ generic_file_splice_write(struct pipe_in
 	ssize_t ret;
 
 	inode_double_lock(inode, pipe->inode);
-	ret = remove_suid(out->f_path.dentry);
+	ret = file_remove_suid(out);
 	if (likely(!ret))
 		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
 	inode_double_unlock(inode, pipe->inode);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-05-29 12:46:19.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2008-05-29 12:46:26.000000000 +0200
@@ -711,7 +711,7 @@ start:
 	     !capable(CAP_FSETID)) {
 		error = xfs_write_clear_setuid(xip);
 		if (likely(!error))
-			error = -remove_suid(file->f_path.dentry);
+			error = -file_remove_suid(file);
 		if (unlikely(error)) {
 			goto out_unlock_internal;
 		}
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-29 12:46:25.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-29 12:46:26.000000000 +0200
@@ -1850,7 +1850,7 @@ extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
-extern int remove_suid(struct dentry *);
+extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-05-29 12:46:19.000000000 +0200
+++ linux-2.6/mm/filemap.c	2008-05-29 12:46:26.000000000 +0200
@@ -1668,8 +1668,9 @@ static int __remove_suid(struct dentry *
 	return notify_change(dentry, &newattrs);
 }
 
-int remove_suid(struct dentry *dentry)
+int file_remove_suid(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	int killsuid = should_remove_suid(dentry);
 	int killpriv = security_inode_need_killpriv(dentry);
 	int error = 0;
@@ -1683,7 +1684,7 @@ int remove_suid(struct dentry *dentry)
 
 	return error;
 }
-EXPORT_SYMBOL(remove_suid);
+EXPORT_SYMBOL(file_remove_suid);
 
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
@@ -2394,7 +2395,7 @@ __generic_file_aio_write_nolock(struct k
 	if (count == 0)
 		goto out;
 
-	err = remove_suid(file->f_path.dentry);
+	err = file_remove_suid(file);
 	if (err)
 		goto out;
 
Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c	2008-05-29 12:46:19.000000000 +0200
+++ linux-2.6/mm/filemap_xip.c	2008-05-29 12:46:26.000000000 +0200
@@ -380,7 +380,7 @@ xip_file_write(struct file *filp, const 
 	if (count == 0)
 		goto out_backing;
 
-	ret = remove_suid(filp->f_path.dentry);
+	ret = file_remove_suid(filp);
 	if (ret)
 		goto out_backing;
 
Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2008-05-29 12:46:19.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2008-05-29 12:46:26.000000000 +0200
@@ -893,7 +893,7 @@ static ssize_t fuse_file_aio_write(struc
 	if (count == 0)
 		goto out;
 
-	err = remove_suid(file->f_path.dentry);
+	err = file_remove_suid(file);
 	if (err)
 		goto out;
 

--
