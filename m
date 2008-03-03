Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYCCRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYCCRV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbYCCRPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbYCCRPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:09 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 24/52] create smp.c
Date: Mon,  3 Mar 2008 14:12:52 -0300
Message-Id: <1204564400-17636-25-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-24-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch moves all the functions and data structures that look
like exactly the same from smp_{32,64}.c to smp.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile |    3 +-
 arch/x86/kernel/smp.c    |  253 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smp_32.c |  223 ----------------------------------------
 arch/x86/kernel/smp_64.c |  205 -------------------------------------
 4 files changed, 255 insertions(+), 429 deletions(-)
 create mode 100644 arch/x86/kernel/smp.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 018d04d..0a4b088 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -46,7 +46,8 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smpboot.o tsc_sync.o
+obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smp.o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
new file mode 100644
index 0000000..b662300
--- /dev/null
+++ b/arch/x86/kernel/smp.c
@@ -0,0 +1,253 @@
+#include <linux/init.h>
+
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/kernel_stat.h>
+#include <linux/mc146818rtc.h>
+#include <linux/cache.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+
+#include <asm/mtrr.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+#include <asm/proto.h>
+#ifdef CONFIG_X86_32
+#include <mach_apic.h>
+#include <mach_ipi.h>
+#else
+#include <asm/mach_apic.h>
+#endif
+
+/*
+ * this function sends a 'reschedule' IPI to another CPU.
+ * it goes straight through and wastes no time serializing
+ * anything. Worst case is that we lose a reschedule ...
+ */
+static void native_smp_send_reschedule(int cpu)
+{
+	WARN_ON(cpu_is_offline(cpu));
+	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+}
+
+/*
+ * Structure and data for smp_call_function(). This is designed to minimise
+ * static memory requirements. It also looks cleaner.
+ */
+static DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	atomic_t started;
+	atomic_t finished;
+	int wait;
+};
+
+void lock_ipi_call_lock(void)
+{
+	spin_lock_irq(&call_lock);
+}
+
+void unlock_ipi_call_lock(void)
+{
+	spin_unlock_irq(&call_lock);
+}
+
+static struct call_data_struct *call_data;
+
+static void __smp_call_function(void (*func) (void *info), void *info,
+				int nonatomic, int wait)
+{
+	struct call_data_struct data;
+	int cpus = num_online_cpus() - 1;
+
+	if (!cpus)
+		return;
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();
+
+	/* Send a message to all other CPUs and wait for them to respond */
+	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+}
+
+
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on.  Must not include the current cpu.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+  * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+static int
+native_smp_call_function_mask(cpumask_t mask,
+			      void (*func)(void *), void *info,
+			      int wait)
+{
+	struct call_data_struct data;
+	cpumask_t allbutself;
+	int cpus;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	wmb();
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	spin_unlock(&call_lock);
+
+	return 0;
+}
+
+static void stop_this_cpu(void *dummy)
+{
+	local_irq_disable();
+	/*
+	 * Remove this CPU:
+	 */
+	cpu_clear(smp_processor_id(), cpu_online_map);
+	disable_local_APIC();
+	if (hlt_works(smp_processor_id()))
+		for (;;) halt();
+	for (;;);
+}
+
+/*
+ * this function calls the 'stop' function on all other CPUs in the system.
+ */
+
+static void native_smp_send_stop(void)
+{
+	int nolock;
+	unsigned long flags;
+
+	if (reboot_force)
+		return;
+
+	/* Don't deadlock on the call lock in panic */
+	nolock = !spin_trylock(&call_lock);
+	local_irq_save(flags);
+	__smp_call_function(stop_this_cpu, NULL, 0, 0);
+	if (!nolock)
+		spin_unlock(&call_lock);
+	disable_local_APIC();
+	local_irq_restore(flags);
+}
+
+/*
+ * Reschedule call back. Nothing to do,
+ * all the work is done automatically when
+ * we return from the interrupt.
+ */
+void smp_reschedule_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+#ifdef CONFIG_X86_32
+	__get_cpu_var(irq_stat).irq_resched_count++;
+#else
+	add_pda(irq_resched_count, 1);
+#endif
+}
+
+void smp_call_function_interrupt(struct pt_regs *regs)
+{
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	int wait = call_data->wait;
+
+	ack_APIC_irq();
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	mb();
+	atomic_inc(&call_data->started);
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
+	irq_enter();
+	(*func)(info);
+#ifdef CONFIG_X86_32
+	__get_cpu_var(irq_stat).irq_call_count++;
+#else
+	add_pda(irq_call_count, 1);
+#endif
+	irq_exit();
+
+	if (wait) {
+		mb();
+		atomic_inc(&call_data->finished);
+	}
+}
+
+struct smp_ops smp_ops = {
+	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = native_smp_prepare_cpus,
+	.cpu_up = native_cpu_up,
+	.smp_cpus_done = native_smp_cpus_done,
+
+	.smp_send_stop = native_smp_send_stop,
+	.smp_send_reschedule = native_smp_send_reschedule,
+	.smp_call_function_mask = native_smp_call_function_mask,
+};
+EXPORT_SYMBOL_GPL(smp_ops);
+
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index 8be3e09..61e546e 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -466,217 +466,6 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
 }
 
-/*
- * this function sends a 'reschedule' IPI to another CPU.
- * it goes straight through and wastes no time serializing
- * anything. Worst case is that we lose a reschedule ...
- */
-static void native_smp_send_reschedule(int cpu)
-{
-	WARN_ON(cpu_is_offline(cpu));
-	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
-}
-
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
-void lock_ipi_call_lock(void)
-{
-	spin_lock_irq(&call_lock);
-}
-
-void unlock_ipi_call_lock(void)
-{
-	spin_unlock_irq(&call_lock);
-}
-
-static struct call_data_struct *call_data;
-
-static void __smp_call_function(void (*func) (void *info), void *info,
-				int nonatomic, int wait)
-{
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
-}
-
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
-{
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
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	spin_unlock(&call_lock);
-
-	return 0;
-}
-
-static void stop_this_cpu (void * dummy)
-{
-	local_irq_disable();
-	/*
-	 * Remove this CPU:
-	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
-	disable_local_APIC();
-	if (hlt_works(smp_processor_id()))
-		for(;;) halt();
-	for (;;);
-}
-
-/*
- * this function calls the 'stop' function on all other CPUs in the system.
- */
-
-static void native_smp_send_stop(void)
-{
-	int nolock;
-	unsigned long flags;
-
-	if (reboot_force)
-		return;
-
-	/* Don't deadlock on the call lock in panic */
-	nolock = !spin_trylock(&call_lock);
-	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
-	disable_local_APIC();
-	local_irq_restore(flags);
-}
-
-/*
- * Reschedule call back. Nothing to do,
- * all the work is done automatically when
- * we return from the interrupt.
- */
-void smp_reschedule_interrupt(struct pt_regs *regs)
-{
-	ack_APIC_irq();
-	__get_cpu_var(irq_stat).irq_resched_count++;
-}
-
-void smp_call_function_interrupt(struct pt_regs *regs)
-{
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	ack_APIC_irq();
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
-	irq_enter();
-	(*func)(info);
-	__get_cpu_var(irq_stat).irq_call_count++;
-	irq_exit();
-
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
-}
-
 static int convert_apicid_to_cpu(int apic_id)
 {
 	int i;
@@ -703,15 +492,3 @@ int safe_smp_processor_id(void)
 
 	return cpuid >= 0 ? cpuid : 0;
 }
-
-struct smp_ops smp_ops = {
-	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
-	.smp_prepare_cpus = native_smp_prepare_cpus,
-	.cpu_up = native_cpu_up,
-	.smp_cpus_done = native_smp_cpus_done,
-
-	.smp_send_stop = native_smp_send_stop,
-	.smp_send_reschedule = native_smp_send_reschedule,
-	.smp_call_function_mask = native_smp_call_function_mask,
-};
-EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index ad11ef0..d28e868 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -283,208 +283,3 @@ void flush_tlb_all(void)
 {
 	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
 }
-
-/*
- * this function sends a 'reschedule' IPI to another CPU.
- * it goes straight through and wastes no time serializing
- * anything. Worst case is that we lose a reschedule ...
- */
-
-static void native_smp_send_reschedule(int cpu)
-{
-	WARN_ON(cpu_is_offline(cpu));
-	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
-}
-
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
-void lock_ipi_call_lock(void)
-{
-	spin_lock_irq(&call_lock);
-}
-
-void unlock_ipi_call_lock(void)
-{
-	spin_unlock_irq(&call_lock);
-}
-
-static void __smp_call_function(void (*func) (void *info), void *info,
-				int nonatomic, int wait)
-{
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
-}
-
-
-int native_smp_call_function_mask(cpumask_t mask,
-				  void (*func)(void *), void *info,
-				  int wait)
-{
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
-
-	if (wait)
-		 while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-
-	spin_unlock(&call_lock);
-
-	return 0;
-}
-
-static void stop_this_cpu(void *dummy)
-{
-	local_irq_disable();
-	/*
-	 * Remove this CPU:
-	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
-	disable_local_APIC();
-	if (hlt_works(smp_processor_id()))
-		for (;;) halt();
-	for (;;);
-}
-
-void native_smp_send_stop(void)
-{
-	int nolock;
-	unsigned long flags;
-
-	if (reboot_force)
-		return;
-
-	/* Don't deadlock on the call lock in panic */
-	nolock = !spin_trylock(&call_lock);
-	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
-	if (!nolock)
-		spin_unlock(&call_lock);
-	disable_local_APIC();
-	local_irq_restore(flags);
-}
-
-/*
- * Reschedule call back. Nothing to do,
- * all the work is done automatically when
- * we return from the interrupt.
- */
-asmlinkage void smp_reschedule_interrupt(void)
-{
-	ack_APIC_irq();
-	add_pda(irq_resched_count, 1);
-}
-
-asmlinkage void smp_call_function_interrupt(void)
-{
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	ack_APIC_irq();
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
-	exit_idle();
-	irq_enter();
-	(*func)(info);
-	add_pda(irq_call_count, 1);
-	irq_exit();
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
-}
-
-struct smp_ops smp_ops = {
-	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
-	.smp_prepare_cpus = native_smp_prepare_cpus,
-	.smp_cpus_done = native_smp_cpus_done,
-
-	.smp_send_stop = native_smp_send_stop,
-	.smp_send_reschedule = native_smp_send_reschedule,
-	.smp_call_function_mask = native_smp_call_function_mask,
-	.cpu_up = native_cpu_up,
-};
-EXPORT_SYMBOL_GPL(smp_ops);
-- 
1.5.0.6

