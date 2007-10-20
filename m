Return-Path: <linux-kernel-owner+w=401wt.eu-S966827AbXJTBYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966827AbXJTBYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXJTBYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:24:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35716 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXJTBYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:24:23 -0400
Message-ID: <471958C4.8030903@ct.jp.nec.com>
Date: Fri, 19 Oct 2007 18:24:20 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com, hbabu@us.ibm.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 3/3] x86: unify crash_32/64.c
References: <47195763.1090803@ct.jp.nec.com>
In-Reply-To: <47195763.1090803@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Most of contents in crash are same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/Makefile_32 |    2 +-
 arch/x86/kernel/Makefile_64 |    2 +-
 arch/x86/kernel/crash.c     |  144 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/crash_32.c  |  137 ----------------------------------------
 arch/x86/kernel/crash_64.c  |  135 ----------------------------------------
 5 files changed, 146 insertions(+), 274 deletions(-)
 create mode 100644 arch/x86/kernel/crash.c
 delete mode 100644 arch/x86/kernel/crash_32.c
 delete mode 100644 arch/x86/kernel/crash_64.c

diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index ccea590..b9d6798 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -26,7 +26,7 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse_32.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_32.o nmi_32.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic_32.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec_32.o relocate_kernel_32.o crash_32.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec_32.o relocate_kernel_32.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_32.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index dec06e7..7b917d4 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -23,7 +23,7 @@ obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_SMP)		+= smp_64.o smpboot_64.o trampoline_64.o tsc_sync.o
 obj-y				+= apic_64.o  nmi_64.o
 obj-y				+= io_apic_64.o mpparse_64.o genapic_64.o genapic_flat_64.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec_64.o relocate_kernel_64.o crash_64.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec_64.o relocate_kernel_64.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_64.o
 obj-$(CONFIG_PM)		+= suspend_64.o
 obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
new file mode 100644
index 0000000..af0253f
--- /dev/null
+++ b/arch/x86/kernel/crash.c
@@ -0,0 +1,144 @@
+/*
+ * Architecture specific (i386/x86_64) functions for kexec based crash dumps.
+ *
+ * Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
+ *
+ * Copyright (C) IBM Corporation, 2004. All rights reserved.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/reboot.h>
+#include <linux/kexec.h>
+#include <linux/delay.h>
+#include <linux/elf.h>
+#include <linux/elfcore.h>
+
+#include <asm/processor.h>
+#include <asm/hardirq.h>
+#include <asm/nmi.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <linux/kdebug.h>
+#include <asm/smp.h>
+
+#ifdef X86_32
+#include <mach_ipi.h>
+#else
+#include <asm/mach_apic.h>
+#endif
+
+/* This keeps a track of which one is crashing cpu. */
+static int crashing_cpu;
+
+#if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
+static atomic_t waiting_for_crash_ipi;
+
+static int crash_nmi_callback(struct notifier_block *self,
+			unsigned long val, void *data)
+{
+	struct pt_regs *regs;
+#ifdef X86_32
+	struct pt_regs fixed_regs;
+#endif
+	int cpu;
+
+	if (val != DIE_NMI_IPI)
+		return NOTIFY_OK;
+
+	regs = ((struct die_args *)data)->regs;
+	cpu = raw_smp_processor_id();
+
+	/* Don't do anything if this handler is invoked on crashing cpu.
+	 * Otherwise, system will completely hang. Crashing cpu can get
+	 * an NMI if system was initially booted with nmi_watchdog parameter.
+	 */
+	if (cpu == crashing_cpu)
+		return NOTIFY_STOP;
+	local_irq_disable();
+
+#ifdef X86_32
+	if (!user_mode_vm(regs)) {
+		crash_fixup_ss_esp(&fixed_regs, regs);
+		regs = &fixed_regs;
+	}
+#endif
+	crash_save_cpu(regs, cpu);
+	disable_local_APIC();
+	atomic_dec(&waiting_for_crash_ipi);
+	/* Assume hlt works */
+	halt();
+	for (;;)
+		cpu_relax();
+
+	return 1;
+}
+
+static void smp_send_nmi_allbutself(void)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(safe_smp_processor_id(), mask);
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, NMI_VECTOR);
+}
+
+static struct notifier_block crash_nmi_nb = {
+	.notifier_call = crash_nmi_callback,
+};
+
+static void nmi_shootdown_cpus(void)
+{
+	unsigned long msecs;
+
+	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+	/* Would it be better to replace the trap vector here? */
+	if (register_die_notifier(&crash_nmi_nb))
+		return;		/* return what? */
+	/* Ensure the new callback function is set before sending
+	 * out the NMI
+	 */
+	wmb();
+
+	smp_send_nmi_allbutself();
+
+	msecs = 1000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+		mdelay(1);
+		msecs--;
+	}
+
+	/* Leave the nmi callback set */
+	disable_local_APIC();
+}
+#else
+static void nmi_shootdown_cpus(void)
+{
+	/* There are no cpus to shootdown */
+}
+#endif
+
+void machine_crash_shutdown(struct pt_regs *regs)
+{
+	/* This function is only called after the system
+	 * has panicked or is otherwise in a critical state.
+	 * The minimum amount of code to allow a kexec'd kernel
+	 * to run successfully needs to happen here.
+	 *
+	 * In practice this means shooting down the other cpus in
+	 * an SMP system.
+	 */
+	/* The kernel is broken so disable interrupts */
+	local_irq_disable();
+
+	/* Make a note of crashing cpu. Will be used in NMI callback.*/
+	crashing_cpu = safe_smp_processor_id();
+	nmi_shootdown_cpus();
+	lapic_shutdown();
+#if defined(CONFIG_X86_IO_APIC)
+	disable_IO_APIC();
+#endif
+	crash_save_cpu(regs, safe_smp_processor_id());
+}
diff --git a/arch/x86/kernel/crash_32.c b/arch/x86/kernel/crash_32.c
deleted file mode 100644
index 53589d1..0000000
--- a/arch/x86/kernel/crash_32.c
+++ /dev/null
@@ -1,137 +0,0 @@
-/*
- * Architecture specific (i386) functions for kexec based crash dumps.
- *
- * Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
- *
- * Copyright (C) IBM Corporation, 2004. All rights reserved.
- *
- */
-
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/reboot.h>
-#include <linux/kexec.h>
-#include <linux/delay.h>
-#include <linux/elf.h>
-#include <linux/elfcore.h>
-
-#include <asm/processor.h>
-#include <asm/hardirq.h>
-#include <asm/nmi.h>
-#include <asm/hw_irq.h>
-#include <asm/apic.h>
-#include <linux/kdebug.h>
-#include <asm/smp.h>
-
-#include <mach_ipi.h>
-
-
-/* This keeps a track of which one is crashing cpu. */
-static int crashing_cpu;
-
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
-static atomic_t waiting_for_crash_ipi;
-
-static int crash_nmi_callback(struct notifier_block *self,
-			unsigned long val, void *data)
-{
-	struct pt_regs *regs;
-	struct pt_regs fixed_regs;
-	int cpu;
-
-	if (val != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	regs = ((struct die_args *)data)->regs;
-	cpu = raw_smp_processor_id();
-
-	/* Don't do anything if this handler is invoked on crashing cpu.
-	 * Otherwise, system will completely hang. Crashing cpu can get
-	 * an NMI if system was initially booted with nmi_watchdog parameter.
-	 */
-	if (cpu == crashing_cpu)
-		return NOTIFY_STOP;
-	local_irq_disable();
-
-	if (!user_mode_vm(regs)) {
-		crash_fixup_ss_esp(&fixed_regs, regs);
-		regs = &fixed_regs;
-	}
-	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	halt();
-	for (;;)
-		cpu_relax();
-
-	return 1;
-}
-
-static void smp_send_nmi_allbutself(void)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(safe_smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, NMI_VECTOR);
-}
-
-static struct notifier_block crash_nmi_nb = {
-	.notifier_call = crash_nmi_callback,
-};
-
-static void nmi_shootdown_cpus(void)
-{
-	unsigned long msecs;
-
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
-	/* Would it be better to replace the trap vector here? */
-	if (register_die_notifier(&crash_nmi_nb))
-		return;		/* return what? */
-	/* Ensure the new callback function is set before sending
-	 * out the NMI
-	 */
-	wmb();
-
-	smp_send_nmi_allbutself();
-
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
-	}
-
-	/* Leave the nmi callback set */
-	disable_local_APIC();
-}
-#else
-static void nmi_shootdown_cpus(void)
-{
-	/* There are no cpus to shootdown */
-}
-#endif
-
-void machine_crash_shutdown(struct pt_regs *regs)
-{
-	/* This function is only called after the system
-	 * has panicked or is otherwise in a critical state.
-	 * The minimum amount of code to allow a kexec'd kernel
-	 * to run successfully needs to happen here.
-	 *
-	 * In practice this means shooting down the other cpus in
-	 * an SMP system.
-	 */
-	/* The kernel is broken so disable interrupts */
-	local_irq_disable();
-
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
-	crashing_cpu = safe_smp_processor_id();
-	nmi_shootdown_cpus();
-	lapic_shutdown();
-#if defined(CONFIG_X86_IO_APIC)
-	disable_IO_APIC();
-#endif
-	crash_save_cpu(regs, safe_smp_processor_id());
-}
diff --git a/arch/x86/kernel/crash_64.c b/arch/x86/kernel/crash_64.c
deleted file mode 100644
index 13432a1..0000000
--- a/arch/x86/kernel/crash_64.c
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * Architecture specific (x86_64) functions for kexec based crash dumps.
- *
- * Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
- *
- * Copyright (C) IBM Corporation, 2004. All rights reserved.
- *
- */
-
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/irq.h>
-#include <linux/reboot.h>
-#include <linux/kexec.h>
-#include <linux/delay.h>
-#include <linux/elf.h>
-#include <linux/elfcore.h>
-#include <linux/kdebug.h>
-
-#include <asm/processor.h>
-#include <asm/hardirq.h>
-#include <asm/nmi.h>
-#include <asm/hw_irq.h>
-#include <asm/mach_apic.h>
-
-/* This keeps a track of which one is crashing cpu. */
-static int crashing_cpu;
-
-#ifdef CONFIG_SMP
-static atomic_t waiting_for_crash_ipi;
-
-static int crash_nmi_callback(struct notifier_block *self,
-				unsigned long val, void *data)
-{
-	struct pt_regs *regs;
-	int cpu;
-
-	if (val != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	regs = ((struct die_args *)data)->regs;
-	cpu = raw_smp_processor_id();
-
-	/*
-	 * Don't do anything if this handler is invoked on crashing cpu.
-	 * Otherwise, system will completely hang. Crashing cpu can get
-	 * an NMI if system was initially booted with nmi_watchdog parameter.
-	 */
-	if (cpu == crashing_cpu)
-		return NOTIFY_STOP;
-	local_irq_disable();
-
-	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	for(;;)
-		halt();
-
-	return 1;
-}
-
-static void smp_send_nmi_allbutself(void)
-{
-	send_IPI_allbutself(NMI_VECTOR);
-}
-
-/*
- * This code is a best effort heuristic to get the
- * other cpus to stop executing. So races with
- * cpu hotplug shouldn't matter.
- */
-
-static struct notifier_block crash_nmi_nb = {
-	.notifier_call = crash_nmi_callback,
-};
-
-static void nmi_shootdown_cpus(void)
-{
-	unsigned long msecs;
-
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
-	if (register_die_notifier(&crash_nmi_nb))
-		return;         /* return what? */
-
-	/*
-	 * Ensure the new callback function is set before sending
-	 * out the NMI
-	 */
-	wmb();
-
-	smp_send_nmi_allbutself();
-
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
-	}
-	/* Leave the nmi callback set */
-	disable_local_APIC();
-}
-#else
-static void nmi_shootdown_cpus(void)
-{
-	/* There are no cpus to shootdown */
-}
-#endif
-
-void machine_crash_shutdown(struct pt_regs *regs)
-{
-	/*
-	 * This function is only called after the system
-	 * has panicked or is otherwise in a critical state.
-	 * The minimum amount of code to allow a kexec'd kernel
-	 * to run successfully needs to happen here.
-	 *
-	 * In practice this means shooting down the other cpus in
-	 * an SMP system.
-	 */
-	/* The kernel is broken so disable interrupts */
-	local_irq_disable();
-
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
-	crashing_cpu = smp_processor_id();
-	nmi_shootdown_cpus();
-
-	if(cpu_has_apic)
-		 disable_local_APIC();
-
-	disable_IO_APIC();
-
-	crash_save_cpu(regs, smp_processor_id());
-}
-- 
1.5.2.3

