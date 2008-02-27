Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbYB0XXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbYB0XXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYB0XXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:23:04 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:48655 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbYB0XXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:23:03 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 02/11] Security: Add hook to calculate context based on a negative dentry.
Date: Wed, 27 Feb 2008 15:39:37 -0500
Message-Id: <1204144786-3502-3-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a time where we need to calculate a context without the
inode having been created yet. To do this we take the negative dentry and
calculate a context based on the process and the parent directory contexts.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/security.h |   11 +++++++++++
 security/dummy.c         |    7 +++++++
 security/security.c      |    9 +++++++++
 security/selinux/hooks.c |   38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index c80bee4..9038f34 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1264,6 +1264,8 @@ struct security_operations {
 	void (*sb_clone_mnt_opts) (const struct super_block *oldsb,
 				   struct super_block *newsb);
 
+	int (*dentry_init_security) (struct dentry *dentry, int mode,
+				     void **ctx, u32 *ctxlen);
 	int (*inode_alloc_security) (struct inode *inode);	
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
@@ -1528,6 +1530,7 @@ int security_sb_set_mnt_opts(struct super_block *sb, char **mount_options,
 void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb);
 
+int security_dentry_init_security(struct dentry *dentry, int mode, void **ctx, u32 *ctxlen);
 int security_inode_alloc(struct inode *inode);
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
@@ -1822,6 +1825,14 @@ static inline void security_sb_post_pivotroot (struct nameidata *old_nd,
 					       struct nameidata *new_nd)
 { }
 
+static inline int security_dentry_init_security(struct dentry *dentry,
+						 int mode,
+						 void **ctx,
+						 u32 *ctxlen)
+{
+	return 0;
+}
+
 static inline int security_inode_alloc (struct inode *inode)
 {
 	return 0;
diff --git a/security/dummy.c b/security/dummy.c
index 928ef41..d322c73 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -268,6 +268,12 @@ static void dummy_sb_clone_mnt_opts(const struct super_block *oldsb,
 	return;
 }
 
+static int dummy_dentry_init_security(struct dentry *dentry, int mode,
+				       void **ctx, u32 *ctxlen)
+{
+	return -EOPNOTSUPP;
+}
+
 static int dummy_inode_alloc_security (struct inode *inode)
 {
 	return 0;
@@ -1033,6 +1039,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, sb_get_mnt_opts);
 	set_to_dummy_if_null(ops, sb_set_mnt_opts);
 	set_to_dummy_if_null(ops, sb_clone_mnt_opts);
+	set_to_dummy_if_null(ops, dentry_init_security);
 	set_to_dummy_if_null(ops, inode_alloc_security);
 	set_to_dummy_if_null(ops, inode_free_security);
 	set_to_dummy_if_null(ops, inode_init_security);
diff --git a/security/security.c b/security/security.c
index 1a84eb1..b6e80bb 100644
--- a/security/security.c
+++ b/security/security.c
@@ -325,6 +325,15 @@ void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 	security_ops->sb_clone_mnt_opts(oldsb, newsb);
 }
 
+int security_dentry_init_security(struct dentry *dentry,
+						 int mode,
+						 void **ctx,
+						 u32 *ctxlen)
+{
+	return security_ops->dentry_init_security(dentry, mode, ctx, ctxlen);
+}
+EXPORT_SYMBOL(security_dentry_init_security);
+
 int security_inode_alloc(struct inode *inode)
 {
 	inode->i_security = NULL;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e7fc9c9..a56b21a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -63,6 +63,7 @@
 #include <linux/udp.h>
 #include <linux/dccp.h>
 #include <linux/quota.h>
+#include <linux/fsnotify.h>
 #include <linux/un.h>		/* for Unix socket types */
 #include <net/af_unix.h>	/* for Unix socket types */
 #include <linux/parser.h>
@@ -2358,6 +2359,42 @@ static int selinux_umount(struct vfsmount *mnt, int flags)
 
 /* inode security operations */
 
+/*
+ * For now, we need a way to compute a SID for
+ * a dentry as the inode is not yet available
+ * (and under NFSv4 has no label backed by an EA anyway.
+ */
+static int selinux_dentry_init_security(struct dentry *dentry, int mode,
+					void **ctx, u32 *ctxlen)
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
 static int selinux_inode_alloc_security(struct inode *inode)
 {
 	return inode_alloc_security(inode);
@@ -5257,6 +5294,7 @@ static struct security_operations selinux_ops = {
 	.sb_set_mnt_opts =		selinux_set_mnt_opts,
 	.sb_clone_mnt_opts = 		selinux_sb_clone_mnt_opts,
 
+	.dentry_init_security = 	selinux_dentry_init_security,
 	.inode_alloc_security =		selinux_inode_alloc_security,
 	.inode_free_security =		selinux_inode_free_security,
 	.inode_init_security =		selinux_inode_init_security,
-- 
1.5.3.8

