Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758831AbYLQFLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYLQFLe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYLQFLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:11:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYLQFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:11:12 -0500
To: linux-audit@redhat.com
Subject: [PATCH 1/15] don't reallocate buffer in every audit_sockaddr()
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCogg-00008b-SH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:11:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to do that more than once per process lifetime; allocating/freeing
on each sendto/accept/etc. is bloody pointless.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/auditsc.c |   46 ++++++++++++++++++++++------------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2a3f0af..aca9ddb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -162,12 +162,6 @@ struct audit_aux_data_socketcall {
 	unsigned long		args[0];
 };
 
-struct audit_aux_data_sockaddr {
-	struct audit_aux_data	d;
-	int			len;
-	char			a[0];
-};
-
 struct audit_aux_data_fd_pair {
 	struct	audit_aux_data d;
 	int	fd[2];
@@ -208,7 +202,8 @@ struct audit_context {
 	struct audit_context *previous; /* For nested syscalls */
 	struct audit_aux_data *aux;
 	struct audit_aux_data *aux_pids;
-
+	struct sockaddr_storage *sockaddr;
+	size_t sockaddr_len;
 				/* Save things to print about task_struct */
 	pid_t		    pid, ppid;
 	uid_t		    uid, euid, suid, fsuid;
@@ -891,6 +886,7 @@ static inline void audit_free_context(struct audit_context *context)
 		free_tree_refs(context);
 		audit_free_aux(context);
 		kfree(context->filterkey);
+		kfree(context->sockaddr);
 		kfree(context);
 		context  = previous;
 	} while (context);
@@ -1322,13 +1318,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 				audit_log_format(ab, " a%d=%lx", i, axs->args[i]);
 			break; }
 
-		case AUDIT_SOCKADDR: {
-			struct audit_aux_data_sockaddr *axs = (void *)aux;
-
-			audit_log_format(ab, "saddr=");
-			audit_log_n_hex(ab, axs->a, axs->len);
-			break; }
-
 		case AUDIT_FD_PAIR: {
 			struct audit_aux_data_fd_pair *axs = (void *)aux;
 			audit_log_format(ab, "fd0=%d fd1=%d", axs->fd[0], axs->fd[1]);
@@ -1338,6 +1327,16 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 		audit_log_end(ab);
 	}
 
+	if (context->sockaddr_len) {
+		ab = audit_log_start(context, GFP_KERNEL, AUDIT_SOCKADDR);
+		if (ab) {
+			audit_log_format(ab, "saddr=");
+			audit_log_n_hex(ab, (void *)context->sockaddr,
+					context->sockaddr_len);
+			audit_log_end(ab);
+		}
+	}
+
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
 
@@ -1604,6 +1603,7 @@ void audit_syscall_exit(int valid, long return_code)
 		context->aux_pids = NULL;
 		context->target_pid = 0;
 		context->target_sid = 0;
+		context->sockaddr_len = 0;
 		kfree(context->filterkey);
 		context->filterkey = NULL;
 		tsk->audit_context = context;
@@ -2354,22 +2354,20 @@ int __audit_fd_pair(int fd1, int fd2)
  */
 int audit_sockaddr(int len, void *a)
 {
-	struct audit_aux_data_sockaddr *ax;
 	struct audit_context *context = current->audit_context;
 
 	if (likely(!context || context->dummy))
 		return 0;
 
-	ax = kmalloc(sizeof(*ax) + len, GFP_KERNEL);
-	if (!ax)
-		return -ENOMEM;
-
-	ax->len = len;
-	memcpy(ax->a, a, len);
+	if (!context->sockaddr) {
+		void *p = kmalloc(sizeof(struct sockaddr_storage), GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+		context->sockaddr = p;
+	}
 
-	ax->d.type = AUDIT_SOCKADDR;
-	ax->d.next = context->aux;
-	context->aux = (void *)ax;
+	context->sockaddr_len = len;
+	memcpy(context->sockaddr, a, len);
 	return 0;
 }
 
-- 
1.5.6.5


