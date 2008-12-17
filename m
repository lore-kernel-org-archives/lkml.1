Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759400AbYLQFMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYLQFMO (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYLQFLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:11:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37013 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYLQFLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:11:32 -0500
To: linux-audit@redhat.com
Subject: [PATCH 3/15] sanitize audit_ipc_obj()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoh0-00009T-Sd@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:11:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* get rid of allocations
* make it return void
* simplify callers

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    9 ++---
 ipc/shm.c             |    4 +--
 ipc/util.c            |    9 ++---
 kernel/auditsc.c      |   88 ++++++++++++++++++++----------------------------
 4 files changed, 45 insertions(+), 65 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index e59feb9..97598f0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -441,7 +441,7 @@ extern int  audit_set_loginuid(struct task_struct *task, uid_t loginuid);
 #define audit_get_loginuid(t) ((t)->loginuid)
 #define audit_get_sessionid(t) ((t)->sessionid)
 extern void audit_log_task_context(struct audit_buffer *ab);
-extern int __audit_ipc_obj(struct kern_ipc_perm *ipcp);
+extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode);
 extern int audit_bprm(struct linux_binprm *bprm);
 extern void audit_socketcall(int nargs, unsigned long *args);
@@ -454,11 +454,10 @@ extern int __audit_mq_timedreceive(mqd_t mqdes, size_t msg_len, unsigned int __u
 extern int __audit_mq_notify(mqd_t mqdes, const struct sigevent __user *u_notification);
 extern int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 
-static inline int audit_ipc_obj(struct kern_ipc_perm *ipcp)
+static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_ipc_obj(ipcp);
-	return 0;
+		__audit_ipc_obj(ipcp);
 }
 static inline int audit_fd_pair(int fd1, int fd2)
 {
@@ -522,7 +521,7 @@ extern int audit_signals;
 #define audit_get_loginuid(t) (-1)
 #define audit_get_sessionid(t) (-1)
 #define audit_log_task_context(b) do { ; } while (0)
-#define audit_ipc_obj(i) ({ 0; })
+#define audit_ipc_obj(i) ((void)0)
 #define audit_ipc_set_perm(q,u,g,m) ({ 0; })
 #define audit_bprm(p) ({ 0; })
 #define audit_socketcall(n,a) ((void)0)
diff --git a/ipc/shm.c b/ipc/shm.c
index 867e5d6..e40065e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -747,9 +747,7 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out;
 		}
 
-		err = audit_ipc_obj(&(shp->shm_perm));
-		if (err)
-			goto out_unlock;
+		audit_ipc_obj(&(shp->shm_perm));
 
 		if (!capable(CAP_IPC_LOCK)) {
 			err = -EPERM;
diff --git a/ipc/util.c b/ipc/util.c
index 361fd1c..0aa8ed8 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -620,10 +620,9 @@ void ipc_rcu_putref(void *ptr)
  
 int ipcperms (struct kern_ipc_perm *ipcp, short flag)
 {	/* flag will most probably be 0 or S_...UGO from <linux/stat.h> */
-	int requested_mode, granted_mode, err;
+	int requested_mode, granted_mode;
 
-	if (unlikely((err = audit_ipc_obj(ipcp))))
-		return err;
+	audit_ipc_obj(ipcp);
 	requested_mode = (flag >> 6) | (flag >> 3) | flag;
 	granted_mode = ipcp->mode;
 	if (current->euid == ipcp->cuid || current->euid == ipcp->uid)
@@ -797,9 +796,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 		goto out_up;
 	}
 
-	err = audit_ipc_obj(ipcp);
-	if (err)
-		goto out_unlock;
+	audit_ipc_obj(ipcp);
 
 	if (cmd == IPC_SET) {
 		err = audit_ipc_set_perm(extra_perm, perm->uid,
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 1d53aa8..c136047 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -221,6 +221,12 @@ struct audit_context {
 			int nargs;
 			long args[6];
 		} socketcall;
+		struct {
+			uid_t			uid;
+			gid_t			gid;
+			mode_t			mode;
+			u32			osid;
+		} ipc;
 	};
 
 #if AUDIT_DEBUG
@@ -578,19 +584,12 @@ static int audit_filter_rules(struct task_struct *tsk,
 					}
 				}
 				/* Find ipc objects that match */
-				if (ctx) {
-					struct audit_aux_data *aux;
-					for (aux = ctx->aux; aux;
-					     aux = aux->next) {
-						if (aux->type == AUDIT_IPC) {
-							struct audit_aux_data_ipcctl *axi = (void *)aux;
-							if (security_audit_rule_match(axi->osid, f->type, f->op, f->lsm_rule, ctx)) {
-								++result;
-								break;
-							}
-						}
-					}
-				}
+				if (!ctx || ctx->type != AUDIT_IPC)
+					break;
+				if (security_audit_rule_match(ctx->ipc.osid,
+							      f->type, f->op,
+							      f->lsm_rule, ctx))
+					++result;
 			}
 			break;
 		case AUDIT_ARG0:
@@ -1169,7 +1168,7 @@ static void audit_log_execve_info(struct audit_context *context,
 	kfree(buf);
 }
 
-static void show_special(struct audit_context *context)
+static void show_special(struct audit_context *context, int *call_panic)
 {
 	struct audit_buffer *ab;
 	int i;
@@ -1186,6 +1185,23 @@ static void show_special(struct audit_context *context)
 			audit_log_format(ab, " a%d=%lx", i,
 				context->socketcall.args[i]);
 		break; }
+	case AUDIT_IPC: {
+		u32 osid = context->ipc.osid;
+
+		audit_log_format(ab, "ouid=%u ogid=%u mode=%#o",
+			 context->ipc.uid, context->ipc.gid, context->ipc.mode);
+		if (osid) {
+			char *ctx = NULL;
+			u32 len;
+			if (security_secid_to_secctx(osid, &ctx, &len)) {
+				audit_log_format(ab, " osid=%u", osid);
+				*call_panic = 1;
+			} else {
+				audit_log_format(ab, " obj=%s", ctx);
+				security_release_secctx(ctx, len);
+			}
+		}
+		break; }
 	}
 	audit_log_end(ab);
 }
@@ -1302,26 +1318,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				axi->mqstat.mq_msgsize, axi->mqstat.mq_curmsgs);
 			break; }
 
-		case AUDIT_IPC: {
-			struct audit_aux_data_ipcctl *axi = (void *)aux;
-			audit_log_format(ab, 
-				 "ouid=%u ogid=%u mode=%#o",
-				 axi->uid, axi->gid, axi->mode);
-			if (axi->osid != 0) {
-				char *ctx = NULL;
-				u32 len;
-				if (security_secid_to_secctx(
-						axi->osid, &ctx, &len)) {
-					audit_log_format(ab, " osid=%u",
-							axi->osid);
-					call_panic = 1;
-				} else {
-					audit_log_format(ab, " obj=%s", ctx);
-					security_release_secctx(ctx, len);
-				}
-			}
-			break; }
-
 		case AUDIT_IPC_SET_PERM: {
 			struct audit_aux_data_ipcctl *axi = (void *)aux;
 			audit_log_format(ab,
@@ -1344,7 +1340,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	}
 
 	if (context->type)
-		show_special(context);
+		show_special(context, &call_panic);
 
 	if (context->sockaddr_len) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_SOCKADDR);
@@ -2235,25 +2231,15 @@ int __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
  * audit_ipc_obj - record audit data for ipc object
  * @ipcp: ipc permissions
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
-int __audit_ipc_obj(struct kern_ipc_perm *ipcp)
+void __audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
-	struct audit_aux_data_ipcctl *ax;
 	struct audit_context *context = current->audit_context;
-
-	ax = kmalloc(sizeof(*ax), GFP_ATOMIC);
-	if (!ax)
-		return -ENOMEM;
-
-	ax->uid = ipcp->uid;
-	ax->gid = ipcp->gid;
-	ax->mode = ipcp->mode;
-	security_ipc_getsecid(ipcp, &ax->osid);
-	ax->d.type = AUDIT_IPC;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->ipc.uid = ipcp->uid;
+	context->ipc.gid = ipcp->gid;
+	context->ipc.mode = ipcp->mode;
+	security_ipc_getsecid(ipcp, &context->ipc.osid);
+	context->type = AUDIT_IPC;
 }
 
 /**
-- 
1.5.6.5


