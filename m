Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbXJVHCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbXJVHCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXJVHCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:02:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37988 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXJVHCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:02:11 -0400
Date: Mon, 22 Oct 2007 12:32:02 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] Make set_fs_{root,pwd} take a struct path
Message-ID: <20071022070202.GK6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

In nearly all cases the set_fs_{root,pwd}() calls work on a struct
path. Change the function to reflect this and use path_get() here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 fs/namespace.c            |   28 ++++++++++++++--------------
 fs/open.c                 |   12 ++++--------
 include/linux/fs_struct.h |    4 ++--
 3 files changed, 20 insertions(+), 24 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2040,15 +2040,14 @@ out1:
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
+	fs->root = *path;
+	path_get(path);
 	write_unlock(&fs->lock);
 	if (old_root.dentry)
 		path_put(&old_root);
@@ -2058,15 +2057,14 @@ void set_fs_root(struct fs_struct *fs, s
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
+	fs->pwd = *path;
+	path_get(path);
 	write_unlock(&fs->lock);
 
 	if (old_pwd.dentry)
@@ -2087,12 +2085,10 @@ static void chroot_fs_refs(struct nameid
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
@@ -2235,6 +2231,7 @@ static void __init init_mount_tree(void)
 {
 	struct vfsmount *mnt;
 	struct mnt_namespace *ns;
+	struct path root;
 
 	mnt = do_kern_mount("rootfs", 0, "rootfs", NULL);
 	if (IS_ERR(mnt))
@@ -2253,8 +2250,11 @@ static void __init init_mount_tree(void)
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
 
 void __init mnt_init(void)
--- a/fs/open.c
+++ b/fs/open.c
@@ -501,7 +501,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.path.mnt, nd.path.dentry);
+	set_fs_pwd(current->fs, &nd.path);
 
 dput_and_out:
 	path_put(&nd.path);
@@ -512,9 +512,7 @@ out:
 asmlinkage long sys_fchdir(unsigned int fd)
 {
 	struct file *file;
-	struct dentry *dentry;
 	struct inode *inode;
-	struct vfsmount *mnt;
 	int error;
 
 	error = -EBADF;
@@ -522,9 +520,7 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!file)
 		goto out;
 
-	dentry = file->f_path.dentry;
-	mnt = file->f_path.mnt;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	error = -ENOTDIR;
 	if (!S_ISDIR(inode->i_mode))
@@ -532,7 +528,7 @@ asmlinkage long sys_fchdir(unsigned int 
 
 	error = file_permission(file, MAY_EXEC);
 	if (!error)
-		set_fs_pwd(current->fs, mnt, dentry);
+		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
 	fput(file);
 out:
@@ -556,7 +552,7 @@ asmlinkage long sys_chroot(const char __
 	if (!capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 
-	set_fs_root(current->fs, nd.path.mnt, nd.path.dentry);
+	set_fs_root(current->fs, &nd.path);
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
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
 
