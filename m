Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYAYVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYAYVxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYAYVwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:24 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37912 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755105AbYAYVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 11] x86: use the same pgd_list for PAE and 64-bit
X-Mercurial-Node: cad0600467d1047483eea1895c012914b84bf4fb
Message-Id: <cad0600467d1047483ee.1201296191@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a standard list threaded through page->lru for maintaining the pgd
list on PAE.  This is the same as 64-bit, and seems saner than using a
non-standard list via page->index.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mm/fault.c          |   10 +++-------
 arch/x86/mm/pageattr.c       |    2 +-
 arch/x86/mm/pgtable_32.c     |   19 +++++--------------
 include/asm-x86/pgtable.h    |    2 ++
 include/asm-x86/pgtable_32.h |    2 --
 include/asm-x86/pgtable_64.h |    3 ---
 6 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -922,10 +922,8 @@ do_sigbus:
 	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
 }
 
-#ifdef CONFIG_X86_64
 DEFINE_SPINLOCK(pgd_lock);
 LIST_HEAD(pgd_list);
-#endif
 
 void vmalloc_sync_all(void)
 {
@@ -950,13 +948,11 @@ void vmalloc_sync_all(void)
 			struct page *page;
 
 			spin_lock_irqsave(&pgd_lock, flags);
-			for (page = pgd_list; page; page =
-					(struct page *)page->index)
+			list_for_each_entry(page, &pgd_list, lru) {
 				if (!vmalloc_sync_one(page_address(page),
-								address)) {
-					BUG_ON(page != pgd_list);
+						      address))
 					break;
-				}
+			}
 			spin_unlock_irqrestore(&pgd_lock, flags);
 			if (!page)
 				set_bit(pgd_index(address), insync);
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -100,7 +100,7 @@ static void __set_pmd_pte(pte_t *kpte, u
 	if (!SHARED_KERNEL_PMD) {
 		struct page *page;
 
-		for (page = pgd_list; page; page = (struct page *)page->index) {
+		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			pud_t *pud;
 			pmd_t *pmd;
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -210,27 +210,18 @@ void pmd_ctor(struct kmem_cache *cache, 
  * vmalloc faults work because attached pagetables are never freed.
  * -- wli
  */
-DEFINE_SPINLOCK(pgd_lock);
-struct page *pgd_list;
-
 static inline void pgd_list_add(pgd_t *pgd)
 {
 	struct page *page = virt_to_page(pgd);
-	page->index = (unsigned long)pgd_list;
-	if (pgd_list)
-		set_page_private(pgd_list, (unsigned long)&page->index);
-	pgd_list = page;
-	set_page_private(page, (unsigned long)&pgd_list);
+
+	list_add(&page->lru, &pgd_list);
 }
 
 static inline void pgd_list_del(pgd_t *pgd)
 {
-	struct page *next, **pprev, *page = virt_to_page(pgd);
-	next = (struct page *)page->index;
-	pprev = (struct page **)page_private(page);
-	*pprev = next;
-	if (next)
-		set_page_private(next, (unsigned long)pprev);
+	struct page *page = virt_to_page(pgd);
+
+	list_del(&page->lru);
 }
 
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -131,6 +131,8 @@ extern unsigned long empty_zero_page[PAG
 extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
+extern spinlock_t pgd_lock;
+extern struct list_head pgd_list;
 
 /*
  * The following only work if pte_present() is true.
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -27,8 +27,6 @@ struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
 extern struct kmem_cache *pmd_cache;
-extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
 void check_pgt_cache(void);
 
 void pmd_ctor(struct kmem_cache *, void *);
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -240,9 +240,6 @@ static inline unsigned long pmd_bad(pmd_
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
-extern spinlock_t pgd_lock;
-extern struct list_head pgd_list;
-
 extern int kern_addr_valid(unsigned long addr); 
 
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\


