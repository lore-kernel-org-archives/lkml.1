Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYGHX3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYGHX3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbYGHXPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:14 -0400
Received: from gw.goop.org ([64.81.55.164]:51218 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523AbYGHXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 53 of 55] xen64: set up userspace syscall patch
X-Mercurial-Node: acbc803ae4b77b9aca8314f0773abd8e9193839b
Message-Id: <acbc803ae4b77b9aca83.1215554835@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit userspace expects the vdso to be mapped at a specific fixed
address, which happens to be in the middle of the kernel address
space.  Because we have split user and kernel pagetables, we need to
make special arrangements for the vsyscall mapping to appear in the
kernel part of the user pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -55,6 +55,18 @@
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
+
+/*
+ * Identity map, in addition to plain kernel map.  This needs to be
+ * large enough to allocate page table pages to allocate the rest.
+ * Each page can map 2MB.
+ */
+static pte_t level1_ident_pgt[PTRS_PER_PTE * 4] __page_aligned_bss;
+
+#ifdef CONFIG_X86_64
+/* l3 pud for userspace vsyscall mapping */
+static pud_t level3_user_vsyscall[PTRS_PER_PUD] __page_aligned_bss;
+#endif /* CONFIG_X86_64 */
 
 /*
  * Note about cr3 (pagetable base) values:
@@ -831,12 +843,20 @@
 #ifdef CONFIG_X86_64
 	{
 		struct page *page = virt_to_page(pgd);
+		pgd_t *user_pgd;
 
 		BUG_ON(page->private != 0);
 
-		page->private = __get_free_page(GFP_KERNEL | __GFP_ZERO);
-		if (page->private == 0)
-			ret = -ENOMEM;
+		ret = -ENOMEM;
+
+		user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		page->private = (unsigned long)user_pgd;
+
+		if (user_pgd != NULL) {
+			user_pgd[pgd_index(VSYSCALL_START)] =
+				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
+			ret = 0;
+		}
 
 		BUG_ON(PagePinned(virt_to_page(xen_get_user_pgd(pgd))));
 	}
@@ -977,6 +997,9 @@
 	pv_mmu_ops.release_pud = xen_release_pud;
 #endif
 
+#ifdef CONFIG_X86_64
+	SetPagePinned(virt_to_page(level3_user_vsyscall));
+#endif
 	xen_mark_init_mm_pinned();
 }
 
@@ -1088,6 +1111,15 @@
 	}
 
 	__native_set_fixmap(idx, pte);
+
+#ifdef CONFIG_X86_64
+	/* Replicate changes to map the vsyscall page into the user
+	   pagetable vsyscall mapping. */
+	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+		unsigned long vaddr = __fix_to_virt(idx);
+		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
+	}
+#endif
 }
 
 static const struct pv_info xen_info __initdata = {
@@ -1427,13 +1459,6 @@
 		BUG();
 }
 
-/*
- * Identity map, in addition to plain kernel map.  This needs to be
- * large enough to allocate page table pages to allocate the rest.
- * Each page can map 2MB.
- */
-static pte_t level1_ident_pgt[PTRS_PER_PTE * 4] __page_aligned_bss;
-
 static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 {
 	unsigned pmdidx, pteidx;
@@ -1533,6 +1558,7 @@
 	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
 	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
 


