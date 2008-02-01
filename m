Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYBARAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYBARAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYBARA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:00:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbYBARA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:00:27 -0500
Date: Fri, 1 Feb 2008 18:00:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20080201170009.GA1799@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Fixes and debug patches only. Thanks,

	Ingo

------------------>
Alexander van Heukelum (1):
      x86: avoid section mismatch involving arch_register_cpu

Harvey Harrison (3):
      x86: make early_console static in early_printk.c
      x86: fix sparse warnings in cpu/common.c
      x86: fixes for lookup_address args

Sam Ravnborg (4):
      x86: silence section mismatch warning in smpboot_64.c
      x86: fix section mismatch warnings when referencing notifiers
      x86: fix section mismatch warning in acpi/boot.c
      x86: fix section mismatch warning in kernel/pci-calgary

Yinghai Lu (4):
      x86_64: add debug name for early_res
      x86_64: make bootmap_start page align v6
      x86: fix comments in vmlinux_64.lds
      x86: remove unneeded round_up

 arch/x86/boot/compressed/vmlinux_64.lds |    2 +-
 arch/x86/kernel/acpi/boot.c             |    8 ++++++-
 arch/x86/kernel/cpu/common.c            |   20 +++++++++---------
 arch/x86/kernel/cpuid.c                 |    2 +-
 arch/x86/kernel/e820_64.c               |   23 +++++++++++++-------
 arch/x86/kernel/early_printk.c          |    2 +-
 arch/x86/kernel/efi_64.c                |    2 +-
 arch/x86/kernel/head64.c                |    6 ++--
 arch/x86/kernel/microcode.c             |    2 +-
 arch/x86/kernel/msr.c                   |    2 +-
 arch/x86/kernel/pci-calgary_64.c        |    4 +-
 arch/x86/kernel/setup_64.c              |    3 +-
 arch/x86/kernel/smpboot_64.c            |    2 +-
 arch/x86/kernel/topology.c              |    3 +-
 arch/x86/mm/fault.c                     |    2 +-
 arch/x86/mm/init_64.c                   |   13 +++--------
 arch/x86/mm/ioremap.c                   |    3 +-
 arch/x86/mm/numa_64.c                   |   34 +++++++++++++++++-------------
 arch/x86/mm/pageattr-test.c             |    4 +-
 include/asm-x86/cpu.h                   |    3 +-
 include/asm-x86/e820_64.h               |    4 +-
 21 files changed, 79 insertions(+), 65 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index f6e5b44..7e5c720 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -3,7 +3,7 @@ OUTPUT_ARCH(i386:x86-64)
 ENTRY(startup_64)
 SECTIONS
 {
-	/* Be careful parts of head_64.S assume startup_64 is at
+	/* Be careful parts of head_64.S assume startup_32 is at
 	 * address 0.
 	 */
 	. = 0;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0ca27c7..d2a5843 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -496,7 +496,8 @@ EXPORT_SYMBOL(acpi_register_gsi);
  *  ACPI based hotplug support for CPU
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
-int acpi_map_lsapic(acpi_handle handle, int *pcpu)
+
+static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
@@ -551,6 +552,11 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	return 0;
 }
 
+/* wrapper to silence section mismatch warning */
+int __ref acpi_map_lsapic(acpi_handle handle, int *pcpu)
+{
+	return _acpi_map_lsapic(handle, pcpu);
+}
 EXPORT_SYMBOL(acpi_map_lsapic);
 
 int acpi_unmap_lsapic(int cpu)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d608c9e..b7b2142 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -258,10 +258,10 @@ static int __cpuinit have_cpuid_p(void)
 void __init cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
-	cpuid(0x00000000, &c->cpuid_level,
-	      (int *)&c->x86_vendor_id[0],
-	      (int *)&c->x86_vendor_id[8],
-	      (int *)&c->x86_vendor_id[4]);
+	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
+	      (unsigned int *)&c->x86_vendor_id[0],
+	      (unsigned int *)&c->x86_vendor_id[8],
+	      (unsigned int *)&c->x86_vendor_id[4]);
 
 	c->x86 = 4;
 	if (c->cpuid_level >= 0x00000001) {
@@ -283,7 +283,7 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
-	int ebx;
+	unsigned int ebx;
 
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 	if (have_cpuid_p()) {
@@ -343,14 +343,14 @@ static void __init early_cpu_detect(void)
 static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 {
 	u32 tfms, xlvl;
-	int ebx;
+	unsigned int ebx;
 
 	if (have_cpuid_p()) {
 		/* Get vendor name */
-		cpuid(0x00000000, &c->cpuid_level,
-		      (int *)&c->x86_vendor_id[0],
-		      (int *)&c->x86_vendor_id[8],
-		      (int *)&c->x86_vendor_id[4]);
+		cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
+		      (unsigned int *)&c->x86_vendor_id[0],
+		      (unsigned int *)&c->x86_vendor_id[8],
+		      (unsigned int *)&c->x86_vendor_id[4]);
 		
 		get_cpu_vendor(c, 0);
 		/* Initialize the standard set of capabilities */
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index dec66e4..a63432d 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -170,7 +170,7 @@ static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpuid_class_cpu_notifier =
+static struct notifier_block __refdata cpuid_class_cpu_notifier =
 {
 	.notifier_call = cpuid_class_cpu_callback,
 };
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index c617174..9f65b4c 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -54,30 +54,33 @@ static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
 struct early_res {
 	unsigned long start, end;
+	char name[16];
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
-	{ 0, PAGE_SIZE },			/* BIOS data page */
+	{ 0, PAGE_SIZE, "BIOS data page" },			/* BIOS data page */
 #ifdef CONFIG_SMP
-	{ SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE },
+	{ SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE, "SMP_TRAMPOLINE" },
 #endif
 	{}
 };
 
-void __init reserve_early(unsigned long start, unsigned long end)
+void __init reserve_early(unsigned long start, unsigned long end, char *name)
 {
 	int i;
 	struct early_res *r;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		r = &early_res[i];
 		if (end > r->start && start < r->end)
-			panic("Overlapping early reservations %lx-%lx to %lx-%lx\n",
-			      start, end, r->start, r->end);
+			panic("Overlapping early reservations %lx-%lx %s to %lx-%lx %s\n",
+			      start, end - 1, name?name:"", r->start, r->end - 1, r->name);
 	}
 	if (i >= MAX_EARLY_RES)
 		panic("Too many early reservations");
 	r = &early_res[i];
 	r->start = start;
 	r->end = end;
+	if (name)
+		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
 void __init early_res_to_bootmem(void)
@@ -85,6 +88,8 @@ void __init early_res_to_bootmem(void)
 	int i;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
+		printk(KERN_INFO "early res: %d [%lx-%lx] %s\n", i,
+			r->start, r->end - 1, r->name);
 		reserve_bootmem_generic(r->start, r->end - r->start);
 	}
 }
@@ -166,12 +171,13 @@ int __init e820_all_mapped(unsigned long start, unsigned long end,
 }
 
 /*
- * Find a free area in a specific range.
+ * Find a free area with specified alignment in a specific range.
  */
 unsigned long __init find_e820_area(unsigned long start, unsigned long end,
-				    unsigned size)
+				    unsigned size, unsigned long align)
 {
 	int i;
+	unsigned long mask = ~(align - 1);
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -185,7 +191,8 @@ unsigned long __init find_e820_area(unsigned long start, unsigned long end,
 			continue;
 		while (bad_addr(&addr, size) && addr+size <= ei->addr+ei->size)
 			;
-		last = PAGE_ALIGN(addr) + size;
+		addr = (addr + align - 1) & mask;
+		last = addr + size;
 		if (last > ei->addr + ei->size)
 			continue;
 		if (last > end)
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index b7d6c23..cff84cd 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -193,7 +193,7 @@ static struct console simnow_console = {
 };
 
 /* Direct interface for emergencies */
-struct console *early_console = &early_vga_console;
+static struct console *early_console = &early_vga_console;
 static int early_console_initialized = 0;
 
 void early_printk(const char *fmt, ...)
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 4b73992..674f237 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -44,7 +44,7 @@ static void __init early_mapping_set_exec(unsigned long start,
 					  int executable)
 {
 	pte_t *kpte;
-	int level;
+	unsigned int level;
 
 	while (start < end) {
 		kpte = lookup_address((unsigned long)__va(start), &level);
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index a317336..24dbf56 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -75,7 +75,7 @@ static __init void reserve_ebda(void)
 	if (ebda_size > 64*1024)
 		ebda_size = 64*1024;
 
-	reserve_early(ebda_addr, ebda_addr + ebda_size);
+	reserve_early(ebda_addr, ebda_addr + ebda_size, "EBDA");
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
@@ -105,14 +105,14 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	pda_init(0);
 	copy_bootdata(__va(real_mode_data));
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end));
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
 
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		reserve_early(ramdisk_image, ramdisk_end);
+		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 
 	reserve_ebda();
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 6ff447f..f2702d0 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -797,7 +797,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata mc_cpu_notifier = {
+static struct notifier_block __refdata mc_cpu_notifier = {
 	.notifier_call = mc_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 21f6e3c..bd82850 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -168,7 +168,7 @@ static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata msr_class_cpu_notifier = {
+static struct notifier_block __refdata msr_class_cpu_notifier = {
 	.notifier_call = msr_class_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 21f34db..1fe7f04 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1006,7 +1006,7 @@ static void __init calgary_set_split_completion_timeout(void __iomem *bbar,
 	readq(target); /* flush */
 }
 
-static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
+static void __init calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
@@ -1022,7 +1022,7 @@ static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 	writel(cpu_to_be32(val), target);
 }
 
-static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
+static void __init calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
 
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 77fb87b..18df70c 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -182,7 +182,8 @@ contig_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	unsigned long bootmap_size, bootmap;
 
 	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size);
+	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
+				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index cc64b80..d53bd6f 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -1019,7 +1019,7 @@ static void remove_siblinginfo(int cpu)
 	cpu_clear(cpu, cpu_sibling_setup_map);
 }
 
-void remove_cpu_from_maps(void)
+static void __ref remove_cpu_from_maps(void)
 {
 	int cpu = smp_processor_id();
 
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 78cbb65..e6757aa 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -57,11 +57,10 @@ void arch_unregister_cpu(int num)
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
 #else
-int arch_register_cpu(int num)
+static int __init arch_register_cpu(int num)
 {
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
-EXPORT_SYMBOL(arch_register_cpu);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 static int __init topology_init(void)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e28cc52..e4440d0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -382,7 +382,7 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 #ifdef CONFIG_X86_PAE
 	if (error_code & PF_INSTR) {
-		int level;
+		unsigned int level;
 		pte_t *pte = lookup_address(address, &level);
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index cc50a13..eabcaed 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -354,17 +354,10 @@ static void __init find_early_table_space(unsigned long end)
 	 * need roughly 0.5KB per GB.
 	 */
 	start = 0x8000;
-	table_start = find_e820_area(start, end, tables);
+	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
-	/*
-	 * When you have a lot of RAM like 256GB, early_table will not fit
-	 * into 0x8000 range, find_e820_area() will find area after kernel
-	 * bss but the table_start is not page aligned, so need to round it
-	 * up to avoid overlap with bss:
-	 */
-	table_start = round_up(table_start, PAGE_SIZE);
 	table_start >>= PAGE_SHIFT;
 	table_end = table_start;
 
@@ -420,7 +413,9 @@ void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
 		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
 
-	reserve_early(table_start << PAGE_SHIFT, table_end << PAGE_SHIFT);
+	if (!after_bootmem)
+		reserve_early(table_start << PAGE_SHIFT,
+				 table_end << PAGE_SHIFT, "PGTABLE");
 }
 
 #ifndef CONFIG_NUMA
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index a177d76..c004d94 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -75,7 +75,8 @@ static int ioremap_change_attr(unsigned long paddr, unsigned long size,
 {
 	unsigned long vaddr = (unsigned long)__va(paddr);
 	unsigned long nrpages = size >> PAGE_SHIFT;
-	int err, level;
+	unsigned int level;
+	int err;
 
 	/* No change for pages after the last mapping */
 	if ((paddr + size - 1) >= (max_pfn_mapped << PAGE_SHIFT))
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index dc3b1f7..a920d09 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -84,26 +84,24 @@ static int __init populate_memnodemap(const struct bootnode *nodes,
 
 static int __init allocate_cachealigned_memnodemap(void)
 {
-	unsigned long pad, pad_addr;
+	unsigned long addr;
 
 	memnodemap = memnode.embedded_map;
 	if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
 		return 0;
 
-	pad = L1_CACHE_BYTES - 1;
-	pad_addr = 0x8000;
-	nodemap_size = pad + sizeof(s16) * memnodemapsize;
-	nodemap_addr = find_e820_area(pad_addr, end_pfn<<PAGE_SHIFT,
-				      nodemap_size);
+	addr = 0x8000;
+	nodemap_size = round_up(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
+	nodemap_addr = find_e820_area(addr, end_pfn<<PAGE_SHIFT,
+				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
 		printk(KERN_ERR
 		       "NUMA: Unable to allocate Memory to Node hash map\n");
 		nodemap_addr = nodemap_size = 0;
 		return -1;
 	}
-	pad_addr = (nodemap_addr + pad) & ~pad;
-	memnodemap = phys_to_virt(pad_addr);
-	reserve_early(nodemap_addr, nodemap_addr + nodemap_size);
+	memnodemap = phys_to_virt(nodemap_addr);
+	reserve_early(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
 
 	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
 	       nodemap_addr, nodemap_addr + nodemap_size);
@@ -164,15 +162,16 @@ int early_pfn_to_nid(unsigned long pfn)
 }
 
 static void * __init early_node_mem(int nodeid, unsigned long start,
-				    unsigned long end, unsigned long size)
+				    unsigned long end, unsigned long size,
+				    unsigned long align)
 {
-	unsigned long mem = find_e820_area(start, end, size);
+	unsigned long mem = find_e820_area(start, end, size, align);
 	void *ptr;
 
 	if (mem != -1L)
 		return __va(mem);
-	ptr = __alloc_bootmem_nopanic(size,
-				SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS));
+
+	ptr = __alloc_bootmem_nopanic(size, align, __pa(MAX_DMA_ADDRESS));
 	if (ptr == NULL) {
 		printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
 		       size, nodeid);
@@ -198,7 +197,8 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
 
-	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size);
+	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
+					   SMP_CACHE_BYTES);
 	if (node_data[nodeid] == NULL)
 		return;
 	nodedata_phys = __pa(node_data[nodeid]);
@@ -211,8 +211,12 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	/* Find a place for the bootmem map */
 	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
 	bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+	/*
+	 * SMP_CAHCE_BYTES could be enough, but init_bootmem_node like
+	 * to use that to align to PAGE_SIZE
+	 */
 	bootmap = early_node_mem(nodeid, bootmap_start, end,
-					bootmap_pages<<PAGE_SHIFT);
+				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
 		if (nodedata_phys < start || nodedata_phys >= end)
 			free_bootmem((unsigned long)node_data[nodeid],
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index 06353d4..7573e78 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -42,7 +42,7 @@ static __init int print_split(struct split_state *s)
 	s->max_exec = 0;
 	for (i = 0; i < max_pfn_mapped; ) {
 		unsigned long addr = (unsigned long)__va(i << PAGE_SHIFT);
-		int level;
+		unsigned int level;
 		pte_t *pte;
 
 		pte = lookup_address(addr, &level);
@@ -106,7 +106,7 @@ static __init int exercise_pageattr(void)
 	unsigned long *bm;
 	pte_t *pte, pte0;
 	int failed = 0;
-	int level;
+	unsigned int level;
 	int i, k;
 	int err;
 
diff --git a/include/asm-x86/cpu.h b/include/asm-x86/cpu.h
index 85ece5f..73f2ea8 100644
--- a/include/asm-x86/cpu.h
+++ b/include/asm-x86/cpu.h
@@ -10,8 +10,9 @@
 struct x86_cpu {
 	struct cpu cpu;
 };
-extern int arch_register_cpu(int num);
+
 #ifdef CONFIG_HOTPLUG_CPU
+extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 #endif
 
diff --git a/include/asm-x86/e820_64.h b/include/asm-x86/e820_64.h
index 51e4170..a560c4f 100644
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -15,7 +15,7 @@
 
 #ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end, 
-				    unsigned size);
+				    unsigned size, unsigned long align);
 extern void add_memory_region(unsigned long start, unsigned long size, 
 			      int type);
 extern void setup_memory_region(void);
@@ -41,7 +41,7 @@ extern void finish_e820_parsing(void);
 extern struct e820map e820;
 extern void update_e820(void);
 
-extern void reserve_early(unsigned long start, unsigned long end);
+extern void reserve_early(unsigned long start, unsigned long end, char *name);
 extern void early_res_to_bootmem(void);
 
 #endif/*!__ASSEMBLY__*/
