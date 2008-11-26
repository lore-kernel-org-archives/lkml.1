Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYLAQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYLAQop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYLAQkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:33 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:34890 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYLAQjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:55 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 04/14] Security: Add hook to calculate context based on a negative dentry.
Date: Wed, 26 Nov 2008 16:03:04 -0500
Message-Id: <1227733394-1114-5-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a time where we need to calculate a context without the
inode having been created yet. To do this we take the negative dentry and
calculate a context based on the process and the parent directory contexts.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/security.h |   22 ++++++++++++++++++++++
 security/capability.c    |    6 ++++++
 security/security.c      |    7 +++++++
 security/selinux/hooks.c |   31 +++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 7229ef1..ccbfb06 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -301,6 +301,14 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Parse a string of security data filling in the opts structure
  *	@options string containing all mount options known by the LSM
  *	@opts binary data structure usable by the LSM
+ * @dentry_init_security:
+ *	Compute a context for a dentry as the inode is not yet available
+ * 	since NFSv4 has no label backed by an EA anyway.
+ * 	@dentry dentry to use in calculating the context.
+ * 	@mode mode used to determine resource type.
+ * 	@ctx pointer to place the pointer to the resulting context in.
+ * 	@ctxlen point to place the length of the resulting context.
+ *
  *
  * Security hooks for inode operations.
  *
@@ -1384,6 +1392,9 @@ struct security_operations {
 	void (*sb_clone_mnt_opts) (const struct super_block *oldsb,
 				   struct super_block *newsb);
 	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
+	int (*dentry_init_security) (struct dentry *dentry, int mode,
+				     void **ctx, u32 *ctxlen);
+
 
 	int (*inode_alloc_security) (struct inode *inode);
 	void (*inode_free_security) (struct inode *inode);
@@ -1652,6 +1663,8 @@ int security_sb_set_mnt_opts(struct super_block *sb, struct security_mnt_opts *o
 void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb);
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
+int security_dentry_init_security (struct dentry *dentry, int mode,
+				   void **ctx, u32 *ctxlen);
 
 int security_inode_alloc(struct inode *inode);
 void security_inode_free(struct inode *inode);
@@ -2000,6 +2013,15 @@ static inline int security_inode_alloc(struct inode *inode)
 static inline void security_inode_free(struct inode *inode)
 { }
 
+static inline int security_dentry_init_security (struct dentry *dentry,
+						 int mode,
+						 void **ctx,
+						 u32 *ctxlen)
+{
+	return -EOPNOTSUPP;
+}
+
+
 static inline int security_inode_init_security(struct inode *inode,
 						struct inode *dir,
 						char **name,
diff --git a/security/capability.c b/security/capability.c
index 27985c5..6d38303 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -139,6 +139,11 @@ static int cap_sb_parse_opts_str(char *options, struct security_mnt_opts *opts)
 	return 0;
 }
 
+static int cap_dentry_init_security(struct dentry *dentry, int mode, void **ctx, u32 *ctxlen)
+{
+	return 0;
+}
+
 static int cap_inode_alloc_security(struct inode *inode)
 {
 	return 0;
@@ -863,6 +868,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, sb_set_mnt_opts);
 	set_to_cap_if_null(ops, sb_clone_mnt_opts);
 	set_to_cap_if_null(ops, sb_parse_opts_str);
+	set_to_cap_if_null(ops, dentry_init_security);
 	set_to_cap_if_null(ops, inode_alloc_security);
 	set_to_cap_if_null(ops, inode_free_security);
 	set_to_cap_if_null(ops, inode_init_security);
diff --git a/security/security.c b/security/security.c
index 1d8d3b0..ab978bf 100644
--- a/security/security.c
+++ b/security/security.c
@@ -358,6 +358,13 @@ void security_inode_free(struct inode *inode)
 	security_ops->inode_free_security(inode);
 }
 
+int security_dentry_init_security (struct dentry *dentry, int mode,
+				   void **ctx, u32 *ctxlen)
+{
+	return security_ops->dentry_init_security (dentry, mode, ctx, ctxlen);
+}
+EXPORT_SYMBOL(security_dentry_init_security);
+
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7ed038c..dcd6d50 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2502,6 +2502,36 @@ static void selinux_inode_free_security(struct inode *inode)
 	inode_free_security(inode);
 }
 
+static int selinux_dentry_init_security(struct dentry *dentry, int mode, void **ctx, u32 *ctxlen)
+{
+	struct task_security_struct *tsec;
+	struct inode_security_struct *dsec;
+	struct superblock_security_struct *sbsec;
+	struct inode *dir = dentry->d_parent->d_inode;
+	u32 newsid;
+	int rc;
+
+	tsec = current->security;
+	dsec = dir->i_security;
+	sbsec = dir->i_sb->s_security;
+
+	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
+		newsid = tsec->create_sid;
+	} else {
+		rc = security_transition_sid(tsec->sid, dsec->sid,
+					     inode_mode_to_security_class(mode),
+					     &newsid);
+		if (rc) {
+			printk(KERN_WARNING "%s:  "
+			       "security_transition_sid failed, rc=%d\n",
+			       __FUNCTION__, -rc);
+			return rc;
+		}
+	}
+
+	return security_sid_to_context(newsid, (char **)ctx, ctxlen);
+}
+
 static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 				       char **name, void **value,
 				       size_t *len)
@@ -5527,6 +5557,7 @@ static struct security_operations selinux_ops = {
 	.sb_clone_mnt_opts =		selinux_sb_clone_mnt_opts,
 	.sb_parse_opts_str = 		selinux_parse_opts_str,
 
+	.dentry_init_security =		selinux_dentry_init_security,
 
 	.inode_alloc_security =		selinux_inode_alloc_security,
 	.inode_free_security =		selinux_inode_free_security,
-- 
1.5.5.1

