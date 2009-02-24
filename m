Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZBXDMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZBXDMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZBXDMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:12:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:58402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZBXDMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:12:40 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] x86: update populate_extra_pte() and add populate_extra_pmd()
Date: Tue, 24 Feb 2009 12:11:36 +0900
Message-Id: <1235445101-7882-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: minor change to populate_extra_pte() and addition of pmd flavor

Update populate_extra_pte() to return pointer to the pte_t for the
specified address and add populate_extra_pmd() which only populates
till the pmd and returns pointer to the pmd entry for the address.

For 64bit, pud/pmd/pte fill functions are separated out from
set_pte_vaddr[_pud]() and used for set_pte_vaddr[_pud]() and
populate_extra_{pte|pmd}().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pgtable.h |    3 +-
 arch/x86/kernel/setup_percpu.c |    7 +++-
 arch/x86/mm/init_32.c          |   13 +++++--
 arch/x86/mm/init_64.c          |   75 ++++++++++++++++++++++++----------------
 4 files changed, 63 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index dd91c25..46312eb 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -402,7 +402,8 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
-void populate_extra_pte(unsigned long vaddr);
+pmd_t *populate_extra_pmd(unsigned long vaddr);
+pte_t *populate_extra_pte(unsigned long vaddr);
 
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 2dce435..671e652 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -41,6 +41,11 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
+static void __init pcpu4k_populate_pte(unsigned long addr)
+{
+	populate_extra_pte(addr);
+}
+
 static inline void setup_percpu_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
@@ -104,7 +109,7 @@ void __init setup_per_cpu_areas(void)
 		}
 	}
 
-	pcpu_unit_size = pcpu_setup_static(populate_extra_pte, pages, size);
+	pcpu_unit_size = pcpu_setup_static(pcpu4k_populate_pte, pages, size);
 
 	free_bootmem(__pa(pages), pages_size);
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8b1a0ef..84a2688 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -137,14 +137,21 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	return pte_offset_kernel(pmd, 0);
 }
 
-void __init populate_extra_pte(unsigned long vaddr)
+pmd_t * __init populate_extra_pmd(unsigned long vaddr)
 {
 	int pgd_idx = pgd_index(vaddr);
 	int pmd_idx = pmd_index(vaddr);
+
+	return one_md_table_init(swapper_pg_dir + pgd_idx) + pmd_idx;
+}
+
+pte_t * __init populate_extra_pte(unsigned long vaddr)
+{
+	int pte_idx = pte_index(vaddr);
 	pmd_t *pmd;
 
-	pmd = one_md_table_init(swapper_pg_dir + pgd_idx);
-	one_page_table_init(pmd + pmd_idx);
+	pmd = populate_extra_pmd(vaddr);
+	return one_page_table_init(pmd) + pte_idx;
 }
 
 static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7f91e2c..7d4e76d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -168,34 +168,51 @@ static __ref void *spp_getpage(void)
 	return ptr;
 }
 
-void
-set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
+static pud_t * __init fill_pud(pgd_t *pgd, unsigned long vaddr)
 {
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
+	if (pgd_none(*pgd)) {
+		pud_t *pud = (pud_t *)spp_getpage();
+		pgd_populate(&init_mm, pgd, pud);
+		if (pud != pud_offset(pgd, 0))
+			printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
+			       pud, pud_offset(pgd, 0));
+	}
+	return pud_offset(pgd, vaddr);
+}
 
-	pud = pud_page + pud_index(vaddr);
+static pmd_t * __init fill_pmd(pud_t *pud, unsigned long vaddr)
+{
 	if (pud_none(*pud)) {
-		pmd = (pmd_t *) spp_getpage();
+		pmd_t *pmd = (pmd_t *) spp_getpage();
 		pud_populate(&init_mm, pud, pmd);
-		if (pmd != pmd_offset(pud, 0)) {
+		if (pmd != pmd_offset(pud, 0))
 			printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
-				pmd, pmd_offset(pud, 0));
-			return;
-		}
+			       pmd, pmd_offset(pud, 0));
 	}
-	pmd = pmd_offset(pud, vaddr);
+	return pmd_offset(pud, vaddr);
+}
+
+static pte_t * __init fill_pte(pmd_t *pmd, unsigned long vaddr)
+{
 	if (pmd_none(*pmd)) {
-		pte = (pte_t *) spp_getpage();
+		pte_t *pte = (pte_t *) spp_getpage();
 		pmd_populate_kernel(&init_mm, pmd, pte);
-		if (pte != pte_offset_kernel(pmd, 0)) {
+		if (pte != pte_offset_kernel(pmd, 0))
 			printk(KERN_ERR "PAGETABLE BUG #02!\n");
-			return;
-		}
 	}
+	return pte_offset_kernel(pmd, vaddr);
+}
+
+void set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pud = pud_page + pud_index(vaddr);
+	pmd = fill_pmd(pud, vaddr);
+	pte = fill_pte(pmd, vaddr);
 
-	pte = pte_offset_kernel(pmd, vaddr);
 	set_pte(pte, new_pte);
 
 	/*
@@ -205,8 +222,7 @@ set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
 	__flush_tlb_one(vaddr);
 }
 
-void
-set_pte_vaddr(unsigned long vaddr, pte_t pteval)
+void set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 {
 	pgd_t *pgd;
 	pud_t *pud_page;
@@ -223,23 +239,22 @@ set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 	set_pte_vaddr_pud(pud_page, vaddr, pteval);
 }
 
-void __init populate_extra_pte(unsigned long vaddr)
+pmd_t * __init populate_extra_pmd(unsigned long vaddr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 
 	pgd = pgd_offset_k(vaddr);
-	if (pgd_none(*pgd)) {
-		pud = (pud_t *)spp_getpage();
-		pgd_populate(&init_mm, pgd, pud);
-		if (pud != pud_offset(pgd, 0)) {
-			printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
-			       pud, pud_offset(pgd, 0));
-			return;
-		}
-	}
+	pud = fill_pud(pgd, vaddr);
+	return fill_pmd(pud, vaddr);
+}
+
+pte_t * __init populate_extra_pte(unsigned long vaddr)
+{
+	pmd_t *pmd;
 
-	set_pte_vaddr_pud((pud_t *)pgd_page_vaddr(*pgd), vaddr, __pte(0));
+	pmd = populate_extra_pmd(vaddr);
+	return fill_pte(pmd, vaddr);
 }
 
 /*
-- 
1.6.0.2

