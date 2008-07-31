Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYGaJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYGaJEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYGaJEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:04:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYGaJEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:04:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: fix exit_signal=0 case
X-fcc: ~/Mail/linus
X-windows: it could happen to you.
Message-Id: <20080731090409.8D32A154263@magilla.localdomain>
Date: Thu, 31 Jul 2008 02:04:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664 introduced a regression
(sorry about that) for the odd case of exit_signal=0 (e.g. clone_flags=0).
This is not a normal use, but it's used by a case in the glibc test suite.

Dying with exit_signal=0 sends no signal, but it's supposed to wake up a
parent's blocked wait*() calls (unlike the delayed_group_leader case).
This fixes tracehook_notify_death() and its caller to distinguish a
"signal 0" wakeup from the delayed_group_leader case (with no wakeup).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   21 +++++++++++++--------
 kernel/exit.c             |    6 +++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index b187558..1253283 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -493,16 +493,21 @@ static inline int tracehook_notify_jctl(int notify, int why)
  * @death_cookie:	value to pass to tracehook_report_death()
  * @group_dead:		nonzero if this was the last thread in the group to die
  *
- * Return the signal number to send our parent with do_notify_parent(), or
- * zero to send no signal and leave a zombie, or -1 to self-reap right now.
+ * A return value >= 0 means call do_notify_parent() with that signal
+ * number.  Negative return value can be %DEATH_REAP to self-reap right
+ * now, or %DEATH_DELAYED_GROUP_LEADER to a zombie without notifying our
+ * parent.  Note that a return value of 0 means a do_notify_parent() call
+ * that sends no signal, but still wakes up a parent blocked in wait*().
  *
  * Called with write_lock_irq(&tasklist_lock) held.
  */
+#define DEATH_REAP			-1
+#define DEATH_DELAYED_GROUP_LEADER	-2
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
 	if (task->exit_signal == -1)
-		return task->ptrace ? SIGCHLD : -1;
+		return task->ptrace ? SIGCHLD : DEATH_REAP;
 
 	/*
 	 * If something other than our normal parent is ptracing us, then
@@ -512,21 +517,21 @@ static inline int tracehook_notify_death(struct task_struct *task,
 	if (thread_group_empty(task) && !ptrace_reparented(task))
 		return task->exit_signal;
 
-	return task->ptrace ? SIGCHLD : 0;
+	return task->ptrace ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
 }
 
 /**
  * tracehook_report_death - task is dead and ready to be reaped
  * @task:		@current task now exiting
- * @signal:		signal number sent to parent, or 0 or -1
+ * @signal:		return value from tracheook_notify_death()
  * @death_cookie:	value passed back from tracehook_notify_death()
  * @group_dead:		nonzero if this was the last thread in the group to die
  *
  * Thread has just become a zombie or is about to self-reap.  If positive,
  * @signal is the signal number just sent to the parent (usually %SIGCHLD).
- * If @signal is -1, this thread will self-reap.  If @signal is 0, this is
- * a delayed_group_leader() zombie.  The @death_cookie was passed back by
- * tracehook_notify_death().
+ * If @signal is %DEATH_REAP, this thread will self-reap.  If @signal is
+ * %DEATH_DELAYED_GROUP_LEADER, this is a delayed_group_leader() zombie.
+ * The @death_cookie was passed back by tracehook_notify_death().
  *
  * If normal reaping is not inhibited, @task->exit_state might be changing
  * in parallel.
diff --git a/kernel/exit.c b/kernel/exit.c
index eb4d647..38ec406 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -911,10 +911,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);
-	if (signal > 0)
+	if (signal >= 0)
 		signal = do_notify_parent(tsk, signal);
 
-	tsk->exit_state = signal < 0 ? EXIT_DEAD : EXIT_ZOMBIE;
+	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
 
 	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
@@ -927,7 +927,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	tracehook_report_death(tsk, signal, cookie, group_dead);
 
 	/* If the process is dead, release it - nobody will wait for it */
-	if (signal < 0)
+	if (signal == DEATH_REAP)
 		release_task(tsk);
 }
 
