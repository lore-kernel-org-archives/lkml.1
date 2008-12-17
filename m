Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759101AbYLQFNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYLQFNk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbYLQFMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:12:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37043 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbYLQFMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:12:12 -0500
To: linux-audit@redhat.com
Subject: [PATCH 7/15] sanitize AUDIT_MQ_SENDRECV
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:12:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* logging the original value of *msg_prio in mq_timedreceive(2)
  is insane - the argument is write-only (i.e. syscall always
  ignores the original value and only overwrites it).
* merge __audit_mq_timed{send,receive}
* don't do copy_from_user() twice
* don't mess with allocations in auditsc part
* ... and don't bother checking !audit_enabled and !context in there -
  we'd already checked for audit_dummy_context().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |   17 ++-----
 ipc/mqueue.c          |   54 ++++++++++++---------
 kernel/auditsc.c      |  127 +++++++++++-------------------------------------
 3 files changed, 63 insertions(+), 135 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b82b927..dd3f62c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -449,8 +449,7 @@ extern int audit_sockaddr(int len, void *addr);
 extern int __audit_fd_pair(int fd1, int fd2);
 extern int audit_set_macxattr(const char *name);
 extern int __audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr);
-extern int __audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec __user *u_abs_timeout);
-extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __user *u_msg_prio, const struct timespec __user *u_abs_timeout);
+extern void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout);
 extern void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification);
 extern void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 
@@ -476,17 +475,10 @@ static inline int audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u
 		return __audit_mq_open(oflag, mode, u_attr);
 	return 0;
 }
-static inline int audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec __user *u_abs_timeout)
+static inline void audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_mq_timedsend(mqdes, msg_len, msg_prio, u_abs_timeout);
-	return 0;
-}
-static inline int audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __user *u_msg_prio, const struct timespec __user *u_abs_timeout)
-{
-	if (unlikely(!audit_dummy_context()))
-		return __audit_mq_timedreceive(mqdes, msg_len, u_msg_prio, u_abs_timeout);
-	return 0;
+		__audit_mq_sendrecv(mqdes, msg_len, msg_prio, abs_timeout);
 }
 static inline void audit_mq_notify(mqd_t mqdes, const struct sigevent *notification)
 {
@@ -526,8 +518,7 @@ extern int audit_signals;
 #define audit_sockaddr(len, addr) ({ 0; })
 #define audit_set_macxattr(n) do { ; } while (0)
 #define audit_mq_open(o,m,a) ({ 0; })
-#define audit_mq_timedsend(d,l,p,t) ({ 0; })
-#define audit_mq_timedreceive(d,l,p,t) ({ 0; })
+#define audit_mq_sendrecv(d,l,p,t) ((void)0)
 #define audit_mq_notify(d,n) ((void)0)
 #define audit_mq_getsetattr(d,s) ((void)0)
 #define audit_ptrace(t) ((void)0)
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 8ea1133..20fd43e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -524,31 +524,27 @@ static void __do_notify(struct mqueue_inode_info *info)
 	wake_up(&info->wait_q);
 }
 
-static long prepare_timeout(const struct timespec __user *u_arg)
+static long prepare_timeout(struct timespec *p)
 {
-	struct timespec ts, nowts;
+	struct timespec nowts;
 	long timeout;
 
-	if (u_arg) {
-		if (unlikely(copy_from_user(&ts, u_arg,
-					sizeof(struct timespec))))
-			return -EFAULT;
-
-		if (unlikely(ts.tv_nsec < 0 || ts.tv_sec < 0
-			|| ts.tv_nsec >= NSEC_PER_SEC))
+	if (p) {
+		if (unlikely(p->tv_nsec < 0 || p->tv_sec < 0
+			|| p->tv_nsec >= NSEC_PER_SEC))
 			return -EINVAL;
 		nowts = CURRENT_TIME;
 		/* first subtract as jiffies can't be too big */
-		ts.tv_sec -= nowts.tv_sec;
-		if (ts.tv_nsec < nowts.tv_nsec) {
-			ts.tv_nsec += NSEC_PER_SEC;
-			ts.tv_sec--;
+		p->tv_sec -= nowts.tv_sec;
+		if (p->tv_nsec < nowts.tv_nsec) {
+			p->tv_nsec += NSEC_PER_SEC;
+			p->tv_sec--;
 		}
-		ts.tv_nsec -= nowts.tv_nsec;
-		if (ts.tv_sec < 0)
+		p->tv_nsec -= nowts.tv_nsec;
+		if (p->tv_sec < 0)
 			return 0;
 
-		timeout = timespec_to_jiffies(&ts) + 1;
+		timeout = timespec_to_jiffies(p) + 1;
 	} else
 		return MAX_SCHEDULE_TIMEOUT;
 
@@ -826,17 +822,22 @@ asmlinkage long sys_mq_timedsend(mqd_t mqdes, const char __user *u_msg_ptr,
 	struct ext_wait_queue *receiver;
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
+	struct timespec ts, *p = NULL;
 	long timeout;
 	int ret;
 
-	ret = audit_mq_timedsend(mqdes, msg_len, msg_prio, u_abs_timeout);
-	if (ret != 0)
-		return ret;
+	if (u_abs_timeout) {
+		if (copy_from_user(&ts, u_abs_timeout, 
+					sizeof(struct timespec)))
+			return -EFAULT;
+		p = &ts;
+	}
 
 	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
 		return -EINVAL;
 
-	timeout = prepare_timeout(u_abs_timeout);
+	audit_mq_sendrecv(mqdes, msg_len, msg_prio, p);
+	timeout = prepare_timeout(p);
 
 	ret = -EBADF;
 	filp = fget(mqdes);
@@ -915,12 +916,17 @@ asmlinkage ssize_t sys_mq_timedreceive(mqd_t mqdes, char __user *u_msg_ptr,
 	struct inode *inode;
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
+	struct timespec ts, *p = NULL;
 
-	ret = audit_mq_timedreceive(mqdes, msg_len, u_msg_prio, u_abs_timeout);
-	if (ret != 0)
-		return ret;
+	if (u_abs_timeout) {
+		if (copy_from_user(&ts, u_abs_timeout, 
+					sizeof(struct timespec)))
+			return -EFAULT;
+		p = &ts;
+	}
 
-	timeout = prepare_timeout(u_abs_timeout);
+	audit_mq_sendrecv(mqdes, msg_len, 0, p);
+	timeout = prepare_timeout(p);
 
 	ret = -EBADF;
 	filp = fget(mqdes);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2060a08..fa8793d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -119,14 +119,6 @@ struct audit_aux_data_mq_open {
 	struct mq_attr		attr;
 };
 
-struct audit_aux_data_mq_sendrecv {
-	struct audit_aux_data	d;
-	mqd_t			mqdes;
-	size_t			msg_len;
-	unsigned int		msg_prio;
-	struct timespec		abs_timeout;
-};
-
 struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
@@ -218,6 +210,12 @@ struct audit_context {
 			mqd_t			mqdes;
 			int			sigev_signo;
 		} mq_notify;
+		struct {
+			mqd_t			mqdes;
+			size_t			msg_len;
+			unsigned int		msg_prio;
+			struct timespec		abs_timeout;
+		} mq_sendrecv;
 	};
 
 #if AUDIT_DEBUG
@@ -1206,6 +1204,16 @@ static void show_special(struct audit_context *context, int *call_panic)
 				return;
 		}
 		break; }
+	case AUDIT_MQ_SENDRECV: {
+		audit_log_format(ab,
+			"mqdes=%d msg_len=%zd msg_prio=%u "
+			"abs_timeout_sec=%ld abs_timeout_nsec=%ld",
+			context->mq_sendrecv.mqdes,
+			context->mq_sendrecv.msg_len,
+			context->mq_sendrecv.msg_prio,
+			context->mq_sendrecv.abs_timeout.tv_sec,
+			context->mq_sendrecv.abs_timeout.tv_nsec);
+		break; }
 	case AUDIT_MQ_NOTIFY: {
 		audit_log_format(ab, "mqdes=%d sigev_signo=%d",
 				context->mq_notify.mqdes,
@@ -1309,15 +1317,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				axi->attr.mq_curmsgs);
 			break; }
 
-		case AUDIT_MQ_SENDRECV: {
-			struct audit_aux_data_mq_sendrecv *axi = (void *)aux;
-			audit_log_format(ab,
-				"mqdes=%d msg_len=%zd msg_prio=%u "
-				"abs_timeout_sec=%ld abs_timeout_nsec=%ld",
-				axi->mqdes, axi->msg_len, axi->msg_prio,
-				axi->abs_timeout.tv_sec, axi->abs_timeout.tv_nsec);
-			break; }
-
 		case AUDIT_EXECVE: {
 			struct audit_aux_data_execve *axi = (void *)aux;
 			audit_log_execve_info(context, &ab, axi);
@@ -2057,97 +2056,29 @@ int __audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr)
 }
 
 /**
- * __audit_mq_timedsend - record audit data for a POSIX MQ timed send
+ * __audit_mq_sendrecv - record audit data for a POSIX MQ timed send/receive
  * @mqdes: MQ descriptor
  * @msg_len: Message length
  * @msg_prio: Message priority
- * @u_abs_timeout: Message timeout in absolute time
- *
- * Returns 0 for success or NULL context or < 0 on error.
- */
-int __audit_mq_timedsend(mqd_t mqdes, size_t msg_len, unsigned int msg_prio,
-			const struct timespec __user *u_abs_timeout)
-{
-	struct audit_aux_data_mq_sendrecv *ax;
-	struct audit_context *context = current->audit_context;
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
-	if (u_abs_timeout != NULL) {
-		if (copy_from_user(&ax->abs_timeout, u_abs_timeout, sizeof(ax->abs_timeout))) {
-			kfree(ax);
-			return -EFAULT;
-		}
-	} else
-		memset(&ax->abs_timeout, 0, sizeof(ax->abs_timeout));
-
-	ax->mqdes = mqdes;
-	ax->msg_len = msg_len;
-	ax->msg_prio = msg_prio;
-
-	ax->d.type = AUDIT_MQ_SENDRECV;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
-}
-
-/**
- * __audit_mq_timedreceive - record audit data for a POSIX MQ timed receive
- * @mqdes: MQ descriptor
- * @msg_len: Message length
- * @u_msg_prio: Message priority
- * @u_abs_timeout: Message timeout in absolute time
+ * @abs_timeout: Message timeout in absolute time
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
-int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len,
-				unsigned int __user *u_msg_prio,
-				const struct timespec __user *u_abs_timeout)
+void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio,
+			const struct timespec *abs_timeout)
 {
-	struct audit_aux_data_mq_sendrecv *ax;
 	struct audit_context *context = current->audit_context;
+	struct timespec *p = &context->mq_sendrecv.abs_timeout;
 
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
-	if (u_msg_prio != NULL) {
-		if (get_user(ax->msg_prio, u_msg_prio)) {
-			kfree(ax);
-			return -EFAULT;
-		}
-	} else
-		ax->msg_prio = 0;
-
-	if (u_abs_timeout != NULL) {
-		if (copy_from_user(&ax->abs_timeout, u_abs_timeout, sizeof(ax->abs_timeout))) {
-			kfree(ax);
-			return -EFAULT;
-		}
-	} else
-		memset(&ax->abs_timeout, 0, sizeof(ax->abs_timeout));
+	if (abs_timeout)
+		memcpy(p, abs_timeout, sizeof(struct timespec));
+	else
+		memset(p, 0, sizeof(struct timespec));
 
-	ax->mqdes = mqdes;
-	ax->msg_len = msg_len;
+	context->mq_sendrecv.mqdes = mqdes;
+	context->mq_sendrecv.msg_len = msg_len;
+	context->mq_sendrecv.msg_prio = msg_prio;
 
-	ax->d.type = AUDIT_MQ_SENDRECV;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->type = AUDIT_MQ_SENDRECV;
 }
 
 /**
-- 
1.5.6.5


