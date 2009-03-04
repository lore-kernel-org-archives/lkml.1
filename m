Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZCDTtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZCDTtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZCDTtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:49:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:44727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbZCDTtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:49:10 -0500
Date: Wed, 4 Mar 2009 19:48:34 GMT
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, johnstul@us.ibm.com, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20090304185605.GA24419@sgi.com>
References: <20090304185605.GA24419@sgi.com>
Subject: [tip:x86/uv] x86: UV, SGI RTC: add generic system vector
Message-ID: <tip-acaabe795a62bba089c185917af86b44654313dc@git.kernel.org>
Git-Commit-ID: acaabe795a62bba089c185917af86b44654313dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 19:48:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acaabe795a62bba089c185917af86b44654313dc
Gitweb:     http://git.kernel.org/tip/acaabe795a62bba089c185917af86b44654313dc
Author:     "Dimitri Sivanich" <sivanich@sgi.com>
AuthorDate: Wed, 4 Mar 2009 12:56:05 -0600
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:25:37 +0100

x86: UV, SGI RTC: add generic system vector

This patch allocates a system interrupt vector for various platform
specific uses.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>
LKML-Reference: <20090304185605.GA24419@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/entry_arch.h  |    2 ++
 arch/x86/include/asm/hardirq.h     |    1 +
 arch/x86/include/asm/hw_irq.h      |    1 +
 arch/x86/include/asm/irq.h         |    1 +
 arch/x86/include/asm/irq_vectors.h |    5 +++++
 arch/x86/kernel/entry_64.S         |    2 ++
 arch/x86/kernel/irq.c              |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irqinit_32.c       |    3 +++
 arch/x86/kernel/irqinit_64.c       |    3 +++
 9 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 854d538..c2e6bed 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -33,6 +33,8 @@ BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
 		 smp_invalidate_interrupt)
 #endif
 
+BUILD_INTERRUPT(generic_interrupt, GENERIC_INTERRUPT_VECTOR)
+
 /*
  * every pentium local APIC has two 'local interrupts', with a
  * soft-definable vector attached to both interrupts, one of
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 176f058..039db6a 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -12,6 +12,7 @@ typedef struct {
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
 #endif
+	unsigned int generic_irqs;	/* arch dependent */
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 370e1c8..b762ea4 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -27,6 +27,7 @@
 
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
+extern void generic_interrupt(void);
 extern void error_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 107eb21..f38481b 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -36,6 +36,7 @@ static inline int irq_canonicalize(int irq)
 extern void fixup_irqs(void);
 #endif
 
+extern void (*generic_interrupt_extension)(void);
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 8a285f3..3cbd79b 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -112,6 +112,11 @@
 #define LOCAL_PERF_VECTOR		0xee
 
 /*
+ * Generic system vector for platform specific use
+ */
+#define GENERIC_INTERRUPT_VECTOR	0xed
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 83d1836..7ba4621 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -984,6 +984,8 @@ apicinterrupt UV_BAU_MESSAGE \
 #endif
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
+apicinterrupt GENERIC_INTERRUPT_VECTOR \
+	generic_interrupt smp_generic_interrupt
 
 #ifdef CONFIG_SMP
 apicinterrupt INVALIDATE_TLB_VECTOR_START+0 \
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index f13ca16..b864341 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -15,6 +15,9 @@
 
 atomic_t irq_err_count;
 
+/* Function pointer for generic interrupt vector handling */
+void (*generic_interrupt_extension)(void) = NULL;
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -56,6 +59,12 @@ static int show_other_interrupts(struct seq_file *p)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
 #endif
+	if (generic_interrupt_extension) {
+		seq_printf(p, "PLT: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
+		seq_printf(p, "  Platform interrupts\n");
+	}
 #ifdef CONFIG_SMP
 	seq_printf(p, "RES: ");
 	for_each_online_cpu(j)
@@ -163,6 +172,8 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
 #endif
+	if (generic_interrupt_extension)
+		sum += irq_stats(cpu)->generic_irqs;
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
 	sum += irq_stats(cpu)->irq_call_count;
@@ -226,4 +237,27 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	return 1;
 }
 
+/*
+ * Handler for GENERIC_INTERRUPT_VECTOR.
+ */
+void smp_generic_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	ack_APIC_irq();
+
+	exit_idle();
+
+	irq_enter();
+
+	inc_irq_stat(generic_irqs);
+
+	if (generic_interrupt_extension)
+		generic_interrupt_extension();
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 50b8c3a..bc13261 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -175,6 +175,9 @@ void __init native_init_IRQ(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
+	/* generic IPI for platform specific use */
+	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
+
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index da481a1..c7a49e0 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -147,6 +147,9 @@ static void __init apic_intr_init(void)
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
+	/* generic IPI for platform specific use */
+	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
+
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
