Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZCBFzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZCBFzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 00:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZCBFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 00:55:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZCBFzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 00:55:23 -0500
Message-ID: <49AB74C2.5030102@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 13:55:14 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: remove O(1) scheduler document
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

based on tip/sched/cleanups

impact: kernel doc remove

Since we don't have O(1) scheduler implementation anymore,
remove the legacy doc.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
 Documentation/scheduler/00-INDEX         |    2 -
 Documentation/scheduler/sched-coding.txt |  126 ------------------------------
 2 files changed, 0 insertions(+), 128 deletions(-)
 delete mode 100644 Documentation/scheduler/sched-coding.txt

diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
index aabcc3a..3c00c9c 100644
--- a/Documentation/scheduler/00-INDEX
+++ b/Documentation/scheduler/00-INDEX
@@ -2,8 +2,6 @@
 	- this file.
 sched-arch.txt
 	- CPU Scheduler implementation hints for architecture specific code.
-sched-coding.txt
-	- reference for various scheduler-related methods in the O(1) scheduler.
 sched-design-CFS.txt
 	- goals, design and implementation of the Complete Fair Scheduler.
 sched-domains.txt
diff --git a/Documentation/scheduler/sched-coding.txt b/Documentation/scheduler/sched-coding.txt
deleted file mode 100644
index cbd8db7..0000000
--- a/Documentation/scheduler/sched-coding.txt
+++ /dev/null
@@ -1,126 +0,0 @@
-     Reference for various scheduler-related methods in the O(1) scheduler
-		Robert Love <rml@tech9.net>, MontaVista Software
-
-
-Note most of these methods are local to kernel/sched.c - this is by design.
-The scheduler is meant to be self-contained and abstracted away.  This document
-is primarily for understanding the scheduler, not interfacing to it.  Some of
-the discussed interfaces, however, are general process/scheduling methods.
-They are typically defined in include/linux/sched.h.
-
-
-Main Scheduling Methods
------------------------
-
-void load_balance(runqueue_t *this_rq, int idle)
-	Attempts to pull tasks from one cpu to another to balance cpu usage,
-	if needed.  This method is called explicitly if the runqueues are
-	imbalanced or periodically by the timer tick.  Prior to calling,
-	the current runqueue must be locked and interrupts disabled.
-
-void schedule()
-	The main scheduling function.  Upon return, the highest priority
-	process will be active.
-
-
-Locking
--------
-
-Each runqueue has its own lock, rq->lock.  When multiple runqueues need
-to be locked, lock acquires must be ordered by ascending &runqueue value.
-
-A specific runqueue is locked via
-
-	task_rq_lock(task_t pid, unsigned long *flags)
-
-which disables preemption, disables interrupts, and locks the runqueue pid is
-running on.  Likewise,
-
-	task_rq_unlock(task_t pid, unsigned long *flags)
-
-unlocks the runqueue pid is running on, restores interrupts to their previous
-state, and reenables preemption.
-
-The routines
-
-	double_rq_lock(runqueue_t *rq1, runqueue_t *rq2)
-
-and
-
-	double_rq_unlock(runqueue_t *rq1, runqueue_t *rq2)
-
-safely lock and unlock, respectively, the two specified runqueues.  They do
-not, however, disable and restore interrupts.  Users are required to do so
-manually before and after calls.
-
-
-Values
-------
-
-MAX_PRIO
-	The maximum priority of the system, stored in the task as task->prio.
-	Lower priorities are higher.  Normal (non-RT) priorities range from
-	MAX_RT_PRIO to (MAX_PRIO - 1).
-MAX_RT_PRIO
-	The maximum real-time priority of the system.  Valid RT priorities
-	range from 0 to (MAX_RT_PRIO - 1).
-MAX_USER_RT_PRIO
-	The maximum real-time priority that is exported to user-space.  Should
-	always be equal to or less than MAX_RT_PRIO.  Setting it less allows
-	kernel threads to have higher priorities than any user-space task.
-MIN_TIMESLICE
-MAX_TIMESLICE
-	Respectively, the minimum and maximum timeslices (quanta) of a process.
-
-Data
-----
-
-struct runqueue
-	The main per-CPU runqueue data structure.
-struct task_struct
-	The main per-process data structure.
-
-
-General Methods
----------------
-
-cpu_rq(cpu)
-	Returns the runqueue of the specified cpu.
-this_rq()
-	Returns the runqueue of the current cpu.
-task_rq(pid)
-	Returns the runqueue which holds the specified pid.
-cpu_curr(cpu)
-	Returns the task currently running on the given cpu.
-rt_task(pid)
-	Returns true if pid is real-time, false if not.
-
-
-Process Control Methods
------------------------
-
-void set_user_nice(task_t *p, long nice)
-	Sets the "nice" value of task p to the given value.
-int setscheduler(pid_t pid, int policy, struct sched_param *param)
-	Sets the scheduling policy and parameters for the given pid.
-int set_cpus_allowed(task_t *p, unsigned long new_mask)
-	Sets a given task's CPU affinity and migrates it to a proper cpu.
-	Callers must have a valid reference to the task and assure the
-	task not exit prematurely.  No locks can be held during the call.
-set_task_state(tsk, state_value)
-	Sets the given task's state to the given value.
-set_current_state(state_value)
-	Sets the current task's state to the given value.
-void set_tsk_need_resched(struct task_struct *tsk)
-	Sets need_resched in the given task.
-void clear_tsk_need_resched(struct task_struct *tsk)
-	Clears need_resched in the given task.
-void set_need_resched()
-	Sets need_resched in the current task.
-void clear_need_resched()
-	Clears need_resched in the current task.
-int need_resched()
-	Returns true if need_resched is set in the current task, false
-	otherwise.
-yield()
-	Place the current process at the end of the runqueue and call schedule.
-- 
1.5.3.4



