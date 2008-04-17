Return-Path: <linux-kernel-owner+w=401wt.eu-S933831AbYDQLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbYDQLHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761488AbYDQLGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:41589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759245AbYDQLGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:31 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 03/12] Audit: use new LSM hooks instead of SELinux exports
Date: Thu, 17 Apr 2008 11:06:00 +0000
Message-Id: <7c91c6351fff5f031e4310392fccf726bdae8556.1208428765.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Stop using the following exported SELinux interfaces:
selinux_get_inode_sid(inode, sid)
selinux_get_ipc_sid(ipcp, sid)
selinux_get_task_sid(tsk, sid)
selinux_sid_to_string(sid, ctx, len)
kfree(ctx)

and use following generic LSM equivalents respectively:
security_inode_getsecid(inode, secid)
security_ipc_getsecid*(ipcp, secid)
security_task_getsecid(tsk, secid)
security_sid_to_secctx(sid, ctx, len)
security_release_secctx(ctx, len)

Call security_release_secctx only if security_secid_to_secctx
succeeded.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---
 kernel/audit.c       |   17 ++++++++-------
 kernel/auditfilter.c |    8 ++++--
 kernel/auditsc.c     |   55 ++++++++++++++++++++++++++-----------------------
 3 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index b782b04..784a48e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -265,13 +265,13 @@ static int audit_log_config_change(char *function_name, int new, int old,
 		char *ctx = NULL;
 		u32 len;
 
-		rc = selinux_sid_to_string(sid, &ctx, &len);
+		rc = security_secid_to_secctx(sid, &ctx, &len);
 		if (rc) {
 			audit_log_format(ab, " sid=%u", sid);
 			allow_changes = 0; /* Something weird, deny request */
 		} else {
 			audit_log_format(ab, " subj=%s", ctx);
-			kfree(ctx);
+			security_release_secctx(ctx, len);
 		}
 	}
 	audit_log_format(ab, " res=%d", allow_changes);
@@ -550,12 +550,13 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 	audit_log_format(*ab, "user pid=%d uid=%u auid=%u",
 			 pid, uid, auid);
 	if (sid) {
-		rc = selinux_sid_to_string(sid, &ctx, &len);
+		rc = security_secid_to_secctx(sid, &ctx, &len);
 		if (rc)
 			audit_log_format(*ab, " ssid=%u", sid);
-		else
+		else {
 			audit_log_format(*ab, " subj=%s", ctx);
-		kfree(ctx);
+			security_release_secctx(ctx, len);
+		}
 	}
 
 	return rc;
@@ -758,18 +759,18 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	}
 	case AUDIT_SIGNAL_INFO:
-		err = selinux_sid_to_string(audit_sig_sid, &ctx, &len);
+		err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
 		if (err)
 			return err;
 		sig_data = kmalloc(sizeof(*sig_data) + len, GFP_KERNEL);
 		if (!sig_data) {
-			kfree(ctx);
+			security_release_secctx(ctx, len);
 			return -ENOMEM;
 		}
 		sig_data->uid = audit_sig_uid;
 		sig_data->pid = audit_sig_pid;
 		memcpy(sig_data->ctx, ctx, len);
-		kfree(ctx);
+		security_release_secctx(ctx, len);
 		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_SIGNAL_INFO,
 				0, 0, sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 2f2914b..35e58a1 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -28,6 +28,7 @@
 #include <linux/netlink.h>
 #include <linux/sched.h>
 #include <linux/inotify.h>
+#include <linux/security.h>
 #include <linux/selinux.h>
 #include "audit.h"
 
@@ -1515,11 +1516,12 @@ static void audit_log_rule_change(uid_t loginuid, u32 sid, char *action,
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if (selinux_sid_to_string(sid, &ctx, &len))
+		if (security_secid_to_secctx(sid, &ctx, &len))
 			audit_log_format(ab, " ssid=%u", sid);
-		else
+		else {
 			audit_log_format(ab, " subj=%s", ctx);
-		kfree(ctx);
+			security_release_secctx(ctx, len);
+		}
 	}
 	audit_log_format(ab, " op=%s rule key=", action);
 	if (rule->filterkey)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 782262e..6a83c70 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -530,7 +530,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			   logged upon error */
 			if (f->se_rule) {
 				if (need_sid) {
-					selinux_get_task_sid(tsk, &sid);
+					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
 				result = selinux_audit_rule_match(sid, f->type,
@@ -885,11 +885,11 @@ void audit_log_task_context(struct audit_buffer *ab)
 	int error;
 	u32 sid;
 
-	selinux_get_task_sid(current, &sid);
+	security_task_getsecid(current, &sid);
 	if (!sid)
 		return;
 
-	error = selinux_sid_to_string(sid, &ctx, &len);
+	error = security_secid_to_secctx(sid, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
@@ -897,7 +897,7 @@ void audit_log_task_context(struct audit_buffer *ab)
 	}
 
 	audit_log_format(ab, " subj=%s", ctx);
-	kfree(ctx);
+	security_release_secctx(ctx, len);
 	return;
 
 error_path:
@@ -941,7 +941,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 u32 sid, char *comm)
 {
 	struct audit_buffer *ab;
-	char *s = NULL;
+	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
 
@@ -951,15 +951,16 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 
 	audit_log_format(ab, "opid=%d oauid=%d ouid=%d oses=%d", pid, auid,
 			 uid, sessionid);
-	if (selinux_sid_to_string(sid, &s, &len)) {
+	if (security_secid_to_secctx(sid, &ctx, &len)) {
 		audit_log_format(ab, " obj=(none)");
 		rc = 1;
-	} else
-		audit_log_format(ab, " obj=%s", s);
+	} else {
+		audit_log_format(ab, " obj=%s", ctx);
+		security_release_secctx(ctx, len);
+	}
 	audit_log_format(ab, " ocomm=");
 	audit_log_untrustedstring(ab, comm);
 	audit_log_end(ab);
-	kfree(s);
 
 	return rc;
 }
@@ -1271,14 +1272,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			if (axi->osid != 0) {
 				char *ctx = NULL;
 				u32 len;
-				if (selinux_sid_to_string(
+				if (security_secid_to_secctx(
 						axi->osid, &ctx, &len)) {
 					audit_log_format(ab, " osid=%u",
 							axi->osid);
 					call_panic = 1;
-				} else
+				} else {
 					audit_log_format(ab, " obj=%s", ctx);
-				kfree(ctx);
+					security_release_secctx(ctx, len);
+				}
 			}
 			break; }
 
@@ -1392,13 +1394,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 		if (n->osid != 0) {
 			char *ctx = NULL;
 			u32 len;
-			if (selinux_sid_to_string(
+			if (security_secid_to_secctx(
 				n->osid, &ctx, &len)) {
 				audit_log_format(ab, " osid=%u", n->osid);
 				call_panic = 2;
-			} else
+			} else {
 				audit_log_format(ab, " obj=%s", ctx);
-			kfree(ctx);
+				security_release_secctx(ctx, len);
+			}
 		}
 
 		audit_log_end(ab);
@@ -1775,7 +1778,7 @@ static void audit_copy_inode(struct audit_names *name, const struct inode *inode
 	name->uid   = inode->i_uid;
 	name->gid   = inode->i_gid;
 	name->rdev  = inode->i_rdev;
-	selinux_get_inode_sid(inode, &name->osid);
+	security_inode_getsecid(inode, &name->osid);
 }
 
 /**
@@ -2190,8 +2193,7 @@ int __audit_ipc_obj(struct kern_ipc_perm *ipcp)
 	ax->uid = ipcp->uid;
 	ax->gid = ipcp->gid;
 	ax->mode = ipcp->mode;
-	selinux_get_ipc_sid(ipcp, &ax->osid);
-
+	security_ipc_getsecid(ipcp, &ax->osid);
 	ax->d.type = AUDIT_IPC;
 	ax->d.next = context->aux;
 	context->aux = (void *)ax;
@@ -2343,7 +2345,7 @@ void __audit_ptrace(struct task_struct *t)
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = t->uid;
 	context->target_sessionid = audit_get_sessionid(t);
-	selinux_get_task_sid(t, &context->target_sid);
+	security_task_getsecid(t, &context->target_sid);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2371,7 +2373,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 				audit_sig_uid = tsk->loginuid;
 			else
 				audit_sig_uid = tsk->uid;
-			selinux_get_task_sid(tsk, &audit_sig_sid);
+			security_task_getsecid(tsk, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
 			return 0;
@@ -2384,7 +2386,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t->uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
-		selinux_get_task_sid(t, &ctx->target_sid);
+		security_task_getsecid(t, &ctx->target_sid);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2405,7 +2407,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t->uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
-	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);
+	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
@@ -2435,16 +2437,17 @@ void audit_core_dumps(long signr)
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	audit_log_format(ab, "auid=%u uid=%u gid=%u ses=%u",
 			auid, current->uid, current->gid, sessionid);
-	selinux_get_task_sid(current, &sid);
+	security_task_getsecid(current, &sid);
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
 
-		if (selinux_sid_to_string(sid, &ctx, &len))
+		if (security_secid_to_secctx(sid, &ctx, &len))
 			audit_log_format(ab, " ssid=%u", sid);
-		else
+		else {
 			audit_log_format(ab, " subj=%s", ctx);
-		kfree(ctx);
+			security_release_secctx(ctx, len);
+		}
 	}
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);
-- 
1.5.4.2

