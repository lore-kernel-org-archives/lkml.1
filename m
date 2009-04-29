Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZD2Mdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZD2Mdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZD2MdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:33:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43517 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZD2MdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:33:22 -0400
Date: Wed, 29 Apr 2009 14:28:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: do not use task->ptrace directly in core kernel
Message-ID: <20090429122827.GA27838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

- Nobody except ptrace.c & co should use ptrace flags directly, we have
  task_ptrace() for that.

- No need to specially check PT_PTRACED, we must not have other PT_ bits
  set without PT_PTRACED. And no need to know this flag exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c   |    6 +++---
 kernel/signal.c |   10 +++++-----
 kernel/fork.c   |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

--- PTRACE/kernel/exit.c~CORE_FLAGS	2009-04-23 23:11:33.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-04-29 12:46:15.000000000 +0200
@@ -757,7 +757,7 @@ static void reparent_thread(struct task_
 	p->exit_signal = SIGCHLD;
 
 	/* If it has exited notify the new parent about this child's death. */
-	if (!p->ptrace &&
+	if (!task_ptrace(p) &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		do_notify_parent(p, p->exit_signal);
 		if (task_detached(p)) {
@@ -782,7 +782,7 @@ static void forget_original_parent(struc
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
 		if (p->parent == father) {
-			BUG_ON(p->ptrace);
+			BUG_ON(task_ptrace(p));
 			p->parent = p->real_parent;
 		}
 		reparent_thread(father, p, &dead_children);
@@ -1478,7 +1478,7 @@ static int wait_consider_task(struct tas
 			*notask_error = ret;
 	}
 
-	if (likely(!ptrace) && unlikely(p->ptrace)) {
+	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
 		/*
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
--- PTRACE/kernel/signal.c~CORE_FLAGS	2009-04-06 00:03:42.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-04-29 13:21:47.000000000 +0200
@@ -1402,7 +1402,7 @@ int do_notify_parent(struct task_struct 
  	/* do_notify_parent_cldstop should have been called instead.  */
  	BUG_ON(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!tsk->ptrace &&
+	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	info.si_signo = sig;
@@ -1441,7 +1441,7 @@ int do_notify_parent(struct task_struct 
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
-	if (!tsk->ptrace && sig == SIGCHLD &&
+	if (!task_ptrace(tsk) && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
 	     (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT))) {
 		/*
@@ -1478,7 +1478,7 @@ static void do_notify_parent_cldstop(str
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
-	if (tsk->ptrace & PT_PTRACED)
+	if (task_ptrace(tsk))
 		parent = tsk->parent;
 	else {
 		tsk = tsk->group_leader;
@@ -1527,7 +1527,7 @@ static void do_notify_parent_cldstop(str
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(current->ptrace & PT_PTRACED))
+	if (!likely(task_ptrace(current)))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1745,7 +1745,7 @@ static int do_signal_stop(int signr)
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
-	if (!(current->ptrace & PT_PTRACED))
+	if (!task_ptrace(current))
 		return signr;
 
 	ptrace_signal_deliver(regs, cookie);
--- PTRACE/kernel/fork.c~CORE_FLAGS	2009-04-27 21:38:57.000000000 +0200
+++ PTRACE/kernel/fork.c	2009-04-29 13:25:29.000000000 +0200
@@ -1088,7 +1088,7 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(current->ptrace))
+	if (unlikely(task_ptrace(current)))
 		ptrace_fork(p, clone_flags);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */

