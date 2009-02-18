Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZBRWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZBRWd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZBRWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:30:28 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43910
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753545AbZBRWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:30:26 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/9] x86/paravirt: remove lazy mode in interrupts
Date: Wed, 18 Feb 2009 14:30:12 -0800
Message-Id: <06944a6dbc4ea222760d39d3d0156e50102f8196.1234988621.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make paravirt_lazy_mode() always return PARAVIRT_LAZY_NONE
when in an interrupt.  This prevents interrupt code from
accidentally inheriting an outer lazy state, and instead
does everything synchronously.  Outer batched operations
are left deferred.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    3 +++
 arch/x86/mm/fault.c        |    5 ++---
 arch/x86/mm/highmem_32.c   |    3 ---
 arch/x86/mm/iomap_32.c     |    2 --
 arch/x86/mm/pageattr.c     |   14 --------------
 5 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 6dc4dca..83dadf9 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -283,6 +283,9 @@ void paravirt_leave_lazy_cpu(void)
 
 enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 {
+	if (in_interrupt())
+		return PARAVIRT_LAZY_NONE;
+
 	return __get_cpu_var(paravirt_lazy_mode);
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6b9239d..51b352a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -296,10 +296,9 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	pmd_k = pmd_offset(pud_k, address);
 	if (!pmd_present(*pmd_k))
 		return NULL;
-	if (!pmd_present(*pmd)) {
+	if (!pmd_present(*pmd))
 		set_pmd(pmd, *pmd_k);
-		arch_flush_lazy_mmu_mode();
-	} else
+	else
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
 	return pmd_k;
 }
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index bcc079c..98c9ac7 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -86,7 +86,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -116,7 +115,6 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
 #endif
 	}
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 
@@ -133,7 +131,6 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index ca53224..a75f8bb 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -42,7 +42,6 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
-	arch_flush_lazy_mmu_mode();
 
 	return (void*) vaddr;
 }
@@ -63,7 +62,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 EXPORT_SYMBOL_GPL(iounmap_atomic);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 8ca0d85..52460f9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -811,13 +811,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 
 	vm_unmap_aliases();
 
-	/*
-	 * If we're called with lazy mmu updates enabled, the
-	 * in-memory pte state may be stale.  Flush pending updates to
-	 * bring them up to date.
-	 */
-	arch_flush_lazy_mmu_mode();
-
 	cpa.vaddr = addr;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
@@ -860,13 +853,6 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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

