Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYBKN1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYBKN1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYBKN1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:27:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:49067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbYBKN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:27:21 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
Date: Mon, 11 Feb 2008 14:27:16 +0100
User-Agent: KMail/1.9.6
Cc: ying.huang@intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <20080211093434.E30961B41CE@basil.firstfloor.org> <20080211130843.GC23733@elte.hu>
In-Reply-To: <20080211130843.GC23733@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111427.16288.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 14:08:43 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > When end_pfn is not aligned to 2MB (or 1GB) then the kernel might map 
> > more memory than end_pfn. Account this in end_pfn_mapped.
> 
> can you see any practical relevance? 

Yes EFI needs to know this to decide if it should ioremap or not.

> Your patch description only deals  
> with the mechanical details of the change instead of analyzing the most 
> important thing: relevance and impact analysis. 

I repeat:

"This is needed for other code that needs to know the true
mapping alias state (in this case EFI)."

and

"This is important for code that really needs to know about
all mapping aliases. Needed for followup patches (in this case EFI)"

> That makes it harder to  
> add your patches and easier to miss a good fix accidentally. It also 
> makes it quite a bit harder to trust your patches.
> 
> at a quick glance the relevance is to EFI only, in 
> efi_enter_virtual_mode(). max_pfn_mapped is used as a differentiator 
> between __va() and efi_ioremap(). AFAICS EFI will typically have its 
> runtime code not right after the end of physical memory.
> 
> Nevertheless, i do agree that the max_pfn_mapped/end_pfn_map limit needs 
> to be sharpened to reflect reality (for later PAT support).
> 
> your patch is also a bit unclean:

Ok patch with hungarized variables appended.

-Andi

---

Account overlapped mappings in end_pfn_map

When end_pfn is not aligned to 2MB (or 1GB) then the kernel might
map more memory than end_pfn. Account this in end_pfn_mapped.

This is needed for other code that needs to know the true
mapping alias state (in this case EFI).

But it's also more correct in general

Cc: ying.huang@intel.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/setup_64.c |    4 +++-
 arch/x86/mm/init_64.c      |   33 +++++++++++++++++++++++----------
 include/asm-x86/proto.h    |    2 +-
 3 files changed, 27 insertions(+), 12 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -287,7 +287,7 @@ __meminit void early_iounmap(void *addr,
 	__flush_tlb_all();
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
 	int i = pmd_index(address);
@@ -309,21 +309,25 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		set_pte((pte_t *)pmd,
 			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
+	return address;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
 {
+	unsigned long true_end;
 	pmd_t *pmd = pmd_offset(pud, 0);
 	spin_lock(&init_mm.page_table_lock);
-	phys_pmd_init(pmd, address, end);
+	true_end = phys_pmd_init(pmd, address, end);
 	spin_unlock(&init_mm.page_table_lock);
 	__flush_tlb_all();
+	return true_end;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
 {
+	unsigned long true_end = end;
 	int i = pud_index(addr);
 
 	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE) {
@@ -342,13 +346,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud))
-				phys_pmd_update(pud, addr, end);
+				true_end = phys_pmd_update(pud, addr, end);
 			continue;
 		}
 
 		if (direct_gbpages) {
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			true_end = (addr & PUD_MASK) + PUD_SIZE;
 			continue;
 		}
 
@@ -356,12 +361,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
 		spin_lock(&init_mm.page_table_lock);
 		set_pud(pud, __pud(pmd_phys | _KERNPG_TABLE));
-		phys_pmd_init(pmd, addr, end);
+		true_end = phys_pmd_init(pmd, addr, end);
 		spin_unlock(&init_mm.page_table_lock);
 
 		unmap_low_page(pmd);
 	}
 	__flush_tlb_all();
+
+	return true_end >> PAGE_SHIFT;
 }
 
 static void __init find_early_table_space(unsigned long end)
@@ -406,9 +413,10 @@ static void __init init_gbpages(void)
  * This runs before bootmem is initialized and gets pages directly from
  * the physical memory. To access them they are temporarily mapped.
  */
-void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
+unsigned long __init_refok
+init_memory_mapping(unsigned long start, unsigned long end)
 {
-	unsigned long next;
+	unsigned long next, true_end = end;
 
 	pr_debug("init_memory_mapping\n");
 
@@ -446,7 +454,7 @@ void __init_refok init_memory_mapping(un
 		next = start + PGDIR_SIZE;
 		if (next > end)
 			next = end;
-		phys_pud_init(pud, __pa(start), __pa(next));
+		true_end = phys_pud_init(pud, __pa(start), __pa(next));
 		set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(pud);
 	}
@@ -458,6 +466,8 @@ void __init_refok init_memory_mapping(un
 	if (!after_bootmem)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
+
+	return true_end;
 }
 
 #ifndef CONFIG_NUMA
@@ -499,9 +509,12 @@ int arch_add_memory(int nid, u64 start, 
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long true_end_pfn;
 	int ret;
 
-	init_memory_mapping(start, start + size-1);
+	true_end_pfn = init_memory_mapping(start, start + size-1);
+	if (true_end_pfn > end_pfn_map)
+		end_pfn_map = true_end_pfn;
 
 	ret = __add_pages(zone, start_pfn, nr_pages);
 	WARN_ON(1);
Index: linux/include/asm-x86/proto.h
===================================================================
--- linux.orig/include/asm-x86/proto.h
+++ linux/include/asm-x86/proto.h
@@ -7,7 +7,8 @@
 
 extern void early_idt_handler(void);
 
-extern void init_memory_mapping(unsigned long start, unsigned long end);
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
 
 extern void system_call(void);
 extern void syscall_init(void);
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -341,7 +341,7 @@ void __init setup_arch(char **cmdline_p)
 
 	check_efer();
 
-	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	end_pfn_map = init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
 	if (efi_enabled)
 		efi_init();
 

