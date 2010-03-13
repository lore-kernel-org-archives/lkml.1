Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab0CMQjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 11:39:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862Ab0CMQjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 11:39:31 -0500
Date: Sat, 13 Mar 2010 17:39:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100313163901.GA15555@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/char/agp/Kconfig           # 0e152cd: x86, k8 nb: Fix boot crash: enabl

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, k8 nb: Fix boot crash: enable k8_northbridges unconditionally on AMD systems

Jack Steiner (1):
      x86, UV: Fix target_cpus() in x2apic_uv_x.c

Mike Travis (2):
      x86: Reduce per cpu MCA boot up messages
      x86: Reduce per cpu warning boot up messages

Suresh Siddha (1):
      x86_64, cpa: Don't work hard in preserving kernel 2M mappings when using 4K already


 arch/x86/Kconfig                       |    4 ++--
 arch/x86/kernel/apic/x2apic_uv_x.c     |    4 +---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    4 ++--
 arch/x86/kernel/k8.c                   |   14 ++++++++++++++
 arch/x86/kernel/pci-gart_64.c          |    2 +-
 arch/x86/kernel/process.c              |    2 +-
 arch/x86/mm/pageattr.c                 |   25 +++++++++++++++++++++++--
 drivers/char/agp/Kconfig               |    2 +-
 8 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..ddb52b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -627,7 +627,7 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	depends on X86_64 && PCI
+	depends on X86_64 && PCI && K8_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -2026,7 +2026,7 @@ endif # X86_32
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
+	depends on CPU_SUP_AMD && PCI
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 21db3cb..af0ca80 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -114,11 +114,9 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
 static const struct cpumask *uv_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 7c78563..d15df6e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -95,7 +95,7 @@ static void cmci_discover(int banks, int boot)
 
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
+			if (test_and_clear_bit(i, owned) && !boot)
 				print_update("SHD", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
@@ -107,7 +107,7 @@ static void cmci_discover(int banks, int boot)
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & CMCI_EN) {
-			if (!test_and_set_bit(i, owned) || boot)
+			if (!test_and_set_bit(i, owned) && !boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 		} else {
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index cbc4332..9b89546 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -121,3 +121,17 @@ void k8_flush_garts(void)
 }
 EXPORT_SYMBOL_GPL(k8_flush_garts);
 
+static __init int init_k8_nbs(void)
+{
+	int err = 0;
+
+	err = cache_k8_northbridges();
+
+	if (err < 0)
+		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
+
+	return err;
+}
+
+/* This has to go after the PCI subsystem */
+fs_initcall(init_k8_nbs);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 34de53b..f3af115 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -735,7 +735,7 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
+	if (num_k8_northbridges == 0)
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c9b3522..4e8cb4e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -600,7 +600,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	if (pm_idle == poll_idle && smp_num_siblings > 1) {
-		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+		printk_once(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
 	}
 #endif
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1d4eb93..cf07c26 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -291,8 +291,29 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 */
 	if (kernel_set_to_readonly &&
 	    within(address, (unsigned long)_text,
-		   (unsigned long)__end_rodata_hpage_align))
-		pgprot_val(forbidden) |= _PAGE_RW;
+		   (unsigned long)__end_rodata_hpage_align)) {
+		unsigned int level;
+
+		/*
+		 * Don't enforce the !RW mapping for the kernel text mapping,
+		 * if the current mapping is already using small page mapping.
+		 * No need to work hard to preserve large page mappings in this
+		 * case.
+		 *
+		 * This also fixes the Linux Xen paravirt guest boot failure
+		 * (because of unexpected read-only mappings for kernel identity
+		 * mappings). In this paravirt guest case, the kernel text
+		 * mapping and the kernel identity mapping share the same
+		 * page-table pages. Thus we can't really use different
+		 * protections for the kernel text and identity mappings. Also,
+		 * these shared mappings are made of small page mappings.
+		 * Thus this don't enforce !RW mapping for small page kernel
+		 * text mapping logic will help Linux Xen parvirt guest boot
+		 * aswell.
+		 */
+		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
+			pgprot_val(forbidden) |= _PAGE_RW;
+	}
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 2fb3a48..4b66c69 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -57,7 +57,7 @@ config AGP_AMD
 
 config AGP_AMD64
 	tristate "AMD Opteron/Athlon64 on-CPU GART support"
-	depends on AGP && X86
+	depends on AGP && X86 && K8_NB
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
