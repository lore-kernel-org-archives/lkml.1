Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZIEWR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZIEWR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 18:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZIEWRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 18:17:54 -0400
Received: from [65.98.92.6] ([65.98.92.6]:4025 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZIEWRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 18:17:53 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2009 18:17:53 EDT
Message-Id: <197625223d8cb6ec3fc3e7da4501dd65@localhost>
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Sat, 5 Sep 2009 14:38:41 -0700
Subject: [PATCH] MIPS: Machine check exception in kmap_coherent()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an SMP MIPS32 2.6.30 system with cache aliases, I am seeing the
following sequence of events:

1) copy_user_highpage() runs on CPU0, invoking kmap_coherent() to create
a temporary mapping in the fixmap region

2) copy_page() starts on CPU0

3) CPU1 sends CPU0 an IPI asking CPU0 to run
local_r4k_flush_cache_page()

4) CPU0 takes the interrupt, interrupting copy_page()

5) local_r4k_flush_cache_page() on CPU0 calls kmap_coherent() again

6) The second invocation of kmap_coherent() on CPU0 tries to use the
same fixmap virtual address that was being used by copy_user_highpage()

7) CPU0 throws a machine check exception for the TLB address conflict

Here is my proposed fix:

a) kmap_coherent() will maintain a flag for each CPU indicating whether
there is an active mapping (kmap_coherent_inuse)

b) kmap_coherent() will return a NULL address in the unlikely case that
it was called while another mapping was already outstanding

c) local_r4k_flush_cache_page() will check for a NULL return value from
kmap_coherent(), and compensate by using indexed cacheops instead of hit
cacheops

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/c-r4k.c |   25 +++++++++++++++++++------
 arch/mips/mm/init.c  |   17 +++++++++++++++--
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 6721ee2..572fe7e 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -459,7 +459,7 @@ static inline void local_r4k_flush_cache_page(void *args)
 	struct page *page = pfn_to_page(fcp_args->pfn);
 	int exec = vma->vm_flags & VM_EXEC;
 	struct mm_struct *mm = vma->vm_mm;
-	int map_coherent = 0;
+	int map_coherent = 0, use_indexed = 0;
 	pgd_t *pgdp;
 	pud_t *pudp;
 	pmd_t *pmdp;
@@ -499,13 +499,23 @@ static inline void local_r4k_flush_cache_page(void *args)
 			vaddr = kmap_coherent(page, addr);
 		else
 			vaddr = kmap_atomic(page, KM_USER0);
-		addr = (unsigned long)vaddr;
+
+		if (unlikely(vaddr == NULL))
+			use_indexed = 1;
+		else
+			addr = (unsigned long)vaddr;
 	}
 
 	if (cpu_has_dc_aliases || (exec && !cpu_has_ic_fills_f_dc)) {
-		r4k_blast_dcache_page(addr);
-		if (exec && !cpu_icache_snoops_remote_store)
-			r4k_blast_scache_page(addr);
+		if (use_indexed) {
+			r4k_blast_dcache_page_indexed(addr);
+			if (exec && !cpu_icache_snoops_remote_store)
+				r4k_blast_scache_page_indexed(addr);
+		} else {
+			r4k_blast_dcache_page(addr);
+			if (exec && !cpu_icache_snoops_remote_store)
+				r4k_blast_scache_page(addr);
+		}
 	}
 	if (exec) {
 		if (vaddr && cpu_has_vtag_icache && mm == current->active_mm) {
@@ -514,7 +524,10 @@ static inline void local_r4k_flush_cache_page(void *args)
 			if (cpu_context(cpu, mm) != 0)
 				drop_mmu_context(mm, cpu);
 		} else
-			r4k_blast_icache_page(addr);
+			if (use_indexed)
+				r4k_blast_icache_page_indexed(addr);
+			else
+				r4k_blast_icache_page(addr);
 	}
 
 	if (vaddr) {
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 0e82050..87967cd 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -31,6 +31,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/bootinfo.h>
 #include <asm/cachectl.h>
+#include <asm/cache.h>
 #include <asm/cpu.h>
 #include <asm/dma.h>
 #include <asm/kmap_types.h>
@@ -105,6 +106,8 @@ unsigned long setup_zero_pages(void)
 	return 1UL << order;
 }
 
+static int kmap_coherent_inuse[NR_CPUS] ____cacheline_aligned_in_smp;
+
 #ifdef CONFIG_MIPS_MT_SMTC
 static pte_t *kmap_coherent_pte;
 static void __init kmap_coherent_init(void)
@@ -125,14 +128,15 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 	unsigned long vaddr, flags, entrylo;
 	unsigned long old_ctx;
 	pte_t pte;
-	int tlbidx;
+	int tlbidx, cpu;
 
 	BUG_ON(Page_dcache_dirty(page));
 
 	inc_preempt_count();
+	cpu = smp_processor_id();
 	idx = (addr >> PAGE_SHIFT) & (FIX_N_COLOURS - 1);
 #ifdef CONFIG_MIPS_MT_SMTC
-	idx += FIX_N_COLOURS * smp_processor_id();
+	idx += FIX_N_COLOURS * cpu;
 #endif
 	vaddr = __fix_to_virt(FIX_CMAP_END - idx);
 	pte = mk_pte(page, PAGE_KERNEL);
@@ -143,6 +147,13 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 #endif
 
 	ENTER_CRITICAL(flags);
+	if (unlikely(kmap_coherent_inuse[cpu] != 0)) {
+		vaddr = 0;
+		dec_preempt_count();
+		goto out;
+	}
+	kmap_coherent_inuse[cpu] = 1;
+
 	old_ctx = read_c0_entryhi();
 	write_c0_entryhi(vaddr & (PAGE_MASK << 1));
 	write_c0_entrylo0(entrylo);
@@ -168,6 +179,7 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 #endif
 	tlbw_use_hazard();
 	write_c0_entryhi(old_ctx);
+out:
 	EXIT_CRITICAL(flags);
 
 	return (void*) vaddr;
@@ -195,6 +207,7 @@ void kunmap_coherent(void)
 	write_c0_entryhi(old_ctx);
 	EXIT_CRITICAL(flags);
 #endif
+	kmap_coherent_inuse[smp_processor_id()] = 0;
 	dec_preempt_count();
 	preempt_check_resched();
 }
-- 
1.6.3.1

