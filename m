Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYIOVJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYIOVJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYIOVGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:06:48 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64420 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbYIOVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:28 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 04/14] Security: Add Hook to test if the particular xattr is part of a MAC model.
Date: Mon, 15 Sep 2008 16:41:08 -0400
Message-Id: <1221511278-28051-5-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
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
 security/security.c        |    6 ++++++
 security/selinux/hooks.c   |    6 ++++++
 security/smack/smack_lsm.c |   11 +++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 42b9128..3031e6c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1244,6 +1244,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
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
@@ -1508,6 +1512,7 @@ struct security_operations {
 
 	int (*getprocattr) (struct task_struct *p, char *name, char **value);
 	int (*setprocattr) (struct task_struct *p, char *name, void *value, size_t size);
+	int (*ismaclabel) (const char * name);
 	int (*secid_to_secctx) (u32 secid, char **secdata, u32 *seclen);
 	int (*secctx_to_secid) (const char *secdata, u32 seclen, u32 *secid);
 	void (*release_secctx) (char *secdata, u32 seclen);
@@ -1762,6 +1767,7 @@ int security_getprocattr(struct task_struct *p, char *name, char **value);
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_netlink_recv(struct sk_buff *skb, int cap);
+int security_ismaclabel(const char *name);
 int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -2494,6 +2500,11 @@ static inline void securityfs_remove(struct dentry *dentry)
 {
 }
 
+static inline int security_ismaclabel(const char *name)
+{
+	return 0;
+}
+
 static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
diff --git a/security/security.c b/security/security.c
index b22a110..1955094 100644
--- a/security/security.c
+++ b/security/security.c
@@ -858,6 +858,12 @@ int security_netlink_recv(struct sk_buff *skb, int cap)
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
index 680db1d..248fa5c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5305,6 +5305,11 @@ static int selinux_setprocattr(struct task_struct *p,
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
@@ -5546,6 +5551,7 @@ static struct security_operations selinux_ops = {
 	.getprocattr =			selinux_getprocattr,
 	.setprocattr =			selinux_setprocattr,
 
+	.ismaclabel =			selinux_ismaclabel,
 	.secid_to_secctx =		selinux_secid_to_secctx,
 	.secctx_to_secid =		selinux_secctx_to_secid,
 	.release_secctx =		selinux_release_secctx,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 87d7541..6b03a18 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2526,6 +2526,16 @@ static void smack_audit_rule_free(void *vrule)
 #endif /* CONFIG_AUDIT */
 
 /*
+ * smack_ismaclabel - check if xattr @name references a smack MAC label
+ * @name: Full xattr name to check.
+ *
+ */
+static int smack_ismaclabel(const char *name)
+{
+	return (strcmp(name,XATTR_NAME_SMACK) == 0);
+}
+
+/*
  * smack_secid_to_secctx - return the smack label for a secid
  * @secid: incoming integer
  * @secdata: destination
@@ -2703,6 +2713,7 @@ struct security_operations smack_ops = {
 	.audit_rule_free =		smack_audit_rule_free,
 #endif /* CONFIG_AUDIT */
 
+	.ismaclabel =			smack_ismaclabel,
 	.secid_to_secctx = 		smack_secid_to_secctx,
 	.secctx_to_secid = 		smack_secctx_to_secid,
 	.release_secctx = 		smack_release_secctx,
-- 
1.5.5.1

