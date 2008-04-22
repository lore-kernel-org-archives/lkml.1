Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbYDVIBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbYDVIBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbYDVH5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:57:32 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26346 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYDVH5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:57:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 11/11] s390: convert to generic helpers for IPI function calls
Date: Tue, 22 Apr 2008 09:57:37 +0200
Message-Id: <1208851058-8500-12-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
In-Reply-To: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts s390 to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested,
but it compiles.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/s390/Kconfig                   |    5 +
 arch/s390/kernel/smp.c              |  160 ++---------------------------------
 arch/sparc64/kernel/sparc64_ksyms.c |    1 +
 include/asm-s390/sigp.h             |    1 +
 include/asm-s390/smp.h              |    2 -
 5 files changed, 15 insertions(+), 154 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f6a68e1..ebaf50f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -62,6 +62,11 @@ config GENERIC_LOCKBREAK
 	default y
 	depends on SMP && PREEMPT
 
+config GENERIC_SMP_HELPERS
+	bool
+	depends on SMP
+	default y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 0dfa988..2ee3484 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -77,164 +77,18 @@ static DEFINE_PER_CPU(struct cpu, cpu_devices);
 
 static void smp_ext_bitcall(int, ec_bit_sig);
 
-/*
- * Structure and data for __smp_call_function_map(). This is designed to
- * minimise static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	cpumask_t started;
-	cpumask_t finished;
-	int wait;
-};
-
-static struct call_data_struct *call_data;
-
-/*
- * 'Call function' interrupt callback
- */
-static void do_call_function(void)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	cpu_set(smp_processor_id(), call_data->started);
-	(*func)(info);
-	if (wait)
-		cpu_set(smp_processor_id(), call_data->finished);;
-}
-
-static void __smp_call_function_map(void (*func) (void *info), void *info,
-				    int nonatomic, int wait, cpumask_t map)
-{
-	struct call_data_struct data;
-	int cpu, local = 0;
-
-	/*
-	 * Can deadlock when interrupts are disabled or if in wrong context.
-	 */
-	WARN_ON(irqs_disabled() || in_irq());
-
-	/*
-	 * Check for local function call. We have to have the same call order
-	 * as in on_each_cpu() because of machine_restart_smp().
-	 */
-	if (cpu_isset(smp_processor_id(), map)) {
-		local = 1;
-		cpu_clear(smp_processor_id(), map);
-	}
-
-	cpus_and(map, map, cpu_online_map);
-	if (cpus_empty(map))
-		goto out;
-
-	data.func = func;
-	data.info = info;
-	data.started = CPU_MASK_NONE;
-	data.wait = wait;
-	if (wait)
-		data.finished = CPU_MASK_NONE;
-
-	spin_lock(&call_lock);
-	call_data = &data;
+	int cpu;
 
-	for_each_cpu_mask(cpu, map)
+	for_each_cpu_mask(cpu, mask)
 		smp_ext_bitcall(cpu, ec_call_function);
-
-	/* Wait for response */
-	while (!cpus_equal(map, data.started))
-		cpu_relax();
-	if (wait)
-		while (!cpus_equal(map, data.finished))
-			cpu_relax();
-	spin_unlock(&call_lock);
-out:
-	if (local) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
 }
 
-/*
- * smp_call_function:
- * @func: the function to run; this must be fast and non-blocking
- * @info: an arbitrary pointer to pass to the function
- * @nonatomic: unused
- * @wait: if true, wait (atomically) until function has completed on other CPUs
- *
- * Run a function on all other CPUs.
- *
- * You must not call this function with disabled interrupts, from a
- * hardware interrupt handler or from a bottom half.
- */
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	cpumask_t map;
-
-	preempt_disable();
-	map = cpu_online_map;
-	cpu_clear(smp_processor_id(), map);
-	__smp_call_function_map(func, info, nonatomic, wait, map);
-	preempt_enable();
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function);
-
-/*
- * smp_call_function_single:
- * @cpu: the CPU where func should run
- * @func: the function to run; this must be fast and non-blocking
- * @info: an arbitrary pointer to pass to the function
- * @nonatomic: unused
- * @wait: if true, wait (atomically) until function has completed on other CPUs
- *
- * Run a function on one processor.
- *
- * You must not call this function with disabled interrupts, from a
- * hardware interrupt handler or from a bottom half.
- */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
-{
-	preempt_disable();
-	__smp_call_function_map(func, info, nonatomic, wait,
-				cpumask_of_cpu(cpu));
-	preempt_enable();
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * @mask: The set of cpus to run on.  Must not include the current cpu.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
-			   int wait)
-{
-	preempt_disable();
-	cpu_clear(smp_processor_id(), mask);
-	__smp_call_function_map(func, info, 0, wait, mask);
-	preempt_enable();
-	return 0;
+	smp_ext_bitcall(cpu, ec_call_function_single);
 }
-EXPORT_SYMBOL(smp_call_function_mask);
 
 void smp_send_stop(void)
 {
@@ -277,7 +131,9 @@ static void do_ext_call_interrupt(__u16 code)
 	bits = xchg(&S390_lowcore.ext_call_fast, 0);
 
 	if (test_bit(ec_call_function, &bits))
-		do_call_function();
+		generic_smp_call_function_interrupt();
+	else if (test_bit(ec_call_function_single, &bits))
+		generic_smp_call_function_single_interrupt();
 }
 
 /*
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 3873646..17b16b1 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -112,6 +112,7 @@ EXPORT_SYMBOL(__write_unlock);
 EXPORT_SYMBOL(__write_trylock);
 
 EXPORT_SYMBOL(smp_call_function);
+EXPORT_SYMBOL(smp_call_function_single);
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_MCOUNT)
diff --git a/include/asm-s390/sigp.h b/include/asm-s390/sigp.h
index e16d56f..ec403d4 100644
--- a/include/asm-s390/sigp.h
+++ b/include/asm-s390/sigp.h
@@ -61,6 +61,7 @@ typedef enum
 {
 	ec_schedule=0,
 	ec_call_function,
+	ec_call_function_single,
 	ec_bit_last
 } ec_bit_sig;
 
diff --git a/include/asm-s390/smp.h b/include/asm-s390/smp.h
index 6f3821a..ae0d0b5 100644
--- a/include/asm-s390/smp.h
+++ b/include/asm-s390/smp.h
@@ -93,8 +93,6 @@ extern int __cpu_up (unsigned int cpu);
 extern struct mutex smp_cpu_state_mutex;
 extern int smp_cpu_polarization[];
 
-extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-	void *info, int wait);
 #endif
 
 #ifndef CONFIG_SMP
-- 
1.5.5.49.gf43e2

