Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYE2I7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYE2I7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYE2I4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17950 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYE2I4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:56:00 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/10] powerpc: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:17 +0200
Message-Id: <1212051504-12561-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts ppc to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single().

ppc loses the timeout functionality of smp_call_function_mask() with
this change, as the generic code does not provide that.

Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/kernel/smp.c               |  220 ++-----------------------------
 arch/powerpc/platforms/cell/interrupt.c |    1 +
 arch/powerpc/platforms/ps3/smp.c        |    7 +-
 arch/powerpc/platforms/pseries/xics.c   |    6 +-
 arch/powerpc/sysdev/mpic.c              |    2 +-
 include/asm-powerpc/smp.h               |    5 +-
 7 files changed, 23 insertions(+), 219 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 3934e26..852d40c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -110,6 +110,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select USE_GENERIC_SMP_HELPERS if SMP
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 1457aa0..cfdb21e 100644
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
@@ -154,215 +153,22 @@ static void stop_this_cpu(void *dummy)
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
-{
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
-
-	call_data = &data;
-	smp_wmb();
-	/* Send a message to all CPUs in the map */
-	for_each_cpu_mask(cpu, map)
-		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
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
+void arch_send_call_function_single_ipi(int cpu)
 {
-	int ret;
-	spin_lock(&call_lock);
-	ret =__smp_call_function_map(func, info, nonatomic, wait,
-				       cpu_online_map);
-	spin_unlock(&call_lock);
-	return ret;
-}
-
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-			int wait)
-{
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	return __smp_call_function(func, info, nonatomic, wait);
+	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL(smp_call_function);
 
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	cpumask_t map = CPU_MASK_NONE;
-	int ret = 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
+	unsigned int cpu;
 
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
+	for_each_cpu_mask(cpu, mask)
+		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
 }
-EXPORT_SYMBOL(smp_call_function_single);
 
 void smp_send_stop(void)
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
-}
-
-void smp_call_function_interrupt(void)
-{
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
-
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
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
 }
 
 extern struct gettimeofday_struct do_gtod;
@@ -596,9 +402,9 @@ int __devinit start_secondary(void *unused)
 
 	secondary_cpu_time_init();
 
-	spin_lock(&call_lock);
+	spin_lock(&call_function_lock);
 	cpu_set(cpu, cpu_online_map);
-	spin_unlock(&call_lock);
+	spin_unlock(&call_function_lock);
 
 	local_irq_enable();
 
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 5bf7df1..2d5bb22 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -218,6 +218,7 @@ void iic_request_IPIs(void)
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
index ebebc28..0fc830f 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -383,13 +383,11 @@ static irqreturn_t xics_ipi_dispatch(int cpu)
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
index 7680001..6c90c95 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1494,7 +1494,7 @@ void mpic_request_ipis(void)
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
1.5.6.rc0.40.gd683

