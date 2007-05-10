Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbXEJF0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbXEJF0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbXEJF00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:26:26 -0400
Received: from ozlabs.org ([203.10.76.45]:49165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbXEJF0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:26:25 -0400
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 10 May 2007 15:25:57 +1000
Subject: [PATCH 1/3] powerpc: Fixup hard_irq_disable semantics
Message-Id: <20070510052620.EC36DDDF92@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the raw hard_irq_{enable,disable} into
__hard_irq_{enable,disable} and introduces a higher level
hard_irq_disable() function that can be used by any code
to enforce that IRQs are fully disabled, not only lazy
disabled.

The difference with the __ versions is that it will update
some per-processor fields so that the kernel keeps track and
properly re-enables them in the next local_irq_disable();

This prepares powerpc for my next patch that introduces
hard_irq_disable() generically.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 arch/powerpc/kernel/irq.c               |    2 +-
 arch/powerpc/kernel/swsusp.c            |    4 ----
 arch/powerpc/platforms/cell/pervasive.c |    6 ++----
 include/asm-powerpc/hw_irq.h            |   11 +++++++++--
 4 files changed, 12 insertions(+), 11 deletions(-)

Index: linux-cell/arch/powerpc/kernel/irq.c
===================================================================
--- linux-cell.orig/arch/powerpc/kernel/irq.c	2007-05-10 14:58:56.000000000 +1000
+++ linux-cell/arch/powerpc/kernel/irq.c	2007-05-10 14:58:59.000000000 +1000
@@ -173,7 +173,7 @@ void local_irq_restore(unsigned long en)
 		lv1_get_version_info(&tmp);
 	}
 
-	hard_irq_enable();
+	__hard_irq_enable();
 }
 #endif /* CONFIG_PPC64 */
 
Index: linux-cell/arch/powerpc/kernel/swsusp.c
===================================================================
--- linux-cell.orig/arch/powerpc/kernel/swsusp.c	2007-05-10 14:57:03.000000000 +1000
+++ linux-cell/arch/powerpc/kernel/swsusp.c	2007-05-10 14:57:07.000000000 +1000
@@ -36,8 +36,4 @@ void restore_processor_state(void)
 #ifdef CONFIG_PPC32
 	set_context(current->active_mm->context.id, current->active_mm->pgd);
 #endif
-
-#ifdef CONFIG_PPC64
-	hard_irq_enable();
-#endif
 }
Index: linux-cell/arch/powerpc/platforms/cell/pervasive.c
===================================================================
--- linux-cell.orig/arch/powerpc/platforms/cell/pervasive.c	2007-05-10 14:57:34.000000000 +1000
+++ linux-cell/arch/powerpc/platforms/cell/pervasive.c	2007-05-10 14:57:54.000000000 +1000
@@ -43,12 +43,10 @@ static void cbe_power_save(void)
 	unsigned long ctrl, thread_switch_control;
 
 	/*
-	 * We need to hard disable interrupts, but we also need to mark them
-	 * hard disabled in the PACA so that the local_irq_enable() done by
-	 * our caller upon return propertly hard enables.
+	 * We need to hard disable interrupts, the local_irq_enable() done by
+	 * our caller upon return will hard re-enable.
 	 */
 	hard_irq_disable();
-	get_paca()->hard_enabled = 0;
 
 	ctrl = mfspr(SPRN_CTRLF);
 
Index: linux-cell/include/asm-powerpc/hw_irq.h
===================================================================
--- linux-cell.orig/include/asm-powerpc/hw_irq.h	2007-05-10 14:51:43.000000000 +1000
+++ linux-cell/include/asm-powerpc/hw_irq.h	2007-05-10 14:59:32.000000000 +1000
@@ -48,8 +48,15 @@ extern void iseries_handle_interrupts(vo
 
 #define irqs_disabled()		(local_get_flags() == 0)
 
-#define hard_irq_enable()	__mtmsrd(mfmsr() | MSR_EE, 1)
-#define hard_irq_disable()	__mtmsrd(mfmsr() & ~MSR_EE, 1)
+#define __hard_irq_enable()	__mtmsrd(mfmsr() | MSR_EE, 1)
+#define __hard_irq_disable()	__mtmsrd(mfmsr() & ~MSR_EE, 1)
+
+#define  hard_irq_disable()			\
+	do {					\
+		__hard_irq_disable();		\
+		get_paca()->soft_enabled = 0;	\
+		get_paca()->hard_enabled = 0;	\
+	} while(0)
 
 #else
 
