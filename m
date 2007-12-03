Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXLCT0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXLCT0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXLCT0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:26:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbXLCT0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:26:00 -0500
Date: Mon, 3 Dec 2007 20:24:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
       penberg@cs.helsinki.fi, lkml@astralstorm.puszkin.org,
       arjan@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203192426.GA8017@elte.hu>
References: <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203141925.GA8327@elte.hu> <20071203095736.7963553e.akpm@linux-foundation.org> <200712031928.53659.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712031928.53659.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > This feature will save one full reporter-developer round-trip during 
> > investigation of a significant number of bug reports.
> > 
> > It might be more practical if it were to dump the traces for _all_ 
> > D-state processes when it fires - basically an auto-triggered 
> > sysrq-W.
> 
> Er, it won't play well if that happen when tasks are frozen for 
> suspend.

right now any suspend attempt times out after 20 seconds:

  $ grep TIMEOUT kernel/power/process.c
  #define TIMEOUT (20 * HZ)
          end_time = jiffies + TIMEOUT;

which should be well before the 120 seconds timeout that the detector 
uses. But indeed you are right in that the refrigerator() works via 
TASK_UNINTERRUPTIBLE too. I've updated the patch to exclude PF_FROZEN - 
attached below. That should solve this particular issue, even if the 
timeout increased to above 20 secs, right?

	Ingo

-------------->
Subject: softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
From: Ingo Molnar <mingo@elte.hu>

this patch extends the soft-lockup detector to automatically
detect hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are
printed the following way:

 ------------------>
 INFO: task prctl:3042 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message
 prctl         D fd5e3793     0  3042   2997
        f6050f38 00000046 00000001 fd5e3793 00000009 c06d8264 c06dae80 00000286
        f6050f40 f6050f00 f7d34d90 f7d34fc8 c1e1be80 00000001 f6050000 00000000
        f7e92d00 00000286 f6050f18 c0489d1a f6050f40 00006605 00000000 c0133a5b
 Call Trace:
  [<c04883a5>] schedule_timeout+0x6d/0x8b
  [<c04883d8>] schedule_timeout_uninterruptible+0x15/0x17
  [<c0133a76>] msleep+0x10/0x16
  [<c0138974>] sys_prctl+0x30/0x1e2
  [<c0104c52>] sysenter_past_esp+0x5f/0xa5
  =======================
 2 locks held by prctl/3042:
 #0:  (&sb->s_type->i_mutex_key#5){--..}, at: [<c0197d11>] do_fsync+0x38/0x7a
 #1:  (jbd_handle){--..}, at: [<c01ca3d2>] journal_start+0xc7/0xe9
 <------------------

the current default timeout is 120 seconds. Such messages are printed
up to 10 times per bootup. If the system has crashed already then the
messages are not printed.

if lockdep is enabled then all held locks are printed as well.

this feature is a natural extension to the softlockup-detector (kernel
locked up without scheduling) and to the NMI watchdog (kernel locked up
with IRQs disabled).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/process_32.c |   15 ++++--
 include/linux/debug_locks.h  |    5 ++
 include/linux/sched.h        |   10 ++++
 kernel/fork.c                |    5 ++
 kernel/lockdep.c             |   14 ++++-
 kernel/sched.c               |    4 -
 kernel/softlockup.c          |  106 ++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c              |   27 ++++++++++
 8 files changed, 169 insertions(+), 17 deletions(-)

Index: linux/arch/x86/kernel/process_32.c
===================================================================
--- linux.orig/arch/x86/kernel/process_32.c
+++ linux/arch/x86/kernel/process_32.c
@@ -114,10 +114,19 @@ void default_idle(void)
 		smp_mb();
 
 		local_irq_disable();
-		if (!need_resched())
+		if (!need_resched()) {
+			ktime_t t0, t1;
+			u64 t0n, t1n;
+
+			t0 = ktime_get();
+			t0n = ktime_to_ns(t0);
 			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
+			local_irq_disable();
+			t1 = ktime_get();
+			t1n = ktime_to_ns(t1);
+			sched_clock_idle_wakeup_event(t1n - t0n);
+		}
+		local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		/* loop is done by the caller */
Index: linux/include/linux/debug_locks.h
===================================================================
--- linux.orig/include/linux/debug_locks.h
+++ linux/include/linux/debug_locks.h
@@ -47,6 +47,7 @@ struct task_struct;
 
 #ifdef CONFIG_LOCKDEP
 extern void debug_show_all_locks(void);
+extern void __debug_show_held_locks(struct task_struct *task);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
 extern void debug_check_no_locks_held(struct task_struct *task);
@@ -55,6 +56,10 @@ static inline void debug_show_all_locks(
 {
 }
 
+static inline void __debug_show_held_locks(struct task_struct *task)
+{
+}
+
 static inline void debug_show_held_locks(struct task_struct *task)
 {
 }
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -261,12 +261,17 @@ extern void account_process_tick(struct 
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
 
+extern void sched_show_task(struct task_struct *p);
+
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern int softlockup_thresh;
+extern unsigned long sysctl_hung_task_check_count;
+extern unsigned long sysctl_hung_task_timeout_secs;
+extern long sysctl_hung_task_warnings;
 #else
 static inline void softlockup_tick(void)
 {
@@ -1052,6 +1057,11 @@ struct task_struct {
 /* ipc stuff */
 	struct sysv_sem sysvsem;
 #endif
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+/* hung task detection */
+	unsigned long last_switch_timestamp;
+	unsigned long last_switch_count;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /* filesystem information */
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -1059,6 +1059,11 @@ static struct task_struct *copy_process(
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
 
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+	p->last_switch_count = 0;
+	p->last_switch_timestamp = 0;
+#endif
+
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
 	p->wchar = 0;		/* I/O counter: bytes written */
Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -3190,14 +3190,24 @@ retry:
 }
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
-void debug_show_held_locks(struct task_struct *task)
+/*
+ * Careful: only use this function if you are sure that
+ * the task cannot run in parallel!
+ */
+void __debug_show_held_locks(struct task_struct *task)
 {
 	if (unlikely(!debug_locks)) {
 		printk("INFO: lockdep is turned off.\n");
 		return;
 	}
+	lockdep_print_held_locks(task);
+}
+EXPORT_SYMBOL_GPL(__debug_show_held_locks);
+
+void debug_show_held_locks(struct task_struct *task)
+{
 	if (task == current)
-		lockdep_print_held_locks(task);
+		__debug_show_held_locks(task);
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4833,7 +4833,7 @@ out_unlock:
 
 static const char stat_nam[] = "RSDTtZX";
 
-static void show_task(struct task_struct *p)
+void sched_show_task(struct task_struct *p)
 {
 	unsigned long free = 0;
 	unsigned state;
@@ -4886,7 +4886,7 @@ void show_state_filter(unsigned long sta
 		 */
 		touch_nmi_watchdog();
 		if (!state_filter || (p->state & state_filter))
-			show_task(p);
+			sched_show_task(p);
 	} while_each_thread(g, p);
 
 	touch_all_softlockup_watchdogs();
Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -8,6 +8,7 @@
  */
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/nmi.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/freezer.h>
@@ -24,7 +25,7 @@ static DEFINE_PER_CPU(unsigned long, pri
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int did_panic;
-int softlockup_thresh = 10;
+int softlockup_thresh = 60;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -45,7 +46,7 @@ static struct notifier_block panic_block
  */
 static unsigned long get_timestamp(int this_cpu)
 {
-	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
+	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
 void touch_softlockup_watchdog(void)
@@ -100,11 +101,7 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
-	/* Wake up the high-prio watchdog task every second: */
-	if (now > (touch_timestamp + 1))
-		wake_up_process(per_cpu(watchdog_task, this_cpu));
-
-	/* Warn about unreasonable 10+ seconds delays: */
+	/* Warn about unreasonable delays: */
 	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
 
@@ -122,11 +119,88 @@ void softlockup_tick(void)
 }
 
 /*
+ * Have a reasonable limit on the number of tasks checked:
+ */
+unsigned long sysctl_hung_task_check_count = 1024;
+
+/*
+ * Zero means infinite timeout - no checking done:
+ */
+unsigned long sysctl_hung_task_timeout_secs = 120;
+
+long sysctl_hung_task_warnings = 10;
+
+static void check_hung_task(struct task_struct *t, unsigned long now)
+{
+	unsigned long switch_count = t->nvcsw + t->nivcsw;
+
+	if (t->flags & PF_FROZEN)
+		return;
+
+	if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
+		t->last_switch_count = switch_count;
+		t->last_switch_timestamp = now;
+		return;
+	}
+	if ((long)(now - t->last_switch_timestamp) <
+					sysctl_hung_task_timeout_secs)
+		return;
+	if (sysctl_hung_task_warnings < 0)
+		return;
+	sysctl_hung_task_warnings--;
+
+	/*
+	 * Ok, the task did not get scheduled for more than 2 minutes,
+	 * complain:
+	 */
+	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
+			"%ld seconds.\n", t->comm, t->pid,
+			sysctl_hung_task_timeout_secs);
+	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+			" disables this message.\n");
+	sched_show_task(t);
+	__debug_show_held_locks(t);
+
+	t->last_switch_timestamp = now;
+	touch_nmi_watchdog();
+}
+
+/*
+ * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
+ * a really long time (120 seconds). If that happens, print out
+ * a warning.
+ */
+static void check_hung_uninterruptible_tasks(int this_cpu)
+{
+	int max_count = sysctl_hung_task_check_count;
+	unsigned long now = get_timestamp(this_cpu);
+	struct task_struct *g, *t;
+
+	/*
+	 * If the system crashed already then all bets are off,
+	 * do not report extra hung tasks:
+	 */
+	if ((tainted & TAINT_DIE) || did_panic)
+		return;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, t) {
+		if (!--max_count)
+			break;
+		if (t->state & TASK_UNINTERRUPTIBLE)
+			check_hung_task(t, now);
+	} while_each_thread(g, t);
+
+	read_unlock(&tasklist_lock);
+}
+
+/*
  * The watchdog thread - runs every second and touches the timestamp.
  */
 static int watchdog(void *__bind_cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	int this_cpu = (int)__bind_cpu, check_cpu;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
@@ -135,13 +209,25 @@ static int watchdog(void *__bind_cpu)
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
-	 * If this gets delayed for more than 10 seconds then the
+	 * If this gets delayed for more than 60 seconds then the
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
-		schedule();
+		msleep_interruptible(10000);
+
+		/*
+		 * Only do the hung-tasks check on one CPU:
+		 */
+		get_online_cpus();
+		check_cpu = any_online_cpu(cpu_online_map);
+		put_online_cpus();
+
+		if (this_cpu != check_cpu)
+			continue;
+
+		if (sysctl_hung_task_timeout_secs)
+			check_hung_uninterruptible_tasks(this_cpu);
 	}
 
 	return 0;
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -753,6 +753,33 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 		.extra2		= &sixty,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_check_count",
+		.data		= &sysctl_hung_task_check_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_timeout_secs",
+		.data		= &sysctl_hung_task_timeout_secs,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_warnings",
+		.data		= &sysctl_hung_task_warnings,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
 #endif
 #ifdef CONFIG_COMPAT
 	{
