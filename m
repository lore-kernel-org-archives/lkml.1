Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbXHRRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbXHRRiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbXHRRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:37:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39348 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbXHRRh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:37:28 -0400
Date: Sat, 18 Aug 2007 21:40:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
Message-ID: <20070818174001.GA218@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

de_thread() yields waiting for ->group_leader to be a zombie. This deadlocks
if an rt-prio execer shares the same cpu with ->group_leader. Change the code
to use ->group_exit_task/notify_count mechanics.

This patch certainly uglifies the code, perhaps someone can suggest something
better.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~5_DEADLOCK	2007-08-17 18:56:31.000000000 +0400
+++ t/kernel/exit.c	2007-08-18 20:57:49.000000000 +0400
@@ -102,10 +102,9 @@ static void __exit_signal(struct task_st
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
-		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count) {
+		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
 			wake_up_process(sig->group_exit_task);
-			sig->group_exit_task = NULL;
-		}
+
 		if (tsk == sig->curr_target)
 			sig->curr_target = next_thread(tsk);
 		/*
@@ -850,6 +849,11 @@ static void exit_notify(struct task_stru
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
+	if (thread_group_leader(tsk) &&
+	    tsk->signal->notify_count < 0 &&
+	    tsk->signal->group_exit_task)
+		wake_up_process(tsk->signal->group_exit_task);
+
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_safe(_p, _n, &ptrace_dead) {
--- t/fs/exec.c~5_DEADLOCK	2007-08-18 19:34:12.000000000 +0400
+++ t/fs/exec.c	2007-08-18 20:43:59.000000000 +0400
@@ -828,16 +828,15 @@ static int de_thread(struct task_struct 
 			hrtimer_restart(&sig->real_timer);
 		spin_lock_irq(lock);
 	}
+
+	sig->notify_count = count;
+	sig->group_exit_task = tsk;
 	while (atomic_read(&sig->count) > count) {
-		sig->group_exit_task = tsk;
-		sig->notify_count = count;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(lock);
 		schedule();
 		spin_lock_irq(lock);
 	}
-	sig->group_exit_task = NULL;
-	sig->notify_count = 0;
 	spin_unlock_irq(lock);
 
 	/*
@@ -846,14 +845,17 @@ static int de_thread(struct task_struct 
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		/*
-		 * Wait for the thread group leader to be a zombie.
-		 * It should already be zombie at this point, most
-		 * of the time.
-		 */
 		leader = tsk->group_leader;
-		while (leader->exit_state != EXIT_ZOMBIE)
-			yield();
+
+		sig->notify_count = -1;
+		for (;;) {
+			write_lock_irq(&tasklist_lock);
+			if (likely(leader->exit_state))
+				break;
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			write_unlock_irq(&tasklist_lock);
+			schedule();
+		}
 
 		/*
 		 * The only record we have of the real-time age of a
@@ -867,8 +869,6 @@ static int de_thread(struct task_struct 
 		 */
 		tsk->start_time = leader->start_time;
 
-		write_lock_irq(&tasklist_lock);
-
 		BUG_ON(leader->tgid != tsk->tgid);
 		BUG_ON(tsk->pid == tsk->tgid);
 		/*
@@ -901,6 +901,8 @@ static int de_thread(struct task_struct 
 		write_unlock_irq(&tasklist_lock);
         }
 
+	sig->group_exit_task = NULL;
+	sig->notify_count = 0;
 	/*
 	 * There may be one thread left which is just exiting,
 	 * but it's safe to stop telling the group to kill themselves.

