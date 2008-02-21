Return-Path: <linux-kernel-owner+w=401wt.eu-S1764954AbYBUIQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764954AbYBUIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYBUIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:16:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:65398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbYBUIPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:15:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,385,1199692800"; 
   d="scan'208";a="343371012"
Subject: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
	section into init BSS section
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Feb 2008 16:15:23 +0800
Message-Id: <1203581723.4707.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 21 Feb 2008 08:14:04.0077 (UTC) FILETIME=[B8C72DD0:01C87461]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uninitialized variable in init DATA sections are relocated into init
BSS sections to reduce kernel image size. Several KB can be reduced.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/acpi/boot.c         |   14 +++++++-------
 arch/x86/kernel/aperture_64.c       |    6 +++---
 arch/x86/kernel/apic_32.c           |   10 +++++-----
 arch/x86/kernel/apic_64.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_32.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 arch/x86/kernel/e820_32.c           |    8 ++++----
 arch/x86/kernel/e820_64.c           |   10 +++++-----
 arch/x86/kernel/early_printk.c      |    2 +-
 arch/x86/kernel/efi.c               |    4 ++--
 arch/x86/kernel/efi_64.c            |    4 ++--
 arch/x86/kernel/io_apic_32.c        |    4 ++--
 arch/x86/kernel/io_apic_64.c        |    2 +-
 arch/x86/kernel/io_delay.c          |    2 +-
 arch/x86/kernel/nmi_32.c            |    2 +-
 arch/x86/kernel/nmi_64.c            |    2 +-
 arch/x86/kernel/pci-calgary_64.c    |    6 +++---
 arch/x86/kernel/setup64.c           |    2 +-
 arch/x86/kernel/setup_32.c          |    6 +++---
 arch/x86/kernel/setup_64.c          |    2 +-
 arch/x86/kernel/srat_32.c           |    2 +-
 arch/x86/kernel/summit_32.c         |    6 +++---
 arch/x86/kernel/tsc_64.c            |    2 +-
 arch/x86/mach-generic/probe.c       |    2 +-
 arch/x86/mach-visws/setup.c         |    2 +-
 arch/x86/mach-voyager/voyager_cat.c |    2 +-
 arch/x86/mm/init_32.c               |    2 +-
 arch/x86/mm/init_64.c               |    4 ++--
 arch/x86/mm/ioremap.c               |   10 +++++-----
 arch/x86/mm/numa_64.c               |    8 ++++----
 arch/x86/mm/srat_64.c               |   10 +++++-----
 arch/x86/pci/mmconfig-shared.c      |    4 ++--
 32 files changed, 73 insertions(+), 73 deletions(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -259,7 +259,7 @@ EXPORT_SYMBOL(iounmap);
 
 #ifdef CONFIG_X86_32
 
-int __initdata early_ioremap_debug;
+int __initbss early_ioremap_debug;
 
 static int __init early_ioremap_debug_setup(char *str)
 {
@@ -269,9 +269,9 @@ static int __init early_ioremap_debug_se
 }
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
-static __initdata int after_paging_init;
-static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
-				__attribute__((aligned(PAGE_SIZE)));
+static __initbss int after_paging_init;
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
+	__section(.init.bss.page_aligned);
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
@@ -385,7 +385,7 @@ static inline void __init early_clear_fi
 }
 
 
-int __initdata early_ioremap_nested;
+int __initbss early_ioremap_nested;
 
 static int __init check_early_ioremap_leak(void)
 {
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -485,7 +485,7 @@ EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 #ifdef CONFIG_X86_PAE
 
-static int disable_nx __initdata;
+static int disable_nx __initbss;
 
 /*
  * noexec = on|off
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -26,11 +26,11 @@
 #include <asm/k8.h>
 
 int gart_iommu_aperture;
-int gart_iommu_aperture_disabled __initdata = 0;
-int gart_iommu_aperture_allowed __initdata = 0;
+int gart_iommu_aperture_disabled __initbss;
+int gart_iommu_aperture_allowed __initbss;
 
 int fallback_aper_order __initdata = 1; /* 64MB */
-int fallback_aper_force __initdata = 0;
+int fallback_aper_force __initbss;
 
 int fix_aperture __initdata = 1;
 
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -55,7 +55,7 @@
  *
  * -1=force-disable, +1=force-enable
  */
-static int enable_local_apic __initdata;
+static int enable_local_apic __initbss;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
@@ -320,10 +320,10 @@ static void __devinit setup_APIC_timer(v
 #define LAPIC_CAL_LOOPS		(HZ/10)
 
 static __initdata int lapic_cal_loops = -1;
-static __initdata long lapic_cal_t1, lapic_cal_t2;
-static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
-static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
-static __initdata unsigned long lapic_cal_j1, lapic_cal_j2;
+static __initbss long lapic_cal_t1, lapic_cal_t2;
+static __initbss unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
+static __initbss unsigned long lapic_cal_pm1, lapic_cal_pm2;
+static __initbss unsigned long lapic_cal_j1, lapic_cal_j2;
 
 /*
  * Temporary interrupt handler.
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -42,7 +42,7 @@
 #include <asm/apic.h>
 
 int disable_apic_timer __cpuinitdata;
-static int apic_calibrate_pmtmr __initdata;
+static int apic_calibrate_pmtmr __initbss;
 int disable_apic;
 
 /* Local APIC timer works in C2 */
--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -21,10 +21,10 @@ struct change_member {
 	struct e820entry *pbios; /* pointer to original bios entry */
 	unsigned long long addr; /* address for this change point */
 };
-static struct change_member change_point_list[2*E820MAX] __initdata;
-static struct change_member *change_point[2*E820MAX] __initdata;
-static struct e820entry *overlap_list[E820MAX] __initdata;
-static struct e820entry new_bios[E820MAX] __initdata;
+static struct change_member change_point_list[2*E820MAX] __initbss;
+static struct change_member *change_point[2*E820MAX] __initbss;
+static struct e820entry *overlap_list[E820MAX] __initbss;
+static struct e820entry new_bios[E820MAX] __initbss;
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0x10000000;
 #ifdef CONFIG_PCI
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -432,10 +432,10 @@ static int __init sanitize_e820_map(stru
 		struct e820entry *pbios; /* pointer to original bios entry */
 		unsigned long long addr; /* address for this change point */
 	};
-	static struct change_member change_point_list[2*E820MAX] __initdata;
-	static struct change_member *change_point[2*E820MAX] __initdata;
-	static struct e820entry *overlap_list[E820MAX] __initdata;
-	static struct e820entry new_bios[E820MAX] __initdata;
+	static struct change_member change_point_list[2*E820MAX] __initbss;
+	static struct change_member *change_point[2*E820MAX] __initbss;
+	static struct e820entry *overlap_list[E820MAX] __initbss;
+	static struct e820entry new_bios[E820MAX] __initbss;
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;
@@ -686,7 +686,7 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
-static int userdef __initdata;
+static int userdef __initbss;
 
 static int __init parse_memmap_opt(char *p)
 {
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -208,7 +208,7 @@ void early_printk(const char *fmt, ...)
 	va_end(ap);
 }
 
-static int __initdata keep_early;
+static int __initbss keep_early;
 
 static int __init setup_early_printk(char *buf)
 {
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -54,8 +54,8 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
-static struct efi efi_phys __initdata;
-static efi_system_table_t efi_systab __initdata;
+static struct efi efi_phys __initbss;
+static efi_system_table_t efi_systab __initbss;
 
 static int __init setup_noefi(char *arg)
 {
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -37,8 +37,8 @@
 #include <asm/efi.h>
 #include <asm/cacheflush.h>
 
-static pgd_t save_pgd __initdata;
-static unsigned long efi_flags __initdata;
+static pgd_t save_pgd __initbss;
+static unsigned long efi_flags __initbss;
 
 static void __init early_mapping_set_exec(unsigned long start,
 					  unsigned long end,
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -71,7 +71,7 @@ int sis_apic_bug = -1;
  */
 int nr_ioapic_registers[MAX_IO_APICS];
 
-static int disable_timer_pin_1 __initdata;
+static int disable_timer_pin_1 __initbss;
 
 /*
  * Rough estimation of how many shared IRQs there are, can
@@ -1861,7 +1861,7 @@ static void __init setup_ioapic_ids_from
 static void __init setup_ioapic_ids_from_mpc(void) { }
 #endif
 
-int no_timer_check __initdata;
+int no_timer_check __initbss;
 
 static int __init notimercheck(char *s)
 {
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -86,7 +86,7 @@ int sis_apic_bug; /* not actually suppor
 
 static int no_timer_check;
 
-static int disable_timer_pin_1 __initdata;
+static int disable_timer_pin_1 __initbss;
 
 int timer_over_8254 __initdata = 1;
 
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -14,7 +14,7 @@
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
 
-static int __initdata io_delay_override;
+static int __initbss io_delay_override;
 
 /*
  * Paravirt wants native_io_delay to be a constant.
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -46,7 +46,7 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-static int endflag __initdata = 0;
+static int endflag __initbss;
 
 #ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -54,7 +54,7 @@ void nmi_watchdog_default(void)
 	nmi_watchdog = NMI_NONE;
 }
 
-static int endflag __initdata = 0;
+static int endflag __initbss;
 
 #ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -149,9 +149,9 @@ unsigned int specified_table_size = TCE_
 static int translate_empty_slots __read_mostly = 0;
 static int calgary_detected __read_mostly = 0;
 
-static struct rio_table_hdr	*rio_table_hdr __initdata;
-static struct scal_detail	*scal_devs[MAX_NUMNODES] __initdata;
-static struct rio_detail	*rio_devs[MAX_NUMNODES * 4] __initdata;
+static struct rio_table_hdr	*rio_table_hdr __initbss;
+static struct scal_detail	*scal_devs[MAX_NUMNODES] __initbss;
+static struct rio_detail	*rio_devs[MAX_NUMNODES * 4] __initbss;
 
 struct calgary_bus_info {
 	void *tce_space;
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -25,7 +25,7 @@
 #include <asm/setup.h>
 
 #ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
+struct boot_params __initbss boot_params;
 #else
 struct boot_params boot_params;
 #endif
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -195,10 +195,10 @@ unsigned long saved_videomode;
 #define RAMDISK_PROMPT_FLAG		0x8000
 #define RAMDISK_LOAD_FLAG		0x4000
 
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initbss command_line[COMMAND_LINE_SIZE];
 
 #ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
+struct boot_params __initbss boot_params;
 #else
 struct boot_params boot_params;
 #endif
@@ -227,7 +227,7 @@ static inline void copy_edd(void)
 }
 #endif
 
-int __initdata user_defined_memmap = 0;
+int __initbss user_defined_memmap;
 
 /*
  * "mem=nopentium" disables the 4MB page tables.
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -112,7 +112,7 @@ EXPORT_SYMBOL_GPL(edid_info);
 
 extern int root_mountflags;
 
-char __initdata command_line[COMMAND_LINE_SIZE];
+char __initbss command_line[COMMAND_LINE_SIZE];
 
 struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
--- a/arch/x86/kernel/srat_32.c
+++ b/arch/x86/kernel/srat_32.c
@@ -55,7 +55,7 @@ struct node_memory_chunk_s {
 static struct node_memory_chunk_s node_memory_chunk[MAXCHUNKS];
 
 static int num_memory_chunks;		/* total number of memory chunks */
-static u8 __initdata apicid_to_pxm[MAX_APICID];
+static u8 __initbss apicid_to_pxm[MAX_APICID];
 
 /* Identify CPU proximity domains */
 static void __init parse_cpu_affinity_structure(char *p)
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -31,9 +31,9 @@
 #include <asm/io.h>
 #include <asm/mach-summit/mach_mpparse.h>
 
-static struct rio_table_hdr *rio_table_hdr __initdata;
-static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
-static struct rio_detail    *rio_devs[MAX_NUMNODES*4] __initdata;
+static struct rio_table_hdr *rio_table_hdr __initbss;
+static struct scal_detail   *scal_devs[MAX_NUMNODES] __initbss;
+static struct rio_detail    *rio_devs[MAX_NUMNODES*4] __initbss;
 
 static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 {
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -12,7 +12,7 @@
 #include <asm/timex.h>
 #include <asm/timer.h>
 
-static int notsc __initdata = 0;
+static int notsc __initbss;
 
 unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 #include <asm/mpspec.h>
 
-static int __initdata acpi_force = 0;
+static int __initbss acpi_force;
 
 #ifdef	CONFIG_ACPI
 int acpi_disabled = 0;
@@ -72,17 +72,17 @@ static inline int acpi_madt_oem_check(ch
 #define PREFIX			"ACPI: "
 
 int acpi_noirq;				/* skip ACPI IRQ initialization */
-int acpi_pci_disabled __initdata;	/* skip ACPI PCI scan and IRQ initialization */
+int acpi_pci_disabled __initbss;	/* skip ACPI PCI scan and IRQ initialization */
 int acpi_ht __initdata = 1;	/* enable HT */
 
 int acpi_lapic;
 int acpi_ioapic;
 int acpi_strict;
 
-u8 acpi_sci_flags __initdata;
-int acpi_sci_override_gsi __initdata;
-int acpi_skip_timer_override __initdata;
-int acpi_use_timer_override __initdata;
+u8 acpi_sci_flags __initbss;
+int acpi_sci_override_gsi __initbss;
+int acpi_skip_timer_override __initbss;
+int acpi_use_timer_override __initbss;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
@@ -602,7 +602,7 @@ static int __init acpi_parse_sbf(struct 
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>
 
-static struct __initdata resource *hpet_res;
+static struct __initbss resource *hpet_res;
 
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
--- a/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -60,7 +60,7 @@ void mcheck_init(struct cpuinfo_x86 *c)
 	}
 }
 
-static unsigned long old_cr4 __initdata;
+static unsigned long old_cr4 __initbss;
 
 void __init stop_mce(void)
 {
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -672,7 +672,7 @@ static struct miscdevice mce_log_device 
 	&mce_chrdev_ops,
 };
 
-static unsigned long old_cr4 __initdata;
+static unsigned long old_cr4 __initbss;
 
 void __init stop_mce(void)
 {
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -30,7 +30,7 @@ static struct genapic *apic_probe[] __in
 	NULL,
 };
 
-static int cmdline_apic __initdata;
+static int cmdline_apic __initbss;
 static int __init parse_apic(char *arg)
 {
 	int i;
--- a/arch/x86/mach-visws/setup.c
+++ b/arch/x86/mach-visws/setup.c
@@ -146,7 +146,7 @@ unsigned long sgivwfb_mem_size;
 EXPORT_SYMBOL(sgivwfb_mem_phys);
 EXPORT_SYMBOL(sgivwfb_mem_size);
 
-long long mem_size __initdata = 0;
+long long mem_size __initbss;
 
 char * __init machine_specific_memory_setup(void)
 {
--- a/arch/x86/mach-voyager/voyager_cat.c
+++ b/arch/x86/mach-voyager/voyager_cat.c
@@ -566,7 +566,7 @@ cat_subread(voyager_module_t * modp, voy
 }
 
 /* buffer for storing EPROM data read in during initialisation */
-static __initdata __u8 eprom_buf[0xFFFF];
+static __initbss __u8 eprom_buf[0xFFFF];
 static voyager_module_t *voyager_initial_module;
 
 /* Initialise the cat bus components.  We assume this is called by the
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -50,7 +50,7 @@
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-static unsigned long dma_reserve __initdata;
+static unsigned long dma_reserve __initbss;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
@@ -231,7 +231,7 @@ __set_fixmap(enum fixed_addresses idx, u
 	set_pte_phys(address, phys, prot);
 }
 
-static unsigned long __initdata table_start;
+static unsigned long __initbss table_start;
 static unsigned long __meminitdata table_end;
 
 static __meminit void *alloc_low_page(unsigned long *phys)
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -46,9 +46,9 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpu
 cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_to_cpumask_map);
 
-int numa_off __initdata;
-unsigned long __initdata nodemap_addr;
-unsigned long __initdata nodemap_size;
+int numa_off __initbss;
+unsigned long __initbss nodemap_addr;
+unsigned long __initbss nodemap_size;
 
 /*
  * Given a shift value, try to populate memnodemap[]
@@ -272,7 +272,7 @@ void __init numa_init_array(void)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
-char *cmdline __initdata;
+char *cmdline __initbss;
 
 /*
  * Setups up nid to range from addr to addr + size.  If the end
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -21,15 +21,15 @@
 #include <asm/numa.h>
 #include <asm/e820.h>
 
-int acpi_numa __initdata;
+int acpi_numa __initbss;
 
 static struct acpi_table_slit *acpi_slit;
 
-static nodemask_t nodes_parsed __initdata;
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
+static nodemask_t nodes_parsed __initbss;
+static struct bootnode nodes[MAX_NUMNODES] __initbss;
 static struct bootnode nodes_add[MAX_NUMNODES];
-static int found_add_area __initdata;
-int hotadd_percent __initdata = 0;
+static int found_add_area __initbss;
+int hotadd_percent __initbss;
 
 /* Too small nodes confuse the VM badly. Usually they result
    from BIOS bugs. */
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -23,7 +23,7 @@
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
 
 /* Indicate if the mmcfg resources have been placed into the resource table. */
-static int __initdata pci_mmcfg_resources_inserted;
+static int __initbss pci_mmcfg_resources_inserted;
 
 static const char __init *pci_mmcfg_e7520(void)
 {
@@ -315,7 +315,7 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
-static int __initdata known_bridge;
+static int __initbss known_bridge;
 
 void __init __pci_mmcfg_init(int type, int early)
 {

