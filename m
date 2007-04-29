Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXD2FWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXD2FWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 01:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXD2FWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 01:22:12 -0400
Received: from gw.goop.org ([64.81.55.164]:38694 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbXD2FWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 01:22:10 -0400
Message-ID: <46342B88.5050407@goop.org>
Date: Sat, 28 Apr 2007 22:22:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: move common parts of smp into their own file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Several parts of kernel/smp.c and smpboot.c are generally useful for
other subarchitectures and paravirt_ops implementations, so make them
available for reuse.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/kernel/Makefile    |    1 
 arch/i386/kernel/smp.c       |   65 +++-------------------------------
 arch/i386/kernel/smpboot.c   |   22 -----------
 arch/i386/kernel/smpcommon.c |   79 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/processor.h |    4 ++
 5 files changed, 90 insertions(+), 81 deletions(-)

===================================================================
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
===================================================================
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -468,7 +468,7 @@ void flush_tlb_all(void)
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
  */
-void native_smp_send_reschedule(int cpu)
+static void native_smp_send_reschedule(int cpu)
 {
 	WARN_ON(cpu_is_offline(cpu));
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
@@ -547,9 +547,10 @@ static void __smp_call_function(void (*f
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int native_smp_call_function_mask(cpumask_t mask,
-				  void (*func)(void *), void *info,
-				  int wait)
+static int
+native_smp_call_function_mask(cpumask_t mask,
+			      void (*func)(void *), void *info,
+			      int wait)
 {
 	struct call_data_struct data;
 	cpumask_t allbutself;
@@ -600,60 +601,6 @@ int native_smp_call_function_mask(cpumas
 	return 0;
 }
 
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
- * smp_call_function_single - Run a function on another CPU
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
-		WARN_ON(1);
-		put_cpu();
-		return -EBUSY;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
-
-	put_cpu();
-	return ret;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
 static void stop_this_cpu (void * dummy)
 {
 	local_irq_disable();
@@ -671,7 +618,7 @@ static void stop_this_cpu (void * dummy)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
-void native_smp_send_stop(void)
+static void native_smp_send_stop(void)
 {
 	/* Don't deadlock on the call lock in panic */
 	int nolock = !spin_trylock(&call_lock);
===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -99,9 +99,6 @@ EXPORT_SYMBOL(x86_cpu_to_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off);
-EXPORT_PER_CPU_SYMBOL(this_cpu_off);
-
 /*
  * Trampoline 80x86 program as an array.
  */
@@ -766,25 +763,6 @@ static inline struct task_struct * alloc
 #define alloc_idle_task(cpu) fork_idle(cpu)
 #endif
 
-/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
-   (still using the master per-cpu area), or a CPU doing it for a
-   secondary which will soon come up. */
-static __cpuinit void init_gdt(int cpu)
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
-/* Defined in head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static int __cpuinit do_boot_cpu(int apicid, int cpu)
 /*
  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
===================================================================
--- /dev/null
+++ b/arch/i386/kernel/smpcommon.c
@@ -0,0 +1,79 @@
+/*
+ * SMP stuff which is common to all sub-architectures.
+ */
+#include <linux/module.h>
+#include <asm/smp.h>
+
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
+
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
+ * smp_call_function_single - Run a function on another CPU
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
+		WARN_ON(1);
+		put_cpu();
+		return -EBUSY;
+	}
+
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
===================================================================
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -749,9 +749,13 @@ extern void enable_sep_cpu(void);
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
+/* Defined in head.S */
+extern struct Xgt_desc_struct early_gdt_descr;
+
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
 extern void cpu_init(void);
+extern void init_gdt(int cpu);
 
 extern int force_mwait;
 

