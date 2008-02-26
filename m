Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbYBZX2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbYBZX2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764050AbYBZX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:28:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:25810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763413AbYBZX2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ZapGAsK+d7kgePGXaR6rTi9DOn9WAwqx+98P5dJ+sWtp+Lu4aBhBXmQQIhsnY07gFqm/Y175OQ+GluVSgbRS6OQhPbJ8g3Jl7RQozBfcNurg8IhEiVTW3LahBvNiysiGgTmdWLQPKQKLR37gYdHpL+4vW4cgkCoJy/ksCZ4lwRE=
Date: Wed, 27 Feb 2008 01:25:41 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/4] SELinux: Remove various exported symbols
Message-ID: <20080226232541.GC12059@ubuntu>
References: <20080226232229.GA12059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226232229.GA12059@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the following exported SELinux interfaces:
selinux_get_inode_sid(inode, sid)
selinux_get_ipc_sid(ipcp, sid) 
selinux_get_task_sid(tsk, sid)
selinux_sid_to_string(sid, ctx, len)

and substitue them with following equivalents respectively:
new LSM hook, inode_getsecid(inode, secid)
new LSM hook, ipc_getsecid*(ipcp, secid)
LSM hook, task_getsecid(tsk, secid)
LSM hook, sid_to_secctx(sid, ctx, len)

This is done to remove SELinux dependency from some
of the kernel subsystems (audit).

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 include/linux/selinux.h    |   62 ---------------------------------------------
 security/selinux/exports.c |   42 ------------------------------
 security/selinux/hooks.c   |   19 ++++++++++++-
 3 files changed, 17 insertions(+), 106 deletions(-)

diff --git a/include/linux/selinux.h b/include/linux/selinux.h
index 8c2cc4c..24b0af1 100644
--- a/include/linux/selinux.h
+++ b/include/linux/selinux.h
@@ -16,7 +16,6 @@
 
 struct selinux_audit_rule;
 struct audit_context;
-struct inode;
 struct kern_ipc_perm;
 
 #ifdef CONFIG_SECURITY_SELINUX
@@ -70,45 +69,6 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op,
 void selinux_audit_set_callback(int (*callback)(void));
 
 /**
- *     selinux_sid_to_string - map a security context ID to a string
- *     @sid: security context ID to be converted.
- *     @ctx: address of context string to be returned
- *     @ctxlen: length of returned context string.
- *
- *     Returns 0 if successful, -errno if not.  On success, the context
- *     string will be allocated internally, and the caller must call
- *     kfree() on it after use.
- */
-int selinux_sid_to_string(u32 sid, char **ctx, u32 *ctxlen);
-
-/**
- *     selinux_get_inode_sid - get the inode's security context ID
- *     @inode: inode structure to get the sid from.
- *     @sid: pointer to security context ID to be filled in.
- *
- *     Returns nothing
- */
-void selinux_get_inode_sid(const struct inode *inode, u32 *sid);
-
-/**
- *     selinux_get_ipc_sid - get the ipc security context ID
- *     @ipcp: ipc structure to get the sid from.
- *     @sid: pointer to security context ID to be filled in.
- *
- *     Returns nothing
- */
-void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid);
-
-/**
- *     selinux_get_task_sid - return the SID of task
- *     @tsk: the task whose SID will be returned
- *     @sid: pointer to security context ID to be filled in.
- *
- *     Returns nothing
- */
-void selinux_get_task_sid(struct task_struct *tsk, u32 *sid);
-
-/**
  *     selinux_string_to_sid - map a security context string to a security ID
  *     @str: the security context string to be mapped
  *     @sid: ID value returned via this.
@@ -175,28 +135,6 @@ static inline void selinux_audit_set_callback(int (*callback)(void))
 	return;
 }
 
-static inline int selinux_sid_to_string(u32 sid, char **ctx, u32 *ctxlen)
-{
-       *ctx = NULL;
-       *ctxlen = 0;
-       return 0;
-}
-
-static inline void selinux_get_inode_sid(const struct inode *inode, u32 *sid)
-{
-	*sid = 0;
-}
-
-static inline void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
-{
-	*sid = 0;
-}
-
-static inline void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
-{
-	*sid = 0;
-}
-
 static inline int selinux_string_to_sid(const char *str, u32 *sid)
 {
        *sid = 0;
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index 87d2bb3..64af2d3 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -25,48 +25,6 @@
 /* SECMARK reference count */
 extern atomic_t selinux_secmark_refcount;
 
-int selinux_sid_to_string(u32 sid, char **ctx, u32 *ctxlen)
-{
-	if (selinux_enabled)
-		return security_sid_to_context(sid, ctx, ctxlen);
-	else {
-		*ctx = NULL;
-		*ctxlen = 0;
-	}
-
-	return 0;
-}
-
-void selinux_get_inode_sid(const struct inode *inode, u32 *sid)
-{
-	if (selinux_enabled) {
-		struct inode_security_struct *isec = inode->i_security;
-		*sid = isec->sid;
-		return;
-	}
-	*sid = 0;
-}
-
-void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
-{
-	if (selinux_enabled) {
-		struct ipc_security_struct *isec = ipcp->security;
-		*sid = isec->sid;
-		return;
-	}
-	*sid = 0;
-}
-
-void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
-{
-	if (selinux_enabled) {
-		struct task_security_struct *tsec = tsk->security;
-		*sid = tsec->sid;
-		return;
-	}
-	*sid = 0;
-}
-
 int selinux_string_to_sid(char *str, u32 *sid)
 {
 	if (selinux_enabled)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f42ebfc..62a0f26 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2724,6 +2724,12 @@ static int selinux_inode_killpriv(struct dentry *dentry)
 	return secondary_ops->inode_killpriv(dentry);
 }
 
+static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	struct inode_security_struct *isec = inode->i_security;
+	*secid = isec->sid;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -3120,7 +3126,8 @@ static int selinux_task_getsid(struct task_struct *p)
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	selinux_get_task_sid(p, secid);
+	struct task_security_struct *tsec = p->security;
+	*secid = tsec->sid;
 }
 
 static int selinux_task_setgroups(struct group_info *group_info)
@@ -4090,7 +4097,7 @@ static int selinux_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *
 		goto out;
 
 	if (sock && family == PF_UNIX)
-		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
+		selinux_inode_getsecid(SOCK_INODE(sock), &peer_secid);
 	else if (skb)
 		selinux_skb_peerlbl_sid(skb, family, &peer_secid);
 
@@ -4970,6 +4977,12 @@ static int selinux_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 	return ipc_has_perm(ipcp, av);
 }
 
+static void selinux_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	struct ipc_security_struct *isec = ipcp->security;
+	*secid = isec->sid;
+}
+
 /* module stacking operations */
 static int selinux_register_security (const char *name, struct security_operations *ops)
 {
@@ -5292,6 +5305,7 @@ static struct security_operations selinux_ops = {
 	.inode_listsecurity =           selinux_inode_listsecurity,
 	.inode_need_killpriv =		selinux_inode_need_killpriv,
 	.inode_killpriv =		selinux_inode_killpriv,
+	.inode_getsecid =               selinux_inode_getsecid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
@@ -5332,6 +5346,7 @@ static struct security_operations selinux_ops = {
 	.task_to_inode =                selinux_task_to_inode,
 
 	.ipc_permission =		selinux_ipc_permission,
+	.ipc_getsecid =                 selinux_ipc_getsecid,
 
 	.msg_msg_alloc_security =	selinux_msg_msg_alloc_security,
 	.msg_msg_free_security =	selinux_msg_msg_free_security,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

