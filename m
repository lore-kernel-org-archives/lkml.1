Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbYCAUBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbYCAUBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbYCAUBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:01:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:23213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYCAUBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:01:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=vBnI7/os4s312JbN4wgi4X+hgOHwvRmNZclrHtS7t1vvLXb/jAVqMHZqFrIkoqkF5N7mgJ/HTfxhEe8Pgqi5ZqkuNcakXrjj9uVGRov3rCEtu9jeWGPkozokp3QT+vs+WmhDALHlx61onG4PaDySMyOr4tssqG5uxo9YeJMZquE=
Date: Sat, 1 Mar 2008 21:58:32 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 5/9] SELinux: remove redundant exports
Message-ID: <20080301195832.GF19636@ubuntu>
References: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301194752.GA19636@ubuntu>
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

They can be substitued with the following generic equivalents 
respectively:
new LSM hook, inode_getsecid(inode, secid)
new LSM hook, ipc_getsecid*(ipcp, secid)
LSM hook, task_getsecid(tsk, secid)
LSM hook, sid_to_secctx(sid, ctx, len)

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 include/linux/selinux.h    |   62 ---------------------------------------------
 security/selinux/exports.c |   42 ------------------------------
 2 files changed, 104 deletions(-)

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

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

