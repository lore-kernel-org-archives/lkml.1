Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbYGHXay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbYGHXay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbYGHXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:21 -0400
Received: from gw.goop.org ([64.81.55.164]:51221 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 30 of 55] xen64: map an initial chunk of physical memory
X-Mercurial-Node: 3c3340568c38c7bbc635c4dcdda5ed4a127bcb3f
Message-Id: <3c3340568c38c7bbc635.1215554812@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early in boot, map a chunk of extra physical memory for use later on.
We need a pool of mapped pages to allocate further pages to construct
pagetables mapping all physical memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   79 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1382,6 +1382,61 @@
 }
 
 /*
+ * Identity map, in addition to plain kernel map.  This needs to be
+ * large enough to allocate page table pages to allocate the rest.
+ * Each page can map 2MB.
+ */
+static pte_t level1_ident_pgt[PTRS_PER_PTE * 4] __page_aligned_bss;
+
+static __init void xen_map_identity_early(unsigned long max_pfn)
+{
+	unsigned pmdidx, pteidx;
+	unsigned ident_pte;
+	unsigned long pfn;
+
+	ident_pte = 0;
+	pfn = 0;
+	for(pmdidx = 0; pmdidx < PTRS_PER_PMD && pfn < max_pfn; pmdidx++) {
+		pte_t *pte_page;
+
+		BUG_ON(level2_ident_pgt[pmdidx].pmd != level2_kernel_pgt[pmdidx].pmd);
+
+		/* Reuse or allocate a page of ptes */
+		if (pmd_present(level2_ident_pgt[pmdidx]))
+			pte_page = m2v(level2_ident_pgt[pmdidx].pmd);
+		else {
+			/* Check for free pte pages */
+			if (ident_pte == ARRAY_SIZE(level1_ident_pgt))
+				break;
+
+			pte_page = &level1_ident_pgt[ident_pte];
+			ident_pte += PTRS_PER_PTE;
+
+			/* Install new l1 in l2(s) */
+			level2_ident_pgt[pmdidx] = __pmd(__pa(pte_page) | _PAGE_TABLE);
+			level2_kernel_pgt[pmdidx] = level2_ident_pgt[pmdidx];
+		}
+
+		/* Install mappings */
+		for(pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
+			pte_t pte;
+
+			if (pfn > max_pfn_mapped)
+				max_pfn_mapped = pfn;
+
+			if (!pte_none(pte_page[pteidx]))
+				continue;
+
+			pte = pfn_pte(pfn, PAGE_KERNEL_EXEC);
+			pte_page[pteidx] = pte;
+		}
+	}
+
+	for(pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
+		set_page_prot(&level1_ident_pgt[pteidx], PAGE_KERNEL_RO);
+}
+
+/*
  * Set up the inital kernel pagetable.
  *
  * We can construct this by grafting the Xen provided pagetable into
@@ -1392,7 +1447,7 @@
  * of the physical mapping once some sort of allocator has been set
  * up.
  */
-static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd)
+static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
 	pud_t *l3;
 	pmd_t *l2;
@@ -1415,6 +1470,9 @@
 	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
 	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
 
+	/* Set up identity map */
+	xen_map_identity_early(max_pfn);
+
 	/* Make pagetable pieces RO */
 	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
@@ -1424,7 +1482,7 @@
 	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
 
 	/* Pin down new L4 */
-	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(init_level4_pgt)));
+	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa_symbol(init_level4_pgt)));
 
 	/* Unpin Xen-provided one */
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
@@ -1433,18 +1491,22 @@
 	pgd = init_level4_pgt;
 	xen_write_cr3(__pa(pgd));
 
-	max_pfn_mapped = PFN_DOWN(__pa(pgd) +
-				  xen_start_info->nr_pt_frames*PAGE_SIZE +
-				  512*1024);
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
 
 	return pgd;
 }
 #else
-static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd)
+static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
 	init_pg_tables_start = __pa(pgd);
 	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
 	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
+
+	x86_write_percpu(xen_cr3, __pa(pgd));
+	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
 	return pgd;
 }
@@ -1502,14 +1564,11 @@
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
 	xen_raw_console_write("mapping kernel into physical memory\n");
-	pgd = xen_setup_kernel_pagetable(pgd);
+	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 
 	init_mm.pgd = pgd;
 
 	/* keep using Xen gdt for now; no urgent need to change it */
-
-	x86_write_percpu(xen_cr3, __pa(pgd));
-	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))


