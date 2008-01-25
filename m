Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYAYVyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYAYVyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbYAYVw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:27 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37922 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757673AbYAYVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 11] x86: demacro asm-x86/pgalloc_32.h
X-Mercurial-Node: 7fea594bbd443d21a1b55e792fd144dab64c8171
Message-Id: <7fea594bbd443d21a1b5.1201296194@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert macros into inline functions, for better type-checking.

This patch required a little bit of fiddling with headers in order to
make __(pte|pmd)_free_tlb inline rather than macros.
asm-generic/tlb.h includes asm/pgalloc.h, though it doesn't directly
use any pgalloc definitions.  I removed this include to avoid an
include cycle, but it may cause secondary compile failures by things
depending on the indirect inclusion; arch/x86/mm/hugetlbpage.c was one
such place; there may be others.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/hugetlbpage.c        |    3 +
 arch/x86/mm/init_32.c            |    1
 include/asm-generic/tlb.h        |    1
 include/asm-x86/pgalloc_32.h     |   61 ++++++++++++++++++++++++--------------
 include/asm-x86/pgtable-3level.h |    2 -
 include/linux/swap.h             |    1
 6 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -15,6 +15,7 @@
 #include <asm/mman.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 static unsigned long page_table_shareable(struct vm_area_struct *svma,
 				struct vm_area_struct *vma,
@@ -88,7 +89,7 @@ static void huge_pmd_share(struct mm_str
 
 	spin_lock(&mm->page_table_lock);
 	if (pud_none(*pud))
-		pud_populate(mm, pud, (unsigned long) spte & PAGE_MASK);
+		pud_populate(mm, pud, (pmd_t *)((unsigned long)spte & PAGE_MASK));
 	else
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -42,6 +42,7 @@
 #include <asm/bugs.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/paravirt.h>
 #include <asm/setup.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -15,7 +15,6 @@
 
 #include <linux/swap.h>
 #include <linux/quicklist.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 /*
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -3,6 +3,8 @@
 
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
+#include <asm/tlb.h>
+#include <asm-generic/tlb.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
@@ -14,19 +16,20 @@
 #define paravirt_release_pd(pfn) do { } while (0)
 #endif
 
-#define pmd_populate_kernel(mm, pmd, pte)			\
-do {								\
-	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);		\
-	set_pmd(pmd, __pmd(_PAGE_TABLE + __pa(pte)));		\
-} while (0)
+static inline void pmd_populate_kernel(struct mm_struct *mm,
+				       pmd_t *pmd, pte_t *pte)
+{
+	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);
+	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+}
 
-#define pmd_populate(mm, pmd, pte) 				\
-do {								\
-	paravirt_alloc_pt(mm, page_to_pfn(pte));		\
-	set_pmd(pmd, __pmd(_PAGE_TABLE +			\
-		((unsigned long long)page_to_pfn(pte) <<	\
-			(unsigned long long) PAGE_SHIFT)));	\
-} while (0)
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
+{
+	unsigned long pfn = page_to_pfn(pte);
+
+	paravirt_alloc_pt(mm, pfn);
+	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
+}
 
 /*
  * Allocate and free page tables.
@@ -48,20 +51,34 @@ static inline void pte_free(struct page 
 }
 
 
-#define __pte_free_tlb(tlb,pte) 					\
-do {									\
-	paravirt_release_pt(page_to_pfn(pte));				\
-	tlb_remove_page((tlb),(pte));					\
-} while (0)
+static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
+	paravirt_release_pt(page_to_pfn(pte));
+	tlb_remove_page(tlb, pte);
+}
 
 #ifdef CONFIG_X86_PAE
 /*
  * In the PAE case we free the pmds as part of the pgd.
  */
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *)2); })
-#define pmd_free(x)			do { } while (0)
-#define __pmd_free_tlb(tlb,x)		do { } while (0)
-#define pud_populate(mm, pmd, pte)	BUG()
-#endif
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	BUG();
+	return (pmd_t *)2;
+}
+
+static inline void pmd_free(pmd_t *pmd)
+{
+}
+
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+}
+
+static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	BUG();
+}
+#endif	/* CONFIG_X86_PAE */
 
 #endif /* _I386_PGALLOC_H */
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -149,6 +149,4 @@ static inline unsigned long pte_pfn(pte_
 #define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t){ { .pte_high = (x).val } })
 
-#define __pmd_free_tlb(tlb, x)		do { } while (0)
-
 #endif /* _I386_PGTABLE_3LEVEL_H */
diff --git a/include/linux/swap.h b/include/linux/swap.h
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -6,6 +6,7 @@
 #include <linux/mmzone.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>


