Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZE3Wpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZE3Wpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbZE3WnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48879 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759220AbZE3WnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:20 -0400
Date: Sun, 31 May 2009 00:38:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 12/12 v3] ptrace: mv task_struct->ptrace_entry
	ptrace_ctx->entry
Message-ID: <20090530223848.GA30527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->ptrace_entry into ptrace_ctx->entry.

(we can change __ptrace_detach() to have the single ptrace_ctx arg).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h     |    4 +---
 include/linux/init_task.h |    1 -
 include/linux/ptrace.h    |    4 ++--
 kernel/exit.c             |    6 +++---
 kernel/ptrace.c           |   23 +++++++++++++----------
 5 files changed, 19 insertions(+), 19 deletions(-)

--- PTRACE/include/linux/sched.h~12_ENTRY	2009-05-30 23:58:55.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-31 00:01:39.000000000 +0200
@@ -1197,11 +1197,9 @@ struct task_struct {
 	struct ptrace_context *ptrace_ctx;
 	/*
 	 * ptraced is the list of tasks this task is using ptrace on.
-	 * This includes both natural children and PTRACE_ATTACH targets.
-	 * p->ptrace_entry is p's link on the p->parent->ptraced list.
+	 * p->ptrace_ctx->entry is p's link on the tracer->ptraced list.
 	 */
 	struct list_head ptraced;
-	struct list_head ptrace_entry;
 
 #ifdef CONFIG_X86_PTRACE_BTS
 	/*
--- PTRACE/include/linux/init_task.h~12_ENTRY	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/include/linux/init_task.h	2009-05-31 00:01:39.000000000 +0200
@@ -137,7 +137,6 @@ extern struct cred init_cred;
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
-	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
--- PTRACE/include/linux/ptrace.h~12_ENTRY	2009-05-30 23:58:55.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-31 00:01:39.000000000 +0200
@@ -80,6 +80,8 @@ struct ptrace_context {
 	struct task_struct	*tracer;
 	struct siginfo		*infop;
 	unsigned long		message;
+	struct task_struct	*tracee;
+	struct list_head	entry;
 };
 
 extern int alloc_ptrace_context(struct task_struct *child);
@@ -176,7 +178,6 @@ static inline int ptrace_event(int mask,
  */
 static inline void ptrace_init_task(struct task_struct *child)
 {
-	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
 
 	if (unlikely(child->ptrace_ctx) && ptrace_tracer(current))
@@ -194,7 +195,6 @@ static inline void ptrace_release_task(s
 {
 	BUG_ON(!list_empty(&task->ptraced));
 	ptrace_unlink(task);
-	BUG_ON(!list_empty(&task->ptrace_entry));
 }
 
 #ifndef force_successful_syscall_return
--- PTRACE/kernel/exit.c~12_ENTRY	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-31 00:01:39.000000000 +0200
@@ -1545,10 +1545,10 @@ static int do_wait_thread(struct wait_op
 
 static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 {
-	struct task_struct *p;
+	struct ptrace_context *ctx;
 
-	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, tsk, 1, p);
+	list_for_each_entry(ctx, &tsk->ptraced, entry) {
+		int ret = wait_consider_task(wo, tsk, 1, ctx->tracee);
 		if (ret)
 			return ret;
 	}
--- PTRACE/kernel/ptrace.c~12_ENTRY	2009-05-30 23:58:55.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-31 00:01:39.000000000 +0200
@@ -45,8 +45,8 @@ void ptrace_link(struct task_struct *chi
 {
 	child->ptrace_ctx->flags = flags | PT_PTRACED;
 
-	BUG_ON(!list_empty(&child->ptrace_entry));
-	list_add(&child->ptrace_entry, &tracer->ptraced);
+	BUG_ON(!list_empty(&child->ptrace_ctx->entry));
+	list_add(&child->ptrace_ctx->entry, &tracer->ptraced);
 	child->ptrace_ctx->tracer = tracer;
 }
 
@@ -86,7 +86,7 @@ void __ptrace_unlink(struct task_struct 
 
 	child->ptrace_ctx->flags = 0;
 	child->ptrace_ctx->tracer = NULL;
-	list_del_init(&child->ptrace_entry);
+	list_del_init(&child->ptrace_ctx->entry);
 
 	arch_ptrace_untrace(child);
 	if (task_is_traced(child))
@@ -193,6 +193,9 @@ int alloc_ptrace_context(struct task_str
 	if (unlikely(!ptrace_ctx))
 		return -ENOMEM;
 
+	ptrace_ctx->tracee = tsk;
+	INIT_LIST_HEAD(&ptrace_ctx->entry);
+
 	task_lock(tsk);
 	if (likely(!tsk->ptrace_ctx)) {
 		tsk->ptrace_ctx = ptrace_ctx;
@@ -364,21 +367,21 @@ int ptrace_detach(struct task_struct *ch
  */
 void exit_ptrace(struct task_struct *tracer)
 {
-	struct task_struct *p, *n;
+	struct ptrace_context *ctx, *tmp;
 	LIST_HEAD(ptrace_dead);
 
 	write_lock_irq(&tasklist_lock);
-	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
-		if (__ptrace_detach(tracer, p))
-			list_add(&p->ptrace_entry, &ptrace_dead);
+	list_for_each_entry_safe(ctx, tmp, &tracer->ptraced, entry) {
+		if (__ptrace_detach(tracer, ctx->tracee))
+			list_add(&ctx->entry, &ptrace_dead);
 	}
 	write_unlock_irq(&tasklist_lock);
 
 	BUG_ON(!list_empty(&tracer->ptraced));
 
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
+	list_for_each_entry_safe(ctx, tmp, &ptrace_dead, entry) {
+		list_del_init(&ctx->entry);
+		release_task(ctx->tracee);
 	}
 }
 

