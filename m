Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbZAKOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbZAKOgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZAKOg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:36:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34984 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZAKOg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:36:26 -0500
Date: Sun, 11 Jan 2009 15:36:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20090111143615.GA5633@elte.hu>
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
Andrew Morton (1):
      smp_call_function_single(): be slightly less stupid

David Miller (1):
      sparc64: Fix cpumask related build failure

Ingo Molnar (1):
      smp_call_function_single(): be slightly less stupid, fix

Paul E. McKenney (1):
      rcu: fix bug in rcutorture system-shutdown code


 arch/sparc/include/asm/topology_64.h |    4 +
 include/linux/smp.h                  |   13 +---
 kernel/Makefile                      |    6 ++-
 kernel/rcutorture.c                  |  113 ++++++++++++++++++++-------------
 kernel/up.c                          |   20 ++++++
 5 files changed, 100 insertions(+), 56 deletions(-)
 create mode 100644 kernel/up.c

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index b8a65b6..5bc0b8f 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -47,6 +47,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	(pcibus_to_node(bus) == -1 ? \
 	 CPU_MASK_ALL : \
 	 node_to_cpumask(pcibus_to_node(bus)))
+#define cpumask_of_pcibus(bus)	\
+	(pcibus_to_node(bus) == -1 ? \
+	 CPU_MASK_ALL_PTR : \
+	 cpumask_of_node(pcibus_to_node(bus)))
 
 #define SD_NODE_INIT (struct sched_domain) {		\
 	.min_interval		= 8,			\
diff --git a/include/linux/smp.h b/include/linux/smp.h
index b824669..715196b 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -24,6 +24,9 @@ struct call_single_data {
 /* total number of cpus in this system (may exceed NR_CPUS) */
 extern unsigned int total_cpus;
 
+int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
+				int wait);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -79,8 +82,6 @@ smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 	return 0;
 }
 
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /*
@@ -140,14 +141,6 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-#define smp_call_function_single(cpuid, func, info, wait) \
-({ \
-	WARN_ON(cpuid != 0);	\
-	local_irq_disable();	\
-	(func)(info);		\
-	local_irq_enable();	\
-	0;			\
-})
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
 #define smp_call_function_many(mask, func, info, wait) \
diff --git a/kernel/Makefile b/kernel/Makefile
index 2921d90..2aebc4c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -40,7 +40,11 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
+ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
+obj-y += smp.o
+else
+obj-y += up.o
+endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 1cff28d..7c4142a 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -136,29 +136,47 @@ static int stutter_pause_test = 0;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
-#define FULLSTOP_SHUTDOWN 1	/* Bail due to system shutdown/panic. */
-#define FULLSTOP_CLEANUP  2	/* Orderly shutdown. */
-static int fullstop;		/* stop generating callbacks at test end. */
-DEFINE_MUTEX(fullstop_mutex);	/* protect fullstop transitions and */
-				/*  spawning of kthreads. */
+/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
+
+#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
+#define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
+#define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
+static int fullstop = FULLSTOP_RMMOD;
+DEFINE_MUTEX(fullstop_mutex);	/* Protect fullstop transitions and spawning */
+				/*  of kthreads. */
 
 /*
- * Detect and respond to a signal-based shutdown.
+ * Detect and respond to a system shutdown.
  */
 static int
 rcutorture_shutdown_notify(struct notifier_block *unused1,
 			   unsigned long unused2, void *unused3)
 {
-	if (fullstop)
-		return NOTIFY_DONE;
 	mutex_lock(&fullstop_mutex);
-	if (!fullstop)
+	if (fullstop == FULLSTOP_DONTSTOP)
 		fullstop = FULLSTOP_SHUTDOWN;
+	else
+		printk(KERN_WARNING /* but going down anyway, so... */
+		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
 }
 
 /*
+ * Absorb kthreads into a kernel function that won't return, so that
+ * they won't ever access module text or data again.
+ */
+static void rcutorture_shutdown_absorb(char *title)
+{
+	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
+		printk(KERN_NOTICE
+		       "rcutorture thread %s parking due to system shutdown\n",
+		       title);
+		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
+	}
+}
+
+/*
  * Allocate an element from the rcu_tortures pool.
  */
 static struct rcu_torture *
@@ -219,13 +237,14 @@ rcu_random(struct rcu_random_state *rrsp)
 }
 
 static void
-rcu_stutter_wait(void)
+rcu_stutter_wait(char *title)
 {
-	while ((stutter_pause_test || !rcutorture_runnable) && !fullstop) {
+	while (stutter_pause_test || !rcutorture_runnable) {
 		if (rcutorture_runnable)
 			schedule_timeout_interruptible(1);
 		else
 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+		rcutorture_shutdown_absorb(title);
 	}
 }
 
@@ -287,7 +306,7 @@ rcu_torture_cb(struct rcu_head *p)
 	int i;
 	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
-	if (fullstop) {
+	if (fullstop != FULLSTOP_DONTSTOP) {
 		/* Test is ending, just drop callbacks on the floor. */
 		/* The next initialization will pick up the pieces. */
 		return;
@@ -619,10 +638,11 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
-		rcu_stutter_wait();
-	} while (!kthread_should_stop() && !fullstop);
+		rcu_stutter_wait("rcu_torture_writer");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
+	rcutorture_shutdown_absorb("rcu_torture_writer");
+	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -643,11 +663,12 @@ rcu_torture_fakewriter(void *arg)
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		cur_ops->sync();
-		rcu_stutter_wait();
-	} while (!kthread_should_stop() && !fullstop);
+		rcu_stutter_wait("rcu_torture_fakewriter");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
+	rcutorture_shutdown_absorb("rcu_torture_fakewriter");
+	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -752,12 +773,13 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
-		rcu_stutter_wait();
-	} while (!kthread_should_stop() && !fullstop);
+		rcu_stutter_wait("rcu_torture_reader");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_reader");
 	if (irqreader && cur_ops->irqcapable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
+	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -854,7 +876,8 @@ rcu_torture_stats(void *arg)
 	do {
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
-	} while (!kthread_should_stop() && !fullstop);
+		rcutorture_shutdown_absorb("rcu_torture_stats");
+	} while (!kthread_should_stop());
 	VERBOSE_PRINTK_STRING("rcu_torture_stats task stopping");
 	return 0;
 }
@@ -866,52 +889,49 @@ static int rcu_idle_cpu;	/* Force all torture tasks off this CPU */
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_var_t tmp_mask;
+	cpumask_t tmp_mask;
 	int i;
 
-	if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
-		BUG();
-
-	cpumask_setall(tmp_mask);
+	cpus_setall(tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
-	if (num_online_cpus() == 1)
-		goto out;
+	if (num_online_cpus() == 1) {
+		put_online_cpus();
+		return;
+	}
 
 	if (rcu_idle_cpu != -1)
-		cpumask_clear_cpu(rcu_idle_cpu, tmp_mask);
+		cpu_clear(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed_ptr(current, tmp_mask);
+	set_cpus_allowed_ptr(current, &tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed_ptr(reader_tasks[i],
-						     tmp_mask);
+						     &tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     tmp_mask);
+						     &tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, tmp_mask);
+		set_cpus_allowed_ptr(writer_task, &tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, tmp_mask);
+		set_cpus_allowed_ptr(stats_task, &tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
 	else
 		rcu_idle_cpu--;
 
-out:
 	put_online_cpus();
-	free_cpumask_var(tmp_mask);
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
@@ -925,7 +945,8 @@ rcu_torture_shuffle(void *arg)
 	do {
 		schedule_timeout_interruptible(shuffle_interval * HZ);
 		rcu_torture_shuffle_tasks();
-	} while (!kthread_should_stop() && !fullstop);
+		rcutorture_shutdown_absorb("rcu_torture_shuffle");
+	} while (!kthread_should_stop());
 	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task stopping");
 	return 0;
 }
@@ -940,10 +961,11 @@ rcu_torture_stutter(void *arg)
 	do {
 		schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 1;
-		if (!kthread_should_stop() && !fullstop)
+		if (!kthread_should_stop())
 			schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 0;
-	} while (!kthread_should_stop() && !fullstop);
+		rcutorture_shutdown_absorb("rcu_torture_stutter");
+	} while (!kthread_should_stop());
 	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
 	return 0;
 }
@@ -970,15 +992,16 @@ rcu_torture_cleanup(void)
 	int i;
 
 	mutex_lock(&fullstop_mutex);
-	if (!fullstop) {
-		/* If being signaled, let it happen, then exit. */
+	if (fullstop == FULLSTOP_SHUTDOWN) {
+		printk(KERN_WARNING /* but going down anyway, so... */
+		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 		mutex_unlock(&fullstop_mutex);
-		schedule_timeout_interruptible(10 * HZ);
+		schedule_timeout_uninterruptible(10);
 		if (cur_ops->cb_barrier != NULL)
 			cur_ops->cb_barrier();
 		return;
 	}
-	fullstop = FULLSTOP_CLEANUP;
+	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&rcutorture_nb);
 	if (stutter_task) {
@@ -1078,7 +1101,7 @@ rcu_torture_init(void)
 	else
 		nrealreaders = 2 * num_online_cpus();
 	rcu_torture_print_module_parms("Start of test");
-	fullstop = 0;
+	fullstop = FULLSTOP_DONTSTOP;
 
 	/* Set up the freelist. */
 
diff --git a/kernel/up.c b/kernel/up.c
new file mode 100644
index 0000000..c04b9dc
--- /dev/null
+++ b/kernel/up.c
@@ -0,0 +1,20 @@
+/*
+ * Uniprocessor-only support functions.  The counterpart to kernel/smp.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/smp.h>
+
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+				int wait)
+{
+	WARN_ON(cpu != 0);
+
+	local_irq_disable();
+	(func)(info);
+	local_irq_enable();
+
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_single);
