Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759521AbYLQFMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYLQFMm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbYLQFLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:11:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37016 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011AbYLQFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:11:42 -0500
To: linux-audit@redhat.com
Subject: [PATCH 4/15] sanitize audit_ipc_set_perm()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCohA-00009y-Sm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:11:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* get rid of allocations
* make it return void
* simplify callers

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    9 +++----
 ipc/util.c            |   10 ++-----
 kernel/auditsc.c      |   59 +++++++++++++++++++++---------------------------
 3 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 97598f0..cd4b1f7 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -442,7 +442,7 @@ extern int  audit_set_loginuid(struct task_struct *task, uid_t loginuid);
 #define audit_get_sessionid(t) ((t)->sessionid)
 extern void audit_log_task_context(struct audit_buffer *ab);
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
-extern int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode);
+extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode);
 extern int audit_bprm(struct linux_binprm *bprm);
 extern void audit_socketcall(int nargs, unsigned long *args);
 extern int audit_sockaddr(int len, void *addr);
@@ -465,11 +465,10 @@ static inline int audit_fd_pair(int fd1, int fd2)
 		return __audit_fd_pair(fd1, fd2);
 	return 0;
 }
-static inline int audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode)
+static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_ipc_set_perm(qbytes, uid, gid, mode);
-	return 0;
+		__audit_ipc_set_perm(qbytes, uid, gid, mode);
 }
 static inline int audit_mq_open(int oflag, mode_t mode, struct mq_attr __user *u_attr)
 {
@@ -522,7 +521,7 @@ extern int audit_signals;
 #define audit_get_sessionid(t) (-1)
 #define audit_log_task_context(b) do { ; } while (0)
 #define audit_ipc_obj(i) ((void)0)
-#define audit_ipc_set_perm(q,u,g,m) ({ 0; })
+#define audit_ipc_set_perm(q,u,g,m) ((void)0)
 #define audit_bprm(p) ({ 0; })
 #define audit_socketcall(n,a) ((void)0)
 #define audit_fd_pair(n,a) ({ 0; })
diff --git a/ipc/util.c b/ipc/util.c
index 0aa8ed8..b9f328b 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -797,19 +797,15 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 	}
 
 	audit_ipc_obj(ipcp);
-
-	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(extra_perm, perm->uid,
+	if (cmd == IPC_SET)
+		audit_ipc_set_perm(extra_perm, perm->uid,
 					 perm->gid, perm->mode);
-		if (err)
-			goto out_unlock;
-	}
+
 	if (current->euid == ipcp->cuid ||
 	    current->euid == ipcp->uid || capable(CAP_SYS_ADMIN))
 		return ipcp;
 
 	err = -EPERM;
-out_unlock:
 	ipc_unlock(ipcp);
 out_up:
 	up_write(&ids->rw_mutex);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c136047..9d4ac11 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -139,16 +139,6 @@ struct audit_aux_data_mq_getsetattr {
 	struct mq_attr 		mqstat;
 };
 
-struct audit_aux_data_ipcctl {
-	struct audit_aux_data	d;
-	struct ipc_perm		p;
-	unsigned long		qbytes;
-	uid_t			uid;
-	gid_t			gid;
-	mode_t			mode;
-	u32			osid;
-};
-
 struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
@@ -226,6 +216,11 @@ struct audit_context {
 			gid_t			gid;
 			mode_t			mode;
 			u32			osid;
+			int			has_perm;
+			uid_t			perm_uid;
+			gid_t			perm_gid;
+			mode_t			perm_mode;
+			unsigned long		qbytes;
 		} ipc;
 	};
 
@@ -1201,6 +1196,19 @@ static void show_special(struct audit_context *context, int *call_panic)
 				security_release_secctx(ctx, len);
 			}
 		}
+		if (context->ipc.has_perm) {
+			audit_log_end(ab);
+			ab = audit_log_start(context, GFP_KERNEL,
+					     AUDIT_IPC_SET_PERM);
+			audit_log_format(ab,
+				"qbytes=%lx ouid=%u ogid=%u mode=%#o",
+				context->ipc.qbytes,
+				context->ipc.perm_uid,
+				context->ipc.perm_gid,
+				context->ipc.perm_mode);
+			if (!ab)
+				return;
+		}
 		break; }
 	}
 	audit_log_end(ab);
@@ -1318,13 +1326,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				axi->mqstat.mq_msgsize, axi->mqstat.mq_curmsgs);
 			break; }
 
-		case AUDIT_IPC_SET_PERM: {
-			struct audit_aux_data_ipcctl *axi = (void *)aux;
-			audit_log_format(ab,
-				"qbytes=%lx ouid=%u ogid=%u mode=%#o",
-				axi->qbytes, axi->uid, axi->gid, axi->mode);
-			break; }
-
 		case AUDIT_EXECVE: {
 			struct audit_aux_data_execve *axi = (void *)aux;
 			audit_log_execve_info(context, &ab, axi);
@@ -2238,6 +2239,7 @@ void __audit_ipc_obj(struct kern_ipc_perm *ipcp)
 	context->ipc.uid = ipcp->uid;
 	context->ipc.gid = ipcp->gid;
 	context->ipc.mode = ipcp->mode;
+	context->ipc.has_perm = 0;
 	security_ipc_getsecid(ipcp, &context->ipc.osid);
 	context->type = AUDIT_IPC;
 }
@@ -2249,26 +2251,17 @@ void __audit_ipc_obj(struct kern_ipc_perm *ipcp)
  * @gid: msgq group id
  * @mode: msgq mode (permissions)
  *
- * Returns 0 for success or NULL context or < 0 on error.
+ * Called only after audit_ipc_obj().
  */
-int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode)
+void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode)
 {
-	struct audit_aux_data_ipcctl *ax;
 	struct audit_context *context = current->audit_context;
 
-	ax = kmalloc(sizeof(*ax), GFP_ATOMIC);
-	if (!ax)
-		return -ENOMEM;
-
-	ax->qbytes = qbytes;
-	ax->uid = uid;
-	ax->gid = gid;
-	ax->mode = mode;
-
-	ax->d.type = AUDIT_IPC_SET_PERM;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->ipc.qbytes = qbytes;
+	context->ipc.perm_uid = uid;
+	context->ipc.perm_gid = gid;
+	context->ipc.perm_mode = mode;
+	context->ipc.has_perm = 1;
 }
 
 int audit_bprm(struct linux_binprm *bprm)
-- 
1.5.6.5


