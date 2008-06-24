Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbYFXOvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbYFXOvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbYFXOuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:50:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58192 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbYFXOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:50:49 -0400
Message-Id: <20080624145044.921319280@szeredi.hu>
References: <20080624145011.722691277@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jun 2008 16:50:14 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
Subject: [patch 3/5] vfs: change remove_suid() to file_remove_suid()
Content-Disposition: inline; filename=vfs-change-remove_suid-to-file_remove_suid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

All calls to remove_suid() are made with a file pointer, because
(similarly to file_update_time) it is called when the file is written.

Clean up callers by passing in a file instead of a dentry.

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

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2008-06-21 10:18:52.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2008-06-24 16:25:25.000000000 +0200
@@ -893,7 +893,7 @@ static ssize_t fuse_file_aio_write(struc
 	if (count == 0)
 		goto out;
 
-	err = remove_suid(file->f_path.dentry);
+	err = file_remove_suid(file);
 	if (err)
 		goto out;
 
Index: linux-2.6/fs/ntfs/file.c
===================================================================
--- linux-2.6.orig/fs/ntfs/file.c	2008-06-19 14:58:10.000000000 +0200
+++ linux-2.6/fs/ntfs/file.c	2008-06-24 16:25:25.000000000 +0200
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
--- linux-2.6.orig/fs/splice.c	2008-06-24 13:58:36.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-06-24 16:25:25.000000000 +0200
@@ -763,7 +763,7 @@ generic_file_splice_write_nolock(struct 
 	ssize_t ret;
 	int err;
 
-	err = remove_suid(out->f_path.dentry);
+	err = file_remove_suid(out);
 	if (unlikely(err))
 		return err;
 
@@ -821,7 +821,7 @@ generic_file_splice_write(struct pipe_in
 	ssize_t ret;
 
 	inode_double_lock(inode, pipe->inode);
-	ret = remove_suid(out->f_path.dentry);
+	ret = file_remove_suid(out);
 	if (likely(!ret))
 		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
 	inode_double_unlock(inode, pipe->inode);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-06-19 14:58:11.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2008-06-24 16:25:25.000000000 +0200
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
--- linux-2.6.orig/include/linux/fs.h	2008-06-24 16:24:46.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-06-24 16:25:25.000000000 +0200
@@ -1817,7 +1817,7 @@ extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
-extern int remove_suid(struct dentry *);
+extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-06-24 13:58:36.000000000 +0200
+++ linux-2.6/mm/filemap.c	2008-06-24 16:25:25.000000000 +0200
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
--- linux-2.6.orig/mm/filemap_xip.c	2008-06-19 14:58:13.000000000 +0200
+++ linux-2.6/mm/filemap_xip.c	2008-06-24 16:25:25.000000000 +0200
@@ -380,7 +380,7 @@ xip_file_write(struct file *filp, const 
 	if (count == 0)
 		goto out_backing;
 
-	ret = remove_suid(filp->f_path.dentry);
+	ret = file_remove_suid(filp);
 	if (ret)
 		goto out_backing;
 

--
