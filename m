Return-Path: <linux-kernel-owner+w=401wt.eu-S1765521AbZAOTT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765521AbZAOTT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764398AbZAOTTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:19:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51804 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170AbZAOTTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:19:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:in-reply-to:x-operating-system:
	user-agent:x-gmailtapped-by:x-gmailtapped;
	b=eIh9sATrrmUqgbsEr3LudPfjozdc/Gv3unbl0wjtldRrWp6LKrlL17PFQNCgjJxH5
	5gW0gg+1wF0oELbT6KCrw==
Date: Thu, 15 Jan 2009 11:08:40 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, hannes@cmpxchg.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: [PATCH v4] softlockup: decouple hung tasks check from softlockup detection
Message-ID: <20090115190840.GA1764@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114105426.GH2913@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.147
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> this now conflicts with the softlockup-panic fix you posted - and that fix 
> has to go first as it's v2.6.29 material. (while the decoupling patch is 
> 2.6.30 material)
> 
> So could you please send a patch against tip/master:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Thanks,
> 
>       Ingo

No problem. Rebased to tip/master.

---

Decoupling allows:

* hung tasks check to happen at very low priority
* hung tasks check and softlockup to be enabled/disabled independently
  at compile and/or run-time
* individual panic settings to be enabled disabled independently
  at compile and/or run-time
* softlockup threshold to be reduced without increasing hung tasks
  poll frequency (hung task check is expensive relative to softlock watchdog)
* hung task check to be zero over-head when disabled at run-time

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 include/linux/sched.h |   14 +++-
 kernel/Makefile       |    1 +
 kernel/hung_task.c    |  198 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/softlockup.c   |  100 -------------------------
 kernel/sysctl.c       |   15 ++++-
 lib/Kconfig.debug     |   38 ++++++++++
 6 files changed, 261 insertions(+), 105 deletions(-)
 create mode 100644 kernel/hung_task.c

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a0b9b6..bda891e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -298,9 +298,6 @@ extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
 				    struct file *filp, void __user *buffer,
 				    size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
-extern unsigned long sysctl_hung_task_check_count;
-extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
 extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
@@ -317,6 +314,15 @@ static inline void touch_all_softlockup_watchdogs(void)
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
@@ -1240,7 +1246,7 @@ struct task_struct {
 /* ipc stuff */
 	struct sysv_sem sysvsem;
 #endif
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_DETECT_HUNG_TASK
 /* hung task detection */
 	unsigned long last_switch_timestamp;
 	unsigned long last_switch_count;
diff --git a/kernel/Makefile b/kernel/Makefile
index e411592..46cd2b6 100644
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
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
new file mode 100644
index 0000000..ba5a77c
--- /dev/null
+++ b/kernel/hung_task.c
@@ -0,0 +1,198 @@
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
+ * Have a reasonable limit on the number of tasks checked:
+ */
+unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
+
+/*
+ * Zero means infinite timeout - no checking done:
+ */
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+static unsigned long __read_mostly hung_task_poll_jiffies;
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
+/*
+ * Returns seconds, approximately.  We don't need nanosecond
+ * resolution, and we don't need to waste time with a big divide when
+ * 2^30ns == 1.074s.
+ */
+static unsigned long get_timestamp(void)
+{
+	int this_cpu = raw_smp_processor_id();
+
+	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
+}
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
+	if (!sysctl_hung_task_warnings)
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
+
+	if (sysctl_hung_task_panic)
+		panic("hung_task: blocked tasks");
+}
+
+/*
+ * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
+ * a really long time (120 seconds). If that happens, print out
+ * a warning.
+ */
+static void check_hung_uninterruptible_tasks(void)
+{
+	int max_count = sysctl_hung_task_check_count;
+	unsigned long now = get_timestamp();
+	struct task_struct *g, *t;
+
+	/*
+	 * If the system crashed already then all bets are off,
+	 * do not report extra hung tasks:
+	 */
+	if (test_taint(TAINT_DIE) || did_panic)
+		return;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, t) {
+		if (!--max_count)
+			goto unlock;
+		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
+		if (t->state == TASK_UNINTERRUPTIBLE)
+			check_hung_task(t, now);
+	} while_each_thread(g, t);
+ unlock:
+	read_unlock(&tasklist_lock);
+}
+
+static void update_poll_jiffies(void)
+{
+	/* timeout of 0 will disable the watchdog */
+	if (sysctl_hung_task_timeout_secs == 0)
+		hung_task_poll_jiffies = MAX_SCHEDULE_TIMEOUT;
+	else
+		hung_task_poll_jiffies = sysctl_hung_task_timeout_secs * HZ / 2;
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
+	update_poll_jiffies();
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
+	update_poll_jiffies();
+
+	for ( ; ; ) {
+		while (schedule_timeout_interruptible(hung_task_poll_jiffies));
+		check_hung_uninterruptible_tasks();
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
index 80849e0..d7971f6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -806,6 +806,19 @@ static struct ctl_table kern_table[] = {
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
@@ -821,7 +834,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dohung_task_timeout_secs,
 		.strategy	= &sysctl_intvec,
 	},
 	{
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 393eb8c..8ccaf97 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -199,6 +199,44 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
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
-- 
1.5.4.5

