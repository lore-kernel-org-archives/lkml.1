Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbXHEO6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbXHEO6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXHEO6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:58:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:36678 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbXHEO6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:58:44 -0400
Date: Sun, 5 Aug 2007 19:01:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wait_task_zombie: fix 2/3 races vs forget_original_parent()
Message-ID: <20070805150107.GA2019@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Two threads, T1 and T2. T2 ptraces P, and P is not a child of ptracer's
thread group. P exits and goes to TASK_ZOMBIE.

T1 does wait_task_zombie(P):

	P->exit_state = TASK_DEAD;
	...
	read_unlock(&tasklist_lock);

					T2 does exit(), takes tasklist,
					forget_original_parent() does
					__ptrace_unlink(P) but doesn't
					call do_notify_parent(P) because
					p->exit_state == EXIT_DEAD.

Now, P is not visible to our process: __ptrace_unlink() removed it from
->children. We should send notification to P->parent and release P if and
only if SIGCHLD is ignored.

And we have 3 bugs:

1. P->parent does do_wait() and gets -ECHILD (P is on ->parent->children,
   but its state is TASK_DEAD).

2. // wait_task_zombie() continues

	if (put_user(...)) {
		// TODO: is this safe?
		p->exit_state = EXIT_ZOMBIE;
		return;
	}

   we return without notification/release, task_struct leaked.

   Solution: ignore -EFAULT and proceed. It is an application's bug if
   we can't fill infop/stat_addr (in case of VM_FAULT_OOM we have much
   more problems).

3. // wait_task_zombie() continues

	if (p->real_parent != p->parent) {
		// Not taken, it was untraced'ed
		...
	}

	release_task(p);

   we released the task which we shouldn't.

   Solution: check ->real_parent != ->parent before, under tasklist_lock,
   but use ptrace_unlink() instead of __ptrace_unlink() to check ->ptrace.


This patch hopefully solves 2 and 3, the 1st bug will be fixed later, we need
some cleanups in forget_original_parent/reparent_thread.

However, the first race is very unlikely and not critical, so I hope it makes
sense to fix 1 and 2 for now.

4. Small cleanup: don't "restore" EXIT_ZOMBIE unless we know we are not going
   to realease the child.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~2_RACES	2007-08-05 18:46:00.000000000 +0400
+++ t/kernel/exit.c	2007-08-05 18:54:09.000000000 +0400
@@ -1167,8 +1167,7 @@ static int wait_task_zombie(struct task_
 			    int __user *stat_addr, struct rusage __user *ru)
 {
 	unsigned long state;
-	int retval;
-	int status;
+	int retval, status, traced;
 
 	if (unlikely(noreap)) {
 		pid_t pid = p->pid;
@@ -1210,7 +1209,10 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	if (likely(p->real_parent == p->parent)) {
+	/* traced means p->ptrace, but not vice versa */
+	traced = (p->real_parent != p->parent);
+
+	if (likely(!traced)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 
@@ -1292,35 +1294,30 @@ static int wait_task_zombie(struct task_
 		retval = put_user(p->pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
-	if (retval) {
-		// TODO: is this safe?
-		p->exit_state = EXIT_ZOMBIE;
-		return retval;
-	}
-	retval = p->pid;
-	if (p->real_parent != p->parent) {
+	if (!retval)
+		retval = p->pid;
+
+	if (traced) {
 		write_lock_irq(&tasklist_lock);
-		/* Double-check with lock held.  */
-		if (p->real_parent != p->parent) {
-			__ptrace_unlink(p);
-			// TODO: is this safe?
-			p->exit_state = EXIT_ZOMBIE;
-			/*
-			 * If this is not a detached task, notify the parent.
-			 * If it's still not detached after that, don't release
-			 * it now.
-			 */
+		/* We dropped tasklist, ptracer could die and untrace */
+		ptrace_unlink(p);
+		/*
+		 * If this is not a detached task, notify the parent.
+		 * If it's still not detached after that, don't release
+		 * it now.
+		 */
+		if (p->exit_signal != -1) {
+			do_notify_parent(p, p->exit_signal);
 			if (p->exit_signal != -1) {
-				do_notify_parent(p, p->exit_signal);
-				if (p->exit_signal != -1)
-					p = NULL;
+				p->exit_state = EXIT_ZOMBIE;
+				p = NULL;
 			}
 		}
 		write_unlock_irq(&tasklist_lock);
 	}
 	if (p != NULL)
 		release_task(p);
-	BUG_ON(!retval);
+
 	return retval;
 }
 

