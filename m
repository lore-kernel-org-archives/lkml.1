Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYE2I7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYE2I7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYE2I4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17951 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbYE2I4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:56:00 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/10] x86: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:16 +0200
Message-Id: <1212051504-12561-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts x86, x86-64, and xen to use the new helpers for
smp_call_function() and friends, and adds support for
smp_call_function_single().

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/Kconfig                           |    1 +
 arch/x86/kernel/apic_32.c                  |    4 +
 arch/x86/kernel/entry_64.S                 |    3 +
 arch/x86/kernel/i8259_64.c                 |    4 +
 arch/x86/kernel/smp.c                      |  152 ++++------------------------
 arch/x86/kernel/smpcommon.c                |   56 ----------
 arch/x86/mach-voyager/voyager_smp.c        |   94 +++--------------
 arch/x86/xen/enlighten.c                   |    4 +-
 arch/x86/xen/smp.c                         |  133 +++++++++----------------
 arch/x86/xen/xen-ops.h                     |    9 +--
 include/asm-x86/hw_irq_32.h                |    1 +
 include/asm-x86/hw_irq_64.h                |    2 +
 include/asm-x86/mach-default/entry_arch.h  |    1 +
 include/asm-x86/mach-default/irq_vectors.h |    1 +
 include/asm-x86/mach-voyager/entry_arch.h  |    2 +-
 include/asm-x86/mach-voyager/irq_vectors.h |    4 +-
 include/asm-x86/smp.h                      |   19 ++--
 include/asm-x86/xen/events.h               |    1 +
 18 files changed, 124 insertions(+), 367 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcbec34..a617291 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -168,6 +168,7 @@ config GENERIC_PENDING_IRQ
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
+	select USE_GENERIC_SMP_HELPERS
 	default y
 
 config X86_32_SMP
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 4b99b1b..71017f7 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1358,6 +1358,10 @@ void __init smp_intr_init(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				call_function_single_interrupt);
 }
 #endif
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 556a8df..6d1fe27 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -711,6 +711,9 @@ END(invalidate_interrupt\num)
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
index fa57a15..00d2ccd 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -494,6 +494,10 @@ void __init native_init_IRQ(void)
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
+	/* IPI for generic single function call */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				call_function_single_interrupt);
+
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 0cb7aad..3e051ae 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -121,132 +121,33 @@ static void native_smp_send_reschedule(int cpu)
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
+void native_send_call_func_single_ipi(int cpu)
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
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
+	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * @mask: The set of cpus to run on.  Must not include the current cpu.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
-  * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-static int
-native_smp_call_function_mask(cpumask_t mask,
-			      void (*func)(void *), void *info,
-			      int wait)
+void native_send_call_func_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
 	cpumask_t allbutself;
-	int cpus;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
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
-	wmb();
-
-	/* Send a message to other CPUs */
 	if (cpus_equal(mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	spin_unlock(&call_lock);
-
-	return 0;
 }
 
 static void stop_this_cpu(void *dummy)
@@ -268,18 +169,13 @@ static void stop_this_cpu(void *dummy)
 
 static void native_smp_send_stop(void)
 {
-	int nolock;
 	unsigned long flags;
 
 	if (reboot_force)
 		return;
 
-	/* Don't deadlock on the call lock in panic */
-	nolock = !spin_trylock(&call_lock);
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
 	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
 	disable_local_APIC();
 	local_irq_restore(flags);
 }
@@ -301,33 +197,28 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 
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
+	generic_smp_call_function_interrupt();
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
 	add_pda(irq_call_count, 1);
 #endif
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
+	generic_smp_call_function_single_interrupt();
+#ifdef CONFIG_X86_32
+	__get_cpu_var(irq_stat).irq_call_count++;
+#else
+	add_pda(irq_call_count, 1);
+#endif
+	irq_exit();
 }
 
 struct smp_ops smp_ops = {
@@ -338,7 +229,8 @@ struct smp_ops smp_ops = {
 
 	.smp_send_stop = native_smp_send_stop,
 	.smp_send_reschedule = native_smp_send_reschedule,
-	.smp_call_function_mask = native_smp_call_function_mask,
+
+	.send_call_func_ipi = native_send_call_func_ipi,
+	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
-
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 3449064..99941b3 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -25,59 +25,3 @@ __cpuinit void init_gdt(int cpu)
 	per_cpu(cpu_number, cpu) = cpu;
 }
 #endif
-
-/**
- * smp_call_function(): Run a function on all other CPUs.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Unused.
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
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
-{
-	return smp_call_function_mask(cpu_online_map, func, info, wait);
-}
-EXPORT_SYMBOL(smp_call_function);
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
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 8acbf0c..cb34407 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -955,94 +955,24 @@ static void smp_stop_cpu_function(void *dummy)
 		halt();
 }
 
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	volatile unsigned long started;
-	volatile unsigned long finished;
-	int wait;
-};
-
-static struct call_data_struct *call_data;
-
 /* execute a thread on a new CPU.  The function to be called must be
  * previously set up.  This is used to schedule a function for
  * execution on all CPUs - set up the function then broadcast a
  * function_interrupt CPI to come here on each CPU */
 static void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	/* must take copy of wait because call_data may be replaced
-	 * unless the function is waiting for us to finish */
-	int wait = call_data->wait;
-	__u8 cpu = smp_processor_id();
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	if (!test_and_clear_bit(cpu, &call_data->started)) {
-		/* If the bit wasn't set, this could be a replay */
-		printk(KERN_WARNING "VOYAGER SMP: CPU %d received call funtion"
-		       " with no call pending\n", cpu);
-		return;
-	}
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func) (info);
+	generic_smp_call_function_interrupt();
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
-	if (wait) {
-		mb();
-		clear_bit(cpu, &call_data->finished);
-	}
 }
 
-static int
-voyager_smp_call_function_mask(cpumask_t cpumask,
-			       void (*func) (void *info), void *info, int wait)
+static void smp_call_function_single_interrupt(void)
 {
-	struct call_data_struct data;
-	u32 mask = cpus_addr(cpumask)[0];
-
-	mask &= ~(1 << smp_processor_id());
-
-	if (!mask)
-		return 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	data.started = mask;
-	data.wait = wait;
-	if (wait)
-		data.finished = mask;
-
-	spin_lock(&call_lock);
-	call_data = &data;
-	wmb();
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
-
-	/* Wait for response */
-	while (data.started)
-		barrier();
-
-	if (wait)
-		while (data.finished)
-			barrier();
-
-	spin_unlock(&call_lock);
-
-	return 0;
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	__get_cpu_var(irq_stat).irq_call_count++;
+	irq_exit();
 }
 
 /* Sorry about the name.  In an APIC based system, the APICs
@@ -1099,6 +1029,12 @@ void smp_qic_call_function_interrupt(struct pt_regs *regs)
 	smp_call_function_interrupt();
 }
 
+void smp_qic_call_function_single_interrupt(struct pt_regs *regs)
+{
+	ack_QIC_CPI(QIC_CALL_FUNCTION_SINGLE_CPI);
+	smp_call_function_single_interrupt();
+}
+
 void smp_vic_cpi_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
@@ -1119,6 +1055,8 @@ void smp_vic_cpi_interrupt(struct pt_regs *regs)
 		smp_enable_irq_interrupt();
 	if (test_and_clear_bit(VIC_CALL_FUNCTION_CPI, &vic_cpi_mailbox[cpu]))
 		smp_call_function_interrupt();
+	if (test_and_clear_bit(VIC_CALL_FUNCTION_SINGLE_CPI, &vic_cpi_mailbox[cpu]))
+		smp_call_function_single_interrupt();
 	set_irq_regs(old_regs);
 }
 
@@ -1862,5 +1800,7 @@ struct smp_ops smp_ops = {
 
 	.smp_send_stop = voyager_smp_send_stop,
 	.smp_send_reschedule = voyager_smp_send_reschedule,
-	.smp_call_function_mask = voyager_smp_call_function_mask,
+
+	.send_call_func_ipi = native_send_call_func_ipi,
+	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8a56e4..e045578 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1123,7 +1123,9 @@ static const struct smp_ops xen_smp_ops __initdata = {
 
 	.smp_send_stop = xen_smp_send_stop,
 	.smp_send_reschedule = xen_smp_send_reschedule,
-	.smp_call_function_mask = xen_smp_call_function_mask,
+
+	.send_call_func_ipi = xen_smp_send_call_function_ipi,
+	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
 };
 #endif	/* CONFIG_SMP */
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 94e6900..b3786e7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -36,27 +36,14 @@
 #include "mmu.h"
 
 static cpumask_t xen_cpu_initialized_map;
-static DEFINE_PER_CPU(int, resched_irq) = -1;
-static DEFINE_PER_CPU(int, callfunc_irq) = -1;
-static DEFINE_PER_CPU(int, debug_irq) = -1;
-
-/*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
 
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-};
+static DEFINE_PER_CPU(int, resched_irq);
+static DEFINE_PER_CPU(int, callfunc_irq);
+static DEFINE_PER_CPU(int, callfuncsingle_irq);
+static DEFINE_PER_CPU(int, debug_irq) = -1;
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
-
-static struct call_data_struct *call_data;
+static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
 
 /*
  * Reschedule call back. Nothing to do,
@@ -122,6 +109,17 @@ static int xen_smp_intr_init(unsigned int cpu)
 		goto fail;
 	per_cpu(debug_irq, cpu) = rc;
 
+	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
+	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
+				    cpu,
+				    xen_call_function_single_interrupt,
+				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    callfunc_name,
+				    NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(callfuncsingle_irq, cpu) = rc;
+
 	return 0;
 
  fail:
@@ -131,6 +129,9 @@ static int xen_smp_intr_init(unsigned int cpu)
 		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
 	if (per_cpu(debug_irq, cpu) >= 0)
 		unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
+	if (per_cpu(callfuncsingle_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
+
 	return rc;
 }
 
@@ -338,7 +339,6 @@ void xen_smp_send_reschedule(int cpu)
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-
 static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 {
 	unsigned cpu;
@@ -349,83 +349,42 @@ static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 		xen_send_IPI_one(cpu, vector);
 }
 
+void xen_smp_send_call_function_ipi(cpumask_t mask)
+{
+	int cpu;
+
+	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+
+	/* Make sure other vcpus get a chance to run if they need to. */
+	for_each_cpu_mask(cpu, mask) {
+		if (xen_vcpu_stolen(cpu)) {
+			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+			break;
+		}
+	}
+}
+
+void xen_smp_send_call_function_single_ipi(int cpu)
+{
+	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+}
+
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
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
+	generic_smp_call_function_interrupt();
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
 
-	if (wait) {
-		mb();		/* commit everything before setting finished */
-		atomic_inc(&call_data->finished);
-	}
-
 	return IRQ_HANDLED;
 }
 
-int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-			       void *info, int wait)
+static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 {
-	struct call_data_struct data;
-	int cpus, cpu;
-	bool yield;
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-
-	cpu_clear(smp_processor_id(), mask);
-
-	cpus = cpus_weight(mask);
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	mb();			/* write everything before IPI */
-
-	/* Send a message to other CPUs and wait for them to respond */
-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
-
-	/* Make sure other vcpus get a chance to run if they need to. */
-	yield = false;
-	for_each_cpu_mask(cpu, mask)
-		if (xen_vcpu_stolen(cpu))
-			yield = true;
-
-	if (yield)
-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus ||
-	       (wait && atomic_read(&data.finished) != cpus))
-		cpu_relax();
-
-	spin_unlock(&call_lock);
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	__get_cpu_var(irq_stat).irq_call_count++;
+	irq_exit();
 
-	return 0;
+	return IRQ_HANDLED;
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f1063ae..a636ab5 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -46,13 +46,8 @@ void xen_smp_cpus_done(unsigned int max_cpus);
 
 void xen_smp_send_stop(void);
 void xen_smp_send_reschedule(int cpu);
-int xen_smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			   int wait);
-int xen_smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-				 int nonatomic, int wait);
-
-int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-			       void *info, int wait);
+void xen_smp_send_call_function_ipi(cpumask_t mask);
+void xen_smp_send_call_function_single_ipi(int cpu);
 
 
 /* Declare an asm function, along with symbols needed to make it
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
diff --git a/include/asm-x86/hw_irq_64.h b/include/asm-x86/hw_irq_64.h
index 0062ef3..fe65781 100644
--- a/include/asm-x86/hw_irq_64.h
+++ b/include/asm-x86/hw_irq_64.h
@@ -68,6 +68,7 @@
 #define ERROR_APIC_VECTOR	0xfe
 #define RESCHEDULE_VECTOR	0xfd
 #define CALL_FUNCTION_VECTOR	0xfc
+#define	CALL_FUNCTION_SINGLE_VECTOR	0xfb
 /* fb free - please don't readd KDB here because it's useless
    (hint - think what a NMI bit does to a vector) */
 #define THERMAL_APIC_VECTOR	0xfa
@@ -102,6 +103,7 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
+void call_function_single_interrupt(void);
 void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
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
diff --git a/include/asm-x86/mach-voyager/entry_arch.h b/include/asm-x86/mach-voyager/entry_arch.h
index 4a1e1e8..ae52624 100644
--- a/include/asm-x86/mach-voyager/entry_arch.h
+++ b/include/asm-x86/mach-voyager/entry_arch.h
@@ -23,4 +23,4 @@ BUILD_INTERRUPT(qic_invalidate_interrupt, QIC_INVALIDATE_CPI);
 BUILD_INTERRUPT(qic_reschedule_interrupt, QIC_RESCHEDULE_CPI);
 BUILD_INTERRUPT(qic_enable_irq_interrupt, QIC_ENABLE_IRQ_CPI);
 BUILD_INTERRUPT(qic_call_function_interrupt, QIC_CALL_FUNCTION_CPI);
-
+BUILD_INTERRUPT(qic_call_function_single_interrupt, QIC_CALL_FUNCTION_SINGLE_CPI);
diff --git a/include/asm-x86/mach-voyager/irq_vectors.h b/include/asm-x86/mach-voyager/irq_vectors.h
index 165421f..64e47f6 100644
--- a/include/asm-x86/mach-voyager/irq_vectors.h
+++ b/include/asm-x86/mach-voyager/irq_vectors.h
@@ -33,6 +33,7 @@
 #define VIC_RESCHEDULE_CPI		4
 #define VIC_ENABLE_IRQ_CPI		5
 #define VIC_CALL_FUNCTION_CPI		6
+#define VIC_CALL_FUNCTION_SINGLE_CPI	7
 
 /* Now the QIC CPIs:  Since we don't need the two initial levels,
  * these are 2 less than the VIC CPIs */
@@ -42,9 +43,10 @@
 #define QIC_RESCHEDULE_CPI		(VIC_RESCHEDULE_CPI - QIC_CPI_OFFSET)
 #define QIC_ENABLE_IRQ_CPI		(VIC_ENABLE_IRQ_CPI - QIC_CPI_OFFSET)
 #define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_CPI - QIC_CPI_OFFSET)
+#define QIC_CALL_FUNCTION_CPI		(VIC_CALL_FUNCTION_SINGLE_CPI - QIC_CPI_OFFSET)
 
 #define VIC_START_FAKE_CPI		VIC_TIMER_CPI
-#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_CPI
+#define VIC_END_FAKE_CPI		VIC_CALL_FUNCTION_SINGLE_CPI
 
 /* this is the SYS_INT CPI. */
 #define VIC_SYS_INT			8
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 1ebaa5c..bba35a1 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -59,9 +59,9 @@ struct smp_ops {
 
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
-	int (*smp_call_function_mask)(cpumask_t mask,
-				      void (*func)(void *info), void *info,
-				      int wait);
+
+	void (*send_call_func_ipi)(cpumask_t mask);
+	void (*send_call_func_single_ipi)(int cpu);
 };
 
 /* Globals due to paravirt */
@@ -103,17 +103,22 @@ static inline void smp_send_reschedule(int cpu)
 	smp_ops.smp_send_reschedule(cpu);
 }
 
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
+static inline void arch_send_call_function_single_ipi(int cpu)
+{
+	smp_ops.send_call_func_single_ipi(cpu);
+}
+
+static inline void arch_send_call_function_ipi(cpumask_t mask)
 {
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+	smp_ops.send_call_func_ipi(mask);
 }
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
+void native_send_call_func_ipi(cpumask_t mask);
+void native_send_call_func_single_ipi(int cpu);
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
diff --git a/include/asm-x86/xen/events.h b/include/asm-x86/xen/events.h
index 596312a..f8d57ea 100644
--- a/include/asm-x86/xen/events.h
+++ b/include/asm-x86/xen/events.h
@@ -4,6 +4,7 @@
 enum ipi_vector {
 	XEN_RESCHEDULE_VECTOR,
 	XEN_CALL_FUNCTION_VECTOR,
+	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 
 	XEN_NR_IPIS,
 };
-- 
1.5.6.rc0.40.gd683

