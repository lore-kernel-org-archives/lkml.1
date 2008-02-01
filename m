Return-Path: <linux-kernel-owner+w=401wt.eu-S1765730AbYBBJCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765730AbYBBJCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbYBBJBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:33 -0500
Received: from gw.goop.org ([64.81.55.164]:59433 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833AbYBBJBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 5] x86: add pud_alloc for 4-level pagetables
X-Mercurial-Node: 0ee47a6f9954fb3f7cef13124c471640773a42d9
Message-Id: <0ee47a6f9954fb3f7cef.1201908325@localhost>
In-Reply-To: <patchbomb.1201908323@localhost>
Date: Fri, 01 Feb 2008 15:25:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/paravirt.c |    2 ++
 arch/x86/mm/pgtable.c      |    1 +
 include/asm-x86/paravirt.h |   11 +++++++++++
 include/asm-x86/pgalloc.h  |    3 +++
 4 files changed, 17 insertions(+)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -385,8 +385,10 @@
 	.alloc_pte = paravirt_nop,
 	.alloc_pmd = paravirt_nop,
 	.alloc_pmd_clone = paravirt_nop,
+	.alloc_pud = paravirt_nop,
 	.release_pte = paravirt_nop,
 	.release_pmd = paravirt_nop,
+	.release_pud = paravirt_nop,
 
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -34,6 +34,7 @@
 #if PAGETABLE_LEVELS > 3
 void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
+	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
 	tlb_remove_page(tlb, virt_to_page(pud));
 }
 #endif	/* PAGETABLE_LEVELS > 3 */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -223,8 +223,10 @@
 	void (*alloc_pte)(struct mm_struct *mm, u32 pfn);
 	void (*alloc_pmd)(struct mm_struct *mm, u32 pfn);
 	void (*alloc_pmd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
+	void (*alloc_pud)(struct mm_struct *mm, u32 pfn);
 	void (*release_pte)(u32 pfn);
 	void (*release_pmd)(u32 pfn);
+	void (*release_pud)(u32 pfn);
 
 	/* Pagetable manipulation functions */
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
@@ -918,6 +920,15 @@
 	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
 }
 
+static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned pfn)
+{
+	PVOP_VCALL2(pv_mmu_ops.alloc_pud, mm, pfn);
+}
+static inline void paravirt_release_pud(unsigned pfn)
+{
+	PVOP_VCALL1(pv_mmu_ops.release_pud, pfn);
+}
+
 #ifdef CONFIG_HIGHPTE
 static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
 {
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -11,8 +11,10 @@
 #define paravirt_alloc_pte(mm, pfn) do { } while (0)
 #define paravirt_alloc_pmd(mm, pfn) do { } while (0)
 #define paravirt_alloc_pmd_clone(pfn, clonepfn, start, count) do { } while (0)
+#define paravirt_alloc_pud(mm, pfn) do { } while (0)
 #define paravirt_release_pte(pfn) do { } while (0)
 #define paravirt_release_pmd(pfn) do { } while (0)
+#define paravirt_release_pud(pfn) do { } while (0)
 #endif
 
 /*
@@ -93,6 +95,7 @@
 #if PAGETABLE_LEVELS > 3
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
 {
+	paravirt_alloc_pud(mm, __pa(pud) >> PAGE_SHIFT);
 	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
 }
 


