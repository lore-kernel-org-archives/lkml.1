Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbYCSUld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbYCSUld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYCSTmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:42:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26258 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbYCSTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:59 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/5] x86-64: convert to generic helpers for IPI function calls
Date: Wed, 19 Mar 2008 12:56:10 +0100
Message-Id: <1205927772-31401-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts x86-64 to use the new helpers for smp_call_function() and
frieds, and adds support for smp_call_function_single().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/entry_64.S  |    3 +
 arch/x86/kernel/i8259_64.c  |    1 +
 arch/x86/kernel/smp_64.c    |  175 ++++++++++---------------------------------
 include/asm-x86/hw_irq_64.h |    4 +-
 4 files changed, 46 insertions(+), 137 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c20c9e7..22caf56 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -713,6 +713,9 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
+ENTRY(call_function_single_interrupt)
+	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_single_interrupt
+END(call_function_single_interrupt)
 ENTRY(irq_move_cleanup_interrupt)
 	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
 END(irq_move_cleanup_interrupt)
diff --git a/arch/x86/kernel/i8259_64.c b/arch/x86/kernel/i8259_64.c
index fa57a15..2b0b6d2 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -493,6 +493,7 @@ void __init native_init_IRQ(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 2fd74b0..6002274 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -295,111 +295,27 @@ void smp_send_reschedule(int cpu)
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
-static struct call_data_struct * call_data;
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
 
-/*
- * this function sends a 'generic call function' IPI to all other CPU
- * of the system defined in the mask.
- */
-static int __smp_call_function_mask(cpumask_t mask,
-				    void (*func)(void *), void *info,
-				    int wait)
+static void send_cfs_ipi(int cpu)
 {
-	struct call_data_struct data;
-	cpumask_t allbutself;
-	int cpus;
-
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
-
-	cpus_and(mask, mask, allbutself);
-	cpus = cpus_weight(mask);
-
-	if (!cpus)
-		return 0;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	wmb();
-
-	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
-		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
-	else
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
+	cpumask_t mask = cpumask_of_cpu(cpu);
 
-	if (!wait)
-		return 0;
-
-	while (atomic_read(&data.finished) != cpus)
-		cpu_relax();
-
-	return 0;
+	send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
 }
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
-int smp_call_function_mask(cpumask_t mask,
-			   void (*func)(void *), void *info,
-			   int wait)
-{
-	int ret;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
 
-	spin_lock(&call_lock);
-	ret = __smp_call_function_mask(mask, func, info, wait);
-	spin_unlock(&call_lock);
-	return ret;
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	generic_exec_single(cpu, data, send_cfs_ipi);
 }
-EXPORT_SYMBOL(smp_call_function_mask);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
@@ -413,30 +329,26 @@ EXPORT_SYMBOL(smp_call_function_mask);
  * Does not return until the remote CPU is nearly ready to execute <func>
  * or is or has executed.
  */
-
-int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			      int nonatomic, int wait)
 {
-	/* prevent preemption and reschedule on another processor */
-	int ret, me = get_cpu();
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	if (cpu == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
+	return generic_smp_call_function_single(cpu, func, info, wait,
+						send_cfs_ipi);
+}
+EXPORT_SYMBOL(smp_call_function_single);
 
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+static void send_call_function_ipi(cpumask_t mask)
+{
+	cpumask_t allbutself;
 
-	put_cpu();
-	return ret;
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 }
-EXPORT_SYMBOL(smp_call_function_single);
 
 /*
  * smp_call_function - run a function on all other CPUs.
@@ -456,7 +368,8 @@ EXPORT_SYMBOL(smp_call_function_single);
 int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 			int wait)
 {
-	return smp_call_function_mask(cpu_online_map, func, info, wait);
+	return generic_smp_call_function(func, info, wait, cpu_online_map,
+						send_call_function_ipi);
 }
 EXPORT_SYMBOL(smp_call_function);
 
@@ -474,18 +387,13 @@ static void stop_this_cpu(void *dummy)
 
 void smp_send_stop(void)
 {
-	int nolock;
 	unsigned long flags;
 
 	if (reboot_force)
 		return;
 
-	/* Don't deadlock on the call lock in panic */
-	nolock = !spin_trylock(&call_lock);
 	local_irq_save(flags);
-	__smp_call_function_mask(cpu_online_map, stop_this_cpu, NULL, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -503,28 +411,25 @@ asmlinkage void smp_reschedule_interrupt(void)
 
 asmlinkage void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+
+	generic_smp_call_function_interrupt();
+
+	add_pda(irq_call_count, 1);
+	irq_exit();
+}
 
+asmlinkage void smp_call_function_single_interrupt(void)
+{
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
 	exit_idle();
 	irq_enter();
-	(*func)(info);
+
+	generic_smp_call_function_single_interrupt();
+
 	add_pda(irq_call_count, 1);
 	irq_exit();
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
 }
 
diff --git a/include/asm-x86/hw_irq_64.h b/include/asm-x86/hw_irq_64.h
index 312a58d..06ac80c 100644
--- a/include/asm-x86/hw_irq_64.h
+++ b/include/asm-x86/hw_irq_64.h
@@ -68,8 +68,7 @@
 #define ERROR_APIC_VECTOR	0xfe
 #define RESCHEDULE_VECTOR	0xfd
 #define CALL_FUNCTION_VECTOR	0xfc
-/* fb free - please don't readd KDB here because it's useless
-   (hint - think what a NMI bit does to a vector) */
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR	0xfa
 #define THRESHOLD_APIC_VECTOR   0xf9
 /* f8 free */
@@ -102,6 +101,7 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
+void call_function_single_interrupt(void);
 void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
-- 
1.5.4.GIT

