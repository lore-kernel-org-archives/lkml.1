Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZKTODA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZKTODA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZKTOC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:02:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:29379 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZKTOC6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 20 Nov 2009 09:02:58 -0500
Message-Id: <4B06AFA902000078000211F8@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 20 Nov 2009 14:03:05 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: tighten conditionals on MCE related statistics
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_thermal_count is only being maintained when X86_THERMAL_VECTOR, and
both X86_THERMAL_VECTOR and X86_MCE_THRESHOLD don't need extra wrapping
in X86_MCE conditionals.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/hardirq.h |    6 +++---
 arch/x86/kernel/irq.c          |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.32-rc8/arch/x86/include/asm/hardirq.h
+++ 2.6.32-rc8-x86-mce-irq-stat/arch/x86/include/asm/hardirq.h
@@ -20,11 +20,11 @@ typedef struct {
 	unsigned int irq_call_count;
 	unsigned int irq_tlb_count;
 #endif
-#ifdef CONFIG_X86_MCE
+#ifdef CONFIG_X86_THERMAL_VECTOR
 	unsigned int irq_thermal_count;
-# ifdef CONFIG_X86_MCE_THRESHOLD
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
 	unsigned int irq_threshold_count;
-# endif
 #endif
 } ____cacheline_aligned irq_cpustat_t;
 
--- linux-2.6.32-rc8/arch/x86/kernel/irq.c
+++ 2.6.32-rc8-x86-mce-irq-stat/arch/x86/kernel/irq.c
@@ -92,17 +92,17 @@ static int show_other_interrupts(struct 
 		seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  TLB shootdowns\n");
 #endif
-#ifdef CONFIG_X86_MCE
+#ifdef CONFIG_X86_THERMAL_VECTOR
 	seq_printf(p, "%*s: ", prec, "TRM");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
 	seq_printf(p, "  Thermal event interrupts\n");
-# ifdef CONFIG_X86_MCE_THRESHOLD
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
 	seq_printf(p, "  Threshold APIC interrupts\n");
-# endif
 #endif
 #ifdef CONFIG_X86_MCE
 	seq_printf(p, "%*s: ", prec, "MCE");
@@ -194,11 +194,11 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_call_count;
 	sum += irq_stats(cpu)->irq_tlb_count;
 #endif
-#ifdef CONFIG_X86_MCE
+#ifdef CONFIG_X86_THERMAL_VECTOR
 	sum += irq_stats(cpu)->irq_thermal_count;
-# ifdef CONFIG_X86_MCE_THRESHOLD
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
 	sum += irq_stats(cpu)->irq_threshold_count;
-# endif
 #endif
 #ifdef CONFIG_X86_MCE
 	sum += per_cpu(mce_exception_count, cpu);



