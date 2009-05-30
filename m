Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbZE3Wpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbZE3Wpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbZE3WnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759262AbZE3WnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:20 -0400
Date: Sun, 31 May 2009 00:38:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 06/12 v3] ptrace: mv task_struct->ptrace
	ptrace_ctx->flags, kill ptrace_link()
Message-ID: <20090530223835.GA30501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->ptrace into ptrace_ctx->flags and change the users
accordingly.

Also, kill ptrace_link(). The only caller is ptrace_init_task(), and with
the recent changes we can check "is it traced" earlier, because ->flags
was already initialized by alloc_ptrace_context().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h  |    1 -
 include/linux/ptrace.h |   24 +++++++++---------------
 kernel/ptrace.c        |   16 ++++++++--------
 3 files changed, 17 insertions(+), 24 deletions(-)

--- PTRACE/include/linux/sched.h~06_MV_FLAGS	2009-05-30 22:48:10.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-30 23:28:49.000000000 +0200
@@ -1119,7 +1119,6 @@ struct task_struct {
 	void *stack;
 	atomic_t usage;
 	unsigned int flags;	/* per process flags, defined below */
-	unsigned int ptrace;
 
 	int lock_depth;		/* BKL lock depth */
 
--- PTRACE/include/linux/ptrace.h~06_MV_FLAGS	2009-05-30 23:14:03.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:28:49.000000000 +0200
@@ -51,10 +51,6 @@
 #ifdef __KERNEL__
 /*
  * Ptrace flags
- *
- * The owner ship rules for task->ptrace which holds the ptrace
- * flags is simple.  When a task is running it owns it's task->ptrace
- * flags.  When the a task is stopped the ptracer owns task->ptrace.
  */
 
 #define PT_PTRACED	0x00000001
@@ -80,6 +76,7 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 struct ptrace_context {
+	unsigned long	flags;
 };
 
 extern int alloc_ptrace_context(struct task_struct *child);
@@ -116,18 +113,16 @@ static inline int ptrace_reparented(stru
  * @task:	pointer to &task_struct in question
  *
  * Returns the %PT_* flags that apply to @task.
+ *
+ * Once allocated, ->ptrace_ctx is never freed until @task is freed,
+ * so this access is always safe.
  */
 static inline int task_ptrace(struct task_struct *task)
 {
-	return task->ptrace;
+	return unlikely(task->ptrace_ctx) ?
+		task->ptrace_ctx->flags : 0;
 }
 
-static inline void ptrace_link(struct task_struct *child,
-			       struct task_struct *new_parent)
-{
-	if (unlikely(task_ptrace(child)))
-		__ptrace_link(child, new_parent);
-}
 static inline void ptrace_unlink(struct task_struct *child)
 {
 	if (unlikely(task_ptrace(child)))
@@ -173,10 +168,9 @@ static inline void ptrace_init_task(stru
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
 	child->parent = child->real_parent;
-	child->ptrace = 0;
-	if (unlikely(child->ptrace_ctx)) {
-		child->ptrace = current->ptrace;
-		ptrace_link(child, current->parent);
+	if (unlikely(child->ptrace_ctx) && task_ptrace(current)) {
+		child->ptrace_ctx->flags = task_ptrace(current);
+		__ptrace_link(child, current->parent);
 	}
 }
 
--- PTRACE/kernel/ptrace.c~06_MV_FLAGS	2009-05-30 22:57:15.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-30 23:28:49.000000000 +0200
@@ -81,7 +81,7 @@ void __ptrace_unlink(struct task_struct 
 {
 	BUG_ON(!task_ptrace(child));
 
-	child->ptrace = 0;
+	child->ptrace_ctx->flags = 0;
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
@@ -237,9 +237,9 @@ int ptrace_attach(struct task_struct *ta
 	if (task_ptrace(task))
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
+	task->ptrace_ctx->flags = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
-		task->ptrace |= PT_PTRACE_CAP;
+		task->ptrace_ctx->flags |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
@@ -277,7 +277,7 @@ int ptrace_traceme(void)
 		 * pretend ->real_parent untraces us right after return.
 		 */
 		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
-			current->ptrace = PT_PTRACED;
+			current->ptrace_ctx->flags = PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}
 	}
@@ -435,7 +435,7 @@ int ptrace_writedata(struct task_struct 
 	return copied;
 }
 
-static int ptrace_setoptions(struct task_struct *child, long data)
+static int ptrace_setoptions(struct ptrace_context *ptrace_ctx, long data)
 {
 	unsigned int new_flags = 0;
 
@@ -460,8 +460,8 @@ static int ptrace_setoptions(struct task
 	if (data & PTRACE_O_TRACEEXIT)
 		new_flags |= PT_TRACE_EXIT;
 
-	child->ptrace &= ~PT_TRACE_MASK;
-	child->ptrace |= new_flags;
+	ptrace_ctx->flags &= ~PT_TRACE_MASK;
+	ptrace_ctx->flags |= new_flags;
 	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
 }
 
@@ -573,7 +573,7 @@ int ptrace_request(struct task_struct *c
 	case PTRACE_OLDSETOPTIONS:
 #endif
 	case PTRACE_SETOPTIONS:
-		ret = ptrace_setoptions(child, data);
+		ret = ptrace_setoptions(child->ptrace_ctx, data);
 		break;
 	case PTRACE_GETEVENTMSG:
 		ret = put_user(child->ptrace_message, (unsigned long __user *) data);

