Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXD2Rkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXD2Rkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030914AbXD2RbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:15 -0400
Received: from gw.goop.org ([64.81.55.164]:59061 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbXD2RaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:24 -0400
Message-Id: <20070429172913.680009000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 16/32] xen: Add support for preemption
Content-Disposition: inline; filename=xen-preempt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add Xen support for preemption.  This is mostly a cleanup of existing
preempt_enable/disable calls, or just comments to explain the current
usage.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/Kconfig      |    2 
 arch/i386/xen/enlighten.c  |  105 +++++++++++++++++++++++++-------------------
 arch/i386/xen/mmu.c        |    4 +
 arch/i386/xen/multicalls.c |   11 ++--
 arch/i386/xen/time.c       |   22 +++++++--
 5 files changed, 89 insertions(+), 55 deletions(-)

===================================================================
--- a/arch/i386/xen/Kconfig
+++ b/arch/i386/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT && !PREEMPT
+	depends on PARAVIRT
 	default y
 	help
 	  This is the Linux Xen port.
===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/preempt.h>
+#include <linux/hardirq.h>
 #include <linux/percpu.h>
 #include <linux/delay.h>
 #include <linux/start_kernel.h>
@@ -108,11 +109,10 @@ static unsigned long xen_save_fl(void)
 	struct vcpu_info *vcpu;
 	unsigned long flags;
 
-	preempt_disable();
 	vcpu = x86_read_percpu(xen_vcpu);
+
 	/* flag has opposite sense of mask */
 	flags = !vcpu->evtchn_upcall_mask;
-	preempt_enable();
 
 	/* convert to IF type flag
 	   -0 -> 0x00000000
@@ -125,51 +125,56 @@ static void xen_restore_fl(unsigned long
 {
 	struct vcpu_info *vcpu;
 
-	preempt_disable();
-
 	/* convert from IF type flag */
 	flags = !(flags & X86_EFLAGS_IF);
+
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
+	preempt_disable();
 	vcpu = x86_read_percpu(xen_vcpu);
 	vcpu->evtchn_upcall_mask = flags;
+	preempt_enable_no_resched();
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
 
 	if (flags == 0) {
-		/* Unmask then check (avoid races).  We're only protecting
-		   against updates by this CPU, so there's no need for
-		   anything stronger. */
-		barrier();
-
+		preempt_check_resched();
+		barrier(); /* unmask then check (avoid races) */
 		if (unlikely(vcpu->evtchn_upcall_pending))
 			force_evtchn_callback();
-		preempt_enable();
-	} else
-		preempt_enable_no_resched();
+	}
 }
 
 static void xen_irq_disable(void)
 {
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
+	preempt_disable();
+	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
+	preempt_enable_no_resched();
+}
+
+static void xen_irq_enable(void)
+{
 	struct vcpu_info *vcpu;
-	preempt_disable();
-	vcpu = x86_read_percpu(xen_vcpu);
-	vcpu->evtchn_upcall_mask = 1;
-	preempt_enable_no_resched();
-}
-
-static void xen_irq_enable(void)
-{
-	struct vcpu_info *vcpu;
-
+
+	/* There's a one instruction preempt window here.  We need to
+	   make sure we're don't switch CPUs between getting the vcpu
+	   pointer and updating the mask. */
 	preempt_disable();
 	vcpu = x86_read_percpu(xen_vcpu);
 	vcpu->evtchn_upcall_mask = 0;
-
-	/* Unmask then check (avoid races).  We're only protecting
-	   against updates by this CPU, so there's no need for
-	   anything stronger. */
-	barrier();
-
+	preempt_enable_no_resched();
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
+
+	barrier(); /* unmask then check (avoid races) */
 	if (unlikely(vcpu->evtchn_upcall_pending))
 		force_evtchn_callback();
-	preempt_enable();
 }
 
 static void xen_safe_halt(void)
@@ -189,6 +194,8 @@ static void xen_halt(void)
 
 static void xen_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
+	BUG_ON(preemptible());
+
 	switch(mode) {
 	case PARAVIRT_LAZY_NONE:
 		BUG_ON(x86_read_percpu(xen_lazy_mode) == PARAVIRT_LAZY_NONE);
@@ -292,12 +299,17 @@ static void xen_write_ldt_entry(struct d
 	xmaddr_t mach_lp = virt_to_machine(lp);
 	u64 entry = (u64)high << 32 | low;
 
+	preempt_disable();
+
 	xen_mc_flush();
 	if (HYPERVISOR_update_descriptor(mach_lp.maddr, entry))
 		BUG();
-}
-
-static int cvt_gate_to_trap(int vector, u32 low, u32 high, struct trap_info *info)
+
+	preempt_enable();
+}
+
+static int cvt_gate_to_trap(int vector, u32 low, u32 high,
+			    struct trap_info *info)
 {
 	u8 type, dpl;
 
@@ -325,11 +337,13 @@ static DEFINE_PER_CPU(struct Xgt_desc_st
    also update Xen. */
 static void xen_write_idt_entry(struct desc_struct *dt, int entrynum, u32 low, u32 high)
 {
-
-	int cpu = smp_processor_id();
 	unsigned long p = (unsigned long)&dt[entrynum];
-	unsigned long start = per_cpu(idt_desc, cpu).address;
-	unsigned long end = start + per_cpu(idt_desc, cpu).size + 1;
+	unsigned long start, end;
+
+	preempt_disable();
+
+	start = __get_cpu_var(idt_desc).address;
+	end = start + __get_cpu_var(idt_desc).size + 1;
 
 	xen_mc_flush();
 
@@ -344,6 +358,8 @@ static void xen_write_idt_entry(struct d
 			if (HYPERVISOR_set_trap_table(info))
 				BUG();
 	}
+
+	preempt_enable();
 }
 
 static void xen_convert_trap_info(const struct Xgt_desc_struct *desc,
@@ -365,11 +381,9 @@ static void xen_convert_trap_info(const 
 
 void xen_copy_trap_info(struct trap_info *traps)
 {
-	const struct Xgt_desc_struct *desc = &get_cpu_var(idt_desc);
+	const struct Xgt_desc_struct *desc = &__get_cpu_var(idt_desc);
 
 	xen_convert_trap_info(desc, traps);
-
-	put_cpu_var(idt_desc);
 }
 
 /* Load a new IDT into Xen.  In principle this can be per-CPU, so we
@@ -379,11 +393,10 @@ static void xen_load_idt(const struct Xg
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
-	int cpu = smp_processor_id();
-
-	per_cpu(idt_desc, cpu) = *desc;
 
 	spin_lock(&lock);
+
+	__get_cpu_var(idt_desc) = *desc;
 
 	xen_convert_trap_info(desc, traps);
 
@@ -398,6 +411,8 @@ static void xen_load_idt(const struct Xg
    they're handled differently. */
 static void xen_write_gdt_entry(struct desc_struct *dt, int entry, u32 low, u32 high)
 {
+	preempt_disable();
+
 	switch ((high >> 8) & 0xff) {
 	case DESCTYPE_LDT:
 	case DESCTYPE_TSS:
@@ -414,10 +429,12 @@ static void xen_write_gdt_entry(struct d
 	}
 
 	}
+
+	preempt_enable();
 }
 
 static void xen_load_esp0(struct tss_struct *tss,
-				   struct thread_struct *thread)
+			  struct thread_struct *thread)
 {
 	struct multicall_space mcs = xen_mc_entry(0);
 	MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->esp0);
@@ -523,6 +540,8 @@ static unsigned long xen_read_cr3(void)
 
 static void xen_write_cr3(unsigned long cr3)
 {
+	BUG_ON(preemptible());
+
 	if (cr3 == x86_read_percpu(xen_cr3)) {
 		/* just a simple tlb flush */
 		xen_flush_tlb();
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -520,5 +520,7 @@ void xen_exit_mmap(struct mm_struct *mm)
 
 	preempt_enable();
 
+	spin_lock(&mm->page_table_lock);
 	xen_pgd_unpin(mm->pgd);
-}
+	spin_unlock(&mm->page_table_lock);
+}
===================================================================
--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
@@ -20,6 +20,7 @@
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
 #include <linux/percpu.h>
+#include <linux/hardirq.h>
 
 #include <asm/xen/hypercall.h>
 
@@ -39,9 +40,11 @@ DEFINE_PER_CPU(unsigned long, xen_mc_irq
 
 void xen_mc_flush(void)
 {
-	struct mc_buffer *b = &get_cpu_var(mc_buffer);
+	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	int ret = 0;
 	unsigned long flags;
+
+	BUG_ON(preemptible());
 
 	/* Disable interrupts in case someone comes in and queues
 	   something in the middle */
@@ -60,7 +63,6 @@ void xen_mc_flush(void)
 	} else
 		BUG_ON(b->argidx != 0);
 
-	put_cpu_var(mc_buffer);
 	local_irq_restore(flags);
 
 	BUG_ON(ret);
@@ -68,10 +70,11 @@ void xen_mc_flush(void)
 
 struct multicall_space __xen_mc_entry(size_t args)
 {
-	struct mc_buffer *b = &get_cpu_var(mc_buffer);
+	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct multicall_space ret;
 	unsigned argspace = (args + sizeof(u64) - 1) / sizeof(u64);
 
+	BUG_ON(preemptible());
 	BUG_ON(argspace > MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
@@ -83,7 +86,5 @@ struct multicall_space __xen_mc_entry(si
 	ret.args = &b->args[b->argidx];
 	b->argidx += argspace;
 
-	put_cpu_var(mc_buffer);
-
 	return ret;
 }
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -57,7 +57,7 @@ static void get_runstate_snapshot(struct
 	u64 state_time;
 	struct vcpu_runstate_info *state;
 
-	preempt_disable();
+	BUG_ON(preemptible());
 
 	state = &__get_cpu_var(runstate);
 
@@ -72,8 +72,6 @@ static void get_runstate_snapshot(struct
 		*res = *state;
 		barrier();
 	} while(state->state_entry_time != state_time);
-
-	preempt_enable();
 }
 
 static void setup_runstate_info(void)
@@ -142,15 +140,29 @@ unsigned long long xen_sched_clock(void)
 unsigned long long xen_sched_clock(void)
 {
 	struct vcpu_runstate_info state;
-	cycle_t now = xen_clocksource_read();
+	cycle_t now;
+	unsigned long long ret;
+
+	/*
+	 * Ideally sched_clock should be called on a per-cpu basis
+	 * anyway, so preempt should already be disabled, but that's
+	 * not current practice at the moment.
+	 */
+	preempt_disable();
+
+	now = xen_clocksource_read();
 
 	get_runstate_snapshot(&state);
 
 	WARN_ON(state.state != RUNSTATE_running);
 
-	return state.time[RUNSTATE_blocked] +
+	ret = state.time[RUNSTATE_blocked] +
 		state.time[RUNSTATE_running] +
 		(now - state.state_entry_time);
+
+	preempt_enable();
+
+	return ret;
 }
 
 

-- 

