Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYCCRU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYCCRU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbYCCRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489AbYCCRO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:59 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 17/52] create smpcommon.c
Date: Mon,  3 Mar 2008 14:12:45 -0300
Message-Id: <1204564400-17636-18-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-17-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates smpcommon.c with functions that are
equal between architectures. The i386-only init_gdt
is ifdef'd.

Note that smpcommon.o figures twice in the Makefile:
this is because sub-architectures like voyager that does
not use the normal smp_$(BITS) files also have to access them

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile       |    4 +-
 arch/x86/kernel/smp_64.c       |   56 ---------------------------
 arch/x86/kernel/smpcommon.c    |   83 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpcommon_32.c |   81 ---------------------------------------
 4 files changed, 85 insertions(+), 139 deletions(-)
 create mode 100644 arch/x86/kernel/smpcommon.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4c68bfc..018d04d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -47,8 +47,8 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smpboot.o tsc_sync.o
-obj-$(CONFIG_X86_32_SMP)	+= smpcommon_32.o
-obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o
+obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
+obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse_$(BITS).o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi_$(BITS).o
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index b040224..1d8b863 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -401,62 +401,6 @@ int native_smp_call_function_mask(cpumask_t mask,
 	return ret;
 }
 
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
 static void stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
new file mode 100644
index 0000000..3449064
--- /dev/null
+++ b/arch/x86/kernel/smpcommon.c
@@ -0,0 +1,83 @@
+/*
+ * SMP stuff which is common to all sub-architectures.
+ */
+#include <linux/module.h>
+#include <asm/smp.h>
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
+	pack_descriptor(&gdt[GDT_ENTRY_PERCPU],
+			__per_cpu_offset[cpu], 0xFFFFF,
+			0x2 | DESCTYPE_S, 0x8);
+
+	gdt[GDT_ENTRY_PERCPU].s = 1;
+
+	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
+	per_cpu(cpu_number, cpu) = cpu;
+}
+#endif
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
diff --git a/arch/x86/kernel/smpcommon_32.c b/arch/x86/kernel/smpcommon_32.c
index 8bc38af..8b13789 100644
--- a/arch/x86/kernel/smpcommon_32.c
+++ b/arch/x86/kernel/smpcommon_32.c
@@ -1,82 +1 @@
-/*
- * SMP stuff which is common to all sub-architectures.
- */
-#include <linux/module.h>
-#include <asm/smp.h>
 
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
-	pack_descriptor(&gdt[GDT_ENTRY_PERCPU],
-			__per_cpu_offset[cpu], 0xFFFFF,
-			0x2 | DESCTYPE_S, 0x8);
-
-	gdt[GDT_ENTRY_PERCPU].s = 1;
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
-- 
1.5.0.6

