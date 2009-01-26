Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZAZRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZAZRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZAZRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:24:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZAZRYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:24:49 -0500
Date: Mon, 26 Jan 2009 18:24:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] core kernel fixes
Message-ID: <20090126172432.GA4019@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jiri Slaby (1):
      relay: fix lock imbalance in relay_late_setup_files

Lai Jiangshan (2):
      rcu: add __cpuinit to rcu_init_percpu_data()
      rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR

Mandeep Singh Baines (1):
      softlock: fix false panic which can occur if softlockup_thresh is reduced

Mike Travis (1):
      rcu: move Kconfig menu

Robert Richter (1):
      oprofile: fix uninitialized use of struct op_entry

Thomas Gleixner (1):
      debugobjects: add and use INIT_WORK_ON_STACK


 arch/x86/kernel/hpet.c        |    3 +-
 drivers/oprofile/cpu_buffer.c |    5 +
 drivers/oprofile/cpu_buffer.h |    7 ++
 include/linux/sched.h         |    3 +
 include/linux/workqueue.h     |    6 ++
 init/Kconfig                  |  179 +++++++++++++++++++++--------------------
 kernel/rcuclassic.c           |    2 +-
 kernel/rcutree.c              |    2 +-
 kernel/relay.c                |    4 +-
 kernel/softlockup.c           |    9 ++
 kernel/sysctl.c               |    2 +-
 lib/Kconfig.debug             |   13 ---
 12 files changed, 130 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index cd759ad..64d5ad0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -628,11 +628,12 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK(&work.work, hpet_work);
+		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
 		init_completion(&work.complete);
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
 		wait_for_completion(&work.complete);
+		destroy_timer_on_stack(&work.work.timer);
 		break;
 	case CPU_DEAD:
 		if (hdev) {
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 2e03b6d..e76d715 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -393,16 +393,21 @@ oprofile_write_reserve(struct op_entry *entry, struct pt_regs * const regs,
 	return;
 
 fail:
+	entry->event = NULL;
 	cpu_buf->sample_lost_overflow++;
 }
 
 int oprofile_add_data(struct op_entry *entry, unsigned long val)
 {
+	if (!entry->event)
+		return 0;
 	return op_cpu_buffer_add_data(entry, val);
 }
 
 int oprofile_write_commit(struct op_entry *entry)
 {
+	if (!entry->event)
+		return -EINVAL;
 	return op_cpu_buffer_write_commit(entry);
 }
 
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 63f81c4..272995d 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -66,6 +66,13 @@ static inline void op_cpu_buffer_reset(int cpu)
 	cpu_buf->last_task = NULL;
 }
 
+/*
+ * op_cpu_buffer_add_data() and op_cpu_buffer_write_commit() may be
+ * called only if op_cpu_buffer_write_reserve() did not return NULL or
+ * entry->event != NULL, otherwise entry->size or entry->event will be
+ * used uninitialized.
+ */
+
 struct op_sample
 *op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size);
 int op_cpu_buffer_write_commit(struct op_entry *entry);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..54cbabf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -293,6 +293,9 @@ extern void sched_show_task(struct task_struct *p);
 extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
+extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
+				    struct file *filp, void __user *buffer,
+				    size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b362911..20b59eb 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -124,6 +124,12 @@ struct execute_work {
 		init_timer_deferrable(&(_work)->timer);		\
 	} while (0)
 
+#define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
+	do {							\
+		INIT_WORK(&(_work)->work, (_func));		\
+		init_timer_on_stack(&(_work)->timer);		\
+	} while (0)
+
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
diff --git a/init/Kconfig b/init/Kconfig
index 2af8382..3be35f3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -238,6 +238,98 @@ config AUDIT_TREE
 	def_bool y
 	depends on AUDITSYSCALL && INOTIFY
 
+menu "RCU Subsystem"
+
+choice
+	prompt "RCU Implementation"
+	default CLASSIC_RCU
+
+config CLASSIC_RCU
+	bool "Classic RCU"
+	help
+	  This option selects the classic RCU implementation that is
+	  designed for best read-side performance on non-realtime
+	  systems.
+
+	  Select this option if you are unsure.
+
+config TREE_RCU
+	bool "Tree-based hierarchical RCU"
+	help
+	  This option selects the RCU implementation that is
+	  designed for very large SMP system with hundreds or
+	  thousands of CPUs.
+
+config PREEMPT_RCU
+	bool "Preemptible RCU"
+	depends on PREEMPT
+	help
+	  This option reduces the latency of the kernel by making certain
+	  RCU sections preemptible. Normally RCU code is non-preemptible, if
+	  this option is selected then read-only RCU sections become
+	  preemptible. This helps latency, but may expose bugs due to
+	  now-naive assumptions about each RCU read-side critical section
+	  remaining on a given CPU through its execution.
+
+endchoice
+
+config RCU_TRACE
+	bool "Enable tracing for RCU"
+	depends on TREE_RCU || PREEMPT_RCU
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
+	  Say N if you are unsure.
+
+config RCU_FANOUT
+	int "Tree-based hierarchical RCU fanout value"
+	range 2 64 if 64BIT
+	range 2 32 if !64BIT
+	depends on TREE_RCU
+	default 64 if 64BIT
+	default 32 if !64BIT
+	help
+	  This option controls the fanout of hierarchical implementations
+	  of RCU, allowing RCU to work efficiently on machines with
+	  large numbers of CPUs.  This value must be at least the cube
+	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
+	  systems and up to 262,144 for 64-bit systems.
+
+	  Select a specific number if testing RCU itself.
+	  Take the default if unsure.
+
+config RCU_FANOUT_EXACT
+	bool "Disable tree-based hierarchical RCU auto-balancing"
+	depends on TREE_RCU
+	default n
+	help
+	  This option forces use of the exact RCU_FANOUT value specified,
+	  regardless of imbalances in the hierarchy.  This is useful for
+	  testing RCU itself, and might one day be useful on systems with
+	  strong NUMA behavior.
+
+	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
+
+	  Say N if unsure.
+
+config TREE_RCU_TRACE
+	def_bool RCU_TRACE && TREE_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the TREE_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcutree_trace.c.
+
+config PREEMPT_RCU_TRACE
+	def_bool RCU_TRACE && PREEMPT_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the PREEMPT_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
+
+endmenu # "RCU Subsystem"
+
 config IKCONFIG
 	tristate "Kernel .config support"
 	---help---
@@ -972,90 +1064,3 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
-choice
-	prompt "RCU Implementation"
-	default CLASSIC_RCU
-
-config CLASSIC_RCU
-	bool "Classic RCU"
-	help
-	  This option selects the classic RCU implementation that is
-	  designed for best read-side performance on non-realtime
-	  systems.
-
-	  Select this option if you are unsure.
-
-config TREE_RCU
-	bool "Tree-based hierarchical RCU"
-	help
-	  This option selects the RCU implementation that is
-	  designed for very large SMP system with hundreds or
-	  thousands of CPUs.
-
-config PREEMPT_RCU
-	bool "Preemptible RCU"
-	depends on PREEMPT
-	help
-	  This option reduces the latency of the kernel by making certain
-	  RCU sections preemptible. Normally RCU code is non-preemptible, if
-	  this option is selected then read-only RCU sections become
-	  preemptible. This helps latency, but may expose bugs due to
-	  now-naive assumptions about each RCU read-side critical section
-	  remaining on a given CPU through its execution.
-
-endchoice
-
-config RCU_TRACE
-	bool "Enable tracing for RCU"
-	depends on TREE_RCU || PREEMPT_RCU
-	help
-	  This option provides tracing in RCU which presents stats
-	  in debugfs for debugging RCU implementation.
-
-	  Say Y here if you want to enable RCU tracing
-	  Say N if you are unsure.
-
-config RCU_FANOUT
-	int "Tree-based hierarchical RCU fanout value"
-	range 2 64 if 64BIT
-	range 2 32 if !64BIT
-	depends on TREE_RCU
-	default 64 if 64BIT
-	default 32 if !64BIT
-	help
-	  This option controls the fanout of hierarchical implementations
-	  of RCU, allowing RCU to work efficiently on machines with
-	  large numbers of CPUs.  This value must be at least the cube
-	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
-	  systems and up to 262,144 for 64-bit systems.
-
-	  Select a specific number if testing RCU itself.
-	  Take the default if unsure.
-
-config RCU_FANOUT_EXACT
-	bool "Disable tree-based hierarchical RCU auto-balancing"
-	depends on TREE_RCU
-	default n
-	help
-	  This option forces use of the exact RCU_FANOUT value specified,
-	  regardless of imbalances in the hierarchy.  This is useful for
-	  testing RCU itself, and might one day be useful on systems with
-	  strong NUMA behavior.
-
-	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
-
-	  Say N if unsure.
-
-config TREE_RCU_TRACE
-	def_bool RCU_TRACE && TREE_RCU
-	select DEBUG_FS
-	help
-	  This option provides tracing for the TREE_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcutree_trace.c.
-
-config PREEMPT_RCU_TRACE
-	def_bool RCU_TRACE && PREEMPT_RCU
-	select DEBUG_FS
-	help
-	  This option provides tracing for the PREEMPT_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 490934f..bd5a900 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -716,7 +716,7 @@ void rcu_check_callbacks(int cpu, int user)
 	raise_rcu_softirq();
 }
 
-static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
+static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
 	unsigned long flags;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f2d8638..b2fd602 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1314,7 +1314,7 @@ int rcu_needs_cpu(int cpu)
  * access due to the fact that this CPU cannot possibly have any RCU
  * callbacks in flight yet.
  */
-static void
+static void __cpuinit
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
diff --git a/kernel/relay.c b/kernel/relay.c
index 09ac200..9d79b78 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -663,8 +663,10 @@ int relay_late_setup_files(struct rchan *chan,
 
 	mutex_lock(&relay_channels_mutex);
 	/* Is chan already set up? */
-	if (unlikely(chan->has_base_filename))
+	if (unlikely(chan->has_base_filename)) {
+		mutex_unlock(&relay_channels_mutex);
 		return -EEXIST;
+	}
 	chan->has_base_filename = 1;
 	chan->parent = parent;
 	curr_cpu = get_cpu();
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index d9188c6..85d5a24 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -16,6 +16,7 @@
 #include <linux/lockdep.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 
 #include <asm/irq_regs.h>
 
@@ -88,6 +89,14 @@ void touch_all_softlockup_watchdogs(void)
 }
 EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
+int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
+			     struct file *filp, void __user *buffer,
+			     size_t *lenp, loff_t *ppos)
+{
+	touch_all_softlockup_watchdogs();
+	return proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+}
+
 /*
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 368d163..790f9d7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -809,7 +809,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &proc_dosoftlockup_thresh,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4c9ae60..e770e85 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -633,19 +633,6 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU
-	default n
-	help
-	  This option causes RCU to printk information on which
-	  CPUs are delaying the current grace period, but only when
-	  the grace period extends for excessive time periods.
-
-	  Say Y if you want RCU to perform such checks.
-
-	  Say N if you are unsure.
-
-config RCU_CPU_STALL_DETECTOR
-	bool "Check for stalled CPUs delaying RCU grace periods"
 	depends on CLASSIC_RCU || TREE_RCU
 	default n
 	help
