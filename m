Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYGCA5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYGCA5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 20:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYGCA5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 20:57:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46439 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYGCA5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 20:57:36 -0400
Subject: [PATCH -rt] Fix CONFIG_DEBUG_RT_MUTEX lock underflow warnings
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       dvhltc <dvhltc@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 17:57:32 -0700
Message-Id: <1215046652.6688.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

So if I enable CONFIG_DEBUG_RT_MUTEXES with 2.6.24.7-rt14, I tend to
quickly see a number of BUG warnings when running Java tests:

BUG: jxeinajar/3383: lock count underflow!
Pid: 3383, comm: jxeinajar Not tainted 2.6.24-ibmrt2.5john #3

Call Trace:
 [<ffffffff8107208d>] rt_mutex_deadlock_account_unlock+0x5d/0x70
 [<ffffffff817d6aa5>] rt_read_slowunlock+0x35/0x550
 [<ffffffff8107173d>] rt_mutex_up_read+0x3d/0xc0
 [<ffffffff81072a99>] rt_up_read+0x29/0x30
 [<ffffffff8106e34e>] do_futex+0x32e/0xd40
 [<ffffffff8107173d>] ? rt_mutex_up_read+0x3d/0xc0
 [<ffffffff81072a99>] ? rt_up_read+0x29/0x30
 [<ffffffff8106f370>] compat_sys_futex+0xa0/0x110
 [<ffffffff81010a36>] ? syscall_trace_enter+0x86/0xb0
 [<ffffffff8102ff04>] cstar_do_call+0x1b/0x65

INFO: lockdep is turned off.
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<ffffffff817d8e42>] .... __spin_lock_irqsave+0x22/0x60
.....[<ffffffff817d6a93>] ..   ( <= rt_read_slowunlock+0x23/0x550)



After some debugging and with Steven's help, we realized that with
rwlocks, rt_mutex_deadlock_account_lock can be called multiple times in
parallel (where as in most cases the mutex must be held by the caller to
to call the function). This can cause integer lock_count value being
used to be non-atomically incremented.

The following patch converts lock_count to a atomic_t and resolves the
warnings. 

Let me know if you have any feedback or comments!

thanks
-john


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff -ru linux-2.6.24.7-ibmrt2.5-view/include/linux/sched.h linux-2.6.24.7-ibmrt2.5-view-atomic-lock-count/include/linux/sched.h
--- linux-2.6.24.7-ibmrt2.5-view/include/linux/sched.h	2008-07-01 22:08:20.000000000 -0400
+++ linux-2.6.24.7-ibmrt2.5-view-atomic-lock-count/include/linux/sched.h	2008-07-02 20:47:02.000000000 -0400
@@ -1250,7 +1250,7 @@
 
 #define MAX_LOCK_STACK	MAX_PREEMPT_TRACE
 #ifdef CONFIG_DEBUG_PREEMPT
-	int lock_count;
+	atomic_t lock_count;
 # ifdef CONFIG_PREEMPT_RT
 	struct rt_mutex *owned_lock[MAX_LOCK_STACK];
 # endif
diff -ru linux-2.6.24.7-ibmrt2.5-view/kernel/fork.c linux-2.6.24.7-ibmrt2.5-view-atomic-lock-count/kernel/fork.c
--- linux-2.6.24.7-ibmrt2.5-view/kernel/fork.c	2008-07-01 22:08:20.000000000 -0400
+++ linux-2.6.24.7-ibmrt2.5-view-atomic-lock-count/kernel/fork.c	2008-07-02 20:47:02.000000000 -0400
@@ -1203,7 +1203,7 @@
 	if (retval)
 		goto bad_fork_cleanup_namespaces;
 #ifdef CONFIG_DEBUG_PREEMPT
-	p->lock_count = 0;
+	atomic_set(&p->lock_count, 0);
 #endif
 
 #ifdef CONFIG_PREEMPT_RT
diff -ru linux-2.6.24.7-ibmrt2.5-view/kernel/rtmutex-debug.c linux-2.6.24.7-ibmrt2.5-view-atomic-lock-count/kernel/rtmutex-debug.c
--- linux-2.6.24.7-ibmrt2.5-view/kernel/rtmutex-debug.c	2008-07-01 22:08:20.000000000 -0400
+++ linux-2.6.24.7-ibmrt2.5-view-atomic-lock-count/kernel/rtmutex-debug.c	2008-07-02 20:48:36.000000000 -0400
@@ -176,7 +176,7 @@
 rt_mutex_deadlock_account_lock(struct rt_mutex *lock, struct task_struct *task)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
-	if (task->lock_count >= MAX_LOCK_STACK) {
+	if (atomic_read(&task->lock_count) >= MAX_LOCK_STACK) {
 		if (!debug_locks_off())
 			return;
 		printk("BUG: %s/%d: lock count overflow!\n",
@@ -185,16 +185,16 @@
 		return;
 	}
 #ifdef CONFIG_PREEMPT_RT
-	task->owned_lock[task->lock_count] = lock;
+	task->owned_lock[atomic_read(&task->lock_count)] = lock;
 #endif
-	task->lock_count++;
+	atomic_inc(&task->lock_count);
 #endif
 }
 
 void rt_mutex_deadlock_account_unlock(struct task_struct *task)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
-	if (!task->lock_count) {
+	if (!atomic_read(&task->lock_count)) {
 		if (!debug_locks_off())
 			return;
 		printk("BUG: %s/%d: lock count underflow!\n",
@@ -202,9 +202,9 @@
 		dump_stack();
 		return;
 	}
-	task->lock_count--;
+	atomic_dec(&task->lock_count);
 #ifdef CONFIG_PREEMPT_RT
-	task->owned_lock[task->lock_count] = NULL;
+	task->owned_lock[atomic_read(&task->lock_count)] = NULL;
 #endif
 #endif
 }



