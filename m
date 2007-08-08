Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXHHNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXHHNa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934061AbXHHNam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:30:42 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:27394 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934041AbXHHNai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:30:38 -0400
X-YMail-OSG: pujzd8AVM1mSDPh0UBYyPJgB5cqen5cOWjJQ5WXyP0UEn0Cf_m_vySlBycnJQh7dGWaFjHB0t87p8YU87Fq3MICBnw--
Date: Wed, 8 Aug 2007 08:30:35 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: James Morris <jmorris@namei.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: file capabilities: clear fcaps on inode change (v3)
Message-ID: <20070808133034.GA2046@vino.hallyn.com>
References: <20070807221727.GA12211@sergelap.austin.ibm.com> <1186526285.6625.41.camel@heimdal.trondhjem.org> <20070807231452.GA27198@vino.hallyn.com> <Pine.LNX.4.64.0708071814520.32311@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708071814520.32311@us.intercode.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Tue, 7 Aug 2007, Serge E. Hallyn wrote:
> 
> > Yeah, I did that in v1, but didn't want to add two new security_ hooks.
> > But I'll send a v4 doing that.
> 
> Yep, add what's actually needed.
> 
> Continually having to jump through all of these hoops for LSM has gone 
> beyond ridiculous.

Here is the next version.  This one involved a bit more actual
switching of logic so was a bit more nerve-wracking, but it
seems to be working correctly now.

thanks,
-serge

>From 1f2270467d988a0dc5ab73b57c9ce5e4f178c5e1 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Tue, 7 Aug 2007 21:41:35 -0400
Subject: [PATCH 1/1] file capabilities: clear fcaps on inode change (v4)

When a file with posix capabilities is overwritten, the
file capabilities, like a setuid bit, should be removed.

This patch introduces security_inode_killpriv().  This is
currently only defined for capability, and is called when
an inode is changed to inform the security module that
it may want to clear out any privilege attached to that inode.
The capability module checks whether any file capabilities
are defined for the inode, and, if so, clears them.

Changelog:
	* Split security_inode_killpriv() into two hooks so as
	  to avoid grabbing inode->i_mutex needlessly in
	  generic_file_splice_write().
	* Removed needlock argument to killpriv, require
	  inode->i_mutex to be held when security_inode_killpriv()
	  is called.
	* Defined security_inode_killpriv to call killpriv() in
	  secondary_ops.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/attr.c                |    9 +++++++++
 fs/nfsd/vfs.c            |    4 ++--
 fs/open.c                |    3 ++-
 fs/splice.c              |   13 +++++++++----
 include/linux/fs.h       |    1 +
 include/linux/security.h |   28 ++++++++++++++++++++++++++++
 mm/filemap.c             |   14 ++++++++++----
 security/capability.c    |    2 ++
 security/commoncap.c     |   35 +++++++++++++++++++++++++++++++++++
 security/dummy.c         |   12 ++++++++++++
 security/security.c      |   10 ++++++++++
 security/selinux/hooks.c |   12 ++++++++++++
 12 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f8dfc22..ae58bd3 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -116,6 +116,15 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 		attr->ia_atime = now;
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	if (ia_valid & ATTR_KILL_PRIV) {
+		attr->ia_valid &= ~ATTR_KILL_PRIV;
+		ia_valid &= ~ATTR_KILL_PRIV;
+		error = security_inode_need_killpriv(dentry);
+		if (error > 0)
+			error = security_inode_killpriv(dentry);
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
index e36c003..ef95b48 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -824,13 +824,18 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
+	int killsuid, killpriv;
 	ssize_t ret;
-	int err;
+	int err = 0;
 
-	err = should_remove_suid(out->f_path.dentry);
-	if (unlikely(err)) {
+	killpriv = security_inode_need_killpriv(out->f_path.dentry);
+	killsuid = should_remove_suid(out->f_path.dentry);
+	if (unlikely(killsuid || killpriv)) {
 		mutex_lock(&inode->i_mutex);
-		err = __remove_suid(out->f_path.dentry, err);
+		if (killpriv)
+			err = security_inode_killpriv(out->f_path.dentry);
+		if (!err && killsuid)
+			err = __remove_suid(out->f_path.dentry, killsuid);
 		mutex_unlock(&inode->i_mutex);
 		if (err)
 			return err;
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
index 0a28da7..e38230f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -51,6 +51,8 @@ extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_need_killpriv(struct dentry *dentry);
+extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
@@ -417,6 +419,18 @@ struct request_sock;
  *	is specified by @buffer_size.  @buffer may be NULL to request
  *	the size of the buffer required.
  *	Returns number of bytes used/required on success.
+ * @inode_need_killpriv:
+ *	Called when an inode has been changed.
+ *	@dentry is the dentry being changed.
+ *	Return <0 on error to abort the inode change operation.
+ *	Return 0 if inode_killpriv does not need to be called.
+ *	Return >0 if inode_killpriv does need to be called.
+ * @inode_killpriv:
+ *	The setuid bit is being removed.  Remove similar security labels.
+ *	Called with the dentry->d_inode->i_mutex held.
+ *	@dentry is the dentry being changed.
+ *	Return 0 on success.  If error is returned, then the operation
+ *	causing setuid bit removal is failed.
  *
  * Security hooks for file operations
  *
@@ -1235,6 +1249,8 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_need_killpriv) (struct dentry *dentry);
+	int (*inode_killpriv) (struct dentry *dentry);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1490,6 +1506,8 @@ void security_inode_post_setxattr(struct dentry *dentry, char *name,
 int security_inode_getxattr(struct dentry *dentry, char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_need_killpriv(struct dentry *dentry);
+int security_inode_killpriv(struct dentry *dentry);
 const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1879,6 +1897,16 @@ static inline int security_inode_removexattr (struct dentry *dentry, char *name)
 	return cap_inode_removexattr(dentry, name);
 }
 
+static inline int security_inode_need_killpriv(struct dentry *dentry)
+{
+	return cap_inode_need_killpriv(dentry);
+}
+
+static inline int security_inode_killpriv(struct dentry *dentry)
+{
+	return cap_inode_killpriv(dentry);
+}
+
 static inline const char *security_inode_xattr_getsuffix (void)
 {
 	return NULL ;
diff --git a/mm/filemap.c b/mm/filemap.c
index c0774b5..915fd04 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1647,12 +1647,18 @@ int __remove_suid(struct dentry *dentry, int kill)
 
 int remove_suid(struct dentry *dentry)
 {
-	int kill = should_remove_suid(dentry);
+	int killsuid = should_remove_suid(dentry);
+	int killpriv = security_inode_need_killpriv(dentry);
+	int error = 0;
 
-	if (unlikely(kill))
-		return __remove_suid(dentry, kill);
+	if (killpriv < 0)
+		return killpriv;
+	if (killpriv)
+		error = security_inode_killpriv(dentry);
+	if (!error && killsuid)
+		error = __remove_suid(dentry, killsuid);
 
-	return 0;
+	return error;
 }
 EXPORT_SYMBOL(remove_suid);
 
diff --git a/security/capability.c b/security/capability.c
index dc2b66c..9e99f36 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -37,6 +37,8 @@ static struct security_operations capability_ops = {
 
 	.inode_setxattr =		cap_inode_setxattr,
 	.inode_removexattr =		cap_inode_removexattr,
+	.inode_need_killpriv =		cap_inode_need_killpriv,
+	.inode_killpriv =		cap_inode_killpriv,
 
 	.task_kill =			cap_task_kill,
 	.task_setscheduler =		cap_task_setscheduler,
diff --git a/security/commoncap.c b/security/commoncap.c
index aa6d929..7816cdc 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -119,6 +119,30 @@ static inline void bprm_clear_caps(struct linux_binprm *bprm)
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
+int cap_inode_need_killpriv(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	if (!inode->i_op || !inode->i_op->getxattr)
+	       return 0;
+
+	error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (error <= 0)
+		return 0;
+	return 1;
+}
+
+int cap_inode_killpriv(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!inode->i_op || !inode->i_op->removexattr)
+	       return 0;
+
+	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+}
+
 static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 				int size)
 {
@@ -185,6 +209,16 @@ out:
 }
 
 #else
+int cap_inode_need_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
+int cap_inode_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);
@@ -509,6 +543,7 @@ EXPORT_SYMBOL(cap_bprm_apply_creds);
 EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
+EXPORT_SYMBOL(cap_inode_killpriv);
 EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_kill);
 EXPORT_SYMBOL(cap_task_setscheduler);
diff --git a/security/dummy.c b/security/dummy.c
index 2d17040..5839faa 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -376,6 +376,16 @@ static int dummy_inode_removexattr (struct dentry *dentry, char *name)
 	return 0;
 }
 
+static int dummy_inode_need_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
+static int dummy_inode_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
 static int dummy_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
 	return -EOPNOTSUPP;
@@ -1017,6 +1027,8 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, inode_getxattr);
 	set_to_dummy_if_null(ops, inode_listxattr);
 	set_to_dummy_if_null(ops, inode_removexattr);
+	set_to_dummy_if_null(ops, inode_need_killpriv);
+	set_to_dummy_if_null(ops, inode_killpriv);
 	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
diff --git a/security/security.c b/security/security.c
index ebd71ad..335e1e1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -515,6 +515,16 @@ int security_inode_removexattr(struct dentry *dentry, char *name)
 	return security_ops->inode_removexattr(dentry, name);
 }
 
+int security_inode_need_killpriv(struct dentry *dentry)
+{
+	return security_ops->inode_need_killpriv(dentry);
+}
+
+int security_inode_killpriv(struct dentry *dentry)
+{
+	return security_ops->inode_killpriv(dentry);
+}
+
 const char *security_inode_xattr_getsuffix(void)
 {
 	return security_ops->inode_xattr_getsuffix();
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8df2c17..c49b514 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2453,6 +2453,16 @@ static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t
 	return len;
 }
 
+static int selinux_inode_need_killpriv(struct dentry *dentry)
+{
+	return secondary_ops->inode_need_killpriv(dentry);
+}
+
+static int selinux_inode_killpriv(struct dentry *dentry)
+{
+	return secondary_ops->inode_killpriv(dentry);
+}
+
 /* file security operations */
 
 static int selinux_file_permission(struct file *file, int mask)
@@ -4781,6 +4791,8 @@ static struct security_operations selinux_ops = {
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
+	.inode_need_killpriv =		selinux_inode_need_killpriv,
+	.inode_killpriv =		selinux_inode_killpriv,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
-- 
1.5.1.1.GIT

