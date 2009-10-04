Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZJDMxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZJDMxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZJDMxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:53:36 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60038 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZJDMxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:53:31 -0400
Message-Id: <20091004125327.105675949@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sun, 04 Oct 2009 21:49:47 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #16 01/25] LSM: Add security_path_chmod() and security_path_chown().
Content-Disposition: inline; filename=lsm-add-chmod-chown-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows pathname based LSM modules to check chmod()/chown()
operations. Since notify_change() does not receive "struct vfsmount *",
we add security_path_chmod() and security_path_chown() to the caller of
notify_change().

These hooks are used by TOMOYO.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/open.c                |   24 ++++++++++++++++++++----
 include/linux/security.h |   30 ++++++++++++++++++++++++++++++
 security/capability.c    |   13 +++++++++++++
 security/security.c      |   15 +++++++++++++++
 4 files changed, 78 insertions(+), 4 deletions(-)

--- security-testing-2.6.orig/fs/open.c
+++ security-testing-2.6/fs/open.c
@@ -616,6 +616,9 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
 	err = mnt_want_write_file(file);
 	if (err)
 		goto out_putf;
+	err = security_path_chmod(dentry, file->f_vfsmnt, mode);
+	if (err)
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -623,6 +626,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
+out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out_putf:
 	fput(file);
@@ -645,6 +649,9 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, cons
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto dput_and_out;
+	error = security_path_chmod(path.dentry, path.mnt, mode);
+	if (error)
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -652,6 +659,7 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, cons
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
+out_drop_write:
 	mnt_drop_write(path.mnt);
 dput_and_out:
 	path_put(&path);
@@ -700,7 +708,9 @@ SYSCALL_DEFINE3(chown, const char __user
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(path.dentry, user, group);
+	error = security_path_chown(&path, user, group);
+	if (!error)
+		error = chown_common(path.dentry, user, group);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -725,7 +735,9 @@ SYSCALL_DEFINE5(fchownat, int, dfd, cons
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(path.dentry, user, group);
+	error = security_path_chown(&path, user, group);
+	if (!error)
+		error = chown_common(path.dentry, user, group);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -744,7 +756,9 @@ SYSCALL_DEFINE3(lchown, const char __use
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(path.dentry, user, group);
+	error = security_path_chown(&path, user, group);
+	if (!error)
+		error = chown_common(path.dentry, user, group);
 	mnt_drop_write(path.mnt);
 out_release:
 	path_put(&path);
@@ -767,7 +781,9 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd
 		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
+	error = security_path_chown(&file->f_path, user, group);
+	if (!error)
+		error = chown_common(dentry, user, group);
 	mnt_drop_write(file->f_path.mnt);
 out_fput:
 	fput(file);
--- security-testing-2.6.orig/include/linux/security.h
+++ security-testing-2.6/include/linux/security.h
@@ -447,6 +447,18 @@ static inline void security_free_mnt_opt
  *	@new_dir contains the path structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
  *	Return 0 if permission is granted.
+ * @path_chmod:
+ *	Check for permission to change DAC's permission of a file or directory.
+ *	@dentry contains the dentry structure.
+ *	@mnt contains the vfsmnt structure.
+ *	@mode contains DAC's mode.
+ *	Return 0 if permission is granted.
+ * @path_chown:
+ *	Check for permission to change owner/group of a file or directory.
+ *	@path contains the path structure.
+ *	@uid contains new owner's ID.
+ *	@gid contains new group's ID.
+ *	Return 0 if permission is granted.
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
  *	@dentry contains the dentry structure for the file link.
@@ -1488,6 +1500,9 @@ struct security_operations {
 			  struct dentry *new_dentry);
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
 			    struct path *new_dir, struct dentry *new_dentry);
+	int (*path_chmod) (struct dentry *dentry, struct vfsmount *mnt,
+			   mode_t mode);
+	int (*path_chown) (struct path *path, uid_t uid, gid_t gid);
 #endif
 
 	int (*inode_alloc_security) (struct inode *inode);
@@ -2952,6 +2967,9 @@ int security_path_link(struct dentry *ol
 		       struct dentry *new_dentry);
 int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 			 struct path *new_dir, struct dentry *new_dentry);
+int security_path_chmod(struct dentry *dentry, struct vfsmount *mnt,
+			mode_t mode);
+int security_path_chown(struct path *path, uid_t uid, gid_t gid);
 #else	/* CONFIG_SECURITY_PATH */
 static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
 {
@@ -3001,6 +3019,18 @@ static inline int security_path_rename(s
 {
 	return 0;
 }
+
+static inline int security_path_chmod(struct dentry *dentry,
+				      struct vfsmount *mnt,
+				      mode_t mode)
+{
+	return 0;
+}
+
+static inline int security_path_chown(struct path *path, uid_t uid, gid_t gid)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_PATH */
 
 #ifdef CONFIG_KEYS
--- security-testing-2.6.orig/security/capability.c
+++ security-testing-2.6/security/capability.c
@@ -308,6 +308,17 @@ static int cap_path_truncate(struct path
 {
 	return 0;
 }
+
+static int cap_path_chmod(struct dentry *dentry, struct vfsmount *mnt,
+			  mode_t mode)
+{
+	return 0;
+}
+
+static int cap_path_chown(struct path *path, uid_t uid, gid_t gid)
+{
+	return 0;
+}
 #endif
 
 static int cap_file_permission(struct file *file, int mask)
@@ -977,6 +988,8 @@ void security_fixup_ops(struct security_
 	set_to_cap_if_null(ops, path_link);
 	set_to_cap_if_null(ops, path_rename);
 	set_to_cap_if_null(ops, path_truncate);
+	set_to_cap_if_null(ops, path_chmod);
+	set_to_cap_if_null(ops, path_chown);
 #endif
 	set_to_cap_if_null(ops, file_permission);
 	set_to_cap_if_null(ops, file_alloc_security);
--- security-testing-2.6.orig/security/security.c
+++ security-testing-2.6/security/security.c
@@ -434,6 +434,21 @@ int security_path_truncate(struct path *
 		return 0;
 	return security_ops->path_truncate(path, length, time_attrs);
 }
+
+int security_path_chmod(struct dentry *dentry, struct vfsmount *mnt,
+			mode_t mode)
+{
+	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+		return 0;
+	return security_ops->path_chmod(dentry, mnt, mode);
+}
+
+int security_path_chown(struct path *path, uid_t uid, gid_t gid)
+{
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
+		return 0;
+	return security_ops->path_chown(path, uid, gid);
+}
 #endif
 
 int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)

-- 
