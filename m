Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbXKRQsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbXKRQsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 11:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXKRQsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 11:48:24 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48123 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXKRQsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 11:48:23 -0500
Date: Sun, 18 Nov 2007 19:48:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] use __set_task_state() for TRACED/STOPPED tasks
Message-ID: <20071118164834.GA3383@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. It is much easier to grep for ->state change if __set_task_state() is used
   instead of the direct assignment.

2. ptrace_stop() and handle_group_stop() use set_task_state() which adds the
   unneeded mb() (btw even if we use mb() it is still possible that do_wait()
   sees the new ->state but not ->exit_code, but this is ok).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 24/kernel/fork.c~state	2007-11-09 12:57:31.000000000 +0300
+++ 24/kernel/fork.c	2007-11-18 19:27:38.000000000 +0300
@@ -1462,7 +1462,7 @@ long do_fork(unsigned long clone_flags,
 		if (!(clone_flags & CLONE_STOPPED))
 			wake_up_new_task(p, clone_flags);
 		else
-			p->state = TASK_STOPPED;
+			__set_task_state(p, TASK_STOPPED);
 
 		if (unlikely (trace)) {
 			current->ptrace_message = nr;
--- 24/kernel/ptrace.c~state	2007-10-25 16:22:12.000000000 +0400
+++ 24/kernel/ptrace.c	2007-11-18 19:30:20.000000000 +0300
@@ -53,7 +53,7 @@ void ptrace_untrace(struct task_struct *
 	spin_lock(&child->sighand->siglock);
 	if (child->state == TASK_TRACED) {
 		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
-			child->state = TASK_STOPPED;
+			__set_task_state(child, TASK_STOPPED);
 		} else {
 			signal_wake_up(child, 1);
 		}
@@ -104,7 +104,7 @@ int ptrace_check_attach(struct task_stru
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_STOPPED) {
-			child->state = TASK_TRACED;
+			__set_task_state(child, TASK_TRACED);
 		} else if (child->state != TASK_TRACED && !kill) {
 			ret = -ESRCH;
 		}
--- 24/kernel/signal.c~state	2007-11-09 12:57:31.000000000 +0300
+++ 24/kernel/signal.c	2007-11-18 19:33:19.000000000 +0300
@@ -1617,7 +1617,7 @@ static void ptrace_stop(int exit_code, i
 	current->exit_code = exit_code;
 
 	/* Let the debugger run.  */
-	set_current_state(TASK_TRACED);
+	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	try_to_freeze();
 	read_lock(&tasklist_lock);
@@ -1781,7 +1781,7 @@ static int handle_group_stop(void)
 	if (stop_count == 0)
 		current->signal->flags = SIGNAL_STOP_STOPPED;
 	current->exit_code = current->signal->group_exit_code;
-	set_current_state(TASK_STOPPED);
+	__set_current_state(TASK_STOPPED);
 	spin_unlock_irq(&current->sighand->siglock);
 	finish_stop(stop_count);
 	return 1;

