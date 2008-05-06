Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbYEFAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbYEFAdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbYEFAdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:33:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbYEFAdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:33:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/4] do_wait reorganization
X-Shopping-List: (1) Puritanical invasions
   (2) Heretical contraceptives
   (3) Public rail Johnny Carson lookalikes
Message-Id: <20080506003239.43FF026FA20@magilla.localdomain>
Date: Mon,  5 May 2008 17:32:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks out the guts of do_wait into three subfunctions.
The control flow is less nonobvious without so much goto.
do_wait_thread and ptrace_do_wait contain the main work of the outer loop.
wait_consider_task contains the main work of the inner loop.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/exit.c |  212 +++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 132 insertions(+), 80 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1510f78..934371a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1232,7 +1232,7 @@ static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_zombie(struct task_struct *p, int noreap,
+static int wait_task_zombie(struct task_struct *p, int options,
 			    struct siginfo __user *infop,
 			    int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1240,7 +1240,10 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
 
-	if (unlikely(noreap)) {
+	if (!likely(options & WEXITED))
+		return 0;
+
+	if (unlikely(options & WNOWAIT)) {
 		uid_t uid = p->uid;
 		int exit_code = p->exit_code;
 		int why, status;
@@ -1391,13 +1394,16 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
  * released the lock and the system call should return.
  */
 static int wait_task_stopped(struct task_struct *p,
-			     int noreap, struct siginfo __user *infop,
+			     int options, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
 	int retval, exit_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
+	if (!(p->ptrace & PT_PTRACED) && !(options & WUNTRACED))
+		return 0;
+
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
@@ -1415,7 +1421,7 @@ static int wait_task_stopped(struct task_struct *p,
 	if (!exit_code)
 		goto unlock_sig;
 
-	if (!noreap)
+	if (!unlikely(options & WNOWAIT))
 		p->exit_code = 0;
 
 	uid = p->uid;
@@ -1436,7 +1442,7 @@ unlock_sig:
 	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(noreap))
+	if (unlikely(options & WNOWAIT))
 		return wait_noreap_copyout(p, pid, uid,
 					   why, exit_code,
 					   infop, ru);
@@ -1470,7 +1476,7 @@ unlock_sig:
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_continued(struct task_struct *p, int noreap,
+static int wait_task_continued(struct task_struct *p, int options,
 			       struct siginfo __user *infop,
 			       int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1478,6 +1484,9 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 	pid_t pid;
 	uid_t uid;
 
+	if (!unlikely(options & WCONTINUED))
+		return 0;
+
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
 
@@ -1487,7 +1496,7 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 		spin_unlock_irq(&p->sighand->siglock);
 		return 0;
 	}
-	if (!noreap)
+	if (!unlikely(options & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
@@ -1513,89 +1522,134 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 	return retval;
 }
 
+/*
+ * Consider @p for a wait by @parent.
+ *
+ * -ECHILD should be in *@retval before the first call.
+ * Returns nonzero for a final return, when we have unlocked tasklist_lock.
+ * Returns zero if the search for a child should continue; then *@retval is
+ * 0 if @p is an eligible child, or still -ECHILD.
+ */
+static int wait_consider_task(struct task_struct *parent,
+			      struct task_struct *p, int *retval,
+			      enum pid_type type, struct pid *pid, int options,
+			      struct siginfo __user *infop,
+			      int __user *stat_addr, struct rusage __user *ru)
+{
+	int ret = eligible_child(type, pid, options, p);
+	if (ret <= 0)
+		return ret;
+
+	if (p->exit_state == EXIT_DEAD)
+		return 0;
+
+	/*
+	 * We don't reap group leaders with subthreads.
+	 */
+	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
+		return wait_task_zombie(p, options, infop, stat_addr, ru);
+
+	/*
+	 * It's stopped or running now, so it might
+	 * later continue, exit, or stop again.
+	 */
+	*retval = 0;
+
+	if (task_is_stopped_or_traced(p))
+		return wait_task_stopped(p, options, infop, stat_addr, ru);
+
+	return wait_task_continued(p, options, infop, stat_addr, ru);
+}
+
+/*
+ * Do the work of do_wait() for one thread in the group, @tsk.
+ *
+ * -ECHILD should be in *@retval before the first call.
+ * Returns nonzero for a final return, when we have unlocked tasklist_lock.
+ * Returns zero if the search for a child should continue; then *@retval is
+ * 0 if there were any eligible children, or still -ECHILD.
+ */
+static int do_wait_thread(struct task_struct *tsk, int *retval,
+			  enum pid_type type, struct pid *pid, int options,
+			  struct siginfo __user *infop, int __user *stat_addr,
+			  struct rusage __user *ru)
+{
+	struct task_struct *p;
+
+	list_for_each_entry(p, &tsk->children, sibling) {
+		int ret = wait_consider_task(tsk, p, retval, type, pid, options,
+					     infop, stat_addr, ru);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ptrace_do_wait(struct task_struct *tsk, int *retval,
+			  enum pid_type type, struct pid *pid, int options,
+			  struct siginfo __user *infop, int __user *stat_addr,
+			  struct rusage __user *ru)
+{
+	struct task_struct *p;
+
+	/*
+	 * If we never saw an eligile child, check for children stolen by
+	 * ptrace.  We don't leave -ECHILD in *@retval if there are any,
+	 * because we will eventually be allowed to wait for them again.
+	 */
+	if (!*retval)
+		return 0;
+
+	list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
+		int ret = eligible_child(type, pid, options, p);
+		if (unlikely(ret < 0))
+			return ret;
+		if (ret) {
+			*retval = 0;
+			return 0;
+		}
+	}
+
+	return 0;
+}
+
 static long do_wait(enum pid_type type, struct pid *pid, int options,
 		    struct siginfo __user *infop, int __user *stat_addr,
 		    struct rusage __user *ru)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
-	int flag, retval;
+	int retval;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
-	/* If there is nothing that can match our critier just get out */
+	/*
+	 * If there is nothing that can match our critiera just get out.
+	 * We will clear @retval to zero if we see any child that might later
+	 * match our criteria, even if we are not able to reap it yet.
+	 */
 	retval = -ECHILD;
 	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
 		goto end;
 
-	/*
-	 * We will set this flag if we see any child that might later
-	 * match our criteria, even if we are not able to reap it yet.
-	 */
-	flag = retval = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		struct task_struct *p;
-
-		list_for_each_entry(p, &tsk->children, sibling) {
-			int ret = eligible_child(type, pid, options, p);
-			if (!ret)
-				continue;
-
-			if (unlikely(ret < 0)) {
-				retval = ret;
-			} else if (task_is_stopped_or_traced(p)) {
-				/*
-				 * It's stopped now, so it might later
-				 * continue, exit, or stop again.
-				 */
-				flag = 1;
-				if (!(p->ptrace & PT_PTRACED) &&
-				    !(options & WUNTRACED))
-					continue;
-
-				retval = wait_task_stopped(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			} else if (p->exit_state == EXIT_ZOMBIE &&
-					!delay_group_leader(p)) {
-				/*
-				 * We don't reap group leaders with subthreads.
-				 */
-				if (!likely(options & WEXITED))
-					continue;
-				retval = wait_task_zombie(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			} else if (p->exit_state != EXIT_DEAD) {
-				/*
-				 * It's running now, so it might later
-				 * exit, stop, or stop and then continue.
-				 */
-				flag = 1;
-				if (!unlikely(options & WCONTINUED))
-					continue;
-				retval = wait_task_continued(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			}
-			if (retval != 0) /* tasklist_lock released */
-				goto end;
-		}
-		if (!flag) {
-			list_for_each_entry(p, &tsk->ptrace_children,
-								ptrace_list) {
-				flag = eligible_child(type, pid, options, p);
-				if (!flag)
-					continue;
-				if (likely(flag > 0))
-					break;
-				retval = flag;
-				goto end;
-			}
+		int ret = do_wait_thread(tsk, &retval, type, pid, options,
+					 infop, stat_addr, ru);
+		if (!ret)
+			ret = ptrace_do_wait(tsk, &retval, type, pid, options,
+					     infop, stat_addr, ru);
+		if (ret) {
+			/*
+			 * tasklist_lock is unlocked and we have a final result.
+			 */
+			retval = ret;
+			goto end;
 		}
+
 		if (options & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
@@ -1603,16 +1657,14 @@ repeat:
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
-	if (flag) {
-		if (options & WNOHANG)
-			goto end;
+	if (!retval && !(options & WNOHANG)) {
 		retval = -ERESTARTSYS;
-		if (signal_pending(current))
-			goto end;
-		schedule();
-		goto repeat;
+		if (!signal_pending(current)) {
+			schedule();
+			goto repeat;
+		}
 	}
-	retval = -ECHILD;
+
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
