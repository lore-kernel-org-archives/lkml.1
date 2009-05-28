Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZE1LmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZE1LmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZE1Lkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:40:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201AbZE1Lk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:40:27 -0400
Date: Thu, 28 May 2009 13:35:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/12 v2] ptrace: avoid using task->ptrace when possible
	in ptrace.{c,h}
Message-ID: <20090528113543.GA18688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do some s/->ptrace/task_ptrace()/ changes in ptrace.{c,h} as a preparation
for the future changes.

Change ptrace_setoptions() to access ->ptrace only once.

 include/linux/ptrace.h |   31 ++++++++++++++++---------------
 kernel/ptrace.c        |   28 +++++++++++++++-------------
 2 files changed, 31 insertions(+), 28 deletions(-)

--- PTRACE/include/linux/ptrace.h~2_PTRACE	2009-05-24 21:36:37.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-28 06:26:19.000000000 +0200
@@ -106,15 +106,27 @@ static inline int ptrace_reparented(stru
 {
 	return child->real_parent != child->parent;
 }
+
+/**
+ * task_ptrace - return %PT_* flags that apply to a task
+ * @task:	pointer to &task_struct in question
+ *
+ * Returns the %PT_* flags that apply to @task.
+ */
+static inline int task_ptrace(struct task_struct *task)
+{
+	return task->ptrace;
+}
+
 static inline void ptrace_link(struct task_struct *child,
 			       struct task_struct *new_parent)
 {
-	if (unlikely(child->ptrace))
+	if (unlikely(task_ptrace(child)))
 		__ptrace_link(child, new_parent);
 }
 static inline void ptrace_unlink(struct task_struct *child)
 {
-	if (unlikely(child->ptrace))
+	if (unlikely(task_ptrace(child)))
 		__ptrace_unlink(child);
 }
 
@@ -122,19 +134,8 @@ int generic_ptrace_peekdata(struct task_
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 
 /**
- * task_ptrace - return %PT_* flags that apply to a task
- * @task:	pointer to &task_struct in question
- *
- * Returns the %PT_* flags that apply to @task.
- */
-static inline int task_ptrace(struct task_struct *task)
-{
-	return task->ptrace;
-}
-
-/**
  * ptrace_event - possibly stop for a ptrace event notification
- * @mask:	%PT_* bit to check in @current->ptrace
+ * @mask:	%PT_* bit to check in task_ptrace(@current)
  * @event:	%PTRACE_EVENT_* value to report if @mask is set
  * @message:	value for %PTRACE_GETEVENTMSG to return
  *
@@ -147,7 +148,7 @@ static inline int task_ptrace(struct tas
  */
 static inline int ptrace_event(int mask, int event, unsigned long message)
 {
-	if (mask && likely(!(current->ptrace & mask)))
+	if (mask && likely(!(task_ptrace(current) & mask)))
 		return 0;
 	current->ptrace_message = message;
 	ptrace_notify((event << 8) | SIGTRAP);
--- PTRACE/kernel/ptrace.c~2_PTRACE	2009-05-24 21:36:37.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-28 06:26:19.000000000 +0200
@@ -79,7 +79,7 @@ static void ptrace_untrace(struct task_s
  */
 void __ptrace_unlink(struct task_struct *child)
 {
-	BUG_ON(!child->ptrace);
+	BUG_ON(!task_ptrace(child));
 
 	child->ptrace = 0;
 	child->parent = child->real_parent;
@@ -105,7 +105,7 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
+	if (task_ptrace(child) && child->parent == current) {
 		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
@@ -203,7 +203,7 @@ int ptrace_attach(struct task_struct *ta
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
 		goto unlock_tasklist;
-	if (task->ptrace)
+	if (task_ptrace(task))
 		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
@@ -234,7 +234,7 @@ int ptrace_traceme(void)
 
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
-	if (!current->ptrace) {
+	if (!task_ptrace(current)) {
 		ret = security_ptrace_traceme(current->parent);
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
@@ -315,7 +315,7 @@ int ptrace_detach(struct task_struct *ch
 	 * This child can be already killed. Make sure de_thread() or
 	 * our sub-thread doing do_wait() didn't do release_task() yet.
 	 */
-	if (child->ptrace) {
+	if (task_ptrace(child)) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 	}
@@ -402,29 +402,31 @@ int ptrace_writedata(struct task_struct 
 
 static int ptrace_setoptions(struct task_struct *child, long data)
 {
-	child->ptrace &= ~PT_TRACE_MASK;
+	unsigned int new_flags = 0;
 
 	if (data & PTRACE_O_TRACESYSGOOD)
-		child->ptrace |= PT_TRACESYSGOOD;
+		new_flags |= PT_TRACESYSGOOD;
 
 	if (data & PTRACE_O_TRACEFORK)
-		child->ptrace |= PT_TRACE_FORK;
+		new_flags |= PT_TRACE_FORK;
 
 	if (data & PTRACE_O_TRACEVFORK)
-		child->ptrace |= PT_TRACE_VFORK;
+		new_flags |= PT_TRACE_VFORK;
 
 	if (data & PTRACE_O_TRACECLONE)
-		child->ptrace |= PT_TRACE_CLONE;
+		new_flags |= PT_TRACE_CLONE;
 
 	if (data & PTRACE_O_TRACEEXEC)
-		child->ptrace |= PT_TRACE_EXEC;
+		new_flags |= PT_TRACE_EXEC;
 
 	if (data & PTRACE_O_TRACEVFORKDONE)
-		child->ptrace |= PT_TRACE_VFORK_DONE;
+		new_flags |= PT_TRACE_VFORK_DONE;
 
 	if (data & PTRACE_O_TRACEEXIT)
-		child->ptrace |= PT_TRACE_EXIT;
+		new_flags |= PT_TRACE_EXIT;
 
+	child->ptrace &= ~PT_TRACE_MASK;
+	child->ptrace |= new_flags;
 	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
 }
 

