Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbXKPRij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbXKPRij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763099AbXKPRhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:37:07 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54622 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762650AbXKPRg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:36:59 -0500
Message-Id: <20071116173524.195366292@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 02:34:41 +0900
From: penguin-kernel@I-love.SAKURA.ne.jp
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #5 02/18] Add wrapper functions for VFS helper functions.
Content-Disposition: inline; filename=add-wrapper-functions-for-vfs-helper-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows LSM hooks refer previously associated "struct vfsmount" parameter
so that they can calculate pathname of given "struct dentry".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/fs.h |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

--- linux-2.6-mm.orig/include/linux/fs.h	2007-11-14 15:14:52.000000000 +0900
+++ linux-2.6-mm/include/linux/fs.h	2007-11-14 15:20:32.000000000 +0900
@@ -1086,6 +1086,116 @@ extern int vfs_rmdir(struct inode *, str
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 
+#include <linux/mount.h>
+#include <linux/sched.h>
+
+static inline int vfs_create2(struct inode *dir, struct dentry *dentry,
+			      int mode, struct nameidata *nd)
+{
+	int ret;
+	struct vfsmount *mnt = nd ? nd->path.mnt : NULL;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_create(dir, dentry, mode, nd);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_mkdir2(struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt, int mode)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_mkdir(dir, dentry, mode);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_mknod2(struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt, int mode, dev_t dev)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_mknod(dir, dentry, mode, dev);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_symlink2(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt, const char *oldname,
+			       int mode)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_symlink(dir, dentry, oldname, mode);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_link2(struct dentry *old_dentry, struct inode *dir,
+			    struct dentry *new_dentry, struct vfsmount *mnt)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_link(old_dentry, dir, new_dentry);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_rmdir2(struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_rmdir(dir, dentry);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_unlink2(struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_unlink(dir, dentry);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
+static inline int vfs_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			      struct inode *new_dir, struct dentry *new_dentry,
+			      struct vfsmount *mnt)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = vfs_rename(old_dir, old_dentry, new_dir, new_dentry);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
 /*
  * VFS dentry helper functions.
  */
@@ -1548,6 +1658,21 @@ static inline int break_lease(struct ino
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+
+static inline int do_truncate2(struct dentry *dentry, struct vfsmount *mnt,
+			       loff_t length, unsigned int time_attrs,
+			       struct file *filp)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = do_truncate(dentry, length, time_attrs, filp);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int);
@@ -1708,6 +1833,19 @@ extern int permission(struct inode *, in
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
+static inline int notify_change2(struct dentry *dentry, struct vfsmount *mnt,
+				 struct iattr *attr)
+{
+	int ret;
+	struct task_struct *task = current;
+	struct vfsmount *prev_mnt = task->last_vfsmount;
+	task->last_vfsmount = mntget(mnt);
+	ret = notify_change(dentry, attr);
+	task->last_vfsmount = prev_mnt;
+	mntput(mnt);
+	return ret;
+}
+
 extern int get_write_access(struct inode *);
 extern int deny_write_access(struct file *);
 static inline void put_write_access(struct inode * inode)

-- 
