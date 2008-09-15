Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYIOVKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYIOVKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYIOVGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:53 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64424 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbYIOVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:28 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 02/14] LSM/SELinux: inode_{get,set,notify}secctx hooks to access LSM security context information.
Date: Mon, 15 Sep 2008 16:41:06 -0400
Message-Id: <1221511278-28051-3-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces three new hooks. The inode_getsecctx hook is used to get
all relevant information from an LSM about an inode. The inode_setsecctx is
used to set both the in-core and on-disk state for the inode based on a context
derived from inode_getsecctx.The final hook inode_notifysecctx will notify the
LSM of a change for the in-core state of the inode in question. These hooks are
for use in the labeled NFS code and addresses concerns of how to set security
on an inode in a multi-xattr LSM. For historical reasons Stephen Smalley's
explanation of the reason for these hooks is pasted below.

Quote Stephen Smalley

inode_setsecctx:  Change the security context of an inode.  Updates the
in core security context managed by the security module and invokes the
fs code as needed (via __vfs_setxattr_noperm) to update any backing
xattrs that represent the context.  Example usage:  NFS server invokes
this hook to change the security context in its incore inode and on the
backing file system to a value provided by the client on a SETATTR
operation.

inode_notifysecctx:  Notify the security module of what the security
context of an inode should be.  Initializes the incore security context
managed by the security module for this inode.  Example usage:  NFS
client invokes this hook to initialize the security context in its
incore inode to the value provided by the server for the file when the
server returned the file's attributes to the client.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/security.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 security/security.c      |   18 ++++++++++++++++
 security/selinux/hooks.c |   25 +++++++++++++++++++++++
 3 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 80c4d00..8b5b041 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1289,6 +1289,36 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	audit_rule_init.
  *	@rule contains the allocated rule
  *
+ * @inode_notifysecctx:
+ *	Notify the security module of what the security context of an inode
+ *	should be.  Initializes the incore security context managed by the
+ *	security module for this inode.  Example usage:  NFS client invokes
+ *	this hook to initialize the security context in its incore inode to the
+ *	value provided by the server for the file when the server returned the
+ *	file's attributes to the client.
+ *
+ * 	@inode we wish to set the security context of.
+ * 	@ctx contains the string which we wish to set in the inode.
+ * 	@ctxlen contains the length of @ctx.
+ *
+ * @inode_setsecctx:
+ * 	Change the security context of an inode.  Updates the
+ * 	incore security context managed by the security module and invokes the
+ * 	fs code as needed (via __vfs_setxattr_noperm) to update any backing
+ * 	xattrs that represent the context.  Example usage:  NFS server invokes
+ * 	this hook to change the security context in its incore inode and on the
+ * 	backing filesystem to a value provided by the client on a SETATTR
+ * 	operation.
+ *
+ * 	@dentry contains the inode we wish to set the security context of.
+ * 	@ctx contains the string which we wish to set in the inode.
+ * 	@ctxlen contains the length of @ctx.
+ *
+ * @inode_getsecctx:
+ * 	Returns a string containing all relavent security context information
+ * 	@inode we wish to set the security context of.
+ *	@ctx is a pointer to place the allocated security context should be placed.
+ *	@ctxlen points to the place to put the length of @ctx.
  * This is the main security structure.
  */
 struct security_operations {
@@ -1479,6 +1509,10 @@ struct security_operations {
 	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx) (char *secdata, u32 seclen);
 
+	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
+	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
+	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
+
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect) (struct socket *sock,
 				    struct socket *other, struct sock *newsk);
@@ -1727,6 +1761,9 @@ int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(char *secdata, u32 seclen);
 
+int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
+int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
+int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
 #else /* CONFIG_SECURITY */
 struct security_mnt_opts {
 };
@@ -2458,6 +2495,19 @@ static inline int security_secctx_to_secid(const char *secdata,
 static inline void security_release_secctx(char *secdata, u32 seclen)
 {
 }
+
+static inline int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
+{
+	return -EOPNOTSUPP;
+}
+static inline int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+{
+	return -EOPNOTSUPP;
+}
+static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+{
+	return -EOPNOTSUPP;
+}
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/security/security.c b/security/security.c
index 3a4b4f5..d0fd42a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -869,6 +869,24 @@ void security_release_secctx(char *secdata, u32 seclen)
 }
 EXPORT_SYMBOL(security_release_secctx);
 
+int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
+{
+	return security_ops->inode_notifysecctx(inode, ctx, ctxlen);
+}
+EXPORT_SYMBOL(security_inode_notifysecctx);
+
+int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+{
+	return security_ops->inode_setsecctx(dentry, ctx, ctxlen);
+}
+EXPORT_SYMBOL(security_inode_setsecctx);
+
+int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+{
+	return security_ops->inode_getsecctx(inode, ctx, ctxlen);
+}
+EXPORT_SYMBOL(security_inode_getsecctx);
+
 #ifdef CONFIG_SECURITY_NETWORK
 
 int security_unix_stream_connect(struct socket *sock, struct socket *other,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 03fc6a8..b07871b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5285,6 +5285,28 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
 	kfree(secdata);
 }
 
+/*
+ *	This hook requires that the inode i_mutex be locked
+ */
+static int selinux_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
+{
+	return selinux_inode_setsecurity(inode, XATTR_SELINUX_SUFFIX, ctx, ctxlen, 0);
+}
+
+/*
+ *	This hook requires that the inode i_mutex be locked
+ */
+static int selinux_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
+{
+	return __vfs_setxattr_noperm(dentry, XATTR_NAME_SELINUX, ctx, ctxlen, 0);
+}
+
+static int selinux_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
+{
+	*ctxlen = selinux_inode_getsecurity(inode, XATTR_SELINUX_SUFFIX,
+						ctx, true);
+	return *ctxlen;
+}
 #ifdef CONFIG_KEYS
 
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
@@ -5491,6 +5513,9 @@ static struct security_operations selinux_ops = {
 	.secid_to_secctx =		selinux_secid_to_secctx,
 	.secctx_to_secid =		selinux_secctx_to_secid,
 	.release_secctx =		selinux_release_secctx,
+	.inode_notifysecctx =		selinux_inode_notifysecctx,
+	.inode_setsecctx =		selinux_inode_setsecctx,
+	.inode_getsecctx =		selinux_inode_getsecctx,
 
 	.unix_stream_connect =		selinux_socket_unix_stream_connect,
 	.unix_may_send =		selinux_socket_unix_may_send,
-- 
1.5.5.1

