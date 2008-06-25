Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYFYEki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYFYEki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYFYEhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:19 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37455 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753720AbYFYEhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 36] x86_64: adjust mapping of physical pagetables to
	work with Xen
X-Mercurial-Node: aa722b5444fdde7ffa52b3c446f8b6fc09bf5aa7
Message-Id: <aa722b5444fdde7ffa52.1214367559@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes a few of changes to the construction of the initial
pagetables to work better with paravirt_ops/Xen.  The main areas
are:

 1. Support non-PSE mapping of memory, since Xen doesn't currently
    allow 2M pages to be mapped in guests.

 2. Make sure that the ioremap alias of all pages are dropped before
    attaching the new page to the pagetable.  This avoids having
    writable aliases of pagetable pages.

 3. Preserve existing pagetable entries, rather than overwriting.  Its
    possible that a fair amount of pagetable has already been constructed,
    so reuse what's already in place rather than ignoring and overwriting it.

The algorithm relies on the invariant that any page which is part of
the kernel pagetable is itself mapped in the linear memory area.  This
way, it can avoid using ioremap on a pagetable page.

The invariant holds because it maps memory from low to high addresses,
and also allocates memory from low to high.  Each allocated page can
map at least 2M of address space, so the mapped area will always
progress much faster than the allocated area.  It relies on the early
boot code mapping enough pages to get started.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |   94 ++++++++++++++++++++++++++++++++++++++++++-------
 arch/x86/mm/ioremap.c |    2 -
 2 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -257,6 +257,43 @@
 	early_iounmap(adr, PAGE_SIZE);
 }
 
+static void __meminit
+phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
+{
+	unsigned pages = 0;
+	int i;
+	pte_t *pte = pte_page + pte_index(addr);
+
+	for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
+
+		if (addr >= end) {
+			if (!after_bootmem) {
+				for(; i < PTRS_PER_PTE; i++, pte++)
+					set_pte(pte, __pte(0));
+			}
+			break;
+		}
+
+		if (pte_val(*pte))
+			continue;
+
+		if (0)
+			printk("   pte=%p addr=%lx pte=%016lx\n",
+			       pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
+		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
+		pages++;
+	}
+	update_page_count(PG_LEVEL_4K, pages);
+}
+
+static void __meminit
+phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end)
+{
+	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
+
+	phys_pte_init(pte, address, end);
+}
+
 static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
@@ -265,7 +302,9 @@
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
+		unsigned long pte_phys;
 		pmd_t *pmd = pmd_page + pmd_index(address);
+		pte_t *pte;
 
 		if (address >= end) {
 			if (!after_bootmem) {
@@ -275,12 +314,23 @@
 			break;
 		}
 
-		if (pmd_val(*pmd))
+		if (pmd_val(*pmd)) {
+			phys_pte_update(pmd, address, end);
 			continue;
+		}
 
-		pages++;
-		set_pte((pte_t *)pmd,
-			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+		if (cpu_has_pse) {
+			pages++;
+			set_pte((pte_t *)pmd,
+				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			continue;
+		}
+
+		pte = alloc_low_page(&pte_phys);
+		phys_pte_init(pte, address, end);
+		unmap_low_page(pte);
+
+		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
 	}
 	update_page_count(PG_LEVEL_2M, pages);
 	return address;
@@ -337,11 +387,11 @@
 		pmd = alloc_low_page(&pmd_phys);
 
 		spin_lock(&init_mm.page_table_lock);
+		last_map_addr = phys_pmd_init(pmd, addr, end);
+		unmap_low_page(pmd);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
-		last_map_addr = phys_pmd_init(pmd, addr, end);
 		spin_unlock(&init_mm.page_table_lock);
 
-		unmap_low_page(pmd);
 	}
 	__flush_tlb_all();
 	update_page_count(PG_LEVEL_1G, pages);
@@ -349,15 +399,29 @@
 	return last_map_addr >> PAGE_SHIFT;
 }
 
+static unsigned long __meminit
+phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end)
+{
+	pud_t *pud;
+
+	pud = (pud_t *)pgd_page_vaddr(*pgd);
+
+	return phys_pud_init(pud, addr, end);
+}
+
 static void __init find_early_table_space(unsigned long end)
 {
-	unsigned long puds, pmds, tables, start;
+	unsigned long puds, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
 	if (!direct_gbpages) {
-		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+		unsigned long pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 		tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	}
+	if (!cpu_has_pse) {
+		unsigned long ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		tables += round_up(ptes * sizeof(pte_t), PAGE_SIZE);
 	}
 
 	/*
@@ -529,19 +593,25 @@
 		unsigned long pud_phys;
 		pud_t *pud;
 
+		next = start + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pgd_val(*pgd)) {
+			last_map_addr = phys_pud_update(pgd, __pa(start), __pa(end));
+			continue;
+		}
+
 		if (after_bootmem)
 			pud = pud_offset(pgd, start & PGDIR_MASK);
 		else
 			pud = alloc_low_page(&pud_phys);
 
-		next = start + PGDIR_SIZE;
-		if (next > end)
-			next = end;
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));
+		unmap_low_page(pud);
 		if (!after_bootmem)
 			pgd_populate(&init_mm, pgd_offset_k(start),
 				     __va(pud_phys));
-		unmap_low_page(pud);
 	}
 
 	if (!after_bootmem)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -513,7 +513,7 @@
 	if (pgprot_val(flags))
 		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
 	else
-		pte_clear(NULL, addr, pte);
+		pte_clear(&init_mm, addr, pte);
 	__flush_tlb_one(addr);
 }
 


