Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYKFVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYKFVa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYKFVaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:30:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYKFVaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:30:13 -0500
Date: Thu, 6 Nov 2008 22:29:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081106212959.GA4649@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
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
      x86: don't use tsc_khz to calculate lpj if notsc is passed

Ben Hutchings (1):
      x86: don't allow nr_irqs > NR_IRQS

Bjorn Helgaas (1):
      x86: mention ACPI in top-level Kconfig menu

Eduardo Habkost (1):
      Revert "x86: default to reboot via ACPI"

Hugh Dickins (1):
      x86: align DirectMap in /proc/meminfo

James Bottomley (1):
      x86, voyager: fix smp_intr_init() compile breakage

Joerg Roedel (2):
      AMD IOMMU: fix detection of NP capable IOMMUs
      AMD IOMMU: fix lazy IO/TLB flushing in unmap path

Mark McLoughlin (1):
      x86/docs: remove noirqbalance param docs

Suresh Siddha (1):
      x86: add smp_mb() before sending INVALIDATE_TLB_VECTOR

Yinghai Lu (2):
      x86: size NR_IRQS on 32-bit systems the same way as 64-bit
      x86: remove VISWS and PARAVIRT around NR_IRQS puzzle


 Documentation/kernel-parameters.txt |    2 --
 arch/x86/Kconfig                    |    2 +-
 arch/x86/include/asm/irq_vectors.h  |   20 ++++++--------------
 arch/x86/include/asm/voyager.h      |    1 +
 arch/x86/kernel/amd_iommu.c         |    9 +++++++--
 arch/x86/kernel/io_apic.c           |    2 ++
 arch/x86/kernel/reboot.c            |    6 +-----
 arch/x86/kernel/tlb_32.c            |    6 ++++++
 arch/x86/kernel/tlb_64.c            |    5 +++++
 arch/x86/kernel/tsc.c               |    8 ++++----
 arch/x86/mach-voyager/setup.c       |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 arch/x86/mm/pageattr.c              |    8 ++++----
 13 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1bbcaa8..de4de3e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1470,8 +1470,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Valid arguments: on, off
 			Default: on
 
-	noirqbalance	[X86-32,SMP,KNL] Disable kernel irq balancing
-
 	noirqdebug	[X86-32] Disables the code which attempts to detect and
 			disable unhandled interrupt sources.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6f20718..5d6aa40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1494,7 +1494,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
 
-menu "Power management options"
+menu "Power management and ACPI options"
 	depends on !X86_VOYAGER
 
 config ARCH_HIBERNATION_HEADER
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index d843ed0..0005adb 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -101,30 +101,22 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 # else
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif
 
-#elif !defined(CONFIG_X86_VOYAGER)
+#elif defined(CONFIG_X86_VOYAGER)
 
-# if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
-
-#  define NR_IRQS		224
-
-# else /* IO_APIC || PARAVIRT */
-
-#  define NR_IRQS		16
-
-# endif
+# define NR_IRQS		224
 
-#else /* !VISWS && !VOYAGER */
+#else /* IO_APIC || VOYAGER */
 
-# define NR_IRQS		224
+# define NR_IRQS		16
 
-#endif /* VISWS */
+#endif
 
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
diff --git a/arch/x86/include/asm/voyager.h b/arch/x86/include/asm/voyager.h
index 9c811d2..b3e6473 100644
--- a/arch/x86/include/asm/voyager.h
+++ b/arch/x86/include/asm/voyager.h
@@ -520,6 +520,7 @@ extern void voyager_restart(void);
 extern void voyager_cat_power_off(void);
 extern void voyager_cat_do_common_interrupt(void);
 extern void voyager_handle_nmi(void);
+extern void voyager_smp_intr_init(void);
 /* Commands for the following are */
 #define	VOYAGER_PSI_READ	0
 #define VOYAGER_PSI_WRITE	1
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a8fd9eb..331b318 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -50,7 +50,7 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 /* returns !0 if the IOMMU is caching non-present entries in its TLB */
 static int iommu_has_npcache(struct amd_iommu *iommu)
 {
-	return iommu->cap & IOMMU_CAP_NPCACHE;
+	return iommu->cap & (1UL << IOMMU_CAP_NPCACHE);
 }
 
 /****************************************************************************
@@ -536,6 +536,9 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 {
 	address >>= PAGE_SHIFT;
 	iommu_area_free(dom->bitmap, address, pages);
+
+	if (address + pages >= dom->next_bit)
+		dom->need_flush = true;
 }
 
 /****************************************************************************
@@ -992,8 +995,10 @@ static void __unmap_single(struct amd_iommu *iommu,
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
-	if (amd_iommu_unmap_flush)
+	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
 		iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
+		dma_dom->need_flush = false;
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index b764d74..7a3f202 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3611,6 +3611,8 @@ int __init probe_nr_irqs(void)
 	/* something wrong ? */
 	if (nr < nr_min)
 		nr = nr_min;
+	if (WARN_ON(nr > NR_IRQS))
+		nr = NR_IRQS;
 
 	return nr;
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f4c93f1..724adfc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -29,11 +29,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-/*
- * Keyboard reset and triple fault may result in INIT, not RESET, which
- * doesn't work when we're in vmx root mode.  Try ACPI first.
- */
-enum reboot_type reboot_type = BOOT_ACPI;
+enum reboot_type reboot_type = BOOT_KBD;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index e00534b..f4049f3 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -154,6 +154,12 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	flush_mm = mm;
 	flush_va = va;
 	cpus_or(flush_cpumask, cpumask, flush_cpumask);
+
+	/*
+	 * Make the above memory operations globally visible before
+	 * sending the IPI.
+	 */
+	smp_mb();
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index dcbf7a1..8f919ca 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -183,6 +183,11 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
 
 	/*
+	 * Make the above memory operations globally visible before
+	 * sending the IPI.
+	 */
+	smp_mb();
+	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 62348e4..2ef80e3 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -813,10 +813,6 @@ void __init tsc_init(void)
 		cpu_khz = calibrate_cpu();
 #endif
 
-	lpj = ((u64)tsc_khz * 1000);
-	do_div(lpj, HZ);
-	lpj_fine = lpj;
-
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
 			(unsigned long)cpu_khz % 1000);
@@ -836,6 +832,10 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	lpj = ((u64)tsc_khz * 1000);
+	do_div(lpj, HZ);
+	lpj_fine = lpj;
+
 	use_tsc_delay();
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 6bbdd63..a580b95 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -27,7 +27,7 @@ static struct irqaction irq2 = {
 void __init intr_init_hook(void)
 {
 #ifdef CONFIG_SMP
-	smp_intr_init();
+	voyager_smp_intr_init();
 #endif
 
 	setup_irq(2, &irq2);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 7f4c6af..0e33165 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1258,7 +1258,7 @@ static void handle_vic_irq(unsigned int irq, struct irq_desc *desc)
 #define QIC_SET_GATE(cpi, vector) \
 	set_intr_gate((cpi) + QIC_DEFAULT_CPI_BASE, (vector))
 
-void __init smp_intr_init(void)
+void __init voyager_smp_intr_init(void)
 {
 	int i;
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f1dc1b7..e89d248 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -67,18 +67,18 @@ static void split_page_count(int level)
 
 void arch_report_meminfo(struct seq_file *m)
 {
-	seq_printf(m, "DirectMap4k:  %8lu kB\n",
+	seq_printf(m, "DirectMap4k:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_4K] << 2);
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-	seq_printf(m, "DirectMap2M:  %8lu kB\n",
+	seq_printf(m, "DirectMap2M:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 11);
 #else
-	seq_printf(m, "DirectMap4M:  %8lu kB\n",
+	seq_printf(m, "DirectMap4M:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 12);
 #endif
 #ifdef CONFIG_X86_64
 	if (direct_gbpages)
-		seq_printf(m, "DirectMap1G:  %8lu kB\n",
+		seq_printf(m, "DirectMap1G:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_1G] << 20);
 #endif
 }
