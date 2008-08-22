Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYHVMYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYHVMYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYHVMYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:24:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYHVMYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:24:04 -0400
Date: Fri, 22 Aug 2008 14:23:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080822122345.GA4225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86: fix VMI for early params

Andi Kleen (1):
      x86: fix oprofile + hibernation badness

Arjan van de Ven (2):
      x86: use WARN() in arch/x86/mm/ioremap.c
      x86: use WARN() in arch/x86/kernel

Cliff Wickman (1):
      x86, SGI UV: hardcode the TLB flush interrupt system vector

David Howells (1):
      werror: fix pci calgary

Ingo Molnar (1):
      x86: work around MTRR mask setting, v2

Jan Beulich (2):
      x86: fix 1:1 mapping init on 64-bit (memory hotplug case)
      x86: fix two modpost warnings in mm/init_64.c

Jeremy Fitzhardinge (1):
      x86: export pv_lock_ops non-GPL

Jiri Kosina (1):
      x86 iommu: remove unneeded parenthesis

Marcin Slusarz (2):
      x86, mmiotrace: silence section mismatch warning - leave_uniprocessor
      x86: fix section mismatch warning - uv_cpu_init

Samuel Sieb (1):
      x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"

Vegard Nossum (1):
      x86: fix BUG: unable to handle kernel paging request (numaq_tsc_disable)

Venki Pallipadi (1):
      x86: fix Xorg startup/shutdown slowdown with PAT

Yinghai Lu (1):
      x86: work around MTRR mask setting

venkatesh.pallipadi@intel.com (3):
      x86: PAT proper tracking of set_memory_uc and friends
      devmem, x86: PAT Change /dev/mem mmap with O_SYNC to use UC_MINUS
      x86: PAT Update validate_pat_support for intel CPUs


 arch/x86/kernel/amd_iommu.c                |    2 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |   17 ++++++++-
 arch/x86/kernel/cpu/cyrix.c                |   18 ----------
 arch/x86/kernel/cpu/mtrr/generic.c         |   20 ++++++++++-
 arch/x86/kernel/cpu/mtrr/main.c            |    5 +--
 arch/x86/kernel/genx2apic_uv_x.c           |    8 +++--
 arch/x86/kernel/numaq_32.c                 |    2 +-
 arch/x86/kernel/paravirt.c                 |    2 +-
 arch/x86/kernel/pci-calgary_64.c           |   14 ++++----
 arch/x86/kernel/setup.c                    |   16 ++++----
 arch/x86/kernel/smpboot.c                  |    3 ++
 arch/x86/kernel/tlb_uv.c                   |    3 +-
 arch/x86/kernel/tsc_sync.c                 |    6 +--
 arch/x86/mm/init_64.c                      |   36 +++++++++++---------
 arch/x86/mm/ioremap.c                      |    8 ++---
 arch/x86/mm/mmio-mod.c                     |    4 ++-
 arch/x86/mm/pageattr.c                     |    6 ++--
 arch/x86/mm/pat.c                          |   50 ++++++++++++++++++++--------
 arch/x86/oprofile/nmi_int.c                |   39 ++++++++++++++++++++--
 include/asm-x86/genapic_32.h               |    1 +
 include/asm-x86/genapic_64.h               |    1 +
 include/asm-x86/irq_vectors.h              |    1 +
 include/asm-x86/uv/uv_bau.h                |    5 ---
 23 files changed, 168 insertions(+), 99 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index de39e1f..69b4d06 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -65,7 +65,7 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 	u8 *target;
 
 	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
-	target = (iommu->cmd_buf + tail);
+	target = iommu->cmd_buf + tail;
 	memcpy_toio(target, cmd, sizeof(*cmd));
 	tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
 	head = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 84a8220..a6ef672 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -56,9 +56,22 @@ void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
-		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+		/*
+		 * There is a known erratum on Pentium III and Core Solo
+		 * and Core Duo CPUs.
+		 * " Page with PAT set to WC while associated MTRR is UC
+		 *   may consolidate to UC "
+		 * Because of this erratum, it is better to stick with
+		 * setting WC in MTRR rather than using PAT on these CPUs.
+		 *
+		 * Enable PAT WC only on P4, Core 2 or later CPUs.
+		 */
+		if (c->x86 > 0x6 || (c->x86 == 6 && c->x86_model >= 15))
 			return;
-		break;
+
+		pat_disable("PAT WC disabled due to known CPU erratum.");
+		return;
+
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_CENTAUR:
 	case X86_VENDOR_TRANSMETA:
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 3fd7a67..e710a21 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -134,23 +134,6 @@ static void __cpuinit set_cx86_memwb(void)
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
 }
 
-static void __cpuinit set_cx86_inc(void)
-{
-	unsigned char ccr3;
-
-	printk(KERN_INFO "Enable Incrementor on Cyrix/NSC processor.\n");
-
-	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
-	/* PCR1 -- Performance Control */
-	/* Incrementor on, whatever that is */
-	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
-	/* PCR0 -- Performance Control */
-	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
-}
-
 /*
  *	Configure later MediaGX and/or Geode processor.
  */
@@ -174,7 +157,6 @@ static void __cpuinit geode_configure(void)
 
 	set_cx86_memwb();
 	set_cx86_reorder();
-	set_cx86_inc();
 
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 509bd3d..cb7d3b6 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -379,6 +379,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 			     unsigned long *size, mtrr_type *type)
 {
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
+	unsigned int tmp, hi;
 
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
 	if ((mask_lo & 0x800) == 0) {
@@ -392,8 +393,23 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
 
 	/* Work out the shifted address mask. */
-	mask_lo = size_or_mask | mask_hi << (32 - PAGE_SHIFT)
-	    | mask_lo >> PAGE_SHIFT;
+	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
+	mask_lo = size_or_mask | tmp;
+	/* Expand tmp with high bits to all 1s*/
+	hi = fls(tmp);
+	if (hi > 0) {
+		tmp |= ~((1<<(hi - 1)) - 1);
+
+		if (tmp != mask_lo) {
+			static int once = 1;
+
+			if (once) {
+				printk(KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+				once = 0;
+			}
+			mask_lo = tmp;
+		}
+	}
 
 	/* This works correctly if size is a power of two, i.e. a
 	   contiguous range. */
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6f23969..b117d7f 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1496,11 +1496,8 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		if (!kvm_para_available()) {
-			printk(KERN_WARNING
+		WARN(!kvm_para_available(), KERN_WARNING
 				"WARNING: strange, CPU MTRRs all blank?\n");
-			WARN_ON(1);
-		}
 		return 0;
 	}
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 2d7e307..bfa837c 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -293,7 +293,9 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
-static __init void uv_system_init(void)
+static bool uv_system_inited;
+
+void __init uv_system_init(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
 	union uvh_node_id_u node_id;
@@ -383,6 +385,7 @@ static __init void uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
+	uv_system_inited = true;
 }
 
 /*
@@ -391,8 +394,7 @@ static __init void uv_system_init(void)
  */
 void __cpuinit uv_cpu_init(void)
 {
-	if (!uv_node_to_blade)
-		uv_system_init();
+	BUG_ON(!uv_system_inited);
 
 	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
 
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index b8c4561..eecc8c1 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -73,7 +73,7 @@ static void __init smp_dump_qct(void)
 }
 
 
-void __init numaq_tsc_disable(void)
+void __cpuinit numaq_tsc_disable(void)
 {
 	if (!found_numaq)
 		return;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 94da4d5..300da17 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -471,7 +471,7 @@ struct pv_lock_ops pv_lock_ops = {
 	.spin_unlock = __ticket_spin_unlock,
 #endif
 };
-EXPORT_SYMBOL_GPL(pv_lock_ops);
+EXPORT_SYMBOL(pv_lock_ops);
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 218d783..dcdac6c 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -343,9 +343,8 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	/* were we called with bad_dma_address? */
 	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
 	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
-		printk(KERN_ERR "Calgary: driver tried unmapping bad DMA "
+		WARN(1, KERN_ERR "Calgary: driver tried unmapping bad DMA "
 		       "address 0x%Lx\n", dma_addr);
-		WARN_ON(1);
 		return;
 	}
 
@@ -1269,13 +1268,15 @@ static inline int __init determine_tce_table_size(u64 ram)
 static int __init build_detail_arrays(void)
 {
 	unsigned long ptr;
-	int i, scal_detail_size, rio_detail_size;
+	unsigned numnodes, i;
+	int scal_detail_size, rio_detail_size;
 
-	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES){
+	numnodes = rio_table_hdr->num_scal_dev;
+	if (numnodes > MAX_NUMNODES){
 		printk(KERN_WARNING
 			"Calgary: MAX_NUMNODES too low! Defined as %d, "
 			"but system has %d nodes.\n",
-			MAX_NUMNODES, rio_table_hdr->num_scal_dev);
+			MAX_NUMNODES, numnodes);
 		return -ENODEV;
 	}
 
@@ -1296,8 +1297,7 @@ static int __init build_detail_arrays(void)
 	}
 
 	ptr = ((unsigned long)rio_table_hdr) + 3;
-	for (i = 0; i < rio_table_hdr->num_scal_dev;
-		    i++, ptr += scal_detail_size)
+	for (i = 0; i < numnodes; i++, ptr += scal_detail_size)
 		scal_devs[i] = (struct scal_detail *)ptr;
 
 	for (i = 0; i < rio_table_hdr->num_rio_dev;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a4656ad..362d4e7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -604,14 +604,6 @@ void __init setup_arch(char **cmdline_p)
 	early_cpu_init();
 	early_ioremap_init();
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be before kernel pagetables are setup
-	 * or fixmap area is touched.
-	 */
-	vmi_init();
-#endif
-
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
@@ -678,6 +670,14 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
+	/*
+	 * Must be before kernel pagetables are setup
+	 * or fixmap area is touched.
+	 */
+	vmi_init();
+#endif
+
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e139e61..7985c5b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1221,6 +1221,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 	setup_boot_clock();
+
+	if (is_uv_system())
+		uv_system_init();
 out:
 	preempt_enable();
 }
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index d0fbb77..8b8c0d6 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -17,6 +17,7 @@
 #include <asm/genapic.h>
 #include <asm/idle.h>
 #include <asm/tsc.h>
+#include <asm/irq_vectors.h>
 
 #include <mach_apic.h>
 
@@ -783,7 +784,7 @@ static int __init uv_bau_init(void)
 		uv_init_blade(blade, node, cur_cpu);
 		cur_cpu += uv_blade_nr_possible_cpus(blade);
 	}
-	set_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
+	alloc_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
 	uv_enable_timeouts();
 
 	return 0;
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 0577825..9ffb01c 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -88,11 +88,9 @@ static __cpuinit void check_tsc_warp(void)
 			__raw_spin_unlock(&sync_lock);
 		}
 	}
-	if (!(now-start)) {
-		printk("Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
+	WARN(!(now-start),
+		"Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
 			now-start, end-start);
-		WARN_ON(1);
-	}
 }
 
 /*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a87ea0e..d3746ef 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -241,7 +241,7 @@ static unsigned long __initdata table_start;
 static unsigned long __meminitdata table_end;
 static unsigned long __meminitdata table_top;
 
-static __meminit void *alloc_low_page(unsigned long *phys)
+static __ref void *alloc_low_page(unsigned long *phys)
 {
 	unsigned long pfn = table_end++;
 	void *adr;
@@ -262,7 +262,7 @@ static __meminit void *alloc_low_page(unsigned long *phys)
 	return adr;
 }
 
-static __meminit void unmap_low_page(void *adr)
+static __ref void unmap_low_page(void *adr)
 {
 	if (after_bootmem)
 		return;
@@ -336,9 +336,12 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		}
 
 		if (pmd_val(*pmd)) {
-			if (!pmd_large(*pmd))
+			if (!pmd_large(*pmd)) {
+				spin_lock(&init_mm.page_table_lock);
 				last_map_addr = phys_pte_update(pmd, address,
-								 end);
+								end);
+				spin_unlock(&init_mm.page_table_lock);
+			}
 			/* Count entries we're using from level2_ident_pgt */
 			if (start == 0)
 				pages++;
@@ -347,8 +350,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
 			pages++;
+			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pmd,
 				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
 			continue;
 		}
@@ -357,7 +362,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		last_map_addr = phys_pte_init(pte, address, end);
 		unmap_low_page(pte);
 
+		spin_lock(&init_mm.page_table_lock);
 		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
+		spin_unlock(&init_mm.page_table_lock);
 	}
 	update_page_count(PG_LEVEL_2M, pages);
 	return last_map_addr;
@@ -370,9 +377,7 @@ phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
 	pmd_t *pmd = pmd_offset(pud, 0);
 	unsigned long last_map_addr;
 
-	spin_lock(&init_mm.page_table_lock);
 	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask);
-	spin_unlock(&init_mm.page_table_lock);
 	__flush_tlb_all();
 	return last_map_addr;
 }
@@ -408,20 +413,21 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
 			pages++;
+			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = (addr & PUD_MASK) + PUD_SIZE;
 			continue;
 		}
 
 		pmd = alloc_low_page(&pmd_phys);
-
-		spin_lock(&init_mm.page_table_lock);
 		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask);
 		unmap_low_page(pmd);
+
+		spin_lock(&init_mm.page_table_lock);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
 		spin_unlock(&init_mm.page_table_lock);
-
 	}
 	__flush_tlb_all();
 	update_page_count(PG_LEVEL_1G, pages);
@@ -513,16 +519,14 @@ static unsigned long __init kernel_physical_mapping_init(unsigned long start,
 			continue;
 		}
 
-		if (after_bootmem)
-			pud = pud_offset(pgd, start & PGDIR_MASK);
-		else
-			pud = alloc_low_page(&pud_phys);
-
+		pud = alloc_low_page(&pud_phys);
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
 						 page_size_mask);
 		unmap_low_page(pud);
-		pgd_populate(&init_mm, pgd_offset_k(start),
-			     __va(pud_phys));
+
+		spin_lock(&init_mm.page_table_lock);
+		pgd_populate(&init_mm, pgd, __va(pud_phys));
+		spin_unlock(&init_mm.page_table_lock);
 	}
 
 	return last_map_addr;
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6ba6f88..d4b6e6a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -553,13 +553,11 @@ static int __init check_early_ioremap_leak(void)
 {
 	if (!early_ioremap_nested)
 		return 0;
-
-	printk(KERN_WARNING
+	WARN(1, KERN_WARNING
 	       "Debug warning: early ioremap leak of %d areas detected.\n",
-	       early_ioremap_nested);
+		early_ioremap_nested);
 	printk(KERN_WARNING
-	       "please boot with early_ioremap_debug and report the dmesg.\n");
-	WARN_ON(1);
+		"please boot with early_ioremap_debug and report the dmesg.\n");
 
 	return 1;
 }
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index e7397e1..635b50e 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -430,7 +430,9 @@ static void enter_uniprocessor(void)
 						"may miss events.\n");
 }
 
-static void leave_uniprocessor(void)
+/* __ref because leave_uniprocessor calls cpu_up which is __cpuinit,
+   but this whole function is ifdefed CONFIG_HOTPLUG_CPU */
+static void __ref leave_uniprocessor(void)
 {
 	int cpu;
 	int err;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f5f5154..43e2f84 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -849,7 +849,7 @@ int set_memory_uc(unsigned long addr, int numpages)
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
@@ -868,7 +868,7 @@ int set_memory_wc(unsigned long addr, int numpages)
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL))
 		return -EINVAL;
 
@@ -884,7 +884,7 @@ int _set_memory_wb(unsigned long addr, int numpages)
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	free_memtype(addr, addr + numpages * PAGE_SIZE);
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
 
 	return _set_memory_wb(addr, numpages);
 }
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2fe3091..2a50e0f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -207,6 +207,9 @@ static int chk_conflict(struct memtype *new, struct memtype *entry,
 	return -EBUSY;
 }
 
+static struct memtype *cached_entry;
+static u64 cached_start;
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -280,11 +283,17 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_lock(&memtype_lock);
 
+	if (cached_entry && start >= cached_start)
+		entry = cached_entry;
+	else
+		entry = list_entry(&memtype_list, struct memtype, nd);
+
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
-	list_for_each_entry(entry, &memtype_list, nd) {
+	list_for_each_entry_continue(entry, &memtype_list, nd) {
 		if (end <= entry->start) {
 			where = entry->nd.prev;
+			cached_entry = list_entry(where, struct memtype, nd);
 			break;
 		} else if (start <= entry->start) { /* end > entry->start */
 			err = chk_conflict(new, entry, new_type);
@@ -292,6 +301,8 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 				dprintk("Overlap at 0x%Lx-0x%Lx\n",
 					entry->start, entry->end);
 				where = entry->nd.prev;
+				cached_entry = list_entry(where,
+							struct memtype, nd);
 			}
 			break;
 		} else if (start < entry->end) { /* start > entry->start */
@@ -299,7 +310,20 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			if (!err) {
 				dprintk("Overlap at 0x%Lx-0x%Lx\n",
 					entry->start, entry->end);
-				where = &entry->nd;
+				cached_entry = list_entry(entry->nd.prev,
+							struct memtype, nd);
+
+				/*
+				 * Move to right position in the linked
+				 * list to add this new entry
+				 */
+				list_for_each_entry_continue(entry,
+							&memtype_list, nd) {
+					if (start <= entry->start) {
+						where = entry->nd.prev;
+						break;
+					}
+				}
 			}
 			break;
 		}
@@ -314,6 +338,8 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return err;
 	}
 
+	cached_start = start;
+
 	if (where)
 		list_add(&new->nd, where);
 	else
@@ -343,6 +369,9 @@ int free_memtype(u64 start, u64 end)
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
 		if (entry->start == start && entry->end == end) {
+			if (cached_entry == entry || cached_start == start)
+				cached_entry = NULL;
+
 			list_del(&entry->nd);
 			kfree(entry);
 			err = 0;
@@ -361,14 +390,6 @@ int free_memtype(u64 start, u64 end)
 }
 
 
-/*
- * /dev/mem mmap interface. The memtype used for mapping varies:
- * - Use UC for mappings with O_SYNC flag
- * - Without O_SYNC flag, if there is any conflict in reserve_memtype,
- *   inherit the memtype from existing mapping.
- * - Else use UC_MINUS memtype (for backward compatibility with existing
- *   X drivers.
- */
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
@@ -406,14 +427,14 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
 	u64 offset = ((u64) pfn) << PAGE_SHIFT;
-	unsigned long flags = _PAGE_CACHE_UC_MINUS;
+	unsigned long flags = -1;
 	int retval;
 
 	if (!range_is_allowed(pfn, size))
 		return 0;
 
 	if (file->f_flags & O_SYNC) {
-		flags = _PAGE_CACHE_UC;
+		flags = _PAGE_CACHE_UC_MINUS;
 	}
 
 #ifdef CONFIG_X86_32
@@ -436,13 +457,14 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 #endif
 
 	/*
-	 * With O_SYNC, we can only take UC mapping. Fail if we cannot.
+	 * With O_SYNC, we can only take UC_MINUS mapping. Fail if we cannot.
+	 *
 	 * Without O_SYNC, we want to get
 	 * - WB for WB-able memory and no other conflicting mappings
 	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
 	 * - Inherit from confliting mappings otherwise
 	 */
-	if (flags != _PAGE_CACHE_UC_MINUS) {
+	if (flags != -1) {
 		retval = reserve_memtype(offset, offset + size, flags, NULL);
 	} else {
 		retval = reserve_memtype(offset, offset + size, -1, &flags);
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3f90289..0227694 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/kdebug.h>
+#include <linux/cpu.h>
 #include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -28,23 +29,48 @@ static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
 static int nmi_start(void);
 static void nmi_stop(void);
+static void nmi_cpu_start(void *dummy);
+static void nmi_cpu_stop(void *dummy);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
+#ifdef CONFIG_SMP
+static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
+				 void *data)
+{
+	int cpu = (unsigned long)data;
+	switch (action) {
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
+		break;
+	case CPU_DOWN_PREPARE:
+		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 1);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block oprofile_cpu_nb = {
+	.notifier_call = oprofile_cpu_notifier
+};
+#endif
+
 #ifdef CONFIG_PM
 
 static int nmi_suspend(struct sys_device *dev, pm_message_t state)
 {
+	/* Only one CPU left, just stop that one */
 	if (nmi_enabled == 1)
-		nmi_stop();
+		nmi_cpu_stop(NULL);
 	return 0;
 }
 
 static int nmi_resume(struct sys_device *dev)
 {
 	if (nmi_enabled == 1)
-		nmi_start();
+		nmi_cpu_start(NULL);
 	return 0;
 }
 
@@ -463,6 +489,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	}
 
 	init_sysfs();
+#ifdef CONFIG_SMP
+	register_cpu_notifier(&oprofile_cpu_nb);
+#endif
 	using_nmi = 1;
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
@@ -476,6 +505,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 void op_nmi_exit(void)
 {
-	if (using_nmi)
+	if (using_nmi) {
 		exit_sysfs();
+#ifdef CONFIG_SMP
+		unregister_cpu_notifier(&oprofile_cpu_nb);
+#endif
+	}
 }
diff --git a/include/asm-x86/genapic_32.h b/include/asm-x86/genapic_32.h
index b02ea6e..754d635 100644
--- a/include/asm-x86/genapic_32.h
+++ b/include/asm-x86/genapic_32.h
@@ -118,6 +118,7 @@ enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 #define get_uv_system_type()		UV_NONE
 #define is_uv_system()			0
 #define uv_wakeup_secondary(a, b)	1
+#define uv_system_init()		do {} while (0)
 
 
 #endif
diff --git a/include/asm-x86/genapic_64.h b/include/asm-x86/genapic_64.h
index 0f85046..a47d631 100644
--- a/include/asm-x86/genapic_64.h
+++ b/include/asm-x86/genapic_64.h
@@ -42,6 +42,7 @@ extern int is_uv_system(void);
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void uv_cpu_init(void);
+extern void uv_system_init(void);
 extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 
 extern void setup_apic_routing(void);
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index b95d167..a48c7f2 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -76,6 +76,7 @@
 #define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 #define THRESHOLD_APIC_VECTOR		0xf9
+#define UV_BAU_MESSAGE			0xf8
 #define INVALIDATE_TLB_VECTOR_END	0xf7
 #define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
 
diff --git a/include/asm-x86/uv/uv_bau.h b/include/asm-x86/uv/uv_bau.h
index 91ac0df..610b6b3 100644
--- a/include/asm-x86/uv/uv_bau.h
+++ b/include/asm-x86/uv/uv_bau.h
@@ -40,11 +40,6 @@
 #define UV_ACTIVATION_DESCRIPTOR_SIZE	32
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
-#define UV_BAU_MESSAGE			200
-/*
- * Messaging irq; see irq_64.h and include/asm-x86/hw_irq_64.h
- * To be dynamically allocated in the future
- */
 #define UV_NET_ENDPOINT_INTD		0x38
 #define UV_DESC_BASE_PNODE_SHIFT	49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
