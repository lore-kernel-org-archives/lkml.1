Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYEEImp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYEEImp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYEEIme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:42:34 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:39878 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753849AbYEEImc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:42:32 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 08/56] microblaze_v2: Interrupt handling, timer support, supported function
Date: Sun,  4 May 2008 13:40:57 +0200
Message-Id: <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/hack.c  |   82 ++++++++++++++++++
 arch/microblaze/kernel/intc.c  |  186 ++++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/irq.c   |  100 +++++++++++++++++++++
 arch/microblaze/kernel/timer.c |  164 +++++++++++++++++++++++++++++++++++
 include/asm-microblaze/hack.h  |   24 +++++
 include/asm-microblaze/irq.h   |   44 ++++++++++
 6 files changed, 600 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/hack.c
 create mode 100644 arch/microblaze/kernel/intc.c
 create mode 100644 arch/microblaze/kernel/irq.c
 create mode 100644 arch/microblaze/kernel/timer.c
 create mode 100644 include/asm-microblaze/hack.h
 create mode 100644 include/asm-microblaze/irq.h

diff --git a/arch/microblaze/kernel/hack.c b/arch/microblaze/kernel/hack.c
new file mode 100644
index 0000000..855e3c2
--- /dev/null
+++ b/arch/microblaze/kernel/hack.c
@@ -0,0 +1,82 @@
+/*
+ * arch/microblaze/kernel/hack.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+#include <linux/interrupt.h>
+#include <asm/hack.h>
+
+#undef DEBUG
+
+/* NOTE
+ * self-modified part of code for improvement of interrupt controller
+ * save instruction in interrupt rutine
+ */
+void function_hack(const int *arr_fce, const unsigned int base)
+{
+	unsigned int flags = 0;
+	unsigned int j, i;
+	unsigned int *addr = NULL;
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
+		for (i = 0;; i++) {
+			pr_debug("%s: instruction code at %d: 0x%x\n",
+						__func__, i, addr[i]);
+			if (addr[i] == 0xb0001234) {
+				/* detecting of lwi or swi instruction */
+				if ((addr[i+1] & 0xec00ff00) == 0xe800ff00) {
+					pr_debug("%s: curr instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __func__, i, addr[i], i+1,
+								addr[i+1]);
+					addr[i] = 0xb0000000 + (base >> 16);
+					addr[i+1] = (addr[i+1] & 0xffff00ff) +
+							(base & 0xffff);
+					__invalidate_icache(addr[i]);
+					__invalidate_icache(addr[i+1]);
+					pr_debug("%s: hack instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __func__, i, addr[i], i+1,
+								addr[i+1]);
+				} else /* detection addik for ack */
+				if ((addr[i+1] & 0xfc00ff00) == 0x3000ff00) {
+					pr_debug("%s: curr instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __func__, i, addr[i], i+1,
+								addr[i+1]);
+					addr[i] = 0xb0000000 + (base >> 16);
+					addr[i+1] = (addr[i+1] & 0xffff00ff) +
+							(base & 0xffff);
+					__invalidate_icache(addr[i]);
+					__invalidate_icache(addr[i+1]);
+					pr_debug("%s: hack instr, "
+						"(%d):0x%x, "
+						"next(%d):0x%x\n",
+						 __func__, i, addr[i], i+1,
+								addr[i+1]);
+				}
+			} else if (addr[i] == 0xb60f0008) {
+				pr_debug("%s: end of array %d\n",
+							__func__, i);
+				break;
+			}
+		}
+	}
+	local_irq_restore(flags);
+} /* end of self-modified code */
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
new file mode 100644
index 0000000..6632e82
--- /dev/null
+++ b/arch/microblaze/kernel/intc.c
@@ -0,0 +1,186 @@
+/*
+ * arch/microblaze/kernel/intc.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+#ifdef CONFIG_HACK
+#include <asm/hack.h>
+#else
+static unsigned int intc_baseaddr;
+#endif
+
+unsigned int NR_IRQ;
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
+#ifdef CONFIG_HACK
+	iowrite32(mask, HACK_BASE_ADDR + SIE);
+#else
+	iowrite32(mask, intc_baseaddr + SIE);
+#endif
+}
+
+static void intc_disable(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable: %d\n", irq);
+#ifdef CONFIG_HACK
+	iowrite32(mask, HACK_BASE_ADDR + CIE);
+#else
+	iowrite32(mask, intc_baseaddr + CIE);
+#endif
+}
+
+static void intc_disable_and_ack(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+	pr_debug("disable_and_ack: %d\n", irq);
+#ifdef CONFIG_HACK
+	iowrite32(mask, HACK_BASE_ADDR + CIE);
+	/* ack edge triggered intr */
+	if (!(irq_desc[irq].status & IRQ_LEVEL))
+		iowrite32(mask, HACK_BASE_ADDR + IAR);
+#else
+	iowrite32(mask, intc_baseaddr + CIE);
+	/* ack edge triggered intr */
+	if (!(irq_desc[irq].status & IRQ_LEVEL))
+		iowrite32(mask, intc_baseaddr + IAR);
+#endif
+}
+
+static void intc_end(unsigned int irq)
+{
+	unsigned long mask = (0x00000001 << (irq & 31));
+
+	pr_debug("end: %d\n", irq);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+#ifdef CONFIG_HACK
+		iowrite32(mask, HACK_BASE_ADDR + SIE);
+		/* ack level sensitive intr */
+		if (irq_desc[irq].status & IRQ_LEVEL)
+			iowrite32(mask, HACK_BASE_ADDR + IAR);
+#else
+		iowrite32(mask, intc_baseaddr + SIE);
+		/* ack level sensitive intr */
+		if (irq_desc[irq].status & IRQ_LEVEL)
+			iowrite32(mask, intc_baseaddr + IAR);
+#endif
+	}
+}
+
+static struct irq_chip intc_dev = {
+	.name = "INTC",
+	.enable = intc_enable,
+	.disable = intc_disable,
+	.ack = intc_disable_and_ack,
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
+#ifdef CONFIG_HACK
+	irq = ioread32(HACK_BASE_ADDR + IVR);
+#else
+	irq = ioread32(intc_baseaddr + IVR);
+#endif
+	pr_debug("get_irq: %d\n", irq);
+
+	return irq;
+}
+
+void __init init_IRQ(void)
+{
+	int i, j = 0;
+	int handle = 0x010;
+	struct device_node *intc = NULL;
+#ifdef CONFIG_HACK
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
+	NR_IRQ = *(int *) of_get_property(intc, "xlnx,num-intr-inputs", NULL);
+#ifdef CONFIG_HACK
+	function_hack((int *) arr_func, intc_baseaddr);
+#endif
+	printk(KERN_INFO "%s #0 at 0x%08x, irq=%d\n",
+		intc_list[j], intc_baseaddr, handle);
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
+	iowrite32(MER_HIE|MER_ME, intc_baseaddr + MER);
+
+	for (i = 0; i < NR_IRQ; ++i) {
+		irq_desc[i].chip = &intc_dev;
+
+		if (handle & (0x00000001 << i))
+			irq_desc[i].status &= ~IRQ_LEVEL;
+		else
+			irq_desc[i].status |= IRQ_LEVEL;
+	}
+}
diff --git a/arch/microblaze/kernel/irq.c b/arch/microblaze/kernel/irq.c
new file mode 100644
index 0000000..4cd30aa
--- /dev/null
+++ b/arch/microblaze/kernel/irq.c
@@ -0,0 +1,100 @@
+/*
+ * arch/microblaze/kernel/process.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/hardirq.h>
+#include <linux/interrupt.h>
+#include <linux/irqflags.h>
+#include <linux/seq_file.h>
+#include <linux/kernel_stat.h>
+
+#include <asm/irq.h>
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
+
+	irq_enter();
+	set_irq_regs(regs);
+	irq = get_irq(regs);
+	BUG_ON(irq == -1U);
+	__do_IRQ(irq);
+
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
+	if (i < NR_IRQ) {
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
+
+/*unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
+{
+	printk ("ERROR %s\n",__FUNCTION__);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_of_parse_and_map);*/
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
new file mode 100644
index 0000000..421a4f3
--- /dev/null
+++ b/arch/microblaze/kernel/timer.c
@@ -0,0 +1,164 @@
+/*
+ * arch/microblaze/kernel/timer.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+#ifdef CONFIG_HACK
+#include <asm/hack.h>
+#else
+static unsigned int timer_baseaddr;
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
+#ifdef CONFIG_HACK
+	iowrite32(ioread32(HACK_BASE_ADDR + TCSR0), HACK_BASE_ADDR + TCSR0);
+#else
+	iowrite32(ioread32(timer_baseaddr + TCSR0), timer_baseaddr + TCSR0);
+#endif
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
+unsigned long do_gettimeoffset(void)
+{
+#ifdef CONFIG_HACK
+	/* Current counter value */
+	unsigned int tcr = ioread32(HACK_BASE_ADDR + TCR0);
+
+	/* Load register value (couting down */
+	unsigned int tcmp = ioread32(HACK_BASE_ADDR + TLR0);
+#else
+	/* Current counter value */
+	unsigned int tcr = ioread32(timer_baseaddr + TCR0);
+
+	/* Load register value (couting down */
+	unsigned int tcmp = ioread32(timer_baseaddr + TLR0);
+#endif
+
+	/* Offset, in nanoseconds */
+	/* FIXME remove loading from structure - build in is faster */
+	unsigned long offset = (tcmp-tcr)/(cpuinfo.cpu_clock_freq/1000000);
+
+	return offset;
+}
+
+void system_timer_init(void)
+{
+	int irq, j = 0;
+	struct device_node *timer = NULL;
+#ifdef CONFIG_HACK
+	unsigned int timer_baseaddr = 0;
+	int arr_func[] = {
+				(int)&do_gettimeoffset,
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
+#ifdef CONFIG_HACK
+	function_hack((int *) arr_func, timer_baseaddr);
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
diff --git a/include/asm-microblaze/hack.h b/include/asm-microblaze/hack.h
new file mode 100644
index 0000000..b0ea20a
--- /dev/null
+++ b/include/asm-microblaze/hack.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/hack.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ */
+
+#ifndef _ASM_MICROBLAZE_HACK_H
+#define _ASM_MICROBLAZE_HACK_H
+
+/*
+ * HACK_BASE_ADDR is constant address for hack function.
+ * do not change this value - it is hardcoded in hack function
+ * arch/microblaze/kernel/hack.c:function_hack()
+ */
+
+#define HACK_BASE_ADDR	0x1234ff00
+
+void function_hack(const int *arr_fce, const unsigned int base);
+
+#endif /* _ASM_MICROBLAZE_HACK_H */
diff --git a/include/asm-microblaze/irq.h b/include/asm-microblaze/irq.h
new file mode 100644
index 0000000..89e0f87
--- /dev/null
+++ b/include/asm-microblaze/irq.h
@@ -0,0 +1,44 @@
+/*
+ * include/asm-microblaze/irq.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_IRQ_H
+#define _ASM_MICROBLAZE_IRQ_H
+
+#include <linux/seq_file.h>
+#define NR_IRQS 32
+#include <linux/irq.h>
+
+extern unsigned int NR_IRQ;
+extern void ledoff(void);
+
+#define NO_IRQ (-1)
+
+static inline int irq_canonicalize(int irq)
+{
+	return (irq);
+}
+
+struct pt_regs;
+extern void do_IRQ(struct pt_regs *regs);
+extern void __init init_IRQ(void);
+int show_interrupts(struct seq_file *p, void *v);
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
-- 
1.5.4.GIT

