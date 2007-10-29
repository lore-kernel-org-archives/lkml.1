Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbXJ2S74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbXJ2S74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXJ2S7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:59:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44093 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbXJ2S7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:59:47 -0400
Date: Mon, 29 Oct 2007 11:50:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tony@bakeyournoodle.com, paulus@samba.org, benh@kernel.crashing.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, antonb@us.ibm.com,
       rostedt@goodmis.org
Subject: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
Message-ID: <20071029185044.GA23413@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

A few random patches that permit POWER to pass kernbench on -rt.
Many of these have more focus on expediency than care for correctness,
so might best be thought of as workarounds than as complete solutions.
There are still issues not addressed by this patch, including:

o	kmem_cache_alloc() from non-preemptible context during
	bootup (xics_startup() building the irq_radix_revmap()).

o	unmap_vmas() freeing pages with preemption disabled.
	Might be able to address this by linking the pages together,
	then freeing them en masse after preemption has been re-enabled,
	but there is likely a better approach.

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/prom.c           |    2 +-
 arch/powerpc/mm/fault.c              |    3 +++
 arch/powerpc/mm/tlb_64.c             |    8 ++++++--
 arch/powerpc/platforms/pseries/eeh.c |    2 +-
 drivers/of/base.c                    |    2 +-
 include/asm-powerpc/tlb.h            |    5 ++++-
 include/asm-powerpc/tlbflush.h       |    5 ++++-
 mm/memory.c                          |    2 ++
 8 files changed, 22 insertions(+), 7 deletions(-)

diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/prom.c linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/prom.c
--- linux-2.6.23.1-rt4/arch/powerpc/kernel/prom.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/prom.c	2007-10-28 13:37:23.000000000 -0700
@@ -80,7 +80,7 @@ struct boot_param_header *initial_boot_p
 
 extern struct device_node *allnodes;	/* temporary while merging */
 
-extern rwlock_t devtree_lock;	/* temporary while merging */
+extern raw_rwlock_t devtree_lock;	/* temporary while merging */
 
 /* export that to outside world */
 struct device_node *of_chosen;
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/mm/fault.c linux-2.6.23.1-rt4-fix/arch/powerpc/mm/fault.c
--- linux-2.6.23.1-rt4/arch/powerpc/mm/fault.c	2007-10-27 22:20:57.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/mm/fault.c	2007-10-28 13:49:07.000000000 -0700
@@ -301,6 +301,7 @@ good_area:
 		if (get_pteptr(mm, address, &ptep, &pmdp)) {
 			spinlock_t *ptl = pte_lockptr(mm, pmdp);
 			spin_lock(ptl);
+			preempt_disable();
 			if (pte_present(*ptep)) {
 				struct page *page = pte_page(*ptep);
 
@@ -310,10 +311,12 @@ good_area:
 				}
 				pte_update(ptep, 0, _PAGE_HWEXEC);
 				_tlbie(address);
+				preempt_enable();
 				pte_unmap_unlock(ptep, ptl);
 				up_read(&mm->mmap_sem);
 				return 0;
 			}
+			preempt_enable();
 			pte_unmap_unlock(ptep, ptl);
 		}
 #endif
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/mm/tlb_64.c linux-2.6.23.1-rt4-fix/arch/powerpc/mm/tlb_64.c
--- linux-2.6.23.1-rt4/arch/powerpc/mm/tlb_64.c	2007-10-27 22:20:57.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/mm/tlb_64.c	2007-10-28 13:50:38.000000000 -0700
@@ -194,7 +194,9 @@ void hpte_need_flush(struct mm_struct *m
 	 * batch
 	 */
 	if (i != 0 && (mm != batch->mm || batch->psize != psize)) {
+		preempt_disable();
 		__flush_tlb_pending(batch);
+		preempt_enable();
 		i = 0;
 	}
 	if (i == 0) {
@@ -211,7 +213,9 @@ void hpte_need_flush(struct mm_struct *m
 	 * always flush it on RT to reduce scheduling latency.
 	 */
 	if (machine_is(celleb)) {
+		preempt_disable();
 		__flush_tlb_pending(batch);
+		preempt_enable();
 		return;
 	}
 #endif /* CONFIG_PREEMPT_RT */
@@ -292,7 +296,7 @@ void __flush_hash_table_range(struct mm_
 	 * to being hashed). This is not the most performance oriented
 	 * way to do things but is fine for our needs here.
 	 */
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	arch_enter_lazy_mmu_mode();
 	for (; start < end; start += PAGE_SIZE) {
 		pte_t *ptep = find_linux_pte(mm->pgd, start);
@@ -306,7 +310,7 @@ void __flush_hash_table_range(struct mm_
 		hpte_need_flush(mm, start, ptep, pte, 0);
 	}
 	arch_leave_lazy_mmu_mode();
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 
 #endif /* CONFIG_HOTPLUG */
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/platforms/pseries/eeh.c linux-2.6.23.1-rt4-fix/arch/powerpc/platforms/pseries/eeh.c
--- linux-2.6.23.1-rt4/arch/powerpc/platforms/pseries/eeh.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/platforms/pseries/eeh.c	2007-10-28 15:43:54.000000000 -0700
@@ -97,7 +97,7 @@ int eeh_subsystem_enabled;
 EXPORT_SYMBOL(eeh_subsystem_enabled);
 
 /* Lock to avoid races due to multiple reports of an error */
-static DEFINE_SPINLOCK(confirm_error_lock);
+static DEFINE_RAW_SPINLOCK(confirm_error_lock);
 
 /* Buffer for reporting slot-error-detail rtas calls. Its here
  * in BSS, and not dynamically alloced, so that it ends up in
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/drivers/of/base.c linux-2.6.23.1-rt4-fix/drivers/of/base.c
--- linux-2.6.23.1-rt4/drivers/of/base.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/drivers/of/base.c	2007-10-28 13:38:36.000000000 -0700
@@ -25,7 +25,7 @@ struct device_node *allnodes;
 /* use when traversing tree through the allnext, child, sibling,
  * or parent members of struct device_node.
  */
-DEFINE_RWLOCK(devtree_lock);
+DEFINE_RAW_RWLOCK(devtree_lock);
 
 int of_n_addr_cells(struct device_node *np)
 {
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/include/asm-powerpc/tlbflush.h linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlbflush.h
--- linux-2.6.23.1-rt4/include/asm-powerpc/tlbflush.h	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlbflush.h	2007-10-28 11:36:47.000000000 -0700
@@ -118,8 +118,11 @@ static inline void arch_leave_lazy_mmu_m
 {
 	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
 
-	if (batch->index)
+	if (batch->index) {
+		preempt_disable();
 		__flush_tlb_pending(batch);
+		preempt_enable();
+	}
 	batch->active = 0;
 }
 
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/include/asm-powerpc/tlb.h linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlb.h
--- linux-2.6.23.1-rt4/include/asm-powerpc/tlb.h	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlb.h	2007-10-28 11:36:05.000000000 -0700
@@ -44,8 +44,11 @@ static inline void tlb_flush(struct mmu_
 	 * pages are going to be freed and we really don't want to have a CPU
 	 * access a freed page because it has a stale TLB
 	 */
-	if (tlbbatch->index)
+	if (tlbbatch->index) {
+		preempt_disable();
 		__flush_tlb_pending(tlbbatch);
+		preempt_enable();
+	}
 
 	pte_free_finish();
 }
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/mm/memory.c linux-2.6.23.1-rt4-fix/mm/memory.c
--- linux-2.6.23.1-rt4/mm/memory.c	2007-10-27 22:20:57.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/mm/memory.c	2007-10-28 15:40:36.000000000 -0700
@@ -664,6 +664,7 @@ static unsigned long zap_pte_range(struc
 	int anon_rss = 0;
 
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	preempt_disable();
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
@@ -732,6 +733,7 @@ static unsigned long zap_pte_range(struc
 
 	add_mm_rss(mm, file_rss, anon_rss);
 	arch_leave_lazy_mmu_mode();
+	preempt_enable();
 	pte_unmap_unlock(pte - 1, ptl);
 
 	return addr;
