Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZDGRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZDGRiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZDGRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:38:07 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:46767 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZDGRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:38:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] x86: introduce smp_intr_init() in irqinit_32.c
Date: Tue,  7 Apr 2009 16:48:30 +0300
Message-Id: <1239112120-676-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |   61 ++++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index c5cb769..df0aad5 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -121,6 +121,38 @@ static void __init init_ISA_irqs(void)
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
+static void __init smp_intr_init(void)
+{
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+	/*
+	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
+	 * IPI, driven by wakeup.
+	 */
+	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+
+	/* IPIs for invalidation */
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
+
+	/* IPI for generic function call */
+	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				 call_function_single_interrupt);
+
+	/* Low priority IPI to cleanup after moving an irq */
+	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
+#endif
+}
+
 /**
  * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
  *
@@ -158,34 +190,7 @@ void __init native_init_IRQ(void)
 	}
 
 
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
-
-	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for single call function */
-	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				 call_function_single_interrupt);
-
-	/* Low priority IPI to cleanup after moving an irq */
-	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
-	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
-#endif
+	smp_intr_init();
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* self generated IPI for local APIC timer */
-- 
1.5.6.3

