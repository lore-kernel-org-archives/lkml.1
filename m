Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbZE3WoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbZE3WoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbZE3WnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbZE3WnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:13 -0400
Date: Sun, 31 May 2009 00:38:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 07/12 v3] ptrace: change __ptrace_link() to set
	->flags, rename to ptrace_link()
Message-ID: <20090530223837.GA30504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every caller of __ptrace_link() must set ->flags, move this code into
this helper and rename it to ptrace_link().

Note that we do not pass PT_PTRACED, it is always set by ptrace_link().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |   11 +++++------
 kernel/ptrace.c        |   25 +++++++++++--------------
 2 files changed, 16 insertions(+), 20 deletions(-)

--- PTRACE/include/linux/ptrace.h~07_PTRACE_LINK	2009-05-30 23:28:49.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:31:18.000000000 +0200
@@ -91,8 +91,8 @@ extern void ptrace_disable(struct task_s
 extern int ptrace_check_attach(struct task_struct *task, int kill);
 extern int ptrace_request(struct task_struct *child, long request, long addr, long data);
 extern void ptrace_notify(int exit_code);
-extern void __ptrace_link(struct task_struct *child,
-			  struct task_struct *new_parent);
+extern void ptrace_link(struct task_struct *child, unsigned int flags,
+			struct task_struct *tracer);
 extern void __ptrace_unlink(struct task_struct *child);
 extern void exit_ptrace(struct task_struct *tracer);
 extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
@@ -168,10 +168,9 @@ static inline void ptrace_init_task(stru
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
 	child->parent = child->real_parent;
-	if (unlikely(child->ptrace_ctx) && task_ptrace(current)) {
-		child->ptrace_ctx->flags = task_ptrace(current);
-		__ptrace_link(child, current->parent);
-	}
+
+	if (unlikely(child->ptrace_ctx) && task_ptrace(current))
+		ptrace_link(child, task_ptrace(current), current->parent);
 }
 
 /**
--- PTRACE/kernel/ptrace.c~07_PTRACE_LINK	2009-05-30 23:28:49.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-30 23:31:18.000000000 +0200
@@ -40,11 +40,14 @@ void ptrace_fork(struct task_struct *chi
  *
  * Must be called with the tasklist lock write-held.
  */
-void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
+void ptrace_link(struct task_struct *child, unsigned int flags,
+			struct task_struct *tracer)
 {
+	child->ptrace_ctx->flags = flags | PT_PTRACED;
+
 	BUG_ON(!list_empty(&child->ptrace_entry));
-	list_add(&child->ptrace_entry, &new_parent->ptraced);
-	child->parent = new_parent;
+	list_add(&child->ptrace_entry, &tracer->ptraced);
+	child->parent = tracer;
 }
 
 /*
@@ -203,7 +206,7 @@ int alloc_ptrace_context(struct task_str
 
 int ptrace_attach(struct task_struct *task)
 {
-	int retval;
+	int retval, flags;
 
 	audit_ptrace(task);
 
@@ -237,11 +240,8 @@ int ptrace_attach(struct task_struct *ta
 	if (task_ptrace(task))
 		goto unlock_tasklist;
 
-	task->ptrace_ctx->flags = PT_PTRACED;
-	if (capable(CAP_SYS_PTRACE))
-		task->ptrace_ctx->flags |= PT_PTRACE_CAP;
-
-	__ptrace_link(task, current);
+	flags = capable(CAP_SYS_PTRACE) ? PT_PTRACE_CAP : 0;
+	ptrace_link(task, flags, current);
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
 	retval = 0;
@@ -256,7 +256,6 @@ out:
 /**
  * ptrace_traceme  --  helper for PTRACE_TRACEME
  *
- * Performs checks and sets PT_PTRACED.
  * Should be used by all ptrace implementations for PTRACE_TRACEME.
  */
 int ptrace_traceme(void)
@@ -276,10 +275,8 @@ int ptrace_traceme(void)
 		 * exit_ptrace(). Otherwise we don't report the error but
 		 * pretend ->real_parent untraces us right after return.
 		 */
-		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
-			current->ptrace_ctx->flags = PT_PTRACED;
-			__ptrace_link(current, current->real_parent);
-		}
+		if (!ret && !(current->real_parent->flags & PF_EXITING))
+			ptrace_link(current, 0, current->real_parent);
 	}
 	write_unlock_irq(&tasklist_lock);
 

