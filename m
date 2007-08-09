Return-Path: <linux-kernel-owner+w=401wt.eu-S966019AbXHIPby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966019AbXHIPby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939795AbXHIP34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:29:56 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:58901 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765244AbXHIP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:29:46 -0400
Message-Id: <20070809152901.762847172@szeredi.hu>
References: <20070809152744.519270818@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 17:27:46 +0200
From: miklos@szeredi.hu
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 2/4] pass open file to ->getattr()
Content-Disposition: inline; filename=vfs_getattr_file.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Pass the open file into the filesystem's ->getattr() method for
fstat().

This is needed to be able to correctly implement open-unlink-fstat
semantics in some filesystem such as sshfs, without having to resort
to "silly-renaming".

Do this by adding a 'struct file *' parameter to i_op->getattr().  For
fstat() pass the open file pointer, in other cases pass NULL.

This is safe from a compatibility standpoint, out-of-tree old stuff
will continue to work, but will get a warning at compile time.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/9p/vfs_inode.c
===================================================================
--- linux.orig/fs/9p/vfs_inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/9p/vfs_inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -706,7 +706,7 @@ done:
 
 static int
 v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		 struct kstat *stat)
+		 struct kstat *stat, struct file *file)
 {
 	int err;
 	struct v9fs_session_info *v9ses;
Index: linux/fs/afs/inode.c
===================================================================
--- linux.orig/fs/afs/inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/afs/inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -295,7 +295,7 @@ error_unlock:
  * read the attributes of an inode
  */
 int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		      struct kstat *stat)
+		      struct kstat *stat, struct file *file)
 {
 	struct inode *inode;
 
Index: linux/fs/afs/internal.h
===================================================================
--- linux.orig/fs/afs/internal.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/afs/internal.h	2007-08-09 16:48:45.000000000 +0200
@@ -548,7 +548,8 @@ extern struct inode *afs_iget(struct sup
 			      struct afs_callback *);
 extern void afs_zap_data(struct afs_vnode *);
 extern int afs_validate(struct afs_vnode *, struct key *);
-extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+		       struct file *);
 extern int afs_setattr(struct dentry *, struct iattr *);
 extern void afs_clear_inode(struct inode *);
 
Index: linux/fs/bad_inode.c
===================================================================
--- linux.orig/fs/bad_inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/bad_inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -250,7 +250,7 @@ static int bad_inode_permission(struct i
 }
 
 static int bad_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
-			struct kstat *stat)
+			struct kstat *stat, struct file *file)
 {
 	return -EIO;
 }
Index: linux/fs/cifs/cifsfs.h
===================================================================
--- linux.orig/fs/cifs/cifsfs.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/cifs/cifsfs.h	2007-08-09 16:48:45.000000000 +0200
@@ -55,7 +55,8 @@ extern int cifs_rmdir(struct inode *, st
 extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
 		       struct dentry *);
 extern int cifs_revalidate(struct dentry *);
-extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+			struct file *);
 extern int cifs_setattr(struct dentry *, struct iattr *);
 
 extern const struct inode_operations cifs_file_inode_ops;
Index: linux/fs/cifs/inode.c
===================================================================
--- linux.orig/fs/cifs/inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/cifs/inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -1332,7 +1332,7 @@ int cifs_revalidate(struct dentry *diren
 }
 
 int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-	struct kstat *stat)
+	struct kstat *stat, struct file *file)
 {
 	int err = cifs_revalidate(dentry);
 	if (!err) {
Index: linux/fs/coda/inode.c
===================================================================
--- linux.orig/fs/coda/inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/coda/inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -220,7 +220,8 @@ static void coda_clear_inode(struct inod
 	coda_cache_clear_inode(inode);
 }
 
-int coda_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int coda_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		 struct kstat *stat, struct file *file)
 {
 	int err = coda_revalidate_inode(dentry);
 	if (!err)
Index: linux/fs/fat/file.c
===================================================================
--- linux.orig/fs/fat/file.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/fat/file.c	2007-08-09 16:48:45.000000000 +0200
@@ -303,7 +303,8 @@ void fat_truncate(struct inode *inode)
 	fat_flush_inodes(inode->i_sb, inode, NULL);
 }
 
-int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-08-09 16:48:45.000000000 +0200
@@ -1056,7 +1056,7 @@ static int fuse_setattr(struct dentry *e
 }
 
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
-			struct kstat *stat)
+			struct kstat *stat, struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
Index: linux/fs/gfs2/ops_inode.c
===================================================================
--- linux.orig/fs/gfs2/ops_inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/gfs2/ops_inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -1030,7 +1030,7 @@ out:
  */
 
 static int gfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
-			struct kstat *stat)
+			struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
Index: linux/fs/libfs.c
===================================================================
--- linux.orig/fs/libfs.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/libfs.c	2007-08-09 16:48:45.000000000 +0200
@@ -12,7 +12,7 @@
 #include <asm/uaccess.h>
 
 int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		   struct kstat *stat)
+		   struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
Index: linux/fs/nfs/inode.c
===================================================================
--- linux.orig/fs/nfs/inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/nfs/inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -423,7 +423,8 @@ static void nfs_wake_up_inode(struct ino
 	wake_up_bit(&nfsi->flags, NFS_INO_REVALIDATING);
 }
 
-int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
Index: linux/fs/ocfs2/file.c
===================================================================
--- linux.orig/fs/ocfs2/file.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/ocfs2/file.c	2007-08-09 16:48:45.000000000 +0200
@@ -1086,7 +1086,8 @@ bail:
 
 int ocfs2_getattr(struct vfsmount *mnt,
 		  struct dentry *dentry,
-		  struct kstat *stat)
+		  struct kstat *stat,
+		  struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct super_block *sb = dentry->d_inode->i_sb;
Index: linux/fs/ocfs2/file.h
===================================================================
--- linux.orig/fs/ocfs2/file.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/ocfs2/file.h	2007-08-09 16:48:45.000000000 +0200
@@ -53,7 +53,7 @@ int ocfs2_lock_allocators(struct inode *
 			  struct ocfs2_alloc_context **meta_ac);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		  struct kstat *stat);
+		  struct kstat *stat, struct file *file);
 int ocfs2_permission(struct inode *inode, int mask,
 		     struct nameidata *nd);
 
Index: linux/fs/proc/base.c
===================================================================
--- linux.orig/fs/proc/base.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/proc/base.c	2007-08-09 16:48:45.000000000 +0200
@@ -1028,7 +1028,8 @@ out_unlock:
 	return NULL;
 }
 
-static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+static int pid_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		       struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
@@ -2584,7 +2585,8 @@ out_no_task:
 	return retval;
 }
 
-static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			     struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *p = get_proc_task(inode);
Index: linux/fs/proc/generic.c
===================================================================
--- linux.orig/fs/proc/generic.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/proc/generic.c	2007-08-09 16:48:45.000000000 +0200
@@ -255,7 +255,7 @@ out:
 }
 
 static int proc_getattr(struct vfsmount *mnt, struct dentry *dentry,
-			struct kstat *stat)
+			struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct proc_dir_entry *de = PROC_I(inode)->pde;
Index: linux/fs/proc/root.c
===================================================================
--- linux.orig/fs/proc/root.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/proc/root.c	2007-08-09 16:48:45.000000000 +0200
@@ -82,8 +82,8 @@ void __init proc_root_init(void)
 	proc_sys_init();
 }
 
-static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat
-)
+static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			     struct kstat *stat, struct file *file)
 {
 	generic_fillattr(dentry->d_inode, stat);
 	stat->nlink = proc_root.nlink + nr_processes();
Index: linux/fs/smbfs/inode.c
===================================================================
--- linux.orig/fs/smbfs/inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/smbfs/inode.c	2007-08-09 16:48:45.000000000 +0200
@@ -659,7 +659,8 @@ smb_statfs(struct dentry *dentry, struct
 	return result;
 }
 
-int smb_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int smb_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		struct kstat *stat, struct file *file)
 {
 	int err = smb_revalidate_inode(dentry);
 	if (!err)
Index: linux/fs/smbfs/proto.h
===================================================================
--- linux.orig/fs/smbfs/proto.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/smbfs/proto.h	2007-08-09 16:48:45.000000000 +0200
@@ -60,7 +60,8 @@ extern void smb_get_inode_attr(struct in
 extern void smb_set_inode_attr(struct inode *inode, struct smb_fattr *fattr);
 extern void smb_invalidate_inodes(struct smb_sb_info *server);
 extern int smb_revalidate_inode(struct dentry *dentry);
-extern int smb_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat);
+extern int smb_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		       struct kstat *stat, struct file *file);
 extern int smb_notify_change(struct dentry *dentry, struct iattr *attr);
 /* file.c */
 extern const struct address_space_operations smb_file_aops;
Index: linux/fs/stat.c
===================================================================
--- linux.orig/fs/stat.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/stat.c	2007-08-09 16:48:45.000000000 +0200
@@ -37,7 +37,8 @@ void generic_fillattr(struct inode *inod
 
 EXPORT_SYMBOL(generic_fillattr);
 
-int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+static int vfs_fgetattr(struct vfsmount *mnt, struct dentry *dentry,
+			struct kstat *stat, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int retval;
@@ -47,12 +48,17 @@ int vfs_getattr(struct vfsmount *mnt, st
 		return retval;
 
 	if (inode->i_op->getattr)
-		return inode->i_op->getattr(mnt, dentry, stat);
+		return inode->i_op->getattr(mnt, dentry, stat, file);
 
 	generic_fillattr(inode, stat);
 	return 0;
 }
 
+int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	return vfs_fgetattr(mnt, dentry, stat, NULL);
+}
+
 EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_stat_fd(int dfd, char __user *name, struct kstat *stat)
@@ -62,7 +68,7 @@ int vfs_stat_fd(int dfd, char __user *na
 
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.mnt, nd.dentry, stat);
+		error = vfs_fgetattr(nd.mnt, nd.dentry, stat, NULL);
 		path_release(&nd);
 	}
 	return error;
@@ -82,7 +88,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.mnt, nd.dentry, stat);
+		error = vfs_fgetattr(nd.mnt, nd.dentry, stat, NULL);
 		path_release(&nd);
 	}
 	return error;
@@ -101,7 +107,7 @@ int vfs_fstat(unsigned int fd, struct ks
 	int error = -EBADF;
 
 	if (f) {
-		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
+		error = vfs_fgetattr(f->f_path.mnt, f->f_path.dentry, stat, f);
 		fput(f);
 	}
 	return error;
Index: linux/fs/sysv/itree.c
===================================================================
--- linux.orig/fs/sysv/itree.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/sysv/itree.c	2007-08-09 16:48:45.000000000 +0200
@@ -440,7 +440,8 @@ static unsigned sysv_nblocks(struct supe
 	return blocks;
 }
 
-int sysv_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int sysv_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		 struct kstat *stat, struct file *file)
 {
 	struct super_block *s = mnt->mnt_sb;
 	generic_fillattr(dentry->d_inode, stat);
Index: linux/fs/sysv/sysv.h
===================================================================
--- linux.orig/fs/sysv/sysv.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/sysv/sysv.h	2007-08-09 16:48:45.000000000 +0200
@@ -145,7 +145,8 @@ extern int sysv_write_inode(struct inode
 extern int sysv_sync_inode(struct inode *);
 extern int sysv_sync_file(struct file *, struct dentry *, int);
 extern void sysv_set_inode(struct inode *, dev_t);
-extern int sysv_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int sysv_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+			struct file *);
 extern int sysv_init_icache(void);
 extern void sysv_destroy_icache(void);
 
Index: linux/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/xfs/linux-2.6/xfs_iops.c	2007-08-09 16:48:45.000000000 +0200
@@ -617,7 +617,8 @@ STATIC int
 xfs_vn_getattr(
 	struct vfsmount	*mnt,
 	struct dentry	*dentry,
-	struct kstat	*stat)
+	struct kstat	*stat,
+	struct file	*file)
 {
 	struct inode	*inode = dentry->d_inode;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
Index: linux/include/linux/coda_linux.h
===================================================================
--- linux.orig/include/linux/coda_linux.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/include/linux/coda_linux.h	2007-08-09 16:48:45.000000000 +0200
@@ -39,7 +39,8 @@ int coda_open(struct inode *i, struct fi
 int coda_release(struct inode *i, struct file *f);
 int coda_permission(struct inode *inode, int mask, struct nameidata *nd);
 int coda_revalidate_inode(struct dentry *);
-int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+		 struct file *);
 int coda_setattr(struct dentry *, struct iattr *);
 
 /* this file:  heloers */
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/include/linux/fs.h	2007-08-09 16:48:45.000000000 +0200
@@ -1210,7 +1210,8 @@ struct inode_operations {
 	void (*truncate) (struct inode *);
 	int (*permission) (struct inode *, int, struct nameidata *);
 	int (*setattr) (struct dentry *, struct iattr *);
-	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
+	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *,
+			struct file *file);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
@@ -1929,7 +1930,8 @@ extern int dcache_dir_open(struct inode 
 extern int dcache_dir_close(struct inode *, struct file *);
 extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
 extern int dcache_readdir(struct file *, void *, filldir_t);
-extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+			  struct file *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
Index: linux/include/linux/msdos_fs.h
===================================================================
--- linux.orig/include/linux/msdos_fs.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/include/linux/msdos_fs.h	2007-08-09 16:48:45.000000000 +0200
@@ -404,7 +404,7 @@ extern const struct inode_operations fat
 extern int fat_notify_change(struct dentry * dentry, struct iattr * attr);
 extern void fat_truncate(struct inode *inode);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		       struct kstat *stat);
+		       struct kstat *stat, struct file *file);
 
 /* fat/inode.c */
 extern void fat_attach(struct inode *inode, loff_t i_pos);
Index: linux/include/linux/nfs_fs.h
===================================================================
--- linux.orig/include/linux/nfs_fs.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/include/linux/nfs_fs.h	2007-08-09 16:48:45.000000000 +0200
@@ -285,7 +285,8 @@ extern struct inode *nfs_fhget(struct su
 				struct nfs_fattr *);
 extern int nfs_refresh_inode(struct inode *, struct nfs_fattr *);
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
-extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *,
+		       struct file *);
 extern int nfs_permission(struct inode *, int, struct nameidata *);
 extern int nfs_access_get_cached(struct inode *, struct rpc_cred *, struct nfs_access_entry *);
 extern void nfs_access_add_cache(struct inode *, struct nfs_access_entry *);
Index: linux/fs/reiser4/plugin/inode_ops.c
===================================================================
--- linux.orig/fs/reiser4/plugin/inode_ops.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/reiser4/plugin/inode_ops.c	2007-08-09 16:48:53.000000000 +0200
@@ -475,7 +475,8 @@ int reiser4_setattr_common(struct dentry
    inode_operations
 */
 int reiser4_getattr_common(struct vfsmount *mnt UNUSED_ARG,
-			   struct dentry *dentry, struct kstat *stat)
+			   struct dentry *dentry, struct kstat *stat,
+			   struct file *file UNUSED_ARG)
 {
 	struct inode *obj;
 
Index: linux/fs/reiser4/plugin/object.h
===================================================================
--- linux.orig/fs/reiser4/plugin/object.h	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/reiser4/plugin/object.h	2007-08-09 16:48:53.000000000 +0200
@@ -29,7 +29,7 @@ int reiser4_permission_common(struct ino
 			      struct nameidata *nameidata);
 int reiser4_setattr_common(struct dentry *, struct iattr *);
 int reiser4_getattr_common(struct vfsmount *mnt, struct dentry *,
-			   struct kstat *);
+			   struct kstat *, struct file *);
 
 /* common implementations of file operations */
 loff_t reiser4_llseek_dir_common(struct file *, loff_t off, int origin);
Index: linux/fs/revoked_inode.c
===================================================================
--- linux.orig/fs/revoked_inode.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/revoked_inode.c	2007-08-09 16:48:53.000000000 +0200
@@ -295,7 +295,7 @@ static int revoked_inode_permission(stru
 }
 
 static int revoked_inode_getattr(struct vfsmount *mnt, struct dentry *dentry,
-				 struct kstat *stat)
+				 struct kstat *stat, struct file *file)
 {
 	return -EBADF;
 }

--
