Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYHFPln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYHFPln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbYHFPj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbYHFPjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/24] CRED: Make inode_has_perm() and file_has_perm() take a
	cred pointer [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:31 +0100
Message-ID: <20080806153831.14351.2400.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make inode_has_perm() and file_has_perm() take a cred pointer rather than a
task pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 security/selinux/hooks.c |  140 ++++++++++++++++++++++++++++++----------------
 1 files changed, 92 insertions(+), 48 deletions(-)


diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 27d1779..fb76940 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -172,16 +172,25 @@ static int cred_alloc_security(struct cred *cred)
 }
 
 /*
+ * get the security ID of a set of credentials
+ */
+static inline u32 cred_sid(const struct cred *cred)
+{
+	const struct task_security_struct *tsec;
+
+	tsec = cred->security;
+	return tsec->sid;
+}
+
+/*
  * get the security ID of a task
  */
 static inline u32 task_sid(const struct task_struct *task)
 {
-	const struct task_security_struct *tsec;
 	u32 sid;
 
 	rcu_read_lock();
-	tsec = __task_cred(task)->security;
-	sid = tsec->sid;
+	sid = cred_sid(__task_cred(task));
 	rcu_read_unlock();
 	return sid;
 }
@@ -196,6 +205,8 @@ static inline u32 current_sid(void)
 	return tsec->sid;
 }
 
+/* Allocate and free functions for each kind of security blob. */
+
 static int inode_alloc_security(struct inode *inode)
 {
 	struct inode_security_struct *isec;
@@ -1366,7 +1377,7 @@ static inline u32 signal_to_av(int sig)
 }
 
 /*
- * Check permission betweeen a pair of tasks, e.g. signal checks,
+ * Check permission between a pair of tasks, e.g. signal checks,
  * fork check, ptrace check, etc.
  * tsk1 is the actor and tsk2 is the target
  */
@@ -1429,7 +1440,7 @@ static int task_has_system(struct task_struct *tsk,
 /* Check whether a task has a particular permission to an inode.
    The 'adp' parameter is optional and allows other audit
    data to be passed (e.g. the dentry). */
-static int inode_has_perm(struct task_struct *tsk,
+static int inode_has_perm(const struct cred *cred,
 			  struct inode *inode,
 			  u32 perms,
 			  struct avc_audit_data *adp)
@@ -1441,7 +1452,7 @@ static int inode_has_perm(struct task_struct *tsk,
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	sid = task_sid(tsk);
+	sid = cred_sid(cred);
 	isec = inode->i_security;
 
 	if (!adp) {
@@ -1456,17 +1467,18 @@ static int inode_has_perm(struct task_struct *tsk,
 /* Same as inode_has_perm, but pass explicit audit data containing
    the dentry to help the auditing code to more easily generate the
    pathname if needed. */
-static inline int dentry_has_perm(struct task_struct *tsk,
+static inline int dentry_has_perm(const struct cred *cred,
 				  struct vfsmount *mnt,
 				  struct dentry *dentry,
 				  u32 av)
 {
 	struct inode *inode = dentry->d_inode;
 	struct avc_audit_data ad;
+
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.mnt = mnt;
 	ad.u.fs.path.dentry = dentry;
-	return inode_has_perm(tsk, inode, av, &ad);
+	return inode_has_perm(cred, inode, av, &ad);
 }
 
 /* Check whether a task can use an open file descriptor to
@@ -1477,14 +1489,14 @@ static inline int dentry_has_perm(struct task_struct *tsk,
    has the same SID as the process.  If av is zero, then
    access to the file is not checked, e.g. for cases
    where only the descriptor is affected like seek. */
-static int file_has_perm(struct task_struct *tsk,
-				struct file *file,
-				u32 av)
+static int file_has_perm(const struct cred *cred,
+			 struct file *file,
+			 u32 av)
 {
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct avc_audit_data ad;
-	u32 sid = task_sid(tsk);
+	u32 sid = cred_sid(cred);
 	int rc;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
@@ -1496,14 +1508,16 @@ static int file_has_perm(struct task_struct *tsk,
 				  FD__USE,
 				  &ad);
 		if (rc)
-			return rc;
+			goto out;
 	}
 
 	/* av is zero if only checking access to the descriptor. */
+	rc = 0;
 	if (av)
-		return inode_has_perm(tsk, inode, av, &ad);
+		rc = inode_has_perm(cred, inode, av, &ad);
 
-	return 0;
+out:
+	return rc;
 }
 
 /* Check whether a task can create a file. */
@@ -1662,13 +1676,13 @@ static inline int may_rename(struct inode *old_dir,
 }
 
 /* Check whether a task can perform a filesystem operation. */
-static int superblock_has_perm(struct task_struct *tsk,
+static int superblock_has_perm(const struct cred *cred,
 			       struct super_block *sb,
 			       u32 perms,
 			       struct avc_audit_data *ad)
 {
 	struct superblock_security_struct *sbsec;
-	u32 sid = task_sid(tsk);
+	u32 sid = cred_sid(cred);
 
 	sbsec = sb->s_security;
 	return avc_has_perm(sid, sbsec->sid, SECCLASS_FILESYSTEM, perms, ad);
@@ -1910,6 +1924,7 @@ static int selinux_sysctl(ctl_table *table, int op)
 
 static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
 {
+	const struct cred *cred = current_cred();
 	int rc = 0;
 
 	if (!sb)
@@ -1921,14 +1936,12 @@ static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
 	case Q_QUOTAOFF:
 	case Q_SETINFO:
 	case Q_SETQUOTA:
-		rc = superblock_has_perm(current, sb, FILESYSTEM__QUOTAMOD,
-					 NULL);
+		rc = superblock_has_perm(cred, sb, FILESYSTEM__QUOTAMOD, NULL);
 		break;
 	case Q_GETFMT:
 	case Q_GETINFO:
 	case Q_GETQUOTA:
-		rc = superblock_has_perm(current, sb, FILESYSTEM__QUOTAGET,
-					 NULL);
+		rc = superblock_has_perm(cred, sb, FILESYSTEM__QUOTAGET, NULL);
 		break;
 	default:
 		rc = 0;  /* let the kernel handle invalid cmds */
@@ -1939,7 +1952,9 @@ static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
 
 static int selinux_quota_on(struct dentry *dentry)
 {
-	return dentry_has_perm(current, NULL, dentry, FILE__QUOTAON);
+	const struct cred *cred = current_cred();
+
+	return dentry_has_perm(cred, NULL, dentry, FILE__QUOTAON);
 }
 
 static int selinux_syslog(int type)
@@ -2136,6 +2151,7 @@ extern struct dentry *selinux_null;
 /* Derived from fs/exec.c:flush_old_files. */
 static inline void flush_unauthorized_files(struct files_struct *files)
 {
+	const struct cred *cred = current_cred();
 	struct avc_audit_data ad;
 	struct file *file, *devnull = NULL;
 	struct tty_struct *tty;
@@ -2155,7 +2171,7 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 			   file may belong to another process and we are only
 			   interested in the inode-based check here. */
 			struct inode *inode = file->f_path.dentry->d_inode;
-			if (inode_has_perm(current, inode,
+			if (inode_has_perm(cred, inode,
 					   FILE__READ | FILE__WRITE, NULL)) {
 				drop_tty = 1;
 			}
@@ -2190,7 +2206,7 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 				file = fget(i);
 				if (!file)
 					continue;
-				if (file_has_perm(current,
+				if (file_has_perm(cred,
 						  file,
 						  file_to_av(file))) {
 					sys_close(i);
@@ -2462,6 +2478,7 @@ out:
 
 static int selinux_sb_kern_mount(struct super_block *sb, void *data)
 {
+	const struct cred *cred = current_cred();
 	struct avc_audit_data ad;
 	int rc;
 
@@ -2471,16 +2488,17 @@ static int selinux_sb_kern_mount(struct super_block *sb, void *data)
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.dentry = sb->s_root;
-	return superblock_has_perm(current, sb, FILESYSTEM__MOUNT, &ad);
+	return superblock_has_perm(cred, sb, FILESYSTEM__MOUNT, &ad);
 }
 
 static int selinux_sb_statfs(struct dentry *dentry)
 {
+	const struct cred *cred = current_cred();
 	struct avc_audit_data ad;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 	ad.u.fs.path.dentry = dentry->d_sb->s_root;
-	return superblock_has_perm(current, dentry->d_sb, FILESYSTEM__GETATTR, &ad);
+	return superblock_has_perm(cred, dentry->d_sb, FILESYSTEM__GETATTR, &ad);
 }
 
 static int selinux_mount(char *dev_name,
@@ -2489,6 +2507,7 @@ static int selinux_mount(char *dev_name,
 			 unsigned long flags,
 			 void *data)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 
 	rc = secondary_ops->sb_mount(dev_name, path, type, flags, data);
@@ -2496,22 +2515,23 @@ static int selinux_mount(char *dev_name,
 		return rc;
 
 	if (flags & MS_REMOUNT)
-		return superblock_has_perm(current, path->mnt->mnt_sb,
+		return superblock_has_perm(cred, path->mnt->mnt_sb,
 					   FILESYSTEM__REMOUNT, NULL);
 	else
-		return dentry_has_perm(current, path->mnt, path->dentry,
+		return dentry_has_perm(cred, path->mnt, path->dentry,
 				       FILE__MOUNTON);
 }
 
 static int selinux_umount(struct vfsmount *mnt, int flags)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 
 	rc = secondary_ops->sb_umount(mnt, flags);
 	if (rc)
 		return rc;
 
-	return superblock_has_perm(current, mnt->mnt_sb,
+	return superblock_has_perm(cred, mnt->mnt_sb,
 				   FILESYSTEM__UNMOUNT, NULL);
 }
 
@@ -2649,21 +2669,25 @@ static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dent
 
 static int selinux_inode_readlink(struct dentry *dentry)
 {
-	return dentry_has_perm(current, NULL, dentry, FILE__READ);
+	const struct cred *cred = current_cred();
+
+	return dentry_has_perm(cred, NULL, dentry, FILE__READ);
 }
 
 static int selinux_inode_follow_link(struct dentry *dentry, struct nameidata *nameidata)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 
 	rc = secondary_ops->inode_follow_link(dentry, nameidata);
 	if (rc)
 		return rc;
-	return dentry_has_perm(current, NULL, dentry, FILE__READ);
+	return dentry_has_perm(cred, NULL, dentry, FILE__READ);
 }
 
 static int selinux_inode_permission(struct inode *inode, int mask)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 
 	rc = secondary_ops->inode_permission(inode, mask);
@@ -2675,12 +2699,13 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 		return 0;
 	}
 
-	return inode_has_perm(current, inode,
+	return inode_has_perm(cred, inode,
 			       open_file_mask_to_av(inode->i_mode, mask), NULL);
 }
 
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 
 	rc = secondary_ops->inode_setattr(dentry, iattr);
@@ -2692,18 +2717,22 @@ static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 
 	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
 			       ATTR_ATIME_SET | ATTR_MTIME_SET))
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
 
-	return dentry_has_perm(current, NULL, dentry, FILE__WRITE);
+	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
 }
 
 static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
-	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
+	const struct cred *cred = current_cred();
+
+	return dentry_has_perm(cred, mnt, dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 {
+	const struct cred *cred = current_cred();
+
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof XATTR_SECURITY_PREFIX - 1)) {
 		if (!strcmp(name, XATTR_NAME_CAPS)) {
@@ -2718,7 +2747,7 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 
 	/* Not an attribute we recognize, so just check the
 	   ordinary setattr permission. */
-	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+	return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
 }
 
 static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
@@ -2803,12 +2832,16 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 
 static int selinux_inode_getxattr(struct dentry *dentry, const char *name)
 {
-	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
+	const struct cred *cred = current_cred();
+
+	return dentry_has_perm(cred, NULL, dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_listxattr(struct dentry *dentry)
 {
-	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
+	const struct cred *cred = current_cred();
+
+	return dentry_has_perm(cred, NULL, dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_removexattr(struct dentry *dentry, const char *name)
@@ -2919,6 +2952,7 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 	struct inode *inode = file->f_path.dentry->d_inode;
 
@@ -2931,7 +2965,7 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 	if ((file->f_flags & O_APPEND) && (mask & MAY_WRITE))
 		mask |= MAY_APPEND;
 
-	rc = file_has_perm(current, file,
+	rc = file_has_perm(cred, file,
 			   file_mask_to_av(inode->i_mode, mask));
 	if (rc)
 		return rc;
@@ -2971,6 +3005,7 @@ static void selinux_file_free_security(struct file *file)
 static int selinux_file_ioctl(struct file *file, unsigned int cmd,
 			      unsigned long arg)
 {
+	const struct cred *cred = current_cred();
 	u32 av = 0;
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
@@ -2980,11 +3015,13 @@ static int selinux_file_ioctl(struct file *file, unsigned int cmd,
 	if (!av)
 		av = FILE__IOCTL;
 
-	return file_has_perm(current, file, av);
+	return file_has_perm(cred, file, av);
 }
 
 static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
 {
+	const struct cred *cred = current_cred();
+
 #ifndef CONFIG_PPC32
 	if ((prot & PROT_EXEC) && (!file || (!shared && (prot & PROT_WRITE)))) {
 		/*
@@ -3009,7 +3046,7 @@ static int file_map_prot_check(struct file *file, unsigned long prot, int shared
 		if (prot & PROT_EXEC)
 			av |= FILE__EXECUTE;
 
-		return file_has_perm(current, file, av);
+		return file_has_perm(cred, file, av);
 	}
 	return 0;
 }
@@ -3038,6 +3075,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 				 unsigned long reqprot,
 				 unsigned long prot)
 {
+	const struct cred *cred = current_cred();
 	int rc;
 
 	rc = secondary_ops->file_mprotect(vma, reqprot, prot);
@@ -3066,7 +3104,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			 * modified content.  This typically should only
 			 * occur for text relocations.
 			 */
-			rc = file_has_perm(current, vma->vm_file,
+			rc = file_has_perm(cred, vma->vm_file,
 					   FILE__EXECMOD);
 		}
 		if (rc)
@@ -3079,12 +3117,15 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 
 static int selinux_file_lock(struct file *file, unsigned int cmd)
 {
-	return file_has_perm(current, file, FILE__LOCK);
+	const struct cred *cred = current_cred();
+
+	return file_has_perm(cred, file, FILE__LOCK);
 }
 
 static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 			      unsigned long arg)
 {
+	const struct cred *cred = current_cred();
 	int err = 0;
 
 	switch (cmd) {
@@ -3095,7 +3136,7 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 		}
 
 		if ((file->f_flags & O_APPEND) && !(arg & O_APPEND)) {
-			err = file_has_perm(current, file, FILE__WRITE);
+			err = file_has_perm(cred, file, FILE__WRITE);
 			break;
 		}
 		/* fall through */
@@ -3105,7 +3146,7 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 	case F_GETOWN:
 	case F_GETSIG:
 		/* Just check FD__USE permission */
-		err = file_has_perm(current, file, 0);
+		err = file_has_perm(cred, file, 0);
 		break;
 	case F_GETLK:
 	case F_SETLK:
@@ -3119,7 +3160,7 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 			err = -EINVAL;
 			break;
 		}
-		err = file_has_perm(current, file, FILE__LOCK);
+		err = file_has_perm(cred, file, FILE__LOCK);
 		break;
 	}
 
@@ -3160,11 +3201,14 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 
 static int selinux_file_receive(struct file *file)
 {
-	return file_has_perm(current, file, file_to_av(file));
+	const struct cred *cred = current_cred();
+
+	return file_has_perm(cred, file, file_to_av(file));
 }
 
 static int selinux_dentry_open(struct file *file)
 {
+	const struct cred *cred = current_cred();
 	struct file_security_struct *fsec;
 	struct inode *inode;
 	struct inode_security_struct *isec;
@@ -3188,7 +3232,7 @@ static int selinux_dentry_open(struct file *file)
 	 * new inode label or new policy.
 	 * This check is not redundant - do not remove.
 	 */
-	return inode_has_perm(current, inode, file_to_av(file), NULL);
+	return inode_has_perm(cred, inode, file_to_av(file), NULL);
 }
 
 /* task security operations */

