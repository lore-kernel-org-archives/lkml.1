Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbYGHXW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbYGHXW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbYGHXOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:55 -0400
Received: from gw.goop.org ([64.81.55.164]:51220 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 55] xen64: early mapping setup
X-Mercurial-Node: 7941e87690cf4b82c65bba01e2fff3191332d265
Message-Id: <7941e87690cf4b82c65b.1215554810@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up the initial pagetables to map the kernel mapping into the
physical mapping space.  This makes __va() usable, since it requires
physical mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c     |  192 ++++++++++++++++++++++++++++++++++++++----
 include/asm-x86/pgtable_64.h |    2
 2 files changed, 178 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -33,6 +33,7 @@
 #include <xen/interface/sched.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/hvc-console.h>
 
 #include <asm/paravirt.h>
 #include <asm/page.h>
@@ -1294,6 +1295,157 @@
 #endif	/* CONFIG_X86_32 */
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * Like __va(), but returns address in the kernel mapping (which is
+ * all we have until the physical memory mapping has been set up.
+ */
+static void *__ka(phys_addr_t paddr)
+{
+	return (void *)(paddr + __START_KERNEL_map);
+}
+
+/* Convert a machine address to physical address */
+static unsigned long m2p(phys_addr_t maddr)
+{
+	phys_addr_t paddr;
+
+	maddr &= PTE_MASK;
+	paddr = mfn_to_pfn(maddr >> PAGE_SHIFT) << PAGE_SHIFT;
+
+	return paddr;
+}
+
+/* Convert a machine address to kernel virtual */
+static void *m2v(phys_addr_t maddr)
+{
+	return __ka(m2p(maddr));
+}
+
+static void walk(pgd_t *pgd, unsigned long addr)
+{
+	unsigned l4idx = pgd_index(addr);
+	unsigned l3idx = pud_index(addr);
+	unsigned l2idx = pmd_index(addr);
+	unsigned l1idx = pte_index(addr);
+	pgd_t l4;
+	pud_t l3;
+	pmd_t l2;
+	pte_t l1;
+
+	xen_raw_printk("walk %p, %lx -> %d %d %d %d\n",
+		       pgd, addr, l4idx, l3idx, l2idx, l1idx);
+
+	l4 = pgd[l4idx];
+	xen_raw_printk("  l4: %016lx\n", l4.pgd);
+	xen_raw_printk("      %016lx\n", pgd_val(l4));
+
+	l3 = ((pud_t *)(m2v(l4.pgd)))[l3idx];
+	xen_raw_printk("  l3: %016lx\n", l3.pud);
+	xen_raw_printk("      %016lx\n", pud_val(l3));
+
+	l2 = ((pmd_t *)(m2v(l3.pud)))[l2idx];
+	xen_raw_printk("  l2: %016lx\n", l2.pmd);
+	xen_raw_printk("      %016lx\n", pmd_val(l2));
+
+	l1 = ((pte_t *)(m2v(l2.pmd)))[l1idx];
+	xen_raw_printk("  l1: %016lx\n", l1.pte);
+	xen_raw_printk("      %016lx\n", pte_val(l1));
+}
+
+static void set_page_prot(void *addr, pgprot_t prot)
+{
+	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
+	pte_t pte = pfn_pte(pfn, prot);
+
+	xen_raw_printk("addr=%p pfn=%lx mfn=%lx prot=%016x pte=%016x\n",
+		       addr, pfn, get_phys_to_machine(pfn),
+		       pgprot_val(prot), pte.pte);
+
+	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
+		BUG();
+}
+
+static void convert_pfn_mfn(void *v)
+{
+	pte_t *pte = v;
+	int i;
+
+	/* All levels are converted the same way, so just treat them
+	   as ptes. */
+	for(i = 0; i < PTRS_PER_PTE; i++)
+		pte[i] = xen_make_pte(pte[i].pte);
+}
+
+/*
+ * Set up the inital kernel pagetable.
+ *
+ * We can construct this by grafting the Xen provided pagetable into
+ * head_64.S's preconstructed pagetables.  We copy the Xen L2's into
+ * level2_ident_pgt, level2_kernel_pgt and level2_fixmap_pgt.  This
+ * means that only the kernel has a physical mapping to start with -
+ * but that's enough to get __va working.  We need to fill in the rest
+ * of the physical mapping once some sort of allocator has been set
+ * up.
+ */
+static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd)
+{
+	pud_t *l3;
+	pmd_t *l2;
+
+	/* Zap identity mapping */
+	init_level4_pgt[0] = __pgd(0);
+
+	/* Pre-constructed entries are in pfn, so convert to mfn */
+	convert_pfn_mfn(init_level4_pgt);
+	convert_pfn_mfn(level3_ident_pgt);
+	convert_pfn_mfn(level3_kernel_pgt);
+
+	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
+	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
+
+	memcpy(level2_ident_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+	memcpy(level2_kernel_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+
+	l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
+	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
+	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
+
+	/* Make pagetable pieces RO */
+	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
+
+	/* Pin down new L4 */
+	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(init_level4_pgt)));
+
+	/* Unpin Xen-provided one */
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
+
+	/* Switch over */
+	pgd = init_level4_pgt;
+	xen_write_cr3(__pa(pgd));
+
+	max_pfn_mapped = PFN_DOWN(__pa(pgd) +
+				  xen_start_info->nr_pt_frames*PAGE_SIZE +
+				  512*1024);
+
+	return pgd;
+}
+#else
+static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd)
+{
+	init_pg_tables_start = __pa(pgd);
+	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
+	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
+
+	return pgd;
+}
+#endif	/* CONFIG_X86_64 */
+
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
@@ -1336,31 +1488,28 @@
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-#ifdef CONFIG_X86_32
-	init_pg_tables_start = __pa(pgd);
-	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
-	max_pfn_mapped = (init_pg_tables_end + 512*1024) >> PAGE_SHIFT;
-#endif
+	/* Prevent unwanted bits from being set in PTEs. */
+	__supported_pte_mask &= ~_PAGE_GLOBAL;
+	if (!is_initial_xendomain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
-	init_mm.pgd = pgd; /* use the Xen pagetables to start */
+	/* Don't do the full vcpu_info placement stuff until we have a
+	   possible map and a non-dummy shared_info. */
+	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+
+	xen_raw_console_write("mapping kernel into physical memory\n");
+	pgd = xen_setup_kernel_pagetable(pgd);
+
+	init_mm.pgd = pgd;
 
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 	x86_write_percpu(xen_cr3, __pa(pgd));
 	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
-	/* Don't do the full vcpu_info placement stuff until we have a
-	   possible map and a non-dummy shared_info. */
-	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
-
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
-
-	/* Prevent unwanted bits from being set in PTEs. */
-	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (!is_initial_xendomain())
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	/* set the limit of our address space */
 	xen_reserve_top();
@@ -1384,10 +1533,21 @@
 		add_preferred_console("hvc", 0, NULL);
 	}
 
+	xen_raw_console_write("about to get started...\n");
+
+#if 0
+	xen_raw_printk("&boot_params=%p __pa(&boot_params)=%lx __va(__pa(&boot_params))=%lx\n",
+		       &boot_params, __pa_symbol(&boot_params),
+		       __va(__pa_symbol(&boot_params)));
+
+	walk(pgd, &boot_params);
+	walk(pgd, __va(__pa(&boot_params)));
+#endif
+
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();
 #else
-	x86_64_start_kernel((char *)&boot_params);
+	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
 #endif
 }
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -16,6 +16,8 @@
 extern pud_t level3_kernel_pgt[512];
 extern pud_t level3_ident_pgt[512];
 extern pmd_t level2_kernel_pgt[512];
+extern pmd_t level2_fixmap_pgt[512];
+extern pmd_t level2_ident_pgt[512];
 extern pgd_t init_level4_pgt[];
 
 #define swapper_pg_dir init_level4_pgt


