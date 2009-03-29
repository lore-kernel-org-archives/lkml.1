Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZC2UW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZC2UW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZC2UVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41083 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZC2UVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Qtl+hGzc3Xx8/Oh17HqoKVnaFm8vPFIYMsJ5Tk52QfUsNjHgTpj+E6v8Yoe5sP5ril
         VcYYYOjBa54SbYrrBPUqL/YKuKWW/0yhl0zfVeFDtsA8tAul1rACJ8q9ocJSuJJRWt0l
         3dPzmnPlg+j0JAdGVOVed4gwT+7n30fpfuzC8=
Message-Id: <20090329202208.155551990@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/6] x86: irqinit - merge native_init_IRQ
References: <20090329201545.470255691@openvz.org>
Content-Disposition: inline; filename=x86-irqinit-native_init_IRQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this purpose init_ISA_irqs is called indirectly
by x86_quirk_pre_intr_init.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irqinit_32.c |    4 +++-
 arch/x86/kernel/irqinit_64.c |   22 +++++++++++++++++++++-
 arch/x86/kernel/setup.c      |    8 ++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
@@ -215,7 +215,7 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
-		/* SYSCALL_VECTOR was reserved in trap_init. */
+		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
 		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
@@ -229,6 +229,7 @@ void __init native_init_IRQ(void)
 	 */
 	x86_quirk_intr_init();
 
+#ifdef CONFIG_X86_32
 	/*
 	 * External FPU? Set up irq13 if so, for
 	 * original braindamaged IBM FERR coupling.
@@ -237,4 +238,5 @@ void __init native_init_IRQ(void)
 		setup_irq(FPU_IRQ, &fpu_irq);
 
 	irq_ctx_init(smp_processor_id());
+#endif
 }
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
@@ -21,6 +21,7 @@
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <asm/setup.h>
 #include <asm/i8259.h>
 
 /*
@@ -174,7 +175,8 @@ void __init native_init_IRQ(void)
 {
 	int i;
 
-	init_ISA_irqs();
+	/* Execute any quirks before the call gates are initialised: */
+	x86_quirk_pre_intr_init();
 
 	apic_intr_init();
 
@@ -185,10 +187,28 @@ void __init native_init_IRQ(void)
 	 */
 	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
+		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
 		if (!test_bit(vector, used_vectors))
 			set_intr_gate(vector, interrupt[i]);
 	}
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
+
+	/*
+	 * Call quirks after call gates are initialised (usually add in
+	 * the architecture specific gates):
+	 */
+	x86_quirk_intr_init();
+
+#ifdef CONFIG_X86_32
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
Index: linux-2.6.git/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup.c
+++ linux-2.6.git/arch/x86/kernel/setup.c
@@ -1087,3 +1087,11 @@ void __init x86_quirk_time_init(void)
 	setup_irq(0, &irq0);
 }
 #endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_X86_64
+void x86_quirk_pre_intr_init(void)
+{
+	init_ISA_irqs();
+}
+void x86_quirk_intr_init(void) { }
+#endif

