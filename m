Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZCaM0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZCaM0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZCaM0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:26:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZCaM0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:26:33 -0400
Date: Tue, 31 Mar 2009 14:25:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] IPI updates for v2.6.30
Message-ID: <20090331122557.GA12975@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: csd.info]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest ipi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git ipi-for-linus

Highlights:

 - Removal of the kmalloc() from smp_call_function*() and the
   resulting simplification and refactoring, as discussed in
   great detail at:

      http://lkml.org/lkml/2009/2/16/217

Known risks:

 - The removal of the kmalloc() might in theory affect performance
   on large SMP systems:

     8969a5e: generic-ipi: remove kmalloc()

There are no known regressions.

 Thanks,

	Ingo

------------------>
Heiko Carstens (1):
      s390: remove arch specific smp_send_stop()

Ingo Molnar (5):
      generic-ipi: cleanups
      generic-ipi: eliminate WARN_ON()s during oops/panic
      panic: decrease oops_in_progress only after having done the panic
      panic, smp: provide smp_send_stop() wrapper on UP too
      panic: clean up kernel/panic.c

Nick Piggin (1):
      generic IPI: simplify barriers and locking

Peter Zijlstra (2):
      generic-ipi: remove kmalloc()
      generic-ipi: remove CSD_FLAG_WAIT


 arch/s390/include/asm/smp.h |    6 -
 block/blk-softirq.c         |    2 +-
 include/linux/smp.h         |    7 +-
 kernel/panic.c              |  115 ++++++------
 kernel/sched.c              |    2 +-
 kernel/smp.c                |  432 +++++++++++++++++++++++--------------------
 kernel/softirq.c            |    2 +-
 7 files changed, 304 insertions(+), 262 deletions(-)

diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index 2009158..72137bc 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -92,12 +92,6 @@ extern void arch_send_call_function_ipi(cpumask_t mask);
 #endif
 
 #ifndef CONFIG_SMP
-static inline void smp_send_stop(void)
-{
-	/* Disable all interrupts/machine checks */
-	__load_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK);
-}
-
 #define hard_smp_processor_id()		0
 #define smp_cpu_not_running(cpu)	1
 #endif
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ce0efc6..ee9c216 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -64,7 +64,7 @@ static int raise_blk_irq(int cpu, struct request *rq)
 		data->info = rq;
 		data->flags = 0;
 
-		__smp_call_function_single(cpu, data);
+		__smp_call_function_single(cpu, data, 0);
 		return 0;
 	}
 
diff --git a/include/linux/smp.h b/include/linux/smp.h
index bbacb7b..a69db82 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -38,7 +38,7 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 /*
  * main cross-CPU interfaces, handles INIT, TLB flush, STOP, etc.
  * (defined in asm header):
- */ 
+ */
 
 /*
  * stops all CPUs but the current one:
@@ -82,7 +82,8 @@ smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 	return 0;
 }
 
-void __smp_call_function_single(int cpuid, struct call_single_data *data);
+void __smp_call_function_single(int cpuid, struct call_single_data *data,
+				int wait);
 
 /*
  * Generic and arch helpers
@@ -121,6 +122,8 @@ extern unsigned int setup_max_cpus;
 
 #else /* !SMP */
 
+static inline void smp_send_stop(void) { }
+
 /*
  *	These macros fold the SMP functionality into a single CPU system
  */
diff --git a/kernel/panic.c b/kernel/panic.c
index 32fe4ef..3fd8c5b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -8,19 +8,19 @@
  * This function is used through-out the kernel (including mm and fs)
  * to indicate a major problem.
  */
+#include <linux/debug_locks.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/notifier.h>
 #include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/delay.h>
+#include <linux/random.h>
 #include <linux/reboot.h>
-#include <linux/notifier.h>
-#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/kexec.h>
+#include <linux/sched.h>
 #include <linux/sysrq.h>
-#include <linux/interrupt.h>
+#include <linux/init.h>
 #include <linux/nmi.h>
-#include <linux/kexec.h>
-#include <linux/debug_locks.h>
-#include <linux/random.h>
-#include <linux/kallsyms.h>
 #include <linux/dmi.h>
 
 int panic_on_oops;
@@ -52,19 +52,15 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-
 NORET_TYPE void panic(const char * fmt, ...)
 {
-	long i;
 	static char buf[1024];
 	va_list args;
-#if defined(CONFIG_S390)
-	unsigned long caller = (unsigned long) __builtin_return_address(0);
-#endif
+	long i;
 
 	/*
-	 * It's possible to come here directly from a panic-assertion and not
-	 * have preempt disabled. Some functions called from here want
+	 * It's possible to come here directly from a panic-assertion and
+	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
 	 */
 	preempt_disable();
@@ -77,7 +73,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
 #endif
-	bust_spinlocks(0);
 
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
@@ -86,14 +81,12 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
 	 * situation.
 	 */
 	smp_send_stop();
-#endif
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
@@ -102,19 +95,21 @@ NORET_TYPE void panic(const char * fmt, ...)
 
 	if (panic_timeout > 0) {
 		/*
-	 	 * Delay timeout seconds before rebooting the machine. 
-		 * We can't use the "normal" timers since we just panicked..
-	 	 */
-		printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
+		 * Delay timeout seconds before rebooting the machine.
+		 * We can't use the "normal" timers since we just panicked.
+		 */
+		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+
 		for (i = 0; i < panic_timeout*1000; ) {
 			touch_nmi_watchdog();
 			i += panic_blink(i);
 			mdelay(1);
 			i++;
 		}
-		/*	This will not be a clean reboot, with everything
-		 *	shutting down.  But if there is a chance of
-		 *	rebooting the system it will be rebooted.
+		/*
+		 * This will not be a clean reboot, with everything
+		 * shutting down.  But if there is a chance of
+		 * rebooting the system it will be rebooted.
 		 */
 		emergency_restart();
 	}
@@ -127,38 +122,44 @@ NORET_TYPE void panic(const char * fmt, ...)
 	}
 #endif
 #if defined(CONFIG_S390)
-	disabled_wait(caller);
+	{
+		unsigned long caller;
+
+		caller = (unsigned long)__builtin_return_address(0);
+		disabled_wait(caller);
+	}
 #endif
 	local_irq_enable();
-	for (i = 0;;) {
+	for (i = 0; ; ) {
 		touch_softlockup_watchdog();
 		i += panic_blink(i);
 		mdelay(1);
 		i++;
 	}
+	bust_spinlocks(0);
 }
 
 EXPORT_SYMBOL(panic);
 
 
 struct tnt {
-	u8 bit;
-	char true;
-	char false;
+	u8	bit;
+	char	true;
+	char	false;
 };
 
 static const struct tnt tnts[] = {
-	{ TAINT_PROPRIETARY_MODULE, 'P', 'G' },
-	{ TAINT_FORCED_MODULE, 'F', ' ' },
-	{ TAINT_UNSAFE_SMP, 'S', ' ' },
-	{ TAINT_FORCED_RMMOD, 'R', ' ' },
-	{ TAINT_MACHINE_CHECK, 'M', ' ' },
-	{ TAINT_BAD_PAGE, 'B', ' ' },
-	{ TAINT_USER, 'U', ' ' },
-	{ TAINT_DIE, 'D', ' ' },
-	{ TAINT_OVERRIDDEN_ACPI_TABLE, 'A', ' ' },
-	{ TAINT_WARN, 'W', ' ' },
-	{ TAINT_CRAP, 'C', ' ' },
+	{ TAINT_PROPRIETARY_MODULE,	'P', 'G' },
+	{ TAINT_FORCED_MODULE,		'F', ' ' },
+	{ TAINT_UNSAFE_SMP,		'S', ' ' },
+	{ TAINT_FORCED_RMMOD,		'R', ' ' },
+	{ TAINT_MACHINE_CHECK,		'M', ' ' },
+	{ TAINT_BAD_PAGE,		'B', ' ' },
+	{ TAINT_USER,			'U', ' ' },
+	{ TAINT_DIE,			'D', ' ' },
+	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
+	{ TAINT_WARN,			'W', ' ' },
+	{ TAINT_CRAP,			'C', ' ' },
 };
 
 /**
@@ -195,7 +196,8 @@ const char *print_tainted(void)
 		*s = 0;
 	} else
 		snprintf(buf, sizeof(buf), "Not tainted");
-	return(buf);
+
+	return buf;
 }
 
 int test_taint(unsigned flag)
@@ -211,7 +213,8 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
-	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
+	/* can't trust the integrity of the kernel anymore: */
+	debug_locks = 0;
 	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
@@ -266,8 +269,8 @@ static void do_oops_enter_exit(void)
 }
 
 /*
- * Return true if the calling CPU is allowed to print oops-related info.  This
- * is a bit racy..
+ * Return true if the calling CPU is allowed to print oops-related info.
+ * This is a bit racy..
  */
 int oops_may_print(void)
 {
@@ -276,20 +279,22 @@ int oops_may_print(void)
 
 /*
  * Called when the architecture enters its oops handler, before it prints
- * anything.  If this is the first CPU to oops, and it's oopsing the first time
- * then let it proceed.
+ * anything.  If this is the first CPU to oops, and it's oopsing the first
+ * time then let it proceed.
  *
- * This is all enabled by the pause_on_oops kernel boot option.  We do all this
- * to ensure that oopses don't scroll off the screen.  It has the side-effect
- * of preventing later-oopsing CPUs from mucking up the display, too.
+ * This is all enabled by the pause_on_oops kernel boot option.  We do all
+ * this to ensure that oopses don't scroll off the screen.  It has the
+ * side-effect of preventing later-oopsing CPUs from mucking up the display,
+ * too.
  *
- * It turns out that the CPU which is allowed to print ends up pausing for the
- * right duration, whereas all the other CPUs pause for twice as long: once in
- * oops_enter(), once in oops_exit().
+ * It turns out that the CPU which is allowed to print ends up pausing for
+ * the right duration, whereas all the other CPUs pause for twice as long:
+ * once in oops_enter(), once in oops_exit().
  */
 void oops_enter(void)
 {
-	debug_locks_off(); /* can't trust the integrity of the kernel anymore */
+	/* can't trust the integrity of the kernel anymore: */
+	debug_locks_off();
 	do_oops_enter_exit();
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 196d48b..518ffe5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1110,7 +1110,7 @@ static void hrtick_start(struct rq *rq, u64 delay)
 	if (rq == this_rq()) {
 		hrtimer_restart(timer);
 	} else if (!rq->hrtick_csd_pending) {
-		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd);
+		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd, 0);
 		rq->hrtick_csd_pending = 1;
 	}
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index bbedbb7..858baac 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -2,40 +2,82 @@
  * Generic helpers for smp ipi calls
  *
  * (C) Jens Axboe <jens.axboe@oracle.com> 2008
- *
  */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-static LIST_HEAD(call_function_queue);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+
+static struct {
+	struct list_head	queue;
+	spinlock_t		lock;
+} call_function __cacheline_aligned_in_smp =
+	{
+		.queue		= LIST_HEAD_INIT(call_function.queue),
+		.lock		= __SPIN_LOCK_UNLOCKED(call_function.lock),
+	};
 
 enum {
-	CSD_FLAG_WAIT		= 0x01,
-	CSD_FLAG_ALLOC		= 0x02,
-	CSD_FLAG_LOCK		= 0x04,
+	CSD_FLAG_LOCK		= 0x01,
 };
 
 struct call_function_data {
-	struct call_single_data csd;
-	spinlock_t lock;
-	unsigned int refs;
-	struct rcu_head rcu_head;
-	unsigned long cpumask_bits[];
+	struct call_single_data	csd;
+	spinlock_t		lock;
+	unsigned int		refs;
+	cpumask_var_t		cpumask;
 };
 
 struct call_single_queue {
-	struct list_head list;
-	spinlock_t lock;
+	struct list_head	list;
+	spinlock_t		lock;
+};
+
+static DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
+	.lock			= __SPIN_LOCK_UNLOCKED(cfd_data.lock),
+};
+
+static int
+hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return NOTIFY_BAD;
+		break;
+
+#ifdef CONFIG_CPU_HOTPLUG
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		free_cpumask_var(cfd->cpumask);
+		break;
+#endif
+	};
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
+	.notifier_call		= hotplug_cfd,
 };
 
 static int __cpuinit init_call_single_data(void)
 {
+	void *cpu = (void *)(long)smp_processor_id();
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -44,29 +86,63 @@ static int __cpuinit init_call_single_data(void)
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+
+	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
+	register_cpu_notifier(&hotplug_cfd_notifier);
+
 	return 0;
 }
 early_initcall(init_call_single_data);
 
-static void csd_flag_wait(struct call_single_data *data)
+/*
+ * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
+ *
+ * For non-synchronous ipi calls the csd can still be in use by the
+ * previous function call. For multi-cpu calls its even more interesting
+ * as we'll have to ensure no other cpu is observing our csd.
+ */
+static void csd_lock_wait(struct call_single_data *data)
 {
-	/* Wait for response */
-	do {
-		if (!(data->flags & CSD_FLAG_WAIT))
-			break;
+	while (data->flags & CSD_FLAG_LOCK)
 		cpu_relax();
-	} while (1);
+}
+
+static void csd_lock(struct call_single_data *data)
+{
+	csd_lock_wait(data);
+	data->flags = CSD_FLAG_LOCK;
+
+	/*
+	 * prevent CPU from reordering the above assignment
+	 * to ->flags with any subsequent assignments to other
+	 * fields of the specified call_single_data structure:
+	 */
+	smp_mb();
+}
+
+static void csd_unlock(struct call_single_data *data)
+{
+	WARN_ON(!(data->flags & CSD_FLAG_LOCK));
+
+	/*
+	 * ensure we're all done before releasing data:
+	 */
+	smp_mb();
+
+	data->flags &= ~CSD_FLAG_LOCK;
 }
 
 /*
- * Insert a previously allocated call_single_data element for execution
- * on the given CPU. data must already have ->func, ->info, and ->flags set.
+ * Insert a previously allocated call_single_data element
+ * for execution on the given CPU. data must already have
+ * ->func, ->info, and ->flags set.
  */
-static void generic_exec_single(int cpu, struct call_single_data *data)
+static
+void generic_exec_single(int cpu, struct call_single_data *data, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
-	int wait = data->flags & CSD_FLAG_WAIT, ipi;
 	unsigned long flags;
+	int ipi;
 
 	spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
@@ -74,24 +150,21 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
 	spin_unlock_irqrestore(&dst->lock, flags);
 
 	/*
-	 * Make the list addition visible before sending the ipi.
+	 * The list addition should be visible before sending the IPI
+	 * handler locks the list to pull the entry off it because of
+	 * normal cache coherency rules implied by spinlocks.
+	 *
+	 * If IPIs can go out of order to the cache coherency protocol
+	 * in an architecture, sufficient synchronisation should be added
+	 * to arch code to make it appear to obey cache coherency WRT
+	 * locking and barrier primitives. Generic code isn't really
+	 * equipped to do the right thing...
 	 */
-	smp_mb();
-
 	if (ipi)
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_flag_wait(data);
-}
-
-static void rcu_free_call_data(struct rcu_head *head)
-{
-	struct call_function_data *data;
-
-	data = container_of(head, struct call_function_data, rcu_head);
-
-	kfree(data);
+		csd_lock_wait(data);
 }
 
 /*
@@ -104,99 +177,83 @@ void generic_smp_call_function_interrupt(void)
 	int cpu = get_cpu();
 
 	/*
-	 * It's ok to use list_for_each_rcu() here even though we may delete
-	 * 'pos', since list_del_rcu() doesn't clear ->next
+	 * Ensure entry is visible on call_function_queue after we have
+	 * entered the IPI. See comment in smp_call_function_many.
+	 * If we don't have this, then we may miss an entry on the list
+	 * and never get another IPI to process it.
+	 */
+	smp_mb();
+
+	/*
+	 * It's ok to use list_for_each_rcu() here even though we may
+	 * delete 'pos', since list_del_rcu() doesn't clear ->next
 	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
+	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
-		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
+		spin_lock(&data->lock);
+		if (!cpumask_test_cpu(cpu, data->cpumask)) {
+			spin_unlock(&data->lock);
 			continue;
+		}
+		cpumask_clear_cpu(cpu, data->cpumask);
+		spin_unlock(&data->lock);
 
 		data->csd.func(data->csd.info);
 
 		spin_lock(&data->lock);
-		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
 		WARN_ON(data->refs == 0);
-		data->refs--;
-		refs = data->refs;
+		refs = --data->refs;
+		if (!refs) {
+			spin_lock(&call_function.lock);
+			list_del_rcu(&data->csd.list);
+			spin_unlock(&call_function.lock);
+		}
 		spin_unlock(&data->lock);
 
 		if (refs)
 			continue;
 
-		spin_lock(&call_function_lock);
-		list_del_rcu(&data->csd.list);
-		spin_unlock(&call_function_lock);
-
-		if (data->csd.flags & CSD_FLAG_WAIT) {
-			/*
-			 * serialize stores to data with the flag clear
-			 * and wakeup
-			 */
-			smp_wmb();
-			data->csd.flags &= ~CSD_FLAG_WAIT;
-		}
-		if (data->csd.flags & CSD_FLAG_ALLOC)
-			call_rcu(&data->rcu_head, rcu_free_call_data);
+		csd_unlock(&data->csd);
 	}
-	rcu_read_unlock();
 
 	put_cpu();
 }
 
 /*
- * Invoked by arch to handle an IPI for call function single. Must be called
- * from the arch with interrupts disabled.
+ * Invoked by arch to handle an IPI for call function single. Must be
+ * called from the arch with interrupts disabled.
  */
 void generic_smp_call_function_single_interrupt(void)
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	unsigned int data_flags;
 	LIST_HEAD(list);
 
-	/*
-	 * Need to see other stores to list head for checking whether
-	 * list is empty without holding q->lock
-	 */
-	smp_read_barrier_depends();
-	while (!list_empty(&q->list)) {
-		unsigned int data_flags;
-
-		spin_lock(&q->lock);
-		list_replace_init(&q->list, &list);
-		spin_unlock(&q->lock);
-
-		while (!list_empty(&list)) {
-			struct call_single_data *data;
-
-			data = list_entry(list.next, struct call_single_data,
-						list);
-			list_del(&data->list);
-
-			/*
-			 * 'data' can be invalid after this call if
-			 * flags == 0 (when called through
-			 * generic_exec_single(), so save them away before
-			 * making the call.
-			 */
-			data_flags = data->flags;
-
-			data->func(data->info);
-
-			if (data_flags & CSD_FLAG_WAIT) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_WAIT;
-			} else if (data_flags & CSD_FLAG_LOCK) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_LOCK;
-			} else if (data_flags & CSD_FLAG_ALLOC)
-				kfree(data);
-		}
+	spin_lock(&q->lock);
+	list_replace_init(&q->list, &list);
+	spin_unlock(&q->lock);
+
+	while (!list_empty(&list)) {
+		struct call_single_data *data;
+
+		data = list_entry(list.next, struct call_single_data, list);
+		list_del(&data->list);
+
+		/*
+		 * 'data' can be invalid after this call if flags == 0
+		 * (when called through generic_exec_single()),
+		 * so save them away before making the call:
+		 */
+		data_flags = data->flags;
+
+		data->func(data->info);
+
 		/*
-		 * See comment on outer loop
+		 * Unlocked CSDs are valid through generic_exec_single():
 		 */
-		smp_read_barrier_depends();
+		if (data_flags & CSD_FLAG_LOCK)
+			csd_unlock(data);
 	}
 }
 
@@ -215,65 +272,45 @@ static DEFINE_PER_CPU(struct call_single_data, csd_data);
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int wait)
 {
-	struct call_single_data d;
+	struct call_single_data d = {
+		.flags = 0,
+	};
 	unsigned long flags;
-	/* prevent preemption and reschedule on another processor,
-	   as well as CPU removal */
-	int me = get_cpu();
+	int this_cpu;
 	int err = 0;
 
+	/*
+	 * prevent preemption and reschedule on another processor,
+	 * as well as CPU removal
+	 */
+	this_cpu = get_cpu();
+
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
 
-	if (cpu == me) {
+	if (cpu == this_cpu) {
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
-	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-		struct call_single_data *data;
+	} else {
+		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
+			struct call_single_data *data = &d;
+
+			if (!wait)
+				data = &__get_cpu_var(csd_data);
 
-		if (!wait) {
-			/*
-			 * We are calling a function on a single CPU
-			 * and we are not going to wait for it to finish.
-			 * We first try to allocate the data, but if we
-			 * fail, we fall back to use a per cpu data to pass
-			 * the information to that CPU. Since all callers
-			 * of this code will use the same data, we must
-			 * synchronize the callers to prevent a new caller
-			 * from corrupting the data before the callee
-			 * can access it.
-			 *
-			 * The CSD_FLAG_LOCK is used to let us know when
-			 * the IPI handler is done with the data.
-			 * The first caller will set it, and the callee
-			 * will clear it. The next caller must wait for
-			 * it to clear before we set it again. This
-			 * will make sure the callee is done with the
-			 * data before a new caller will use it.
-			 */
-			data = kmalloc(sizeof(*data), GFP_ATOMIC);
-			if (data)
-				data->flags = CSD_FLAG_ALLOC;
-			else {
-				data = &per_cpu(csd_data, me);
-				while (data->flags & CSD_FLAG_LOCK)
-					cpu_relax();
-				data->flags = CSD_FLAG_LOCK;
-			}
+			csd_lock(data);
+
+			data->func = func;
+			data->info = info;
+			generic_exec_single(cpu, data, wait);
 		} else {
-			data = &d;
-			data->flags = CSD_FLAG_WAIT;
+			err = -ENXIO;	/* CPU not online */
 		}
-
-		data->func = func;
-		data->info = info;
-		generic_exec_single(cpu, data);
-	} else {
-		err = -ENXIO;	/* CPU not online */
 	}
 
 	put_cpu();
+
 	return err;
 }
 EXPORT_SYMBOL(smp_call_function_single);
@@ -283,23 +320,26 @@ EXPORT_SYMBOL(smp_call_function_single);
  * @cpu: The CPU to run on.
  * @data: Pre-allocated and setup data structure
  *
- * Like smp_call_function_single(), but allow caller to pass in a pre-allocated
- * data structure. Useful for embedding @data inside other structures, for
- * instance.
- *
+ * Like smp_call_function_single(), but allow caller to pass in a
+ * pre-allocated data structure. Useful for embedding @data inside
+ * other structures, for instance.
  */
-void __smp_call_function_single(int cpu, struct call_single_data *data)
+void __smp_call_function_single(int cpu, struct call_single_data *data,
+				int wait)
 {
+	csd_lock(data);
+
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
+	WARN_ON_ONCE(wait && irqs_disabled() && !oops_in_progress);
 
-	generic_exec_single(cpu, data);
+	generic_exec_single(cpu, data, wait);
 }
 
-/* FIXME: Shim for archs using old arch_send_call_function_ipi API. */
+/* Deprecated: shim for archs using old arch_send_call_function_ipi API. */
+
 #ifndef arch_send_call_function_ipi_mask
-#define arch_send_call_function_ipi_mask(maskp) \
-	arch_send_call_function_ipi(*(maskp))
+# define arch_send_call_function_ipi_mask(maskp) \
+	 arch_send_call_function_ipi(*(maskp))
 #endif
 
 /**
@@ -307,7 +347,8 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
  * @mask: The set of cpus to run on (only runs on online subset).
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ * @wait: If true, wait (atomically) until function has completed
+ *        on other CPUs.
  *
  * If @wait is true, then returns once @func has returned. Note that @wait
  * will be implicitly turned on in case of allocation failures, since
@@ -318,27 +359,27 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
  * must be disabled when calling this function.
  */
 void smp_call_function_many(const struct cpumask *mask,
-			    void (*func)(void *), void *info,
-			    bool wait)
+			    void (*func)(void *), void *info, bool wait)
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu;
+	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
 
-	/* So, what's a CPU they want?  Ignoring this one. */
+	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
-	if (cpu == smp_processor_id())
+	if (cpu == this_cpu)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
+
 	/* No online cpus?  We're done. */
 	if (cpu >= nr_cpu_ids)
 		return;
 
 	/* Do we have another CPU which isn't us? */
 	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
-	if (next_cpu == smp_processor_id())
+	if (next_cpu == this_cpu)
 		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
 
 	/* Fastpath: do that cpu by itself. */
@@ -347,43 +388,40 @@ void smp_call_function_many(const struct cpumask *mask,
 		return;
 	}
 
-	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
-	if (unlikely(!data)) {
-		/* Slow path. */
-		for_each_online_cpu(cpu) {
-			if (cpu == smp_processor_id())
-				continue;
-			if (cpumask_test_cpu(cpu, mask))
-				smp_call_function_single(cpu, func, info, wait);
-		}
-		return;
-	}
+	data = &__get_cpu_var(cfd_data);
+	csd_lock(&data->csd);
 
-	spin_lock_init(&data->lock);
-	data->csd.flags = CSD_FLAG_ALLOC;
-	if (wait)
-		data->csd.flags |= CSD_FLAG_WAIT;
+	spin_lock_irqsave(&data->lock, flags);
 	data->csd.func = func;
 	data->csd.info = info;
-	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
-	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
+	cpumask_and(data->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, data->cpumask);
+	data->refs = cpumask_weight(data->cpumask);
 
-	spin_lock_irqsave(&call_function_lock, flags);
-	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-	spin_unlock_irqrestore(&call_function_lock, flags);
+	spin_lock(&call_function.lock);
+	/*
+	 * Place entry at the _HEAD_ of the list, so that any cpu still
+	 * observing the entry in generic_smp_call_function_interrupt()
+	 * will not miss any other list entries:
+	 */
+	list_add_rcu(&data->csd.list, &call_function.queue);
+	spin_unlock(&call_function.lock);
+
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	/*
 	 * Make the list addition visible before sending the ipi.
+	 * (IPIs must obey or appear to obey normal Linux cache
+	 * coherency rules -- see comment in generic_exec_single).
 	 */
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(to_cpumask(data->cpumask_bits));
+	arch_send_call_function_ipi_mask(data->cpumask);
 
-	/* optionally wait for the CPUs to complete */
+	/* Optionally wait for the CPUs to complete */
 	if (wait)
-		csd_flag_wait(&data->csd);
+		csd_lock_wait(&data->csd);
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
@@ -391,7 +429,8 @@ EXPORT_SYMBOL(smp_call_function_many);
  * smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ * @wait: If true, wait (atomically) until function has completed
+ *        on other CPUs.
  *
  * Returns 0.
  *
@@ -407,26 +446,27 @@ int smp_call_function(void (*func)(void *), void *info, int wait)
 	preempt_disable();
 	smp_call_function_many(cpu_online_mask, func, info, wait);
 	preempt_enable();
+
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
 
 void ipi_call_lock(void)
 {
-	spin_lock(&call_function_lock);
+	spin_lock(&call_function.lock);
 }
 
 void ipi_call_unlock(void)
 {
-	spin_unlock(&call_function_lock);
+	spin_unlock(&call_function.lock);
 }
 
 void ipi_call_lock_irq(void)
 {
-	spin_lock_irq(&call_function_lock);
+	spin_lock_irq(&call_function.lock);
 }
 
 void ipi_call_unlock_irq(void)
 {
-	spin_unlock_irq(&call_function_lock);
+	spin_unlock_irq(&call_function.lock);
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 57d3f67..c349a03 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -496,7 +496,7 @@ static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softir
 		cp->flags = 0;
 		cp->priv = softirq;
 
-		__smp_call_function_single(cpu, cp);
+		__smp_call_function_single(cpu, cp, 0);
 		return 0;
 	}
 	return 1;
