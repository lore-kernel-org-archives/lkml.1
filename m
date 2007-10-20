Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbXJTKLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbXJTKLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764040AbXJTKLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:11:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:38554 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbXJTKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:10:58 -0400
Message-Id: <20071020101327.745699516@X40.localnet>
References: <20071020100903.717837398@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Sat, 20 Oct 2007 12:09:05 +0200
From: Jan Blunck <jblunck@suse.de>
To: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: [RFC 2/2] i_op->readdir: Change libfs users to the new interface
Content-Disposition: inline; filename=vfs/readdir-inode_operation-libfs.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes dcache_readdir() to the new inode operations readdir
interface. Hence all the users of libfs.c are changed to use the new interface
too.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/autofs4/autofs_i.h |    5 ++---
 fs/autofs4/root.c     |   41 ++++++++++++++++++++++++-----------------
 fs/cifs/inode.c       |    1 +
 fs/hugetlbfs/inode.c  |    1 +
 fs/libfs.c            |   27 ++++++++++++++-------------
 fs/ocfs2/dlm/dlmfs.c  |    1 +
 fs/ramfs/inode.c      |    1 +
 include/linux/fs.h    |    3 ++-
 mm/shmem.c            |    1 +
 9 files changed, 47 insertions(+), 34 deletions(-)

Index: b/fs/autofs4/autofs_i.h
===================================================================
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -168,10 +168,9 @@ static inline int autofs4_ispending(stru
 	return pending;
 }
 
-static inline void autofs4_copy_atime(struct file *src, struct file *dst)
+static inline void autofs4_copy_atime(struct inode *src, struct inode *dst)
 {
-	dst->f_path.dentry->d_inode->i_atime =
-		src->f_path.dentry->d_inode->i_atime;
+	dst->i_atime = src->i_atime;
 	return;
 }
 
Index: b/fs/autofs4/root.c
===================================================================
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -35,7 +35,6 @@ const struct file_operations autofs4_roo
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs4_root_readdir,
 	.ioctl		= autofs4_root_ioctl,
 };
 
@@ -43,7 +42,6 @@ const struct file_operations autofs4_dir
 	.open		= autofs4_dir_open,
 	.release	= autofs4_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs4_dir_readdir,
 };
 
 const struct inode_operations autofs4_indirect_root_inode_operations = {
@@ -52,6 +50,7 @@ const struct inode_operations autofs4_in
 	.symlink	= autofs4_dir_symlink,
 	.mkdir		= autofs4_dir_mkdir,
 	.rmdir		= autofs4_dir_rmdir,
+	.readdir	= autofs4_root_readdir,
 };
 
 const struct inode_operations autofs4_direct_root_inode_operations = {
@@ -59,6 +58,7 @@ const struct inode_operations autofs4_di
 	.unlink		= autofs4_dir_unlink,
 	.mkdir		= autofs4_dir_mkdir,
 	.rmdir		= autofs4_dir_rmdir,
+	.readdir	= autofs4_root_readdir,
 	.follow_link	= autofs4_follow_link,
 };
 
@@ -68,15 +68,17 @@ const struct inode_operations autofs4_di
 	.symlink	= autofs4_dir_symlink,
 	.mkdir		= autofs4_dir_mkdir,
 	.rmdir		= autofs4_dir_rmdir,
+	.readdir	= autofs4_dir_readdir,
 };
 
-static int autofs4_root_readdir(struct file *file, void *dirent,
-				filldir_t filldir)
+static int autofs4_root_readdir(struct dentry *dentry, loff_t *pos,
+				void *private,
+				filldir_t filldir, void *dirent)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(file->f_path.dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	int oz_mode = autofs4_oz_mode(sbi);
 
-	DPRINTK("called, filp->f_pos = %lld", file->f_pos);
+	DPRINTK("called, filp->f_pos = %lld", *pos);
 
 	/*
 	 * Don't set reghost flag if:
@@ -84,12 +86,12 @@ static int autofs4_root_readdir(struct f
 	 * 2) we haven't even enabled reghosting in the 1st place.
 	 * 3) this is the daemon doing a readdir
 	 */
-	if (oz_mode && file->f_pos == 0 && sbi->reghost_enabled)
+	if (oz_mode && *pos == 0 && sbi->reghost_enabled)
 		sbi->needs_reghost = 1;
 
 	DPRINTK("needs_reghost = %d", sbi->needs_reghost);
 
-	return dcache_readdir(file, dirent, filldir);
+	return dcache_inode_readdir(dentry, pos, private,filldir, dirent);
 }
 
 static int autofs4_dir_open(struct inode *inode, struct file *file)
@@ -201,15 +203,16 @@ out:
 	return status;
 }
 
-static int autofs4_dir_readdir(struct file *file, void *dirent, filldir_t filldir)
+static int autofs4_dir_readdir(struct dentry *dentry, loff_t *pos,
+			       void *private,
+			       filldir_t filldir, void *dirent)
 {
-	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor = file->private_data;
+	struct dentry *cursor = private;
 	int status;
 
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
+	DPRINTK("dentry=%p %.*s", dentry, dentry->d_name.len,
+		dentry->d_name.name);
 
 	if (autofs4_oz_mode(sbi))
 		goto out;
@@ -221,21 +224,25 @@ static int autofs4_dir_readdir(struct fi
 
 	if (d_mountpoint(dentry)) {
 		struct file *fp = cursor->d_fsdata;
+		struct inode *inode;
 
 		if (!fp)
 			return -ENOENT;
 
-		if (!fp->f_op || !fp->f_op->readdir)
+		inode = fp->f_path.dentry->d_inode;
+
+		if ((!fp->f_op || !fp->f_op->readdir) &&
+		    (!inode->i_op || !inode->i_op->readdir))
 			goto out;
 
 		status = vfs_readdir(fp, filldir, dirent);
-		file->f_pos = fp->f_pos;
+		*pos = fp->f_pos;
 		if (status)
-			autofs4_copy_atime(file, fp);
+			autofs4_copy_atime(dentry->d_inode, inode);
 		return status;
 	}
 out:
-	return dcache_readdir(file, dirent, filldir);
+	return dcache_inode_readdir(dentry, pos, private, filldir, dirent);
 }
 
 static int autofs4_compare_dentry(struct dentry *parent, struct dentry *dentry, struct qstr *name)
Index: b/fs/cifs/inode.c
===================================================================
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -577,6 +577,7 @@ int cifs_get_inode_info(struct inode **p
 
 static const struct inode_operations cifs_ipc_inode_ops = {
 	.lookup = cifs_lookup,
+	.readdir = dcache_inode_readdir,
 };
 
 /* gets root inode */
Index: b/fs/hugetlbfs/inode.c
===================================================================
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -719,6 +719,7 @@ static const struct inode_operations hug
 	.symlink	= hugetlbfs_symlink,
 	.mkdir		= hugetlbfs_mkdir,
 	.rmdir		= simple_rmdir,
+	.readdir	= dcache_inode_readdir,
 	.mknod		= hugetlbfs_mknod,
 	.rename		= simple_rename,
 	.setattr	= hugetlbfs_setattr,
Index: b/fs/libfs.c
===================================================================
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -125,32 +125,33 @@ static inline unsigned char dt_type(stru
  * both impossible due to the lock on directory.
  */
 
-int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
+int dcache_inode_readdir(struct dentry *dentry, loff_t *pos,
+			 void *private_data,
+			 filldir_t filldir, void *dirent)
 {
-	struct dentry *dentry = filp->f_path.dentry;
-	struct dentry *cursor = filp->private_data;
+	struct dentry *cursor = private_data;
 	struct list_head *p, *q = &cursor->d_u.d_child;
 	ino_t ino;
-	int i = filp->f_pos;
+	int i = *pos;
 
 	switch (i) {
 		case 0:
 			ino = dentry->d_inode->i_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
-			filp->f_pos++;
+			(*pos)++;
 			i++;
 			/* fallthrough */
 		case 1:
 			ino = parent_ino(dentry);
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
-			filp->f_pos++;
+			(*pos)++;
 			i++;
 			/* fallthrough */
 		default:
 			spin_lock(&dcache_lock);
-			if (filp->f_pos == 2)
+			if ((*pos) == 2)
 				list_move(q, &dentry->d_subdirs);
 
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
@@ -160,21 +161,22 @@ int dcache_readdir(struct file * filp, v
 					continue;
 
 				spin_unlock(&dcache_lock);
-				if (filldir(dirent, next->d_name.name, 
-					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
+				if (filldir(dirent, next->d_name.name,
+					    next->d_name.len, *pos,
+					    next->d_inode->i_ino,
 					    dt_type(next->d_inode)) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
 				/* next is still alive */
 				list_move(q, p);
 				p = q;
-				filp->f_pos++;
+				(*pos)++;
 			}
 			spin_unlock(&dcache_lock);
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dcache_inode_readdir);
 
 ssize_t generic_read_dir(struct file *filp, char __user *buf, size_t siz, loff_t *ppos)
 {
@@ -186,12 +188,12 @@ const struct file_operations simple_dir_
 	.release	= dcache_dir_close,
 	.llseek		= dcache_dir_lseek,
 	.read		= generic_read_dir,
-	.readdir	= dcache_readdir,
 	.fsync		= simple_sync_file,
 };
 
 const struct inode_operations simple_dir_inode_operations = {
 	.lookup		= simple_lookup,
+	.readdir	= dcache_inode_readdir,
 };
 
 static const struct super_operations simple_super_operations = {
@@ -769,7 +771,6 @@ EXPORT_SYMBOL_GPL(generic_fh_to_parent);
 EXPORT_SYMBOL(dcache_dir_close);
 EXPORT_SYMBOL(dcache_dir_lseek);
 EXPORT_SYMBOL(dcache_dir_open);
-EXPORT_SYMBOL(dcache_readdir);
 EXPORT_SYMBOL(generic_read_dir);
 EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_write_begin);
Index: b/fs/ocfs2/dlm/dlmfs.c
===================================================================
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -553,6 +553,7 @@ static const struct inode_operations dlm
 	.lookup		= simple_lookup,
 	.mkdir		= dlmfs_mkdir,
 	.rmdir		= simple_rmdir,
+	.readdir	= dcache_inode_readdir,
 };
 
 static const struct super_operations dlmfs_ops = {
Index: b/fs/ramfs/inode.c
===================================================================
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -151,6 +151,7 @@ static const struct inode_operations ram
 	.symlink	= ramfs_symlink,
 	.mkdir		= ramfs_mkdir,
 	.rmdir		= simple_rmdir,
+	.readdir	= dcache_inode_readdir,
 	.mknod		= ramfs_mknod,
 	.rename		= simple_rename,
 };
Index: b/include/linux/fs.h
===================================================================
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1964,7 +1964,8 @@ extern void drop_super(struct super_bloc
 extern int dcache_dir_open(struct inode *, struct file *);
 extern int dcache_dir_close(struct inode *, struct file *);
 extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
-extern int dcache_readdir(struct file *, void *, filldir_t);
+extern int dcache_inode_readdir(struct dentry *, loff_t *, void *,
+				filldir_t , void *);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
Index: b/mm/shmem.c
===================================================================
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2389,6 +2389,7 @@ static const struct inode_operations shm
 	.symlink	= shmem_symlink,
 	.mkdir		= shmem_mkdir,
 	.rmdir		= shmem_rmdir,
+	.readdir	= dcache_inode_readdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
 #endif

-- 

