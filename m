Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbZE3Wog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbZE3Wog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZE3WnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759282AbZE3WnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:16 -0400
Date: Sun, 31 May 2009 00:38:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/12 v3] ptrace: kill the now unneeded args from
	tracehook_finish_clone() path
Message-ID: <20090530223832.GA30498@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous change tracehook_finish_clone() and ptrace_init_task()
do not need any arguments except "child", remove them.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h    |    7 +++----
 include/linux/tracehook.h |   10 +++-------
 kernel/fork.c             |    2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

--- PTRACE/include/linux/ptrace.h~05_FORK_TRACE	2009-05-30 22:48:10.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:14:03.000000000 +0200
@@ -162,20 +162,19 @@ static inline int ptrace_event(int mask,
 /**
  * ptrace_init_task - initialize ptrace state for a new child
  * @child:		new child task
- * @ptrace:		true if child should be ptrace'd by parent's tracer
  *
  * This is called immediately after adding @child to its parent's children
- * list.  @ptrace is false in the normal case, and true to ptrace @child.
+ * list. @child->ptrace_ctx != NULL was allocated by tracehook_init_task().
  *
  * Called with current's siglock and write_lock_irq(&tasklist_lock) held.
  */
-static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
+static inline void ptrace_init_task(struct task_struct *child)
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
 	child->parent = child->real_parent;
 	child->ptrace = 0;
-	if (unlikely(ptrace)) {
+	if (unlikely(child->ptrace_ctx)) {
 		child->ptrace = current->ptrace;
 		ptrace_link(child, current->parent);
 	}
--- PTRACE/include/linux/tracehook.h~05_FORK_TRACE	2009-05-30 22:48:10.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-05-30 23:05:12.000000000 +0200
@@ -219,7 +219,7 @@ static inline void tracehook_report_exit
  * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
  *
  * This is called before a new user task is to be cloned.
- * Its return value will be passed to tracehook_finish_clone().
+ * Its return value will be passed to tracehook_init_task().
  *
  * Called with no locks held.
  */
@@ -279,18 +279,14 @@ static inline void tracehook_free_task(s
 /**
  * tracehook_finish_clone - new child created and being attached
  * @child:		new child task
- * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
- * @trace:		return value from tracehook_prepare_clone()
  *
  * This is called immediately after adding @child to its parent's children list.
- * The @trace value is that returned by tracehook_prepare_clone().
  *
  * Called with current's siglock and write_lock_irq(&tasklist_lock) held.
  */
-static inline void tracehook_finish_clone(struct task_struct *child,
-					  unsigned long clone_flags, int trace)
+static inline void tracehook_finish_clone(struct task_struct *child)
 {
-	ptrace_init_task(child, (clone_flags & CLONE_PTRACE) || trace);
+	ptrace_init_task(child);
 }
 
 /**
--- PTRACE/kernel/fork.c~05_FORK_TRACE	2009-05-30 22:48:10.000000000 +0200
+++ PTRACE/kernel/fork.c	2009-05-30 23:05:12.000000000 +0200
@@ -1247,7 +1247,7 @@ static struct task_struct *copy_process(
 
 	if (likely(p->pid)) {
 		list_add_tail(&p->sibling, &p->real_parent->children);
-		tracehook_finish_clone(p, clone_flags, trace);
+		tracehook_finish_clone(p);
 
 		if (thread_group_leader(p)) {
 			if (clone_flags & CLONE_NEWPID)

