Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXKVQPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXKVQPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXKVQP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:15:27 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57693 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbXKVQPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:15:24 -0500
Date: Thu, 22 Nov 2007 19:15:00 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] wait_task_stopped: simplify and fix races with SIGCONT/SIGKILL/untrace
Message-ID: <20071122161500.GA5976@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_stopped() has multiple races with SIGCONT/SIGKILL. tasklist_lock does
not pin the child in TASK_TRACED/TASK_STOPPED stated, almost all info reported
(including exit_code) may be wrong.

In fact, the code under write_lock_irq(tasklist_lock) is not safe. The child
may be PTRACE_DETACH'ed at this time by another subthread, in that case it is
possible we are no longer its ->parent.

Change wait_task_stopped() to take ->siglock before inspecting the task. This
guarantees that the child can't resume and (for example) clear its ->exit_code,
so we don't need to use xchg(&p->exit_code) and re-check. The only exception
is ptrace_stop() which changes ->state and ->exit_code without ->siglock held
during abort. But this can only happen if both the tracer and the tracee are
dying (coredump is in progress), we don't care.

With this patch wait_task_stopped() doesn't move the child to the end of the
->parent list on success. This optimization could be restored, but in that case
we have to take write_lock(tasklist) and do some nasty checks.

Also change the do_wait() since we don't return EAGAIN any longer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~2_wait_task_stopped	2007-11-21 17:09:41.000000000 +0300
+++ PT/kernel/exit.c	2007-11-22 18:06:01.000000000 +0300
@@ -1352,17 +1352,35 @@ static int wait_task_stopped(struct task
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code;
+	int retval, exit_code, why;
+	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
-	if (!p->exit_code)
-		return 0;
+	exit_code = 0;
+	spin_lock_irq(&p->sighand->siglock);
+
+	if (unlikely(!is_task_stopped_or_traced(p)))
+		goto unlock_sig;
+
 	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
 	    p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
 		 */
+		goto unlock_sig;
+
+	exit_code = p->exit_code;
+	if (!exit_code)
+		goto unlock_sig;
+
+	if (!noreap)
+		p->exit_code = 0;
+
+	uid = p->uid;
+unlock_sig:
+	spin_unlock_irq(&p->sighand->siglock);
+	if (!exit_code)
 		return 0;
 
 	/*
@@ -1372,65 +1390,15 @@ static int wait_task_stopped(struct task
 	 * keep holding onto the tasklist_lock while we call getrusage and
 	 * possibly take page faults for user memory.
 	 */
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	get_task_struct(p);
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(noreap)) {
-		uid_t uid = p->uid;
-		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
-
-		exit_code = p->exit_code;
-		if (unlikely(!exit_code) || unlikely(p->exit_state))
-			goto bail_ref;
+	if (unlikely(noreap))
 		return wait_noreap_copyout(p, pid, uid,
 					   why, exit_code,
 					   infop, ru);
-	}
-
-	write_lock_irq(&tasklist_lock);
-
-	/*
-	 * This uses xchg to be atomic with the thread resuming and setting
-	 * it.  It must also be done with the write lock held to prevent a
-	 * race with the EXIT_ZOMBIE case.
-	 */
-	exit_code = xchg(&p->exit_code, 0);
-	if (unlikely(p->exit_state)) {
-		/*
-		 * The task resumed and then died.  Let the next iteration
-		 * catch it in EXIT_ZOMBIE.  Note that exit_code might
-		 * already be zero here if it resumed and did _exit(0).
-		 * The task itself is dead and won't touch exit_code again;
-		 * other processors in this function are locked out.
-		 */
-		p->exit_code = exit_code;
-		exit_code = 0;
-	}
-	if (unlikely(exit_code == 0)) {
-		/*
-		 * Another thread in this function got to it first, or it
-		 * resumed, or it resumed and then died.
-		 */
-		write_unlock_irq(&tasklist_lock);
-bail_ref:
-		put_task_struct(p);
-		/*
-		 * We are returning to the wait loop without having successfully
-		 * removed the process and having released the lock. We cannot
-		 * continue, since the "p" task pointer is potentially stale.
-		 *
-		 * Return -EAGAIN, and do_wait() will restart the loop from the
-		 * beginning. Do _not_ re-acquire the lock.
-		 */
-		return -EAGAIN;
-	}
-
-	/* move to end of parent's list to avoid starvation */
-	remove_parent(p);
-	add_parent(p);
-
-	write_unlock_irq(&tasklist_lock);
 
 	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
 	if (!retval && stat_addr)
@@ -1440,15 +1408,13 @@ bail_ref:
 	if (!retval && infop)
 		retval = put_user(0, &infop->si_errno);
 	if (!retval && infop)
-		retval = put_user((short)((p->ptrace & PT_PTRACED)
-					  ? CLD_TRAPPED : CLD_STOPPED),
-				  &infop->si_code);
+		retval = put_user(why, &infop->si_code);
 	if (!retval && infop)
 		retval = put_user(exit_code, &infop->si_status);
 	if (!retval && infop)
 		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->uid, &infop->si_uid);
+		retval = put_user(uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 	put_task_struct(p);
@@ -1555,8 +1521,6 @@ repeat:
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval == -EAGAIN)
-					goto repeat;
 				if (retval != 0) /* He released the lock.  */
 					goto end;
 			} else if (p->exit_state == EXIT_ZOMBIE) {

