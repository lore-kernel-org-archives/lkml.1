Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYCAT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYCAT6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYCAT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:57:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:10383 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYCAT5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=MMuHkzhS5ryG4hL6iSq0VsgypqaIHJRAWAqAa82TXLY+H+JTJ8SPk6tZoj+b3VHrLoHUsvTko3Z96P5uL9ZJ4bjMTrsSDX/vCvDQZvvzNzPtJKo/af8FnAdCXNpCt5uMRqNng3n/neARQNjhEt/Hw9+ySGNGnI3T/O5mWBDTyUI=
Date: Sat, 1 Mar 2008 21:54:38 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 3/9] Audit: use new LSM hooks instead of SELinux exports
Message-ID: <20080301195438.GD19636@ubuntu>
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
---

 audit.c       |   17 +++++++++--------
 auditfilter.c |    8 +++++---
 auditsc.c     |   55 +++++++++++++++++++++++++++++--------------------------
 3 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 8316a88..d79f866 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -259,13 +259,13 @@ static int audit_log_config_change(char *function_name, int new, int old,
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
@@ -543,12 +543,13 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
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
@@ -750,18 +751,18 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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
index d07fc4a..a9fc9dd 100644
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
@@ -1268,14 +1269,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
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
 
@@ -1389,13 +1391,14 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
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
@@ -1772,7 +1775,7 @@ static void audit_copy_inode(struct audit_names *name, const struct inode *inode
 	name->uid   = inode->i_uid;
 	name->gid   = inode->i_gid;
 	name->rdev  = inode->i_rdev;
-	selinux_get_inode_sid(inode, &name->osid);
+	security_inode_getsecid(inode, &name->osid);
 }
 
 /**
@@ -2187,8 +2190,7 @@ int __audit_ipc_obj(struct kern_ipc_perm *ipcp)
 	ax->uid = ipcp->uid;
 	ax->gid = ipcp->gid;
 	ax->mode = ipcp->mode;
-	selinux_get_ipc_sid(ipcp, &ax->osid);
-
+	security_ipc_getsecid(ipcp, &ax->osid);
 	ax->d.type = AUDIT_IPC;
 	ax->d.next = context->aux;
 	context->aux = (void *)ax;
@@ -2340,7 +2342,7 @@ void __audit_ptrace(struct task_struct *t)
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = t->uid;
 	context->target_sessionid = audit_get_sessionid(t);
-	selinux_get_task_sid(t, &context->target_sid);
+	security_task_getsecid(t, &context->target_sid);
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2368,7 +2370,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 				audit_sig_uid = tsk->loginuid;
 			else
 				audit_sig_uid = tsk->uid;
-			selinux_get_task_sid(tsk, &audit_sig_sid);
+			security_task_getsecid(tsk, &audit_sig_sid);
 		}
 		if (!audit_signals || audit_dummy_context())
 			return 0;
@@ -2381,7 +2383,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 		ctx->target_auid = audit_get_loginuid(t);
 		ctx->target_uid = t->uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
-		selinux_get_task_sid(t, &ctx->target_sid);
+		security_task_getsecid(t, &ctx->target_sid);
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2402,7 +2404,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	axp->target_auid[axp->pid_count] = audit_get_loginuid(t);
 	axp->target_uid[axp->pid_count] = t->uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
-	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);
+	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
@@ -2432,16 +2434,17 @@ void audit_core_dumps(long signr)
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

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

