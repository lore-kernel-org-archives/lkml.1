Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZC0SDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZC0SDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZC0SCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:49 -0400
Received: from gw.goop.org ([64.81.55.164]:58141 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751478AbZC0SCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/8] x86/paravirt: remove lazy mode in interrupts
Date: Fri, 27 Mar 2009 11:02:37 -0700
Message-Id: <1238176963-21093-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: simplification, robustness

Make paravirt_lazy_mode() always return PARAVIRT_LAZY_NONE
when in an interrupt.  This prevents interrupt code from
accidentally inheriting an outer lazy state, and instead
does everything synchronously.  Outer batched operations
are left deferred.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    3 +++
 arch/x86/mm/fault.c        |    6 ++----
 arch/x86/mm/highmem_32.c   |    2 --
 arch/x86/mm/iomap_32.c     |    2 --
 arch/x86/mm/pageattr.c     |   14 --------------
 5 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 8e45f44..c866521 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -282,6 +282,9 @@ void paravirt_leave_lazy_cpu(void)
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 {
+	if (in_interrupt())
+		return PARAVIRT_LAZY_NONE;
+
 	return __get_cpu_var(paravirt_lazy_mode);
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f70b901..09e6ae4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -227,12 +227,10 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	if (!pmd_present(*pmd_k))
 		return NULL;
 
-	if (!pmd_present(*pmd)) {
+	if (!pmd_present(*pmd))
 		set_pmd(pmd, *pmd_k);
-		arch_flush_lazy_mmu_mode();
-	} else {
+	else
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
-	}
 
 	return pmd_k;
 }
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 522db5e..17d0103 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -87,7 +87,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -117,7 +116,6 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 #endif
 	}
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 699c9b2..0c16a33 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -41,7 +41,6 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -80,7 +79,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 EXPORT_SYMBOL_GPL(iounmap_atomic);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b0e5adb..1224865 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -844,13 +844,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	vm_unmap_aliases();
 
-	/*
-	 * If we're called with lazy mmu updates enabled, the
-	 * in-memory pte state may be stale.  Flush pending updates to
-	 * bring them up to date.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 	cpa.vaddr = addr;
 	cpa.pages = pages;
 	cpa.numpages = numpages;
@@ -895,13 +888,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	} else
 		cpa_flush_all(cache);
 
-	/*
-	 * If we've been called with lazy mmu updates enabled, then
-	 * make sure that everything gets flushed out before we
-	 * return.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 out:
 	return ret;
 }
-- 
1.6.0.6

