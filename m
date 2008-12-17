Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759241AbYLQFLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYLQFLt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbYLQFLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:11:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37012 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbYLQFLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:11:22 -0500
To: linux-audit@redhat.com
Subject: [PATCH 2/15] sanitize audit_socketcall
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCogq-00008v-SR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:11:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* don't bother with allocations
* now that it can't fail, make it return void

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    4 +-
 kernel/auditsc.c      |   66 ++++++++++++++++++++++++++++--------------------
 net/socket.c          |    4 +--
 3 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 8f0672d..e59feb9 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -444,7 +444,7 @@ extern void audit_log_task_context(struct audit_buffer *ab);
 extern int __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode);
 extern int audit_bprm(struct linux_binprm *bprm);
-extern int audit_socketcall(int nargs, unsigned long *args);
+extern void audit_socketcall(int nargs, unsigned long *args);
 extern int audit_sockaddr(int len, void *addr);
 extern int __audit_fd_pair(int fd1, int fd2);
 extern int audit_set_macxattr(const char *name);
@@ -525,7 +525,7 @@ extern int audit_signals;
 #define audit_ipc_obj(i) ({ 0; })
 #define audit_ipc_set_perm(q,u,g,m) ({ 0; })
 #define audit_bprm(p) ({ 0; })
-#define audit_socketcall(n,a) ({ 0; })
+#define audit_socketcall(n,a) ((void)0)
 #define audit_fd_pair(n,a) ({ 0; })
 #define audit_sockaddr(len, addr) ({ 0; })
 #define audit_set_macxattr(n) do { ; } while (0)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index aca9ddb..1d53aa8 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -156,12 +156,6 @@ struct audit_aux_data_execve {
 	struct mm_struct *mm;
 };
 
-struct audit_aux_data_socketcall {
-	struct audit_aux_data	d;
-	int			nargs;
-	unsigned long		args[0];
-};
-
 struct audit_aux_data_fd_pair {
 	struct	audit_aux_data d;
 	int	fd[2];
@@ -221,6 +215,14 @@ struct audit_context {
 	struct audit_tree_refs *trees, *first_trees;
 	int tree_count;
 
+	int type;
+	union {
+		struct {
+			int nargs;
+			long args[6];
+		} socketcall;
+	};
+
 #if AUDIT_DEBUG
 	int		    put_count;
 	int		    ino_count;
@@ -1167,6 +1169,27 @@ static void audit_log_execve_info(struct audit_context *context,
 	kfree(buf);
 }
 
+static void show_special(struct audit_context *context)
+{
+	struct audit_buffer *ab;
+	int i;
+
+	ab = audit_log_start(context, GFP_KERNEL, context->type);
+	if (!ab)
+		return;
+
+	switch (context->type) {
+	case AUDIT_SOCKETCALL: {
+		int nargs = context->socketcall.nargs;
+		audit_log_format(ab, "nargs=%d", nargs);
+		for (i = 0; i < nargs; i++)
+			audit_log_format(ab, " a%d=%lx", i,
+				context->socketcall.args[i]);
+		break; }
+	}
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -1311,13 +1334,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_execve_info(context, &ab, axi);
 			break; }
 
-		case AUDIT_SOCKETCALL: {
-			struct audit_aux_data_socketcall *axs = (void *)aux;
-			audit_log_format(ab, "nargs=%d", axs->nargs);
-			for (i=0; i<axs->nargs; i++)
-				audit_log_format(ab, " a%d=%lx", i, axs->args[i]);
-			break; }
-
 		case AUDIT_FD_PAIR: {
 			struct audit_aux_data_fd_pair *axs = (void *)aux;
 			audit_log_format(ab, "fd0=%d fd1=%d", axs->fd[0], axs->fd[1]);
@@ -1327,6 +1343,9 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 		audit_log_end(ab);
 	}
 
+	if (context->type)
+		show_special(context);
+
 	if (context->sockaddr_len) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_SOCKADDR);
 		if (ab) {
@@ -1604,6 +1623,7 @@ void audit_syscall_exit(int valid, long return_code)
 		context->target_pid = 0;
 		context->target_sid = 0;
 		context->sockaddr_len = 0;
+		context->type = 0;
 		kfree(context->filterkey);
 		context->filterkey = NULL;
 		tsk->audit_context = context;
@@ -2292,27 +2312,17 @@ int audit_bprm(struct linux_binprm *bprm)
  * @nargs: number of args
  * @args: args array
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
-int audit_socketcall(int nargs, unsigned long *args)
+void audit_socketcall(int nargs, unsigned long *args)
 {
-	struct audit_aux_data_socketcall *ax;
 	struct audit_context *context = current->audit_context;
 
 	if (likely(!context || context->dummy))
-		return 0;
-
-	ax = kmalloc(sizeof(*ax) + nargs * sizeof(unsigned long), GFP_KERNEL);
-	if (!ax)
-		return -ENOMEM;
-
-	ax->nargs = nargs;
-	memcpy(ax->args, args, nargs * sizeof(unsigned long));
+		return;
 
-	ax->d.type = AUDIT_SOCKETCALL;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->type = AUDIT_SOCKETCALL;
+	context->socketcall.nargs = nargs;
+	memcpy(context->socketcall.args, args, nargs * sizeof(unsigned long));
 }
 
 /**
diff --git a/net/socket.c b/net/socket.c
index 92764d8..aba5a50 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2066,9 +2066,7 @@ asmlinkage long sys_socketcall(int call, unsigned long __user *args)
 	if (copy_from_user(a, args, nargs[call]))
 		return -EFAULT;
 
-	err = audit_socketcall(nargs[call] / sizeof(unsigned long), a);
-	if (err)
-		return err;
+	audit_socketcall(nargs[call] / sizeof(unsigned long), a);
 
 	a0 = a[0];
 	a1 = a[1];
-- 
1.5.6.5


