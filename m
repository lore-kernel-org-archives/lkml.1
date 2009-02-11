Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZBKKvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZBKKvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZBKKvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:51:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:40089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbZBKKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:51:43 -0500
Subject: [PATCH] timers: fix TIMER_ABSTIME for process wide cpu timers
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
In-Reply-To: <1234280251.23438.73.camel@twins>
References: <1233910614.23431.18.camel@marge.simson.net>
	 <20090206140134.GC3415@elte.hu>  <1234280251.23438.73.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Feb 2009 11:53:21 +0100
Message-Id: <1234349601.23438.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While going through the man-pages Michael prepared for the posix timer
interface I realized that posix timers do expose the absolute time value
through the use of TIMER_ABSTIME.

---
Subject: timers: fix TIMER_ABSTIME for process wide cpu timers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Feb 11 11:30:27 CET 2009

The POSIX timer interface allows for absolute time expiry values through the
TIMER_ABSTIME flag, therefore we have to synchronize the timer to the clock
every time we start it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h     |   13 +------------
 kernel/posix-cpu-timers.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2229,18 +2229,7 @@ static inline int spin_needbreak(spinloc
  * Thread group CPU time accounting.
  */
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
-
-static inline
-void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
-{
-	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cputimer->lock, flags);
-	cputimer->running = 1;
-	*times = cputimer->cputime;
-	spin_unlock_irqrestore(&cputimer->lock, flags);
-}
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -261,6 +261,40 @@ out:
 	rcu_read_unlock();
 }
 
+static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
+{
+	if (cputime_gt(b->utime, a->utime))
+		a->utime = b->utime;
+
+	if (cputime_gt(b->stime, a->stime))
+		a->stime = b->stime;
+
+	if (b->sum_exec_runtime > a->sum_exelt rec_runtime)
+		a->sum_exec_runtime = b->sum_exec_runtime;
+}
+
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+{
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct task_cputime sum;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cputimer->lock, flags);
+	if (!cputimer->running) {
+		cputimer->running = 1;
+		/*
+		 * The POSIX timer interface allows for absolute time expiry
+		 * values through the TIMER_ABSTIME flag, therefore we have
+		 * to synchronize the timer to the clock every time we start
+		 * it.
+		 */
+		thread_group_cputime(tsk, &sum);
+		update_gt_cputime(&cputimer->cputime, &sum);
+	}
+	*times = cputimer->cputime;
+	spin_unlock_irqrestore(&cputimer->lock, flags);
+}
+
 /*
  * Sample a process (thread group) clock for the given group_leader task.
  * Must be called with tasklist_lock held for reading.

