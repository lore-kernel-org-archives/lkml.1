Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYI2SLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYI2SLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbYI2SDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36498 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754019AbYI2SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180253.667326000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:16 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 26/31] cpumask: clean tlb files
Content-Disposition: inline; filename=clean-tlb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/tlb_32.c   |   24 ++++++++++++------------
 arch/x86/kernel/tlb_64.c   |   23 ++++++++++++-----------
 arch/x86/kernel/tlb_uv.c   |   12 ++++++------
 include/asm-x86/tlbflush.h |    6 +++---
 4 files changed, 33 insertions(+), 32 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/tlb_32.c
+++ struct-cpumasks/arch/x86/kernel/tlb_32.c
@@ -20,7 +20,7 @@ DEFINE_PER_CPU(struct tlb_state, cpu_tlb
  *	Optimizations Manfred Spraul <manfred@colorfullife.com>
  */
 
-static cpumask_t flush_cpumask;
+static cpumask_map_t flush_cpumask;
 static struct mm_struct *flush_mm;
 static unsigned long flush_va;
 static DEFINE_SPINLOCK(tlbstate_lock);
@@ -122,10 +122,10 @@ out:
 	__get_cpu_var(irq_stat).irq_tlb_count++;
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+void native_flush_tlb_others(const_cpumask_t cpumaskp, struct mm_struct *mm,
 			     unsigned long va)
 {
-	cpumask_t cpumask = *cpumaskp;
+	cpumask_var_t cpumask;
 
 	/*
 	 * A couple of (to be removed) sanity checks:
@@ -133,13 +133,13 @@ void native_flush_tlb_others(const cpuma
 	 * - current CPU must not be in mask
 	 * - mask must exist :)
 	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(cpus_empty(cpumaskp));
+	BUG_ON(cpu_isset(smp_processor_id(), cpumaskp));
 	BUG_ON(!mm);
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
+	cpus_and(cpumask, cpumaskp, cpu_online_map);
 	if (unlikely(cpus_empty(cpumask)))
 		return;
 #endif
@@ -172,10 +172,10 @@ void native_flush_tlb_others(const cpuma
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpus_copy(cpu_mask, mm->cpu_vm_mask);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
@@ -186,10 +186,10 @@ void flush_tlb_current_task(void)
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpus_copy(cpu_mask, mm->cpu_vm_mask);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
@@ -207,10 +207,10 @@ void flush_tlb_mm(struct mm_struct *mm)
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpus_copy(cpu_mask, mm->cpu_vm_mask);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
--- struct-cpumasks.orig/arch/x86/kernel/tlb_64.c
+++ struct-cpumasks/arch/x86/kernel/tlb_64.c
@@ -43,7 +43,7 @@
 
 union smp_flush_state {
 	struct {
-		cpumask_t flush_cpumask;
+		cpumask_map_t flush_cpumask;
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
 		spinlock_t tlbstate_lock;
@@ -157,14 +157,15 @@ out:
 	add_pda(irq_tlb_count, 1);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+void native_flush_tlb_others(const_cpumask_t cpumaskp, struct mm_struct *mm,
 			     unsigned long va)
 {
 	int sender;
 	union smp_flush_state *f;
-	cpumask_t cpumask = *cpumaskp;
+	cpumask_var_t cpumask;
 
-	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
+	cpus_copy(cpumask, cpumaskp);
+	if (is_uv_system() && uv_flush_tlb_others(cpumask, mm, va))
 		return;
 
 	/* Caller has disabled preemption */
@@ -186,7 +187,7 @@ void native_flush_tlb_others(const cpuma
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
 	while (!cpus_empty(f->flush_cpumask))
 		cpu_relax();
@@ -210,10 +211,10 @@ core_initcall(init_smp_flush);
 void flush_tlb_current_task(void)
 {
 	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpus_copy(cpu_mask, mm->cpu_vm_mask);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
@@ -224,10 +225,10 @@ void flush_tlb_current_task(void)
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpus_copy(cpu_mask, mm->cpu_vm_mask);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
@@ -245,10 +246,10 @@ void flush_tlb_mm(struct mm_struct *mm)
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpus_copy(cpu_mask, mm->cpu_vm_mask);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	if (current->active_mm == mm) {
--- struct-cpumasks.orig/arch/x86/kernel/tlb_uv.c
+++ struct-cpumasks/arch/x86/kernel/tlb_uv.c
@@ -216,7 +216,7 @@ static int uv_wait_completion(struct bau
  * unchanged.
  */
 int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
-			   cpumask_t *cpumaskp)
+			   cpumask_t cpumaskp)
 {
 	int completion_status = 0;
 	int right_shift;
@@ -263,13 +263,13 @@ int uv_flush_send_and_wait(int cpu, int 
 	 * Success, so clear the remote cpu's from the mask so we don't
 	 * use the IPI method of shootdown on them.
 	 */
-	for_each_cpu(bit, *cpumaskp) {
+	for_each_cpu(bit, cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
 		if (blade == this_blade)
 			continue;
-		cpu_clear(bit, *cpumaskp);
+		cpu_clear(bit, cpumaskp);
 	}
-	if (!cpus_empty(*cpumaskp))
+	if (!cpus_empty(cpumaskp))
 		return 0;
 	return 1;
 }
@@ -296,7 +296,7 @@ int uv_flush_send_and_wait(int cpu, int 
  * Returns 1 if all remote flushing was done.
  * Returns 0 if some remote flushing remains to be done.
  */
-int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
+int uv_flush_tlb_others(cpumask_t cpumaskp, struct mm_struct *mm,
 			unsigned long va)
 {
 	int i;
@@ -315,7 +315,7 @@ int uv_flush_tlb_others(cpumask_t *cpuma
 	bau_nodes_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	i = 0;
-	for_each_cpu(bit, *cpumaskp) {
+	for_each_cpu(bit, cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
 		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
 		if (blade == this_blade) {
--- struct-cpumasks.orig/include/asm-x86/tlbflush.h
+++ struct-cpumasks/include/asm-x86/tlbflush.h
@@ -113,7 +113,7 @@ static inline void flush_tlb_range(struc
 		__flush_tlb();
 }
 
-static inline void native_flush_tlb_others(const cpumask_t *cpumask,
+static inline void native_flush_tlb_others(const_cpumask_t cpumask,
 					   struct mm_struct *mm,
 					   unsigned long va)
 {
@@ -142,7 +142,7 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
+void native_flush_tlb_others(const_cpumask_t cpumask, struct mm_struct *mm,
 			     unsigned long va);
 
 #define TLBSTATE_OK	1
@@ -166,7 +166,7 @@ static inline void reset_lazy_tlbstate(v
 #endif	/* SMP */
 
 #ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(&mask, mm, va)
+#define flush_tlb_others(mask, mm, va)	native_flush_tlb_others(mask, mm, va)
 #endif
 
 static inline void flush_tlb_kernel_range(unsigned long start,

-- 
