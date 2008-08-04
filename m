Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYHDP6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYHDP6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYHDP5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:57:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40740 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYHDP5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:57:22 -0400
Date: Mon, 4 Aug 2008 20:01:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] posix-timers: sys_timer_create: remove the buggy PF_EXITING check
Message-ID: <20080804160104.GA10518@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_timer_create() return -EINVAL if the target thread has PF_EXITING.

This doesn't really make sense, the sub-thread can die right after unlock.
And in fact, this is just wrong. Without SIGEV_THREAD_ID good_sigevent()
returns ->group_leader, and it is very possible that the leader is already
dead. This is OK, we shouldn't return the error in this case.

Remove this check and the comment. Note that the "process" was found under
tasklist_lock, it must have ->sighand != NULL.

Also, remove a couple of unneeded initializations.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~4_DONT_CHECK_EXIT	2008-08-03 21:13:25.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-04 16:50:29.000000000 +0400
@@ -460,9 +460,9 @@ sys_timer_create(const clockid_t which_c
 		 timer_t __user * created_timer_id)
 {
 	int error = 0;
-	struct k_itimer *new_timer = NULL;
+	struct k_itimer *new_timer;
 	int new_timer_id;
-	struct task_struct *process = NULL;
+	struct task_struct *process;
 	unsigned long flags;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
@@ -523,32 +523,12 @@ sys_timer_create(const clockid_t which_c
 
 		read_lock(&tasklist_lock);
 		if ((process = good_sigevent(&event))) {
-			/*
-			 * We may be setting up this process for another
-			 * thread.  It may be exiting.  To catch this
-			 * case the we check the PF_EXITING flag.  If
-			 * the flag is not set, the siglock will catch
-			 * him before it is too late (in exit_itimers).
-			 *
-			 * The exec case is a bit more invloved but easy
-			 * to code.  If the process is in our thread
-			 * group (and it must be or we would not allow
-			 * it here) and is doing an exec, it will cause
-			 * us to be killed.  In this case it will wait
-			 * for us to die which means we can finish this
-			 * linkage with our last gasp. I.e. no code :)
-			 */
+			get_task_struct(process);
 			spin_lock_irqsave(&process->sighand->siglock, flags);
-			if (!(process->flags & PF_EXITING)) {
-				get_task_struct(process);
-				new_timer->it_process = process;
-				list_add(&new_timer->list,
-					 &process->signal->posix_timers);
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
-			} else {
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
-				process = NULL;
-			}
+			new_timer->it_process = process;
+			list_add(&new_timer->list,
+				&process->signal->posix_timers);
+			spin_unlock_irqrestore(&process->sighand->siglock, flags);
 		}
 		read_unlock(&tasklist_lock);
 		if (!process) {

