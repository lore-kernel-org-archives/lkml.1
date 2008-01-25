Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYAYVxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYAYVxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbYAYVwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:23 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37913 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755177AbYAYVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 11] x86: add mm parameter to paravirt_alloc_pd
X-Mercurial-Node: c884b4df02dfe6fc8619b22db370c15b8ec8e3a3
Message-Id: <c884b4df02dfe6fc8619.1201296192@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mm to paravirt_alloc_pd, partly to make it consistent with
paravirt_alloc_pt, and because later changes will make use of it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/vmi_32.c     |    2 +-
 arch/x86/mm/init_32.c        |    4 ++--
 arch/x86/mm/pgtable_32.c     |    4 +++-
 include/asm-x86/paravirt.h   |    6 +++---
 include/asm-x86/pgalloc_32.h |    3 +--
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -398,7 +398,7 @@ static void vmi_allocate_pt(struct mm_st
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
 }
 
-static void vmi_allocate_pd(u32 pfn)
+static void vmi_allocate_pd(struct mm_struct *mm, u32 pfn)
 {
  	/*
 	 * This call comes in very early, before mem_map is setup.
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -67,7 +67,7 @@ static pmd_t * __init one_md_table_init(
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 
-		paravirt_alloc_pd(__pa(pmd_table) >> PAGE_SHIFT);
+		paravirt_alloc_pd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
 		BUG_ON(pmd_table != pmd_offset(pud, 0));
@@ -378,7 +378,7 @@ void __init native_pagetable_setup_start
 
 		pte_clear(NULL, va, pte);
 	}
-	paravirt_alloc_pd(__pa(swapper_pg_dir) >> PAGE_SHIFT);
+	paravirt_alloc_pd(&init_mm, __pa(base) >> PAGE_SHIFT);
 }
 
 void __init native_pagetable_setup_done(pgd_t *base)
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -321,13 +321,15 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	if (PTRS_PER_PMD == 1 || !pgd)
 		return pgd;
 
+	mm->pgd = pgd;		/* so that alloc_pd can use it */
+
  	for (i = 0; i < UNSHARED_PTRS_PER_PGD; ++i) {
 		pmd_t *pmd = pmd_cache_alloc(i);
 
 		if (!pmd)
 			goto out_oom;
 
-		paravirt_alloc_pd(__pa(pmd) >> PAGE_SHIFT);
+		paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
 		set_pgd(&pgd[i], __pgd(1 + __pa(pmd)));
 	}
 	return pgd;
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -221,7 +221,7 @@ struct pv_mmu_ops {
 
 	/* Hooks for allocating/releasing pagetable pages */
 	void (*alloc_pt)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pd)(u32 pfn);
+	void (*alloc_pd)(struct mm_struct *mm, u32 pfn);
 	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
 	void (*release_pt)(u32 pfn);
 	void (*release_pd)(u32 pfn);
@@ -903,9 +903,9 @@ static inline void paravirt_release_pt(u
 	PVOP_VCALL1(pv_mmu_ops.release_pt, pfn);
 }
 
-static inline void paravirt_alloc_pd(unsigned pfn)
+static inline void paravirt_alloc_pd(struct mm_struct *mm, unsigned pfn)
 {
-	PVOP_VCALL1(pv_mmu_ops.alloc_pd, pfn);
+	PVOP_VCALL2(pv_mmu_ops.alloc_pd, mm, pfn);
 }
 
 static inline void paravirt_alloc_pd_clone(unsigned pfn, unsigned clonepfn,
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -8,8 +8,7 @@
 #include <asm/paravirt.h>
 #else
 #define paravirt_alloc_pt(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd(pfn) do { } while (0)
-#define paravirt_alloc_pd(pfn) do { } while (0)
+#define paravirt_alloc_pd(mm, pfn) do { } while (0)
 #define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
 #define paravirt_release_pt(pfn) do { } while (0)
 #define paravirt_release_pd(pfn) do { } while (0)


