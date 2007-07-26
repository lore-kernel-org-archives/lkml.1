Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbXGZSRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbXGZSRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936152AbXGZSQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:16:52 -0400
Received: from users.ccur.com ([66.10.65.2]:56392 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935876AbXGZSQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:16:50 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 14:16:47 EDT
Date: Thu, 26 Jul 2007 14:05:22 -0400
From: Joe Korty <joe.korty@ccur.com>
To: mingo@elte.hu
Cc: tglx@linutronix.de, sdietrich@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, jason.baietto@ccur.com
Subject: [PATCH] create /proc/all-interrupts
Message-ID: <20070726180522.GA1486@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create /proc/all-interrupts for some architectures.

Create a version of /proc/interrupts that displays _every_
IRQ vector, not just those that someone thought might be
interesting, and add an entry in the commentary column
for those vectors which lacked such a comment.

Rationale: /proc/interrupts is not truly useful unless it
displays every IRQ vector, not just those somebody thought
would be interesting.  For example, since /proc/interrupts
does not display the rescheduling interrupt, the occurance
of rescheduling interrupt floods ends up affecting
latencies, yet without an entry in /proc/interrupts, it
is difficult to discern why latencies are being affected.

Rather than modify /proc/interrupts, this patch creates
a new version of /proc/interrupts, on the off-chance
that adding new lines to /proc/interrupts, and appending
new fields to the end of old lines, might break some
longstanding script.  However, these kinds of changes
traditionally do not affect scripts, so it might be
reasonable to fold /proc/all-interrupts back into
/proc/interrupts.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.22.1-rt8/arch/i386/kernel/apic.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/apic.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/apic.c	2007-07-26 11:57:14.000000000 -0400
@@ -1268,6 +1268,8 @@
 {
 	unsigned long v;
 
+	atomic_inc(&__get_cpu_var(irq_spur_counts));
+
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1297,7 +1299,7 @@
 	apic_write(APIC_ESR, 0);
 	v1 = apic_read(APIC_ESR);
 	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
+	atomic_inc(&__get_cpu_var(irq_err_counts));
 
 	/* Here is what the APIC error bits mean:
 	   0: Send CS error
Index: 2.6.22.1-rt8/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-26 11:57:14.000000000 -0400
@@ -60,6 +60,7 @@
 fastcall void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
+	atomic_inc(&__get_cpu_var(irq_thermal_counts));
 	vendor_thermal_interrupt(regs);
 	irq_exit();
 }
Index: 2.6.22.1-rt8/arch/i386/kernel/i8259.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/i8259.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/i8259.c	2007-07-26 11:57:14.000000000 -0400
@@ -209,7 +209,7 @@
 			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
-		atomic_inc(&irq_err_count);
+		atomic_inc(&__get_cpu_var(irq_err_counts));
 		/*
 		 * Theoretically we do not have to handle this IRQ,
 		 * but in Linux this does not cause problems and is
Index: 2.6.22.1-rt8/arch/i386/kernel/io_apic.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/io_apic.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/io_apic.c	2007-07-26 11:57:14.000000000 -0400
@@ -51,7 +51,6 @@
 #include "io_ports.h"
 
 int (*ioapic_renumber_irq)(int ioapic, int irq);
-atomic_t irq_mis_count;
 
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
@@ -2031,7 +2030,7 @@
 	ack_APIC_irq();
 
 	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
+		atomic_inc(&__get_cpu_var(irq_mis_counts));
 		spin_lock(&ioapic_lock);
 		/* mask = 1, trigger = 0 */
 		__modify_IO_APIC_irq(irq, 0x00010000, 0x00008000);
Index: 2.6.22.1-rt8/arch/i386/kernel/irq.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/irq.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/irq.c	2007-07-26 13:13:22.000000000 -0400
@@ -12,6 +12,8 @@
 
 #include <linux/module.h>
 #include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/notifier.h>
@@ -252,15 +254,22 @@
  * Interrupt statistics:
  */
 
-atomic_t irq_err_count;
+DEFINE_PER_CPU(atomic_t, irq_resched_counts);
+DEFINE_PER_CPU(atomic_t, irq_call_counts);
+DEFINE_PER_CPU(atomic_t, irq_spur_counts);
+DEFINE_PER_CPU(atomic_t, irq_tlb_counts);
+DEFINE_PER_CPU(atomic_t, irq_thermal_counts);
+DEFINE_PER_CPU(atomic_t, irq_err_counts);
+DEFINE_PER_CPU(atomic_t, irq_mis_counts);
 
 /*
- * /proc/interrupts printing:
+ * /proc/interrupts and /proc/all-interrupts printing.  Done this
+ * way to preserve the original /proc/interrupts layout.
  */
 
-int show_interrupts(struct seq_file *p, void *v)
+int show_selected_interrupts(struct seq_file *p, int i, int full)
 {
-	int i = *(loff_t *) v, j;
+	int j;
 	struct irqaction * action;
 	unsigned long flags;
 
@@ -297,22 +306,162 @@
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", nmi_count(j));
+		if (full)
+			seq_printf(p, "  Non-maskable interrupts");
 		seq_putc(p, '\n');
+
 #ifdef CONFIG_X86_LOCAL_APIC
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).apic_timer_irqs);
+		if (full)
+			seq_printf(p, "  Local interrupts");
 		seq_putc(p, '\n');
 #endif
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
-#if defined(CONFIG_X86_IO_APIC)
-		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
+#ifdef CONFIG_SMP
+#ifdef RESCHEDULE_VECTOR
+		if (full) {
+			seq_printf(p, "RES: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_resched_counts, j)));
+			seq_printf(p, "  Rescheduling interrupts\n");
+		}
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef CALL_FUNCTION_VECTOR
+		if (full) {
+			seq_printf(p, "CAL: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_call_counts, j)));
+			seq_printf(p, "  function call interrupts\n");
+		}
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef INVALIDATE_TLB_VECTOR
+		if (full) {
+			seq_printf(p, "TLB: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_tlb_counts, j)));
+			seq_printf(p, "  TLB shootdowns\n");
+		}
+#endif
+#endif
+#ifdef THERMAL_APIC_VECTOR
+		if (full) {
+			seq_printf(p, "TRM: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_thermal_counts, j)));
+			seq_printf(p, "  Thermal event interrupts\n");
+		}
+#endif
+#ifdef SPURIOUS_APIC_VECTOR
+		if (full) {
+			seq_printf(p, "SPU: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_spur_counts, j)));
+			seq_printf(p, "  Spurious interrupts\n");
+		}
+#endif
+#ifdef ERROR_APIC_VECTOR
+		seq_printf(p, "ERR: ");
+		if (full) {
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_err_counts, j)));
+			seq_printf(p, "  Error interrupts\n");
+		} else {
+			unsigned count = 0;
+			for_each_online_cpu(j)
+				count += atomic_read(&per_cpu(irq_err_counts, j));
+			seq_printf(p, "%10u\n", count);
+		}
+#endif
+#if defined(CONFIG_X86_IO_APIC) && defined(APIC_MISMATCH_DEBUG)
+		seq_printf(p, "MIS: ");
+		if (full) {
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ",
+					atomic_read(&per_cpu(irq_mis_counts, j)));
+			seq_printf(p, "  APIC mismatch fixups\n");
+		} else {
+			unsigned count = 0;
+			for_each_online_cpu(j)
+				count += atomic_read(&per_cpu(irq_mis_counts, j)));
+			seq_printf(p, "%10u\n");
+		}
 #endif
 	}
 	return 0;
 }
 
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i  = *(loff_t *)v;
+	return show_selected_interrupts(p, i, 0);
+}
+
+int show_all_interrupts(struct seq_file *p, void *v)
+{
+	int i  = *(loff_t *)v;
+	return show_selected_interrupts(p, i, 1);
+}
+
+static void *show_irq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos <= NR_IRQS) ? pos : NULL;
+}
+
+static void *show_irq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos > NR_IRQS)
+		return NULL;
+	return pos;
+}
+
+static void show_irq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static struct seq_operations show_all_interrupts_ops = {
+	.start = show_irq_start,
+	.next  = show_irq_next,
+	.stop  = show_irq_stop,
+	.show  = show_all_interrupts
+};
+
+static int show_all_interrupts_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &show_all_interrupts_ops);
+}
+
+static const struct file_operations show_all_interrupts_proc_ops = {
+	.open		= show_all_interrupts_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init show_all_interrupts_register(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = create_proc_entry("all-interrupts", 0, NULL);
+	if (entry)
+		entry->proc_fops = &show_all_interrupts_proc_ops;
+	return 0;
+}
+core_initcall(show_all_interrupts_register);
+
 #ifdef CONFIG_HOTPLUG_CPU
 #include <mach_apic.h>
 
Index: 2.6.22.1-rt8/arch/i386/kernel/smp.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/smp.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/smp.c	2007-07-26 11:57:14.000000000 -0400
@@ -315,6 +315,7 @@
 	unsigned long cpu;
 
 	cpu = get_cpu();
+	atomic_inc(&__get_cpu_var(irq_tlb_counts));
 
 	if (!cpu_isset(cpu, flush_cpumask))
 		goto out;
@@ -658,6 +659,7 @@
 {
 	trace_special(regs->eip, 0, 0);
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_resched_counts));
 	set_tsk_need_resched(current);
 }
 
@@ -668,6 +670,7 @@
 	int wait = call_data->wait;
 
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_call_counts));
 	/*
 	 * Notify initiating CPU that I've grabbed the data and am
 	 * about to execute the function
Index: 2.6.22.1-rt8/arch/x86_64/kernel/apic.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/apic.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/apic.c	2007-07-26 11:57:14.000000000 -0400
@@ -1099,6 +1099,9 @@
 asmlinkage void smp_spurious_interrupt(void)
 {
 	unsigned int v;
+
+	atomic_inc(&__get_cpu_var(irq_spur_counts));
+
 	exit_idle();
 	irq_enter();
 	/*
@@ -1127,7 +1130,7 @@
 	apic_write(APIC_ESR, 0);
 	v1 = apic_read(APIC_ESR);
 	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
+	atomic_inc(&__get_cpu_var(irq_err_counts));
 
 	/* Here is what the APIC error bits mean:
 	   0: Send CS error
Index: 2.6.22.1-rt8/arch/x86_64/kernel/i8259.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/i8259.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/i8259.c	2007-07-26 11:57:14.000000000 -0400
@@ -273,7 +273,7 @@
 			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
-		atomic_inc(&irq_err_count);
+		atomic_inc(&__get_cpu_var(irq_err_counts));
 		/*
 		 * Theoretically we do not have to handle this IRQ,
 		 * but in Linux this does not cause problems and is
Index: 2.6.22.1-rt8/arch/x86_64/kernel/irq.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/irq.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/irq.c	2007-07-26 12:29:50.000000000 -0400
@@ -13,6 +13,8 @@
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <asm/uaccess.h>
@@ -20,7 +22,18 @@
 #include <asm/idle.h>
 #include <asm/smp.h>
 
-atomic_t irq_err_count;
+DEFINE_PER_CPU(atomic_t, irq_resched_counts);
+DEFINE_PER_CPU(atomic_t, irq_call_counts);
+DEFINE_PER_CPU(atomic_t, irq_spur_counts);
+DEFINE_PER_CPU(atomic_t, irq_tlb_counts);
+DEFINE_PER_CPU(atomic_t, irq_threshold_counts);
+DEFINE_PER_CPU(atomic_t, irq_thermal_counts);
+DEFINE_PER_CPU(atomic_t, irq_err_counts);
+#ifdef CONFIG_X86_IO_APIC
+#ifdef APIC_MISMATCH_DEBUG
+DEFINE_PER_CPU(atomic_t, irq_mis_counts);
+#endif
+#endif
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 /*
@@ -47,12 +60,13 @@
 #endif
 
 /*
- * Generic, controller-independent functions:
+ * /proc/interrupts and /proc/all-interrupts printing.  Done this
+ * way to preserve the original /proc/interrupts layout.
  */
 
-int show_interrupts(struct seq_file *p, void *v)
+int show_selected_interrupts(struct seq_file *p, int i, int full)
 {
-	int i = *(loff_t *) v, j;
+	int j;
 	struct irqaction * action;
 	unsigned long flags;
 
@@ -88,16 +102,163 @@
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
+		if (full)
+			seq_printf(p, "  Non-maskable interrupts");
 		seq_putc(p, '\n');
+
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->apic_timer_irqs);
+		if (full)
+			seq_printf(p, "  Local interrupts");
 		seq_putc(p, '\n');
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
+
+#ifdef CONFIG_SMP
+#ifdef RESCHEDULE_VECTOR
+		if (full) {
+			seq_printf(p, "RES: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_resched_counts, j)));
+			seq_printf(p, "  Rescheduling interrupts\n");
+		}
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef CALL_FUNCTION_VECTOR
+		if (full) {
+			seq_printf(p, "CAL: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_call_counts, j)));
+			seq_printf(p, "  function call interrupts\n");
+		}
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef INVALIDATE_TLB_VECTOR_START
+		if (full) {
+			seq_printf(p, "TLB: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_tlb_counts, j)));
+			seq_printf(p, "  TLB shootdowns\n");
+		}
+#endif
+#endif
+#ifdef THERMAL_APIC_VECTOR
+		if (full) {
+			seq_printf(p, "TRM: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_thermal_counts, j)));
+			seq_printf(p, "  Thermal event interrupts\n");
+		}
+#endif
+#ifdef THRESHOLD_APIC_VECTOR
+		if (full) {
+			seq_printf(p, "THR: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_threshold_counts, j)));
+			seq_printf(p, "  Threshold APIC interrupts\n");
+		}
+#endif
+#ifdef SPURIOUS_APIC_VECTOR
+		if (full) {
+			seq_printf(p, "SPU: ");
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_spur_counts, j)));
+			seq_printf(p, "  Spurious interrupts\n");
+		}
+#endif
+#ifdef ERROR_APIC_VECTOR
+		seq_printf(p, "ERR: ");
+		if (full) {
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_err_counts, j)));
+			seq_printf(p, "  Error interrupts\n");
+		} else {
+			unsigned count = 0;
+			for_each_online_cpu(j)
+				count += atomic_read(&per_cpu(irq_err_counts, j));
+			seq_printf(p, "%10u\n", count);
+		}
+#endif
+#ifdef CONFIG_X86_IO_APIC
+#ifdef APIC_MISMATCH_DEBUG
+		seq_printf(p, "MIS: ");
+		if (full) {
+			for_each_online_cpu(j)
+				seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_mis_counts, j)));
+			seq_printf(p, "  APIC mismatch fixups\n");
+		} else {
+			unsigned count = 0;
+			for_each_online_cpu(j)
+				count += atomic_read(&per_cpu(irq_mis_counts, j));
+			seq_printf(p, "%10u\n", count);
+		}
+#endif
+#endif
 	}
 	return 0;
 }
 
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i  = *(loff_t *)v;
+	return show_selected_interrupts(p, i, 0);
+}
+
+static int show_all_interrupts(struct seq_file *p, void *v)
+{
+	int i  = *(loff_t *)v;
+	return show_selected_interrupts(p, i, 1);
+}
+
+static void *show_irq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos <= NR_IRQS) ? pos : NULL;
+}
+
+static void *show_irq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos > NR_IRQS)
+		return NULL;
+	return pos;
+}
+
+static void show_irq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+static struct seq_operations show_all_interrupts_ops = {
+	.start = show_irq_start,
+	.next  = show_irq_next,
+	.stop  = show_irq_stop,
+	.show  = show_all_interrupts
+};
+
+static int show_all_interrupts_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &show_all_interrupts_ops);
+}
+
+static const struct file_operations show_all_interrupts_proc_ops = {
+	.open		= show_all_interrupts_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init show_all_interrupts_register(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = create_proc_entry("all-interrupts", 0, NULL);
+	if (entry)
+		entry->proc_fops = &show_all_interrupts_proc_ops;
+	return 0;
+}
+core_initcall(show_all_interrupts_register);
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
Index: 2.6.22.1-rt8/arch/x86_64/kernel/mce_amd.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/mce_amd.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/mce_amd.c	2007-07-26 11:57:14.000000000 -0400
@@ -186,6 +186,8 @@
 	exit_idle();
 	irq_enter();
 
+	atomic_inc(&__get_cpu_var(irq_threshold_counts));
+
 	memset(&m, 0, sizeof(m));
 	rdtscll(m.tsc);
 	m.cpu = smp_processor_id();
Index: 2.6.22.1-rt8/arch/x86_64/kernel/mce_intel.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/mce_intel.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/mce_intel.c	2007-07-26 11:57:14.000000000 -0400
@@ -21,6 +21,7 @@
 
 	exit_idle();
 	irq_enter();
+	atomic_inc(&__get_cpu_var(irq_thermal_counts));
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & 1))
Index: 2.6.22.1-rt8/include/asm-i386/apic.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-i386/apic.h	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-i386/apic.h	2007-07-26 11:57:14.000000000 -0400
@@ -7,6 +7,7 @@
 #include <asm/apicdef.h>
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/atomic.h>
 
 #define Dprintk(x...)
 
@@ -118,6 +119,9 @@
 
 extern void smp_send_nmi_allbutself(void);
 
+DECLARE_PER_CPU(atomic_t, irq_spur_counts);
+DECLARE_PER_CPU(atomic_t, irq_thermal_counts);
+
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
 
Index: 2.6.22.1-rt8/include/asm-i386/hw_irq.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-i386/hw_irq.h	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-i386/hw_irq.h	2007-07-26 11:57:14.000000000 -0400
@@ -13,6 +13,7 @@
  */
 
 #include <linux/profile.h>
+#include <linux/percpu.h>
 #include <asm/atomic.h>
 #include <asm/irq.h>
 #include <asm/sections.h>
@@ -58,8 +59,11 @@
 
 extern unsigned long io_apic_irqs;
 
-extern atomic_t irq_err_count;
-extern atomic_t irq_mis_count;
+DECLARE_PER_CPU(atomic_t, irq_resched_counts);
+DECLARE_PER_CPU(atomic_t, irq_call_counts);
+DECLARE_PER_CPU(atomic_t, irq_tlb_counts);
+DECLARE_PER_CPU(atomic_t, irq_err_counts);
+DECLARE_PER_CPU(atomic_t, irq_mis_counts);
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
Index: 2.6.22.1-rt8/include/asm-x86_64/apic.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-x86_64/apic.h	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-x86_64/apic.h	2007-07-26 11:57:14.000000000 -0400
@@ -6,6 +6,7 @@
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/system.h>
+#include <asm/atomic.h>
 
 #define Dprintk(x...)
 
@@ -101,4 +102,7 @@
 extern unsigned boot_cpu_id;
 extern int local_apic_timer_c2_ok;
 
+DECLARE_PER_CPU(atomic_t, irq_spur_counts);
+DECLARE_PER_CPU(atomic_t, irq_thermal_counts);
+
 #endif /* __ASM_APIC_H */
Index: 2.6.22.1-rt8/include/asm-x86_64/hw_irq.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-x86_64/hw_irq.h	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-x86_64/hw_irq.h	2007-07-26 11:57:14.000000000 -0400
@@ -123,8 +123,12 @@
 
 extern unsigned long io_apic_irqs;
 
-extern atomic_t irq_err_count;
-extern atomic_t irq_mis_count;
+DECLARE_PER_CPU(atomic_t, irq_resched_counts);
+DECLARE_PER_CPU(atomic_t, irq_call_counts);
+DECLARE_PER_CPU(atomic_t, irq_tlb_counts);
+DECLARE_PER_CPU(atomic_t, irq_threshold_counts);
+DECLARE_PER_CPU(atomic_t, irq_err_counts);
+DECLARE_PER_CPU(atomic_t, irq_mis_counts);
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
Index: 2.6.22.1-rt8/arch/x86_64/kernel/smp.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/smp.c	2007-07-26 11:57:13.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/smp.c	2007-07-26 11:57:14.000000000 -0400
@@ -133,6 +133,8 @@
 	int sender;
 	union smp_flush_state *f;
 
+	atomic_inc(&__get_cpu_var(irq_tlb_counts));
+
 	cpu = smp_processor_id();
 	/*
 	 * orig_rax contains the negated interrupt vector.
@@ -508,6 +510,7 @@
 asmlinkage void smp_reschedule_interrupt(void)
 {
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_resched_counts));
 }
 
 asmlinkage void smp_call_function_interrupt(void)
@@ -517,6 +520,7 @@
 	int wait = call_data->wait;
 
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_call_counts));
 	/*
 	 * Notify initiating CPU that I've grabbed the data and am
 	 * about to execute the function
Index: 2.6.22.1-rt8/Documentation/filesystems/proc.txt
===================================================================
--- 2.6.22.1-rt8.orig/Documentation/filesystems/proc.txt	2007-07-08 19:32:17.000000000 -0400
+++ 2.6.22.1-rt8/Documentation/filesystems/proc.txt	2007-07-26 13:02:17.000000000 -0400
@@ -295,7 +295,15 @@
 the IO-APIC automatically retry the transmission, so it should not be a big
 problem, but you should read the SMP-FAQ.
 
-In this context it could be interesting to note the new irq directory in 2.4.
+In 2.6.* a new file, /proc/all-interrupts appears on some architectures.
+This adds to the /proc/interrupts output all the system interrupt vectors
+that /proc/interrupts missed, and it fills in the commentary field for each
+system vector that lacked it.  This added functionality was made a seperate
+file, rather than merged into /proc/interrupts, as /proc/interrupts has
+not changed in a long time, thus raising the specter that _any_ change
+might break ancient, longstanding scripts and programs.
+
+An interesting addition to 2.4 is the new irq directory.
 It could be used to set IRQ to CPU affinity, this means that you can "hook" an
 IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
 irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
