Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758966AbYLQFN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbYLQFN4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbYLQFMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:12:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37061 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbYLQFMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:12:22 -0500
To: linux-audit@redhat.com
Subject: [PATCH 8/15] sanitize audit_mq_open()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoho-0000Cr-TT@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:12:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* don't bother with allocations
* don't do double copy_from_user()
* don't duplicate parts of check for audit_dummy_context()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    9 +++----
 ipc/mqueue.c          |   23 ++++++++---------
 kernel/auditsc.c      |   65 +++++++++++++++++-------------------------------
 3 files changed, 38 insertions(+), 59 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index dd3f62c..ed6bdfc 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -448,7 +448,7 @@ extern void audit_socketcall(int nargs, unsigned long *args);
 extern int audit_sockaddr(int len, void *addr);
 extern int __audit_fd_pair(int fd1, int fd2);
 extern int audit_set_macxattr(const char *name);
-extern int __audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr);
+extern void __audit_mq_open(int oflag, mode_t mode, struct mq_attr *attr);
 extern void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout);
 extern void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification);
 extern void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
@@ -469,11 +469,10 @@ static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid
 	if (unlikely(!audit_dummy_context()))
 		__audit_ipc_set_perm(qbytes, uid, gid, mode);
 }
-static inline int audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr)
+static inline void audit_mq_open(int oflag, mode_t mode, struct mq_attr *attr)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_mq_open(oflag, mode, u_attr);
-	return 0;
+		__audit_mq_open(oflag, mode, attr);
 }
 static inline void audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout)
 {
@@ -517,7 +516,7 @@ extern int audit_signals;
 #define audit_fd_pair(n,a) ({ 0; })
 #define audit_sockaddr(len, addr) ({ 0; })
 #define audit_set_macxattr(n) do { ; } while (0)
-#define audit_mq_open(o,m,a) ({ 0; })
+#define audit_mq_open(o,m,a) ((void)0)
 #define audit_mq_sendrecv(d,l,p,t) ((void)0)
 #define audit_mq_notify(d,n) ((void)0)
 #define audit_mq_getsetattr(d,s) ((void)0)
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 20fd43e..27199b9 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -588,21 +588,17 @@ static int mq_attr_ok(struct mq_attr *attr)
  * Invoked when creating a new queue via sys_mq_open
  */
 static struct file *do_create(struct dentry *dir, struct dentry *dentry,
-			int oflag, mode_t mode, struct mq_attr __user *u_attr)
+			int oflag, mode_t mode, struct mq_attr *attr)
 {
-	struct mq_attr attr;
 	struct file *result;
 	int ret;
 
-	if (u_attr) {
-		ret = -EFAULT;
-		if (copy_from_user(&attr, u_attr, sizeof(attr)))
-			goto out;
+	if (attr) {
 		ret = -EINVAL;
-		if (!mq_attr_ok(&attr))
+		if (!mq_attr_ok(attr))
 			goto out;
 		/* store for use during create */
-		dentry->d_fsdata = &attr;
+		dentry->d_fsdata = attr;
 	}
 
 	mode &= ~current->fs->umask;
@@ -657,11 +653,13 @@ asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
 	struct dentry *dentry;
 	struct file *filp;
 	char *name;
+	struct mq_attr attr;
 	int fd, error;
 
-	error = audit_mq_open(oflag, mode, u_attr);
-	if (error != 0)
-		return error;
+	if (u_attr && copy_from_user(&attr, u_attr, sizeof(struct mq_attr)))
+		return -EFAULT;
+
+	audit_mq_open(oflag, mode, u_attr ? &attr : NULL);
 
 	if (IS_ERR(name = getname(u_name)))
 		return PTR_ERR(name);
@@ -687,7 +685,8 @@ asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
 			filp = do_open(dentry, oflag);
 		} else {
 			filp = do_create(mqueue_mnt->mnt_root, dentry,
-						oflag, mode, u_attr);
+						oflag, mode,
+						u_attr ? &attr : NULL);
 		}
 	} else {
 		error = -ENOENT;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index fa8793d..ac89cd3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -112,13 +112,6 @@ struct audit_aux_data {
 /* Number of target pids per aux struct. */
 #define AUDIT_AUX_PIDS	16
 
-struct audit_aux_data_mq_open {
-	struct audit_aux_data	d;
-	int			oflag;
-	mode_t			mode;
-	struct mq_attr		attr;
-};
-
 struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
@@ -216,6 +209,11 @@ struct audit_context {
 			unsigned int		msg_prio;
 			struct timespec		abs_timeout;
 		} mq_sendrecv;
+		struct {
+			int			oflag;
+			mode_t			mode;
+			struct mq_attr		attr;
+		} mq_open;
 	};
 
 #if AUDIT_DEBUG
@@ -1204,6 +1202,16 @@ static void show_special(struct audit_context *context, int *call_panic)
 				return;
 		}
 		break; }
+	case AUDIT_MQ_OPEN: {
+		audit_log_format(ab,
+			"oflag=0x%x mode=%#o mq_flags=0x%lx mq_maxmsg=%ld "
+			"mq_msgsize=%ld mq_curmsgs=%ld",
+			context->mq_open.oflag, context->mq_open.mode,
+			context->mq_open.attr.mq_flags,
+			context->mq_open.attr.mq_maxmsg,
+			context->mq_open.attr.mq_msgsize,
+			context->mq_open.attr.mq_curmsgs);
+		break; }
 	case AUDIT_MQ_SENDRECV: {
 		audit_log_format(ab,
 			"mqdes=%d msg_len=%zd msg_prio=%u "
@@ -1307,15 +1315,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			continue; /* audit_panic has been called */
 
 		switch (aux->type) {
-		case AUDIT_MQ_OPEN: {
-			struct audit_aux_data_mq_open *axi = (void *)aux;
-			audit_log_format(ab,
-				"oflag=0x%x mode=%#o mq_flags=0x%lx mq_maxmsg=%ld "
-				"mq_msgsize=%ld mq_curmsgs=%ld",
-				axi->oflag, axi->mode, axi->attr.mq_flags,
-				axi->attr.mq_maxmsg, axi->attr.mq_msgsize,
-				axi->attr.mq_curmsgs);
-			break; }
 
 		case AUDIT_EXECVE: {
 			struct audit_aux_data_execve *axi = (void *)aux;
@@ -2021,38 +2020,20 @@ int audit_set_loginuid(struct task_struct *task, uid_t loginuid)
  * @mode: mode bits
  * @u_attr: queue attributes
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
-int __audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr)
+void __audit_mq_open(int oflag, mode_t mode, struct mq_attr *attr)
 {
-	struct audit_aux_data_mq_open *ax;
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
-	if (u_attr != NULL) {
-		if (copy_from_user(&ax->attr, u_attr, sizeof(ax->attr))) {
-			kfree(ax);
-			return -EFAULT;
-		}
-	} else
-		memset(&ax->attr, 0, sizeof(ax->attr));
+	if (attr)
+		memcpy(&context->mq_open.attr, attr, sizeof(struct mq_attr));
+	else
+		memset(&context->mq_open.attr, 0, sizeof(struct mq_attr));
 
-	ax->oflag = oflag;
-	ax->mode = mode;
+	context->mq_open.oflag = oflag;
+	context->mq_open.mode = mode;
 
-	ax->d.type = AUDIT_MQ_OPEN;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->type = AUDIT_MQ_OPEN;
 }
 
 /**
-- 
1.5.6.5


