Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYAOFuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYAOFuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 00:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYAOFuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 00:50:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:36685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYAOFuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 00:50:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,285,1196668800"; 
   d="scan'208";a="501975138"
Subject: [PATCH -mm 3/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - rename bt_ioremap to early_ioremap
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 13:45:16 +0800
Message-Id: <1200375916.3505.32.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Jan 2008 05:45:02.0668 (UTC) FILETIME=[C5FFB0C0:01C85739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames bt_ioremap to early_ioremap, which is used in
x86_64. This makes it easier to merge i386 and x86_64 usage.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c        |   16 ++++++++--------
 arch/x86/kernel/efi_32.c     |    2 +-
 arch/x86/kernel/efi_tables.c |   12 ++++++------
 arch/x86/kernel/setup_32.c   |    2 +-
 arch/x86/kernel/srat_32.c    |    6 +++---
 arch/x86/mm/init_32.c        |    4 ++--
 arch/x86/mm/ioremap_32.c     |   38 +++++++++++++++++++-------------------
 include/asm-x86/dmi.h        |    7 ++-----
 include/asm-x86/efi.h        |    8 --------
 include/asm-x86/io_32.h      |   16 ++++++++--------
 10 files changed, 50 insertions(+), 61 deletions(-)

--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -212,36 +212,36 @@ static __initdata int after_paging_init;
 static __initdata unsigned long bm_pte[1024]
 				__attribute__((aligned(PAGE_SIZE)));
 
-static inline unsigned long * __init bt_ioremap_pgd(unsigned long addr)
+static inline unsigned long * __init early_ioremap_pgd(unsigned long addr)
 {
 	return (unsigned long *)swapper_pg_dir + ((addr >> 22) & 1023);
 }
 
-static inline unsigned long * __init bt_ioremap_pte(unsigned long addr)
+static inline unsigned long * __init early_ioremap_pte(unsigned long addr)
 {
 	return bm_pte + ((addr >> PAGE_SHIFT) & 1023);
 }
 
-void __init bt_ioremap_init(void)
+void __init early_ioremap_init(void)
 {
 	unsigned long *pgd;
 
-	pgd = bt_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
+	pgd = early_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
 	*pgd = __pa(bm_pte) | _PAGE_TABLE;
 	memset(bm_pte, 0, sizeof(bm_pte));
-	BUG_ON(pgd != bt_ioremap_pgd(fix_to_virt(FIX_BTMAP_END)));
+	BUG_ON(pgd != early_ioremap_pgd(fix_to_virt(FIX_BTMAP_END)));
 }
 
-void __init bt_ioremap_clear(void)
+void __init early_ioremap_clear(void)
 {
 	unsigned long *pgd;
 
-	pgd = bt_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
+	pgd = early_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
 	*pgd = 0;
 	__flush_tlb_all();
 }
 
-void __init bt_ioremap_reset(void)
+void __init early_ioremap_reset(void)
 {
 	enum fixed_addresses idx;
 	unsigned long *pte, phys, addr;
@@ -249,7 +249,7 @@ void __init bt_ioremap_reset(void)
 	after_paging_init = 1;
 	for (idx = FIX_BTMAP_BEGIN; idx <= FIX_BTMAP_END; idx--) {
 		addr = fix_to_virt(idx);
-		pte = bt_ioremap_pte(addr);
+		pte = early_ioremap_pte(addr);
 		if (!*pte & _PAGE_PRESENT) {
 			phys = *pte & PAGE_MASK;
 			set_fixmap(idx, phys);
@@ -257,7 +257,7 @@ void __init bt_ioremap_reset(void)
 	}
 }
 
-static void __init __bt_set_fixmap(enum fixed_addresses idx,
+static void __init __early_set_fixmap(enum fixed_addresses idx,
 				   unsigned long phys, pgprot_t flags)
 {
 	unsigned long *pte, addr = __fix_to_virt(idx);
@@ -266,7 +266,7 @@ static void __init __bt_set_fixmap(enum 
 		BUG();
 		return;
 	}
-	pte = bt_ioremap_pte(addr);
+	pte = early_ioremap_pte(addr);
 	if (pgprot_val(flags))
 		*pte = (phys & PAGE_MASK) | pgprot_val(flags);
 	else
@@ -274,24 +274,24 @@ static void __init __bt_set_fixmap(enum 
 	__flush_tlb_one(addr);
 }
 
-static inline void __init bt_set_fixmap(enum fixed_addresses idx,
+static inline void __init early_set_fixmap(enum fixed_addresses idx,
 					unsigned long phys)
 {
 	if (after_paging_init)
 		set_fixmap(idx, phys);
 	else
-		__bt_set_fixmap(idx, phys, PAGE_KERNEL);
+		__early_set_fixmap(idx, phys, PAGE_KERNEL);
 }
 
-static inline void __init bt_clear_fixmap(enum fixed_addresses idx)
+static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 {
 	if (after_paging_init)
 		clear_fixmap(idx);
 	else
-		__bt_set_fixmap(idx, 0, __pgprot(0));
+		__early_set_fixmap(idx, 0, __pgprot(0));
 }
 
-void __init *bt_ioremap(unsigned long phys_addr, unsigned long size)
+void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	unsigned long offset, last_addr;
 	unsigned int nrpages;
@@ -327,7 +327,7 @@ void __init *bt_ioremap(unsigned long ph
 	 */
 	idx = FIX_BTMAP_BEGIN;
 	while (nrpages > 0) {
-		bt_set_fixmap(idx, phys_addr);
+		early_set_fixmap(idx, phys_addr);
 		phys_addr += PAGE_SIZE;
 		--idx;
 		--nrpages;
@@ -335,7 +335,7 @@ void __init *bt_ioremap(unsigned long ph
 	return (void*) (offset + fix_to_virt(FIX_BTMAP_BEGIN));
 }
 
-void __init bt_iounmap(void *addr, unsigned long size)
+void __init early_iounmap(void *addr, unsigned long size)
 {
 	unsigned long virt_addr;
 	unsigned long offset;
@@ -350,7 +350,7 @@ void __init bt_iounmap(void *addr, unsig
 
 	idx = FIX_BTMAP_BEGIN;
 	while (nrpages > 0) {
-		bt_clear_fixmap(idx);
+		early_clear_fixmap(idx);
 		--idx;
 		--nrpages;
 	}
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -33,9 +33,6 @@ extern unsigned long asmlinkage efi_call
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_early_ioremap(addr, size)		bt_ioremap(addr, size)
-#define efi_early_iounmap(vaddr, size)		bt_iounmap(vaddr, size)
-
 #define efi_ioremap(addr, size)			ioremap(addr, size)
 
 #define end_pfn_map				max_low_pfn
@@ -93,13 +90,8 @@ extern u64 efi_call6(void *fp, u64 arg1,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-#define efi_early_ioremap(addr, size)		early_ioremap(addr, size)
-#define efi_early_iounmap(vaddr, size)		early_iounmap(vaddr, size)
-
 extern void *efi_ioremap(unsigned long offset, unsigned long size);
 
-extern int efi_time;
-
 #define EFI_CHECK_ADDR(addr)	1
 
 #endif /* CONFIG_X86_32 */
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -126,20 +126,20 @@ extern void __iomem * ioremap_nocache(un
 extern void iounmap(volatile void __iomem *addr);
 
 /*
- * bt_ioremap() and bt_iounmap() are for temporary early boot-time
+ * early_ioremap() and early_iounmap() are for temporary early boot-time
  * mappings, before the real ioremap() is functional.
  * A boot-time mapping is currently limited to at most 16 pages.
  */
-extern void bt_ioremap_init(void);
-extern void bt_ioremap_clear(void);
-extern void bt_ioremap_reset(void);
-extern void *bt_ioremap(unsigned long offset, unsigned long size);
-extern void bt_iounmap(void *addr, unsigned long size);
+extern void early_ioremap_init(void);
+extern void early_ioremap_clear(void);
+extern void early_ioremap_reset(void);
+extern void *early_ioremap(unsigned long offset, unsigned long size);
+extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 /* Use early IO mappings for DMI because it's initialized early */
-#define dmi_ioremap bt_ioremap
-#define dmi_iounmap bt_iounmap
+#define dmi_ioremap early_ioremap
+#define dmi_iounmap early_iounmap
 #define dmi_alloc alloc_bootmem
 
 /*
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -251,14 +251,14 @@ void __init efi_init(void)
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 
-	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
-				       sizeof(efi_system_table_t));
+	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
+				   sizeof(efi_system_table_t));
 	if (efi.systab == NULL) {
 		printk(KERN_ERR "Couldn't map the EFI system table!\n");
 		goto error;
 	}
 	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
-	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
+	early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
 
 	/*
@@ -275,8 +275,8 @@ void __init efi_init(void)
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
 	 */
-	runtime = efi_early_ioremap((unsigned long)efi.systab->runtime,
-				    sizeof(efi_runtime_services_t));
+	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+				sizeof(efi_runtime_services_t));
 	if (runtime == NULL) {
 		printk(KERN_ERR "Could not map the EFI runtime service "
 		       "table!\n");
@@ -293,11 +293,11 @@ void __init efi_init(void)
 	 * Make efi_get_time can be called before entering virtual mode.
 	 */
 	efi.get_time = phys_efi_get_time;
-	efi_early_iounmap(runtime, sizeof(efi_runtime_services_t));
+	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	/* Map the EFI memory map */
-	memmap.map = efi_early_ioremap((unsigned long)memmap.phys_map,
-				       memmap.nr_map * memmap.desc_size);
+	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
+				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL) {
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
 		goto error;
--- a/arch/x86/kernel/efi_tables.c
+++ b/arch/x86/kernel/efi_tables.c
@@ -34,13 +34,13 @@ static void __init efi_tables_parse ## b
 		n |= ((u64)boot_params.efi_info.efi_systab_hi<<32);	\
 	if (!EFI_CHECK_ADDR(n))						\
 		return;							\
-	psystab = efi_early_ioremap(n, sizeof(systab));			\
+	psystab = early_ioremap(n, sizeof(systab));			\
 	if (psystab == NULL) {						\
 		printk(KERN_ERR "Could not map the EFI system table!\n"); \
 		return;							\
 	}								\
 	memcpy(&systab, psystab, sizeof(systab));			\
-	efi_early_iounmap(psystab, sizeof(systab));			\
+	early_iounmap(psystab, sizeof(systab));				\
 									\
 	if (systab.hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {	\
 		printk(KERN_ERR "EFI system table signature "		\
@@ -56,7 +56,7 @@ static void __init efi_tables_parse ## b
 	}								\
 									\
 	if (EFI_CHECK_ADDR(systab.fw_vendor)) {				\
-		c16 = tmp = efi_early_ioremap(systab.fw_vendor, 2);	\
+		c16 = tmp = early_ioremap(systab.fw_vendor, 2);		\
 		if (c16 == NULL) {					\
 			printk(KERN_ERR "Could not map the EFI "	\
 			       "firmware vendor!\n");			\
@@ -65,7 +65,7 @@ static void __init efi_tables_parse ## b
 		for (i = 0; i < sizeof(vendor) && *c16; ++i)		\
 			vendor[i] = *c16++;				\
 		vendor[i] = '\0';					\
-		efi_early_iounmap(tmp, 2);				\
+		early_iounmap(tmp, 2);					\
 	}								\
 									\
 	printk(KERN_INFO "EFI %u v%u.%.02u by %s \n",			\
@@ -75,7 +75,7 @@ static void __init efi_tables_parse ## b
 	if (!EFI_CHECK_ADDR(systab.tables))				\
 		return;							\
 									\
-	config_tables = efi_early_ioremap(				\
+	config_tables = early_ioremap(					\
 		systab.tables,						\
 		systab.nr_tables * sizeof(struct efi_config_table ## bt)); \
 	if (config_tables == NULL) {					\
@@ -111,7 +111,7 @@ static void __init efi_tables_parse ## b
 		}							\
 	}								\
 	printk("\n");							\
-	efi_early_iounmap(						\
+	early_iounmap(							\
 		config_tables,						\
 		systab.nr_tables * sizeof(struct efi_config_table ## bt)); \
 }
--- a/include/asm-x86/dmi.h
+++ b/include/asm-x86/dmi.h
@@ -5,9 +5,6 @@
 
 #ifdef CONFIG_X86_32
 
-/* Use early IO mappings for DMI because it's initialized early */
-#define dmi_ioremap bt_ioremap
-#define dmi_iounmap bt_iounmap
 #define dmi_alloc alloc_bootmem
 
 #else /* CONFIG_X86_32 */
@@ -27,9 +24,9 @@ static inline void *dmi_alloc(unsigned l
 	return dmi_alloc_data + idx;
 }
 
+#endif
+
 #define dmi_ioremap early_ioremap
 #define dmi_iounmap early_iounmap
 
 #endif
-
-#endif
--- a/arch/x86/kernel/srat_32.c
+++ b/arch/x86/kernel/srat_32.c
@@ -297,7 +297,7 @@ int __init get_memcfg_from_srat(void)
 	}
 
 	rsdt = (struct acpi_table_rsdt *)
-	    bt_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
+	    early_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
 
 	if (!rsdt) {
 		printk(KERN_WARNING
@@ -337,11 +337,11 @@ int __init get_memcfg_from_srat(void)
 	for (i = 0; i < tables; i++) {
 		/* Map in header, then map in full table length. */
 		header = (struct acpi_table_header *)
-			bt_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
+			early_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
 		if (!header)
 			break;
 		header = (struct acpi_table_header *)
-			bt_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
+			early_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
 		if (!header)
 			break;
 
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -423,11 +423,11 @@ static void __init pagetable_init (void)
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
-	bt_ioremap_clear();
+	early_ioremap_clear();
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
-	bt_ioremap_reset();
+	early_ioremap_reset();
 
 	permanent_kmaps_init(pgd_base);
 
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -624,7 +624,7 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
-	bt_ioremap_init();
+	early_ioremap_init();
 
 	efi_check_bios_type();
 #ifdef CONFIG_EFI
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -117,7 +117,7 @@ void __init efi_map_memmap(void)
 {
 	memmap.map = NULL;
 
-	memmap.map = bt_ioremap((unsigned long) memmap.phys_map,
+	memmap.map = early_ioremap((unsigned long) memmap.phys_map,
 			(memmap.nr_map * memmap.desc_size));
 	if (memmap.map == NULL)
 		printk(KERN_ERR "Could not remap the EFI memmap!\n");

