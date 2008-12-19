Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYLSWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYLSWZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYLSWYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:24:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbYLSWYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:24:51 -0500
Date: Fri, 19 Dec 2008 23:23:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix lguest used_vectors breakage
Message-ID: <20081219222349.GA10954@elte.hu>
References: <494B8790.4060801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494B8790.4060801@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix and clean up

i tidied the changelog up - see it attached further below. Also Cc:-ed 
Rusty as the motivation is to fix and standardize lguest's irq vector 
allocation method.

One small detail, we'll need a -v2:

 In file included from 
 /home/mingo/linux/linux/arch/x86/include/asm/elf.h:90,
                 from include/linux/elf.h:8,
                 from include/linux/module.h:15,
                 from include/linux/crypto.h:22,
                 from arch/x86/kernel/asm-offsets_32.c:8,
                 from arch/x86/kernel/asm-offsets.c:3:
 /home/mingo/linux/linux/arch/x86/include/asm/desc.h:324: error: 'NR_VECTORS' undeclared here (not in a function)

config attached. Please pick up the changelog (and subject line) below 
when you iterate the patch. Thanks,

	Ingo

------------------>
>From 712403e560af439a61924cd18c8cd465aa2405bf Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Fri, 19 Dec 2008 03:37:52 -0800
Subject: [PATCH] x86: fix lguest used_vectors breakage

Impact: fix lguest, clean up

32-bit lguest used used_vectors to record vectors, but that model of
allocating vectors changed and got broken, after we changed vector
allocation to a per_cpu array.

Try enable that for 64bit, and the array is used for all vectors that
are not managed by vector_irq per_cpu array.

Also kill system_vectors[], that is now a duplication of the
used_vectors bitmap.

[ merged in cpus4096 due to io_apic.c cpumask changes. ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/desc.h           |    9 +++------
 arch/x86/include/asm/irq.h            |    1 +
 arch/x86/kernel/apic.c                |    2 --
 arch/x86/kernel/io_apic.c             |    9 +++------
 arch/x86/kernel/irqinit_32.c          |   16 +++++++++++++++-
 arch/x86/kernel/irqinit_64.c          |   13 +++++++++++++
 arch/x86/kernel/traps.c               |   12 +++++++-----
 drivers/lguest/interrupts_and_traps.c |   13 +++++++++----
 8 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e6b82b1..90c5eb2 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -320,16 +320,13 @@ static inline void set_intr_gate(unsigned int n, void *addr)
 	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
 }
 
-#define SYS_VECTOR_FREE		0
-#define SYS_VECTOR_ALLOCED	1
-
 extern int first_system_vector;
-extern char system_vectors[];
+extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 
 static inline void alloc_system_vector(int vector)
 {
-	if (system_vectors[vector] == SYS_VECTOR_FREE) {
-		system_vectors[vector] = SYS_VECTOR_ALLOCED;
+	if (!test_bit(vector, used_vectors)) {
+		set_bit(vector, used_vectors);
 		if (first_system_vector > vector)
 			first_system_vector = vector;
 	} else
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 8766d30..4bb732e 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -46,5 +46,6 @@ extern void native_init_IRQ(void);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
+extern int vector_used_by_percpu_irq(unsigned int vector);
 
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index f7a32a3..b901927 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -118,8 +118,6 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
 int first_system_vector = 0xfe;
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
-
 /*
  * Debug level, exported for io_apic.c
  */
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 908c1d0..1cbf7c8 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1326,13 +1326,10 @@ next:
 		}
 		if (unlikely(current_vector == vector))
 			continue;
-#ifdef CONFIG_X86_64
-		if (vector == IA32_SYSCALL_VECTOR)
-			goto next;
-#else
-		if (vector == SYSCALL_VECTOR)
+
+		if (test_bit(vector, used_vectors))
 			goto next;
-#endif
+
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 6a92f47..61aa2a1 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -110,6 +110,18 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
@@ -146,10 +158,12 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
 	/* IPI for single call function */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
+	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
+				 call_function_single_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 40c1e62..1020919 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -135,6 +135,18 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
+int vector_used_by_percpu_irq(unsigned int vector)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (per_cpu(vector_irq, cpu)[vector] != -1)
+			return 1;
+	}
+
+	return 0;
+}
+
 void __init init_ISA_irqs(void)
 {
 	int i;
@@ -187,6 +199,7 @@ static void __init smp_intr_init(void)
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 04d242a..4a6dff3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -72,9 +72,6 @@
 
 #include "cpu/mcheck/mce.h"
 
-DECLARE_BITMAP(used_vectors, NR_VECTORS);
-EXPORT_SYMBOL_GPL(used_vectors);
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
@@ -89,6 +86,9 @@ gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 #endif
 
+DECLARE_BITMAP(used_vectors, NR_VECTORS);
+EXPORT_SYMBOL_GPL(used_vectors);
+
 static int ignore_nmis;
 
 static inline void conditional_sti(struct pt_regs *regs)
@@ -949,9 +949,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 
 void __init trap_init(void)
 {
-#ifdef CONFIG_X86_32
 	int i;
-#endif
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1008,11 +1006,15 @@ void __init trap_init(void)
 	}
 
 	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
+#endif
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
+#ifdef CONFIG_X86_64
+	set_bit(IA32_SYSCALL_VECTOR, used_vectors);
+#else
 	set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
 	/*
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index a103906..415fab0 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -222,11 +222,16 @@ bool check_syscall_vector(struct lguest *lg)
 int init_interrupts(void)
 {
 	/* If they want some strange system call vector, reserve it now */
-	if (syscall_vector != SYSCALL_VECTOR
-	    && test_and_set_bit(syscall_vector, used_vectors)) {
-		printk("lg: couldn't reserve syscall %u\n", syscall_vector);
-		return -EBUSY;
+	if (syscall_vector != SYSCALL_VECTOR) {
+		if (test_bit(syscall_vector, used_vectors) ||
+		    vector_used_by_percpu_irq(syscall_vector)) {
+			printk(KERN_ERR "lg: couldn't reserve syscall %u\n",
+				 syscall_vector);
+			return -EBUSY;
+		}
+		set_bit(syscall_vector, used_vectors);
 	}
+
 	return 0;
 }
 
