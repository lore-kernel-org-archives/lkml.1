Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYFDRJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYFDRJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYFDRIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:08:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47560 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbYFDRIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:08:06 -0400
Date: Wed, 4 Jun 2008 21:09:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080604170905.GA10273@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule() has the special "TASK_INTERRUPTIBLE && signal_pending()" case,
this allows us to do

	current->state = TASK_INTERRUPTIBLE;
	schedule();

without fear to sleep with pending signal.

However, the code like

	current->state = TASK_KILLABLE;
	schedule();

is not right, schedule() doesn't take TASK_WAKEKILL into account. This means
that mutex_lock_killable(), wait_for_completion_killable(), down_killable(),
schedule_timeout_killable() can miss SIGKILL (and btw the second SIGKILL has
no effect).

Introduce the new helper, signal_pending_state(), and change schedule() to
use it.

Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
Probably it would be better to remove it, but this will change the current
behaviour and thus needs a separate discussion.

Note also that with or without this patch TASK_WAKEKILL is not exactly right
wrt /sbin/init, but this is another issue.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    2 ++
 kernel/signal.c       |   14 ++++++++++++++
 kernel/sched.c        |    6 ++----
 3 files changed, 18 insertions(+), 4 deletions(-)

--- 26-rc2/include/linux/sched.h~1_SCHED_KILLABLE	2008-06-01 16:44:39.000000000 +0400
+++ 26-rc2/include/linux/sched.h	2008-06-01 16:44:39.000000000 +0400
@@ -2020,6 +2020,8 @@ static inline int signal_pending(struct 
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+extern int signal_pending_state(long state, struct task_struct *p);
+
 extern int __fatal_signal_pending(struct task_struct *p);
 
 static inline int fatal_signal_pending(struct task_struct *p)
--- 26-rc2/kernel/signal.c~1_SCHED_KILLABLE	2008-05-31 16:03:39.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-06-04 19:57:34.000000000 +0400
@@ -980,6 +980,20 @@ int __fatal_signal_pending(struct task_s
 }
 EXPORT_SYMBOL(__fatal_signal_pending);
 
+int signal_pending_state(long state, struct task_struct *p)
+{
+	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
+		return 0;
+	if (!signal_pending(p))
+		return 0;
+
+	if (state & TASK_INTERRUPTIBLE)
+		return 1;
+	if (state & (__TASK_STOPPED | __TASK_TRACED))
+		return 0;
+	return __fatal_signal_pending(p);
+}
+
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
 {
 	struct sighand_struct *sighand;
--- 26-rc2/kernel/sched.c~1_SCHED_KILLABLE	2008-05-18 15:44:18.000000000 +0400
+++ 26-rc2/kernel/sched.c	2008-06-04 17:42:59.000000000 +0400
@@ -4510,12 +4510,10 @@ need_resched_nonpreemptible:
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				signal_pending(prev))) {
+		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		} else {
+		else
 			deactivate_task(rq, prev, 1);
-		}
 		switch_count = &prev->nvcsw;
 	}
 

