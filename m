Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759847AbYLQFOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYLQFOY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYLQFMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:12:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37065 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbYLQFMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:12:32 -0500
To: linux-audit@redhat.com
Subject: [PATCH 9/15] sanitize audit_fd_pair()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCohy-0000De-Tc@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:12:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* no allocations
* return void

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/pipe.c             |    7 +------
 include/linux/audit.h |    9 ++++-----
 kernel/auditsc.c      |   44 ++++++++++++++------------------------------
 net/socket.c          |    9 +--------
 4 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 7aea8b8..5341421 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1016,10 +1016,7 @@ int do_pipe_flags(int *fd, int flags)
 		goto err_fdr;
 	fdw = error;
 
-	error = audit_fd_pair(fdr, fdw);
-	if (error < 0)
-		goto err_fdw;
-
+	audit_fd_pair(fdr, fdw);
 	fd_install(fdr, fr);
 	fd_install(fdw, fw);
 	fd[0] = fdr;
@@ -1027,8 +1024,6 @@ int do_pipe_flags(int *fd, int flags)
 
 	return 0;
 
- err_fdw:
-	put_unused_fd(fdw);
  err_fdr:
 	put_unused_fd(fdr);
  err_read_pipe:
diff --git a/include/linux/audit.h b/include/linux/audit.h
index ed6bdfc..c5e95e7 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -446,7 +446,7 @@ extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mod
 extern int audit_bprm(struct linux_binprm *bprm);
 extern void audit_socketcall(int nargs, unsigned long *args);
 extern int audit_sockaddr(int len, void *addr);
-extern int __audit_fd_pair(int fd1, int fd2);
+extern void __audit_fd_pair(int fd1, int fd2);
 extern int audit_set_macxattr(const char *name);
 extern void __audit_mq_open(int oflag, mode_t mode, struct mq_attr *attr);
 extern void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout);
@@ -458,11 +458,10 @@ static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 	if (unlikely(!audit_dummy_context()))
 		__audit_ipc_obj(ipcp);
 }
-static inline int audit_fd_pair(int fd1, int fd2)
+static inline void audit_fd_pair(int fd1, int fd2)
 {
 	if (unlikely(!audit_dummy_context()))
-		return __audit_fd_pair(fd1, fd2);
-	return 0;
+		__audit_fd_pair(fd1, fd2);
 }
 static inline void audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode)
 {
@@ -513,7 +512,7 @@ extern int audit_signals;
 #define audit_ipc_set_perm(q,u,g,m) ((void)0)
 #define audit_bprm(p) ({ 0; })
 #define audit_socketcall(n,a) ((void)0)
-#define audit_fd_pair(n,a) ({ 0; })
+#define audit_fd_pair(n,a) ((void)0)
 #define audit_sockaddr(len, addr) ({ 0; })
 #define audit_set_macxattr(n) do { ; } while (0)
 #define audit_mq_open(o,m,a) ((void)0)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index ac89cd3..5de0087 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -119,11 +119,6 @@ struct audit_aux_data_execve {
 	struct mm_struct *mm;
 };
 
-struct audit_aux_data_fd_pair {
-	struct	audit_aux_data d;
-	int	fd[2];
-};
-
 struct audit_aux_data_pids {
 	struct audit_aux_data	d;
 	pid_t			target_pid[AUDIT_AUX_PIDS];
@@ -215,6 +210,7 @@ struct audit_context {
 			struct mq_attr		attr;
 		} mq_open;
 	};
+	int fds[2];
 
 #if AUDIT_DEBUG
 	int		    put_count;
@@ -1321,11 +1317,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_execve_info(context, &ab, axi);
 			break; }
 
-		case AUDIT_FD_PAIR: {
-			struct audit_aux_data_fd_pair *axs = (void *)aux;
-			audit_log_format(ab, "fd0=%d fd1=%d", axs->fd[0], axs->fd[1]);
-			break; }
-
 		}
 		audit_log_end(ab);
 	}
@@ -1333,6 +1324,15 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 	if (context->type)
 		show_special(context, &call_panic);
 
+	if (context->fds[0] >= 0) {
+		ab = audit_log_start(context, GFP_KERNEL, AUDIT_FD_PAIR);
+		if (ab) {
+			audit_log_format(ab, "fd0=%d fd1=%d",
+					context->fds[0], context->fds[1]);
+			audit_log_end(ab);
+		}
+	}
+
 	if (context->sockaddr_len) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_SOCKADDR);
 		if (ab) {
@@ -1611,6 +1611,7 @@ void audit_syscall_exit(int valid, long return_code)
 		context->target_sid = 0;
 		context->sockaddr_len = 0;
 		context->type = 0;
+		context->fds[0] = -1;
 		kfree(context->filterkey);
 		context->filterkey = NULL;
 		tsk->audit_context = context;
@@ -2177,29 +2178,12 @@ void audit_socketcall(int nargs, unsigned long *args)
  * @fd1: the first file descriptor
  * @fd2: the second file descriptor
  *
- * Returns 0 for success or NULL context or < 0 on error.
  */
-int __audit_fd_pair(int fd1, int fd2)
+void __audit_fd_pair(int fd1, int fd2)
 {
 	struct audit_context *context = current->audit_context;
-	struct audit_aux_data_fd_pair *ax;
-
-	if (likely(!context)) {
-		return 0;
-	}
-
-	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
-	if (!ax) {
-		return -ENOMEM;
-	}
-
-	ax->fd[0] = fd1;
-	ax->fd[1] = fd2;
-
-	ax->d.type = AUDIT_FD_PAIR;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
-	return 0;
+	context->fds[0] = fd1;
+	context->fds[1] = fd2;
 }
 
 /**
diff --git a/net/socket.c b/net/socket.c
index aba5a50..a383608 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1314,13 +1314,7 @@ asmlinkage long sys_socketpair(int family, int type, int protocol,
 		goto out_fd1;
 	}
 
-	err = audit_fd_pair(fd1, fd2);
-	if (err < 0) {
-		fput(newfile1);
-		fput(newfile2);
-		goto out_fd;
-	}
-
+	audit_fd_pair(fd1, fd2);
 	fd_install(fd1, newfile1);
 	fd_install(fd2, newfile2);
 	/* fd1 and fd2 may be already another descriptors.
@@ -1350,7 +1344,6 @@ out_fd2:
 out_fd1:
 	put_filp(newfile2);
 	sock_release(sock2);
-out_fd:
 	put_unused_fd(fd1);
 	put_unused_fd(fd2);
 	goto out;
-- 
1.5.6.5


