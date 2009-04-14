Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZDNPyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZDNPyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZDNPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:52 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45967 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbZDNPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:49 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 09/14] [VOYAGER] x86: redo irq2 cascade setup
Date: Tue, 14 Apr 2009 10:51:35 -0500
Message-Id: <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cascade setup really needs to be done as part of the
arch_intr_init() because you might need the machine vectors all
plumbed in before you set up the cascade.

Fix this by moving the current check in irqinit_32.c to the correct
place and also directly calling the x86_quirk hook from there.  Tidy
up visws (and eventually voyager) which do their own irq2
initialisation but which could quite easily use the generic one.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/setup.h   |    1 -
 arch/x86/kernel/irqinit_32.c   |   15 +++++++++------
 arch/x86/kernel/setup.c        |   17 -----------------
 arch/x86/kernel/visws_quirks.c |    7 -------
 arch/x86/mach-voyager/setup.c  |   11 -----------
 5 files changed, 9 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index c4ff4ff..2b149d6 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -35,7 +35,6 @@ struct x86_quirks {
 };
 
 extern void x86_quirk_pre_intr_init(void);
-extern void x86_quirk_intr_init(void);
 
 extern void x86_quirk_trap_init(void);
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 368b0a8..bc8d528 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -186,14 +186,17 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
 
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
-
 	/*
-	 * Call quirks after call gates are initialised (usually add in
-	 * the architecture specific gates):
+	 * setup after call gates are initialised (usually add in the
+	 * architecture specific gates).  Populating the
+	 * arch_intr_init x86_quirk allows final gate setup.  If the
+	 * quirk returns true, the cascade interrupt will not be setup
+	 * unless acpi_ioapic is zero
 	 */
-	x86_quirk_intr_init();
+
+	if ((x86_quirks->arch_intr_init && !x86_quirks->arch_intr_init()) ||
+	    (!x86_quirks->arch_intr_init && !acpi_ioapic))
+		setup_irq(2, &irq2);
 
 	/*
 	 * External FPU? Set up irq13 if so, for
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 43f81f0..bee0914 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1011,23 +1011,6 @@ void __init x86_quirk_pre_intr_init(void)
 }
 
 /**
- * x86_quirk_intr_init - post gate setup interrupt initialisation
- *
- * Description:
- *	Fill in any interrupts that may have been left out by the general
- *	init_IRQ() routine.  interrupts having to do with the machine rather
- *	than the devices on the I/O bus (like APIC interrupts in intel MP
- *	systems) are started here.
- **/
-void __init x86_quirk_intr_init(void)
-{
-	if (x86_quirks->arch_intr_init) {
-		if (x86_quirks->arch_intr_init())
-			return;
-	}
-}
-
-/**
  * x86_quirk_trap_init - initialise system specific traps
  *
  * Description:
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 31ffc24..42de9eb 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -645,12 +645,6 @@ static struct irqaction master_action = {
 	.name =		"PIIX4-8259",
 };
 
-static struct irqaction cascade_action = {
-	.handler = 	no_action,
-	.name =		"cascade",
-};
-
-
 void init_VISWS_APIC_irqs(void)
 {
 	int i;
@@ -683,5 +677,4 @@ void init_VISWS_APIC_irqs(void)
 	}
 
 	setup_irq(CO_IRQ_8259, &master_action);
-	setup_irq(2, &cascade_action);
 }
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 88c3c55..e4516a8 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -16,22 +16,11 @@ void __init pre_intr_init_hook(void)
 	init_ISA_irqs();
 }
 
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
-
 void __init intr_init_hook(void)
 {
 #ifdef CONFIG_SMP
 	voyager_smp_intr_init();
 #endif
-
-	setup_irq(2, &irq2);
 }
 
 static void voyager_disable_tsc(void)
-- 
1.6.2.1

