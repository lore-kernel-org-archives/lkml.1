Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZC2UVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZC2UVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZC2UVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:35858 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZC2UVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=PafcU8J4U7S1MvfD0KcYhcLSsVZ6O22gSL/JSLFlEDAQw+TMS9XpIHIgFC5ZUVxmmX
         Wa4Vz02e96selu8wItfJHeye6xE0hX55MZy8O33/5JC9qhOXDpl6fgYcL9gPVOKRWlhg
         pf1HS0OiggqINWsb5rV0q56dlV7L5z8GqfLN8=
Message-Id: <20090329202207.737977988@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/6] x86: irqinit - order code snippets for easier merging
References: <20090329201545.470255691@openvz.org>
Content-Disposition: inline; filename=x86-irqinit-ordering
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In attempt of easier further merging of this files I've
order init_ISA_irqs function and a few comments as well.
The notable change is that init_ISA_irqs is not static
function on x86-64 anymore -- we will use arch quirks later.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irqinit_32.c |   27 +++++++++++++++++++-------
 arch/x86/kernel/irqinit_64.c |   44 +++++++++++++++++++++----------------------
 2 files changed, 42 insertions(+), 29 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
@@ -54,6 +54,10 @@ static struct irqaction fpu_irq = {
 	.name = "fpu",
 };
 
+/*
+ * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
+ * (these are usually mapped to vectors 0x30-0x3f)
+ */
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -63,9 +67,7 @@ void __init init_ISA_irqs(void)
 #endif
 	init_8259A(0);
 
-	/*
-	 * 16 old-style INTA-cycle interrupts:
-	 */
+	/* 16 old-style INTA-cycle interrupts */
 	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
@@ -74,11 +76,22 @@ void __init init_ISA_irqs(void)
 		desc->depth = 1;
 
 		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					      handle_level_irq, "XT");
+					handle_level_irq, "XT");
 	}
 }
 
 /*
+ * The IO-APIC gives us many more interrupt sources. Most of these
+ * are unused but an SMP system is supposed to have enough memory ...
+ * sometimes (mostly wrt. hw bugs) we get corrupted vectors all
+ * across the spectrum, so we really want to be prepared to get all
+ * of these. Plus, more powerful systems might have more than 64
+ * IO-APIC registers.
+ *
+ * (these are usually mapped into the 0x30-0xff vector range)
+ */
+
+/*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
 static struct irqaction irq2 = {
@@ -120,6 +133,9 @@ int vector_used_by_percpu_irq(unsigned i
 	return 0;
 }
 
+/* Overridden in paravirt.c */
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+
 static void __init smp_intr_init(void)
 {
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
@@ -177,9 +193,6 @@ static void __init apic_intr_init(void)
 #endif
 }
 
-/* Overridden in paravirt.c */
-void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
-
 void __init native_init_IRQ(void)
 {
 	int i;
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
@@ -27,6 +27,27 @@
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
  * (these are usually mapped to vectors 0x30-0x3f)
  */
+void __init init_ISA_irqs(void)
+{
+	int i;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	init_bsp_APIC();
+#endif
+	init_8259A(0);
+
+	/* 16 old-style INTA-cycle interrupts */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
+					handle_level_irq, "XT");
+	}
+}
 
 /*
  * The IO-APIC gives us many more interrupt sources. Most of these
@@ -81,28 +102,7 @@ int vector_used_by_percpu_irq(unsigned i
 	return 0;
 }
 
-static void __init init_ISA_irqs(void)
-{
-	int i;
-
-	init_bsp_APIC();
-	init_8259A(0);
-
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		/*
-		 * 16 old-style INTA-cycle interrupts:
-		 */
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-						      handle_level_irq, "XT");
-	}
-}
-
+/* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
 static void __init smp_intr_init(void)

