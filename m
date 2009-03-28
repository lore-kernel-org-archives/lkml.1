Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZC1XAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZC1XAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZC1XA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:00:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZC1XA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:00:28 -0400
Date: Sun, 29 Mar 2009 00:00:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] softlockup detector updates for v2.6.30
Message-ID: <20090328230007.GA8967@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest softlockup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git softlockup-for-linus

Note: CONFIG_DETECT_HUNG_TASK defaults to Y here, because that was 
its previous (implict) default from the softlockup watchdog. Should 
this default to N perhaps?

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      softlockup: ensure the task has been switched out once

Ingo Molnar (1):
      softlockup: move 'one' to the softlockup section in sysctl.c

Mandeep Singh Baines (7):
      softlockup: decouple hung tasks check from softlockup detection
      softlockup: fix to allow compiling with !DETECT_HUNG_TASK
      softlockup: fix potential race in hung_task when resetting timeout
      softlockup: remove unused definition for spawn_softlockup_task
      softlockup: check all tasks in hung_task
      softlockup: convert read_lock in hung_task to rcu_read_lock
      softlockup: remove timestamp checking from hung_task


 include/linux/sched.h |   18 +++--
 kernel/Makefile       |    1 +
 kernel/fork.c         |    8 +-
 kernel/hung_task.c    |  217 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/softlockup.c   |  100 -----------------------
 kernel/sysctl.c       |   19 ++++-
 lib/Kconfig.debug     |   38 +++++++++
 7 files changed, 286 insertions(+), 115 deletions(-)
 create mode 100644 kernel/hung_task.c

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1d19c02..3a843fa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -297,17 +297,11 @@ extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
 				    struct file *filp, void __user *buffer,
 				    size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
-extern unsigned long sysctl_hung_task_check_count;
-extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
 extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
 {
 }
-static inline void spawn_softlockup_task(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
@@ -316,6 +310,15 @@ static inline void touch_all_softlockup_watchdogs(void)
 }
 #endif
 
+#ifdef CONFIG_DETECT_HUNG_TASK
+extern unsigned int  sysctl_hung_task_panic;
+extern unsigned long sysctl_hung_task_check_count;
+extern unsigned long sysctl_hung_task_timeout_secs;
+extern unsigned long sysctl_hung_task_warnings;
+extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
+					 struct file *filp, void __user *buffer,
+					 size_t *lenp, loff_t *ppos);
+#endif
 
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
@@ -1260,9 +1263,8 @@ struct task_struct {
 /* ipc stuff */
 	struct sysv_sem sysvsem;
 #endif
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_DETECT_HUNG_TASK
 /* hung task detection */
-	unsigned long last_switch_timestamp;
 	unsigned long last_switch_count;
 #endif
 /* CPU-specific state of this task */
diff --git a/kernel/Makefile b/kernel/Makefile
index e4791b3..3e43fd1 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
+obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
diff --git a/kernel/fork.c b/kernel/fork.c
index 6715ebc..b82214b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -644,6 +644,9 @@ static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
+#ifdef CONFIG_DETECT_HUNG_TASK
+	tsk->last_switch_count = tsk->nvcsw + tsk->nivcsw;
+#endif
 
 	tsk->mm = NULL;
 	tsk->active_mm = NULL;
@@ -1046,11 +1049,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
-#ifdef CONFIG_DETECT_SOFTLOCKUP
-	p->last_switch_count = 0;
-	p->last_switch_timestamp = 0;
-#endif
-
 	task_io_accounting_init(&p->ioac);
 	acct_clear_integrals(p);
 
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
new file mode 100644
index 0000000..022a492
--- /dev/null
+++ b/kernel/hung_task.c
@@ -0,0 +1,217 @@
+/*
+ * Detect Hung Task
+ *
+ * kernel/hung_task.c - kernel thread for detecting tasks stuck in D state
+ *
+ */
+
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/nmi.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/lockdep.h>
+#include <linux/module.h>
+#include <linux/sysctl.h>
+
+/*
+ * The number of tasks checked:
+ */
+unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+
+/*
+ * Limit number of tasks checked in a batch.
+ *
+ * This value controls the preemptibility of khungtaskd since preemption
+ * is disabled during the critical section. It also controls the size of
+ * the RCU grace period. So it needs to be upper-bound.
+ */
+#define HUNG_TASK_BATCHING 1024
+
+/*
+ * Zero means infinite timeout - no checking done:
+ */
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+
+unsigned long __read_mostly sysctl_hung_task_warnings = 10;
+
+static int __read_mostly did_panic;
+
+static struct task_struct *watchdog_task;
+
+/*
+ * Should we panic (and reboot, if panic_timeout= is set) when a
+ * hung task is detected:
+ */
+unsigned int __read_mostly sysctl_hung_task_panic =
+				CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE;
+
+static int __init hung_task_panic_setup(char *str)
+{
+	sysctl_hung_task_panic = simple_strtoul(str, NULL, 0);
+
+	return 1;
+}
+__setup("hung_task_panic=", hung_task_panic_setup);
+
+static int
+hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	did_panic = 1;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block panic_block = {
+	.notifier_call = hung_task_panic,
+};
+
+static void check_hung_task(struct task_struct *t, unsigned long timeout)
+{
+	unsigned long switch_count = t->nvcsw + t->nivcsw;
+
+	/*
+	 * Ensure the task is not frozen.
+	 * Also, when a freshly created task is scheduled once, changes
+	 * its state to TASK_UNINTERRUPTIBLE without having ever been
+	 * switched out once, it musn't be checked.
+	 */
+	if (unlikely(t->flags & PF_FROZEN || !switch_count))
+		return;
+
+	if (switch_count != t->last_switch_count) {
+		t->last_switch_count = switch_count;
+		return;
+	}
+	if (!sysctl_hung_task_warnings)
+		return;
+	sysctl_hung_task_warnings--;
+
+	/*
+	 * Ok, the task did not get scheduled for more than 2 minutes,
+	 * complain:
+	 */
+	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
+			"%ld seconds.\n", t->comm, t->pid, timeout);
+	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+			" disables this message.\n");
+	sched_show_task(t);
+	__debug_show_held_locks(t);
+
+	touch_nmi_watchdog();
+
+	if (sysctl_hung_task_panic)
+		panic("hung_task: blocked tasks");
+}
+
+/*
+ * To avoid extending the RCU grace period for an unbounded amount of time,
+ * periodically exit the critical section and enter a new one.
+ *
+ * For preemptible RCU it is sufficient to call rcu_read_unlock in order
+ * exit the grace period. For classic RCU, a reschedule is required.
+ */
+static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
+{
+	get_task_struct(g);
+	get_task_struct(t);
+	rcu_read_unlock();
+	cond_resched();
+	rcu_read_lock();
+	put_task_struct(t);
+	put_task_struct(g);
+}
+
+/*
+ * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
+ * a really long time (120 seconds). If that happens, print out
+ * a warning.
+ */
+static void check_hung_uninterruptible_tasks(unsigned long timeout)
+{
+	int max_count = sysctl_hung_task_check_count;
+	int batch_count = HUNG_TASK_BATCHING;
+	struct task_struct *g, *t;
+
+	/*
+	 * If the system crashed already then all bets are off,
+	 * do not report extra hung tasks:
+	 */
+	if (test_taint(TAINT_DIE) || did_panic)
+		return;
+
+	rcu_read_lock();
+	do_each_thread(g, t) {
+		if (!--max_count)
+			goto unlock;
+		if (!--batch_count) {
+			batch_count = HUNG_TASK_BATCHING;
+			rcu_lock_break(g, t);
+			/* Exit if t or g was unhashed during refresh. */
+			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
+				goto unlock;
+		}
+		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
+		if (t->state == TASK_UNINTERRUPTIBLE)
+			check_hung_task(t, timeout);
+	} while_each_thread(g, t);
+ unlock:
+	rcu_read_unlock();
+}
+
+static unsigned long timeout_jiffies(unsigned long timeout)
+{
+	/* timeout of 0 will disable the watchdog */
+	return timeout ? timeout * HZ : MAX_SCHEDULE_TIMEOUT;
+}
+
+/*
+ * Process updating of timeout sysctl
+ */
+int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
+				  struct file *filp, void __user *buffer,
+				  size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
+
+	if (ret || !write)
+		goto out;
+
+	wake_up_process(watchdog_task);
+
+ out:
+	return ret;
+}
+
+/*
+ * kthread which checks for tasks stuck in D state
+ */
+static int watchdog(void *dummy)
+{
+	set_user_nice(current, 0);
+
+	for ( ; ; ) {
+		unsigned long timeout = sysctl_hung_task_timeout_secs;
+
+		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
+			timeout = sysctl_hung_task_timeout_secs;
+
+		check_hung_uninterruptible_tasks(timeout);
+	}
+
+	return 0;
+}
+
+static int __init hung_task_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+	watchdog_task = kthread_run(watchdog, NULL, "khungtaskd");
+
+	return 0;
+}
+
+module_init(hung_task_init);
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 85d5a24..88796c3 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -166,97 +166,11 @@ void softlockup_tick(void)
 }
 
 /*
- * Have a reasonable limit on the number of tasks checked:
- */
-unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
-
-/*
- * Zero means infinite timeout - no checking done:
- */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 480;
-
-unsigned long __read_mostly sysctl_hung_task_warnings = 10;
-
-/*
- * Only do the hung-tasks check on one CPU:
- */
-static int check_cpu __read_mostly = -1;
-
-static void check_hung_task(struct task_struct *t, unsigned long now)
-{
-	unsigned long switch_count = t->nvcsw + t->nivcsw;
-
-	if (t->flags & PF_FROZEN)
-		return;
-
-	if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
-		t->last_switch_count = switch_count;
-		t->last_switch_timestamp = now;
-		return;
-	}
-	if ((long)(now - t->last_switch_timestamp) <
-					sysctl_hung_task_timeout_secs)
-		return;
-	if (!sysctl_hung_task_warnings)
-		return;
-	sysctl_hung_task_warnings--;
-
-	/*
-	 * Ok, the task did not get scheduled for more than 2 minutes,
-	 * complain:
-	 */
-	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
-			"%ld seconds.\n", t->comm, t->pid,
-			sysctl_hung_task_timeout_secs);
-	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
-			" disables this message.\n");
-	sched_show_task(t);
-	__debug_show_held_locks(t);
-
-	t->last_switch_timestamp = now;
-	touch_nmi_watchdog();
-
-	if (softlockup_panic)
-		panic("softlockup: blocked tasks");
-}
-
-/*
- * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
- * a really long time (120 seconds). If that happens, print out
- * a warning.
- */
-static void check_hung_uninterruptible_tasks(int this_cpu)
-{
-	int max_count = sysctl_hung_task_check_count;
-	unsigned long now = get_timestamp(this_cpu);
-	struct task_struct *g, *t;
-
-	/*
-	 * If the system crashed already then all bets are off,
-	 * do not report extra hung tasks:
-	 */
-	if (test_taint(TAINT_DIE) || did_panic)
-		return;
-
-	read_lock(&tasklist_lock);
-	do_each_thread(g, t) {
-		if (!--max_count)
-			goto unlock;
-		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
-		if (t->state == TASK_UNINTERRUPTIBLE)
-			check_hung_task(t, now);
-	} while_each_thread(g, t);
- unlock:
-	read_unlock(&tasklist_lock);
-}
-
-/*
  * The watchdog thread - runs every second and touches the timestamp.
  */
 static int watchdog(void *__bind_cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-	int this_cpu = (long)__bind_cpu;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
@@ -276,11 +190,6 @@ static int watchdog(void *__bind_cpu)
 		if (kthread_should_stop())
 			break;
 
-		if (this_cpu == check_cpu) {
-			if (sysctl_hung_task_timeout_secs)
-				check_hung_uninterruptible_tasks(this_cpu);
-		}
-
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
@@ -312,18 +221,9 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		check_cpu = cpumask_any(cpu_online_mask);
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		if (hotcpu == check_cpu) {
-			/* Pick any other online cpu. */
-			check_cpu = cpumask_any_but(cpu_online_mask, hotcpu);
-		}
-		break;
-
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(watchdog_task, hotcpu))
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..6d2aeff 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -90,6 +90,9 @@ extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 /* Constants used for minimum and  maximum */
+#if defined(CONFIG_DETECT_HUNG_TASK) || defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+static int one = 1;
+#endif
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
 static int neg_one = -1;
@@ -100,7 +103,6 @@ static int two = 2;
 #endif
 
 static int zero;
-static int one = 1;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
@@ -815,6 +817,19 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
+#endif
+#ifdef CONFIG_DETECT_HUNG_TASK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_panic",
+		.data		= &sysctl_hung_task_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_check_count",
@@ -830,7 +845,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dohung_task_timeout_secs,
 		.strategy	= &sysctl_intvec,
 	},
 	{
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8fee0a1..5a26298 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -186,6 +186,44 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
+config DETECT_HUNG_TASK
+	bool "Detect Hung Tasks"
+	depends on DEBUG_KERNEL
+	default y
+	help
+	  Say Y here to enable the kernel to detect "hung tasks",
+	  which are bugs that cause the task to be stuck in
+	  uninterruptible "D" state indefinitiley.
+
+	  When a hung task is detected, the kernel will print the
+	  current stack trace (which you should report), but the
+	  task will stay in uninterruptible state. If lockdep is
+	  enabled then all held locks will also be reported. This
+	  feature has negligible overhead.
+
+config BOOTPARAM_HUNG_TASK_PANIC
+	bool "Panic (Reboot) On Hung Tasks"
+	depends on DETECT_HUNG_TASK
+	help
+	  Say Y here to enable the kernel to panic on "hung tasks",
+	  which are bugs that cause the kernel to leave a task stuck
+	  in uninterruptible "D" state.
+
+	  The panic can be used in combination with panic_timeout,
+	  to cause the system to reboot automatically after a
+	  hung task has been detected. This feature is useful for
+	  high-availability systems that have uptime guarantees and
+	  where a hung tasks must be resolved ASAP.
+
+	  Say N if unsure.
+
+config BOOTPARAM_HUNG_TASK_PANIC_VALUE
+	int
+	depends on DETECT_HUNG_TASK
+	range 0 1
+	default 0 if !BOOTPARAM_HUNG_TASK_PANIC
+	default 1 if BOOTPARAM_HUNG_TASK_PANIC
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
