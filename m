Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbYGIQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbYGIQwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYGIQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57888 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbYGIQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:30 -0400
Message-Id: <20080709165129.879990000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:33 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 04/15] x86_64: Replace cpu_pda ops with percpu ops
Content-Disposition: inline; filename=zero_based_replace_cpu_pda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Replace cpu_pda(i) references with percpu(pda, i).

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/common_64.c |    2 +-
 arch/x86/kernel/irq_64.c        |   36 ++++++++++++++++++++----------------
 arch/x86/kernel/nmi.c           |    2 +-
 arch/x86/kernel/setup_percpu.c  |    2 +-
 arch/x86/kernel/smpboot.c       |    2 +-
 arch/x86/kernel/traps_64.c      |   11 +++++++----
 6 files changed, 31 insertions(+), 24 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/common_64.c
@@ -477,7 +477,7 @@ __setup("noexec32=", nonx32_setup);
 
 void pda_init(int cpu)
 {
-	struct x8664_pda *pda = cpu_pda(cpu);
+	struct x8664_pda *pda = &per_cpu(pda, cpu);
 
 	/* Setup up data that may be needed in __get_free_pages early */
 	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0));
--- linux-2.6.tip.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6.tip/arch/x86/kernel/irq_64.c
@@ -115,39 +115,43 @@ skip:
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
+			seq_printf(p, "%10u ", per_cpu(pda.__nmi_count, j));
 		seq_printf(p, "  Non-maskable interrupts\n");
 		seq_printf(p, "LOC: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->apic_timer_irqs);
+			seq_printf(p, "%10u ", per_cpu(pda.apic_timer_irqs, j));
 		seq_printf(p, "  Local timer interrupts\n");
 #ifdef CONFIG_SMP
 		seq_printf(p, "RES: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_resched_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_resched_count, j));
 		seq_printf(p, "  Rescheduling interrupts\n");
 		seq_printf(p, "CAL: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_call_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_call_count, j));
 		seq_printf(p, "  function call interrupts\n");
 		seq_printf(p, "TLB: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_count);
+			seq_printf(p, "%10u ", per_cpu(pda.irq_tlb_count, j));
 		seq_printf(p, "  TLB shootdowns\n");
 #endif
 #ifdef CONFIG_X86_MCE
 		seq_printf(p, "TRM: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_thermal_count, j));
 		seq_printf(p, "  Thermal event interrupts\n");
 		seq_printf(p, "THR: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_threshold_count, j));
 		seq_printf(p, "  Threshold APIC interrupts\n");
 #endif
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_count);
+			seq_printf(p, "%10u ",
+				per_cpu(pda.irq_spurious_count, j));
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
@@ -159,19 +163,19 @@ skip:
  */
 u64 arch_irq_stat_cpu(unsigned int cpu)
 {
-	u64 sum = cpu_pda(cpu)->__nmi_count;
+	u64 sum = per_cpu(pda.__nmi_count, cpu);
 
-	sum += cpu_pda(cpu)->apic_timer_irqs;
+	sum += per_cpu(pda.apic_timer_irqs, cpu);
 #ifdef CONFIG_SMP
-	sum += cpu_pda(cpu)->irq_resched_count;
-	sum += cpu_pda(cpu)->irq_call_count;
-	sum += cpu_pda(cpu)->irq_tlb_count;
+	sum += per_cpu(pda.irq_resched_count, cpu);
+	sum += per_cpu(pda.irq_call_count, cpu);
+	sum += per_cpu(pda.irq_tlb_count, cpu);
 #endif
 #ifdef CONFIG_X86_MCE
-	sum += cpu_pda(cpu)->irq_thermal_count;
-	sum += cpu_pda(cpu)->irq_threshold_count;
+	sum += per_cpu(pda.irq_thermal_count, cpu);
+	sum += per_cpu(pda.irq_threshold_count, cpu);
 #endif
-	sum += cpu_pda(cpu)->irq_spurious_count;
+	sum += per_cpu(pda.irq_spurious_count, cpu);
 	return sum;
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/nmi.c
+++ linux-2.6.tip/arch/x86/kernel/nmi.c
@@ -61,7 +61,7 @@ static int endflag __initdata;
 static inline unsigned int get_nmi_count(int cpu)
 {
 #ifdef CONFIG_X86_64
-	return cpu_pda(cpu)->__nmi_count;
+	return per_cpu(pda.__nmi_count, cpu);
 #else
 	return nmi_count(cpu);
 #endif
--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -279,7 +279,7 @@ void __cpuinit numa_set_node(int cpu, in
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
 	if (node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
+		per_cpu(pda.nodenumber, cpu) = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
--- linux-2.6.tip.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.tip/arch/x86/kernel/smpboot.c
@@ -814,7 +814,7 @@ do_rest:
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
+	per_cpu(pda.pcurrent, cpu) = c_idle.idle;
 	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
 	initial_pda = (unsigned long)get_cpu_pda(cpu);
 #endif
--- linux-2.6.tip.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.tip/arch/x86/kernel/traps_64.c
@@ -265,7 +265,8 @@ void dump_trace(struct task_struct *tsk,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
+	unsigned long *irqstack_end =
+		(unsigned long *)per_cpu(pda.irqstackptr, cpu);
 	unsigned used = 0;
 	struct thread_info *tinfo;
 
@@ -399,8 +400,10 @@ _show_stack(struct task_struct *tsk, str
 	unsigned long *stack;
 	int i;
 	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end = (unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack = (unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+	unsigned long *irqstack_end =
+				(unsigned long *)per_cpu(pda.irqstackptr, cpu);
+	unsigned long *irqstack =
+				(unsigned long *)(irqstack_end - IRQSTACKSIZE);
 
 	// debugging aid: "show_stack(NULL, NULL);" prints the
 	// back trace for this cpu.
@@ -464,7 +467,7 @@ void show_registers(struct pt_regs *regs
 	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	struct task_struct *cur = __get_cpu_var(pda.pcurrent);
 	u8 *ip;
 	unsigned int code_prologue = code_bytes * 43 / 64;
 	unsigned int code_len = code_bytes;

-- 
