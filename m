Return-Path: <linux-kernel-owner+w=401wt.eu-S1161196AbXBUKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161196AbXBUKBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161204AbXBUKBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:01:19 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:30579 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161196AbXBUKBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:01:02 -0500
Date: Wed, 21 Feb 2007 11:01:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: jan.glauber@de.ibm.com
Subject: [S390] smp_call_function cleanup
Message-ID: <20070221100102.GD13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jan.glauber@de.ibm.com>

[S390] smp_call_function cleanup

Introduce __smp_call_function_map which calls a function on all cpus
given with a cpumask_t. Use it to implement smp_call_function and
smp_call_function_on. Replace smp_ext_bitcall_others with smp_ext_bitcall
and a for_each_cpu_mask loop. Use a cpumask_t instead of an atomic_t for
cpu counting and print a warning if preempt is on in
__smp_call_function_map().

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/smp.c |  181 ++++++++++++++++++++-----------------------------
 1 files changed, 77 insertions(+), 104 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/smp.c linux-2.6-patched/arch/s390/kernel/smp.c
--- linux-2.6/arch/s390/kernel/smp.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/smp.c	2007-02-21 10:47:26.000000000 +0100
@@ -54,19 +54,18 @@ cpumask_t cpu_possible_map = CPU_MASK_NO
 static struct task_struct *current_set[NR_CPUS];
 
 static void smp_ext_bitcall(int, ec_bit_sig);
-static void smp_ext_bitcall_others(ec_bit_sig);
 
 /*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
+ * Structure and data for __smp_call_function_map(). This is designed to
+ * minimise static memory requirements. It also looks cleaner.
  */
 static DEFINE_SPINLOCK(call_lock);
 
 struct call_data_struct {
 	void (*func) (void *info);
 	void *info;
-	atomic_t started;
-	atomic_t finished;
+	cpumask_t started;
+	cpumask_t finished;
 	int wait;
 };
 
@@ -81,118 +80,113 @@ static void do_call_function(void)
 	void *info = call_data->info;
 	int wait = call_data->wait;
 
-	atomic_inc(&call_data->started);
+	cpu_set(smp_processor_id(), call_data->started);
 	(*func)(info);
 	if (wait)
-		atomic_inc(&call_data->finished);
+		cpu_set(smp_processor_id(), call_data->finished);;
 }
 
-/*
- * this function sends a 'generic call function' IPI to all other CPUs
- * in the system.
- */
-
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
-/*
- * [SUMMARY] Run a function on all other CPUs.
- * <func> The function to run. This must be fast and non-blocking.
- * <info> An arbitrary pointer to pass to the function.
- * <nonatomic> currently unused.
- * <wait> If true, wait (atomically) until function has completed on other CPUs.
- * [RETURNS] 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler.
- */
+static void __smp_call_function_map(void (*func) (void *info), void *info,
+				    int nonatomic, int wait, cpumask_t map)
 {
 	struct call_data_struct data;
-	int cpus = num_online_cpus()-1;
+	int cpu, local = 0;
 
-	if (cpus <= 0)
-		return 0;
+	/*
+	 * Can deadlock when interrupts are disabled or if in wrong context,
+	 * caller must disable preemption
+	 */
+	WARN_ON(irqs_disabled() || in_irq() || preemptible());
 
-	/* Can deadlock when interrupts are disabled or if in wrong context */
-	WARN_ON(irqs_disabled() || in_irq());
+	/*
+	 * Check for local function call. We have to have the same call order
+	 * as in on_each_cpu() because of machine_restart_smp().
+	 */
+	if (cpu_isset(smp_processor_id(), map)) {
+		local = 1;
+		cpu_clear(smp_processor_id(), map);
+	}
+
+	cpus_and(map, map, cpu_online_map);
+	if (cpus_empty(map))
+		goto out;
 
 	data.func = func;
 	data.info = info;
-	atomic_set(&data.started, 0);
+	data.started = CPU_MASK_NONE;
 	data.wait = wait;
 	if (wait)
-		atomic_set(&data.finished, 0);
+		data.finished = CPU_MASK_NONE;
 
 	spin_lock_bh(&call_lock);
 	call_data = &data;
-	/* Send a message to all other CPUs and wait for them to respond */
-        smp_ext_bitcall_others(ec_call_function);
+
+	for_each_cpu_mask(cpu, map)
+		smp_ext_bitcall(cpu, ec_call_function);
 
 	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
+	while (!cpus_equal(map, data.started))
 		cpu_relax();
 
 	if (wait)
-		while (atomic_read(&data.finished) != cpus)
+		while (!cpus_equal(map, data.finished))
 			cpu_relax();
+
 	spin_unlock_bh(&call_lock);
 
-	return 0;
+out:
+	local_irq_disable();
+	if (local)
+		func(info);
+	local_irq_enable();
 }
 
 /*
- * Call a function on one CPU
- * cpu : the CPU the function should be executed on
+ * smp_call_function:
+ * @func: the function to run; this must be fast and non-blocking
+ * @info: an arbitrary pointer to pass to the function
+ * @nonatomic: unused
+ * @wait: if true, wait (atomically) until function has completed on other CPUs
  *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler. You may call it from a bottom half.
+ * Run a function on all other CPUs.
  *
- * It is guaranteed that the called function runs on the specified CPU,
- * preemption is disabled.
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler. Must be called with preemption disabled.
+ * You may call it from a bottom half.
  */
-int smp_call_function_on(void (*func) (void *info), void *info,
-			 int nonatomic, int wait, int cpu)
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+		      int wait)
 {
-	struct call_data_struct data;
-	int curr_cpu;
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
-
-	/* Can deadlock when interrupts are disabled or if in wrong context */
-	WARN_ON(irqs_disabled() || in_irq());
-
-	/* disable preemption for local function call */
-	curr_cpu = get_cpu();
-
-	if (curr_cpu == cpu) {
-		/* direct call to function */
-		func(info);
-		put_cpu();
-		return 0;
-	}
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	spin_lock_bh(&call_lock);
-	call_data = &data;
-	smp_ext_bitcall(cpu, ec_call_function);
+	cpumask_t map;
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != 1)
-		cpu_relax();
+	map = cpu_online_map;
+	cpu_clear(smp_processor_id(), map);
+	__smp_call_function_map(func, info, nonatomic, wait, map);
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function);
 
-	if (wait)
-		while (atomic_read(&data.finished) != 1)
-			cpu_relax();
+/*
+ * smp_call_function_on:
+ * @func: the function to run; this must be fast and non-blocking
+ * @info: an arbitrary pointer to pass to the function
+ * @nonatomic: unused
+ * @wait: if true, wait (atomically) until function has completed on other CPUs
+ * @cpu: the CPU where func should run
+ *
+ * Run a function on one processor.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler. Must be called with preemption disabled.
+ * You may call it from a bottom half.
+ */
+int smp_call_function_on(void (*func) (void *info), void *info, int nonatomic,
+			  int wait, int cpu)
+{
+	cpumask_t map = CPU_MASK_NONE;
 
-	spin_unlock_bh(&call_lock);
-	put_cpu();
+	cpu_set(cpu, map);
+	__smp_call_function_map(func, info, nonatomic, wait, map);
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_on);
@@ -325,26 +319,6 @@ static void smp_ext_bitcall(int cpu, ec_
 		udelay(10);
 }
 
-/*
- * Send an external call sigp to every other cpu in the system and
- * return without waiting for its completion.
- */
-static void smp_ext_bitcall_others(ec_bit_sig sig)
-{
-        int cpu;
-
-	for_each_online_cpu(cpu) {
-		if (cpu == smp_processor_id())
-                        continue;
-                /*
-                 * Set signaling bit in lowcore of target cpu and kick it
-                 */
-		set_bit(sig, (unsigned long *) &lowcore_ptr[cpu]->ext_call_fast);
-		while (signal_processor(cpu, sigp_emergency_signal) == sigp_busy)
-			udelay(10);
-        }
-}
-
 #ifndef CONFIG_64BIT
 /*
  * this function sends a 'purge tlb' signal to another CPU.
@@ -807,6 +781,5 @@ EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_SYMBOL(lowcore_ptr);
 EXPORT_SYMBOL(smp_ctl_set_bit);
 EXPORT_SYMBOL(smp_ctl_clear_bit);
-EXPORT_SYMBOL(smp_call_function);
 EXPORT_SYMBOL(smp_get_cpu);
 EXPORT_SYMBOL(smp_put_cpu);
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

