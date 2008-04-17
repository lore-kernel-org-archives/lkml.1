Return-Path: <linux-kernel-owner+w=401wt.eu-S934415AbYDQLJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbYDQLJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbYDQLGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:41599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761001AbYDQLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:33 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 05/12] SELinux: remove redundant exports
Date: Thu, 17 Apr 2008 11:06:02 +0000
Message-Id: <14b33afe467d8903b8b3f1394500f94f13cb3089.1208428765.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Remove the following exported SELinux interfaces:
selinux_get_inode_sid(inode, sid)
selinux_get_ipc_sid(ipcp, sid)
selinux_get_task_sid(tsk, sid)
selinux_sid_to_string(sid, ctx, len)

They can be substitued with the following generic equivalents
respectively:
new LSM hook, inode_getsecid(inode, secid)
new LSM hook, ipc_getsecid*(ipcp, secid)
LSM hook, task_getsecid(tsk, secid)
LSM hook, sid_to_secctx(sid, ctx, len)

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---
 include/linux/selinux.h    |   62 --------------------------------------------
 security/selinux/exports.c |   42 -----------------------------
 2 files changed, 0 insertions(+), 104 deletions(-)

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
-- 
1.5.4.2

