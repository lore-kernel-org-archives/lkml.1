Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbYCSUka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbYCSUka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYCSTmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:42:32 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26257 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871AbYCSTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:59 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/5] x86: convert to generic helpers for IPI function calls
Date: Wed, 19 Mar 2008 12:56:09 +0100
Message-Id: <1205927772-31401-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts x86 to use the new helpers for smp_call_function() and
frieds, and adds support for smp_call_function_single().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/smp_32.c                   |  165 +++++++++-------------------
 arch/x86/kernel/smpboot_32.c               |    4 +
 arch/x86/kernel/smpcommon_32.c             |   34 ------
 include/asm-x86/hw_irq_32.h                |    1 +
 include/asm-x86/mach-default/entry_arch.h  |    1 +
 include/asm-x86/mach-default/irq_vectors.h |    1 +
 6 files changed, 61 insertions(+), 145 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dc0cde9..8d12130 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -476,64 +476,29 @@ static void native_smp_send_reschedule(int cpu)
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
-/*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-};
-
 void lock_ipi_call_lock(void)
 {
-	spin_lock_irq(&call_lock);
+	spin_lock_irq(&call_function_lock);
 }
 
 void unlock_ipi_call_lock(void)
 {
-	spin_unlock_irq(&call_lock);
+	spin_unlock_irq(&call_function_lock);
 }
 
-static struct call_data_struct *call_data;
-
-static void __smp_call_function(void (*func) (void *info), void *info,
-				int nonatomic, int wait)
+static void send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpus = num_online_cpus() - 1;
-
-	if (!cpus)
-		return;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb();
-	
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	cpumask_t allbutself;
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
 
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 }
 
-
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.  Must not include the current cpu.
@@ -554,54 +519,41 @@ native_smp_call_function_mask(cpumask_t mask,
 			      void (*func)(void *), void *info,
 			      int wait)
 {
-	struct call_data_struct data;
-	cpumask_t allbutself;
-	int cpus;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
-
-	cpus_and(mask, mask, allbutself);
-	cpus = cpus_weight(mask);
-
-	if (!cpus) {
-		spin_unlock(&call_lock);
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
-	call_data = &data;
-	mb();
+	return generic_smp_call_function(func, info, wait, mask,
+						send_call_function_ipi);
+}
 
-	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
-		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
-	else
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+static void send_cfs_ipi(int cpu)
+{
+	cpumask_t mask = cpumask_of_cpu(cpu);
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
+	send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
+}
 
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	spin_unlock(&call_lock);
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	generic_exec_single(cpu, data, send_cfs_ipi);
+}
 
-	return 0;
+/*
+ * smp_call_function_single - Run a function on a specific CPU
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Currently unused.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Retrurns 0 on success, else a negative status code.
+ *
+ * Does not return until the remote CPU is nearly ready to execute <func>
+ * or is or has executed.
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			      int nonatomic, int wait)
+{
+	return generic_smp_call_function_single(cpu, func, info, wait,
+						send_cfs_ipi);
 }
+EXPORT_SYMBOL(smp_call_function_single);
 
 static void stop_this_cpu (void * dummy)
 {
@@ -622,14 +574,10 @@ static void stop_this_cpu (void * dummy)
 
 static void native_smp_send_stop(void)
 {
-	/* Don't deadlock on the call lock in panic */
-	int nolock = !spin_trylock(&call_lock);
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -647,29 +595,24 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
 	ack_APIC_irq();
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func)(info);
+
+	generic_smp_call_function_interrupt();
+
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
+}
 
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
+void smp_call_function_single_interrupt(void)
+{
+	ack_APIC_irq();
+	irq_enter();
+
+	generic_smp_call_function_single_interrupt();
+
+	__get_cpu_var(irq_stat).irq_call_count++;
+	irq_exit();
 }
 
 static int convert_apicid_to_cpu(int apic_id)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 579b9b7..d250388 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -1304,6 +1304,10 @@ void __init smp_intr_init(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+					call_function_single_interrupt);
 }
 
 /*
diff --git a/arch/x86/kernel/smpcommon_32.c b/arch/x86/kernel/smpcommon_32.c
index 8bc38af..4590a67 100644
--- a/arch/x86/kernel/smpcommon_32.c
+++ b/arch/x86/kernel/smpcommon_32.c
@@ -46,37 +46,3 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
 EXPORT_SYMBOL(smp_call_function);
-
-/**
- * smp_call_function_single - Run a function on a specific CPU
- * @cpu: The target CPU.  Cannot be the calling CPU.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
-{
-	/* prevent preemption and reschedule on another processor */
-	int ret;
-	int me = get_cpu();
-	if (cpu == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
-
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index ea88054..a87b132 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -32,6 +32,7 @@ extern void (*const interrupt[NR_IRQS])(void);
 void reschedule_interrupt(void);
 void invalidate_interrupt(void);
 void call_function_interrupt(void);
+void call_function_single_interrupt(void);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/include/asm-x86/mach-default/entry_arch.h b/include/asm-x86/mach-default/entry_arch.h
index bc86146..9283b60 100644
--- a/include/asm-x86/mach-default/entry_arch.h
+++ b/include/asm-x86/mach-default/entry_arch.h
@@ -13,6 +13,7 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
+BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 #endif
 
 /*
diff --git a/include/asm-x86/mach-default/irq_vectors.h b/include/asm-x86/mach-default/irq_vectors.h
index 881c63c..ed7d495 100644
--- a/include/asm-x86/mach-default/irq_vectors.h
+++ b/include/asm-x86/mach-default/irq_vectors.h
@@ -48,6 +48,7 @@
 #define INVALIDATE_TLB_VECTOR	0xfd
 #define RESCHEDULE_VECTOR	0xfc
 #define CALL_FUNCTION_VECTOR	0xfb
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfa
 
 #define THERMAL_APIC_VECTOR	0xf0
 /*
-- 
1.5.4.GIT

