Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYAIA4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYAIA4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYAIAyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:54:31 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:51868 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYAIAyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:54:22 -0500
Message-Id: <20080109005418.967825467@nttdata.co.jp>
References: <20080109005320.323184643@nttdata.co.jp>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 09:53:23 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #6 retry 03/21] Add wrapper functions for VFS helper functions.
X-OriginalArrivalTime: 09 Jan 2008 00:54:19.0615 (UTC) FILETIME=[2AA686F0:01C8525A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows LSM hooks refer previously associated "struct vfsmount"
parameter so that they can calculate pathname of given "struct dentry".

AppArmor's approach is to add "struct vfsmount" parameter to all related
functions, while my approach is to store "struct vfsmount" parameter
in "struct task_struct". My approach resembles to "syscall auditing" because
"syscall auditing" saves parameters at the entrance of a system call
in "struct audit_context" of "struct task_struct"
instead of adding parameters needed for auditing to all functions.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/fs.h |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

--- linux-2.6-mm.orig/include/linux/fs.h
+++ linux-2.6-mm/include/linux/fs.h
@@ -1081,6 +1081,116 @@ extern int vfs_rmdir(struct inode *, str
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
@@ -1558,6 +1668,21 @@ static inline int break_lease(struct ino
 
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
@@ -1718,6 +1843,19 @@ extern int permission(struct inode *, in
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
