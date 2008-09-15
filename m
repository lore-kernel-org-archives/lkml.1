Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYIOVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYIOVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYIOVGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:33 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64414 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYIOVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:27 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 03/14] Security: Add hook to calculate context based on a negative dentry.
Date: Mon, 15 Sep 2008 16:41:07 -0400
Message-Id: <1221511278-28051-4-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a time where we need to calculate a context without the
inode having been created yet. To do this we take the negative dentry and
calculate a context based on the process and the parent directory contexts.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/security.h |   14 ++++++++++++++
 security/security.c      |    7 +++++++
 security/selinux/hooks.c |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 8b5b041..42b9128 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1379,6 +1379,9 @@ struct security_operations {
 	void (*sb_clone_mnt_opts) (const struct super_block *oldsb,
 				   struct super_block *newsb);
 	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
+	int (*dentry_init_security) (struct dentry *dentry, int mode,
+				     void **ctx, u32 *ctxlen);
+
 
 	int (*inode_alloc_security) (struct inode *inode);
 	void (*inode_free_security) (struct inode *inode);
@@ -1651,6 +1654,8 @@ int security_sb_set_mnt_opts(struct super_block *sb, struct security_mnt_opts *o
 void security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				struct super_block *newsb);
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
+int security_dentry_init_security (struct dentry *dentry, int mode,
+				   void **ctx, u32 *ctxlen);
 
 int security_inode_alloc(struct inode *inode);
 void security_inode_free(struct inode *inode);
@@ -1994,6 +1999,15 @@ static inline int security_inode_alloc(struct inode *inode)
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
diff --git a/security/security.c b/security/security.c
index d0fd42a..b22a110 100644
--- a/security/security.c
+++ b/security/security.c
@@ -349,6 +349,13 @@ void security_inode_free(struct inode *inode)
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
index b07871b..680db1d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2504,6 +2504,41 @@ static void selinux_inode_free_security(struct inode *inode)
 	inode_free_security(inode);
 }
 
+/*
+ * For now, we need a way to compute a SID for
+ * a dentry as the inode is not yet available
+ * (and under NFSv4 has no label backed by an EA anyway.
+ */
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
@@ -5413,6 +5448,7 @@ static struct security_operations selinux_ops = {
 	.sb_clone_mnt_opts =		selinux_sb_clone_mnt_opts,
 	.sb_parse_opts_str = 		selinux_parse_opts_str,
 
+	.dentry_init_security =		selinux_dentry_init_security,
 
 	.inode_alloc_security =		selinux_inode_alloc_security,
 	.inode_free_security =		selinux_inode_free_security,
-- 
1.5.5.1

