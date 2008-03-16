Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYCPPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYCPPuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 11:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYCPPua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 11:50:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35762 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYCPPu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 11:50:29 -0400
Date: Sun, 16 Mar 2008 18:54:52 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] signals: de_thread: simplify the ->child_reaper switching
Message-ID: <20080316155452.GA20839@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we rely on SIGNAL_UNKILLABLE flag, de_thread() doesn't need the nasty
hack to kill the old ->child_reaper during the mt-exec.

This also means we can avoid taking tasklist_lock around zap_other_threads().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/fs/exec.c~2_EXEC_KILL_HACK	2008-03-03 17:01:36.000000000 +0300
+++ 25/fs/exec.c	2008-03-16 15:20:25.000000000 +0300
@@ -757,9 +757,7 @@ static int de_thread(struct task_struct 
 
 	/*
 	 * Kill all other threads in the thread group.
-	 * We must hold tasklist_lock to call zap_other_threads.
 	 */
-	read_lock(&tasklist_lock);
 	spin_lock_irq(lock);
 	if (signal_group_exit(sig)) {
 		/*
@@ -767,21 +765,10 @@ static int de_thread(struct task_struct 
 		 * return so that the signal is processed.
 		 */
 		spin_unlock_irq(lock);
-		read_unlock(&tasklist_lock);
 		return -EAGAIN;
 	}
-
-	/*
-	 * child_reaper ignores SIGKILL, change it now.
-	 * Reparenting needs write_lock on tasklist_lock,
-	 * so it is safe to do it under read_lock.
-	 */
-	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
-		task_active_pid_ns(tsk)->child_reaper = tsk;
-
 	sig->group_exit_task = tsk;
 	zap_other_threads(tsk);
-	read_unlock(&tasklist_lock);
 
 	/* Account for the thread group leader hanging around: */
 	count = thread_group_leader(tsk) ? 1 : 2;
@@ -812,6 +799,8 @@ static int de_thread(struct task_struct 
 			schedule();
 		}
 
+		if (unlikely(task_child_reaper(tsk) == leader))
+			task_active_pid_ns(tsk)->child_reaper = tsk;
 		/*
 		 * The only record we have of the real-time age of a
 		 * process, regardless of execs it's done, is start_time.

