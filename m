Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYGQHeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYGQHeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbYGQHax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759711AbYGQHav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 16/23] tracehook: death
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: more than just a Lisp interpreter, a text editor as well!
Message-Id: <20080717073046.8A8EB15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the ptrace logic in task death (exit_notify) into
tracehook.h inlines.  Some code is rearranged slightly to make
things nicer.  There is no change, only cleanup.

There is one hook called with the tasklist_lock write-locked, as ptrace
needs.  There is also a new hook called after exit_state changes and
without locks.  This is a better place for tracing work to be in the
future, since it doesn't delay the whole system with locking.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h     |    2 +-
 include/linux/tracehook.h |   52 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/exit.c             |   26 +++++++--------------
 kernel/signal.c           |   10 ++++++--
 4 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1941d8b..c58e8ab 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1785,7 +1785,7 @@ extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
-extern void do_notify_parent(struct task_struct *, int);
+extern int do_notify_parent(struct task_struct *, int);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6dc428d..4c50e1b 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -471,4 +471,56 @@ static inline int tracehook_notify_jctl(int notify, int why)
 	return notify || (current->ptrace & PT_PTRACED);
 }
 
+/**
+ * tracehook_notify_death - task is dead, ready to notify parent
+ * @task:		@current task now exiting
+ * @death_cookie:	value to pass to tracehook_report_death()
+ * @group_dead:		nonzero if this was the last thread in the group to die
+ *
+ * Return the signal number to send our parent with do_notify_parent(), or
+ * zero to send no signal and leave a zombie, or -1 to self-reap right now.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static inline int tracehook_notify_death(struct task_struct *task,
+					 void **death_cookie, int group_dead)
+{
+	if (task->exit_signal == -1)
+		return task->ptrace ? SIGCHLD : -1;
+
+	/*
+	 * If something other than our normal parent is ptracing us, then
+	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
+	 * only has special meaning to our real parent.
+	 */
+	if (thread_group_empty(task) && !ptrace_reparented(task))
+		return task->exit_signal;
+
+	return task->ptrace ? SIGCHLD : 0;
+}
+
+/**
+ * tracehook_report_death - task is dead and ready to be reaped
+ * @task:		@current task now exiting
+ * @signal:		signal number sent to parent, or 0 or -1
+ * @death_cookie:	value passed back from tracehook_notify_death()
+ * @group_dead:		nonzero if this was the last thread in the group to die
+ *
+ * Thread has just become a zombie or is about to self-reap.  If positive,
+ * @signal is the signal number just sent to the parent (usually %SIGCHLD).
+ * If @signal is -1, this thread will self-reap.  If @signal is 0, this is
+ * a delayed_group_leader() zombie.  The @death_cookie was passed back by
+ * tracehook_notify_death().
+ *
+ * If normal reaping is not inhibited, @task->exit_state might be changing
+ * in parallel.
+ *
+ * Called without locks.
+ */
+static inline void tracehook_report_death(struct task_struct *task,
+					  int signal, void *death_cookie,
+					  int group_dead)
+{
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/exit.c b/kernel/exit.c
index a416a84..78c6307 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -861,7 +861,8 @@ static void forget_original_parent(struct task_struct *father)
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	int state;
+	int signal;
+	void *cookie;
 
 	/*
 	 * This does two things:
@@ -898,22 +899,11 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	    !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 
-	/* If something other than our normal parent is ptracing us, then
-	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
-	 * only has special meaning to our real parent.
-	 */
-	if (!task_detached(tsk) && thread_group_empty(tsk)) {
-		int signal = ptrace_reparented(tsk) ?
-				SIGCHLD : tsk->exit_signal;
-		do_notify_parent(tsk, signal);
-	} else if (tsk->ptrace) {
-		do_notify_parent(tsk, SIGCHLD);
-	}
+	signal = tracehook_notify_death(tsk, &cookie, group_dead);
+	if (signal > 0)
+		signal = do_notify_parent(tsk, signal);
 
-	state = EXIT_ZOMBIE;
-	if (task_detached(tsk) && likely(!tsk->ptrace))
-		state = EXIT_DEAD;
-	tsk->exit_state = state;
+	tsk->exit_state = signal < 0 ? EXIT_DEAD : EXIT_ZOMBIE;
 
 	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
@@ -923,8 +913,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 
 	write_unlock_irq(&tasklist_lock);
 
+	tracehook_report_death(tsk, signal, cookie, group_dead);
+
 	/* If the process is dead, release it - nobody will wait for it */
-	if (state == EXIT_DEAD)
+	if (signal < 0)
 		release_task(tsk);
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 9b8d94a..cbec18e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1346,9 +1346,11 @@ static inline void __wake_up_parent(struct task_struct *p,
 /*
  * Let a parent know about the death of a child.
  * For a stopped/continued status change, use do_notify_parent_cldstop instead.
+ *
+ * Returns -1 if our parent ignored us and so we've switched to
+ * self-reaping, or else @sig.
  */
-
-void do_notify_parent(struct task_struct *tsk, int sig)
+int do_notify_parent(struct task_struct *tsk, int sig)
 {
 	struct siginfo info;
 	unsigned long flags;
@@ -1420,12 +1422,14 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 		 */
 		tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
-			sig = 0;
+			sig = -1;
 	}
 	if (valid_signal(sig) && sig > 0)
 		__group_send_sig_info(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
+
+	return sig;
 }
 
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
