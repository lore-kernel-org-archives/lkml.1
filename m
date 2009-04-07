Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZDGPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZDGPET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZDGPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:04:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:49176 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZDGPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:04:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] x86: move x86_quirk_pre_intr_init() to irqinit_32.c
Date: Tue,  7 Apr 2009 16:48:28 +0300
Message-Id: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In preparation for unifying irqinit_{32,64}.c, make
x86_quirk_pre_intr_init() local to irqinit_32.c.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/include/asm/i8259.h |    4 ----
 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/irqinit_32.c |   20 +++++++++++++++++++-
 arch/x86/kernel/setup.c      |   18 ------------------
 4 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 1a99e6c..58d7091 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -60,8 +60,4 @@ extern struct irq_chip i8259A_chip;
 extern void mask_8259A(void);
 extern void unmask_8259A(void);
 
-#ifdef CONFIG_X86_32
-extern void init_ISA_irqs(void);
-#endif
-
 #endif /* _ASM_X86_I8259_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index bdc2ada..4093d1e 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -33,7 +33,6 @@ struct x86_quirks {
 	int (*setup_ioapic_ids)(void);
 };
 
-extern void x86_quirk_pre_intr_init(void);
 extern void x86_quirk_intr_init(void);
 
 extern void x86_quirk_trap_init(void);
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 368b0a8..0c0dedc 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -53,7 +53,7 @@ static struct irqaction fpu_irq = {
 	.name = "fpu",
 };
 
-void __init init_ISA_irqs(void)
+static void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -121,6 +121,24 @@ int vector_used_by_percpu_irq(unsigned int vector)
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
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
+
 void __init native_init_IRQ(void)
 {
 	int i;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..523bb69 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -997,24 +997,6 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 
 /**
- * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
- *
- * Description:
- *	Perform any necessary interrupt initialisation prior to setting up
- *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
- *	interrupts should be initialised here if the machine emulates a PC
- *	in any way.
- **/
-void __init x86_quirk_pre_intr_init(void)
-{
-	if (x86_quirks->arch_pre_intr_init) {
-		if (x86_quirks->arch_pre_intr_init())
-			return;
-	}
-	init_ISA_irqs();
-}
-
-/**
  * x86_quirk_intr_init - post gate setup interrupt initialisation
  *
  * Description:
-- 
1.5.6.3

