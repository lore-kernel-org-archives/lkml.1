Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbZGHWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbZGHWdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZGHWbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47050 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbZGHWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:42 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [4/8] x86: mce: Rename CONFIG_X86_NEW_MCE to CONFIG_X86_MCE
Message-Id: <20090708223141.1416E1D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Drop the CONFIG_X86_NEW_MCE symbol and change all 
references to it to check for CONFIG_X86_MCE directly.

No code changes

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig                    |   11 +++--------
 arch/x86/include/asm/entry_arch.h   |    2 +-
 arch/x86/kernel/apic/nmi.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile |    3 +--
 arch/x86/kernel/irq.c               |    4 ++--
 arch/x86/kernel/irqinit.c           |    2 +-
 arch/x86/kernel/signal.c            |    2 +-
 7 files changed, 10 insertions(+), 16 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -784,15 +784,10 @@ config X86_MCE
 	  The action the kernel takes depends on the severity of the problem,
 	  ranging from warning messages to halting the machine.
 
-config X86_NEW_MCE
-	depends on X86_MCE
-	bool
-	default y
-
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
-	depends on X86_NEW_MCE && X86_LOCAL_APIC
+	depends on X86_MCE && X86_LOCAL_APIC
 	---help---
 	   Additional support for intel specific MCE features such as
 	   the thermal monitor.
@@ -800,7 +795,7 @@ config X86_MCE_INTEL
 config X86_MCE_AMD
 	def_bool y
 	prompt "AMD MCE features"
-	depends on X86_NEW_MCE && X86_LOCAL_APIC
+	depends on X86_MCE && X86_LOCAL_APIC
 	---help---
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
@@ -820,7 +815,7 @@ config X86_MCE_THRESHOLD
 	default y
 
 config X86_MCE_INJECT
-	depends on X86_NEW_MCE
+	depends on X86_MCE
 	tristate "Machine check injector support"
 	---help---
 	  Provide support for injecting machine checks for testing purposes.
Index: linux/arch/x86/include/asm/entry_arch.h
===================================================================
--- linux.orig/arch/x86/include/asm/entry_arch.h
+++ linux/arch/x86/include/asm/entry_arch.h
@@ -61,7 +61,7 @@ BUILD_INTERRUPT(thermal_interrupt,THERMA
 BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_NEW_MCE
+#ifdef CONFIG_X86_MCE
 BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
 #endif
 
Index: linux/arch/x86/kernel/cpu/mcheck/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/Makefile
+++ linux/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,6 +1,5 @@
-obj-y				=  mce.o
+obj-y				=  mce.o mce-severity.o
 
-obj-$(CONFIG_X86_NEW_MCE)	+= mce-severity.o
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
Index: linux/arch/x86/kernel/apic/nmi.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/nmi.c
+++ linux/arch/x86/kernel/apic/nmi.c
@@ -66,7 +66,7 @@ static inline unsigned int get_nmi_count
 
 static inline int mce_in_progress(void)
 {
-#if defined(CONFIG_X86_NEW_MCE)
+#if defined(CONFIG_X86_MCE)
 	return atomic_read(&mce_entry) > 0;
 #endif
 	return 0;
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- linux.orig/arch/x86/kernel/irq.c
+++ linux/arch/x86/kernel/irq.c
@@ -104,7 +104,7 @@ static int show_other_interrupts(struct
 	seq_printf(p, "  Threshold APIC interrupts\n");
 # endif
 #endif
-#ifdef CONFIG_X86_NEW_MCE
+#ifdef CONFIG_X86_MCE
 	seq_printf(p, "%*s: ", prec, "MCE");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
@@ -200,7 +200,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_threshold_count;
 # endif
 #endif
-#ifdef CONFIG_X86_NEW_MCE
+#ifdef CONFIG_X86_MCE
 	sum += per_cpu(mce_exception_count, cpu);
 	sum += per_cpu(mce_poll_count, cpu);
 #endif
Index: linux/arch/x86/kernel/irqinit.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit.c
+++ linux/arch/x86/kernel/irqinit.c
@@ -190,7 +190,7 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
-#if defined(CONFIG_X86_NEW_MCE) && defined(CONFIG_X86_LOCAL_APIC)
+#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
 	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
 #endif
 
Index: linux/arch/x86/kernel/signal.c
===================================================================
--- linux.orig/arch/x86/kernel/signal.c
+++ linux/arch/x86/kernel/signal.c
@@ -856,7 +856,7 @@ static void do_signal(struct pt_regs *re
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-#ifdef CONFIG_X86_NEW_MCE
+#ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_process();
