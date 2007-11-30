Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbXLFMz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbXLFMz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXLFMob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:31 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53777 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbXLFMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:29 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <18f4030b185917de1baeed20c5992f7c82195a08.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 18:09:54 +0100
Subject: [PATCH 41/47] Update and simplify CRISv32 kernel/irq.c.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- First timer register has changed name to timer0.
- Build IRQs with only IRQ number, mask bit will be calculated instead.
- Add more IRQs, up to 64 supported.
- Use arrays to hold which IRQs triggered instead of trying to do magic
  with two 32 bit values now that more than 32 IRQs are supported.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/irq.c |  274 +++++++++++++++++++++++++++------------
 1 files changed, 193 insertions(+), 81 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index a9acaa2..173c141 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -15,15 +15,21 @@
 #include <linux/threads.h>
 #include <linux/spinlock.h>
 #include <linux/kernel_stat.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/intr_vect.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/intr_vect.h>
+#include <hwregs/intr_vect_defs.h>
 
 #define CPU_FIXED -1
 
 /* IRQ masks (refer to comment for crisv32_do_multiple) */
-#define TIMER_MASK (1 << (TIMER_INTR_VECT - FIRST_IRQ))
+#if TIMER0_INTR_VECT - FIRST_IRQ < 32
+#define TIMER_MASK (1 << (TIMER0_INTR_VECT - FIRST_IRQ))
+#undef TIMER_VECT1
+#else
+#define TIMER_MASK (1 << (TIMER0_INTR_VECT - FIRST_IRQ - 32))
+#define TIMER_VECT1
+#endif
 #ifdef CONFIG_ETRAX_KGDB
 #if defined(CONFIG_ETRAX_KGDB_PORT0)
 #define IGNOREMASK (1 << (SER0_INTR_VECT - FIRST_IRQ))
@@ -44,8 +50,8 @@ struct cris_irq_allocation
   cpumask_t mask; /* The CPUs to which the IRQ may be allocated. */
 };
 
-struct cris_irq_allocation irq_allocations[NR_IRQS] =
-  {[0 ... NR_IRQS - 1] = {0, CPU_MASK_ALL}};
+struct cris_irq_allocation irq_allocations[NR_REAL_IRQS] =
+  { [0 ... NR_REAL_IRQS - 1] = {0, CPU_MASK_ALL} };
 
 static unsigned long irq_regs[NR_CPUS] =
 {
@@ -55,6 +61,12 @@ static unsigned long irq_regs[NR_CPUS] =
 #endif
 };
 
+#if NR_REAL_IRQS > 32
+#define NBR_REGS 2
+#else
+#define NBR_REGS 1
+#endif
+
 unsigned long cpu_irq_counters[NR_CPUS];
 unsigned long irq_counters[NR_REAL_IRQS];
 
@@ -79,45 +91,81 @@ extern void d_mmu_write(void);
 extern void kgdb_init(void);
 extern void breakpoint(void);
 
+/* From traps.c.  */
+extern void breakh_BUG(void);
+
 /*
- * Build the IRQ handler stubs using macros from irq.h. First argument is the
- * IRQ number, the second argument is the corresponding bit in
- * intr_rw_vect_mask found in asm/arch/hwregs/intr_vect_defs.h.
+ * Build the IRQ handler stubs using macros from irq.h.
  */
-BUILD_IRQ(0x31, (1 << 0))	/* memarb */
-BUILD_IRQ(0x32, (1 << 1))	/* gen_io */
-BUILD_IRQ(0x33, (1 << 2))	/* iop0 */
-BUILD_IRQ(0x34, (1 << 3))	/* iop1 */
-BUILD_IRQ(0x35, (1 << 4))	/* iop2 */
-BUILD_IRQ(0x36, (1 << 5))	/* iop3 */
-BUILD_IRQ(0x37, (1 << 6))	/* dma0 */
-BUILD_IRQ(0x38, (1 << 7))	/* dma1 */
-BUILD_IRQ(0x39, (1 << 8))	/* dma2 */
-BUILD_IRQ(0x3a, (1 << 9))	/* dma3 */
-BUILD_IRQ(0x3b, (1 << 10))	/* dma4 */
-BUILD_IRQ(0x3c, (1 << 11))	/* dma5 */
-BUILD_IRQ(0x3d, (1 << 12))	/* dma6 */
-BUILD_IRQ(0x3e, (1 << 13))	/* dma7 */
-BUILD_IRQ(0x3f, (1 << 14))	/* dma8 */
-BUILD_IRQ(0x40, (1 << 15))	/* dma9 */
-BUILD_IRQ(0x41, (1 << 16))	/* ata */
-BUILD_IRQ(0x42, (1 << 17))	/* sser0 */
-BUILD_IRQ(0x43, (1 << 18))	/* sser1 */
-BUILD_IRQ(0x44, (1 << 19))	/* ser0 */
-BUILD_IRQ(0x45, (1 << 20))	/* ser1 */
-BUILD_IRQ(0x46, (1 << 21))	/* ser2 */
-BUILD_IRQ(0x47, (1 << 22))	/* ser3 */
-BUILD_IRQ(0x48, (1 << 23))
-BUILD_IRQ(0x49, (1 << 24))	/* eth0 */
-BUILD_IRQ(0x4a, (1 << 25))	/* eth1 */
-BUILD_TIMER_IRQ(0x4b, (1 << 26))/* timer */
-BUILD_IRQ(0x4c, (1 << 27))	/* bif_arb */
-BUILD_IRQ(0x4d, (1 << 28))	/* bif_dma */
-BUILD_IRQ(0x4e, (1 << 29))	/* ext */
-BUILD_IRQ(0x4f, (1 << 29))	/* ipi */
+BUILD_IRQ(0x31)
+BUILD_IRQ(0x32)
+BUILD_IRQ(0x33)
+BUILD_IRQ(0x34)
+BUILD_IRQ(0x35)
+BUILD_IRQ(0x36)
+BUILD_IRQ(0x37)
+BUILD_IRQ(0x38)
+BUILD_IRQ(0x39)
+BUILD_IRQ(0x3a)
+BUILD_IRQ(0x3b)
+BUILD_IRQ(0x3c)
+BUILD_IRQ(0x3d)
+BUILD_IRQ(0x3e)
+BUILD_IRQ(0x3f)
+BUILD_IRQ(0x40)
+BUILD_IRQ(0x41)
+BUILD_IRQ(0x42)
+BUILD_IRQ(0x43)
+BUILD_IRQ(0x44)
+BUILD_IRQ(0x45)
+BUILD_IRQ(0x46)
+BUILD_IRQ(0x47)
+BUILD_IRQ(0x48)
+BUILD_IRQ(0x49)
+BUILD_IRQ(0x4a)
+BUILD_IRQ(0x4b)
+BUILD_IRQ(0x4c)
+BUILD_IRQ(0x4d)
+BUILD_IRQ(0x4e)
+BUILD_IRQ(0x4f)
+BUILD_IRQ(0x50)
+#if MACH_IRQS > 32
+BUILD_IRQ(0x51)
+BUILD_IRQ(0x52)
+BUILD_IRQ(0x53)
+BUILD_IRQ(0x54)
+BUILD_IRQ(0x55)
+BUILD_IRQ(0x56)
+BUILD_IRQ(0x57)
+BUILD_IRQ(0x58)
+BUILD_IRQ(0x59)
+BUILD_IRQ(0x5a)
+BUILD_IRQ(0x5b)
+BUILD_IRQ(0x5c)
+BUILD_IRQ(0x5d)
+BUILD_IRQ(0x5e)
+BUILD_IRQ(0x5f)
+BUILD_IRQ(0x60)
+BUILD_IRQ(0x61)
+BUILD_IRQ(0x62)
+BUILD_IRQ(0x63)
+BUILD_IRQ(0x64)
+BUILD_IRQ(0x65)
+BUILD_IRQ(0x66)
+BUILD_IRQ(0x67)
+BUILD_IRQ(0x68)
+BUILD_IRQ(0x69)
+BUILD_IRQ(0x6a)
+BUILD_IRQ(0x6b)
+BUILD_IRQ(0x6c)
+BUILD_IRQ(0x6d)
+BUILD_IRQ(0x6e)
+BUILD_IRQ(0x6f)
+BUILD_IRQ(0x70)
+#endif
 
 /* Pointers to the low-level handlers. */
-static void (*interrupt[NR_IRQS])(void) = {
+static void (*interrupt[MACH_IRQS])(void) = {
 	IRQ0x31_interrupt, IRQ0x32_interrupt, IRQ0x33_interrupt,
 	IRQ0x34_interrupt, IRQ0x35_interrupt, IRQ0x36_interrupt,
 	IRQ0x37_interrupt, IRQ0x38_interrupt, IRQ0x39_interrupt,
@@ -128,7 +176,20 @@ static void (*interrupt[NR_IRQS])(void) = {
 	IRQ0x46_interrupt, IRQ0x47_interrupt, IRQ0x48_interrupt,
 	IRQ0x49_interrupt, IRQ0x4a_interrupt, IRQ0x4b_interrupt,
 	IRQ0x4c_interrupt, IRQ0x4d_interrupt, IRQ0x4e_interrupt,
-	IRQ0x4f_interrupt
+	IRQ0x4f_interrupt, IRQ0x50_interrupt,
+#if MACH_IRQS > 32
+	IRQ0x51_interrupt, IRQ0x52_interrupt, IRQ0x53_interrupt,
+	IRQ0x54_interrupt, IRQ0x55_interrupt, IRQ0x56_interrupt,
+	IRQ0x57_interrupt, IRQ0x58_interrupt, IRQ0x59_interrupt,
+	IRQ0x5a_interrupt, IRQ0x5b_interrupt, IRQ0x5c_interrupt,
+	IRQ0x5d_interrupt, IRQ0x5e_interrupt, IRQ0x5f_interrupt,
+	IRQ0x60_interrupt, IRQ0x61_interrupt, IRQ0x62_interrupt,
+	IRQ0x63_interrupt, IRQ0x64_interrupt, IRQ0x65_interrupt,
+	IRQ0x66_interrupt, IRQ0x67_interrupt, IRQ0x68_interrupt,
+	IRQ0x69_interrupt, IRQ0x6a_interrupt, IRQ0x6b_interrupt,
+	IRQ0x6c_interrupt, IRQ0x6d_interrupt, IRQ0x6e_interrupt,
+	IRQ0x6f_interrupt, IRQ0x70_interrupt,
+#endif
 };
 
 void
@@ -137,13 +198,26 @@ block_irq(int irq, int cpu)
 	int intr_mask;
         unsigned long flags;
 
-        spin_lock_irqsave(&irq_lock, flags);
-        intr_mask = REG_RD_INT(intr_vect, irq_regs[cpu], rw_mask);
-
-	/* Remember; 1 let through, 0 block. */
-	intr_mask &= ~(1 << (irq - FIRST_IRQ));
-
-	REG_WR_INT(intr_vect, irq_regs[cpu], rw_mask, intr_mask);
+	spin_lock_irqsave(&irq_lock, flags);
+	if (irq - FIRST_IRQ < 32)
+		intr_mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu],
+			rw_mask, 0);
+	else
+		intr_mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu],
+			rw_mask, 1);
+
+	/* Remember; 1 let thru, 0 block. */
+	if (irq - FIRST_IRQ < 32)
+		intr_mask &= ~(1 << (irq - FIRST_IRQ));
+	else
+		intr_mask &= ~(1 << (irq - FIRST_IRQ - 32));
+
+	if (irq - FIRST_IRQ < 32)
+		REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask,
+			0, intr_mask);
+	else
+		REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask,
+			1, intr_mask);
         spin_unlock_irqrestore(&irq_lock, flags);
 }
 
@@ -154,12 +228,26 @@ unblock_irq(int irq, int cpu)
         unsigned long flags;
 
         spin_lock_irqsave(&irq_lock, flags);
-        intr_mask = REG_RD_INT(intr_vect, irq_regs[cpu], rw_mask);
-
-	/* Remember; 1 let through, 0 block. */
-	intr_mask |= (1 << (irq - FIRST_IRQ));
+	if (irq - FIRST_IRQ < 32)
+		intr_mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu],
+			rw_mask, 0);
+	else
+		intr_mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu],
+			rw_mask, 1);
+
+	/* Remember; 1 let thru, 0 block. */
+	if (irq - FIRST_IRQ < 32)
+		intr_mask |= (1 << (irq - FIRST_IRQ));
+	else
+		intr_mask |= (1 << (irq - FIRST_IRQ - 32));
+
+	if (irq - FIRST_IRQ < 32)
+		REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask,
+			0, intr_mask);
+	else
+		REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask,
+			1, intr_mask);
 
-	REG_WR_INT(intr_vect, irq_regs[cpu], rw_mask, intr_mask);
         spin_unlock_irqrestore(&irq_lock, flags);
 }
 
@@ -298,8 +386,9 @@ crisv32_do_multiple(struct pt_regs* regs)
 {
 	int cpu;
 	int mask;
-	int masked;
+	int masked[NBR_REGS];
 	int bit;
+	int i;
 
 	cpu = smp_processor_id();
 
@@ -308,42 +397,59 @@ crisv32_do_multiple(struct pt_regs* regs)
 	 */
 	irq_enter();
 
-	/* Get which IRQs that happened. */
-	masked = REG_RD_INT(intr_vect, irq_regs[cpu], r_masked_vect);
+	for (i = 0; i < NBR_REGS; i++) {
+		/* Get which IRQs that happend. */
+		masked[i] = REG_RD_INT_VECT(intr_vect, irq_regs[cpu],
+			r_masked_vect, i);
 
-	/* Calculate new IRQ mask with these IRQs disabled. */
-	mask = REG_RD_INT(intr_vect, irq_regs[cpu], rw_mask);
-	mask &= ~masked;
+		/* Calculate new IRQ mask with these IRQs disabled. */
+		mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu], rw_mask, i);
+		mask &= ~masked[i];
 
 	/* Timer IRQ is never masked */
-	if (masked & TIMER_MASK)
-		mask |= TIMER_MASK;
-
-	/* Block all the IRQs */
-	REG_WR_INT(intr_vect, irq_regs[cpu], rw_mask, mask);
+#ifdef TIMER_VECT1
+		if ((i == 1) && (masked[0] & TIMER_MASK))
+			mask |= TIMER_MASK;
+#else
+		if ((i == 0) && (masked[0] & TIMER_MASK))
+			mask |= TIMER_MASK;
+#endif
+		/* Block all the IRQs */
+		REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask, i, mask);
 
 	/* Check for timer IRQ and handle it special. */
-	if (masked & TIMER_MASK) {
-	        masked &= ~TIMER_MASK;
-		do_IRQ(TIMER_INTR_VECT, regs);
+#ifdef TIMER_VECT1
+		if ((i == 1) && (masked[i] & TIMER_MASK)) {
+			masked[i] &= ~TIMER_MASK;
+			do_IRQ(TIMER0_INTR_VECT, regs);
+		}
+#else
+		if ((i == 0) && (masked[i] & TIMER_MASK)) {
+			 masked[i] &= ~TIMER_MASK;
+			 do_IRQ(TIMER0_INTR_VECT, regs);
+		}
 	}
+#endif
 
 #ifdef IGNORE_MASK
 	/* Remove IRQs that can't be handled as multiple. */
-	masked &= ~IGNORE_MASK;
+	masked[0] &= ~IGNORE_MASK;
 #endif
 
 	/* Handle the rest of the IRQs. */
-	for (bit = 0; bit < 32; bit++)
-	{
-		if (masked & (1 << bit))
-			do_IRQ(bit + FIRST_IRQ, regs);
+	for (i = 0; i < NBR_REGS; i++) {
+		for (bit = 0; bit < 32; bit++) {
+			if (masked[i] & (1 << bit))
+				do_IRQ(bit + FIRST_IRQ + i*32, regs);
+		}
 	}
 
 	/* Unblock all the IRQs. */
-	mask = REG_RD_INT(intr_vect, irq_regs[cpu], rw_mask);
-	mask |= masked;
-	REG_WR_INT(intr_vect, irq_regs[cpu], rw_mask, mask);
+	for (i = 0; i < NBR_REGS; i++) {
+		mask = REG_RD_INT_VECT(intr_vect, irq_regs[cpu], rw_mask, i);
+		mask |= masked[i];
+		REG_WR_INT_VECT(intr_vect, irq_regs[cpu], rw_mask, i, mask);
+	}
 
 	/* This irq_exit() will trigger the soft IRQs. */
 	irq_exit();
@@ -361,20 +467,21 @@ init_IRQ(void)
 	reg_intr_vect_rw_mask vect_mask = {0};
 
 	/* Clear all interrupts masks. */
-	REG_WR(intr_vect, regi_irq, rw_mask, vect_mask);
+	for (i = 0; i < NBR_REGS; i++)
+		REG_WR_VECT(intr_vect, regi_irq, rw_mask, i, vect_mask);
 
 	for (i = 0; i < 256; i++)
 		etrax_irv->v[i] = weird_irq;
 
-	/* Point all IRQs to bad handlers. */
+	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
 		irq_desc[j].chip = &crisv32_irq_type;
 		set_exception_vector(i, interrupt[j]);
 	}
 
         /* Mark Timer and IPI IRQs as CPU local */
-	irq_allocations[TIMER_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
-	irq_desc[TIMER_INTR_VECT].status |= IRQ_PER_CPU;
+	irq_allocations[TIMER0_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
+	irq_desc[TIMER0_INTR_VECT].status |= IRQ_PER_CPU;
 	irq_allocations[IPI_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
 	irq_desc[IPI_INTR_VECT].status |= IRQ_PER_CPU;
 
@@ -391,6 +498,11 @@ init_IRQ(void)
 	set_exception_vector(0x0a, d_mmu_access);
 	set_exception_vector(0x0b, d_mmu_write);
 
+#ifdef CONFIG_BUG
+	/* Break 14 handler, used to implement cheap BUG().  */
+	set_exception_vector(0x1e, breakh_BUG);
+#endif
+
 	/* The system-call trap is reached by "break 13". */
 	set_exception_vector(0x1d, system_call);
 
-- 
1.5.3.6.970.gd25430

