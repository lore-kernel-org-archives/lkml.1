Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYDXVhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYDXVhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYDXVhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:37:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53657 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYDXVhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:37:19 -0400
Date: Thu, 24 Apr 2008 23:37:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080424213703.GA30311@elte.hu>
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


Linus, please pull the latest x86 fixes from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes.git for-linus

Thanks!

	Ingo

------------------>
Alexey Starikovskiy (2):
      x86: Drop duplicate from setup.c
      x86: fix compilation error in VisWS

Ingo Molnar (3):
      intel-iommu.c: dma ops fix
      x86: voyager fix
      "make namespacecheck" fixes

 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/apic_32.c           |    2 +-
 arch/x86/kernel/apic_64.c           |    4 ++--
 arch/x86/kernel/process_32.c        |    2 +-
 arch/x86/kernel/process_64.c        |    2 +-
 arch/x86/kernel/setup.c             |    2 --
 arch/x86/kernel/setup_32.c          |    4 ++--
 arch/x86/kernel/smpboot.c           |   12 ++++++------
 arch/x86/kernel/tlb_64.c            |    2 +-
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 arch/x86/mach-visws/mpparse.c       |   15 +--------------
 arch/x86/mach-voyager/voyager_smp.c |   17 -----------------
 arch/x86/mm/dump_pagetables.c       |    2 +-
 arch/x86/mm/pageattr.c              |    2 +-
 arch/x86/mm/srat_64.c               |    2 +-
 drivers/pci/intel-iommu.c           |   35 +++++++++++++++++------------------
 include/asm-x86/smp.h               |    1 -
 include/asm-x86/tsc.h               |    1 -
 18 files changed, 37 insertions(+), 72 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 87a693c..4d350b5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -23,7 +23,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
-	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
 
 config GENERIC_LOCKBREAK
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6872081..8317401 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -902,7 +902,7 @@ void __init init_bsp_APIC(void)
 	apic_write_around(APIC_LVT1, value);
 }
 
-void __cpuinit lapic_setup_esr(void)
+static void __cpuinit lapic_setup_esr(void)
 {
 	unsigned long oldvalue, value, maxlvt;
 	if (lapic_is_integrated() && !esr_disable) {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 9e8e5c0..bf83157 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -429,7 +429,7 @@ void __init setup_boot_APIC_clock(void)
  * set the DUMMY flag again and force the broadcast mode in the
  * clockevents layer.
  */
-void __cpuinit check_boot_apic_timer_broadcast(void)
+static void __cpuinit check_boot_apic_timer_broadcast(void)
 {
 	if (!disable_apic_timer ||
 	    (lapic_clockevent.features & CLOCK_EVT_FEAT_DUMMY))
@@ -834,7 +834,7 @@ void __cpuinit setup_local_APIC(void)
 	preempt_enable();
 }
 
-void __cpuinit lapic_setup_esr(void)
+static void __cpuinit lapic_setup_esr(void)
 {
 	unsigned maxlvt = lapic_get_maxlvt();
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7adad08..77de848 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -550,7 +550,7 @@ static void hard_enable_TSC(void)
 	write_cr4(read_cr4() & ~X86_CR4_TSD);
 }
 
-void enable_TSC(void)
+static void enable_TSC(void)
 {
 	preempt_disable();
 	if (test_and_clear_thread_flag(TIF_NOTSC))
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 891af1a..131c2ee 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -562,7 +562,7 @@ static void hard_enable_TSC(void)
 	write_cr4(read_cr4() & ~X86_CR4_TSD);
 }
 
-void enable_TSC(void)
+static void enable_TSC(void)
 {
 	preempt_disable();
 	if (test_and_clear_thread_flag(TIF_NOTSC))
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0d1f44a..c0c68c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -18,8 +18,6 @@ unsigned disabled_cpus __cpuinitdata;
 unsigned int boot_cpu_physical_apicid = -1U;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
-physid_mask_t phys_cpu_present_map;
-
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 78828b0..455d3c8 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -442,7 +442,7 @@ static void __init reserve_ebda_region(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-void __init setup_bootmem_allocator(void);
+static void __init setup_bootmem_allocator(void);
 static unsigned long __init setup_memory(void)
 {
 	/*
@@ -477,7 +477,7 @@ static unsigned long __init setup_memory(void)
 	return max_low_pfn;
 }
 
-void __init zone_sizes_init(void)
+static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6a92539..ade371f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -184,7 +184,7 @@ static void unmap_cpu_to_node(int cpu)
 u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
 					{ [0 ... NR_CPUS-1] = BAD_APICID };
 
-void map_cpu_to_logical_apicid(void)
+static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
 	int apicid = logical_smp_processor_id();
@@ -197,7 +197,7 @@ void map_cpu_to_logical_apicid(void)
 	map_cpu_to_node(cpu, node);
 }
 
-void unmap_cpu_to_logical_apicid(int cpu)
+static void unmap_cpu_to_logical_apicid(int cpu)
 {
 	cpu_2_logical_apicid[cpu] = BAD_APICID;
 	unmap_cpu_to_node(cpu);
@@ -211,7 +211,7 @@ void unmap_cpu_to_logical_apicid(int cpu)
  * Report back to the Boot Processor.
  * Running on AP.
  */
-void __cpuinit smp_callin(void)
+static void __cpuinit smp_callin(void)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;
@@ -436,7 +436,7 @@ valid_k7:
 #endif
 }
 
-void __cpuinit smp_checks(void)
+static void __cpuinit smp_checks(void)
 {
 	if (smp_b_stepping)
 		printk(KERN_WARNING "WARNING: SMP operation may be unreliable"
@@ -565,7 +565,7 @@ void __init smp_alloc_memory(void)
 }
 #endif
 
-void impress_friends(void)
+static void impress_friends(void)
 {
 	int cpu;
 	unsigned long bogosum = 0;
@@ -1287,7 +1287,7 @@ void cpu_exit_clear(void)
 }
 #  endif /* CONFIG_X86_32 */
 
-void remove_siblinginfo(int cpu)
+static void remove_siblinginfo(int cpu)
 {
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 1558e51..df224a8 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -191,7 +191,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	spin_unlock(&f->tlbstate_lock);
 }
 
-int __cpuinit init_smp_flush(void)
+static int __cpuinit init_smp_flush(void)
 {
 	int i;
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index edff4c9..61efa2f 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -216,7 +216,7 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 	return 0;
 }
 
-long __vsyscall(3) venosys_1(void)
+static long __vsyscall(3) venosys_1(void)
 {
 	return -ENOSYS;
 }
diff --git a/arch/x86/mach-visws/mpparse.c b/arch/x86/mach-visws/mpparse.c
index 2a8456a..57484e9 100644
--- a/arch/x86/mach-visws/mpparse.c
+++ b/arch/x86/mach-visws/mpparse.c
@@ -11,22 +11,9 @@
 /* Have we found an MP table */
 int smp_found_config;
 
-/*
- * Various Linux-internal data structures created from the
- * MP-table.
- */
-int apic_version [MAX_APICS];
-
 int pic_mode;
-unsigned long mp_lapic_addr;
-
-/* Processor that is doing the boot up */
-unsigned int boot_cpu_physical_apicid = -1U;
-
-/* Bitmask of physically existing CPUs */
-physid_mask_t phys_cpu_present_map;
 
-unsigned int __initdata maxcpus = NR_CPUS;
+extern unsigned int __cpuinitdata maxcpus;
 
 /*
  * The Visual Workstation is Intel MP compliant in the hardware
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 96f60c7..d057221 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -206,11 +206,6 @@ static struct irq_chip vic_chip = {
 /* used to count up as CPUs are brought on line (starts at 0) */
 static int cpucount = 0;
 
-/* steal a page from the bottom of memory for the trampoline and
- * squirrel its address away here.  This will be in kernel virtual
- * space */
-unsigned char *trampoline_base;
-
 /* The per cpu profile stuff - used in smp_local_timer_interrupt */
 static DEFINE_PER_CPU(int, prof_multiplier) = 1;
 static DEFINE_PER_CPU(int, prof_old_multiplier) = 1;
@@ -427,18 +422,6 @@ void __init smp_store_cpu_info(int id)
 	identify_secondary_cpu(c);
 }
 
-/* set up the trampoline and return the physical address of the code */
-unsigned long __init setup_trampoline(void)
-{
-	/* these two are global symbols in trampoline.S */
-	extern const __u8 trampoline_end[];
-	extern const __u8 trampoline_data[];
-
-	memcpy(trampoline_base, trampoline_data,
-	       trampoline_end - trampoline_data);
-	return virt_to_phys(trampoline_base);
-}
-
 /* Routine initially called when a non-boot CPU is brought online */
 static void __init start_secondary(void *unused)
 {
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 6791b83..2c24bea 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -324,7 +324,7 @@ static const struct file_operations ptdump_fops = {
 	.release	= single_release,
 };
 
-int pt_dump_init(void)
+static int pt_dump_init(void)
 {
 	struct dentry *pe;
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f7823a1..c29ebd0 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -993,7 +993,7 @@ static const struct file_operations dpa_fops = {
 	.release	= single_release,
 };
 
-int __init debug_pagealloc_proc_init(void)
+static int __init debug_pagealloc_proc_init(void)
 {
 	struct dentry *de;
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index fb43d89..3890234 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -163,7 +163,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	       pxm, apic_id, node);
 }
 
-int update_end_of_memory(unsigned long end) {return -1;}
+static int update_end_of_memory(unsigned long end) {return -1;}
 static int hotadd_enough_memory(struct bootnode *nd) {return 1;}
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int save_add_info(void) {return 1;}
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 301c68f..1fd8bb7 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1905,32 +1905,31 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 	return domain;
 }
 
-static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
-	size_t size, int dir)
+static dma_addr_t
+intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
-	int ret;
 	struct dmar_domain *domain;
-	unsigned long start_addr;
+	unsigned long start_paddr;
 	struct iova *iova;
 	int prot = 0;
+	int ret;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
-		return virt_to_bus(addr);
+		return paddr;
 
 	domain = get_valid_domain_for_dev(pdev);
 	if (!domain)
 		return 0;
 
-	addr = (void *)virt_to_phys(addr);
-	size = aligned_size((u64)addr, size);
+	size = aligned_size((u64)paddr, size);
 
 	iova = __intel_alloc_iova(hwdev, domain, size);
 	if (!iova)
 		goto error;
 
-	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	start_paddr = iova->pfn_lo << PAGE_SHIFT_4K;
 
 	/*
 	 * Check if DMAR supports zero-length reads on write only
@@ -1942,33 +1941,33 @@ static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
 		prot |= DMA_PTE_WRITE;
 	/*
-	 * addr - (addr + size) might be partial page, we should map the whole
+	 * paddr - (paddr + size) might be partial page, we should map the whole
 	 * page.  Note: if two part of one page are separately mapped, we
-	 * might have two guest_addr mapping to the same host addr, but this
+	 * might have two guest_addr mapping to the same host paddr, but this
 	 * is not a big problem
 	 */
-	ret = domain_page_mapping(domain, start_addr,
-		((u64)addr) & PAGE_MASK_4K, size, prot);
+	ret = domain_page_mapping(domain, start_paddr,
+		((u64)paddr) & PAGE_MASK_4K, size, prot);
 	if (ret)
 		goto error;
 
 	pr_debug("Device %s request: %lx@%llx mapping: %lx@%llx, dir %d\n",
-		pci_name(pdev), size, (u64)addr,
-		size, (u64)start_addr, dir);
+		pci_name(pdev), size, (u64)paddr,
+		size, (u64)start_paddr, dir);
 
 	/* it's a non-present to present mapping */
 	ret = iommu_flush_iotlb_psi(domain->iommu, domain->id,
-			start_addr, size >> PAGE_SHIFT_4K, 1);
+			start_paddr, size >> PAGE_SHIFT_4K, 1);
 	if (ret)
 		iommu_flush_write_buffer(domain->iommu);
 
-	return (start_addr + ((u64)addr & (~PAGE_MASK_4K)));
+	return (start_paddr + ((u64)paddr & (~PAGE_MASK_4K)));
 
 error:
 	if (iova)
 		__free_iova(&domain->iovad, iova);
 	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
-		pci_name(pdev), size, (u64)addr, dir);
+		pci_name(pdev), size, (u64)paddr, dir);
 	return 0;
 }
 
@@ -2082,7 +2081,7 @@ static void * intel_alloc_coherent(struct device *hwdev, size_t size,
 		return NULL;
 	memset(vaddr, 0, size);
 
-	*dma_handle = intel_map_single(hwdev, vaddr, size, DMA_BIDIRECTIONAL);
+	*dma_handle = intel_map_single(hwdev, virt_to_bus(vaddr), size, DMA_BIDIRECTIONAL);
 	if (*dma_handle)
 		return vaddr;
 	free_pages((unsigned long)vaddr, order);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 62ebdec..1ebaa5c 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -199,7 +199,6 @@ static inline int hard_smp_processor_id(void)
 #ifdef CONFIG_HOTPLUG_CPU
 extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
-extern void remove_siblinginfo(int cpu);
 #endif
 
 extern void smp_alloc_memory(void);
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 0434bd8..d2d8eb5 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -18,7 +18,6 @@ extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
 
 extern void disable_TSC(void);
-extern void enable_TSC(void);
 
 static inline cycles_t get_cycles(void)
 {
