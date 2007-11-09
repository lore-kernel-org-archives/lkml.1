Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbXKIVd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbXKIVd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbXKIV3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669AbXKIV3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:19 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/24] smp x86 consolidation
Date: Fri,  9 Nov 2007 16:42:46 -0200
Message-Id: <1194633815833-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338103068-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates part of the pieces of smp for both architectures.
(i386 and x86_64). It makes part the calls go through smp_ops, and shares
code for those functions in smpcommon.c

There's more room for code sharing here, but it is left as an exercise to
the reader ;-)

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/Makefile_32    |    2 +-
 arch/x86/kernel/Makefile_64    |    2 +-
 arch/x86/kernel/smp_32.c       |  218 ------------------------------
 arch/x86/kernel/smp_64.c       |  245 ---------------------------------
 arch/x86/kernel/smpboot_64.c   |    8 +-
 arch/x86/kernel/smpcommon.c    |  291 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpcommon_32.c |   81 -----------
 include/asm-x86/idle.h         |   18 +++-
 include/asm-x86/smp.h          |   66 +++++++++
 include/asm-x86/smp_32.h       |   58 --------
 include/asm-x86/smp_64.h       |    4 -
 11 files changed, 379 insertions(+), 614 deletions(-)

diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index b08179a..b0da543 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -20,7 +20,7 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 obj-$(CONFIG_APM)		+= apm_32.o
 obj-$(CONFIG_X86_SMP)		+= smp_32.o smpboot_32.o tsc_sync.o
-obj-$(CONFIG_SMP)		+= smpcommon_32.o
+obj-$(CONFIG_SMP)		+= smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_32.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse_32.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_32.o nmi_32.o
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 686de84..ffee997 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -17,7 +17,7 @@ obj-y				+= acpi/
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_SMP)		+= smp_64.o smpboot_64.o trampoline_64.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smp_64.o smpboot_64.o trampoline_64.o tsc_sync.o smpcommon.o
 obj-y				+= apic_64.o  nmi_64.o
 obj-y				+= io_apic_64.o mpparse_64.o genapic_64.o genapic_flat_64.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_64.o relocate_kernel_64.o crash.o
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index fcaa026..a7cc319 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -464,213 +464,6 @@ void flush_tlb_all(void)
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
-	mb();
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
-	if (cpu_data(smp_processor_id()).hlt_works_ok)
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
-	/* Don't deadlock on the call lock in panic */
-	int nolock = !spin_trylock(&call_lock);
-	unsigned long flags;
-
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
-fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
-{
-	ack_APIC_irq();
-	__get_cpu_var(irq_stat).irq_resched_count++;
-}
-
-fastcall void smp_call_function_interrupt(struct pt_regs *regs)
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
@@ -698,14 +491,3 @@ int safe_smp_processor_id(void)
 	return cpuid >= 0 ? cpuid : 0;
 }
 
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
index ce3935b..c19c68b 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -283,248 +283,3 @@ void flush_tlb_all(void)
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
-void smp_send_reschedule(int cpu)
-{
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
-/*
- * this function sends a 'generic call function' IPI to all other CPU
- * of the system defined in the mask.
- */
-static int __smp_call_function_mask(cpumask_t mask,
-				    void (*func)(void *), void *info,
-				    int wait)
-{
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
-
-	if (!wait)
-		return 0;
-
-	while (atomic_read(&data.finished) != cpus)
-		cpu_relax();
-
-	return 0;
-}
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
-
-	spin_lock(&call_lock);
-	ret = __smp_call_function_mask(mask, func, info, wait);
-	spin_unlock(&call_lock);
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_mask);
-
-/*
- * smp_call_function_single - Run a function on a specific CPU
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Currently unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Retrurns 0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
- */
-
-int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
-			      int nonatomic, int wait)
-{
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
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
-
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
-/*
- * smp_call_function - run a function on all other CPUs.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: currently unused.
- * @wait: If true, wait (atomically) until function has completed on other
- *        CPUs.
- *
- * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute func or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- * Actually there are a few legal cases, like panic.
- */
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
-{
-	return smp_call_function_mask(cpu_online_map, func, info, wait);
-}
-EXPORT_SYMBOL(smp_call_function);
-
-static void stop_this_cpu(void *dummy)
-{
-	local_irq_disable();
-	/*
-	 * Remove this CPU:
-	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
-	disable_local_APIC();
-	for (;;)
-		halt();
-}
-
-void smp_send_stop(void)
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
-	__smp_call_function_mask(cpu_online_map, stop_this_cpu, NULL, 0);
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
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 6f3e63c..17e54fa 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -864,7 +864,7 @@ void __init smp_set_apicids(void)
  * Prepare for SMP bootup.  The MP table or ACPI has been read
  * earlier.  Just do some sanity checking here and enable APIC mode.
  */
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	nmi_watchdog_default();
 	current_cpu_data = boot_cpu_data;
@@ -908,7 +908,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 /*
  * Early setup to make printk work.
  */
-void __init smp_prepare_boot_cpu(void)
+void __init native_smp_prepare_boot_cpu(void)
 {
 	int me = smp_processor_id();
 	cpu_set(me, cpu_online_map);
@@ -919,7 +919,7 @@ void __init smp_prepare_boot_cpu(void)
 /*
  * Entry point to boot a CPU.
  */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	int apicid = cpu_present_to_apicid(cpu);
 	unsigned long flags;
@@ -977,7 +977,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 /*
  * Finish the SMP boot.
  */
-void __init smp_cpus_done(unsigned int max_cpus)
+void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	smp_cleanup_boot();
 	setup_ioapic_dest();
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
new file mode 100644
index 0000000..e3bee40
--- /dev/null
+++ b/arch/x86/kernel/smpcommon.c
@@ -0,0 +1,291 @@
+/*
+ * SMP stuff which is common to all sub-architectures.
+ */
+#include <linux/cpu.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+
+#include <asm/mach_apic.h>
+#include <asm/proto.h>
+#include <asm/apicdef.h>
+#include <asm/smp.h>
+#include <asm/idle.h>
+
+#ifdef CONFIG_X86_32
+DEFINE_PER_CPU(unsigned long, this_cpu_off);
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
+
+/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
+   (still using the master per-cpu area), or a CPU doing it for a
+   secondary which will soon come up. */
+__cpuinit void init_gdt(int cpu)
+{
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+
+	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
+			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
+			__per_cpu_offset[cpu], 0xFFFFF,
+			0x80 | DESCTYPE_S | 0x2, 0x8);
+
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
+}
+#endif
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
+static struct call_data_struct * call_data;
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
+	mb();
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
+/**
+ * smp_call_function(): Run a function on all other CPUs.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Unused.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+		      int wait)
+{
+	return smp_call_function_mask(cpu_online_map, func, info, wait);
+}
+EXPORT_SYMBOL(smp_call_function);
+
+/**
+ * smp_call_function_single - Run a function on a specific CPU
+ * @cpu: The target CPU.  Cannot be the calling CPU.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Unused.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int nonatomic, int wait)
+{
+	/* prevent preemption and reschedule on another processor */
+	int ret;
+	int me = get_cpu();
+	if (cpu == me) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+		put_cpu();
+		return 0;
+	}
+
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
+
+static void stop_this_cpu(void *dummy)
+{
+	local_irq_disable();
+	/*
+	 * Remove this CPU:
+	 */
+	cpu_clear(smp_processor_id(), cpu_online_map);
+	disable_local_APIC();
+#ifdef CONFIG_X86_32
+	if (cpu_data(smp_processor_id()).hlt_works_ok)
+#endif
+	for (;;)
+		halt();
+	for (;;);
+}
+
+void native_smp_send_stop(void)
+{
+	int nolock;
+	unsigned long flags;
+
+#ifdef CONFIG_X86_64
+	if (reboot_force)
+		return;
+#endif
+
+	/* Don't deadlock on the call lock in panic */
+	nolock = !spin_trylock(&call_lock);
+	local_irq_save(flags);
+	smp_call_function(stop_this_cpu, NULL, 0, 0);
+	if (!nolock)
+		spin_unlock(&call_lock);
+	disable_local_APIC();
+	local_irq_restore(flags);
+}
+
+asmlinkage void smp_call_function_interrupt(void)
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
+	exit_idle();
+	irq_enter();
+	(*func)(info);
+	/* FIXME: Put this thing in the same place for both arches */
+#ifdef CONFIG_X86_64
+	add_pda(irq_call_count, 1);
+#else
+	__get_cpu_var(irq_stat).irq_call_count++;
+#endif
+	irq_exit();
+	if (wait) {
+		mb();
+		atomic_inc(&call_data->finished);
+	}
+}
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
+ * Reschedule call back. Nothing to do,
+ * all the work is done automatically when
+ * we return from the interrupt.
+ */
+asmlinkage void smp_reschedule_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	/* FIXME: Put this thing in the same place for both arches */
+#ifdef CONFIG_X86_64
+	add_pda(irq_call_count, 1);
+#else
+	__get_cpu_var(irq_stat).irq_resched_count++;
+#endif
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
+EXPORT_SYMBOL(smp_ops);
diff --git a/arch/x86/kernel/smpcommon_32.c b/arch/x86/kernel/smpcommon_32.c
deleted file mode 100644
index bbfe85a..0000000
--- a/arch/x86/kernel/smpcommon_32.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * SMP stuff which is common to all sub-architectures.
- */
-#include <linux/module.h>
-#include <asm/smp.h>
-
-DEFINE_PER_CPU(unsigned long, this_cpu_off);
-EXPORT_PER_CPU_SYMBOL(this_cpu_off);
-
-/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
-   (still using the master per-cpu area), or a CPU doing it for a
-   secondary which will soon come up. */
-__cpuinit void init_gdt(int cpu)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-
-	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
-			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
-			__per_cpu_offset[cpu], 0xFFFFF,
-			0x80 | DESCTYPE_S | 0x2, 0x8);
-
-	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
-	per_cpu(cpu_number, cpu) = cpu;
-}
-
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
diff --git a/include/asm-x86/idle.h b/include/asm-x86/idle.h
index d240e5b..487bca1 100644
--- a/include/asm-x86/idle.h
+++ b/include/asm-x86/idle.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_64_IDLE_H
-#define _ASM_X86_64_IDLE_H 1
+#ifndef _ASM_X86_IDLE_H
+#define _ASM_X86_IDLE_H 1
 
 #define IDLE_START 1
 #define IDLE_END 2
@@ -7,7 +7,21 @@
 struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
 
+#ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
+#else
+/*
+ * i386 does not really uses it, but define them here so we can avoid ifdefs in
+ * shared locations that uses it
+ */
+static inline void enter_idle(void)
+{
+}
+static inline void exit_idle(void)
+{
+}
+#endif
+
 
 #endif
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index f2e8319..b2f99df 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -1,5 +1,71 @@
+#ifndef _X86_SMP_H_
+#define _X86_SMP_H_
+
+#ifndef __ASSEMBLY__
+struct smp_ops
+{
+	void (*smp_prepare_boot_cpu)(void);
+	void (*smp_prepare_cpus)(unsigned max_cpus);
+	int (*cpu_up)(unsigned cpu);
+	void (*smp_cpus_done)(unsigned max_cpus);
+
+	void (*smp_send_stop)(void);
+	void (*smp_send_reschedule)(int cpu);
+	int (*smp_call_function_mask)(cpumask_t mask,
+				      void (*func)(void *info), void *info,
+				      int wait);
+};
+
+extern struct smp_ops smp_ops;
+
+static inline void smp_prepare_boot_cpu(void)
+{
+	smp_ops.smp_prepare_boot_cpu();
+}
+static inline void smp_prepare_cpus(unsigned int max_cpus)
+{
+	smp_ops.smp_prepare_cpus(max_cpus);
+}
+static inline int __cpu_up(unsigned int cpu)
+{
+	return smp_ops.cpu_up(cpu);
+}
+static inline void smp_cpus_done(unsigned int max_cpus)
+{
+	smp_ops.smp_cpus_done(max_cpus);
+}
+
+static inline void smp_send_stop(void)
+{
+	smp_ops.smp_send_stop();
+}
+static inline void smp_send_reschedule(int cpu)
+{
+	smp_ops.smp_send_reschedule(cpu);
+}
+
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info),
+					 void *info, int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
+
+void native_smp_prepare_boot_cpu(void);
+void native_smp_prepare_cpus(unsigned int max_cpus);
+int native_cpu_up(unsigned int cpunum);
+void native_smp_cpus_done(unsigned int max_cpus);
+
+#ifndef CONFIG_PARAVIRT
+#define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
+do { } while (0)
+#endif
+#endif /* __ASSEMBLY__ */
+
 #ifdef CONFIG_X86_32
 # include "smp_32.h"
 #else
 # include "smp_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index e10b7af..a53b03f 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -53,64 +53,6 @@ extern void cpu_uninit(void);
 extern void remove_siblinginfo(int cpu);
 #endif
 
-struct smp_ops
-{
-	void (*smp_prepare_boot_cpu)(void);
-	void (*smp_prepare_cpus)(unsigned max_cpus);
-	int (*cpu_up)(unsigned cpu);
-	void (*smp_cpus_done)(unsigned max_cpus);
-
-	void (*smp_send_stop)(void);
-	void (*smp_send_reschedule)(int cpu);
-	int (*smp_call_function_mask)(cpumask_t mask,
-				      void (*func)(void *info), void *info,
-				      int wait);
-};
-
-extern struct smp_ops smp_ops;
-
-static inline void smp_prepare_boot_cpu(void)
-{
-	smp_ops.smp_prepare_boot_cpu();
-}
-static inline void smp_prepare_cpus(unsigned int max_cpus)
-{
-	smp_ops.smp_prepare_cpus(max_cpus);
-}
-static inline int __cpu_up(unsigned int cpu)
-{
-	return smp_ops.cpu_up(cpu);
-}
-static inline void smp_cpus_done(unsigned int max_cpus)
-{
-	smp_ops.smp_cpus_done(max_cpus);
-}
-
-static inline void smp_send_stop(void)
-{
-	smp_ops.smp_send_stop();
-}
-static inline void smp_send_reschedule(int cpu)
-{
-	smp_ops.smp_send_reschedule(cpu);
-}
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
-
-void native_smp_prepare_boot_cpu(void);
-void native_smp_prepare_cpus(unsigned int max_cpus);
-int native_cpu_up(unsigned int cpunum);
-void native_smp_cpus_done(unsigned int max_cpus);
-
-#ifndef CONFIG_PARAVIRT
-#define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
-do { } while (0)
-#endif
-
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
  * from the initial startup. We map APIC_BASE very early in page_setup(),
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index ab612b0..279ff92 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -36,9 +36,6 @@ extern volatile unsigned long smp_invalidate_needed;
 extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
 extern int smp_num_siblings;
-extern void smp_send_reschedule(int cpu);
-extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-				  void *info, int wait);
 
 /*
  * cpu_sibling_map and cpu_core_map now live
@@ -127,4 +124,3 @@ extern unsigned int boot_cpu_id;
 #define cpu_physical_id(cpu)		boot_cpu_id
 #endif /* !CONFIG_SMP */
 #endif
-
-- 
1.4.4.2

