Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZAYKjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZAYKjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 05:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZAYKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 05:39:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:59313 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbZAYKj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 05:39:27 -0500
Message-ID: <497C4111.8030904@kernel.org>
Date: Sun, 25 Jan 2009 02:38:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make irqinit_32.c more like irqoinit_64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

1. add smp_intr_init and apic_intr_init for 32bit the same as 64bit
2. move apic_intr_init() calling before set gate with interrupt[i]
3. for 64bit, if ia32_emulation is not used, will make per_cpu to use 0x80 vector.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/irqinit_32.c |   56 +++++++++++++++++++++++++------------------
 arch/x86/kernel/irqinit_64.c |    7 +++--
 arch/x86/kernel/traps.c      |   15 ++++-------
 3 files changed, 43 insertions(+), 35 deletions(-)

Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -120,28 +120,8 @@ int vector_used_by_percpu_irq(unsigned i
 	return 0;
 }
 
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
-void __init native_init_IRQ(void)
+static void __init smp_intr_init(void)
 {
-	int i;
-
-	/* all the set up before the call gates are initialised */
-	pre_intr_init_hook();
-
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-		/* SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
-	}
-
-
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
@@ -170,8 +150,13 @@ void __init native_init_IRQ(void)
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
+}
 
+static void __init apic_intr_init(void)
+{
 #ifdef CONFIG_X86_LOCAL_APIC
+	smp_intr_init();
+
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
@@ -181,12 +166,37 @@ void __init native_init_IRQ(void)
 # ifdef CONFIG_PERF_COUNTERS
 	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
 # endif
-#endif
 
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
+# ifdef CONFIG_X86_MCE_P4THERMAL
 	/* thermal monitor LVT interrupt */
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+# endif
 #endif
+}
+
+/* Overridden in paravirt.c */
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	/* all the set up before the call gates are initialised */
+	pre_intr_init_hook();
+
+	apic_intr_init();
+
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		/* SYSCALL_VECTOR was reserved in trap_init. */
+		if (test_bit(vector, used_vectors))
+			set_intr_gate(vector, interrupt[i]);
+	}
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -162,6 +162,9 @@ void __init native_init_IRQ(void)
 	int i;
 
 	init_ISA_irqs();
+
+	apic_intr_init();
+
 	/*
 	 * Cover the whole vector space, no vector can escape
 	 * us. (some of these will be overridden and become
@@ -169,12 +172,10 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
+		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
 
-	apic_intr_init();
-
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -984,8 +984,13 @@ void __init trap_init(void)
 #endif
 	set_intr_gate(19, &simd_coprocessor_error);
 
+	/* Reserve all the builtin and the syscall vector: */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+		set_bit(i, used_vectors);
+
 #ifdef CONFIG_IA32_EMULATION
 	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
 #endif
 
 #ifdef CONFIG_X86_32
@@ -1002,17 +1007,9 @@ void __init trap_init(void)
 	}
 
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
-#endif
-
-	/* Reserve all the builtin and the syscall vector: */
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
-		set_bit(i, used_vectors);
-
-#ifdef CONFIG_X86_64
-	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
-#else
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
+
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
