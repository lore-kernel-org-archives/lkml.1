Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZCLMop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZCLMop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZCLMog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:44:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37702 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCLMof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:44:35 -0400
Message-Id: <49B911EB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:45:15 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: smarten /proc/interrupts output
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: readability of kernel provided statistics data

With the number of interrupts on large systems growing, assumptions on
the width an interrupt number requires when converted to a decimal
string turn invalid. Therefore, calculate the maximum number of digits
dynamically.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/irq.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- linux-2.6.29-rc7/arch/x86/kernel/irq.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-show-interrupts/arch/x86/kernel/irq.c	2009-03-05 15:30:06.000000000 +0100
@@ -44,55 +44,55 @@ void ack_bad_irq(unsigned int irq)
 /*
  * /proc/interrupts printing:
  */
-static int show_other_interrupts(struct seq_file *p)
+static int show_other_interrupts(struct seq_file *p, int prec)
 {
 	int j;
 
-	seq_printf(p, "NMI: ");
+	seq_printf(p, "%*s: ", prec, "NMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
 	seq_printf(p, "  Non-maskable interrupts\n");
 #ifdef CONFIG_X86_LOCAL_APIC
-	seq_printf(p, "LOC: ");
+	seq_printf(p, "%*s: ", prec, "LOC");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
 #endif
 #ifdef CONFIG_SMP
-	seq_printf(p, "RES: ");
+	seq_printf(p, "%*s: ", prec, "RES");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_resched_count);
 	seq_printf(p, "  Rescheduling interrupts\n");
-	seq_printf(p, "CAL: ");
+	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count);
 	seq_printf(p, "  Function call interrupts\n");
-	seq_printf(p, "TLB: ");
+	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  TLB shootdowns\n");
 #endif
 #ifdef CONFIG_X86_MCE
-	seq_printf(p, "TRM: ");
+	seq_printf(p, "%*s: ", prec, "TRM");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
 	seq_printf(p, "  Thermal event interrupts\n");
 # ifdef CONFIG_X86_64
-	seq_printf(p, "THR: ");
+	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
 	seq_printf(p, "  Threshold APIC interrupts\n");
 # endif
 #endif
 #ifdef CONFIG_X86_LOCAL_APIC
-	seq_printf(p, "SPU: ");
+	seq_printf(p, "%*s: ", prec, "SPU");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
 #endif
-	seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
+	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
-	seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
+	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
 #endif
 	return 0;
 }
@@ -100,19 +100,22 @@ static int show_other_interrupts(struct 
 int show_interrupts(struct seq_file *p, void *v)
 {
 	unsigned long flags, any_count = 0;
-	int i = *(loff_t *) v, j;
+	int i = *(loff_t *) v, j, prec;
 	struct irqaction *action;
 	struct irq_desc *desc;
 
 	if (i > nr_irqs)
 		return 0;
 
+	for (prec = 3, j = 1000; prec < 10 && j <= nr_irqs; ++prec)
+		j *= 10;
+
 	if (i == nr_irqs)
-		return show_other_interrupts(p);
+		return show_other_interrupts(p, prec);
 
 	/* print header */
 	if (i == 0) {
-		seq_printf(p, "           ");
+		seq_printf(p, "%*s", prec + 8, "");
 		for_each_online_cpu(j)
 			seq_printf(p, "CPU%-8d", j);
 		seq_putc(p, '\n');
@@ -133,7 +136,7 @@ int show_interrupts(struct seq_file *p, 
 	if (!action && !any_count)
 		goto out;
 
-	seq_printf(p, "%3d: ", i);
+	seq_printf(p, "%*d: ", prec, i);
 #ifndef CONFIG_SMP
 	seq_printf(p, "%10u ", kstat_irqs(i));
 #else



