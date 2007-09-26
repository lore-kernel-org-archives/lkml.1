Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXIZOV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXIZOV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbXIZOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:21:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbXIZOV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:21:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/24] CRED: Alter security_task_getsecid() and similar to
	return both task SIDs
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 26 Sep 2007 15:21:15 +0100
Message-ID: <20070926142115.2656.64834.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
References: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alter security_task_getsecid(), selinux_get_task_sid() and associated functions
to return both the objective/victim and subjective/action task SIDs.  Both
results are optional by submitting NULL result pointers.

Interestingly, AF_NETLINK calls directly into SELinux.  I suspect this to be
incorrect.  It should probably use security_task_getsecid() instead.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/usb/core/devio.c          |    4 ++--
 include/linux/security.h          |   18 +++++++++++++-----
 include/linux/selinux.h           |   15 ++++++++++-----
 kernel/auditsc.c                  |   14 +++++++-------
 net/netlabel/netlabel_unlabeled.c |    2 +-
 net/netlink/af_netlink.c          |    2 +-
 security/dummy.c                  |    3 ++-
 security/selinux/exports.c        |   22 ++++++++++++++++++----
 security/selinux/hooks.c          |    5 +++--
 security/selinux/xfrm.c           |   12 ++++++------
 10 files changed, 63 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 927a181..1e651d8 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -579,7 +579,7 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	ps->disc_euid = current->euid;
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
-	security_task_getsecid(current, &ps->secid);
+	security_task_getsecid(current, NULL, &ps->secid);
 	smp_wmb();
 	list_add_tail(&ps->list, &dev->filelist);
 	file->private_data = ps;
@@ -1069,7 +1069,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->pid = get_pid(task_pid(current));
 	as->uid = current->uid;
 	as->euid = current->euid;
-	security_task_getsecid(current, &as->secid);
+	security_task_getsecid(current, NULL, &as->secid);
 	if (!(uurb->endpoint & USB_DIR_IN)) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer, as->urb->transfer_buffer_length)) {
 			free_async(as);
diff --git a/include/linux/security.h b/include/linux/security.h
index 74cc204..0933333 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -584,7 +584,12 @@ struct request_sock;
  *	Return 0 if permission is granted.
  * @task_getsecid:
  *	Retrieve the security identifier of the process @p.
- *	@p contains the task_struct for the process and place is into @secid.
+ *	@p contains the task_struct for the process to be interrogated.  The
+ *	security ID of the task itself is placed in *@object_secid, and the
+ *	security ID as which the task is currently acting is placed in
+ *	*@action_secid.  Either result pointer may be NULL if that particular
+ *	ID is not required.
+ *
  * @task_setgroups:
  *	Check permission before setting the supplementary group set of the
  *	current process.
@@ -1281,7 +1286,8 @@ struct security_operations {
 	int (*task_setpgid) (struct task_struct * p, pid_t pgid);
 	int (*task_getpgid) (struct task_struct * p);
 	int (*task_getsid) (struct task_struct * p);
-	void (*task_getsecid) (struct task_struct * p, u32 * secid);
+	void (*task_getsecid) (struct task_struct * p,
+			       u32 * object_secid, u32 * subject_secid);
 	int (*task_setgroups) (struct group_info *group_info);
 	int (*task_setnice) (struct task_struct * p, int nice);
 	int (*task_setioprio) (struct task_struct * p, int ioprio);
@@ -1936,9 +1942,10 @@ static inline int security_task_getsid (struct task_struct *p)
 	return security_ops->task_getsid (p);
 }
 
-static inline void security_task_getsecid (struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid (struct task_struct *p,
+					   u32 *object_secid, u32 *action_secid)
 {
-	security_ops->task_getsecid (p, secid);
+	security_ops->task_getsecid (p, object_secid, action_secid);
 }
 
 static inline int security_task_setgroups (struct group_info *group_info)
@@ -2625,7 +2632,8 @@ static inline int security_task_getsid (struct task_struct *p)
 	return 0;
 }
 
-static inline void security_task_getsecid (struct task_struct *p, u32 *secid)
+static inline void security_task_getsecid (struct task_struct *p,
+					   u32 *object_secid, u32 *action_secid)
 { }
 
 static inline int security_task_setgroups (struct group_info *group_info)
diff --git a/include/linux/selinux.h b/include/linux/selinux.h
index d1b7ca6..26cdec3 100644
--- a/include/linux/selinux.h
+++ b/include/linux/selinux.h
@@ -101,12 +101,16 @@ void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid);
 
 /**
  *     selinux_get_task_sid - return the SID of task
- *     @tsk: the task whose SID will be returned
- *     @sid: pointer to security context ID to be filled in.
+ *     @tsk: the task to be queried.
+ *     @object_sid: optional pointer to where the objective security context ID
+ *     of the task is to be placed.
+ *     @action_sid: optional pointer to where the subjective security context ID
+ *     of the task is to be placed.
  *
  *     Returns nothing
  */
-void selinux_get_task_sid(struct task_struct *tsk, u32 *sid);
+void selinux_get_task_sid(struct task_struct *tsk,
+			  u32 *object_sid, u32 *action_sid);
 
 /**
  *     selinux_string_to_sid - map a security context string to a security ID
@@ -173,9 +177,10 @@ static inline void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *si
 	*sid = 0;
 }
 
-static inline void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
+lstatic inline void selinux_get_task_sid(struct task_struct *tsk,
+					 u32 *object_sid, u32 *action_sid)
 {
-	*sid = 0;
+	*object_sid = *action_sid = 0;
 }
 
 static inline int selinux_string_to_sid(const char *str, u32 *sid)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 282e041..d87f7ac 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -399,7 +399,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			   logged upon error */
 			if (f->se_rule) {
 				if (need_sid) {
-					selinux_get_task_sid(tsk, &sid);
+					selinux_get_task_sid(tsk, NULL, &sid);
 					need_sid = 0;
 				}
 				result = selinux_audit_rule_match(sid, f->type,
@@ -746,7 +746,7 @@ void audit_log_task_context(struct audit_buffer *ab)
 	int error;
 	u32 sid;
 
-	selinux_get_task_sid(current, &sid);
+	selinux_get_task_sid(current, NULL, &sid);
 	if (!sid)
 		return;
 
@@ -1977,7 +1977,7 @@ void __audit_ptrace(struct task_struct *t)
 	struct audit_context *context = current->audit_context;
 
 	context->target_pid = t->pid;
-	selinux_get_task_sid(t, &context->target_sid);
+	selinux_get_task_sid(t, &context->target_sid, NULL);
 }
 
 /**
@@ -2004,7 +2004,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 				audit_sig_uid = ctx->loginuid;
 			else
 				audit_sig_uid = tsk->uid;
-			selinux_get_task_sid(tsk, &audit_sig_sid);
+			selinux_get_task_sid(tsk, NULL, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
 			return 0;
@@ -2014,7 +2014,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	 * in audit_context */
 	if (!ctx->target_pid) {
 		ctx->target_pid = t->tgid;
-		selinux_get_task_sid(t, &ctx->target_sid);
+		selinux_get_task_sid(t, &ctx->target_sid, NULL);
 		return 0;
 	}
 
@@ -2031,7 +2031,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	BUG_ON(axp->pid_count >= AUDIT_AUX_PIDS);
 
 	axp->target_pid[axp->pid_count] = t->tgid;
-	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);
+	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count], NULL);
 	axp->pid_count++;
 
 	return 0;
@@ -2059,7 +2059,7 @@ void audit_core_dumps(long signr)
 	audit_log_format(ab, "auid=%u uid=%u gid=%u",
 			audit_get_loginuid(current->audit_context),
 			current->uid, current->gid);
-	selinux_get_task_sid(current, &sid);
+	selinux_get_task_sid(current, NULL, &sid);
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 5c303c6..474c03a 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -277,7 +277,7 @@ int netlbl_unlabel_defconf(void)
 	/* Only the kernel is allowed to call this function and the only time
 	 * it is called is at bootup before the audit subsystem is reporting
 	 * messages so don't worry to much about these values. */
-	security_task_getsecid(current, &audit_info.secid);
+	security_task_getsecid(current, NULL, &audit_info.secid);
 	audit_info.loginuid = 0;
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5681ce3..8c37d5f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1190,7 +1190,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	NETLINK_CB(skb).pid	= nlk->pid;
 	NETLINK_CB(skb).dst_group = dst_group;
 	NETLINK_CB(skb).loginuid = audit_get_loginuid(current->audit_context);
-	selinux_get_task_sid(current, &(NETLINK_CB(skb).sid));
+	selinux_get_task_sid(current, NULL, &(NETLINK_CB(skb).sid));
 	memcpy(NETLINK_CREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
 
 	/* What can I do? Netlink is asynchronous, so that
diff --git a/security/dummy.c b/security/dummy.c
index f535cc6..187fc4b 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -523,7 +523,8 @@ static int dummy_task_getsid (struct task_struct *p)
 	return 0;
 }
 
-static void dummy_task_getsecid (struct task_struct *p, u32 *secid)
+static void dummy_task_getsecid (struct task_struct *p,
+				 u32 *object_secid, u32 *action_secid)
 { }
 
 static int dummy_task_setgroups (struct group_info *group_info)
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index 29cb87a..374a7b2 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -53,14 +53,28 @@ void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
 	*sid = 0;
 }
 
-void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
+void selinux_get_task_sid(struct task_struct *tsk,
+			  u32 *object_sid, u32 *action_sid)
 {
 	if (selinux_enabled) {
-		struct task_security_struct *tsec = tsk->security;
-		*sid = tsec->victim_sid;
+		struct task_security_struct *tsec;
+		struct cred_security_struct *csec;
+		if (object_sid) {
+			tsec = tsk->security;
+			*object_sid = tsec->victim_sid;
+		}
+		if (action_sid) {
+			rcu_read_lock();
+			csec = task_cred(tsk)->security;
+			*action_sid = csec->action_sid;
+			rcu_read_unlock();
+		}
 		return;
 	}
-	*sid = 0;
+	if (object_sid)
+		*object_sid = 0;
+	if (action_sid)
+		*action_sid = 0;
 }
 
 int selinux_string_to_sid(char *str, u32 *sid)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4e72dbb..2ee1712 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2853,9 +2853,10 @@ static int selinux_task_getsid(struct task_struct *p)
 	return task_has_perm(current, p, PROCESS__GETSESSION);
 }
 
-static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
+static void selinux_task_getsecid(struct task_struct *p,
+				  u32 *object_secid, u32 *action_secid)
 {
-	selinux_get_task_sid(p, secid);
+	selinux_get_task_sid(p, object_secid, action_secid);
 }
 
 static int selinux_task_setgroups(struct group_info *group_info)
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 902d302..9dfa8f3 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -199,7 +199,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	struct xfrm_user_sec_ctx *uctx, u32 sid)
 {
 	int rc = 0;
-	struct task_security_struct *tsec = current->security;
+	struct cred_security_struct *csec = current->cred->security;
 	struct xfrm_sec_ctx *ctx = NULL;
 	char *ctx_str = NULL;
 	u32 str_len;
@@ -240,7 +240,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	/*
 	 * Does the subject have permission to set security context?
 	 */
-	rc = avc_has_perm(tsec->action_sid, ctx->ctx_sid,
+	rc = avc_has_perm(csec->action_sid, ctx->ctx_sid,
 			  SECCLASS_ASSOCIATION,
 			  ASSOCIATION__SETCONTEXT, NULL);
 	if (rc)
@@ -336,12 +336,12 @@ void selinux_xfrm_policy_free(struct xfrm_policy *xp)
  */
 int selinux_xfrm_policy_delete(struct xfrm_policy *xp)
 {
-	struct task_security_struct *tsec = current->security;
+	struct cred_security_struct *csec = current->cred->security;
 	struct xfrm_sec_ctx *ctx = xp->security;
 	int rc = 0;
 
 	if (ctx)
-		rc = avc_has_perm(tsec->action_sid, ctx->ctx_sid,
+		rc = avc_has_perm(csec->action_sid, ctx->ctx_sid,
 				  SECCLASS_ASSOCIATION,
 				  ASSOCIATION__SETCONTEXT, NULL);
 
@@ -378,12 +378,12 @@ void selinux_xfrm_state_free(struct xfrm_state *x)
   */
 int selinux_xfrm_state_delete(struct xfrm_state *x)
 {
-	struct task_security_struct *tsec = current->security;
+	struct cred_security_struct *csec = current->cred->security;
 	struct xfrm_sec_ctx *ctx = x->security;
 	int rc = 0;
 
 	if (ctx)
-		rc = avc_has_perm(tsec->action_sid, ctx->ctx_sid,
+		rc = avc_has_perm(csec->action_sid, ctx->ctx_sid,
 				  SECCLASS_ASSOCIATION,
 				  ASSOCIATION__SETCONTEXT, NULL);
 

