Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZDGS4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZDGS4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZDGS4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:56:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:43536 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbZDGS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:56:07 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] x86: unify smp_intr_init() in irqinit_{32,64}.h
Date: Tue,  7 Apr 2009 16:48:33 +0300
Message-Id: <1239112120-676-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |    8 +++++---
 arch/x86/kernel/irqinit_64.c |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 1029a18..ef2528d 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -123,7 +123,8 @@ void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
 static void __init smp_intr_init(void)
 {
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -143,14 +144,15 @@ static void __init smp_intr_init(void)
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
-	/* IPI for single call function */
+	/* IPI for generic single function call */
 	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				 call_function_single_interrupt);
+			call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
+#endif /* CONFIG_SMP */
 }
 
 /**
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 1c8858b..9e7c57d 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -107,6 +107,7 @@ void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -134,6 +135,7 @@ static void __init smp_intr_init(void)
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
+#endif /* CONFIG_SMP */
 }
 
 static void __init apic_intr_init(void)
-- 
1.5.6.3

