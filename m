Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZKWSzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZKWSzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZKWSzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:55:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:56012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZKWSzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:55:31 -0500
Date: Mon, 23 Nov 2009 18:54:51 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, yong.y.wang@intel.com,
       arjan@infradead.org, jbeulich@novell.com, ak@linux.intel.com,
       JBeulich@novell.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, yong.y.wang@intel.com,
       arjan@infradead.org, jbeulich@novell.com, suresh.b.siddha@intel.com,
       JBeulich@novell.com, ak@linux.intel.com, tglx@linutronix.de,
       borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <4B06AFA902000078000211F8@vpn.id2.novell.com>
References: <4B06AFA902000078000211F8@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] x86: Tighten conditionals on MCE related statistics
Message-ID: <tip-0444c9bd0cf4e0eb946a7fcaf34765accfa9404a@git.kernel.org>
Git-Commit-ID: 0444c9bd0cf4e0eb946a7fcaf34765accfa9404a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0444c9bd0cf4e0eb946a7fcaf34765accfa9404a
Gitweb:     http://git.kernel.org/tip/0444c9bd0cf4e0eb946a7fcaf34765accfa9404a
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 20 Nov 2009 14:03:05 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 19:40:06 +0100

x86: Tighten conditionals on MCE related statistics

irq_thermal_count is only being maintained when
X86_THERMAL_VECTOR, and both X86_THERMAL_VECTOR and
X86_MCE_THRESHOLD don't need extra wrapping in X86_MCE
conditionals.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Yong Wang <yong.y.wang@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <4B06AFA902000078000211F8@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/hardirq.h |    6 +++---
 arch/x86/kernel/irq.c          |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 82e3e8f..108eb6f 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
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
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 04bbd52..19212cb 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -92,17 +92,17 @@ static int show_other_interrupts(struct seq_file *p, int prec)
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
