Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXHFSwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXHFSwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXHFSwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:52:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46905 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbXHFSwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:52:34 -0400
Date: Mon, 6 Aug 2007 13:52:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
Message-ID: <20070806185231.GA21550@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1376764cbb54243f088cf00c39000c4f4418f461 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Mon, 6 Aug 2007 14:20:06 -0400
Subject: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)

When a file with posix capabilities is overwritten, the
file capabilities, like a setuid bit, should be removed.

This patch introduces security_inode_killpriv().  This is
currently only defined for capability, and is called when
an inode is changed to inform the security module that
it may want to clear out any privilege attached to that inode.
The capability module checks whether any file capabilities
are defined for the inode, and, if so, clears them.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/attr.c                |    7 +++++++
 fs/nfsd/vfs.c            |    4 ++--
 fs/open.c                |    3 ++-
 fs/splice.c              |    4 ++++
 include/linux/fs.h       |    1 +
 include/linux/security.h |   18 ++++++++++++++++++
 mm/filemap.c             |    5 +++++
 security/capability.c    |    1 +
 security/commoncap.c     |   27 +++++++++++++++++++++++++++
 security/dummy.c         |    6 ++++++
 security/security.c      |    5 +++++
 11 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..f3b4c6d 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -116,6 +116,13 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 		attr->ia_atime = now;
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	if (ia_valid & ATTR_KILL_PRIV) {
+		attr->ia_valid &= ~ATTR_KILL_PRIV;
+		ia_valid &= ~ATTR_KILL_PRIV;
+		error = security_inode_killpriv(dentry, LSM_NO_LOCK);
+		if (error)
+			return error;
+	}
 	if (ia_valid & ATTR_KILL_SUID) {
 		attr->ia_valid &= ~ATTR_KILL_SUID;
 		if (mode & S_ISUID) {
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ee96a89..33d1476 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -364,7 +364,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 
 	/* Revoke setuid/setgid bit on chown/chgrp */
 	if ((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid)
-		iap->ia_valid |= ATTR_KILL_SUID;
+		iap->ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV;
 	if ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid)
 		iap->ia_valid |= ATTR_KILL_SGID;
 
@@ -921,7 +921,7 @@ out:
 static void kill_suid(struct dentry *dentry)
 {
 	struct iattr	ia;
-	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID;
+	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	notify_change(dentry, &ia);
diff --git a/fs/open.c b/fs/open.c
index 0e2e7b1..23f334d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -658,7 +658,8 @@ static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
 		newattrs.ia_gid = group;
 	}
 	if (!S_ISDIR(inode->i_mode))
-		newattrs.ia_valid |= ATTR_KILL_SUID|ATTR_KILL_SGID;
+		newattrs.ia_valid |=
+			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/splice.c b/fs/splice.c
index e36c003..e2102ce 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -827,6 +827,10 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	ssize_t ret;
 	int err;
 
+	err = security_inode_killpriv(out->f_path.dentry, LSM_NEED_LOCK);
+	if (err)
+		return err;
+
 	err = should_remove_suid(out->f_path.dentry);
 	if (unlikely(err)) {
 		mutex_lock(&inode->i_mutex);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3d99c04..609c40a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -335,6 +335,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_KILL_SUID	2048
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
+#define ATTR_KILL_PRIV	16384
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
diff --git a/include/linux/security.h b/include/linux/security.h
index 0a28da7..39411b1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -51,6 +51,7 @@ extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_killpriv(struct dentry *dentry, int needlock);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
@@ -102,6 +103,9 @@ struct request_sock;
 #define LSM_UNSAFE_PTRACE	2
 #define LSM_UNSAFE_PTRACE_CAP	4
 
+#define LSM_NO_LOCK 0
+#define LSM_NEED_LOCK 1
+
 #ifdef CONFIG_SECURITY
 
 /**
@@ -417,6 +421,13 @@ struct request_sock;
  *	is specified by @buffer_size.  @buffer may be NULL to request
  *	the size of the buffer required.
  *	Returns number of bytes used/required on success.
+ * @inode_killpriv:
+ *	The setuid bit is being removed.  Remove similar security labels.
+ *	@dentry is the dentry being changed.
+ *	@needlock is 0 if the inode is locked, 1 if the LSM needs to lock
+ *	it.
+ *	Return 0 on success.  If error is returned, then the operation
+ *	causing setuid bit removal is failed.
  *
  * Security hooks for file operations
  *
@@ -1235,6 +1246,7 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_killpriv) (struct dentry *dentry, int needlock);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1490,6 +1502,7 @@ void security_inode_post_setxattr(struct dentry *dentry, char *name,
 int security_inode_getxattr(struct dentry *dentry, char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_killpriv(struct dentry *dentry, int needlock);
 const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1879,6 +1892,11 @@ static inline int security_inode_removexattr (struct dentry *dentry, char *name)
 	return cap_inode_removexattr(dentry, name);
 }
 
+static inline int security_inode_killpriv(struct dentry *dentry, int needlock)
+{
+	return cap_inode_killpriv(dentry, needlock);
+}
+
 static inline const char *security_inode_xattr_getsuffix (void)
 {
 	return NULL ;
diff --git a/mm/filemap.c b/mm/filemap.c
index c0774b5..2a06291 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1648,6 +1648,11 @@ int __remove_suid(struct dentry *dentry, int kill)
 int remove_suid(struct dentry *dentry)
 {
 	int kill = should_remove_suid(dentry);
+	int error;
+
+	error = security_inode_killpriv(dentry, LSM_NO_LOCK);
+	if (error)
+		return error;
 
 	if (unlikely(kill))
 		return __remove_suid(dentry, kill);
diff --git a/security/capability.c b/security/capability.c
index dc2b66c..e23864e 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -37,6 +37,7 @@ static struct security_operations capability_ops = {
 
 	.inode_setxattr =		cap_inode_setxattr,
 	.inode_removexattr =		cap_inode_removexattr,
+	.inode_removexattr =		cap_inode_killpriv,
 
 	.task_kill =			cap_task_kill,
 	.task_setscheduler =		cap_task_setscheduler,
diff --git a/security/commoncap.c b/security/commoncap.c
index aa6d929..12d1fa3 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -119,6 +119,27 @@ static inline void bprm_clear_caps(struct linux_binprm *bprm)
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
+int cap_inode_killpriv(struct dentry *dentry, int needlock)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	if (!inode->i_op || !inode->i_op->getxattr || !inode->i_op->removexattr)
+	       return 0;
+
+	error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (error <= 0)
+		return 0;
+
+	if (needlock)
+		mutex_lock(&inode->i_mutex);
+	error = inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+	if (needlock)
+		mutex_unlock(&inode->i_mutex);
+
+	return error;
+}
+
 static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 				int size)
 {
@@ -185,6 +206,11 @@ out:
 }
 
 #else
+int cap_inode_killpriv(struct dentry *dentry, int needlock)
+{
+	return 0;
+}
+
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);
@@ -509,6 +535,7 @@ EXPORT_SYMBOL(cap_bprm_apply_creds);
 EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
+EXPORT_SYMBOL(cap_inode_killpriv);
 EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_kill);
 EXPORT_SYMBOL(cap_task_setscheduler);
diff --git a/security/dummy.c b/security/dummy.c
index 2d17040..4f6927a 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -376,6 +376,11 @@ static int dummy_inode_removexattr (struct dentry *dentry, char *name)
 	return 0;
 }
 
+static int dummy_inode_killpriv(struct dentry *dentry, int needlock)
+{
+	return 0;
+}
+
 static int dummy_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
 	return -EOPNOTSUPP;
@@ -1017,6 +1022,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, inode_getxattr);
 	set_to_dummy_if_null(ops, inode_listxattr);
 	set_to_dummy_if_null(ops, inode_removexattr);
+	set_to_dummy_if_null(ops, inode_killpriv);
 	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
diff --git a/security/security.c b/security/security.c
index ebd71ad..c1b91d5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -515,6 +515,11 @@ int security_inode_removexattr(struct dentry *dentry, char *name)
 	return security_ops->inode_removexattr(dentry, name);
 }
 
+int security_inode_killpriv(struct dentry *dentry, int needlock)
+{
+	return security_ops->inode_killpriv(dentry, needlock);
+}
+
 const char *security_inode_xattr_getsuffix(void)
 {
 	return security_ops->inode_xattr_getsuffix();
-- 
1.5.1.1.GIT

