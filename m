Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYCSUpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYCSUpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYCSToL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:11 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26269 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253AbYCSToA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:44:00 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/5] powerpc: convert to generic helpers for IPI function calls
Date: Wed, 19 Mar 2008 12:56:11 +0100
Message-Id: <1205927772-31401-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts ppc to use the new helpers for smp_call_function() and
frieds, and adds support for smp_call_function_single().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/powerpc/kernel/smp.c               |  223 ++++---------------------------
 arch/powerpc/platforms/cell/interrupt.c |    1 +
 arch/powerpc/platforms/ps3/smp.c        |    7 +-
 arch/powerpc/platforms/pseries/xics.c   |    6 +-
 arch/powerpc/sysdev/mpic.c              |    2 +-
 include/asm-powerpc/smp.h               |    5 +-
 6 files changed, 36 insertions(+), 208 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index be35ffa..c94c80c 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -72,12 +72,8 @@ struct smp_ops_t *smp_ops;
 
 static volatile unsigned int cpu_callin_map[NR_CPUS];
 
-void smp_call_function_interrupt(void);
-
 int smt_enabled_at_boot = 1;
 
-static int ipi_fail_ok;
-
 static void (*crash_ipi_function_ptr)(struct pt_regs *) = NULL;
 
 #ifdef CONFIG_PPC64
@@ -99,12 +95,15 @@ void smp_message_recv(int msg)
 {
 	switch(msg) {
 	case PPC_MSG_CALL_FUNCTION:
-		smp_call_function_interrupt();
+		generic_smp_call_function_interrupt();
 		break;
 	case PPC_MSG_RESCHEDULE:
 		/* XXX Do we have to do this? */
 		set_need_resched();
 		break;
+	case PPC_MSG_CALL_FUNC_SINGLE:
+		generic_smp_call_function_single_interrupt();
+		break;
 	case PPC_MSG_DEBUGGER_BREAK:
 		if (crash_ipi_function_ptr) {
 			crash_ipi_function_ptr(get_irq_regs());
@@ -154,215 +153,47 @@ static void stop_this_cpu(void *dummy)
 		;
 }
 
-/*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- * Stolen from the i386 version.
- */
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_lock);
-
-static struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-} *call_data;
-
-/* delay of at least 8 seconds */
-#define SMP_CALL_TIMEOUT	8
-
-/*
- * These functions send a 'generic call function' IPI to other online
- * CPUS in the system.
- *
- * [SUMMARY] Run a function on other CPUs.
- * <func> The function to run. This must be fast and non-blocking.
- * <info> An arbitrary pointer to pass to the function.
- * <nonatomic> currently unused.
- * <wait> If true, wait (atomically) until function has completed on other CPUs.
- * [RETURNS] 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
- * <map> is a cpu map of the cpus to send IPI to.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-static int __smp_call_function_map(void (*func) (void *info), void *info,
-				   int nonatomic, int wait, cpumask_t map)
+static void send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int ret = -1, num_cpus;
-	int cpu;
-	u64 timeout;
-
-	if (unlikely(smp_ops == NULL))
-		return ret;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	/* remove 'self' from the map */
-	if (cpu_isset(smp_processor_id(), map))
-		cpu_clear(smp_processor_id(), map);
-
-	/* sanity check the map, remove any non-online processors. */
-	cpus_and(map, map, cpu_online_map);
-
-	num_cpus = cpus_weight(map);
-	if (!num_cpus)
-		goto done;
+	unsigned int cpu;
 
-	call_data = &data;
-	smp_wmb();
-	/* Send a message to all CPUs in the map */
-	for_each_cpu_mask(cpu, map)
+	for_each_cpu_mask(cpu, mask)
 		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
-
-	timeout = get_tb() + (u64) SMP_CALL_TIMEOUT * tb_ticks_per_sec;
-
-	/* Wait for indication that they have received the message */
-	while (atomic_read(&data.started) != num_cpus) {
-		HMT_low();
-		if (get_tb() >= timeout) {
-			printk("smp_call_function on cpu %d: other cpus not "
-				"responding (%d)\n", smp_processor_id(),
-				atomic_read(&data.started));
-			if (!ipi_fail_ok)
-				debugger(NULL);
-			goto out;
-		}
-	}
-
-	/* optionally wait for the CPUs to complete */
-	if (wait) {
-		while (atomic_read(&data.finished) != num_cpus) {
-			HMT_low();
-			if (get_tb() >= timeout) {
-				printk("smp_call_function on cpu %d: other "
-					"cpus not finishing (%d/%d)\n",
-					smp_processor_id(),
-					atomic_read(&data.finished),
-					atomic_read(&data.started));
-				debugger(NULL);
-				goto out;
-			}
-		}
-	}
-
- done:
-	ret = 0;
-
- out:
-	call_data = NULL;
-	HMT_medium();
-	return ret;
-}
-
-static int __smp_call_function(void (*func)(void *info), void *info,
-			       int nonatomic, int wait)
-{
-	int ret;
-	spin_lock(&call_lock);
-	ret =__smp_call_function_map(func, info, nonatomic, wait,
-				       cpu_online_map);
-	spin_unlock(&call_lock);
-	return ret;
 }
 
 int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 			int wait)
 {
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	if (unlikely(smp_ops == NULL))
+		return -1;
 
-	return __smp_call_function(func, info, nonatomic, wait);
+	return generic_smp_call_function(func, info, wait, cpu_online_map,
+						send_call_function_ipi);
 }
 EXPORT_SYMBOL(smp_call_function);
 
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
+static void send_cfs_ipi(int cpu)
 {
-	cpumask_t map = CPU_MASK_NONE;
-	int ret = 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
-
-	cpu_set(cpu, map);
-	if (cpu != get_cpu()) {
-		spin_lock(&call_lock);
-		ret = __smp_call_function_map(func, info, nonatomic, wait, map);
-		spin_unlock(&call_lock);
-	} else {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
-	put_cpu();
-	return ret;
+	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL(smp_call_function_single);
 
-void smp_send_stop(void)
+void __smp_call_function_single(int cpu, struct call_single_data *data)
 {
-	int nolock;
-
-	/* It's OK to fail sending the IPI, since the alternative is to
-	 * be stuck forever waiting on the other CPU to take the interrupt.
-	 *
-	 * It's better to at least continue and go through reboot, since this
-	 * function is usually called at panic or reboot time in the first
-	 * place.
-	 */
-	ipi_fail_ok = 1;
-
-	/* Don't deadlock in case we got called through panic */
-	nolock = !spin_trylock(&call_lock);
-	__smp_call_function_map(stop_this_cpu, NULL, 1, 0, cpu_online_map);
-	if (!nolock)
-		spin_unlock(&call_lock);
+	generic_exec_single(cpu, data, send_cfs_ipi);
 }
 
-void smp_call_function_interrupt(void)
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			      int nonatomic, int wait)
 {
-	void (*func) (void *info);
-	void *info;
-	int wait;
-
-	/* call_data will be NULL if the sender timed out while
-	 * waiting on us to receive the call.
-	 */
-	if (!call_data)
-		return;
-
-	func = call_data->func;
-	info = call_data->info;
-	wait = call_data->wait;
-
-	if (!wait)
-		smp_mb__before_atomic_inc();
+	return generic_smp_call_function_single(cpu, func, info, wait,
+						send_cfs_ipi);
+}
+EXPORT_SYMBOL(smp_call_function_single);
 
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
-	(*func)(info);
-	if (wait) {
-		smp_mb__before_atomic_inc();
-		atomic_inc(&call_data->finished);
-	}
+void smp_send_stop(void)
+{
+	generic_smp_call_function(stop_this_cpu, NULL, 0, cpu_online_map,
+					send_call_function_ipi);
 }
 
 extern struct gettimeofday_struct do_gtod;
@@ -594,9 +425,9 @@ int __devinit start_secondary(void *unused)
 
 	secondary_cpu_time_init();
 
-	spin_lock(&call_lock);
+	spin_lock(&call_function_lock);
 	cpu_set(cpu, cpu_online_map);
-	spin_unlock(&call_lock);
+	spin_unlock(&call_function_lock);
 
 	local_irq_enable();
 
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 04f74f9..bc91ec5 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -217,6 +217,7 @@ void iic_request_IPIs(void)
 {
 	iic_request_ipi(PPC_MSG_CALL_FUNCTION, "IPI-call");
 	iic_request_ipi(PPC_MSG_RESCHEDULE, "IPI-resched");
+	iic_request_ipi(PPC_MSG_CALL_FUNC_SINGLE, "IPI-call-single");
 #ifdef CONFIG_DEBUGGER
 	iic_request_ipi(PPC_MSG_DEBUGGER_BREAK, "IPI-debug");
 #endif /* CONFIG_DEBUGGER */
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index f0b12f2..a0927a3 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -105,9 +105,10 @@ static void __init ps3_smp_setup_cpu(int cpu)
 	 * to index needs to be setup.
 	 */
 
-	BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION  != 0);
-	BUILD_BUG_ON(PPC_MSG_RESCHEDULE     != 1);
-	BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK != 3);
+	BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION    != 0);
+	BUILD_BUG_ON(PPC_MSG_RESCHEDULE       != 1);
+	BUILD_BUG_ON(PPC_MSG_CALL_FUNC_SINGLE != 2);
+	BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK   != 3);
 
 	for (i = 0; i < MSG_COUNT; i++) {
 		result = ps3_event_receive_port_setup(cpu, &virqs[i]);
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index ca52b58..31fc69a 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -384,13 +384,11 @@ static irqreturn_t xics_ipi_dispatch(int cpu)
 			mb();
 			smp_message_recv(PPC_MSG_RESCHEDULE);
 		}
-#if 0
-		if (test_and_clear_bit(PPC_MSG_MIGRATE_TASK,
+		if (test_and_clear_bit(PPC_MSG_CALL_FUNC_SINGLE,
 				       &xics_ipi_message[cpu].value)) {
 			mb();
-			smp_message_recv(PPC_MSG_MIGRATE_TASK);
+			smp_message_recv(PPC_MSG_CALL_FUNC_SINGLE);
 		}
-#endif
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 		if (test_and_clear_bit(PPC_MSG_DEBUGGER_BREAK,
 				       &xics_ipi_message[cpu].value)) {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 6ffdda2..4c51691 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1505,7 +1505,7 @@ void mpic_request_ipis(void)
 	static char *ipi_names[] = {
 		"IPI0 (call function)",
 		"IPI1 (reschedule)",
-		"IPI2 (unused)",
+		"IPI2 (call function single)",
 		"IPI3 (debugger break)",
 	};
 	BUG_ON(mpic == NULL);
diff --git a/include/asm-powerpc/smp.h b/include/asm-powerpc/smp.h
index 505f35b..78382f6 100644
--- a/include/asm-powerpc/smp.h
+++ b/include/asm-powerpc/smp.h
@@ -67,10 +67,7 @@ DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
  * in /proc/interrupts will be wrong!!! --Troy */
 #define PPC_MSG_CALL_FUNCTION   0
 #define PPC_MSG_RESCHEDULE      1
-/* This is unused now */
-#if 0
-#define PPC_MSG_MIGRATE_TASK    2
-#endif
+#define PPC_MSG_CALL_FUNC_SINGLE	2
 #define PPC_MSG_DEBUGGER_BREAK  3
 
 void smp_init_iSeries(void);
-- 
1.5.4.GIT

