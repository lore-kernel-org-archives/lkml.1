Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZCRUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZCRUeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZCRUbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:51 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56217 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752800AbZCRUbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:41 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support, selfmod code
Date: Wed, 18 Mar 2009 21:30:35 +0100
Message-Id: <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/irq.h     |   46 ++++++
 arch/microblaze/include/asm/selfmod.h |   24 ++++
 arch/microblaze/kernel/intc.c         |  167 ++++++++++++++++++++++
 arch/microblaze/kernel/irq.c          |  102 ++++++++++++++
 arch/microblaze/kernel/selfmod.c      |   80 +++++++++++
 arch/microblaze/kernel/timer.c        |  246 +++++++++++++++++++++++++++++++++
 6 files changed, 665 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/irq.h
 create mode 100644 arch/microblaze/include/asm/selfmod.h
 create mode 100644 arch/microblaze/kernel/intc.c
 create mode 100644 arch/microblaze/kernel/irq.c
 create mode 100644 arch/microblaze/kernel/selfmod.c
 create mode 100644 arch/microblaze/kernel/timer.c

diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
new file mode 100644
index 0000000..c0b773f
--- /dev/null
+++ b/arch/microblaze/include/asm/irq.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_IRQ_H
+#define _ASM_MICROBLAZE_IRQ_H
+
+#define NR_IRQS 32
+
+#include <linux/interrupt.h>
+
+extern unsigned int nr_irq;
+
+#define NO_IRQ (-1)
+
+static inline int irq_canonicalize(int irq)
+{
+	return irq;
+}
+
+struct pt_regs;
+extern void do_IRQ(struct pt_regs *regs);
+
+/* irq_of_parse_and_map - Parse and Map an interrupt into linux virq space
+ * @device: Device node of the device whose interrupt is to be mapped
+ * @index: Index of the interrupt to map
+ *
+ * This function is a wrapper that chains of_irq_map_one() and
+ * irq_create_of_mapping() to make things easier to callers
+ */
+struct device_node;
+extern unsigned int irq_of_parse_and_map(struct device_node *dev, int index);
+
+/** FIXME - not implement
+ * irq_dispose_mapping - Unmap an interrupt
+ * @virq: linux virq number of the interrupt to unmap
+ */
+static inline void irq_dispose_mapping(unsigned int virq) {
+	return;
+}
+
+#endif /* _ASM_MICROBLAZE_IRQ_H */
diff --git a/arch/microblaze/include/asm/selfmod.h b/arch/microblaze/include/asm/selfmod.h
new file mode 100644
index 0000000..c42aff2
--- /dev/null
+++ b/arch/microblaze/include/asm/selfmod.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SELFMOD_H
+#define _ASM_MICROBLAZE_SELFMOD_H
+
+/*
+ * BARRIER_BASE_ADDR is constant address for selfmod function.
+ * do not change this value - selfmod function is in
+ * arch/microblaze/kernel/selfmod.c: selfmod_function()
+ *
+ * last 16 bits is used for storing register offset
+ */
+
+#define BARRIER_BASE_ADDR	0x1234ff00
+
+void selfmod_function(const int *arr_fce, const unsigned int base);
+
+#endif /* _ASM_MICROBLAZE_SELFMOD_H */
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
new file mode 100644
index 0000000..9b57e47
--- /dev/null
+++ b/arch/microblaze/kernel/intc.c
@@ -0,0 +1,167 @@
+/*
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <asm/page.h>
+#include <linux/io.h>
+
+#include <asm/prom.h>
+#include <asm/irq.h>
+
+#ifdef CONFIG_SELFMOD_INTC
+#include <asm/selfmod.h>
+#define INTC_BASE	BARRIER_BASE_ADDR
+#else
+static unsigned int intc_baseaddr;
+#define INTC_BASE	intc_baseaddr
+#endif
+
+unsigned int nr_irq;
+
+/* No one else should require these constants, so define them locally here. */
+#define ISR 0x00			/* Interrupt Status Register */
+#define IPR 0x04			/* Interrupt Pending Register */
+#define IER 0x08			/* Interrupt Enable Register */
+#define IAR 0x0c			/* Interrupt Acknowledge Register */
+#define SIE 0x10			/* Set Interrupt Enable bits */
+#define CIE 0x14			/* Clear Interrupt Enable bits */
+#define IVR 0x18			/* Interrupt Vector Register */
+#define MER 0x1c			/* Master Enable Register */
+
+#define MER_ME (1<<0)
+#define MER_HIE (1<<1)
+
+static void intc_enable(unsigned int irq)
+{
+	unsigned int mask = (0x00000001 << (irq & 31));
+	pr_debug("enable: %d\n", irq);
+	out_be32(INTC_BASE + SIE, mask);
+}
+
+static void intc_disable(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable: %d\n", irq);
+	out_be32(INTC_BASE + CIE, mask);
+}
+
+static void intc_disable_and_ack(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable_and_ack: %d\n", irq);
+	out_be32(INTC_BASE + CIE, mask);
+	/* ack edge triggered intr */
+	if (!(irq_desc[irq].status & IRQ_LEVEL))
+		out_be32(INTC_BASE + IAR, mask);
+}
+
+static void intc_end(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+
+	pr_debug("end: %d\n", irq);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+		out_be32(INTC_BASE + SIE, mask);
+		/* ack level sensitive intr */
+		if (irq_desc[irq].status & IRQ_LEVEL)
+			out_be32(INTC_BASE + IAR, mask);
+	}
+}
+
+static struct irq_chip intc_dev = {
+	.name = "INTC",
+	.enable = intc_enable,
+	.disable = intc_disable,
+	.ack  = intc_disable_and_ack,
+	.end = intc_end,
+};
+
+unsigned int get_irq(struct pt_regs *regs)
+{
+	int irq;
+
+	/*
+	 * NOTE: This function is the one that needs to be improved in
+	 * order to handle multiple interrupt controllers. It currently
+	 * is hardcoded to check for interrupts only on the first INTC.
+	 */
+	irq = in_be32(INTC_BASE + IVR);
+	pr_debug("get_irq: %d\n", irq);
+
+	return irq;
+}
+
+void __init init_IRQ(void)
+{
+	u32 i, j, intr_type;
+	struct device_node *intc = NULL;
+#ifdef CONFIG_SELFMOD_INTC
+	unsigned int intc_baseaddr = 0;
+	static int arr_func[] = {
+				(int)&get_irq,
+				(int)&intc_enable,
+				(int)&intc_disable,
+				(int)&intc_disable_and_ack,
+				(int)&intc_end,
+				0
+			};
+#endif
+	static char *intc_list[] = {
+				"xlnx,xps-intc-1.00.a",
+				"xlnx,opb-intc-1.00.c",
+				"xlnx,opb-intc-1.00.b",
+				"xlnx,opb-intc-1.00.a",
+				NULL
+			};
+
+	for (j = 0; intc_list[j] != NULL; j++) {
+		intc = of_find_compatible_node(NULL, NULL, intc_list[j]);
+		if (intc)
+			break;
+	}
+
+	intc_baseaddr = *(int *) of_get_property(intc, "reg", NULL);
+	intc_baseaddr = (unsigned long) ioremap(intc_baseaddr, PAGE_SIZE);
+	nr_irq = *(int *) of_get_property(intc, "xlnx,num-intr-inputs", NULL);
+
+	intr_type =
+		*(int *) of_get_property(intc, "xlnx,kind-of-intr", NULL);
+	if (intr_type >= (1 << nr_irq))
+		printk(" ERROR: Mishmash in king-of-intr parameter\n");
+
+#ifdef CONFIG_SELFMOD_INTC
+	selfmod_function((int *) arr_func, intc_baseaddr);
+#endif
+	printk(KERN_INFO "%s #0 at 0x%08x, num_irq=%d, edge=0x%x\n",
+		intc_list[j], intc_baseaddr, nr_irq, intr_type);
+
+	/*
+	 * Disable all external interrupts until they are
+	 * explicity requested.
+	 */
+	out_be32(intc_baseaddr + IER, 0);
+
+	/* Acknowledge any pending interrupts just in case. */
+	out_be32(intc_baseaddr + IAR, 0xffffffff);
+
+	/* Turn on the Master Enable. */
+	out_be32(intc_baseaddr + MER, MER_HIE | MER_ME);
+
+	for (i = 0; i < nr_irq; ++i) {
+		if (intr_type & (0x00000001 << i)) {
+			set_irq_chip_and_handler_name(i, &intc_dev,
+				handle_edge_irq, intc_dev.name);
+			irq_desc[i].status &= ~IRQ_LEVEL;
+		} else {
+			set_irq_chip_and_handler_name(i, &intc_dev,
+				handle_level_irq, intc_dev.name);
+			irq_desc[i].status |= IRQ_LEVEL;
+		}
+	}
+}
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
new file mode 100644
index 0000000..ff2d29f
--- /dev/null
+++ b/arch/microblaze/kernel/irq.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/hardirq.h>
+#include <linux/interrupt.h>
+#include <linux/irqflags.h>
+#include <linux/seq_file.h>
+#include <linux/kernel_stat.h>
+#include <linux/irq.h>
+
+#include <asm/prom.h>
+
+unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
+{
+	struct of_irq oirq;
+
+	if (of_irq_map_one(dev, index, &oirq))
+		return NO_IRQ;
+
+	return oirq.specifier[0];
+}
+EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
+
+/*
+ * 'what should we do if we get a hw irq event on an illegal vector'.
+ * each architecture has to answer this themselves.
+ */
+void ack_bad_irq(unsigned int irq)
+{
+	printk(KERN_WARNING "unexpected IRQ trap at vector %02x\n", irq);
+}
+
+static u32 concurrent_irq;
+
+void do_IRQ(struct pt_regs *regs)
+{
+	unsigned int irq;
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	irq = get_irq(regs);
+next_irq:
+	BUG_ON(irq == -1U);
+	__do_IRQ(irq);
+
+	irq = get_irq(regs);
+	if (irq != -1U) {
+		pr_debug("next irq: %d\n", irq);
+		++concurrent_irq;
+		goto next_irq;
+	}
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, j;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		seq_printf(p, "		");
+		for_each_online_cpu(j)
+			seq_printf(p, "CPU%-8d", j);
+		seq_putc(p, '\n');
+	}
+
+	if (i < nr_irq) {
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
+		if (!action)
+			goto skip;
+		seq_printf(p, "%3d: ", i);
+#ifndef CONFIG_SMP
+		seq_printf(p, "%10u ", kstat_irqs(i));
+#else
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+#endif
+		seq_printf(p, " %8s", irq_desc[i].status &
+					IRQ_LEVEL ? "level" : "edge");
+		seq_printf(p, " %8s", irq_desc[i].chip->name);
+		seq_printf(p, "  %s", action->name);
+
+		for (action = action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+
+		seq_putc(p, '\n');
+skip:
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+	}
+	return 0;
+}
diff --git a/arch/microblaze/kernel/selfmod.c b/arch/microblaze/kernel/selfmod.c
new file mode 100644
index 0000000..c0eb301
--- /dev/null
+++ b/arch/microblaze/kernel/selfmod.c
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <asm/selfmod.h>
+
+#undef DEBUG
+
+#if __GNUC__ > 3
+#error GCC 4 unsupported SELFMOD. Please disable SELFMOD from menuconfig.
+#endif
+
+#define OPCODE_IMM		0xB0000000
+#define OPCODE_LWI		0xE8000000
+#define OPCODE_LWI_MASK		0xEC000000
+#define OPCODE_RTSD		0xB60F0008 /* return from func: rtsd r15, 8 */
+#define OPCODE_ADDIK		0x30000000
+#define OPCODE_ADDIK_MASK	0xFC000000
+
+#define IMM_BASE	(OPCODE_IMM | (BARRIER_BASE_ADDR >> 16))
+#define LWI_BASE	(OPCODE_LWI | (BARRIER_BASE_ADDR & 0x0000ff00))
+#define LWI_BASE_MASK	(OPCODE_LWI_MASK | (BARRIER_BASE_ADDR & 0x0000ff00))
+#define ADDIK_BASE	(OPCODE_ADDIK | (BARRIER_BASE_ADDR & 0x0000ff00))
+#define ADDIK_BASE_MASK	(OPCODE_ADDIK_MASK | (BARRIER_BASE_ADDR & 0x0000ff00))
+
+#define MODIFY_INSTR {						\
+	pr_debug("%s: curr instr, (%d):0x%x, next(%d):0x%x\n",		\
+		__func__, i, addr[i], i + 1, addr[i + 1]);		\
+	addr[i] = OPCODE_IMM + (base >> 16);				\
+	/* keep instruction opcode and add only last 16bits */		\
+	addr[i + 1] = (addr[i + 1] & 0xffff00ff) + (base & 0xffff);	\
+	__invalidate_icache(addr[i]);					\
+	__invalidate_icache(addr[i + 1]);				\
+	pr_debug("%s: hack instr, (%d):0x%x, next(%d):0x%x\n",		\
+		__func__, i, addr[i], i + 1, addr[i + 1]); }
+
+/* NOTE
+ * self-modified part of code for improvement of interrupt controller
+ * save instruction in interrupt rutine
+ */
+void selfmod_function(const int *arr_fce, const unsigned int base)
+{
+	unsigned int flags, i, j, *addr = NULL;
+
+	local_irq_save(flags);
+	__disable_icache();
+
+	/* zero terminated array */
+	for (j = 0; arr_fce[j] != 0; j++) {
+		/* get start address of function */
+		addr = (unsigned int *) arr_fce[j];
+		pr_debug("%s: func(%d) at 0x%x\n",
+					__func__, j, (unsigned int) addr);
+		for (i = 0; ; i++) {
+			pr_debug("%s: instruction code at %d: 0x%x\n",
+						__func__, i, addr[i]);
+			if (addr[i] == IMM_BASE) {
+				/* detecting of lwi (0xE8) or swi (0xF8) instr
+				 * I can detect both opcode with one mask */
+				if ((addr[i + 1] & LWI_BASE_MASK) == LWI_BASE) {
+					MODIFY_INSTR;
+				} else /* detection addik for ack */
+				if ((addr[i + 1] & ADDIK_BASE_MASK) ==
+								ADDIK_BASE) {
+					MODIFY_INSTR;
+				}
+			} else if (addr[i] == OPCODE_RTSD) {
+				/* return from function means end of function */
+				pr_debug("%s: end of array %d\n", __func__, i);
+				break;
+			}
+		}
+	}
+	local_irq_restore(flags);
+} /* end of self-modified code */
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
new file mode 100644
index 0000000..2dccd29
--- /dev/null
+++ b/arch/microblaze/kernel/timer.c
@@ -0,0 +1,246 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/interrupt.h>
+#include <linux/profile.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/io.h>
+#include <asm/cpuinfo.h>
+#include <asm/setup.h>
+#include <asm/prom.h>
+#include <asm/irq.h>
+#include <asm/system.h>
+
+#ifdef CONFIG_SELFMOD_TIMER
+#include <asm/selfmod.h>
+#define TIMER_BASE	BARRIER_BASE_ADDR
+#else
+static unsigned int timer_baseaddr;
+#define TIMER_BASE	timer_baseaddr
+#endif
+
+#define TCSR0	(0x00)
+#define TLR0	(0x04)
+#define TCR0	(0x08)
+
+#define TCSR_MDT	(1<<0)
+#define TCSR_UDT	(1<<1)
+#define TCSR_GENT	(1<<2)
+#define TCSR_CAPT	(1<<3)
+#define TCSR_ARHT	(1<<4)
+#define TCSR_LOAD	(1<<5)
+#define TCSR_ENIT	(1<<6)
+#define TCSR_ENT	(1<<7)
+#define TCSR_TINT	(1<<8)
+#define TCSR_PWMA	(1<<9)
+#define TCSR_ENALL	(1<<10)
+
+static void timer_ack(void)
+{
+	out_be32(TIMER_BASE + TCSR0, in_be32(TIMER_BASE + TCSR0));
+}
+
+static cycle_t mb_tick_cnt; /* store counter ticks */
+
+static cycle_t microblaze_read(void)
+{
+	u64 temp = (u64)mb_tick_cnt + (u64)((u32)cpuinfo.freq_div_hz
+					- (u32)in_be32(TIMER_BASE + TCR0));
+	return temp;
+}
+
+static struct clocksource clocksource_microblaze = {
+	.name		= "microblaze_counter",
+	.rating		= 200,
+	.read		= microblaze_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.shift		= 13, /* I can shift it */
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int __init microblaze_clocksource_init(void)
+{
+	clocksource_microblaze.mult =
+			clocksource_hz2mult(cpuinfo.cpu_clock_freq,
+						clocksource_microblaze.shift);
+	if (clocksource_register(&clocksource_microblaze))
+		panic("failed to register clocksource");
+
+	return 0;
+}
+
+static inline void microblaze_timer_stop(void)
+{
+	out_be32(TIMER_BASE + TCSR0, in_be32(TIMER_BASE + TCSR0) & ~TCSR_ENT);
+}
+
+static inline void microblaze_timer_start(unsigned long load_val)
+{
+	if (!load_val)
+		load_val = 1;
+	out_be32(TIMER_BASE + TLR0, load_val); /* loading value to timer reg */
+
+	/* load the initial value */
+	out_be32(TIMER_BASE + TCSR0, TCSR_LOAD);
+
+	/* see timer data sheet for detail
+	 * !ENALL - don't enable 'em all
+	 * !PWMA - disable pwm
+	 * TINT - clear interrupt status
+	 * ENT- enable timer itself
+	 * EINT - enable interrupt
+	 * !LOAD - clear the bit to let go
+	 * ARHT - auto reload
+	 * !CAPT - no external trigger
+	 * !GENT - no external signal
+	 * UDT - set the timer as down counter
+	 * !MDT0 - generate mode
+	 */
+	out_be32(TIMER_BASE + TCSR0,
+			TCSR_TINT|TCSR_ENIT|TCSR_ENT|TCSR_ARHT|TCSR_UDT);
+}
+
+static int microblaze_timer_set_next_event(unsigned long delta,
+					 struct clock_event_device *dev)
+{
+	printk(KERN_INFO "next event, delta %x, %d\n", (u32)delta, (u32)delta);
+	microblaze_timer_start(delta);
+	return 0;
+}
+
+static void microblaze_timer_set_mode(enum clock_event_mode mode,
+				    struct clock_event_device *evt)
+{
+	microblaze_timer_stop();
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		printk(KERN_INFO "%s: periodic\n", __func__);
+		microblaze_timer_start(cpuinfo.freq_div_hz);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		printk(KERN_INFO "%s: oneshot\n", __func__);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+		printk(KERN_INFO "%s: unused\n", __func__);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		printk(KERN_INFO "%s: shutdown\n", __func__);
+		microblaze_timer_stop();
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		printk(KERN_INFO "%s: resume\n", __func__);
+		break;
+	}
+}
+
+static struct clock_event_device clockevent_microblaze_timer = {
+	.name		= "microblaze-timer",
+	.features       = CLOCK_EVT_FEAT_PERIODIC,
+	.shift		= 13,
+	.rating		= 200,
+	.set_next_event	= microblaze_timer_set_next_event,
+	.set_mode	= microblaze_timer_set_mode,
+};
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &clockevent_microblaze_timer;
+#ifdef CONFIG_HEART_BEAT
+	heartbeat();
+#endif
+	timer_ack();
+
+	mb_tick_cnt += cpuinfo.freq_div_hz;
+
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irqaction = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.name = "timer",
+	.dev_id = &clockevent_microblaze_timer,
+};
+
+static __init void microblaze_clockevent_init(void)
+{
+	clockevent_microblaze_timer.mult =
+		div_sc(cpuinfo.cpu_clock_freq, NSEC_PER_SEC,
+				clockevent_microblaze_timer.shift);
+	clockevent_microblaze_timer.max_delta_ns =
+		clockevent_delta2ns((u32)~0, &clockevent_microblaze_timer);
+	clockevent_microblaze_timer.min_delta_ns =
+		clockevent_delta2ns(1, &clockevent_microblaze_timer);
+	clockevent_microblaze_timer.cpumask = cpumask_of(0);
+	clockevents_register_device(&clockevent_microblaze_timer);
+}
+
+void __init time_init(void)
+{
+	int irq, j = 0;
+	struct device_node *timer = NULL;
+#ifdef CONFIG_SELFMOD_TIMER
+	unsigned int timer_baseaddr = 0;
+	int arr_func[] = {
+				(int)&timer_ack,
+				(int)&microblaze_read,
+				(int)&microblaze_timer_stop,
+				(int)&microblaze_timer_start,
+				(int)&microblaze_timer_set_mode,
+				0
+			};
+#endif
+	char *timer_list[] = {
+				"xlnx,xps-timer-1.00.a",
+				"xlnx,opb-timer-1.00.b",
+				"xlnx,opb-timer-1.00.a",
+				NULL
+			};
+
+	for (j = 0; timer_list[j] != NULL; j++) {
+		timer = of_find_compatible_node(NULL, NULL, timer_list[j]);
+		if (timer)
+			break;
+	}
+
+	timer_baseaddr = *(int *) of_get_property(timer, "reg", NULL);
+	timer_baseaddr = (unsigned long) ioremap(timer_baseaddr, PAGE_SIZE);
+	irq = *(int *) of_get_property(timer, "interrupts", NULL);
+#ifdef CONFIG_SELFMOD_TIMER
+	selfmod_function((int *) arr_func, timer_baseaddr);
+#endif
+	printk(KERN_INFO "%s #0 at 0x%08x, irq=%d\n",
+		timer_list[j], timer_baseaddr, irq);
+
+	cpuinfo.freq_div_hz = cpuinfo.cpu_clock_freq / HZ;
+
+	setup_irq(irq, &timer_irqaction);
+#ifdef CONFIG_HEART_BEAT
+	setup_heartbeat();
+#endif
+	xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
+	xtime.tv_nsec = 0;
+	set_normalized_timespec(&wall_to_monotonic,
+				-xtime.tv_sec, -xtime.tv_nsec);
+
+	microblaze_clocksource_init();
+	microblaze_clockevent_init();
+}
-- 
1.5.5.1

