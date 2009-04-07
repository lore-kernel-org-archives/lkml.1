Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZDGSz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZDGSz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZDGSzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:55:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:41262 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZDGSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:55:06 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] x86: unify native_init_IRQ() in irqinit_{32,64}.c
Date: Tue,  7 Apr 2009 16:48:35 +0300
Message-Id: <1239112120-676-8-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |   53 +++++++++++++++++----------
 arch/x86/kernel/irqinit_64.c |   82 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 4488b71..a780de3 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -22,7 +22,7 @@
 #include <asm/i8259.h>
 #include <asm/traps.h>
 
-
+#ifdef CONFIG_X86_32
 /*
  * Note that on a 486, we don't want to do a SIGFPE on an irq13
  * as the irq is unreliable, and exception 16 works correctly
@@ -52,6 +52,7 @@ static struct irqaction fpu_irq = {
 	.handler = math_error_irq,
 	.name = "fpu",
 };
+#endif
 
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
@@ -155,24 +156,6 @@ static void __init smp_intr_init(void)
 #endif /* CONFIG_SMP */
 }
 
-/**
- * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
- *
- * Description:
- *	Perform any necessary interrupt initialisation prior to setting up
- *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
- *	interrupts should be initialised here if the machine emulates a PC
- *	in any way.
- **/
-static void __init x86_quirk_pre_intr_init(void)
-{
-	if (x86_quirks->arch_pre_intr_init) {
-		if (x86_quirks->arch_pre_intr_init())
-			return;
-	}
-	init_ISA_irqs();
-}
-
 static void __init apic_intr_init(void)
 {
 	smp_intr_init();
@@ -195,12 +178,36 @@ static void __init apic_intr_init(void)
 #endif
 }
 
+#ifdef CONFIG_X86_32
+/**
+ * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
+ *
+ * Description:
+ *	Perform any necessary interrupt initialisation prior to setting up
+ *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
+ *	interrupts should be initialised here if the machine emulates a PC
+ *	in any way.
+ **/
+static void __init x86_quirk_pre_intr_init(void)
+{
+	if (x86_quirks->arch_pre_intr_init) {
+		if (x86_quirks->arch_pre_intr_init())
+			return;
+	}
+	init_ISA_irqs();
+}
+#endif
+
 void __init native_init_IRQ(void)
 {
 	int i;
 
+#ifdef CONFIG_X86_32
 	/* Execute any quirks before the call gates are initialised: */
 	x86_quirk_pre_intr_init();
+#else
+	init_ISA_irqs();
+#endif
 
 	/*
 	 * Cover the whole vector space, no vector can escape
@@ -208,9 +215,15 @@ void __init native_init_IRQ(void)
 	 * 'special' SMP interrupts)
 	 */
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+#ifdef CONFIG_X86_32
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+#else
+		/* IA32_SYSCALL_VECTOR was reserved in trap_init. */
+		if (i != IA32_SYSCALL_VECTOR)
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+#endif
 	}
 
 	apic_intr_init();
@@ -218,6 +231,7 @@ void __init native_init_IRQ(void)
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Call quirks after call gates are initialised (usually add in
 	 * the architecture specific gates):
@@ -232,4 +246,5 @@ void __init native_init_IRQ(void)
 		setup_irq(FPU_IRQ, &fpu_irq);
 
 	irq_ctx_init(smp_processor_id());
+#endif
 }
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 61c9a92..ed50e35 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -39,14 +39,46 @@
  * (these are usually mapped into the 0x30-0xff vector range)
  */
 
+#ifdef CONFIG_X86_32
 /*
- * IRQ2 is cascade interrupt to second interrupt controller
+ * Note that on a 486, we don't want to do a SIGFPE on an irq13
+ * as the irq is unreliable, and exception 16 works correctly
+ * (ie as explained in the intel literature). On a 386, you
+ * can't use exception 16 due to bad IBM design, so we have to
+ * rely on the less exact irq13.
+ *
+ * Careful.. Not only is IRQ13 unreliable, but it is also
+ * leads to races. IBM designers who came up with it should
+ * be shot.
+ */
+
+static irqreturn_t math_error_irq(int cpl, void *dev_id)
+{
+	outb(0, 0xF0);
+	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
+		return IRQ_NONE;
+	math_error((void __user *)get_irq_regs()->ip);
+	return IRQ_HANDLED;
+}
+
+/*
+ * New motherboards sometimes make IRQ 13 be a PCI interrupt,
+ * so allow interrupt sharing.
  */
+static struct irqaction fpu_irq = {
+	.handler = math_error_irq,
+	.name = "fpu",
+};
+#endif
 
+/*
+ * IRQ2 is cascade interrupt to second interrupt controller
+ */
 static struct irqaction irq2 = {
 	.handler = no_action,
 	.name = "cascade",
 };
+
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[0 ... IRQ0_VECTOR - 1] = -1,
 	[IRQ0_VECTOR] = 0,
@@ -158,11 +190,36 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 }
 
+#ifdef CONFIG_X86_32
+/**
+ * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
+ *
+ * Description:
+ *	Perform any necessary interrupt initialisation prior to setting up
+ *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
+ *	interrupts should be initialised here if the machine emulates a PC
+ *	in any way.
+ **/
+static void __init x86_quirk_pre_intr_init(void)
+{
+	if (x86_quirks->arch_pre_intr_init) {
+		if (x86_quirks->arch_pre_intr_init())
+			return;
+	}
+	init_ISA_irqs();
+}
+#endif
+
 void __init native_init_IRQ(void)
 {
 	int i;
 
+#ifdef CONFIG_X86_32
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
+#else
 	init_ISA_irqs();
+#endif
 
 	/*
 	 * Cover the whole vector space, no vector can escape
@@ -170,13 +227,36 @@ void __init native_init_IRQ(void)
 	 * 'special' SMP interrupts)
 	 */
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+#ifdef CONFIG_X86_32
+		/* SYSCALL_VECTOR was reserved in trap_init. */
+		if (i != SYSCALL_VECTOR)
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+#else
 		/* IA32_SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != IA32_SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
+#endif
 	}
 
 	apic_intr_init();
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Call quirks after call gates are initialised (usually add in
+	 * the architecture specific gates):
+	 */
+	x86_quirk_intr_init();
+
+	/*
+	 * External FPU? Set up irq13 if so, for
+	 * original braindamaged IBM FERR coupling.
+	 */
+	if (boot_cpu_data.hard_math && !cpu_has_fpu)
+		setup_irq(FPU_IRQ, &fpu_irq);
+
+	irq_ctx_init(smp_processor_id());
+#endif
 }
-- 
1.5.6.3

