Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbYCCRbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbYCCRbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbYCCRQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760026AbYCCRQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:09 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 26/52] create tlb files
Date: Mon,  3 Mar 2008 14:12:54 -0300
Message-Id: <1204564400-17636-27-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-26-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch creates tlb_32.c and tlb_64.c, with
tlb-related functions that used to live in smp*.c files.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/smp_32.c |  235 ---------------------------------------
 arch/x86/kernel/smp_64.c |  275 ----------------------------------------------
 arch/x86/kernel/tlb_32.c |  243 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tlb_64.c |  273 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 517 insertions(+), 511 deletions(-)
 create mode 100644 arch/x86/kernel/tlb_32.c
 create mode 100644 arch/x86/kernel/tlb_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index e3b01f9..362ab6a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_$(BITS).o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index d80623a..d8fdec5 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -104,238 +104,3 @@
  *	or are signal timing bugs worked around in hardware and there's
  *	about nothing of note with C stepping upwards.
  */
-
-DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0, };
-
-#include <mach_ipi.h> /* must come after the send_IPI functions above for inlining */
-
-/*
- *	Smarter SMP flushing macros. 
- *		c/o Linus Torvalds.
- *
- *	These mean you can really definitely utterly forget about
- *	writing to user space from interrupts. (Its not allowed anyway).
- *
- *	Optimizations Manfred Spraul <manfred@colorfullife.com>
- */
-
-static cpumask_t flush_cpumask;
-static struct mm_struct * flush_mm;
-static unsigned long flush_va;
-static DEFINE_SPINLOCK(tlbstate_lock);
-
-/*
- * We cannot call mmdrop() because we are in interrupt context,
- * instead update mm->cpu_vm_mask.
- *
- * We need to reload %cr3 since the page tables may be going
- * away from under us..
- */
-void leave_mm(int cpu)
-{
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
-}
-EXPORT_SYMBOL_GPL(leave_mm);
-
-/*
- *
- * The flush IPI assumes that a thread switch happens in this order:
- * [cpu0: the cpu that switches]
- * 1) switch_mm() either 1a) or 1b)
- * 1a) thread switch to a different mm
- * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
- * 	Stop ipi delivery for the old mm. This is not synchronized with
- * 	the other cpus, but smp_invalidate_interrupt ignore flush ipis
- * 	for the wrong mm, and in the worst case we perform a superfluous
- * 	tlb flush.
- * 1a2) set cpu_tlbstate to TLBSTATE_OK
- * 	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
- *	was in lazy tlb mode.
- * 1a3) update cpu_tlbstate[].active_mm
- * 	Now cpu0 accepts tlb flushes for the new mm.
- * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
- * 	Now the other cpus will send tlb flush ipis.
- * 1a4) change cr3.
- * 1b) thread switch without mm change
- *	cpu_tlbstate[].active_mm is correct, cpu0 already handles
- *	flush ipis.
- * 1b1) set cpu_tlbstate to TLBSTATE_OK
- * 1b2) test_and_set the cpu bit in cpu_vm_mask.
- * 	Atomically set the bit [other cpus will start sending flush ipis],
- * 	and test the bit.
- * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
- * 2) switch %%esp, ie current
- *
- * The interrupt must handle 2 special cases:
- * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
- * - the cpu performs speculative tlb reads, i.e. even if the cpu only
- *   runs in kernel space, the cpu could load tlb entries for user space
- *   pages.
- *
- * The good news is that cpu_tlbstate is local to each cpu, no
- * write/read ordering problems.
- */
-
-/*
- * TLB flush IPI:
- *
- * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
- * 2) Leave the mm if we are in the lazy tlb mode.
- */
-
-void smp_invalidate_interrupt(struct pt_regs *regs)
-{
-	unsigned long cpu;
-
-	cpu = get_cpu();
-
-	if (!cpu_isset(cpu, flush_cpumask))
-		goto out;
-		/* 
-		 * This was a BUG() but until someone can quote me the
-		 * line from the intel manual that guarantees an IPI to
-		 * multiple CPUs is retried _only_ on the erroring CPUs
-		 * its staying as a return
-		 *
-		 * BUG();
-		 */
-		 
-	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
-		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush_va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(flush_va);
-		} else
-			leave_mm(cpu);
-	}
-	ack_APIC_irq();
-	smp_mb__before_clear_bit();
-	cpu_clear(cpu, flush_cpumask);
-	smp_mb__after_clear_bit();
-out:
-	put_cpu_no_resched();
-	__get_cpu_var(irq_stat).irq_tlb_count++;
-}
-
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
-{
-	cpumask_t cpumask = *cpumaskp;
-
-	/*
-	 * A couple of (to be removed) sanity checks:
-	 *
-	 * - current CPU must not be in mask
-	 * - mask must exist :)
-	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
-	BUG_ON(!mm);
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (unlikely(cpus_empty(cpumask)))
-		return;
-#endif
-
-	/*
-	 * i'm not happy about this global shared spinlock in the
-	 * MM hot path, but we'll see how contended it is.
-	 * AK: x86-64 has a faster method that could be ported.
-	 */
-	spin_lock(&tlbstate_lock);
-	
-	flush_mm = mm;
-	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
-	/*
-	 * We have to send the IPI only to
-	 * CPUs affected.
-	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR);
-
-	while (!cpus_empty(flush_cpumask))
-		/* nothing. lockup detection does not belong here */
-		cpu_relax();
-
-	flush_mm = NULL;
-	flush_va = 0;
-	spin_unlock(&tlbstate_lock);
-}
-	
-void flush_tlb_current_task(void)
-{
-	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	preempt_enable();
-}
-
-void flush_tlb_mm (struct mm_struct * mm)
-{
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			leave_mm(smp_processor_id());
-	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_page(struct vm_area_struct * vma, unsigned long va)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if(current->mm)
-			__flush_tlb_one(va);
-		 else
-		 	leave_mm(smp_processor_id());
-	}
-
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
-
-	preempt_enable();
-}
-EXPORT_SYMBOL(flush_tlb_page);
-
-static void do_flush_tlb_all(void* info)
-{
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
-
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
-}
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index d28e868..26448ff 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -8,278 +8,3 @@
  *	This code is released under the GNU General Public License version 2 or
  *	later.
  */
-
-#include <linux/init.h>
-
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/kernel_stat.h>
-#include <linux/mc146818rtc.h>
-#include <linux/interrupt.h>
-
-#include <asm/mtrr.h>
-#include <asm/pgalloc.h>
-#include <asm/tlbflush.h>
-#include <asm/mach_apic.h>
-#include <asm/mmu_context.h>
-#include <asm/proto.h>
-#include <asm/apicdef.h>
-#include <asm/idle.h>
-
-/*
- *	Smarter SMP flushing macros.
- *		c/o Linus Torvalds.
- *
- *	These mean you can really definitely utterly forget about
- *	writing to user space from interrupts. (Its not allowed anyway).
- *
- *	Optimizations Manfred Spraul <manfred@colorfullife.com>
- *
- *	More scalable flush, from Andi Kleen
- *
- *	To avoid global state use 8 different call vectors.
- *	Each CPU uses a specific vector to trigger flushes on other
- *	CPUs. Depending on the received vector the target CPUs look into
- *	the right per cpu variable for the flush data.
- *
- *	With more than 8 CPUs they are hashed to the 8 available
- *	vectors. The limited global vector space forces us to this right now.
- *	In future when interrupts are split into per CPU domains this could be
- *	fixed, at the cost of triggering multiple IPIs in some cases.
- */
-
-union smp_flush_state {
-	struct {
-		cpumask_t flush_cpumask;
-		struct mm_struct *flush_mm;
-		unsigned long flush_va;
-		spinlock_t tlbstate_lock;
-	};
-	char pad[SMP_CACHE_BYTES];
-} ____cacheline_aligned;
-
-/* State is put into the per CPU data section, but padded
-   to a full cache line because other CPUs can access it and we don't
-   want false sharing in the per cpu data segment. */
-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
-
-/*
- * We cannot call mmdrop() because we are in interrupt context,
- * instead update mm->cpu_vm_mask.
- */
-void leave_mm(int cpu)
-{
-	if (read_pda(mmu_state) == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
-}
-EXPORT_SYMBOL_GPL(leave_mm);
-
-/*
- *
- * The flush IPI assumes that a thread switch happens in this order:
- * [cpu0: the cpu that switches]
- * 1) switch_mm() either 1a) or 1b)
- * 1a) thread switch to a different mm
- * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
- *	Stop ipi delivery for the old mm. This is not synchronized with
- *	the other cpus, but smp_invalidate_interrupt ignore flush ipis
- *	for the wrong mm, and in the worst case we perform a superfluous
- *	tlb flush.
- * 1a2) set cpu mmu_state to TLBSTATE_OK
- *	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
- *	was in lazy tlb mode.
- * 1a3) update cpu active_mm
- *	Now cpu0 accepts tlb flushes for the new mm.
- * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
- *	Now the other cpus will send tlb flush ipis.
- * 1a4) change cr3.
- * 1b) thread switch without mm change
- *	cpu active_mm is correct, cpu0 already handles
- *	flush ipis.
- * 1b1) set cpu mmu_state to TLBSTATE_OK
- * 1b2) test_and_set the cpu bit in cpu_vm_mask.
- *	Atomically set the bit [other cpus will start sending flush ipis],
- *	and test the bit.
- * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
- * 2) switch %%esp, ie current
- *
- * The interrupt must handle 2 special cases:
- * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
- * - the cpu performs speculative tlb reads, i.e. even if the cpu only
- *   runs in kernel space, the cpu could load tlb entries for user space
- *   pages.
- *
- * The good news is that cpu mmu_state is local to each cpu, no
- * write/read ordering problems.
- */
-
-/*
- * TLB flush IPI:
- *
- * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
- * 2) Leave the mm if we are in the lazy tlb mode.
- *
- * Interrupts are disabled.
- */
-
-asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
-{
-	int cpu;
-	int sender;
-	union smp_flush_state *f;
-
-	cpu = smp_processor_id();
-	/*
-	 * orig_rax contains the negated interrupt vector.
-	 * Use that to determine where the sender put the data.
-	 */
-	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &per_cpu(flush_state, sender);
-
-	if (!cpu_isset(cpu, f->flush_cpumask))
-		goto out;
-		/*
-		 * This was a BUG() but until someone can quote me the
-		 * line from the intel manual that guarantees an IPI to
-		 * multiple CPUs is retried _only_ on the erroring CPUs
-		 * its staying as a return
-		 *
-		 * BUG();
-		 */
-
-	if (f->flush_mm == read_pda(active_mm)) {
-		if (read_pda(mmu_state) == TLBSTATE_OK) {
-			if (f->flush_va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(f->flush_va);
-		} else
-			leave_mm(cpu);
-	}
-out:
-	ack_APIC_irq();
-	cpu_clear(cpu, f->flush_cpumask);
-	add_pda(irq_tlb_count, 1);
-}
-
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
-{
-	int sender;
-	union smp_flush_state *f;
-	cpumask_t cpumask = *cpumaskp;
-
-	/* Caller has disabled preemption */
-	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
-	f = &per_cpu(flush_state, sender);
-
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	spin_lock(&f->tlbstate_lock);
-
-	f->flush_mm = mm;
-	f->flush_va = va;
-	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
-
-	/*
-	 * We have to send the IPI only to
-	 * CPUs affected.
-	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
-
-	while (!cpus_empty(f->flush_cpumask))
-		cpu_relax();
-
-	f->flush_mm = NULL;
-	f->flush_va = 0;
-	spin_unlock(&f->tlbstate_lock);
-}
-
-int __cpuinit init_smp_flush(void)
-{
-	int i;
-
-	for_each_cpu_mask(i, cpu_possible_map) {
-		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
-	}
-	return 0;
-}
-core_initcall(init_smp_flush);
-
-void flush_tlb_current_task(void)
-{
-	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	preempt_enable();
-}
-
-void flush_tlb_mm (struct mm_struct * mm)
-{
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			leave_mm(smp_processor_id());
-	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_page(struct vm_area_struct * vma, unsigned long va)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if(current->mm)
-			__flush_tlb_one(va);
-		else
-			leave_mm(smp_processor_id());
-	}
-
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
-
-	preempt_enable();
-}
-
-static void do_flush_tlb_all(void* info)
-{
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
-	if (read_pda(mmu_state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
-
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
-}
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
new file mode 100644
index 0000000..9bb2363
--- /dev/null
+++ b/arch/x86/kernel/tlb_32.c
@@ -0,0 +1,243 @@
+#include <linux/spinlock.h>
+#include <linux/cpu.h>
+#include <linux/interrupt.h>
+
+#include <asm/tlbflush.h>
+
+DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
+			____cacheline_aligned = { &init_mm, 0, };
+
+/* must come after the send_IPI functions above for inlining */
+#include <mach_ipi.h>
+
+/*
+ *	Smarter SMP flushing macros.
+ *		c/o Linus Torvalds.
+ *
+ *	These mean you can really definitely utterly forget about
+ *	writing to user space from interrupts. (Its not allowed anyway).
+ *
+ *	Optimizations Manfred Spraul <manfred@colorfullife.com>
+ */
+
+static cpumask_t flush_cpumask;
+static struct mm_struct *flush_mm;
+static unsigned long flush_va;
+static DEFINE_SPINLOCK(tlbstate_lock);
+
+/*
+ * We cannot call mmdrop() because we are in interrupt context,
+ * instead update mm->cpu_vm_mask.
+ *
+ * We need to reload %cr3 since the page tables may be going
+ * away from under us..
+ */
+void leave_mm(int cpu)
+{
+	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
+		BUG();
+	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
+	load_cr3(swapper_pg_dir);
+}
+EXPORT_SYMBOL_GPL(leave_mm);
+
+/*
+ *
+ * The flush IPI assumes that a thread switch happens in this order:
+ * [cpu0: the cpu that switches]
+ * 1) switch_mm() either 1a) or 1b)
+ * 1a) thread switch to a different mm
+ * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
+ * 	Stop ipi delivery for the old mm. This is not synchronized with
+ * 	the other cpus, but smp_invalidate_interrupt ignore flush ipis
+ * 	for the wrong mm, and in the worst case we perform a superfluous
+ * 	tlb flush.
+ * 1a2) set cpu_tlbstate to TLBSTATE_OK
+ * 	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
+ *	was in lazy tlb mode.
+ * 1a3) update cpu_tlbstate[].active_mm
+ * 	Now cpu0 accepts tlb flushes for the new mm.
+ * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
+ * 	Now the other cpus will send tlb flush ipis.
+ * 1a4) change cr3.
+ * 1b) thread switch without mm change
+ *	cpu_tlbstate[].active_mm is correct, cpu0 already handles
+ *	flush ipis.
+ * 1b1) set cpu_tlbstate to TLBSTATE_OK
+ * 1b2) test_and_set the cpu bit in cpu_vm_mask.
+ * 	Atomically set the bit [other cpus will start sending flush ipis],
+ * 	and test the bit.
+ * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
+ * 2) switch %%esp, ie current
+ *
+ * The interrupt must handle 2 special cases:
+ * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
+ * - the cpu performs speculative tlb reads, i.e. even if the cpu only
+ *   runs in kernel space, the cpu could load tlb entries for user space
+ *   pages.
+ *
+ * The good news is that cpu_tlbstate is local to each cpu, no
+ * write/read ordering problems.
+ */
+
+/*
+ * TLB flush IPI:
+ *
+ * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
+ * 2) Leave the mm if we are in the lazy tlb mode.
+ */
+
+void smp_invalidate_interrupt(struct pt_regs *regs)
+{
+	unsigned long cpu;
+
+	cpu = get_cpu();
+
+	if (!cpu_isset(cpu, flush_cpumask))
+		goto out;
+		/*
+		 * This was a BUG() but until someone can quote me the
+		 * line from the intel manual that guarantees an IPI to
+		 * multiple CPUs is retried _only_ on the erroring CPUs
+		 * its staying as a return
+		 *
+		 * BUG();
+		 */
+
+	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
+		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
+			if (flush_va == TLB_FLUSH_ALL)
+				local_flush_tlb();
+			else
+				__flush_tlb_one(flush_va);
+		} else
+			leave_mm(cpu);
+	}
+	ack_APIC_irq();
+	smp_mb__before_clear_bit();
+	cpu_clear(cpu, flush_cpumask);
+	smp_mb__after_clear_bit();
+out:
+	put_cpu_no_resched();
+	__get_cpu_var(irq_stat).irq_tlb_count++;
+}
+
+void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+			     unsigned long va)
+{
+	cpumask_t cpumask = *cpumaskp;
+
+	/*
+	 * A couple of (to be removed) sanity checks:
+	 *
+	 * - current CPU must not be in mask
+	 * - mask must exist :)
+	 */
+	BUG_ON(cpus_empty(cpumask));
+	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(!mm);
+
+#ifdef CONFIG_HOTPLUG_CPU
+	/* If a CPU which we ran on has gone down, OK. */
+	cpus_and(cpumask, cpumask, cpu_online_map);
+	if (unlikely(cpus_empty(cpumask)))
+		return;
+#endif
+
+	/*
+	 * i'm not happy about this global shared spinlock in the
+	 * MM hot path, but we'll see how contended it is.
+	 * AK: x86-64 has a faster method that could be ported.
+	 */
+	spin_lock(&tlbstate_lock);
+
+	flush_mm = mm;
+	flush_va = va;
+	cpus_or(flush_cpumask, cpumask, flush_cpumask);
+	/*
+	 * We have to send the IPI only to
+	 * CPUs affected.
+	 */
+	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR);
+
+	while (!cpus_empty(flush_cpumask))
+		/* nothing. lockup detection does not belong here */
+		cpu_relax();
+
+	flush_mm = NULL;
+	flush_va = 0;
+	spin_unlock(&tlbstate_lock);
+}
+
+void flush_tlb_current_task(void)
+{
+	struct mm_struct *mm = current->mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	local_flush_tlb();
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	preempt_enable();
+}
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			local_flush_tlb();
+		else
+			leave_mm(smp_processor_id());
+	}
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+
+	preempt_enable();
+}
+
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			__flush_tlb_one(va);
+		 else
+			leave_mm(smp_processor_id());
+	}
+
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, va);
+
+	preempt_enable();
+}
+EXPORT_SYMBOL(flush_tlb_page);
+
+static void do_flush_tlb_all(void *info)
+{
+	unsigned long cpu = smp_processor_id();
+
+	__flush_tlb_all();
+	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
+		leave_mm(cpu);
+}
+
+void flush_tlb_all(void)
+{
+	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
+}
+
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
new file mode 100644
index 0000000..615d848
--- /dev/null
+++ b/arch/x86/kernel/tlb_64.c
@@ -0,0 +1,273 @@
+#include <linux/init.h>
+
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/kernel_stat.h>
+#include <linux/mc146818rtc.h>
+#include <linux/interrupt.h>
+
+#include <asm/mtrr.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
+#include <asm/mach_apic.h>
+#include <asm/mmu_context.h>
+#include <asm/proto.h>
+#include <asm/apicdef.h>
+#include <asm/idle.h>
+/*
+ *	Smarter SMP flushing macros.
+ *		c/o Linus Torvalds.
+ *
+ *	These mean you can really definitely utterly forget about
+ *	writing to user space from interrupts. (Its not allowed anyway).
+ *
+ *	Optimizations Manfred Spraul <manfred@colorfullife.com>
+ *
+ *	More scalable flush, from Andi Kleen
+ *
+ *	To avoid global state use 8 different call vectors.
+ *	Each CPU uses a specific vector to trigger flushes on other
+ *	CPUs. Depending on the received vector the target CPUs look into
+ *	the right per cpu variable for the flush data.
+ *
+ *	With more than 8 CPUs they are hashed to the 8 available
+ *	vectors. The limited global vector space forces us to this right now.
+ *	In future when interrupts are split into per CPU domains this could be
+ *	fixed, at the cost of triggering multiple IPIs in some cases.
+ */
+
+union smp_flush_state {
+	struct {
+		cpumask_t flush_cpumask;
+		struct mm_struct *flush_mm;
+		unsigned long flush_va;
+		spinlock_t tlbstate_lock;
+	};
+	char pad[SMP_CACHE_BYTES];
+} ____cacheline_aligned;
+
+/* State is put into the per CPU data section, but padded
+   to a full cache line because other CPUs can access it and we don't
+   want false sharing in the per cpu data segment. */
+static DEFINE_PER_CPU(union smp_flush_state, flush_state);
+
+/*
+ * We cannot call mmdrop() because we are in interrupt context,
+ * instead update mm->cpu_vm_mask.
+ */
+void leave_mm(int cpu)
+{
+	if (read_pda(mmu_state) == TLBSTATE_OK)
+		BUG();
+	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
+	load_cr3(swapper_pg_dir);
+}
+EXPORT_SYMBOL_GPL(leave_mm);
+
+/*
+ *
+ * The flush IPI assumes that a thread switch happens in this order:
+ * [cpu0: the cpu that switches]
+ * 1) switch_mm() either 1a) or 1b)
+ * 1a) thread switch to a different mm
+ * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
+ *	Stop ipi delivery for the old mm. This is not synchronized with
+ *	the other cpus, but smp_invalidate_interrupt ignore flush ipis
+ *	for the wrong mm, and in the worst case we perform a superfluous
+ *	tlb flush.
+ * 1a2) set cpu mmu_state to TLBSTATE_OK
+ *	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
+ *	was in lazy tlb mode.
+ * 1a3) update cpu active_mm
+ *	Now cpu0 accepts tlb flushes for the new mm.
+ * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
+ *	Now the other cpus will send tlb flush ipis.
+ * 1a4) change cr3.
+ * 1b) thread switch without mm change
+ *	cpu active_mm is correct, cpu0 already handles
+ *	flush ipis.
+ * 1b1) set cpu mmu_state to TLBSTATE_OK
+ * 1b2) test_and_set the cpu bit in cpu_vm_mask.
+ *	Atomically set the bit [other cpus will start sending flush ipis],
+ *	and test the bit.
+ * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
+ * 2) switch %%esp, ie current
+ *
+ * The interrupt must handle 2 special cases:
+ * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
+ * - the cpu performs speculative tlb reads, i.e. even if the cpu only
+ *   runs in kernel space, the cpu could load tlb entries for user space
+ *   pages.
+ *
+ * The good news is that cpu mmu_state is local to each cpu, no
+ * write/read ordering problems.
+ */
+
+/*
+ * TLB flush IPI:
+ *
+ * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
+ * 2) Leave the mm if we are in the lazy tlb mode.
+ *
+ * Interrupts are disabled.
+ */
+
+asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
+{
+	int cpu;
+	int sender;
+	union smp_flush_state *f;
+
+	cpu = smp_processor_id();
+	/*
+	 * orig_rax contains the negated interrupt vector.
+	 * Use that to determine where the sender put the data.
+	 */
+	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
+	f = &per_cpu(flush_state, sender);
+
+	if (!cpu_isset(cpu, f->flush_cpumask))
+		goto out;
+		/*
+		 * This was a BUG() but until someone can quote me the
+		 * line from the intel manual that guarantees an IPI to
+		 * multiple CPUs is retried _only_ on the erroring CPUs
+		 * its staying as a return
+		 *
+		 * BUG();
+		 */
+
+	if (f->flush_mm == read_pda(active_mm)) {
+		if (read_pda(mmu_state) == TLBSTATE_OK) {
+			if (f->flush_va == TLB_FLUSH_ALL)
+				local_flush_tlb();
+			else
+				__flush_tlb_one(f->flush_va);
+		} else
+			leave_mm(cpu);
+	}
+out:
+	ack_APIC_irq();
+	cpu_clear(cpu, f->flush_cpumask);
+	add_pda(irq_tlb_count, 1);
+}
+
+void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+			     unsigned long va)
+{
+	int sender;
+	union smp_flush_state *f;
+	cpumask_t cpumask = *cpumaskp;
+
+	/* Caller has disabled preemption */
+	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
+	f = &per_cpu(flush_state, sender);
+
+	/*
+	 * Could avoid this lock when
+	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
+	 * probably not worth checking this for a cache-hot lock.
+	 */
+	spin_lock(&f->tlbstate_lock);
+
+	f->flush_mm = mm;
+	f->flush_va = va;
+	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
+
+	/*
+	 * We have to send the IPI only to
+	 * CPUs affected.
+	 */
+	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+
+	while (!cpus_empty(f->flush_cpumask))
+		cpu_relax();
+
+	f->flush_mm = NULL;
+	f->flush_va = 0;
+	spin_unlock(&f->tlbstate_lock);
+}
+
+int __cpuinit init_smp_flush(void)
+{
+	int i;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
+	}
+	return 0;
+}
+core_initcall(init_smp_flush);
+
+void flush_tlb_current_task(void)
+{
+	struct mm_struct *mm = current->mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	local_flush_tlb();
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	preempt_enable();
+}
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			local_flush_tlb();
+		else
+			leave_mm(smp_processor_id());
+	}
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+
+	preempt_enable();
+}
+
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			__flush_tlb_one(va);
+		else
+			leave_mm(smp_processor_id());
+	}
+
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, va);
+
+	preempt_enable();
+}
+
+static void do_flush_tlb_all(void *info)
+{
+	unsigned long cpu = smp_processor_id();
+
+	__flush_tlb_all();
+	if (read_pda(mmu_state) == TLBSTATE_LAZY)
+		leave_mm(cpu);
+}
+
+void flush_tlb_all(void)
+{
+	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
+}
-- 
1.5.0.6

