Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZALGwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZALGwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZALGwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:52:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZALGwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:52:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=a0MTez7YFETJe6PxaiGfRwkpBd+oFyRkswLnGKpW3+oG7fQluV8H6F86oIhkSjGUf
	EhWZUJfI4GvwNRFlcNFjw==
Date: Sun, 11 Jan 2009 22:52:13 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: [PATCH v2] softlockup: decouple hung tasks check from softlockup detection
Message-ID: <20090112065213.GA19795@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.18
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decoupling allows:

* hung tasks check to happen at very low priority
* hung tasks check and softlockup to be enabled/disabled independently
  at compile and/or run-time
* individual panic settings to be enabled disabled independently
  at compile and/or run-time
* softlockup threshold to be reduced without increasing hung tasks
  poll frequency (hung task check is expensive relative to softlock watchdog)
* hung task check to be zero over-head when disabled at run-time
---
 include/linux/sched.h |   14 +++++--
 kernel/Makefile       |    1 +
 kernel/softlockup.c   |  102 -------------------------------------------------
 kernel/sysctl.c       |   15 +++++++-
 lib/Kconfig.debug     |   38 ++++++++++++++++++
 5 files changed, 63 insertions(+), 107 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..9e6a39b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -296,9 +296,6 @@ extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern unsigned int  softlockup_panic;
-extern unsigned long sysctl_hung_task_check_count;
-extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
 extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
@@ -315,6 +312,15 @@ static inline void touch_all_softlockup_watchdogs(void)
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
@@ -1207,7 +1213,7 @@ struct task_struct {
 /* ipc stuff */
 	struct sysv_sem sysvsem;
 #endif
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_DETECT_HUNG_TASK
 /* hung task detection */
 	unsigned long last_switch_timestamp;
 	unsigned long last_switch_count;
diff --git a/kernel/Makefile b/kernel/Makefile
index 19fad00..2809bc6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
+obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index dc0b3be..8081b88 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -157,97 +157,11 @@ void softlockup_tick(void)
 }
 
 /*
- * Have a reasonable limit on the number of tasks checked:
- */
-unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
-
-/*
- * Zero means infinite timeout - no checking done:
- */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
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
 
@@ -267,11 +181,6 @@ static int watchdog(void *__bind_cpu)
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
@@ -303,20 +212,9 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		check_cpu = any_online_cpu(cpu_online_map);
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		if (hotcpu == check_cpu) {
-			cpumask_t temp_cpu_online_map = cpu_online_map;
-
-			cpu_clear(hotcpu, temp_cpu_online_map);
-			check_cpu = any_online_cpu(temp_cpu_online_map);
-		}
-		break;
-
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(watchdog_task, hotcpu))
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3d56fe7..51a4748 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -771,6 +771,19 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
+#endif
+#ifdef CONFIG_HUNG_TASK
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
@@ -786,7 +799,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= &proc_dohung_task_timeout_secs,
 		.strategy	= &sysctl_intvec,
 	},
 	{
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..a52aa38 100644
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
-- 
1.5.4.5

