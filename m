Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759655AbYLQFM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYLQFM7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYLQFLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:11:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37017 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbYLQFLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:11:52 -0500
To: linux-audit@redhat.com
Subject: [PATCH 5/15] sanitize audit_mq_getsetattr()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCohK-0000Ai-Sw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:11:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* get rid of allocations
* make it return void
* don't duplicate parts of audit_dummy_context()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    9 +++----
 ipc/mqueue.c          |    6 +----
 kernel/auditsc.c      |   54 +++++++++++++++---------------------------------
 3 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index cd4b1f7..921073b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -452,7 +452,7 @@ extern int __audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr
 extern int __audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec __user *u_abs_timeout);
 extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __user *u_msg_prio, const struct timespec __user *u_abs_timeout);
 extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
-extern int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
+extern void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -494,11 +494,10 @@ static inline int audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_n
 		return __audit_mq_notify(mqdes, u_notification);
 	return 0;
 }
-static inline int audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
+static inline void audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_mq_getsetattr(mqdes, mqstat);
-	return 0;
+		__audit_mq_getsetattr(mqdes, mqstat);
 }
 extern int audit_n_rules;
 extern int audit_signals;
@@ -531,7 +530,7 @@ extern int audit_signals;
 #define audit_mq_timedsend(d,l,p,t) ({ 0; })
 #define audit_mq_timedreceive(d,l,p,t) ({ 0; })
 #define audit_mq_notify(d,n) ({ 0; })
-#define audit_mq_getsetattr(d,s) ({ 0; })
+#define audit_mq_getsetattr(d,s) ((void)0)
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
 #define audit_signals 0
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 68eb857..04aa59e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1147,11 +1147,7 @@ asmlinkage long sys_mq_getsetattr(mqd_t mqdes,
 	omqstat = info->attr;
 	omqstat.mq_flags = filp->f_flags & O_NONBLOCK;
 	if (u_mqstat) {
-		ret = audit_mq_getsetattr(mqdes, &mqstat);
-		if (ret != 0) {
-			spin_unlock(&info->lock);
-			goto out_fput;
-		}
+		audit_mq_getsetattr(mqdes, &mqstat);
 		if (mqstat.mq_flags & O_NONBLOCK)
 			filp->f_flags |= O_NONBLOCK;
 		else
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9d4ac11..703f6c0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -133,12 +133,6 @@ struct audit_aux_data_mq_notify {
 	struct sigevent 	notification;
 };
 
-struct audit_aux_data_mq_getsetattr {
-	struct audit_aux_data	d;
-	mqd_t			mqdes;
-	struct mq_attr 		mqstat;
-};
-
 struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
@@ -222,6 +216,10 @@ struct audit_context {
 			mode_t			perm_mode;
 			unsigned long		qbytes;
 		} ipc;
+		struct {
+			mqd_t			mqdes;
+			struct mq_attr 		mqstat;
+		} mq_getsetattr;
 	};
 
 #if AUDIT_DEBUG
@@ -1210,6 +1208,15 @@ static void show_special(struct audit_context *context, int *call_panic)
 				return;
 		}
 		break; }
+	case AUDIT_MQ_GETSETATTR: {
+		struct mq_attr *attr = &context->mq_getsetattr.mqstat;
+		audit_log_format(ab,
+			"mqdes=%d mq_flags=0x%lx mq_maxmsg=%ld mq_msgsize=%ld "
+			"mq_curmsgs=%ld ",
+			context->mq_getsetattr.mqdes,
+			attr->mq_flags, attr->mq_maxmsg,
+			attr->mq_msgsize, attr->mq_curmsgs);
+		break; }
 	}
 	audit_log_end(ab);
 }
@@ -1316,16 +1323,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				axi->notification.sigev_signo);
 			break; }
 
-		case AUDIT_MQ_GETSETATTR: {
-			struct audit_aux_data_mq_getsetattr *axi = (void *)aux;
-			audit_log_format(ab,
-				"mqdes=%d mq_flags=0x%lx mq_maxmsg=%ld mq_msgsize=%ld "
-				"mq_curmsgs=%ld ",
-				axi->mqdes,
-				axi->mqstat.mq_flags, axi->mqstat.mq_maxmsg,
-				axi->mqstat.mq_msgsize, axi->mqstat.mq_curmsgs);
-			break; }
-
 		case AUDIT_EXECVE: {
 			struct audit_aux_data_execve *axi = (void *)aux;
 			audit_log_execve_info(context, &ab, axi);
@@ -2202,30 +2199,13 @@ int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification)
  * @mqdes: MQ descriptor
  * @mqstat: MQ flags
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
-int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
+void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 {
-	struct audit_aux_data_mq_getsetattr *ax;
 	struct audit_context *context = current->audit_context;
-
-	if (!audit_enabled)
-		return 0;
-
-	if (likely(!context))
-		return 0;
-
-	ax = kmalloc(sizeof(*ax), GFP_ATOMIC);
-	if (!ax)
-		return -ENOMEM;
-
-	ax->mqdes = mqdes;
-	ax->mqstat = *mqstat;
-
-	ax->d.type = AUDIT_MQ_GETSETATTR;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->mq_getsetattr.mqdes = mqdes;
+	context->mq_getsetattr.mqstat = *mqstat;
+	context->type = AUDIT_MQ_GETSETATTR;
 }
 
 /**
-- 
1.5.6.5


