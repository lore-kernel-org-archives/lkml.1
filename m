Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXI0OND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXI0OND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbXI0OJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:56 -0400
Received: from ns2.suse.de ([195.135.220.15]:55091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbXI0OJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:45 -0400
Message-Id: <20070927141229.273280043@X40.localnet>
References: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:10 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 10/10] Make set_fs_{root,pwd} take a struct path
Content-Disposition: inline; filename=nameidata-path-7.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In nearly all cases the set_fs_{root,pwd}() calls work on a struct
path. Change the function to reflect this and use path_get() here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/namespace.c            |   26 ++++++++++++--------------
 fs/open.c                 |   12 ++++--------
 include/linux/fs_struct.h |    4 ++--
 3 files changed, 18 insertions(+), 24 deletions(-)

Index: b/fs/namespace.c
===================================================================
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1580,15 +1580,13 @@ out1:
  * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
  */
-void set_fs_root(struct fs_struct *fs, struct vfsmount *mnt,
-		 struct dentry *dentry)
+void set_fs_root(struct fs_struct *fs, struct path *path)
 {
 	struct path old_root;
 
 	write_lock(&fs->lock);
 	old_root = fs->root;
-	fs->root.mnt = mntget(mnt);
-	fs->root.dentry = dget(dentry);
+	fs->root = *path_get(path);
 	write_unlock(&fs->lock);
 	if (old_root.dentry)
 		path_put(&old_root);
@@ -1598,15 +1596,13 @@ void set_fs_root(struct fs_struct *fs, s
  * Replace the fs->{pwdmnt,pwd} with {mnt,dentry}. Put the old values.
  * It can block. Requires the big lock held.
  */
-void set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
-		struct dentry *dentry)
+void set_fs_pwd(struct fs_struct *fs, struct path *path)
 {
 	struct path old_pwd;
 
 	write_lock(&fs->lock);
 	old_pwd = fs->pwd;
-	fs->pwd.mnt = mntget(mnt);
-	fs->pwd.dentry = dget(dentry);
+	fs->pwd = *path_get(path);
 	write_unlock(&fs->lock);
 
 	if (old_pwd.dentry)
@@ -1627,12 +1623,10 @@ static void chroot_fs_refs(struct nameid
 			task_unlock(p);
 			if (fs->root.dentry == old_nd->path.dentry
 			    && fs->root.mnt == old_nd->path.mnt)
-				set_fs_root(fs, new_nd->path.mnt,
-					    new_nd->path.dentry);
+				set_fs_root(fs, &new_nd->path);
 			if (fs->pwd.dentry == old_nd->path.dentry
 			    && fs->pwd.mnt == old_nd->path.mnt)
-				set_fs_pwd(fs, new_nd->path.mnt,
-					   new_nd->path.dentry);
+				set_fs_pwd(fs, &new_nd->path);
 			put_fs_struct(fs);
 		} else
 			task_unlock(p);
@@ -1774,6 +1768,7 @@ static void __init init_mount_tree(void)
 {
 	struct vfsmount *mnt;
 	struct mnt_namespace *ns;
+	struct path root;
 
 	mnt = do_kern_mount("rootfs", 0, "rootfs", NULL);
 	if (IS_ERR(mnt))
@@ -1792,8 +1787,11 @@ static void __init init_mount_tree(void)
 	init_task.nsproxy->mnt_ns = ns;
 	get_mnt_ns(ns);
 
-	set_fs_pwd(current->fs, ns->root, ns->root->mnt_root);
-	set_fs_root(current->fs, ns->root, ns->root->mnt_root);
+	root.mnt = ns->root;
+	root.dentry = ns->root->mnt_root;
+
+	set_fs_pwd(current->fs, &root);
+	set_fs_root(current->fs, &root);
 }
 
 void __init mnt_init(unsigned long mempages)
Index: b/fs/open.c
===================================================================
--- a/fs/open.c
+++ b/fs/open.c
@@ -490,7 +490,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
+	set_fs_pwd(current->fs, &nd.path);
 
 dput_and_out:
 	path_put(&nd.path);
@@ -501,9 +501,7 @@ out:
 asmlinkage long sys_fchdir(unsigned int fd)
 {
 	struct file *file;
-	struct dentry *dentry;
 	struct inode *inode;
-	struct vfsmount *mnt;
 	int error;
 
 	error = -EBADF;
@@ -511,9 +509,7 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!file)
 		goto out;
 
-	dentry = file->f_path.dentry;
-	mnt = file->f_path.mnt;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	error = -ENOTDIR;
 	if (!S_ISDIR(inode->i_mode))
@@ -521,7 +517,7 @@ asmlinkage long sys_fchdir(unsigned int 
 
 	error = file_permission(file, MAY_EXEC);
 	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
 	fput(file);
 out:
@@ -545,7 +541,7 @@ asmlinkage long sys_chroot(const char __
 	if (!capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 
-	set_fs_root(current->fs, nd.path.mnt, nd.path.dentry);
+	set_fs_root(current->fs, &nd.path);
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
Index: b/include/linux/fs_struct.h
===================================================================
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -20,8 +20,8 @@ extern struct kmem_cache *fs_cachep;
 
 extern void exit_fs(struct task_struct *);
 extern void set_fs_altroot(void);
-extern void set_fs_root(struct fs_struct *, struct vfsmount *, struct dentry *);
-extern void set_fs_pwd(struct fs_struct *, struct vfsmount *, struct dentry *);
+extern void set_fs_root(struct fs_struct *, struct path *);
+extern void set_fs_pwd(struct fs_struct *, struct path *);
 extern struct fs_struct *copy_fs_struct(struct fs_struct *);
 extern void put_fs_struct(struct fs_struct *);
 

-- 

