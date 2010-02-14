Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0BNTqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:46:04 -0500
Received: from www.tglx.de ([62.245.132.106]:33842 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0BNTp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:45:59 -0500
Date: Sun, 14 Feb 2010 20:45:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: sched: Fix wake up race with rt_mutex_setprio()
Message-ID: <alpine.LFD.2.00.1002142036260.2811@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rt_mutex_setprio() can race with try_to_wake_up():

CPU 0                           CPU 1
try_to_wake_up(p)
  task_rq_lock(p)	
  p->state = TASK_WAKING;
  task_rq_unlock()              rt_mutex_setprio(p)
                                task_rq_lock(p)	<- succeeds (old CPU)
  newcpu = select_task_rq(p)	
  set_task_cpu(p)

  task_rq_lock(p) <- succeeds (new CPU)

  activate_task(p)              change sched_class(p)

That way we end up with the task enqueued in the wrong sched class.

Solve this by waiting for p->state != TASK_WAKING in rt_mutex_setprio().

Debugged and tested in the preempt-rt tree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6058,7 +6058,25 @@ void rt_mutex_setprio(struct task_struct
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
+again:
 	rq = task_rq_lock(p, &flags);
+
+	/*
+	 * Prevent a nasty race with ttwu(). ttwu() sets the task
+	 * state to WAKING and drops the runqueue lock. So we can
+	 * acquire the runqueue lock while ttwu() migrates the
+	 * task. We need to wait until ttwu() set the target cpu and
+	 * enqueued the task on whatever CPU it decided to select.
+	 * Otherwise ttwu() might enqueue with the old class on
+	 * another cpu while we are changing the class on the previous
+	 * cpu.
+	 */
+	if (unlikely(p->state == TASK_WAKING)) {
+		task_rq_unlock(rq, &flags);
+		cpu_relax();
+		goto again;
+	}
+
 	update_rq_clock(rq);
 
 	oldprio = p->prio;
