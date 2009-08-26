Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZHZGl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZHZGl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZHZGl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:41:58 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:57046 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbZHZGly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:41:54 -0400
Subject: Subject: [PATCH 25/33] score: create kernel/ files irq.c time.c
	traps.c
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:31:42 +0800
Message-Id: <1251268302.3153.17.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1039f8cf823ca523528802239511c714b1c159f7 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:09 +0800
Subject: [PATCH 25/33] score: create kernel/ files irq.c time.c traps.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/irq.c   |  148 +++++++++++++++++++
 arch/score/kernel/time.c  |   99 +++++++++++++
 arch/score/kernel/traps.c |  349 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 596 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/kernel/irq.c
 create mode 100644 arch/score/kernel/time.c
 create mode 100644 arch/score/kernel/traps.c

diff --git a/arch/score/kernel/irq.c b/arch/score/kernel/irq.c
new file mode 100644
index 0000000..47647dd
--- /dev/null
+++ b/arch/score/kernel/irq.c
@@ -0,0 +1,148 @@
+/*
+ * arch/score/kernel/irq.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/seq_file.h>
+
+#include <asm/io.h>
+
+/* the interrupt controller is hardcoded at this address */
+#define SCORE_PIC		((u32 __iomem __force *)0x95F50000)
+
+#define INT_PNDL		0
+#define INT_PNDH		1
+#define INT_PRIORITY_M		2
+#define INT_PRIORITY_SG0	4
+#define INT_PRIORITY_SG1	5
+#define INT_PRIORITY_SG2	6
+#define INT_PRIORITY_SG3	7
+#define INT_MASKL		8
+#define INT_MASKH		9
+
+/*
+ * handles all normal device IRQs
+ */
+asmlinkage void do_IRQ(int irq)
+{
+	irq_enter();
+	generic_handle_irq(irq);
+	irq_exit();
+}
+
+static void score_mask(unsigned int irq_nr)
+{
+	unsigned int irq_source = 63 - irq_nr;
+
+	if (irq_source < 32)
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) | \
+			(1 << irq_source)), SCORE_PIC + INT_MASKL);
+	else
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) | \
+			(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
+}
+
+static void score_unmask(unsigned int irq_nr)
+{
+	unsigned int irq_source = 63 - irq_nr;
+
+	if (irq_source < 32)
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) & \
+			~(1 << irq_source)), SCORE_PIC + INT_MASKL);
+	else
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) & \
+			~(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
+}
+
+struct irq_chip score_irq_chip = {
+	.name		= "Score7-level",
+	.mask		= score_mask,
+	.mask_ack	= score_mask,
+	.unmask		= score_unmask,
+};
+
+/*
+ * initialise the interrupt system
+ */
+void __init init_IRQ(void)
+{
+	int index;
+	unsigned long target_addr;
+
+	for (index = 0; index < NR_IRQS; ++index)
+		set_irq_chip_and_handler(index, &score_irq_chip,
+					 handle_level_irq);
+
+	for (target_addr = IRQ_VECTOR_BASE_ADDR;
+		target_addr <= IRQ_VECTOR_END_ADDR;
+		target_addr += IRQ_VECTOR_SIZE)
+		memcpy((void *)target_addr, \
+			interrupt_exception_vector, IRQ_VECTOR_SIZE);
+
+	__raw_writel(0xffffffff, SCORE_PIC + INT_MASKL);
+	__raw_writel(0xffffffff, SCORE_PIC + INT_MASKH);
+
+	__asm__ __volatile__(
+		"mtcr	%0, cr3\n\t"
+		: : "r" (EXCEPTION_VECTOR_BASE_ADDR | \
+			VECTOR_ADDRESS_OFFSET_MODE16));
+}
+
+/*
+ * Generic, controller-independent functions:
+ */
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *)v, cpu;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		seq_puts(p, "           ");
+		for_each_online_cpu(cpu)
+			seq_printf(p, "CPU%d       ", cpu);
+		seq_putc(p, '\n');
+	}
+
+	if (i < NR_IRQS) {
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
+		if (!action)
+			goto unlock;
+
+		seq_printf(p, "%3d: ", i);
+		seq_printf(p, "%10u ", kstat_irqs(i));
+		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+		seq_printf(p, "  %s", action->name);
+		for (action = action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+
+		seq_putc(p, '\n');
+unlock:
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+	}
+
+	return 0;
+}
diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
new file mode 100644
index 0000000..f0a43af
--- /dev/null
+++ b/arch/score/kernel/time.c
@@ -0,0 +1,99 @@
+/*
+ * arch/score/kernel/time.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+
+#include <asm/scoreregs.h>
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evdev = dev_id;
+
+	/* clear timer interrupt flag */
+	outl(1, P_TIMER0_CPP_REG);
+	evdev->event_handler(evdev);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irq = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.name = "timer",
+};
+
+static int score_timer_set_next_event(unsigned long delta,
+		struct clock_event_device *evdev)
+{
+	outl((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
+	outl(delta, P_TIMER0_PRELOAD);
+	outl(inl(P_TIMER0_CTRL) | TMR_ENABLE, P_TIMER0_CTRL);
+
+	return 0;
+}
+
+static void score_timer_set_mode(enum clock_event_mode mode,
+		struct clock_event_device *evdev)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		outl((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
+		outl(SYSTEM_CLOCK/HZ, P_TIMER0_PRELOAD);
+		outl(inl(P_TIMER0_CTRL) | TMR_ENABLE, P_TIMER0_CTRL);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_UNUSED:
+		break;
+	default:
+		BUG();
+	}
+}
+
+static struct clock_event_device score_clockevent = {
+	.name		= "score_clockevent",
+	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.shift		= 16,
+	.set_next_event	= score_timer_set_next_event,
+	.set_mode	= score_timer_set_mode,
+};
+
+void __init time_init(void)
+{
+	timer_irq.dev_id = &score_clockevent;
+	setup_irq(IRQ_TIMER , &timer_irq);
+
+	/* setup COMPARE clockevent */
+	score_clockevent.mult = div_sc(SYSTEM_CLOCK, NSEC_PER_SEC,
+					score_clockevent.shift);
+	score_clockevent.max_delta_ns = clockevent_delta2ns((u32)~0,
+					&score_clockevent);
+	score_clockevent.min_delta_ns = clockevent_delta2ns(50,
+						&score_clockevent) + 1;
+	score_clockevent.cpumask = cpumask_of(0);
+	clockevents_register_device(&score_clockevent);
+}
diff --git a/arch/score/kernel/traps.c b/arch/score/kernel/traps.c
new file mode 100644
index 0000000..0e46fb1
--- /dev/null
+++ b/arch/score/kernel/traps.c
@@ -0,0 +1,349 @@
+/*
+ * arch/score/kernel/traps.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/cacheflush.h>
+#include <asm/irq.h>
+#include <asm/irq_regs.h>
+
+unsigned long exception_handlers[32];
+
+/*
+ * The architecture-independent show_stack generator
+ */
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	int i;
+	long stackdata;
+
+	sp = sp ? sp : (unsigned long *)&sp;
+
+	printk(KERN_NOTICE "Stack: ");
+	i = 1;
+	while ((long) sp & (PAGE_SIZE - 1)) {
+		if (i && ((i % 8) == 0))
+			printk(KERN_NOTICE "\n");
+		if (i > 40) {
+			printk(KERN_NOTICE " ...");
+			break;
+		}
+
+		if (__get_user(stackdata, sp++)) {
+			printk(KERN_NOTICE " (Bad stack address)");
+			break;
+		}
+
+		printk(KERN_NOTICE " %08lx", stackdata);
+		i++;
+	}
+	printk(KERN_NOTICE "\n");
+}
+
+static void show_trace(long *sp)
+{
+	int i;
+	long addr;
+
+	sp = sp ? sp : (long *) &sp;
+
+	printk(KERN_NOTICE "Call Trace:  ");
+	i = 1;
+	while ((long) sp & (PAGE_SIZE - 1)) {
+		if (__get_user(addr, sp++)) {
+			if (i && ((i % 6) == 0))
+				printk(KERN_NOTICE "\n");
+			printk(KERN_NOTICE " (Bad stack address)\n");
+			break;
+		}
+
+		if (kernel_text_address(addr)) {
+			if (i && ((i % 6) == 0))
+				printk(KERN_NOTICE "\n");
+			if (i > 40) {
+				printk(KERN_NOTICE " ...");
+				break;
+			}
+
+			printk(KERN_NOTICE " [<%08lx>]", addr);
+			i++;
+		}
+	}
+	printk(KERN_NOTICE "\n");
+}
+
+static void show_code(unsigned int *pc)
+{
+	long i;
+
+	printk(KERN_NOTICE "\nCode:");
+
+	for (i = -3; i < 6; i++) {
+		unsigned long insn;
+		if (__get_user(insn, pc + i)) {
+			printk(KERN_NOTICE " (Bad address in epc)\n");
+			break;
+		}
+		printk(KERN_NOTICE "%c%08lx%c", (i ? ' ' : '<'),
+			insn, (i ? ' ' : '>'));
+	}
+}
+
+/*
+ * FIXME: really the generic show_regs should take a const pointer argument.
+ */
+void show_regs(struct pt_regs *regs)
+{
+	printk("r0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+		regs->regs[0], regs->regs[1], regs->regs[2], regs->regs[3],
+		regs->regs[4], regs->regs[5], regs->regs[6], regs->regs[7]);
+	printk("r8 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+		regs->regs[8], regs->regs[9], regs->regs[10], regs->regs[11],
+		regs->regs[12], regs->regs[13], regs->regs[14], regs->regs[15]);
+	printk("r16: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+		regs->regs[16], regs->regs[17], regs->regs[18], regs->regs[19],
+		regs->regs[20], regs->regs[21], regs->regs[22], regs->regs[23]);
+	printk("r24: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+		regs->regs[24], regs->regs[25], regs->regs[26], regs->regs[27],
+		regs->regs[28], regs->regs[29], regs->regs[30], regs->regs[31]);
+
+	printk("CEH : %08lx\n", regs->ceh);
+	printk("CEL : %08lx\n", regs->cel);
+
+	printk("EMA:%08lx, epc:%08lx %s\nPSR: %08lx\nECR:%08lx\nCondition : %08lx\n",
+		regs->cp0_ema, regs->cp0_epc, print_tainted(), regs->cp0_psr,
+		regs->cp0_ecr, regs->cp0_condition);
+}
+
+static void show_registers(struct pt_regs *regs)
+{
+	show_regs(regs);
+	printk(KERN_NOTICE "Process %s (pid: %d, stackpage=%08lx)\n",
+		current->comm, current->pid, (unsigned long) current);
+	show_stack(current_thread_info()->task, (long *) regs->regs[0]);
+	show_trace((long *) regs->regs[0]);
+	show_code((unsigned int *) regs->cp0_epc);
+	printk(KERN_NOTICE "\n");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	show_stack(current_thread_info()->task,
+		   (long *) get_irq_regs()->regs[0]);
+}
+EXPORT_SYMBOL(dump_stack);
+
+void __die(const char *str, struct pt_regs *regs, const char *file,
+	const char *func, unsigned long line)
+{
+	console_verbose();
+	printk("%s", str);
+	if (file && func)
+		printk(" in %s:%s, line %ld", file, func, line);
+	printk(":\n");
+	show_registers(regs);
+	do_exit(SIGSEGV);
+}
+
+void __die_if_kernel(const char *str, struct pt_regs *regs,
+		const char *file, const char *func, unsigned long line)
+{
+	if (!user_mode(regs))
+		__die(str, regs, file, func, line);
+}
+
+asmlinkage void do_adelinsn(struct pt_regs *regs)
+{
+	printk("do_ADE-linsn:ema:0x%08lx:epc:0x%08lx\n",
+		 regs->cp0_ema, regs->cp0_epc);
+	die_if_kernel("do_ade execution Exception\n", regs);
+	force_sig(SIGBUS, current);
+}
+
+asmlinkage void do_adedata(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+	fixup = search_exception_tables(regs->cp0_epc);
+	if (fixup) {
+		regs->cp0_epc = fixup->fixup;
+		return;
+	}
+	printk("do_ADE-data:ema:0x%08lx:epc:0x%08lx\n",
+		 regs->cp0_ema, regs->cp0_epc);
+	die_if_kernel("do_ade execution Exception\n", regs);
+	force_sig(SIGBUS, current);
+}
+
+asmlinkage void do_pel(struct pt_regs *regs)
+{
+	die_if_kernel("do_pel execution Exception", regs);
+	force_sig(SIGFPE, current);
+}
+
+asmlinkage void do_cee(struct pt_regs *regs)
+{
+	die_if_kernel("do_cee execution Exception", regs);
+	force_sig(SIGFPE, current);
+}
+
+asmlinkage void do_cpe(struct pt_regs *regs)
+{
+	die_if_kernel("do_cpe execution Exception", regs);
+	force_sig(SIGFPE, current);
+}
+
+asmlinkage void do_be(struct pt_regs *regs)
+{
+	die_if_kernel("do_be execution Exception", regs);
+	force_sig(SIGBUS, current);
+}
+
+asmlinkage void do_ov(struct pt_regs *regs)
+{
+	siginfo_t info;
+
+	die_if_kernel("do_ov execution Exception", regs);
+
+	info.si_code = FPE_INTOVF;
+	info.si_signo = SIGFPE;
+	info.si_errno = 0;
+	info.si_addr = (void *)regs->cp0_epc;
+	force_sig_info(SIGFPE, &info, current);
+}
+
+asmlinkage void do_tr(struct pt_regs *regs)
+{
+	die_if_kernel("do_tr execution Exception", regs);
+	force_sig(SIGTRAP, current);
+}
+
+asmlinkage void do_ri(struct pt_regs *regs)
+{
+	unsigned long epc_insn;
+	unsigned long epc = regs->cp0_epc;
+
+	read_tsk_long(current, epc, &epc_insn);
+	if (current->thread.single_step == 1) {
+		if ((epc == current->thread.addr1) ||
+		    (epc == current->thread.addr2)) {
+			user_disable_single_step(current);
+			force_sig(SIGTRAP, current);
+			return;
+		} else
+			BUG();
+	} else if ((epc_insn == BREAKPOINT32_INSN) ||
+		   ((epc_insn & 0x0000FFFF) == 0x7002) ||
+		   ((epc_insn & 0xFFFF0000) == 0x70020000)) {
+			force_sig(SIGTRAP, current);
+			return;
+	} else {
+		die_if_kernel("do_ri execution Exception", regs);
+		force_sig(SIGILL, current);
+	}
+}
+
+asmlinkage void do_ccu(struct pt_regs *regs)
+{
+	die_if_kernel("do_ccu execution Exception", regs);
+	force_sig(SIGILL, current);
+}
+
+asmlinkage void do_reserved(struct pt_regs *regs)
+{
+	/*
+	 * Game over - no way to handle this if it ever occurs.  Most probably
+	 * caused by a new unknown cpu type or after another deadly
+	 * hard/software error.
+	 */
+	die_if_kernel("do_reserved execution Exception", regs);
+	show_regs(regs);
+	panic("Caught reserved exception - should not happen.");
+}
+
+/*
+ * NMI exception handler.
+ */
+void nmi_exception_handler(struct pt_regs *regs)
+{
+	die_if_kernel("nmi_exception_handler execution Exception", regs);
+	die("NMI", regs);
+}
+
+/* Install CPU exception handler */
+void *set_except_vector(int n, void *addr)
+{
+	unsigned long handler = (unsigned long) addr;
+	unsigned long old_handler = exception_handlers[n];
+
+	exception_handlers[n] = handler;
+	return (void *)old_handler;
+}
+
+void __init trap_init(void)
+{
+	int i;
+
+	pgd_current = (unsigned long)init_mm.pgd;
+	/* DEBUG EXCEPTION */
+	memcpy((void *)DEBUG_VECTOR_BASE_ADDR,
+			&debug_exception_vector, DEBUG_VECTOR_SIZE);
+	/* NMI EXCEPTION */
+	memcpy((void *)GENERAL_VECTOR_BASE_ADDR,
+			&general_exception_vector, GENERAL_VECTOR_SIZE);
+
+	/*
+	 * Initialise exception handlers
+	 */
+	for (i = 0; i <= 31; i++)
+		set_except_vector(i, handle_reserved);
+
+	set_except_vector(1, handle_nmi);
+	set_except_vector(2, handle_adelinsn);
+	set_except_vector(3, handle_tlb_refill);
+	set_except_vector(4, handle_tlb_invaild);
+	set_except_vector(5, handle_ibe);
+	set_except_vector(6, handle_pel);
+	set_except_vector(7, handle_sys);
+	set_except_vector(8, handle_ccu);
+	set_except_vector(9, handle_ri);
+	set_except_vector(10, handle_tr);
+	set_except_vector(11, handle_adedata);
+	set_except_vector(12, handle_adedata);
+	set_except_vector(13, handle_tlb_refill);
+	set_except_vector(14, handle_tlb_invaild);
+	set_except_vector(15, handle_mod);
+	set_except_vector(16, handle_cee);
+	set_except_vector(17, handle_cpe);
+	set_except_vector(18, handle_dbe);
+	flush_icache_range(DEBUG_VECTOR_BASE_ADDR, IRQ_VECTOR_BASE_ADDR);
+
+	atomic_inc(&init_mm.mm_count);
+	current->active_mm = &init_mm;
+	cpu_cache_init();
+}
-- 
1.6.2



