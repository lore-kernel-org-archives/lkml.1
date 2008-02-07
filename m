Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYBGJWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYBGJWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYBGJUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:12 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18501 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbYBGJUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:01 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/8] x86-64: add support for remotely triggering the block softirq
Date: Thu,  7 Feb 2008 10:19:02 +0100
Message-Id: <1202375945-29525-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/entry_64.S  |    3 +++
 arch/x86/kernel/i8259_64.c  |    3 +++
 arch/x86/kernel/smp_64.c    |   15 +++++++++++++++
 include/asm-x86/hw_irq_64.h |    2 ++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c7341e8..753834b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -704,6 +704,9 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
+ENTRY(raise_block_softirq)
+	apicinterrupt BLOCK_SOFTIRQ_VECTOR,smp_raise_block_softirq
+END(raise_block_softirq);
 ENTRY(irq_move_cleanup_interrupt)
 	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
 END(irq_move_cleanup_interrupt)
diff --git a/arch/x86/kernel/i8259_64.c b/arch/x86/kernel/i8259_64.c
index fa57a15..cd7675b 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -494,6 +494,9 @@ void __init native_init_IRQ(void)
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
+	/* IPI for raising block softirq on another CPU */
+	set_intr_gate(BLOCK_SOFTIRQ_VECTOR, raise_block_softirq);
+
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 2fd74b0..fe4c2bf 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -460,6 +460,21 @@ int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 }
 EXPORT_SYMBOL(smp_call_function);
 
+asmlinkage void smp_raise_block_softirq(void)
+{
+	unsigned long flags;
+
+	ack_APIC_irq();
+	local_irq_save(flags);
+	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+	local_irq_restore(flags);
+}
+
+void arch_raise_softirq_on_cpu(int cpu, unsigned int nr)
+{
+	send_IPI_mask(cpumask_of_cpu(cpu), BLOCK_SOFTIRQ_VECTOR);
+}
+
 static void stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
diff --git a/include/asm-x86/hw_irq_64.h b/include/asm-x86/hw_irq_64.h
index 312a58d..98ed167 100644
--- a/include/asm-x86/hw_irq_64.h
+++ b/include/asm-x86/hw_irq_64.h
@@ -68,6 +68,7 @@
 #define ERROR_APIC_VECTOR	0xfe
 #define RESCHEDULE_VECTOR	0xfd
 #define CALL_FUNCTION_VECTOR	0xfc
+#define BLOCK_SOFTIRQ_VECTOR	0xfb
 /* fb free - please don't readd KDB here because it's useless
    (hint - think what a NMI bit does to a vector) */
 #define THERMAL_APIC_VECTOR	0xfa
@@ -102,6 +103,7 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
+void raise_block_softirq(void);
 void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
-- 
1.5.4.22.g7a20

