Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYLAQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYLAQoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYLAQkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:40:25 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:34872 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYLAQjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:39:54 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 05/14] Security: Add Hook to test if the particular xattr is part of a MAC model.
Date: Wed, 26 Nov 2008 16:03:05 -0500
Message-Id: <1227733394-1114-6-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are areas in the Labeled NFS code where where we need to test if the
attribute being requested exhibits the semantics of a MAC model. This allows us
to make sure that we get the desired semantics from the attribute instead of
something else such as capabilities or a time based LSM.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 include/linux/security.h   |   11 +++++++++++
 security/capability.c      |    6 ++++++
 security/security.c        |    6 ++++++
 security/selinux/hooks.c   |    6 ++++++
 security/smack/smack_lsm.c |   10 ++++++++++
 5 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ccbfb06..5eac603 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1252,6 +1252,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@pages contains the number of pages.
  *	Return 0 if permission is granted.
  *
+ * @ismaclabel:
+ * 	Check if the extended attribute specified by @name represents a MAC label.
+ * 	@name full extended attribute name to check against LSM as a MAC label.
+ *
  * @secid_to_secctx:
  *	Convert secid to security context.
  *	@secid contains the security ID.
@@ -1521,6 +1525,7 @@ struct security_operations {
 
 	int (*getprocattr) (struct task_struct *p, char *name, char **value);
 	int (*setprocattr) (struct task_struct *p, char *name, void *value, size_t size);
+	int (*ismaclabel) (const char * name);
 	int (*secid_to_secctx) (u32 secid, char **secdata, u32 *seclen);
 	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx) (char *secdata, u32 seclen);
@@ -1771,6 +1776,7 @@ int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_netlink_recv(struct sk_buff *skb, int cap);
+int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -2489,6 +2495,11 @@ static inline int security_netlink_recv(struct sk_buff *skb, int cap)
 	return cap_netlink_recv(skb, cap);
 }
 
+static inline int security_ismaclabel(const char *name)
+{
+	return 0;
+}
+
 static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
diff --git a/security/capability.c b/security/capability.c
index 6d38303..ed24c60 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -740,6 +740,11 @@ static int cap_setprocattr(struct task_struct *p, char *name, void *value,
 	return -EINVAL;
 }
 
+static int cap_ismaclabel(const char *name)
+{
+	return 0;
+}
+
 static int cap_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
@@ -957,6 +962,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, d_instantiate);
 	set_to_cap_if_null(ops, getprocattr);
 	set_to_cap_if_null(ops, setprocattr);
+	set_to_cap_if_null(ops, ismaclabel);
 	set_to_cap_if_null(ops, secid_to_secctx);
 	set_to_cap_if_null(ops, secctx_to_secid);
 	set_to_cap_if_null(ops, release_secctx);
diff --git a/security/security.c b/security/security.c
index ab978bf..d3194e1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -867,6 +867,12 @@ int security_netlink_recv(struct sk_buff *skb, int cap)
 }
 EXPORT_SYMBOL(security_netlink_recv);
 
+int security_ismaclabel(const char *name)
+{
+	return security_ops->ismaclabel(name);
+}
+EXPORT_SYMBOL(security_ismaclabel);
+
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return security_ops->secid_to_secctx(secid, secdata, seclen);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index dcd6d50..60d6bcc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5414,6 +5414,11 @@ boundary_ok:
 	return size;
 }
 
+static int selinux_ismaclabel(const char *name)
+{
+	return (strcmp(name,XATTR_NAME_SELINUX) == 0);
+}
+
 static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return security_sid_to_context(secid, secdata, seclen);
@@ -5655,6 +5660,7 @@ static struct security_operations selinux_ops = {
 	.getprocattr =			selinux_getprocattr,
 	.setprocattr =			selinux_setprocattr,
 
+	.ismaclabel =			selinux_ismaclabel,
 	.secid_to_secctx =		selinux_secid_to_secctx,
 	.secctx_to_secid =		selinux_secctx_to_secid,
 	.release_secctx =		selinux_release_secctx,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6e2dc0b..49a2ca7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2529,6 +2529,15 @@ static void smack_audit_rule_free(void *vrule)
 #endif /* CONFIG_AUDIT */
 
 /*
+ * smack_ismaclabel - check if xattr @name references a smack MAC label
+ * @name: Full xattr name to check.
+ */
+static int smack_ismaclabel(const char *name)
+{
+	return (strcmp(name, XATTR_NAME_SMACK) == 0);
+}
+
+/*
  * smack_secid_to_secctx - return the smack label for a secid
  * @secid: incoming integer
  * @secdata: destination
@@ -2706,6 +2715,7 @@ struct security_operations smack_ops = {
 	.audit_rule_free =		smack_audit_rule_free,
 #endif /* CONFIG_AUDIT */
 
+	.ismaclabel =			smack_ismaclabel,
 	.secid_to_secctx = 		smack_secid_to_secctx,
 	.secctx_to_secid = 		smack_secctx_to_secid,
 	.release_secctx = 		smack_release_secctx,
-- 
1.5.5.1

