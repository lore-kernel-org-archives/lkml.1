Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYC1QmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYC1QmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYC1Qlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:41:53 -0400
Received: from mail17.svc.cra.dublin.eircom.net ([159.134.118.216]:32329 "HELO
	mail17.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751731AbYC1Qlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:41:52 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, xen-devel@lists.xensource.com,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/3] xen: Refactor xen_{alloc,release}_{pte,pmd}()
Date: Fri, 28 Mar 2008 16:38:15 +0000
Message-Id: <1206722297-11763-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206722297-11763-1-git-send-email-markmc@redhat.com>
References: <1206722297-11763-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pt_level enum with generic alloc_ptpage()
and release_ptpage() functions to make it a little
more clear what's going on in next commit.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/xen/enlighten.c |   27 ++++++++++++++++++++-------
 arch/x86/xen/mmu.c       |    7 -------
 arch/x86/xen/mmu.h       |    7 +++++++
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1e5ea9e..a6a1b40 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -669,10 +669,10 @@ static void xen_release_pte_init(u32 pfn)
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
-static void pin_pagetable_pfn(unsigned level, unsigned long pfn)
+static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 {
 	struct mmuext_op op;
-	op.cmd = level;
+	op.cmd = cmd;
 	op.arg1.mfn = pfn_to_mfn(pfn);
 	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
 		BUG();
@@ -689,7 +689,10 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-			pin_pagetable_pfn(level, pfn);
+			if (level == PT_PTE)
+				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+			else if (level == PT_PMD)
+				pin_pagetable_pfn(MMUEXT_PIN_L2_TABLE, pfn);
 		} else
 			/* make sure there are no stray mappings of
 			   this page */
@@ -699,16 +702,16 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 
 static void xen_alloc_pte(struct mm_struct *mm, u32 pfn)
 {
-	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L1_TABLE);
+	xen_alloc_ptpage(mm, pfn, PT_PTE);
 }
 
 static void xen_alloc_pmd(struct mm_struct *mm, u32 pfn)
 {
-	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L2_TABLE);
+	xen_alloc_ptpage(mm, pfn, PT_PMD);
 }
 
 /* This should never happen until we're OK to use struct page */
-static void xen_release_pte(u32 pfn)
+static void xen_release_ptpage(u32 pfn, unsigned level)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -720,6 +723,16 @@ static void xen_release_pte(u32 pfn)
 	}
 }
 
+static void xen_release_pte(u32 pfn)
+{
+	xen_release_ptpage(pfn, PT_PTE);
+}
+
+static void xen_release_pmd(u32 pfn)
+{
+	xen_release_ptpage(pfn, PT_PMD);
+}
+
 #ifdef CONFIG_HIGHPTE
 static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
 {
@@ -840,7 +853,7 @@ static __init void xen_pagetable_setup_done(pgd_t *base)
 	pv_mmu_ops.alloc_pte = xen_alloc_pte;
 	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
 	pv_mmu_ops.release_pte = xen_release_pte;
-	pv_mmu_ops.release_pmd = xen_release_pte;
+	pv_mmu_ops.release_pmd = xen_release_pmd;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	setup_shared_info();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f5bb0be..272635a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -271,13 +271,6 @@ void xen_set_pte(pte_t *ptep, pte_t pte)
 }
 #endif	/* CONFIG_X86_PAE */
 
-enum pt_level {
-	PT_PGD,
-	PT_PUD,
-	PT_PMD,
-	PT_PTE
-};
-
 /*
   (Yet another) pagetable walker.  This one is intended for pinning a
   pagetable.  This means that it walks a pagetable and calls the
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index c9ff27f..b5e189b 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -3,6 +3,13 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 
+enum pt_level {
+	PT_PGD,
+	PT_PUD,
+	PT_PMD,
+	PT_PTE
+};
+
 /*
  * Page-directory addresses above 4GB do not fit into architectural %cr3.
  * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
-- 
1.5.4.1

