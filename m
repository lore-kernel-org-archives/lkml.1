Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZEFFh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZEFFh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZEFFhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:37:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44504 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbZEFFhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:37:15 -0400
Date: Wed, 6 May 2009 07:33:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to simplify
	do_wait() pathes
Message-ID: <20090506053324.GA31988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce "struct wait_opts" which holds the parameters for misc helpers
in do_wait() pathes.

This adds 17 lines to kernel/exit.c, but saves 256 bytes from .o and imho
makes the code much more readable.

(untested, not signed)

 kernel/exit.c |  211 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 114 insertions(+), 97 deletions(-)

--- PTRACE/kernel/exit.c~2_WOPTS	2009-05-06 01:48:51.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-06 07:00:45.000000000 +0200
@@ -1076,6 +1076,18 @@ SYSCALL_DEFINE1(exit_group, int, error_c
 	return 0;
 }
 
+struct wait_opts {
+	enum pid_type		wtype;
+	struct pid		*wpid;
+	int			wflags;
+
+	struct siginfo __user	*winfo;
+	int __user		*wstat;
+	struct rusage __user	*wrusage;
+
+	int			notask_error;
+};
+
 static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid = NULL;
@@ -1086,13 +1098,12 @@ static struct pid *task_pid_type(struct 
 	return pid;
 }
 
-static int eligible_child(enum pid_type type, struct pid *pid, int options,
-			  struct task_struct *p)
+static int eligible_child(struct wait_opts *wopts, struct task_struct *p)
 {
 	int err;
 
-	if (type < PIDTYPE_MAX) {
-		if (task_pid_type(p, type) != pid)
+	if (wopts->wtype < PIDTYPE_MAX) {
+		if (task_pid_type(p, wopts->wtype) != wopts->wpid)
 			return 0;
 	}
 
@@ -1101,8 +1112,8 @@ static int eligible_child(enum pid_type 
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
 	 * A "clone" child here is one that reports to its parent
 	 * using a signal other than SIGCHLD.) */
-	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
-	    && !(options & __WALL))
+	if (((p->exit_signal != SIGCHLD) ^ !!(wopts->wflags & __WCLONE))
+	    && !(wopts->wflags & __WALL))
 		return 0;
 
 	err = security_task_wait(p);
@@ -1112,14 +1123,15 @@ static int eligible_child(enum pid_type 
 	return 1;
 }
 
-static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
-			       int why, int status,
-			       struct siginfo __user *infop,
-			       struct rusage __user *rusagep)
+static int wait_noreap_copyout(struct wait_opts *wopts, struct task_struct *p,
+				pid_t pid, uid_t uid, int why, int status)
 {
-	int retval = rusagep ? getrusage(p, RUSAGE_BOTH, rusagep) : 0;
+	struct siginfo __user *infop;
+	int retval = wopts->wrusage
+		? getrusage(p, RUSAGE_BOTH, wopts->wrusage) : 0;
 
 	put_task_struct(p);
+	infop = wopts->winfo;
 	if (!retval)
 		retval = put_user(SIGCHLD, &infop->si_signo);
 	if (!retval)
@@ -1143,19 +1155,18 @@ static int wait_noreap_copyout(struct ta
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_zombie(struct task_struct *p, int options,
-			    struct siginfo __user *infop,
-			    int __user *stat_addr, struct rusage __user *ru)
+static int wait_task_zombie(struct wait_opts *wopts, struct task_struct *p)
 {
 	unsigned long state;
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
+	struct siginfo __user *infop;
 
-	if (!likely(options & WEXITED))
+	if (!likely(wopts->wflags & WEXITED))
 		return 0;
 
-	if (unlikely(options & WNOWAIT)) {
+	if (unlikely(wopts->wflags & WNOWAIT)) {
 		int exit_code = p->exit_code;
 		int why, status;
 
@@ -1168,8 +1179,7 @@ static int wait_task_zombie(struct task_
 			why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
 			status = exit_code & 0x7f;
 		}
-		return wait_noreap_copyout(p, pid, uid, why,
-					   status, infop, ru);
+		return wait_noreap_copyout(wopts, p, pid, uid, why, status);
 	}
 
 	/*
@@ -1250,11 +1260,14 @@ static int wait_task_zombie(struct task_
 	 */
 	read_unlock(&tasklist_lock);
 
-	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
+	retval = wopts->wrusage
+		? getrusage(p, RUSAGE_BOTH, wopts->wrusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (!retval && stat_addr)
-		retval = put_user(status, stat_addr);
+	if (!retval && wopts->wstat)
+		retval = put_user(status, wopts->wstat);
+
+	infop = wopts->winfo;
 	if (!retval && infop)
 		retval = put_user(SIGCHLD, &infop->si_signo);
 	if (!retval && infop)
@@ -1322,16 +1335,16 @@ static int *task_stopped_code(struct tas
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_stopped(int ptrace, struct task_struct *p,
-			     int options, struct siginfo __user *infop,
-			     int __user *stat_addr, struct rusage __user *ru)
+static int wait_task_stopped(struct wait_opts *wopts,
+				int ptrace, struct task_struct *p)
 {
+	struct siginfo __user *infop;
 	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
 	/* Traditionally we see ptrace'd stopped tasks regardless of options */
-	if (!ptrace && !(options & WUNTRACED))
+	if (!ptrace && !(wopts->wflags & WUNTRACED))
 		return 0;
 
 	exit_code = 0;
@@ -1345,7 +1358,7 @@ static int wait_task_stopped(int ptrace,
 	if (!exit_code)
 		goto unlock_sig;
 
-	if (!unlikely(options & WNOWAIT))
+	if (!unlikely(wopts->wflags & WNOWAIT))
 		*p_code = 0;
 
 	/* don't need the RCU readlock here as we're holding a spinlock */
@@ -1367,14 +1380,15 @@ unlock_sig:
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(options & WNOWAIT))
-		return wait_noreap_copyout(p, pid, uid,
-					   why, exit_code,
-					   infop, ru);
+	if (unlikely(wopts->wflags & WNOWAIT))
+		return wait_noreap_copyout(wopts, p, pid, uid, why, exit_code);
 
-	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
-	if (!retval && stat_addr)
-		retval = put_user((exit_code << 8) | 0x7f, stat_addr);
+	retval = wopts->wrusage
+		? getrusage(p, RUSAGE_BOTH, wopts->wrusage) : 0;
+	if (!retval && wopts->wstat)
+		retval = put_user((exit_code << 8) | 0x7f, wopts->wstat);
+
+	infop = wopts->winfo;
 	if (!retval && infop)
 		retval = put_user(SIGCHLD, &infop->si_signo);
 	if (!retval && infop)
@@ -1401,15 +1415,13 @@ unlock_sig:
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_continued(struct task_struct *p, int options,
-			       struct siginfo __user *infop,
-			       int __user *stat_addr, struct rusage __user *ru)
+static int wait_task_continued(struct wait_opts *wopts, struct task_struct *p)
 {
 	int retval;
 	pid_t pid;
 	uid_t uid;
 
-	if (!unlikely(options & WCONTINUED))
+	if (!unlikely(wopts->wflags & WCONTINUED))
 		return 0;
 
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
@@ -1421,7 +1433,7 @@ static int wait_task_continued(struct ta
 		spin_unlock_irq(&p->sighand->siglock);
 		return 0;
 	}
-	if (!unlikely(options & WNOWAIT))
+	if (!unlikely(wopts->wflags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	uid = __task_cred(p)->uid;
 	spin_unlock_irq(&p->sighand->siglock);
@@ -1430,17 +1442,17 @@ static int wait_task_continued(struct ta
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	if (!infop) {
-		retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
+	if (!wopts->winfo) {
+		retval = wopts->wrusage
+			? getrusage(p, RUSAGE_BOTH, wopts->wrusage) : 0;
 		put_task_struct(p);
-		if (!retval && stat_addr)
-			retval = put_user(0xffff, stat_addr);
+		if (!retval && wopts->wstat)
+			retval = put_user(0xffff, wopts->wstat);
 		if (!retval)
 			retval = pid;
 	} else {
-		retval = wait_noreap_copyout(p, pid, uid,
-					     CLD_CONTINUED, SIGCONT,
-					     infop, ru);
+		retval = wait_noreap_copyout(wopts, p, pid, uid,
+					     CLD_CONTINUED, SIGCONT);
 		BUG_ON(retval == 0);
 	}
 
@@ -1450,19 +1462,16 @@ static int wait_task_continued(struct ta
 /*
  * Consider @p for a wait by @parent.
  *
- * -ECHILD should be in *@notask_error before the first call.
+ * -ECHILD should be in ->notask_error before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue;
- * then *@notask_error is 0 if @p is an eligible child,
+ * then ->notask_error is 0 if @p is an eligible child,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int wait_consider_task(struct task_struct *parent, int ptrace,
-			      struct task_struct *p, int *notask_error,
-			      enum pid_type type, struct pid *pid, int options,
-			      struct siginfo __user *infop,
-			      int __user *stat_addr, struct rusage __user *ru)
+static int wait_consider_task(struct wait_opts *wopts, struct task_struct *parent,
+				int ptrace, struct task_struct *p)
 {
-	int ret = eligible_child(type, pid, options, p);
+	int ret = eligible_child(wopts, p);
 	if (!ret)
 		return ret;
 
@@ -1474,8 +1483,8 @@ static int wait_consider_task(struct tas
 		 * to look for security policy problems, rather
 		 * than for mysterious wait bugs.
 		 */
-		if (*notask_error)
-			*notask_error = ret;
+		if (wopts->notask_error)
+			wopts->notask_error = ret;
 		return 0;
 	}
 
@@ -1484,7 +1493,7 @@ static int wait_consider_task(struct tas
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
 		 */
-		*notask_error = 0;
+		wopts->notask_error = 0;
 		return 0;
 	}
 
@@ -1495,34 +1504,30 @@ static int wait_consider_task(struct tas
 	 * We don't reap group leaders with subthreads.
 	 */
 	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
-		return wait_task_zombie(p, options, infop, stat_addr, ru);
+		return wait_task_zombie(wopts, p);
 
 	/*
 	 * It's stopped or running now, so it might
 	 * later continue, exit, or stop again.
 	 */
-	*notask_error = 0;
+	wopts->notask_error = 0;
 
 	if (task_stopped_code(p, ptrace))
-		return wait_task_stopped(ptrace, p, options,
-					 infop, stat_addr, ru);
+		return wait_task_stopped(wopts, ptrace, p);
 
-	return wait_task_continued(p, options, infop, stat_addr, ru);
+	return wait_task_continued(wopts, p);
 }
 
 /*
  * Do the work of do_wait() for one thread in the group, @tsk.
  *
- * -ECHILD should be in *@notask_error before the first call.
+ * -ECHILD should be in ->notask_error before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then
- * *@notask_error is 0 if there were any eligible children,
+ * ->notask_error is 0 if there were any eligible children,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int do_wait_thread(struct task_struct *tsk, int *notask_error,
-			  enum pid_type type, struct pid *pid, int options,
-			  struct siginfo __user *infop, int __user *stat_addr,
-			  struct rusage __user *ru)
+static int do_wait_thread(struct wait_opts *wopts, struct task_struct *tsk)
 {
 	struct task_struct *p;
 
@@ -1531,9 +1536,7 @@ static int do_wait_thread(struct task_st
 		 * Do not consider detached threads.
 		 */
 		if (!task_detached(p)) {
-			int ret = wait_consider_task(tsk, 0, p, notask_error,
-						     type, pid, options,
-						     infop, stat_addr, ru);
+			int ret = wait_consider_task(wopts, tsk, 0, p);
 			if (ret)
 				return ret;
 		}
@@ -1542,17 +1545,12 @@ static int do_wait_thread(struct task_st
 	return 0;
 }
 
-static int ptrace_do_wait(struct task_struct *tsk, int *notask_error,
-			  enum pid_type type, struct pid *pid, int options,
-			  struct siginfo __user *infop, int __user *stat_addr,
-			  struct rusage __user *ru)
+static int ptrace_do_wait(struct wait_opts *wopts, struct task_struct *tsk)
 {
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(tsk, 1, p, notask_error,
-					     type, pid, options,
-					     infop, stat_addr, ru);
+		int ret = wait_consider_task(wopts, tsk, 1, p);
 		if (ret)
 			return ret;
 	}
@@ -1560,38 +1558,36 @@ static int ptrace_do_wait(struct task_st
 	return 0;
 }
 
-static long do_wait(enum pid_type type, struct pid *pid, int options,
-		    struct siginfo __user *infop, int __user *stat_addr,
-		    struct rusage __user *ru)
+static long do_wait(struct wait_opts *wopts)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int retval;
 
-	trace_sched_process_wait(pid);
+	trace_sched_process_wait(wopts->wpid);
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
 	/*
 	 * If there is nothing that can match our critiera just get out.
-	 * We will clear @retval to zero if we see any child that might later
-	 * match our criteria, even if we are not able to reap it yet.
+	 * We will clear ->notask_error to zero if we see any child that
+	 * might later match our criteria, even if we are not able to reap
+	 * it yet.
 	 */
-	retval = -ECHILD;
-	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
+	retval = wopts->notask_error = -ECHILD;
+	if ((wopts->wtype < PIDTYPE_MAX) &&
+	   (!wopts->wpid || hlist_empty(&wopts->wpid->tasks[wopts->wtype])))
 		goto end;
 
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		int tsk_result = do_wait_thread(tsk, &retval,
-						type, pid, options,
-						infop, stat_addr, ru);
+		int tsk_result = do_wait_thread(wopts, tsk);
+
 		if (!tsk_result)
-			tsk_result = ptrace_do_wait(tsk, &retval,
-						    type, pid, options,
-						    infop, stat_addr, ru);
+			tsk_result = ptrace_do_wait(wopts, tsk);
+
 		if (tsk_result) {
 			/*
 			 * tasklist_lock is unlocked and we have a final result.
@@ -1600,25 +1596,27 @@ repeat:
 			goto end;
 		}
 
-		if (options & __WNOTHREAD)
+		if (wopts->wflags & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
 		BUG_ON(tsk->signal != current->signal);
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
-	if (!retval && !(options & WNOHANG)) {
+	retval = wopts->notask_error;
+	if (!retval && !(wopts->wflags & WNOHANG)) {
 		retval = -ERESTARTSYS;
 		if (!signal_pending(current)) {
 			schedule();
 			goto repeat;
 		}
 	}
-
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
-	if (infop) {
+	if (wopts->winfo) {
+		struct siginfo __user *infop = wopts->winfo;
+
 		if (retval > 0)
 			retval = 0;
 		else {
@@ -1647,6 +1645,7 @@ end:
 SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 		infop, int, options, struct rusage __user *, ru)
 {
+	struct wait_opts wopts;
 	struct pid *pid = NULL;
 	enum pid_type type;
 	long ret;
@@ -1676,7 +1675,16 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 
 	if (type < PIDTYPE_MAX)
 		pid = find_get_pid(upid);
-	ret = do_wait(type, pid, options, infop, NULL, ru);
+
+	wopts.wtype = type;
+	wopts.wpid = pid;
+	wopts.wflags = options;
+
+	wopts.winfo = infop;
+	wopts.wstat = NULL;
+	wopts.wrusage = ru;
+
+	ret = do_wait(&wopts);
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
@@ -1687,6 +1695,7 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
 		int, options, struct rusage __user *, ru)
 {
+	struct wait_opts wopts;
 	struct pid *pid = NULL;
 	enum pid_type type;
 	long ret;
@@ -1708,7 +1717,15 @@ SYSCALL_DEFINE4(wait4, pid_t, upid, int 
 		pid = find_get_pid(upid);
 	}
 
-	ret = do_wait(type, pid, options | WEXITED, NULL, stat_addr, ru);
+	wopts.wtype = type;
+	wopts.wpid = pid;
+	wopts.wflags = options | WEXITED;
+
+	wopts.winfo = NULL;
+	wopts.wstat = stat_addr;
+	wopts.wrusage = ru;
+
+	ret = do_wait(&wopts);
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */

