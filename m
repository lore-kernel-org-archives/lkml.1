Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYBGJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYBGJVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbYBGJUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:11 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18496 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbYBGJUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:01 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/8] x86: add support for remotely triggering the block softirq
Date: Thu,  7 Feb 2008 10:19:01 +0100
Message-Id: <1202375945-29525-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/x86/kernel/smp_32.c                   |   15 +++++++++++++++
 arch/x86/kernel/smpboot_32.c               |    3 +++
 include/asm-x86/hw_irq_32.h                |    1 +
 include/asm-x86/mach-default/entry_arch.h  |    1 +
 include/asm-x86/mach-default/irq_vectors.h |    1 +
 5 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dc0cde9..668b8a4 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -672,6 +672,21 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	}
 }
 
+fastcall void smp_raise_block_softirq(struct pt_regs *regs)
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
 static int convert_apicid_to_cpu(int apic_id)
 {
 	int i;
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 579b9b7..ca35697 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -1304,6 +1304,9 @@ void __init smp_intr_init(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for scheduling block softirq */
+	set_intr_gate(BLOCK_SOFTIRQ_VECTOR, raise_block_softirq);
 }
 
 /*
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index ea88054..0a053d8 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -32,6 +32,7 @@ extern void (*const interrupt[NR_IRQS])(void);
 void reschedule_interrupt(void);
 void invalidate_interrupt(void);
 void call_function_interrupt(void);
+void raise_block_softirq(void);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/include/asm-x86/mach-default/entry_arch.h b/include/asm-x86/mach-default/entry_arch.h
index bc86146..e96ed61 100644
--- a/include/asm-x86/mach-default/entry_arch.h
+++ b/include/asm-x86/mach-default/entry_arch.h
@@ -13,6 +13,7 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
+BUILD_INTERRUPT(raise_block_softirq,BLOCK_SOFTIRQ_VECTOR);
 #endif
 
 /*
diff --git a/include/asm-x86/mach-default/irq_vectors.h b/include/asm-x86/mach-default/irq_vectors.h
index 881c63c..f7535a3 100644
--- a/include/asm-x86/mach-default/irq_vectors.h
+++ b/include/asm-x86/mach-default/irq_vectors.h
@@ -48,6 +48,7 @@
 #define INVALIDATE_TLB_VECTOR	0xfd
 #define RESCHEDULE_VECTOR	0xfc
 #define CALL_FUNCTION_VECTOR	0xfb
+#define BLOCK_SOFTIRQ_VECTOR	0xfa
 
 #define THERMAL_APIC_VECTOR	0xf0
 /*
-- 
1.5.4.22.g7a20

