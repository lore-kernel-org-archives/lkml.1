Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbZAGCNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbZAGCNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbZAGCMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:12:55 -0500
Received: from ozlabs.org ([203.10.76.45]:42123 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbZAGCMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:12:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 00/11] x86: cpumask: some more cpumask cleanups - flush_tlb_*
Date: Wed, 7 Jan 2009 12:42:41 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Cliff Wickman <cpw@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>, Jes Sorensen <jes@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104144454.GA1132@elte.hu> <4962D4CF.7070200@sgi.com>
In-Reply-To: <4962D4CF.7070200@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071242.42573.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 14:19:35 Mike Travis wrote:
> Ingo Molnar wrote:
> > Quite good! Can we fix those TLB flush cpumask uses too?
> 
> Here is one proposal.

Here's what I had.  It's untested though...

x86: change flush_tlb_others to take a const struct cpumask *. FIXME: REVIEW

This is made a little more tricky by uv_flush_tlb_others which
actually alters its argument, for an IPI to be sent to the remaining
cpus in the mask.

I solve this by allocating a cpumask_var_t for this case and falling back
to IPI should this fail.

To eliminate temporaries in the caller, all flush_tlb_others implementations
now do the this-cpu-elimination step themselves.

Note also the curious "cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask)"
which has been there since pre-git and yet f->flush_cpumask is always zero
at this point.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/paravirt.h  |    8 ++--
 arch/x86/include/asm/tlbflush.h  |    6 +--
 arch/x86/include/asm/uv/uv_bau.h |    3 +
 arch/x86/kernel/tlb_32.c         |   69 ++++++++++++++++-----------------------
 arch/x86/kernel/tlb_64.c         |   62 ++++++++++++++++++-----------------
 arch/x86/kernel/tlb_uv.c         |   16 ++++-----
 arch/x86/xen/enlighten.c         |   31 ++++++-----------
 7 files changed, 92 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -244,7 +244,8 @@ struct pv_mmu_ops {
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
-	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
+	void (*flush_tlb_others)(const struct cpumask *cpus,
+				 struct mm_struct *mm,
 				 unsigned long va);
 
 	/* Hooks for allocating and freeing a pagetable top-level */
@@ -984,10 +985,11 @@ static inline void __flush_tlb_single(un
 	PVOP_VCALL1(pv_mmu_ops.flush_tlb_single, addr);
 }
 
-static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+static inline void flush_tlb_others(const struct cpumask *cpumask,
+				    struct mm_struct *mm,
 				    unsigned long va)
 {
-	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
+	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
 }
 
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -113,7 +113,7 @@ static inline void flush_tlb_range(struc
 		__flush_tlb();
 }
 
-static inline void native_flush_tlb_others(const cpumask_t *cpumask,
+static inline void native_flush_tlb_others(const struct cpumask *cpumask,
 					   struct mm_struct *mm,
 					   unsigned long va)
 {
@@ -142,8 +142,8 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
-			     unsigned long va);
+void native_flush_tlb_others(const struct cpumask *cpumask,
+			     struct mm_struct *mm, unsigned long va);
 
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -325,7 +325,8 @@ static inline void bau_cpubits_clear(str
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
+extern int uv_flush_tlb_others(const struct cpumask *,
+			       struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -20,7 +20,7 @@ DEFINE_PER_CPU(struct tlb_state, cpu_tlb
  *	Optimizations Manfred Spraul <manfred@colorfullife.com>
  */
 
-static cpumask_t flush_cpumask;
+static cpumask_var_t flush_cpumask;
 static struct mm_struct *flush_mm;
 static unsigned long flush_va;
 static DEFINE_SPINLOCK(tlbstate_lock);
@@ -93,7 +93,7 @@ void smp_invalidate_interrupt(struct pt_
 
 	cpu = get_cpu();
 
-	if (!cpu_isset(cpu, flush_cpumask))
+	if (!cpumask_test_cpu(cpu, flush_cpumask))
 		goto out;
 		/*
 		 * This was a BUG() but until someone can quote me the
@@ -115,34 +115,21 @@ void smp_invalidate_interrupt(struct pt_
 	}
 	ack_APIC_irq();
 	smp_mb__before_clear_bit();
-	cpu_clear(cpu, flush_cpumask);
+	cpumask_clear_cpu(cpu, flush_cpumask);
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
 	inc_irq_stat(irq_tlb_count);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
+void native_flush_tlb_others(const struct cpumask *cpumaskp,
+			     struct mm_struct *mm, unsigned long va)
 {
-	cpumask_t cpumask = *cpumaskp;
-
 	/*
-	 * A couple of (to be removed) sanity checks:
-	 *
-	 * - current CPU must not be in mask
 	 * - mask must exist :)
 	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpumask_empty(cpumask));
 	BUG_ON(!mm);
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (unlikely(cpus_empty(cpumask)))
-		return;
-#endif
 
 	/*
 	 * i'm not happy about this global shared spinlock in the
@@ -151,9 +138,17 @@ void native_flush_tlb_others(const cpuma
 	 */
 	spin_lock(&tlbstate_lock);
 
+	cpumask_andnot(flush_cpumask, cpumask, cpumask_of(smp_processor_id()));
+#ifdef CONFIG_HOTPLUG_CPU
+	/* If a CPU which we ran on has gone down, OK. */
+	cpumask_and(flush_cpumask, flush_cpumask, cpu_online_mask);
+	if (unlikely(cpumask_empty(flush_cpumask))) {
+		spin_unlock(&tlbstate_lock);
+		return;
+	}
+#endif
 	flush_mm = mm;
 	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
 
 	/*
 	 * Make the above memory operations globally visible before
@@ -164,9 +159,9 @@ void native_flush_tlb_others(const cpuma
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR);
+	send_IPI_mask(flush_cpumask, INVALIDATE_TLB_VECTOR);
 
-	while (!cpus_empty(flush_cpumask))
+	while (!cpumask_empty(flush_cpumask))
 		/* nothing. lockup detection does not belong here */
 		cpu_relax();
 
@@ -178,25 +173,18 @@ void flush_tlb_current_task(void)
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = *mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
-
 	preempt_disable();
-	cpu_mask = *mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -204,8 +192,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 		else
 			leave_mm(smp_processor_id());
 	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -213,12 +201,8 @@ void flush_tlb_page(struct vm_area_struc
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = *mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
 	if (current->active_mm == mm) {
 		if (current->mm)
 			__flush_tlb_one(va);
@@ -226,9 +210,8 @@ void flush_tlb_page(struct vm_area_struc
 			leave_mm(smp_processor_id());
 	}
 
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
-
+	if (cpumask_any_but(mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm->cpu_vm_mask, mm, va);
 	preempt_enable();
 }
 EXPORT_SYMBOL(flush_tlb_page);
@@ -255,3 +238,9 @@ void reset_lazy_tlbstate(void)
 	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
 }
 
+static int init_flush_cpumask(void)
+{
+	alloc_cpumask_var(&flush_cpumask, GFP_KERNEL);
+	return 0;
+}
+early_initcall(init_flush_cpumask);
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -43,10 +43,10 @@
 
 union smp_flush_state {
 	struct {
-		cpumask_t flush_cpumask;
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
 		spinlock_t tlbstate_lock;
+		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
 	char pad[SMP_CACHE_BYTES];
 } ____cacheline_aligned;
@@ -131,7 +131,7 @@ asmlinkage void smp_invalidate_interrupt
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
 	f = &per_cpu(flush_state, sender);
 
-	if (!cpu_isset(cpu, f->flush_cpumask))
+	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
 		/*
 		 * This was a BUG() but until someone can quote me the
@@ -153,19 +153,15 @@ asmlinkage void smp_invalidate_interrupt
 	}
 out:
 	ack_APIC_irq();
-	cpu_clear(cpu, f->flush_cpumask);
+	cpumask_clear_cpu(cpu, f->flush_cpumask);
 	inc_irq_stat(irq_tlb_count);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
+static void flush_tlb_others_ipi(const struct cpumask *cpumaskp,
+				 struct mm_struct *mm, unsigned long va)
 {
 	int sender;
 	union smp_flush_state *f;
-	cpumask_t cpumask = *cpumaskp;
-
-	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
-		return;
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
@@ -180,7 +176,8 @@ void native_flush_tlb_others(const cpuma
 
 	f->flush_mm = mm;
 	f->flush_va = va;
-	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
+	cpumask_andnot(to_cpumask(f->flush_cpumask),
+		       cpumask, cpumask_of(smp_processor_id));
 
 	/*
 	 * Make the above memory operations globally visible before
@@ -191,14 +188,32 @@ void native_flush_tlb_others(const cpuma
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
-	while (!cpus_empty(f->flush_cpumask))
+	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
 		cpu_relax();
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
 	spin_unlock(&f->tlbstate_lock);
+
+
+void native_flush_tlb_others(const struct cpumask *cpumask,
+			     struct mm_struct *mm, unsigned long va)
+{
+	if (is_uv_system()) {
+		cpumask_var_t after_uv_flush;
+
+		if (alloc_cpumask_var(&after_uv_flush, GFP_ATOMIC)) {
+			cpumask_andnot(after_uv_flush,
+				       cpumask, cpumask_of(smp_processor_id()));
+			if (!uv_flush_tlb_others(after_uv_flush, mm, va))
+				flush_tlb_others_ipi(after_uv_flush, mm, va);
+			free_cpumask_var(after_uv_flush);
+			return;
+		}
+	}
+	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
 static int __cpuinit init_smp_flush(void)
@@ -215,34 +230,26 @@ void flush_tlb_current_task(void)
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = *mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = *mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
 	if (current->active_mm == mm) {
 		if (current->mm)
 			local_flush_tlb();
 		else
 			leave_mm(smp_processor_id());
 	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -250,11 +257,8 @@ void flush_tlb_page(struct vm_area_struc
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = *mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -263,8 +267,8 @@ void flush_tlb_page(struct vm_area_struc
 			leave_mm(smp_processor_id());
 	}
 
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
+	if (cpumask_any_but(mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm->cpu_vm_mask, mm, va);
 
 	preempt_enable();
 }
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -212,11 +212,11 @@ static int uv_wait_completion(struct bau
  * The cpumaskp mask contains the cpus the broadcast was sent to.
  *
  * Returns 1 if all remote flushing was done. The mask is zeroed.
- * Returns 0 if some remote flushing remains to be done. The mask is left
- * unchanged.
+ * Returns 0 if some remote flushing remains to be done. The mask will have
+ * some bits still set.
  */
 int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
-			   cpumask_t *cpumaskp)
+			   struct cpumask *cpumaskp)
 {
 	int completion_status = 0;
 	int right_shift;
@@ -263,13 +263,13 @@ int uv_flush_send_and_wait(int cpu, int 
 	 * Success, so clear the remote cpu's from the mask so we don't
 	 * use the IPI method of shootdown on them.
 	 */
-	for_each_cpu_mask(bit, *cpumaskp) {
+	for_each_cpu(bit, cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
 		if (blade == this_blade)
 			continue;
-		cpu_clear(bit, *cpumaskp);
+		cpumask_clear_cpu(bit, cpumaskp);
 	}
-	if (!cpus_empty(*cpumaskp))
+	if (!cpumask_empty(cpumaskp))
 		return 0;
 	return 1;
 }
@@ -296,7 +296,7 @@ int uv_flush_send_and_wait(int cpu, int 
  * Returns 1 if all remote flushing was done.
  * Returns 0 if some remote flushing remains to be done.
  */
-int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
+int uv_flush_tlb_others(struct cpumask *cpumaskp, struct mm_struct *mm,
 			unsigned long va)
 {
 	int i;
@@ -315,7 +315,7 @@ int uv_flush_tlb_others(cpumask_t *cpuma
 	bau_nodes_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	i = 0;
-	for_each_cpu_mask(bit, *cpumaskp) {
+	for_each_cpu(bit, cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
 		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
 		if (blade == this_blade) {
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -634,35 +634,27 @@ static void xen_flush_tlb_single(unsigne
 	preempt_enable();
 }
 
-static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
-				 unsigned long va)
+static void xen_flush_tlb_others(const struct cpumask *cpus,
+				 struct mm_struct *mm, unsigned long va)
 {
 	struct {
 		struct mmuext_op op;
-		cpumask_t mask;
+		DECLARE_BITMAP(mask, NR_CPUS);
 	} *args;
-	cpumask_t cpumask = *cpus;
 	struct multicall_space mcs;
 
-	/*
-	 * A couple of (to be removed) sanity checks:
-	 *
-	 * - current CPU must not be in mask
-	 * - mask must exist :)
-	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpumask_empty(cpus));
 	BUG_ON(!mm);
-
-	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (cpus_empty(cpumask))
-		return;
 
 	mcs = xen_mc_entry(sizeof(*args));
 	args = mcs.args;
-	args->mask = cpumask;
-	args->op.arg2.vcpumask = &args->mask;
+	args->op.arg2.vcpumask = to_cpumask(args->mask);
+
+	/* Remove us, and any offline CPUS. */
+	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
+	if (unlikely(cpumask_empty(to_cpumask(args->mask))))
+		goto issue;
 
 	if (va == TLB_FLUSH_ALL) {
 		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
@@ -673,6 +665,7 @@ static void xen_flush_tlb_others(const c
 
 	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
 
+issue:
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
