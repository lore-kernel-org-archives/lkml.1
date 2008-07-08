Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYGHX1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYGHX1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYGHXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:09 -0400
Received: from gw.goop.org ([64.81.55.164]:51213 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420AbYGHXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 44 of 55] xen: rework pgd_walk to deal with 32/64 bit
X-Mercurial-Node: ff719e4b56d5027b933fb5723119344321b8c603
Message-Id: <ff719e4b56d5027b933f.1215554826@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite pgd_walk to deal with 64-bit address spaces.  There are two
notible features of 64-bit workspaces:

 1. The physical address is only 48 bits wide, with the upper 16 bits
    being sign extension; kernel addresses are negative, and userspace is
    positive.

 2. The Xen hypervisor mapping is at the negative-most address, just above
    the sign-extension hole.

1. means that we can't easily use addresses when traversing the space,
since we must deal with sign extension.  This rewrite expresses
everything in terms of pgd/pud/pmd indices, which means we don't need
to worry about the exact configuration of the virtual memory space.
This approach works equally well in 32-bit.

To deal with 2, assume the hole is between the uppermost userspace
address and PAGE_OFFSET.  For 64-bit this skips the Xen mapping hole.
For 32-bit, the hole is zero-sized.

In all cases, the uppermost kernel address is FIXADDR_TOP.

A side-effect of this patch is that the upper boundary is actually
handled properly, exposing a long-standing bug in 32-bit, which failed
to pin kernel pmd page.  The kernel pmd is not shared, and so must be
explicitly pinned, even though the kernel ptes are shared and don't
need pinning.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |  117 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 76 insertions(+), 41 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -44,6 +44,7 @@
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/fixmap.h>
 #include <asm/mmu_context.h>
 #include <asm/paravirt.h>
 #include <asm/linkage.h>
@@ -491,77 +492,103 @@
 #endif	/* PAGETABLE_LEVELS == 4 */
 
 /*
-  (Yet another) pagetable walker.  This one is intended for pinning a
-  pagetable.  This means that it walks a pagetable and calls the
-  callback function on each page it finds making up the page table,
-  at every level.  It walks the entire pagetable, but it only bothers
-  pinning pte pages which are below pte_limit.  In the normal case
-  this will be TASK_SIZE, but at boot we need to pin up to
-  FIXADDR_TOP.  But the important bit is that we don't pin beyond
-  there, because then we start getting into Xen's ptes.
-*/
-static int pgd_walk(pgd_t *pgd_base, int (*func)(struct page *, enum pt_level),
+ * (Yet another) pagetable walker.  This one is intended for pinning a
+ * pagetable.  This means that it walks a pagetable and calls the
+ * callback function on each page it finds making up the page table,
+ * at every level.  It walks the entire pagetable, but it only bothers
+ * pinning pte pages which are below limit.  In the normal case this
+ * will be STACK_TOP_MAX, but at boot we need to pin up to
+ * FIXADDR_TOP.
+ *
+ * For 32-bit the important bit is that we don't pin beyond there,
+ * because then we start getting into Xen's ptes.
+ *
+ * For 64-bit, we must skip the Xen hole in the middle of the address
+ * space, just after the big x86-64 virtual hole.
+ */
+static int pgd_walk(pgd_t *pgd, int (*func)(struct page *, enum pt_level),
 		    unsigned long limit)
 {
-	pgd_t *pgd = pgd_base;
 	int flush = 0;
-	unsigned long addr = 0;
-	unsigned long pgd_next;
+	unsigned hole_low, hole_high;
+	unsigned pgdidx_limit, pudidx_limit, pmdidx_limit;
+	unsigned pgdidx, pudidx, pmdidx;
 
-	BUG_ON(limit > FIXADDR_TOP);
+	/* The limit is the last byte to be touched */
+	limit--;
+	BUG_ON(limit >= FIXADDR_TOP);
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return 0;
 
-	for (; addr != FIXADDR_TOP; pgd++, addr = pgd_next) {
+	/*
+	 * 64-bit has a great big hole in the middle of the address
+	 * space, which contains the Xen mappings.  On 32-bit these
+	 * will end up making a zero-sized hole and so is a no-op.
+	 */
+	hole_low = pgd_index(STACK_TOP_MAX + PGDIR_SIZE - 1);
+	hole_high = pgd_index(PAGE_OFFSET);
+
+	pgdidx_limit = pgd_index(limit);
+#if PTRS_PER_PUD > 1
+	pudidx_limit = pud_index(limit);
+#else
+	pudidx_limit = 0;
+#endif
+#if PTRS_PER_PMD > 1
+	pmdidx_limit = pmd_index(limit);
+#else
+	pmdidx_limit = 0;
+#endif
+
+	flush |= (*func)(virt_to_page(pgd), PT_PGD);
+
+	for (pgdidx = 0; pgdidx <= pgdidx_limit; pgdidx++) {
 		pud_t *pud;
-		unsigned long pud_limit, pud_next;
 
-		pgd_next = pud_limit = pgd_addr_end(addr, FIXADDR_TOP);
-
-		if (!pgd_val(*pgd))
+		if (pgdidx >= hole_low && pgdidx < hole_high)
 			continue;
 
-		pud = pud_offset(pgd, 0);
+		if (!pgd_val(pgd[pgdidx]))
+			continue;
+
+		pud = pud_offset(&pgd[pgdidx], 0);
 
 		if (PTRS_PER_PUD > 1) /* not folded */
 			flush |= (*func)(virt_to_page(pud), PT_PUD);
 
-		for (; addr != pud_limit; pud++, addr = pud_next) {
+		for (pudidx = 0; pudidx < PTRS_PER_PUD; pudidx++) {
 			pmd_t *pmd;
-			unsigned long pmd_limit;
 
-			pud_next = pud_addr_end(addr, pud_limit);
+			if (pgdidx == pgdidx_limit &&
+			    pudidx > pudidx_limit)
+				goto out;
 
-			if (pud_next < limit)
-				pmd_limit = pud_next;
-			else
-				pmd_limit = limit;
-
-			if (pud_none(*pud))
+			if (pud_none(pud[pudidx]))
 				continue;
 
-			pmd = pmd_offset(pud, 0);
+			pmd = pmd_offset(&pud[pudidx], 0);
 
 			if (PTRS_PER_PMD > 1) /* not folded */
 				flush |= (*func)(virt_to_page(pmd), PT_PMD);
 
-			for (; addr != pmd_limit; pmd++) {
-				addr += (PAGE_SIZE * PTRS_PER_PTE);
-				if ((pmd_limit-1) < (addr-1)) {
-					addr = pmd_limit;
-					break;
-				}
+			for (pmdidx = 0; pmdidx < PTRS_PER_PMD; pmdidx++) {
+				struct page *pte;
 
-				if (pmd_none(*pmd))
+				if (pgdidx == pgdidx_limit &&
+				    pudidx == pudidx_limit &&
+				    pmdidx > pmdidx_limit)
+					goto out;
+
+				if (pmd_none(pmd[pmdidx]))
 					continue;
 
-				flush |= (*func)(pmd_page(*pmd), PT_PTE);
+				pte = pmd_page(pmd[pmdidx]);
+				flush |= (*func)(pte, PT_PTE);
 			}
 		}
 	}
-
-	flush |= (*func)(virt_to_page(pgd_base), PT_PGD);
+out:
 
 	return flush;
 }
@@ -650,6 +677,11 @@
 		xen_mc_batch();
 	}
 
+#ifdef CONFIG_X86_PAE
+	/* Need to make sure unshared kernel PMD is pinnable */
+	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+#endif
+
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
 	xen_mc_issue(0);
 }
@@ -731,6 +763,10 @@
 
 	xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
+#ifdef CONFIG_X86_PAE
+	/* Need to make sure unshared kernel PMD is unpinned */
+	pin_page(virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])), PT_PMD);
+#endif
 	pgd_walk(pgd, unpin_page, TASK_SIZE);
 
 	xen_mc_issue(0);
@@ -750,7 +786,6 @@
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
 			BUG_ON(!PagePinned(page));
-			printk("unpinning pinned %p\n", page_address(page));
 			xen_pgd_unpin((pgd_t *)page_address(page));
 			ClearPageSavePinned(page);
 		}


