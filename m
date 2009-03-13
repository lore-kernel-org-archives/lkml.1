Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbZCMCe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbZCMCe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZCMCeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:34:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:39513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZCMCeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:34:16 -0400
Date: Fri, 13 Mar 2009 02:33:30 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B911EB.76E4.0078.0@novell.com>
References: <49B911EB.76E4.0078.0@novell.com>
Subject: [tip:x86/apic] x86: smarten /proc/interrupts output
Message-ID: <tip-7a81d9a7da03d2f27840d659f97ef140d032f609@git.kernel.org>
Git-Commit-ID: 7a81d9a7da03d2f27840d659f97ef140d032f609
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:33:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a81d9a7da03d2f27840d659f97ef140d032f609
Gitweb:     http://git.kernel.org/tip/7a81d9a7da03d2f27840d659f97ef140d032f609
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:45:15 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:36:52 +0100

x86: smarten /proc/interrupts output

Impact: change /proc/interrupts output ABI

With the number of interrupts on large systems growing, assumptions on
the width an interrupt number requires when converted to a decimal
string turn invalid. Therefore, calculate the maximum number of digits
dynamically.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B911EB.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/irq.c |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b864341..b8ac3b6 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -45,16 +45,16 @@ void ack_bad_irq(unsigned int irq)
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
@@ -66,40 +66,40 @@ static int show_other_interrupts(struct seq_file *p)
 		seq_printf(p, "  Platform interrupts\n");
 	}
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
@@ -107,19 +107,22 @@ static int show_other_interrupts(struct seq_file *p)
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
@@ -140,7 +143,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	if (!action && !any_count)
 		goto out;
 
-	seq_printf(p, "%3d: ", i);
+	seq_printf(p, "%*d: ", prec, i);
 #ifndef CONFIG_SMP
 	seq_printf(p, "%10u ", kstat_irqs(i));
 #else
