Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZAFDtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZAFDtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZAFDtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:49:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47585 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbZAFDtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:49:41 -0500
Message-ID: <4962D4CF.7070200@sgi.com>
Date: Mon, 05 Jan 2009 19:49:35 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Cliff Wickman <cpw@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>, Jes Sorensen <jes@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] x86: cpumask: some more cpumask cleanups - flush_tlb_*
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104144454.GA1132@elte.hu>
In-Reply-To: <20090104144454.GA1132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
>> ====== Stack (-l 500)
>>     1 - allyesconfig-128
>>     2 - allyesconfig-4k
>>
>>   .1.    .2.    ..final..
>>     0  +1032   1032      .  flush_tlb_page
>>     0  +1024   1024      .  kvm_reload_remote_mmus
>>     0  +1024   1024      .  kvm_flush_remote_tlbs
>>     0  +1024   1024      .  flush_tlb_mm
>>     0  +1024   1024      .  flush_tlb_current_task
> 
> Quite good! Can we fix those TLB flush cpumask uses too?

Here is one proposal.  I don't like increasing PER_CPU area but eventually we
should be able to per_cpu_alloc the cpumasks so they only take up enough room
as needed.  Also, it was unclear whether one scratch cpumask work suffice for
all three flush_tlb_* functions or a separate one for each was needed.  I
went for the safe route and used one for each function.

An alternate approach might be to add a scratch cpumask to the smp_flush_state
struct.  It already has one fixed cpumask_t (flush_cpumask) so this whole
struct should per_cpu_alloc'd.  (And since it's cacheline_aligned, then a
per_cpu_alloc_aligned() will probably be needed?)

(btw, only 64-bit shown here, 32-bit needs similar changes.)

Thanks,
Mike

---
Subject: cpumask: remove cpumask_t from stack for flush_tlb_xxx

Remove the scratch cpumask_t from the stack for the flush_tlb_*
functions.  Since we're disabling preemption, we can use a
one-per-cpu scratch cpumask.  "Un-const" the cpumask pointer arg
in native_flush_tlb_others as one of the flush_others functions
(uv) changed the cpumask.  I believe this is safe.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/paravirt.h  |    8 ++---
 arch/x86/include/asm/tlbflush.h  |    4 +-
 arch/x86/include/asm/uv/uv_bau.h |    3 +-
 arch/x86/kernel/tlb_64.c         |   53 +++++++++++++++++++++------------------
 arch/x86/kernel/tlb_uv.c         |   12 ++++----
 5 files changed, 43 insertions(+), 37 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/paravirt.h
@@ -244,7 +244,7 @@ struct pv_mmu_ops {
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
-	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
+	void (*flush_tlb_others)(struct cpumask *cpus, struct mm_struct *mm,
 				 unsigned long va);
 
 	/* Hooks for allocating and freeing a pagetable top-level */
@@ -984,10 +984,10 @@ static inline void __flush_tlb_single(un
 	PVOP_VCALL1(pv_mmu_ops.flush_tlb_single, addr);
 }
 
-static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
-				    unsigned long va)
+static inline void flush_tlb_others(struct cpumask *cpumask,
+				    struct mm_struct *mm, unsigned long va)
 {
-	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
+	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
 }
 
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/tlbflush.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/tlbflush.h
@@ -142,7 +142,7 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
+void native_flush_tlb_others(struct cpumask *cpumask, struct mm_struct *mm,
 			     unsigned long va);
 
 #define TLBSTATE_OK	1
@@ -166,7 +166,7 @@ static inline void reset_lazy_tlbstate(v
 #endif	/* SMP */
 
 #ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(&mask, mm, va)
+#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(mask, mm, va)
 #endif
 
 static inline void flush_tlb_kernel_range(unsigned long start,
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/uv/uv_bau.h
@@ -325,7 +325,8 @@ static inline void bau_cpubits_clear(str
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
+extern int uv_flush_tlb_others(struct cpumask *, struct mm_struct *,
+			       unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/tlb_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/tlb_64.c
@@ -157,14 +157,13 @@ out:
 	inc_irq_stat(irq_tlb_count);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+void native_flush_tlb_others(struct cpumask *cpumask, struct mm_struct *mm,
 			     unsigned long va)
 {
 	int sender;
 	union smp_flush_state *f;
-	cpumask_t cpumask = *cpumaskp;
 
-	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
+	if (is_uv_system() && uv_flush_tlb_others(cpumask, mm, va))
 		return;
 
 	/* Caller has disabled preemption */
@@ -180,7 +179,7 @@ void native_flush_tlb_others(const cpuma
 
 	f->flush_mm = mm;
 	f->flush_va = va;
-	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
+	cpumask_or(&f->flush_cpumask, cpumask, &f->flush_cpumask);
 
 	/*
 	 * Make the above memory operations globally visible before
@@ -191,9 +190,9 @@ void native_flush_tlb_others(const cpuma
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
-	while (!cpus_empty(f->flush_cpumask))
+	while (!cpumask_empty(&f->flush_cpumask))
 		cpu_relax();
 
 	f->flush_mm = NULL;
@@ -212,28 +211,32 @@ static int __cpuinit init_smp_flush(void
 }
 core_initcall(init_smp_flush);
 
+static DEFINE_PER_CPU(cpumask_t, flush_tlb_task_cpumask);
+
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
+	struct cpumask *cpu_mask;
 
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpu_mask = &get_cpu_var(flush_tlb_task_cpumask);
+	cpumask_copy(cpu_mask, &mm->cpu_vm_mask);
+	cpumask_clear_cpu(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	preempt_enable();
+	put_cpu_var(flush_tlb_task_cpumask);
 }
 
+static DEFINE_PER_CPU(cpumask_t, flush_tlb_mm_cpumask);
+
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
+	struct cpumask * cpu_mask;
 
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpu_mask = &get_cpu_var(flush_tlb_mm_cpumask);
+	cpumask_copy(cpu_mask, &mm->cpu_vm_mask);
+	cpumask_clear_cpu(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -241,20 +244,22 @@ void flush_tlb_mm(struct mm_struct *mm)
 		else
 			leave_mm(smp_processor_id());
 	}
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
 
-	preempt_enable();
+	put_cpu_var(flush_tlb_mm_cpumask);
 }
 
+static DEFINE_PER_CPU(cpumask_t, flush_tlb_page_cpumask);
+
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
+	struct cpumask *cpu_mask;
 
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
+	cpu_mask = &get_cpu_var(flush_tlb_page_cpumask);
+	cpumask_copy(cpu_mask, &mm->cpu_vm_mask);
+	cpumask_clear_cpu(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
 		if (current->mm)
@@ -263,10 +268,10 @@ void flush_tlb_page(struct vm_area_struc
 			leave_mm(smp_processor_id());
 	}
 
-	if (!cpus_empty(cpu_mask))
+	if (!cpumask_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, va);
 
-	preempt_enable();
+	put_cpu_var(flush_tlb_page_cpumask);
 }
 
 static void do_flush_tlb_all(void *info)
--- linux-2.6-for-ingo.orig/arch/x86/kernel/tlb_uv.c
+++ linux-2.6-for-ingo/arch/x86/kernel/tlb_uv.c
@@ -216,7 +216,7 @@ static int uv_wait_completion(struct bau
  * unchanged.
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
