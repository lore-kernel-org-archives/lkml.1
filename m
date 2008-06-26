Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYFZNqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYFZNqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYFZNps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:45:48 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24266 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756307AbYFZNpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:45:45 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 10/60] microblaze_v4: Interrupt handling, timer support, supported function
Date: Thu, 26 Jun 2008 14:29:39 +0200
Message-Id: <1214483429-32360-11-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-10-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/intc.c    |  163 ++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/irq.c     |   93 ++++++++++++++++++++++
 arch/microblaze/kernel/selfmod.c |   76 ++++++++++++++++++
 arch/microblaze/kernel/timer.c   |  136 +++++++++++++++++++++++++++++++
 include/asm-microblaze/irq.h     |   40 +++++++++
 include/asm-microblaze/selfmod.h |   24 ++++++
 6 files changed, 532 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/intc.c
 create mode 100644 arch/microblaze/kernel/irq.c
 create mode 100644 arch/microblaze/kernel/selfmod.c
 create mode 100644 arch/microblaze/kernel/timer.c
 create mode 100644 include/asm-microblaze/irq.h
 create mode 100644 include/asm-microblaze/selfmod.h

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
new file mode 100644
index 0000000..3a6529d
--- /dev/null
+++ b/arch/microblaze/kernel/intc.c
@@ -0,0 +1,163 @@
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
+#include <linux/autoconf.h>
+#include <asm/page.h>
+#include <asm/io.h>
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
+	iowrite32(mask, INTC_BASE + SIE);
+}
+
+static void intc_disable(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable: %d\n", irq);
+	iowrite32(mask, INTC_BASE + CIE);
+}
+
+static void intc_disable_and_ack(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable_and_ack: %d\n", irq);
+	iowrite32(mask, INTC_BASE + CIE);
+	/* ack edge triggered intr */
+	if (!(irq_desc[irq].status & IRQ_LEVEL))
+		iowrite32(mask, INTC_BASE + IAR);
+}
+
+static void intc_end(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+
+	pr_debug("end: %d\n", irq);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+		iowrite32(mask, INTC_BASE + SIE);
+		/* ack level sensitive intr */
+		if (irq_desc[irq].status & IRQ_LEVEL)
+			iowrite32(mask, INTC_BASE + IAR);
+	}
+}
+
+static struct irq_chip intc_dev = {
+	.name = "INTC",
+	.enable = intc_enable,
+	.disable = intc_disable,
+	.mask_ack  = intc_disable_and_ack,
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
+	irq = ioread32(INTC_BASE + IVR);
+	pr_debug("get_irq: %d\n", irq);
+
+	return irq;
+}
+
+void __init init_IRQ(void)
+{
+	int i, j, intr_type;
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
+	intr_type = *(int *) of_get_property(intc, "xlnx,kind-of-edge", NULL);
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
+	iowrite32(0, intc_baseaddr + IER);
+
+	/* Acknowledge any pending interrupts just in case. */
+	iowrite32(0xffffffff, intc_baseaddr + IAR);
+
+	/* Turn on the Master Enable. */
+	iowrite32(MER_HIE | MER_ME, intc_baseaddr + MER);
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
index 0000000..63e8994
--- /dev/null
+++ b/arch/microblaze/kernel/irq.c
@@ -0,0 +1,93 @@
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
+void do_IRQ(struct pt_regs *regs)
+{
+	unsigned int irq;
+	struct irq_desc *desc;
+
+	irq_enter();
+	set_irq_regs(regs);
+	irq = get_irq(regs);
+	BUG_ON(irq == -1U);
+	desc = irq_desc + irq;
+	desc->handle_irq(irq, desc);
+	desc->chip->end(irq);
+	irq_exit();
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
+					IRQ_LEVEL ? "level": "edge");
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
index 0000000..3c4cd25
--- /dev/null
+++ b/arch/microblaze/kernel/selfmod.c
@@ -0,0 +1,76 @@
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
+#define MODIFY_INSTR	{						\
+	pr_debug("%s: curr instr, (%d):0x%x, next(%d):0x%x\n",		\
+		__func__, i, addr[i], i + 1, addr[i + 1]);		\
+	addr[i] = OPCODE_IMM + (base >> 16);				\
+	/* keep instruction opcode and add only last 16bits */		\
+	addr[i + 1] = (addr[i + 1] & 0xffff00ff) + (base & 0xffff);	\
+	__invalidate_icache(addr[i]);					\
+	__invalidate_icache(addr[i + 1]);				\
+	pr_debug("%s: hack instr, (%d):0x%x, next(%d):0x%x\n",		\
+		__func__, i, addr[i], i + 1, addr[i + 1]);		\
+	}
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
+				if ((addr[i + 1] & ADDIK_BASE_MASK)
+							== ADDIK_BASE)
+					MODIFY_INSTR;
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
index 0000000..35c7d59
--- /dev/null
+++ b/arch/microblaze/kernel/timer.c
@@ -0,0 +1,136 @@
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
+#include <asm/io.h>
+#include <asm/cpuinfo.h>
+#include <asm/setup.h>
+
+#include <asm/prom.h>
+#include <asm/irq.h>
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
+#define TCSR1	(0x10)
+#define TLR1	(0x14)
+#define TCR1	(0x18)
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
+	iowrite32(ioread32(TIMER_BASE + TCSR0), TIMER_BASE + TCSR0);
+}
+
+irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+#ifdef CONFIG_HEART_BEAT
+	heartbeat();
+#endif
+	timer_ack();
+
+	write_seqlock(&xtime_lock);
+
+	do_timer(1);
+	update_process_times(user_mode(get_irq_regs()));
+	profile_tick(CPU_PROFILING);
+
+	write_sequnlock(&xtime_lock);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irqaction = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.name = "timer",
+};
+
+void time_init(void)
+{
+	int irq, j = 0;
+	struct device_node *timer = NULL;
+#ifdef CONFIG_SELFMOD_TIMER
+	unsigned int timer_baseaddr = 0;
+	int arr_func[] = {
+				(int)&timer_ack,
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
+	/* set the initial value to the load register */
+	iowrite32(cpuinfo.cpu_clock_freq/HZ, timer_baseaddr + TLR0);
+
+	/* load the initial value */
+	iowrite32(TCSR_LOAD, timer_baseaddr + TCSR0);
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
+	 *
+	 */
+	iowrite32(TCSR_TINT|TCSR_ENT|TCSR_ENIT|TCSR_ARHT|TCSR_UDT,
+			timer_baseaddr + TCSR0);
+
+	setup_irq(irq, &timer_irqaction);
+}
diff --git a/include/asm-microblaze/irq.h b/include/asm-microblaze/irq.h
new file mode 100644
index 0000000..12a6b14
--- /dev/null
+++ b/include/asm-microblaze/irq.h
@@ -0,0 +1,40 @@
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
+extern void __init init_IRQ(void);
+irqreturn_t timer_interrupt(int irq, void *dev_id);
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
+#endif /* _ASM_MICROBLAZE_IRQ_H */
diff --git a/include/asm-microblaze/selfmod.h b/include/asm-microblaze/selfmod.h
new file mode 100644
index 0000000..c42aff2
--- /dev/null
+++ b/include/asm-microblaze/selfmod.h
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
-- 
1.5.4.GIT

