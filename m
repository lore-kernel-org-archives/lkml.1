Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759839AbYLQFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYLQFNX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYLQFMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:12:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37021 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623AbYLQFMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:12:02 -0500
To: linux-audit@redhat.com
Subject: [PATCH 6/15] sanitize audit_mq_notify()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCohU-0000BE-T6@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:12:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* don't copy_from_user() twice
* don't bother with allocations
* don't duplicate parts of audit_dummy_context()
* make it return void

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    9 +++----
 ipc/mqueue.c          |   14 ++++++------
 kernel/auditsc.c      |   56 ++++++++++++++-----------------------------------
 3 files changed, 27 insertions(+), 52 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 921073b..b82b927 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -451,7 +451,7 @@ extern int audit_set_macxattr(const char *name);
 extern int __audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr);
 extern int __audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec __user *u_abs_timeout);
 extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __user *u_msg_prio, const struct timespec __user *u_abs_timeout);
-extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
+extern void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification);
 extern void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
@@ -488,11 +488,10 @@ static inline int audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned in
 		return __audit_mq_timedreceive(mqdes, msg_len, u_msg_prio, u_abs_timeout);
 	return 0;
 }
-static inline int audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification)
+static inline void audit_mq_notify(mqd_t mqdes, const struct sigevent *notification)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_mq_notify(mqdes, u_notification);
-	return 0;
+		__audit_mq_notify(mqdes, notification);
 }
 static inline void audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 {
@@ -529,7 +528,7 @@ extern int audit_signals;
 #define audit_mq_open(o,m,a) ({ 0; })
 #define audit_mq_timedsend(d,l,p,t) ({ 0; })
 #define audit_mq_timedreceive(d,l,p,t) ({ 0; })
-#define audit_mq_notify(d,n) ({ 0; })
+#define audit_mq_notify(d,n) ((void)0)
 #define audit_mq_getsetattr(d,s) ((void)0)
 #define audit_ptrace(t) ((void)0)
 #define audit_n_rules 0
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 04aa59e..8ea1133 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1000,17 +1000,17 @@ asmlinkage long sys_mq_notify(mqd_t mqdes,
 	struct mqueue_inode_info *info;
 	struct sk_buff *nc;
 
-	ret = audit_mq_notify(mqdes, u_notification);
-	if (ret != 0)
-		return ret;
-
-	nc = NULL;
-	sock = NULL;
-	if (u_notification != NULL) {
+	if (u_notification) {
 		if (copy_from_user(&notification, u_notification,
 					sizeof(struct sigevent)))
 			return -EFAULT;
+	}
+
+	audit_mq_notify(mqdes, u_notification ? &notification : NULL);
 
+	nc = NULL;
+	sock = NULL;
+	if (u_notification != NULL) {
 		if (unlikely(notification.sigev_notify != SIGEV_NONE &&
 			     notification.sigev_notify != SIGEV_SIGNAL &&
 			     notification.sigev_notify != SIGEV_THREAD))
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 703f6c0..2060a08 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -127,12 +127,6 @@ struct audit_aux_data_mq_sendrecv {
 	struct timespec		abs_timeout;
 };
 
-struct audit_aux_data_mq_notify {
-	struct audit_aux_data	d;
-	mqd_t			mqdes;
-	struct sigevent 	notification;
-};
-
 struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
@@ -220,6 +214,10 @@ struct audit_context {
 			mqd_t			mqdes;
 			struct mq_attr 		mqstat;
 		} mq_getsetattr;
+		struct {
+			mqd_t			mqdes;
+			int			sigev_signo;
+		} mq_notify;
 	};
 
 #if AUDIT_DEBUG
@@ -1208,6 +1206,11 @@ static void show_special(struct audit_context *context, int *call_panic)
 				return;
 		}
 		break; }
+	case AUDIT_MQ_NOTIFY: {
+		audit_log_format(ab, "mqdes=%d sigev_signo=%d",
+				context->mq_notify.mqdes,
+				context->mq_notify.sigev_signo);
+		break; }
 	case AUDIT_MQ_GETSETATTR: {
 		struct mq_attr *attr = &context->mq_getsetattr.mqstat;
 		audit_log_format(ab,
@@ -1315,14 +1318,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				axi->abs_timeout.tv_sec, axi->abs_timeout.tv_nsec);
 			break; }
 
-		case AUDIT_MQ_NOTIFY: {
-			struct audit_aux_data_mq_notify *axi = (void *)aux;
-			audit_log_format(ab,
-				"mqdes=%d sigev_signo=%d",
-				axi->mqdes,
-				axi->notification.sigev_signo);
-			break; }
-
 		case AUDIT_EXECVE: {
 			struct audit_aux_data_execve *axi = (void *)aux;
 			audit_log_execve_info(context, &ab, axi);
@@ -2160,38 +2155,19 @@ int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len,
  * @mqdes: MQ descriptor
  * @u_notification: Notification event
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
 
-int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification)
+void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification)
 {
-	struct audit_aux_data_mq_notify *ax;
 	struct audit_context *context = current->audit_context;
 
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
-	if (u_notification != NULL) {
-		if (copy_from_user(&ax->notification, u_notification, sizeof(ax->notification))) {
-			kfree(ax);
-			return -EFAULT;
-		}
-	} else
-		memset(&ax->notification, 0, sizeof(ax->notification));
-
-	ax->mqdes = mqdes;
+	if (notification)
+		context->mq_notify.sigev_signo = notification->sigev_signo;
+	else
+		context->mq_notify.sigev_signo = 0;
 
-	ax->d.type = AUDIT_MQ_NOTIFY;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->mq_notify.mqdes = mqdes;
+	context->type = AUDIT_MQ_NOTIFY;
 }
 
 /**
-- 
1.5.6.5


