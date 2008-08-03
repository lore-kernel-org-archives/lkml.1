Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYHCRq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYHCRq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbYHCRpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:45:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33176 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315AbYHCRpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:45:50 -0400
Date: Sun, 3 Aug 2008 21:49:11 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] posix-timers: always do get_task_struct(timer->it_process)
Message-ID: <20080803174911.GA4916@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the code to get/put timer->it_process regardless of SIGEV_THREAD_ID.
This streamlines the create/destroy paths and allows us to simplify the
usage of exit_itimers() in de_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/posix-timers.c~2_GET_LEADER	2008-08-03 20:25:41.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-08-03 21:13:25.000000000 +0400
@@ -540,11 +540,10 @@ sys_timer_create(const clockid_t which_c
 			 */
 			spin_lock_irqsave(&process->sighand->siglock, flags);
 			if (!(process->flags & PF_EXITING)) {
+				get_task_struct(process);
 				new_timer->it_process = process;
 				list_add(&new_timer->list,
 					 &process->signal->posix_timers);
-				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-					get_task_struct(process);
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 			} else {
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
@@ -561,6 +560,7 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_signo = SIGALRM;
 		new_timer->it_sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
+		get_task_struct(process);
 		spin_lock_irqsave(&process->sighand->siglock, flags);
 		new_timer->it_process = process;
 		list_add(&new_timer->list, &process->signal->posix_timers);
@@ -853,8 +853,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);
@@ -881,8 +880,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	if (timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(timer->it_process);
+	put_task_struct(timer->it_process);
 	timer->it_process = NULL;
 
 	unlock_timer(timer, flags);

