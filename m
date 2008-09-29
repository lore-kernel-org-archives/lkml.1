Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYI2SIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYI2SIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYI2SDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54328 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753969AbYI2SCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180252.721566000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:09 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 19/31] cpumask: clean xen files
Content-Disposition: inline; filename=clean-xen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/xen/enlighten.c |    9 +++++----
 arch/x86/xen/smp.c       |   12 ++++++------
 arch/x86/xen/suspend.c   |    2 +-
 arch/x86/xen/time.c      |    2 +-
 arch/x86/xen/xen-ops.h   |    2 +-
 drivers/xen/events.c     |    6 +++---
 6 files changed, 17 insertions(+), 16 deletions(-)

--- struct-cpumasks.orig/arch/x86/xen/enlighten.c
+++ struct-cpumasks/arch/x86/xen/enlighten.c
@@ -626,16 +626,17 @@ static void xen_flush_tlb_single(unsigne
 	preempt_enable();
 }
 
-static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
+static void xen_flush_tlb_others(const_cpumask_t cpus, struct mm_struct *mm,
 				 unsigned long va)
 {
 	struct {
 		struct mmuext_op op;
-		cpumask_t mask;
+		cpumask_map_t mask;
 	} *args;
-	cpumask_t cpumask = *cpus;
+	cpumask_var_t cpumask;
 	struct multicall_space mcs;
 
+	cpus_copy(cpumask, cpus);
 	/*
 	 * A couple of (to be removed) sanity checks:
 	 *
@@ -653,7 +654,7 @@ static void xen_flush_tlb_others(const c
 
 	mcs = xen_mc_entry(sizeof(*args));
 	args = mcs.args;
-	args->mask = cpumask;
+	cpus_copy(args->mask, cpumask);
 	args->op.arg2.vcpumask = &args->mask;
 
 	if (va == TLB_FLUSH_ALL) {
--- struct-cpumasks.orig/arch/x86/xen/smp.c
+++ struct-cpumasks/arch/x86/xen/smp.c
@@ -33,7 +33,7 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
-cpumask_t xen_cpu_initialized_map;
+cpumask_map_t xen_cpu_initialized_map;
 
 static DEFINE_PER_CPU(int, resched_irq);
 static DEFINE_PER_CPU(int, callfunc_irq);
@@ -192,7 +192,7 @@ static void __init xen_smp_prepare_cpus(
 	if (xen_smp_intr_init(0))
 		BUG();
 
-	xen_cpu_initialized_map = cpumask_of_cpu(0);
+	cpus_copy(xen_cpu_initialized_map, cpumask_of_cpu(0));
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
@@ -408,7 +408,7 @@ static void xen_smp_send_reschedule(int 
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(const cpumask_t *mask, enum ipi_vector vector)
+static void xen_send_IPI_mask(const_cpumask_t mask, enum ipi_vector vector)
 {
 	unsigned cpu;
 
@@ -416,11 +416,11 @@ static void xen_send_IPI_mask(const cpum
 		xen_send_IPI_one(cpu, vector);
 }
 
-static void xen_smp_send_call_function_ipi(const cpumask_t mask)
+static void xen_smp_send_call_function_ipi(const_cpumask_t mask)
 {
 	int cpu;
 
-	xen_send_IPI_mask(&mask, XEN_CALL_FUNCTION_VECTOR);
+	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
@@ -433,7 +433,7 @@ static void xen_smp_send_call_function_i
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(&cpumask_of_cpu(cpu),
+	xen_send_IPI_mask(cpumask_of_cpu(cpu),
 			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
--- struct-cpumasks.orig/arch/x86/xen/suspend.c
+++ struct-cpumasks/arch/x86/xen/suspend.c
@@ -35,7 +35,7 @@ void xen_post_suspend(int suspend_cancel
 			pfn_to_mfn(xen_start_info->console.domU.mfn);
 	} else {
 #ifdef CONFIG_SMP
-		xen_cpu_initialized_map = cpu_online_map;
+		cpus_copy(xen_cpu_initialized_map, cpu_online_map);
 #endif
 		xen_vcpu_restore();
 	}
--- struct-cpumasks.orig/arch/x86/xen/time.c
+++ struct-cpumasks/arch/x86/xen/time.c
@@ -444,7 +444,7 @@ void xen_setup_timer(int cpu)
 	evt = &per_cpu(xen_clock_events, cpu);
 	memcpy(evt, xen_clockevent, sizeof(*evt));
 
-	evt->cpumask = cpumask_of_cpu(cpu);
+	cpus_copy(evt->cpumask, cpumask_of_cpu(cpu));
 	evt->irq = irq;
 
 	setup_runstate_info(cpu);
--- struct-cpumasks.orig/arch/x86/xen/xen-ops.h
+++ struct-cpumasks/arch/x86/xen/xen-ops.h
@@ -58,7 +58,7 @@ void __init xen_init_spinlocks(void);
 __cpuinit void xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 
-extern cpumask_t xen_cpu_initialized_map;
+extern cpumask_map_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
 #endif
--- struct-cpumasks.orig/drivers/xen/events.c
+++ struct-cpumasks/drivers/xen/events.c
@@ -125,7 +125,7 @@ static void bind_evtchn_to_cpu(unsigned 
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_to_desc(irq)->affinity = cpumask_of_cpu(cpu);
+	cpus_copy(irq_to_desc(irq)->affinity, cpumask_of_cpu(cpu));
 #endif
 
 	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
@@ -143,7 +143,7 @@ static void init_evtchn_cpu_bindings(voi
 		struct irq_desc *desc = irq_to_desc(i);
 		if (!desc)
 			continue;
-		desc->affinity = cpumask_of_cpu(0);
+		cpus_copy(desc->affinity, cpumask_of_cpu(0));
 	}
 #endif
 
@@ -610,7 +610,7 @@ static void rebind_irq_to_cpu(unsigned i
 }
 
 
-static void set_affinity_irq(unsigned irq, cpumask_t dest)
+static void set_affinity_irq(unsigned irq, const_cpumask_t dest)
 {
 	unsigned tcpu = cpus_first(dest);
 	rebind_irq_to_cpu(irq, tcpu);

-- 
