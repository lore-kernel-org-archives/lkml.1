Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbYGKDjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbYGKDjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 23:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYGKDjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 23:39:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:46477 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYGKDjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 23:39:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=woU3DHkxyC1xrHfjGpj7ObU/UL4JtPTBRNp3UKpN+sCKZsZ0/hD+/wiKGYHYvHIgZz
         8ArBAYw04ZQQ0DbbEY2N5ISbAAA1+YJbo7/qGUToHUwJrh+qNYRgzQ0YsdxJQJ9nvFBR
         Pa2aWUBUg0WzXnWHf+Bdl0DCokB7alpyqaMZ8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: introduce max_low_pfn_mapped for 64bit
Date: Thu, 10 Jul 2008 20:38:26 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com>
In-Reply-To: <200807092017.51004.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102038.26591.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when 4g more memory installed, don't map big hole below 4g.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c  |    2 +-
 arch/x86/kernel/cpu/amd_64.c |   10 +++++++---
 arch/x86/kernel/e820.c       |   23 ++++++++++++++++++++---
 arch/x86/kernel/efi.c        |    2 +-
 arch/x86/kernel/setup.c      |   22 ++++++++++++++++++----
 arch/x86/mm/init_32.c        |    1 +
 arch/x86/mm/init_64.c        |    1 +
 arch/x86/mm/pageattr.c       |   19 +++++++++++++++++--
 arch/x86/mm/pat.c            |    3 ++-
 arch/x86/pci/i386.c          |    4 +++-
 include/asm-x86/e820.h       |    3 ++-
 include/asm-x86/page.h       |    1 +
 12 files changed, 74 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -130,7 +130,7 @@ char *__init __acpi_map_table(unsigned l
 	if (!phys || !size)
 		return NULL;
 
-	if (phys+size <= (max_pfn_mapped << PAGE_SHIFT))
+	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
 		return __va(phys);
 
 	offset = phys & (PAGE_SIZE - 1);
Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -199,10 +199,14 @@ static void __cpuinit init_amd(struct cp
 		 * Don't do it for gbpages because there seems very little
 		 * benefit in doing so.
 		 */
-		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg) &&
-		    (tseg >> PMD_SHIFT) <
-			(max_pfn_mapped >> (PMD_SHIFT-PAGE_SHIFT)))
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+		    if ((tseg>>PMD_SHIFT) <
+				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
+			((tseg>>PMD_SHIFT) <
+				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
+			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
 			set_memory_4k((unsigned long)__va(tseg), 1);
+		}
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1056,7 +1056,7 @@ unsigned long __initdata end_user_pfn =
 /*
  * Find the highest page frame number we have available
  */
-unsigned long __init e820_end(void)
+static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 {
 	int i;
 	unsigned long last_pfn = 0;
@@ -1064,12 +1064,21 @@ unsigned long __init e820_end(void)
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
+		unsigned long start_pfn;
 		unsigned long end_pfn;
 
-		if (ei->type != E820_RAM)
+		if (ei->type != type)
 			continue;
 
+		start_pfn = ei->addr >> PAGE_SHIFT;
 		end_pfn = (ei->addr + ei->size) >> PAGE_SHIFT;
+
+		if (start_pfn >= limit_pfn)
+			continue;
+		if (end_pfn > limit_pfn) {
+			last_pfn = limit_pfn;
+			break;
+		}
 		if (end_pfn > last_pfn)
 			last_pfn = end_pfn;
 	}
@@ -1083,7 +1092,15 @@ unsigned long __init e820_end(void)
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
+unsigned long __init e820_end_of_ram_pfn(void)
+{
+	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
+}
 
+unsigned long __init e820_end_of_low_ram_pfn(void)
+{
+	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
+}
 /*
  * Finds an active region in the address range from start_pfn to last_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
@@ -1206,7 +1223,7 @@ static int __init parse_memmap_opt(char
 		 * the real mem size before original memory map is
 		 * reset.
 		 */
-		saved_max_pfn = e820_end();
+		saved_max_pfn = e820_end_of_ram_pfn();
 #endif
 		e820.nr_map = 0;
 		userdef = 1;
Index: linux-2.6/arch/x86/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -473,7 +473,7 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		if (PFN_UP(end) <= max_pfn_mapped)
+		if (PFN_UP(end) <= max_low_pfn_mapped)
 			va = __va(md->phys_addr);
 		else
 			va = efi_ioremap(md->phys_addr, size);
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -719,14 +719,14 @@ void __init setup_arch(char **cmdline_p)
 	 * partially used pages are not usable - thus
 	 * we are rounding upwards:
 	 */
-	max_pfn = e820_end();
+	max_pfn = e820_end_of_ram_pfn();
 
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 	/* update e820 for memory not covered by WB MTRRs */
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn))
-		max_pfn = e820_end();
+		max_pfn = e820_end_of_ram_pfn();
 
 #ifdef CONFIG_X86_32
 	/* max_low_pfn get updated here */
@@ -738,12 +738,26 @@ void __init setup_arch(char **cmdline_p)
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
-	max_low_pfn = max_pfn;
+	if (max_pfn > (1UL<<(32 - PAGE_SHIFT)))
+		max_low_pfn = e820_end_of_low_ram_pfn();
+	else
+		max_low_pfn = max_pfn;
+
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
 	/* max_pfn_mapped is updated here */
-	max_pfn_mapped = init_memory_mapping(0, (max_low_pfn << PAGE_SHIFT));
+	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	max_pfn_mapped = max_low_pfn_mapped;
+
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping(1UL<<32,
+						     max_pfn<<PAGE_SHIFT);
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -50,6 +50,7 @@
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
+unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -53,6 +53,7 @@
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
  * apertures, ACPI and other tables without having to play with fixmaps.
  */
+unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
 static unsigned long dma_reserve __initdata;
Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c
+++ linux-2.6/arch/x86/mm/pageattr.c
@@ -537,8 +537,14 @@ static int split_large_page(pte_t *kpte,
 		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
 
 	if (address >= (unsigned long)__va(0) &&
+		address < (unsigned long)__va(max_low_pfn_mapped << PAGE_SHIFT))
+		split_page_count(level);
+
+#ifdef CONFIG_X86_64
+	if (address >= (unsigned long)__va(1UL<<32) &&
 		address < (unsigned long)__va(max_pfn_mapped << PAGE_SHIFT))
 		split_page_count(level);
+#endif
 
 	/*
 	 * Install the new, split up pagetable. Important details here:
@@ -655,12 +661,21 @@ static int cpa_process_alias(struct cpa_
 	if (cpa->pfn > max_pfn_mapped)
 		return 0;
 
+#ifdef CONFIG_X86_64
+	if (cpa->pfn > max_low_pfn_mapped && cpa->pfn < (1UL<<(32-PAGE_SHIFT)))
+		return 0;
+#endif
 	/*
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (!within(cpa->vaddr, PAGE_OFFSET,
-		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+	if (!(within(cpa->vaddr, PAGE_OFFSET,
+		    PAGE_OFFSET + (max_low_pfn_mapped << PAGE_SHIFT))
+#ifdef CONFIG_X86_64
+		|| within(cpa->vaddr, PAGE_OFFSET + (1UL<<32),
+		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
+#endif
+	)) {
 
 		alias_cpa = *cpa;
 		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c
+++ linux-2.6/arch/x86/mm/pat.c
@@ -449,7 +449,8 @@ int phys_mem_access_prot_allowed(struct
 	if (retval < 0)
 		return 0;
 
-	if (pfn <= max_pfn_mapped &&
+	if (((pfn <= max_low_pfn_mapped) ||
+	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn <= max_pfn_mapped)) &&
 	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
 		free_memtype(offset, offset + size);
 		printk(KERN_INFO
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -334,7 +334,9 @@ int pci_mmap_page_range(struct pci_dev *
 		flags = new_flags;
 	}
 
-	if (vma->vm_pgoff <= max_pfn_mapped &&
+	if (((vma->vm_pgoff <= max_low_pfn_mapped) ||
+	     (vma->vm_pgoff >= (1UL<<(32 - PAGE_SHIFT)) &&
+	      vma->vm_pgoff <= max_pfn_mapped)) &&
 	    ioremap_change_attr((unsigned long)__va(addr), len, flags)) {
 		free_memtype(addr, addr + len);
 		return -EINVAL;
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -99,7 +99,8 @@ extern void free_early(u64 start, u64 en
 extern void early_res_to_bootmem(u64 start, u64 end);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
-extern unsigned long e820_end(void);
+extern unsigned long e820_end_of_ram_pfn(void);
+extern unsigned long e820_end_of_low_ram_pfn(void);
 extern int e820_find_active_region(const struct e820entry *ei,
 				  unsigned long start_pfn,
 				  unsigned long last_pfn,
Index: linux-2.6/include/asm-x86/page.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page.h
+++ linux-2.6/include/asm-x86/page.h
@@ -61,6 +61,7 @@ extern void map_devmem(unsigned long pfn
 extern void unmap_devmem(unsigned long pfn, unsigned long size,
 			 pgprot_t vma_prot);
 
+extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
 struct page;
