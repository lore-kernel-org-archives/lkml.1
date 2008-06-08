Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYFHRUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYFHRUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 13:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbYFHRTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 13:19:55 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41472 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbYFHRT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 13:19:27 -0400
Date: Sun, 8 Jun 2008 21:20:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sched: fix TASK_WAKEKILL vs SIGKILL race
Message-ID: <20080608172041.GA10383@tv-sign.ru>
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
use it. Hopefully it will have more users, that is why the task's state is
passed separately.

Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
This is needed to preserve the current behaviour (ptrace_notify). I hope
this check will be removed soon, but this (afaics good) change needs the
separate discussion.

The fast path is "(state & (INTERRUPTIBLE | WAKEKILL)) + signal_pending(p)",
basically the same that schedule() does now. However, this patch of course
bloats schedule().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |   13 +++++++++++++
 kernel/sched.c        |    6 ++----
 2 files changed, 15 insertions(+), 4 deletions(-)

--- 26-rc2/include/linux/sched.h~1_SP_STATE	2008-06-01 16:44:39.000000000 +0400
+++ 26-rc2/include/linux/sched.h	2008-06-01 16:44:39.000000000 +0400
@@ -2027,6 +2027,19 @@ static inline int fatal_signal_pending(s
 	return signal_pending(p) && __fatal_signal_pending(p);
 }
 
+static inline int signal_pending_state(long state, struct task_struct *p)
+{
+	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
+		return 0;
+	if (!signal_pending(p))
+		return 0;
+
+	if (state & (__TASK_STOPPED | __TASK_TRACED))
+		return 0;
+
+	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
+}
+
 static inline int need_resched(void)
 {
 	return unlikely(test_tsk_need_resched(current));
--- 26-rc2/kernel/sched.c~1_SP_STATE	2008-06-08 16:15:25.000000000 +0400
+++ 26-rc2/kernel/sched.c	2008-06-08 16:52:23.000000000 +0400
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
 

