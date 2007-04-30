Return-Path: <linux-kernel-owner+w=401wt.eu-S1946045AbXD3QUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946045AbXD3QUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423504AbXD3QT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:19:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52751 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423630AbXD3QQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:16:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 08/12] i386: Convert the boot time page tables to the kernels native format.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 10:15:08 -0600
In-Reply-To: <m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 30 Apr 2007 10:10:49 -0600")
Message-ID: <m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we have a lot of special case code and a lot of limitations
because we cannot count on the initial boot time page tables being in
the format our page table handling routines know how to manipulate.
So this patch rewrites the code that initializes our boot time page
tables.

The error message for running on cpus that don't support PAE mode is
removed from mm/init.c.  We are already checking and printing an error
message to the user in setup.S.

boot_ioreamp is removed and replaced with the already existing and
semantically equivalent bt_ioremap.  The practical difference was that
bt_ioremap used fixmaps where boot_ioremap hacked the boot time page
table.  Since the boot time page table is now in the native format
fixmaps work as soon as we hit C code.

The voyager code is modified to use bt_ioremap, instead of hacking the
page tables in an ugly way.  We now have a good universal replacement
and changing voyager means nothing cares which order we store the
pages in pg0. 

The meat of the change is the introduction of the function
early_pgtable_init written in C to build the initial page tables. By
writing in C, I only have about 6 lines of code that are different
between the PAE and the non-PAE case, and the code is a little more
approachable.  Unfortuantely we still have to contend with the fact
that the code is running in a very weird environment and so can not
use virtual addresses.  Which limits the opportunites for code reuse.

The page table entry flags now use the standard defines from pgtable.h
instead of a hard coded 0x007 which while not wrong was not really
correct either.

The big change is that now the boot time page tables now add an extra
pte page to support the kernel fixmap entries.  In addition to being
very useful this was necessary so that boot_ioremap could be replaced
with something that work in the presence of PAE page tables.

The net result is a simpler and easier to work in, early boot
environment.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/Kconfig                      |    7 --
 arch/i386/kernel/efi.c                 |   15 +--
 arch/i386/kernel/head.S                |   66 +------------
 arch/i386/kernel/setup.c               |    4 +
 arch/i386/kernel/srat.c                |    8 +-
 arch/i386/mach-voyager/voyager_basic.c |   16 +--
 arch/i386/mm/Makefile                  |    1 -
 arch/i386/mm/boot_ioremap.c            |  100 --------------------
 arch/i386/mm/init.c                    |  159 +++++++++++++++++++++++---------
 include/asm-i386/page.h                |    1 -
 include/asm-i386/pgtable.h             |    4 -
 11 files changed, 137 insertions(+), 244 deletions(-)
 delete mode 100644 arch/i386/mm/boot_ioremap.c

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 80003de..ae00af8 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -750,13 +750,6 @@ config IRQBALANCE
  	  The default yes will allow the kernel to do irq load balancing.
 	  Saying no will keep the kernel from doing irq load balancing.
 
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
-config BOOT_IOREMAP
-	bool
-	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
-	default y
-
 config SECCOMP
 	bool "Enable seccomp to safely compute untrusted bytecode"
 	depends on PROC_FS
diff --git a/arch/i386/kernel/efi.c b/arch/i386/kernel/efi.c
index dd9e7fa..1319bae 100644
--- a/arch/i386/kernel/efi.c
+++ b/arch/i386/kernel/efi.c
@@ -50,11 +50,6 @@ static struct efi efi_phys;
 struct efi_memory_map memmap;
 
 /*
- * We require an early boot_ioremap mapping mechanism initially
- */
-extern void * boot_ioremap(unsigned long, unsigned long);
-
-/*
  * To make EFI call EFI runtime service in physical addressing mode we need
  * prelog/epilog before/after the invocation to disable interrupt, to
  * claim EFI runtime service handler exclusively and to duplicate a memory in
@@ -338,7 +333,7 @@ void __init efi_init(void)
 	memmap.desc_size = EFI_MEMDESC_SIZE;
 
 	efi.systab = (efi_system_table_t *)
-		boot_ioremap((unsigned long) efi_phys.systab,
+		bt_ioremap((unsigned long) efi_phys.systab,
 			sizeof(efi_system_table_t));
 	/*
 	 * Verify the EFI Table
@@ -365,7 +360,7 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = (efi_char16_t *) boot_ioremap(efi.systab->fw_vendor, 2);
+	c16 = (efi_char16_t *) bt_ioremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < (sizeof(vendor) - 1) && *c16; ++i)
 			vendor[i] = *c16++;
@@ -381,7 +376,7 @@ void __init efi_init(void)
 	 * Let's see what config tables the firmware passed to us.
 	 */
 	config_tables = (efi_config_table_t *)
-				boot_ioremap((unsigned long) config_tables,
+				bt_ioremap((unsigned long) config_tables,
 			        num_config_tables * sizeof(efi_config_table_t));
 
 	if (config_tables == NULL)
@@ -431,7 +426,7 @@ void __init efi_init(void)
 	 * set the firmware into virtual mode.
 	 */
 
-	runtime = (efi_runtime_services_t *) boot_ioremap((unsigned long)
+	runtime = (efi_runtime_services_t *) bt_ioremap((unsigned long)
 						runtime,
 				      		sizeof(efi_runtime_services_t));
 	if (runtime != NULL) {
@@ -448,7 +443,7 @@ void __init efi_init(void)
 		printk(KERN_ERR PFX "Could not map the runtime service table!\n");
 
 	/* Map the EFI memory map for use until paging_init() */
-	memmap.map = boot_ioremap((unsigned long) EFI_MEMMAP, EFI_MEMMAP_SIZE);
+	memmap.map = bt_ioremap((unsigned long) EFI_MEMMAP, EFI_MEMMAP_SIZE);
 	if (memmap.map == NULL)
 		printk(KERN_ERR PFX "Could not map the EFI memory map!\n");
 
diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index 248d44c..de65f45 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -33,35 +33,6 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
- * We need:
- *  - one bit for each possible page, but only in low memory, which means
- *     2^32/4096/8 = 128K worst case (4G/4G split.)
- *  - enough space to map all low memory, which means
- *     (2^32/4096) / 1024 pages (worst case, non PAE)
- *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
- *  - a few pages for allocator use before the kernel pagetable has
- *     been set up
- *
- * Modulo rounding, each megabyte assigned here requires a kilobyte of
- * memory, which is currently unreclaimed.
- *
- * This should be a multiple of a page.
- */
-LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
-
-#if PTRS_PER_PMD > 1
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
-#else
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
-#endif
-BOOTBITMAP_SIZE = LOW_PAGES / 8
-ALLOCATOR_SLOP = 4
-
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
-
-/*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
  * %esi points to the real-mode code as a 32-bit pointer.
  * CS and DS must be 4 GB flat segments, but we don't depend on
@@ -125,37 +96,12 @@ ENTRY(startup_32)
 	movsl
 1:
 
-/*
- * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond _end.  The variable
- * init_pg_tables_end is set up to point to the first "safe" location.
- * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
- *
- * Warning: don't use %esi or the stack in this code.  However, %esp
- * can be used as a GPR if you really need it...
- */
-page_pde_offset = (__PAGE_OFFSET >> 20);
-
-	movl $(pg0 - __PAGE_OFFSET), %edi
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
-10:
-	leal 0x007(%edi),%ecx			/* Create PDE entry */
-	movl %ecx,(%edx)			/* Store identity PDE entry */
-	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
-	addl $4,%edx
-	movl $1024, %ecx
-11:
-	stosl
-	addl $0x1000,%eax
-	loop 11b
-	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
-	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
-	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
-	cmpl %ebp,%eax
-	jb 10b
-	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
+	/* Setup the stack */
+	lss stack_start - __PAGE_OFFSET, %esp
+	subl $__PAGE_OFFSET, %esp
+
+	/* Initialize the boot page tables */
+	call early_pgtable_init
 
 	jmp 3f
 /*
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 698c24f..3e31591 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -82,7 +82,11 @@ struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 struct cpuinfo_x86 boot_cpu_data __read_mostly = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 EXPORT_SYMBOL(boot_cpu_data);
 
+#ifndef CONFIG_X86_PAE
 unsigned long mmu_cr4_features;
+#else
+unsigned long mmu_cr4_features = X86_CR4_PAE;
+#endif
 
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
diff --git a/arch/i386/kernel/srat.c b/arch/i386/kernel/srat.c
index 2a8713e..24bfd4a 100644
--- a/arch/i386/kernel/srat.c
+++ b/arch/i386/kernel/srat.c
@@ -57,8 +57,6 @@ static struct node_memory_chunk_s node_memory_chunk[MAXCHUNKS];
 static int num_memory_chunks;		/* total number of memory chunks */
 static u8 __initdata apicid_to_pxm[MAX_APICID];
 
-extern void * boot_ioremap(unsigned long, unsigned long);
-
 /* Identify CPU proximity domains */
 static void __init parse_cpu_affinity_structure(char *p)
 {
@@ -299,7 +297,7 @@ int __init get_memcfg_from_srat(void)
 	}
 
 	rsdt = (struct acpi_table_rsdt *)
-	    boot_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
+	    bt_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
 
 	if (!rsdt) {
 		printk(KERN_WARNING
@@ -339,11 +337,11 @@ int __init get_memcfg_from_srat(void)
 	for (i = 0; i < tables; i++) {
 		/* Map in header, then map in full table length. */
 		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
+			bt_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
 		if (!header)
 			break;
 		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
+			bt_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
 		if (!header)
 			break;
 
diff --git a/arch/i386/mach-voyager/voyager_basic.c b/arch/i386/mach-voyager/voyager_basic.c
index 8fe7e45..144e235 100644
--- a/arch/i386/mach-voyager/voyager_basic.c
+++ b/arch/i386/mach-voyager/voyager_basic.c
@@ -114,8 +114,7 @@ typedef struct ClickMap {
 } ClickMap_t;
 
 
-/* This routine is pretty much an awful hack to read the bios clickmap by
- * mapping it into page 0.  There are usually three regions in the map:
+/* This routine  to reads the bios clickmap.  There are usually three regions in the map:
  * 	Base Memory
  * 	Extended Memory
  *	zero length marker for end of map
@@ -142,12 +141,8 @@ voyager_memory_detect(int region, __u32 *start, __u32 *length)
 
 	map_addr = *(unsigned long *)cmos;
 
-	/* steal page 0 for this */
-	old = pg0[0];
-	pg0[0] = ((map_addr & PAGE_MASK) | _PAGE_RW | _PAGE_PRESENT);
-	local_flush_tlb();
-	/* now clear everything out but page 0 */
-	map = (ClickMap_t *)(map_addr & (~PAGE_MASK));
+	/* Setup a temporary mapping for the clickmap */
+	map = bt_ioremap(map_addr, sizeof(*map));
 
 	/* zero length is the end of the clickmap */
 	if(map->Entry[region].Length != 0) {
@@ -156,9 +151,8 @@ voyager_memory_detect(int region, __u32 *start, __u32 *length)
 		retval = 1;
 	}
 
-	/* replace the mapping */
-	pg0[0] = old;
-	local_flush_tlb();
+	/* undo the mapping */
+	bt_iounmap(map, sizeof(*map));
 	return retval;
 }
 
diff --git a/arch/i386/mm/Makefile b/arch/i386/mm/Makefile
index 80908b5..215eed5 100644
--- a/arch/i386/mm/Makefile
+++ b/arch/i386/mm/Makefile
@@ -7,4 +7,3 @@ obj-y	:= init.o pgtable.o fault.o ioremap.o extable.o pageattr.o mmap.o
 obj-$(CONFIG_NUMA) += discontig.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_HIGHMEM) += highmem.o
-obj-$(CONFIG_BOOT_IOREMAP) += boot_ioremap.o
diff --git a/arch/i386/mm/boot_ioremap.c b/arch/i386/mm/boot_ioremap.c
deleted file mode 100644
index 4de95a1..0000000
--- a/arch/i386/mm/boot_ioremap.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * arch/i386/mm/boot_ioremap.c
- * 
- * Re-map functions for early boot-time before paging_init() when the 
- * boot-time pagetables are still in use
- *
- * Written by Dave Hansen <haveblue@us.ibm.com>
- */
-
-
-/*
- * We need to use the 2-level pagetable functions, but CONFIG_X86_PAE
- * keeps that from happenning.  If anyone has a better way, I'm listening.
- *
- * boot_pte_t is defined only if this all works correctly
- */
-
-#undef CONFIG_X86_PAE
-#undef CONFIG_PARAVIRT
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/tlbflush.h>
-#include <linux/init.h>
-#include <linux/stddef.h>
-
-/* 
- * I'm cheating here.  It is known that the two boot PTE pages are 
- * allocated next to each other.  I'm pretending that they're just
- * one big array. 
- */
-
-#define BOOT_PTE_PTRS (PTRS_PER_PTE*2)
-
-static unsigned long boot_pte_index(unsigned long vaddr) 
-{
-	return __pa(vaddr) >> PAGE_SHIFT;
-}
-
-static inline boot_pte_t* boot_vaddr_to_pte(void *address)
-{
-	boot_pte_t* boot_pg = (boot_pte_t*)pg0;
-	return &boot_pg[boot_pte_index((unsigned long)address)];
-}
-
-/*
- * This is only for a caller who is clever enough to page-align
- * phys_addr and virtual_source, and who also has a preference
- * about which virtual address from which to steal ptes
- */
-static void __boot_ioremap(unsigned long phys_addr, unsigned long nrpages, 
-		    void* virtual_source)
-{
-	boot_pte_t* pte;
-	int i;
-	char *vaddr = virtual_source;
-
-	pte = boot_vaddr_to_pte(virtual_source);
-	for (i=0; i < nrpages; i++, phys_addr += PAGE_SIZE, pte++) {
-		set_pte(pte, pfn_pte(phys_addr>>PAGE_SHIFT, PAGE_KERNEL));
-		__flush_tlb_one(&vaddr[i*PAGE_SIZE]);
-	}
-}
-
-/* the virtual space we're going to remap comes from this array */
-#define BOOT_IOREMAP_PAGES 4
-#define BOOT_IOREMAP_SIZE (BOOT_IOREMAP_PAGES*PAGE_SIZE)
-static __initdata char boot_ioremap_space[BOOT_IOREMAP_SIZE]
-		       __attribute__ ((aligned (PAGE_SIZE)));
-
-/*
- * This only applies to things which need to ioremap before paging_init()
- * bt_ioremap() and plain ioremap() are both useless at this point.
- * 
- * When used, we're still using the boot-time pagetables, which only
- * have 2 PTE pages mapping the first 8MB
- *
- * There is no unmap.  The boot-time PTE pages aren't used after boot.
- * If you really want the space back, just remap it yourself.
- * boot_ioremap(&ioremap_space-PAGE_OFFSET, BOOT_IOREMAP_SIZE)
- */
-__init void* boot_ioremap(unsigned long phys_addr, unsigned long size)
-{
-	unsigned long last_addr, offset;
-	unsigned int nrpages;
-	
-	last_addr = phys_addr + size - 1;
-
-	/* page align the requested address */
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
-	
-	nrpages = size >> PAGE_SHIFT;
-	if (nrpages > BOOT_IOREMAP_PAGES)
-		return NULL;
-	
-	__boot_ioremap(phys_addr, nrpages, boot_ioremap_space);
-
-	return &boot_ioremap_space[offset];
-}
diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
index dbe16f6..78f03b1 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -44,6 +44,7 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/paravirt.h>
+#include <asm/setup.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
@@ -53,6 +54,119 @@ unsigned long highstart_pfn, highend_pfn;
 static int noinline do_test_wp_bit(void);
 
 /*
+ * This is how much memory *in addition to the memory covered up to
+ * and including _end* we need mapped initially.  We need one bit for
+ * each possible page, but only in low memory, which means
+ * 2^32/4096/8 = 128K worst case (4G/4G split.)
+ *
+ * Modulo rounding, each megabyte assigned here requires a kilobyte of
+ * memory, which is currently unreclaimed.
+ *
+ * This should be a multiple of a page.
+ */
+#define INIT_MAP_BEYOND_END	(128*1024)
+
+/*
+ * Initialize page tables.  This creates a PDE and a set of page
+ * tables, which are located immediately beyond _end.  The variable
+ * init_pg_tables_end is set up to point to the first "safe" location.
+ * Mappings are created both at virtual address 0 (identity mapping)
+ * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
+ *
+ * WARNING: This code runs at it's physical address not it's virtual address,
+ * with all physical everything identity mapped, and nothing else mapped.
+ * This means global variabels must be done very carfully.
+ */
+#define __pavar(X) (*(__typeof__(X) *)__pa_symbol(&(X)))
+
+static __init inline pud_t *early_pud_offset(pgd_t *pgd, unsigned long vaddr)
+{
+	return (pud_t *)pgd;
+}
+
+static __init inline pmd_t *early_pmd_offset(pud_t *pud, unsigned long vaddr)
+{
+#ifndef CONFIG_X86_PAE
+	return (pmd_t *)pud;
+#else
+	return ((pmd_t *)(u32)(pud_val(*pud) & PAGE_MASK)) + pmd_index(vaddr);
+#endif
+}
+
+static __init inline pte_t *early_pte_offset(pmd_t *pmd, unsigned long vaddr)
+{
+	return ((pte_t *)(u32)(pmd_val(*pmd) & PAGE_MASK)) + pte_index(vaddr);
+}
+
+static __init pmd_t *
+early_pmd_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pgd = pgd_base + pgd_index(vaddr);
+	pud = early_pud_offset(pgd, vaddr);
+
+#ifdef CONFIG_X86_PAE
+	if (!(pud_val(*pud) & _PAGE_PRESENT)) {
+		unsigned long phys = *end;
+		memset((void *)phys, 0, PAGE_SIZE);
+		native_set_pud(pud, __pud(phys | _PAGE_PRESENT));
+		*end += PAGE_SIZE;
+	}
+#endif
+	return early_pmd_offset(pud, vaddr);
+}
+
+static __init pte_t *
+early_pte_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
+{
+	pmd_t *pmd;
+
+	pmd = early_pmd_alloc(pgd_base, vaddr, end);
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
+		unsigned long phys = *end;
+		memset((void *)phys, 0, PAGE_SIZE);
+		native_set_pmd(pmd, __pmd(phys | _PAGE_TABLE));
+		*end += PAGE_SIZE;
+	}
+	return early_pte_offset(pmd, vaddr);
+}
+
+static __init void early_set_pte_phys(pgd_t *pgd_base, unsigned long vaddr,
+				      unsigned long phys, unsigned long *end)
+{
+	pte_t *pte;
+	pte = early_pte_alloc(pgd_base, vaddr, end);
+	native_set_pte(pte, __pte(phys | _PAGE_KERNEL_EXEC));
+}
+
+void __init early_pgtable_init(void)
+{
+	unsigned long addr, end;
+	pgd_t *pgd_base;
+
+	pgd_base = __pavar(swapper_pg_dir);
+	end = __pa_symbol(pg0);
+
+	/* Initialize the directory page */
+	memset(pgd_base, 0, PAGE_SIZE);
+
+	/* Set up the fixmap page table */
+	early_pte_alloc(pgd_base, __pavar(__FIXADDR_TOP), &end);
+
+	/* Set up the initial kernel mapping */
+	for (addr = 0; addr < (end + INIT_MAP_BEYOND_END); addr += PAGE_SIZE)
+		early_set_pte_phys(pgd_base, addr + PAGE_OFFSET, addr, &end);
+
+	/* Set up the low identity mappings */
+	clone_pgd_range(pgd_base, pgd_base + USER_PTRS_PER_PGD,
+			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+
+	__pavar(init_pg_tables_end) = end;
+}
+#undef __pavar
+
+/*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
  * in non-PAE compilation mode, since the middle layer is folded.
@@ -338,44 +452,11 @@ extern void __init remap_numa_kva(void);
 
 void __init native_pagetable_setup_start(pgd_t *base)
 {
-#ifdef CONFIG_X86_PAE
-	int i;
-
-	/*
-	 * Init entries of the first-level page table to the
-	 * zero page, if they haven't already been set up.
-	 *
-	 * In a normal native boot, we'll be running on a
-	 * pagetable rooted in swapper_pg_dir, but not in PAE
-	 * mode, so this will end up clobbering the mappings
-	 * for the lower 24Mbytes of the address space,
-	 * without affecting the kernel address space.
-	 */
-	for (i = 0; i < USER_PTRS_PER_PGD; i++)
-		set_pgd(&base[i],
-			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
-
-	/* Make sure kernel address space is empty so that a pagetable
-	   will be allocated for it. */
-	memset(&base[USER_PTRS_PER_PGD], 0,
-	       KERNEL_PGD_PTRS * sizeof(pgd_t));
-#else
 	paravirt_alloc_pd(__pa(swapper_pg_dir) >> PAGE_SHIFT);
-#endif
 }
 
 void __init native_pagetable_setup_done(pgd_t *base)
 {
-#ifdef CONFIG_X86_PAE
-	/*
-	 * Add low memory identity-mappings - SMP needs it when
-	 * starting up on an AP from real-mode. In the non-PAE
-	 * case we already have these mappings through head.S.
-	 * All user-space mappings are explicitly cleared after
-	 * SMP startup.
-	 */
-	set_pgd(&base[0], base[USER_PTRS_PER_PGD]);
-#endif
 }
 
 /*
@@ -567,14 +648,6 @@ void __init paging_init(void)
 
 	load_cr3(swapper_pg_dir);
 
-#ifdef CONFIG_X86_PAE
-	/*
-	 * We will bail out later - printk doesn't work right now so
-	 * the user would just see a hanging kernel.
-	 */
-	if (cpu_has_pae)
-		set_in_cr4(X86_CR4_PAE);
-#endif
 	__flush_tlb_all();
 
 	kmap_init();
@@ -704,10 +777,6 @@ void __init mem_init(void)
 	BUG_ON((unsigned long)high_memory      > VMALLOC_START);
 #endif /* double-sanity-check paranoia */
 
-#ifdef CONFIG_X86_PAE
-	if (!cpu_has_pae)
-		panic("cannot execute a PAE-enabled kernel on a PAE-less CPU!");
-#endif
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
 
diff --git a/include/asm-i386/page.h b/include/asm-i386/page.h
index 818ac8b..bb29e82 100644
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -90,7 +90,6 @@ static inline pte_t native_make_pte(unsigned long long val)
 typedef struct { unsigned long pte_low; } pte_t;
 typedef struct { unsigned long pgd; } pgd_t;
 typedef struct { unsigned long pgprot; } pgprot_t;
-#define boot_pte_t pte_t /* or would you rather have a typedef */
 
 static inline unsigned long native_pgd_val(pgd_t pgd)
 {
diff --git a/include/asm-i386/pgtable.h b/include/asm-i386/pgtable.h
index c6b8b94..7159f12 100644
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -68,10 +68,6 @@ void paging_init(void);
 #define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
 #define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
 
-#define TWOLEVEL_PGDIR_SHIFT	22
-#define BOOT_USER_PGD_PTRS (__PAGE_OFFSET >> TWOLEVEL_PGDIR_SHIFT)
-#define BOOT_KERNEL_PGD_PTRS (1024-BOOT_USER_PGD_PTRS)
-
 /* Just any arbitrary offset to the start of the vmalloc VM area: the
  * current 8MB value just means that there will be a 8MB "hole" after the
  * physical memory until the kernel virtual memory starts.  That means that
-- 
1.5.1.1.181.g2de0

