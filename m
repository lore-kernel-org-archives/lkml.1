Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbZA2AUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbZA2AUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbZA1Xqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:53317 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828AbZA1Xqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:45 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 092/114] x86: replace CONFIG_X86_SMP with CONFIG_SMP
Date: Wed, 28 Jan 2009 23:42:38 +0000
Message-Id: <1233186180-29883-93-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86/Voyager subarch used to have this distinction between
 'x86 SMP support' and 'Voyager SMP support':

 config X86_SMP
	bool
	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)

This is a pointless distinction - Voyager can (and already does) use
smp_ops to implement various SMP quirks it has - and it can be extended
more to cover all the specialities of Voyager.

So remove this complication in the Kconfig space.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig                           |    7 +------
 arch/x86/Kconfig.debug                     |    2 +-
 arch/x86/include/asm/entry_arch.h          |    2 +-
 arch/x86/include/asm/hw_irq.h              |    2 +-
 arch/x86/kernel/Makefile                   |    4 ++--
 arch/x86/kernel/apic.c                     |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 +-
 arch/x86/kernel/process.c                  |    2 +-
 arch/x86/kernel/setup.c                    |    2 +-
 arch/x86/kernel/tsc.c                      |    2 +-
 arch/x86/kernel/vmiclock_32.c              |    2 +-
 arch/x86/mm/Makefile                       |    2 +-
 12 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8e6413e..3671506 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -173,11 +173,6 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
-config X86_SMP
-	bool
-	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
-	default y
-
 config USE_GENERIC_SMP_HELPERS
 	def_bool y
 	depends on SMP
@@ -203,7 +198,7 @@ config X86_BIOS_REBOOT
 
 config X86_TRAMPOLINE
 	bool
-	depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
+	depends on SMP || (64BIT && ACPI_SLEEP)
 	default y
 
 config KTIME_SCALAR
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 28f1114..a38dd60 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -83,7 +83,7 @@ config DEBUG_PAGEALLOC
 config DEBUG_PER_CPU_MAPS
 	bool "Debug access to per_cpu maps"
 	depends on DEBUG_KERNEL
-	depends on X86_SMP
+	depends on SMP
 	default n
 	help
 	  Say Y to verify that the per_cpu map being accessed has
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index b87b077..854d538 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -9,7 +9,7 @@
  * is no hardware IRQ pin equivalent for them, they are triggered
  * through the ICC by us (IPIs)
  */
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bfa921f..4155079 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -98,7 +98,7 @@ extern asmlinkage void qic_call_function_interrupt(void);
 extern void smp_apic_timer_interrupt(struct pt_regs *);
 extern void smp_spurious_interrupt(struct pt_regs *);
 extern void smp_error_interrupt(struct pt_regs *);
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 extern void smp_reschedule_interrupt(struct pt_regs *);
 extern void smp_call_function_interrupt(struct pt_regs *);
 extern void smp_call_function_single_interrupt(struct pt_regs *);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cea216f..1ab8e47 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -57,8 +57,8 @@ obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o
+obj-$(CONFIG_SMP)		+= smp.o
+obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o ipi.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 81efe86..968c817 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1900,7 +1900,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 #endif
 
-#if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
+#if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 4a48bb4..e48640c 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -69,7 +69,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
  */
 void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e68bb9e..89537f6 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -344,7 +344,7 @@ static void c1e_idle(void)
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 	if (pm_idle == poll_idle && smp_num_siblings > 1) {
 		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e645d47..eeb180b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -588,7 +588,7 @@ early_param("elfcorehdr", setup_elfcorehdr);
 
 static int __init default_update_genapic(void)
 {
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 	if (!apic->wakeup_cpu)
 		apic->wakeup_cpu = wakeup_secondary_cpu_via_init;
 #endif
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 599e581..83d53ce 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -773,7 +773,7 @@ __cpuinit int unsynchronized_tsc(void)
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
 
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 	if (apic_is_clustered_box())
 		return 1;
 #endif
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index c4c1f9e..a4791ef 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -256,7 +256,7 @@ void __devinit vmi_time_bsp_init(void)
 	 */
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	local_irq_disable();
-#ifdef CONFIG_X86_SMP
+#ifdef CONFIG_SMP
 	/*
 	 * XXX handle_percpu_irq only defined for SMP; we need to switch over
 	 * to using it, since this is a local interrupt, which each CPU must
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 9f05157..2b938a3 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,7 +1,7 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_X86_SMP)		+= tlb.o
+obj-$(CONFIG_SMP)		+= tlb.o
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
 
-- 
1.6.0.2

