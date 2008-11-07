Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYKGTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYKGTRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYKGTRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:17:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:40593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbYKGTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:17:23 -0500
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
	context)
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
References: <1226083858.20569.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 20:16:47 +0100
Message-Id: <1226085407.31966.58.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> Peter, I think we've seen this before. It is the highmem code sleeping.

I've been working on an alternative kmap_atomic implementation for -rt,
the below has been build and booted but not stressed, anybody care to
give it a spin ?

---
 arch/x86/mm/highmem_32.c  |  130 ++++++++++++++++++++++++++++++++++++++++++---
 include/asm-x86/highmem.h |   11 ----
 include/linux/sched.h     |    5 ++
 kernel/sched.c            |   10 ++++
 4 files changed, 137 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index dc5cf71..e9f1ea4 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -39,6 +39,12 @@ struct page *kmap_to_page(void *ptr)
 }
 EXPORT_SYMBOL_GPL(kmap_to_page); /* PREEMPT_RT converts some modules to use this */
 
+EXPORT_SYMBOL(kmap);
+EXPORT_SYMBOL(kunmap);
+EXPORT_SYMBOL(kunmap_virt);
+
+#ifndef CONFIG_PREEMPT_RT
+
 static void debug_kmap_atomic_prot(enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -112,11 +118,6 @@ void *__kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	return (void *)vaddr;
 }
 
-void *__kmap_atomic(struct page *page, enum km_type type)
-{
-	return kmap_atomic_prot(page, type, kmap_prot);
-}
-
 void __kunmap_atomic(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -161,6 +162,121 @@ void *__kmap_atomic_pfn(unsigned long pfn, enum km_type type)
 	return (void*) vaddr;
 }
 
+#else /* CONFIG_PREEMPT_RT */
+
+void *__kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
+{
+	unsigned long vaddr;
+
+	preempt_disable();
+	pagefault_disable();
+	if (!PageHighMem(page))
+		vaddr = (unsigned long)page_address(page);
+	else {
+		enum fixed_addresses idx;
+		pte_t pte;
+
+		idx = type + KM_TYPE_NR * smp_processor_id();
+		vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+		WARN_ON_ONCE(!pte_none(*(kmap_pte - idx)));
+		pte = mk_pte(page, prot);
+		current->kmap_atomic_ptes[idx] = pte;
+		current->kmap_atomic_count++;
+		set_pte(kmap_pte - idx, pte);
+		arch_flush_lazy_mmu_mode();
+	}
+	preempt_enable();
+
+	return (void *)vaddr;
+}
+
+void __kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	unsigned long vaddr = (unsigned long)kvaddr & PAGE_MASK;
+	enum fixed_addresses idx;
+       
+	preempt_disable();
+	idx = type + KM_TYPE_NR * smp_processor_id();
+	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx)) {
+		current->kmap_atomic_ptes[idx] = native_make_pte(0);
+		current->kmap_atomic_count--;
+		kpte_clear_flush(kmap_pte - idx, vaddr);
+	} else {
+#ifdef CONFIG_DEBUG_HIGHMEM
+		BUG_ON(vaddr < PAGE_OFFSET);
+		BUG_ON(vaddr >= (unsigned long)high_memory);
+#endif
+	}
+	arch_flush_lazy_mmu_mode();
+	pagefault_enable();
+	preempt_enable();
+}
+
+void *__kmap_atomic_pfn(unsigned long pfn, enum km_type type)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+	pte_t pte;
+
+	preempt_disable();
+	pagefault_disable();
+
+	idx = type + KM_TYPE_NR*smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	pte = pfn_pte(pfn, kmap_prot);
+
+	current->kmap_atomic_ptes[idx] = pte;
+	current->kmap_atomic_count++;
+
+	set_pte(kmap_pte-idx, pte);
+	arch_flush_lazy_mmu_mode();
+	preempt_enable();
+
+	return (void*) vaddr;
+}
+
+void arch_kmap_atomic_save(void)
+{
+	int i;
+
+	if (!current->kmap_atomic_count)
+		return;
+
+	arch_enter_lazy_mmu_mode();
+	for (i = 0; i < KM_TYPE_NR; i++) {
+		enum fixed_addresses idx = i + KM_TYPE_NR * smp_processor_id();
+		unsigned long vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+
+		kpte_clear_flush(kmap_pte - idx, vaddr);
+	}
+	arch_leave_lazy_mmu_mode();
+}
+
+void arch_kmap_atomic_restore(void)
+{
+	int i;
+
+	if (!current->kmap_atomic_count)
+		return;
+
+	arch_enter_lazy_mmu_mode();
+	for (i = 0; i < KM_TYPE_NR; i++) {
+		enum fixed_addresses idx = i + KM_TYPE_NR * smp_processor_id();
+		pte_t pte = current->kmap_atomic_ptes[i];
+
+		if (!pte_none(pte))
+			set_pte(kmap_pte - idx, pte);
+	}
+	arch_leave_lazy_mmu_mode();
+}
+
+#endif /* CONFIG_PREEMPT_RT */
+
+void *__kmap_atomic(struct page *page, enum km_type type)
+{
+	return kmap_atomic_prot(page, type, kmap_prot);
+}
+
 struct page *__kmap_atomic_to_page(void *ptr)
 {
 	unsigned long idx, vaddr = (unsigned long)ptr;
@@ -174,8 +290,6 @@ struct page *__kmap_atomic_to_page(void *ptr)
 	return pte_page(*pte);
 }
 
-EXPORT_SYMBOL(kmap);
-EXPORT_SYMBOL(kunmap);
-EXPORT_SYMBOL(kunmap_virt);
 EXPORT_SYMBOL(__kmap_atomic);
 EXPORT_SYMBOL(__kunmap_atomic);
+
diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index 61bae9b..2e37334 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -84,22 +84,11 @@ struct page *kmap_atomic_to_page(void *ptr);
 
 #define flush_cache_kmaps()	do { } while (0)
 
-/*
- * on PREEMPT_RT kmap_atomic() is a wrapper that uses kmap():
- */
-#ifdef CONFIG_PREEMPT_RT
-# define kmap_atomic_prot(page, type, prot)	({ pagefault_disable(); kmap(page); })
-# define kmap_atomic(page, type)	({ pagefault_disable(); kmap(page); })
-# define kmap_atomic_pfn(pfn, type)	kmap(pfn_to_page(pfn))
-# define kunmap_atomic(kvaddr, type)	do { pagefault_enable(); kunmap_virt(kvaddr); } while(0)
-# define kmap_atomic_to_page(kvaddr)	kmap_to_page(kvaddr)
-#else
 # define kmap_atomic_prot(page, type, prot)	__kmap_atomic_prot(page, type, prot)
 # define kmap_atomic(page, type)	__kmap_atomic(page, type)
 # define kmap_atomic_pfn(pfn, type)	__kmap_atomic_pfn(pfn, type)
 # define kunmap_atomic(kvaddr, type)	__kunmap_atomic(kvaddr, type)
 # define kmap_atomic_to_page(kvaddr)	__kmap_atomic_to_page(kvaddr)
-#endif
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 423978b..7dd2b8e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1441,6 +1441,11 @@ struct task_struct {
 	 */
 	int in_printk;
 #endif
+
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_PREEMPT_RT)
+	int kmap_atomic_count;
+	pte_t kmap_atomic_ptes[KM_TYPE_NR];
+#endif
 };
 
 #ifdef CONFIG_PREEMPT_RT
diff --git a/kernel/sched.c b/kernel/sched.c
index 0d68e79..7b52d3b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2623,6 +2623,14 @@ EXPORT_SYMBOL(preempt_enable_no_resched);
 #endif
 
 
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_PREEMPT_RT)
+extern void arch_kmap_atomic_save(void);
+extern void arch_kmap_atomic_restore(void);
+#else
+static inline void arch_kmap_atomic_save(void) { }
+static inline void arch_kmap_atomic_restore(void) { }
+#endif
+
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -2741,6 +2749,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 {
 	struct mm_struct *mm, *oldmm;
 
+	arch_kmap_atomic_save();
 	prepare_task_switch(rq, prev, next);
 	trace_sched_switch(rq, prev, next);
 	mm = next->mm;
@@ -2788,6 +2797,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * frame will be invalid.
 	 */
 	finish_task_switch(this_rq(), prev);
+	arch_kmap_atomic_restore();
 }
 
 /*


