Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZB0Q32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZB0Q32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 11:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZB0Q3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 11:29:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153AbZB0Q3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 11:29:00 -0500
Date: Fri, 27 Feb 2009 17:28:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090227162835.GA13225@elte.hu>
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


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/gpu/drm/i915/i915_dma.c    # 6644107: gpu/drm, x86, PAT: Handle io_mapp
include/linux/io-mapping.h         # 4ab0d47: gpu/drm, x86, PAT: io_mapping_cre

 Thanks,

	Ingo

------------------>
James Bottomley (1):
      x86, Voyager: fix compile by lifting the degeneracy of phys_cpu_present_map

Jeremy Fitzhardinge (1):
      xen: disable interrupts early, as start_kernel expects

Kyle McMartin (2):
      x86, doc: fix references to Documentation/x86/i386/boot.txt
      x86: enable DMAR by default

Venkatesh Pallipadi (2):
      gpu/drm, x86, PAT: Handle io_mapping_create_wc() errors in a clean way
      gpu/drm, x86, PAT: io_mapping_create_wc and resource_size_t


 Documentation/kernel-parameters.txt |    4 +-
 arch/x86/Kconfig                    |    2 +-
 arch/x86/include/asm/iomap.h        |    3 ++
 arch/x86/mach-voyager/voyager_smp.c |   24 +++++++++---------
 arch/x86/mm/iomap_32.c              |   18 +++++++++++++
 arch/x86/xen/enlighten.c            |    3 ++
 drivers/gpu/drm/i915/i915_dma.c     |    9 ++++++-
 include/linux/io-mapping.h          |   46 ++++++++++++++++++++++++++--------
 8 files changed, 82 insertions(+), 27 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 319785b..f6d5d5b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -114,7 +114,7 @@ In addition, the following text indicates that the option:
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/x86/i386/boot.txt>.
+need or coordination with <Documentation/x86/boot.txt>.
 
 There are also arch-specific kernel-parameters not documented here.
 See for example <Documentation/x86/x86_64/boot-options.txt>.
@@ -2449,7 +2449,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See Documentation/fb/modedb.txt.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/x86/i386/boot.txt and
+			See Documentation/x86/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9c39095..bc2fbad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1803,7 +1803,7 @@ config DMAR
 	  remapping devices.
 
 config DMAR_DEFAULT_ON
-	def_bool n
+	def_bool y
 	prompt "Enable DMA Remapping Devices by default"
 	depends on DMAR
 	help
diff --git a/arch/x86/include/asm/iomap.h b/arch/x86/include/asm/iomap.h
index c1f0628..86af260 100644
--- a/arch/x86/include/asm/iomap.h
+++ b/arch/x86/include/asm/iomap.h
@@ -23,6 +23,9 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
+int
+is_io_mapping_possible(resource_size_t base, unsigned long size);
+
 void *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 7ffcdee..b9cc84a 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -65,7 +65,7 @@ static volatile unsigned long smp_invalidate_needed;
 
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+static cpumask_t voyager_phys_cpu_present_map = CPU_MASK_NONE;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
@@ -366,19 +366,19 @@ void __init find_smp_config(void)
 	/* set up everything for just this CPU, we can alter
 	 * this as we start the other CPUs later */
 	/* now get the CPU disposition from the extended CMOS */
-	cpus_addr(phys_cpu_present_map)[0] =
+	cpus_addr(voyager_phys_cpu_present_map)[0] =
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK);
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK + 1) << 8;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       2) << 16;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	init_cpu_possible(&phys_cpu_present_map);
-	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
-	       cpus_addr(phys_cpu_present_map)[0]);
+	init_cpu_possible(&voyager_phys_cpu_present_map);
+	printk("VOYAGER SMP: voyager_phys_cpu_present_map = 0x%lx\n",
+	       cpus_addr(voyager_phys_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
 	/* enable the CPIs by writing the base vector to their register */
 	outb(VIC_DEFAULT_CPI_BASE, VIC_CPI_BASE_REGISTER);
@@ -628,15 +628,15 @@ void __init smp_boot_cpus(void)
 		/* now that the cat has probed the Voyager System Bus, sanity
 		 * check the cpu map */
 		if (((voyager_quad_processors | voyager_extended_vic_processors)
-		     & cpus_addr(phys_cpu_present_map)[0]) !=
-		    cpus_addr(phys_cpu_present_map)[0]) {
+		     & cpus_addr(voyager_phys_cpu_present_map)[0]) !=
+		    cpus_addr(voyager_phys_cpu_present_map)[0]) {
 			/* should panic */
 			printk("\n\n***WARNING*** "
 			       "Sanity check of CPU present map FAILED\n");
 		}
 	} else if (voyager_level == 4)
 		voyager_extended_vic_processors =
-		    cpus_addr(phys_cpu_present_map)[0];
+		    cpus_addr(voyager_phys_cpu_present_map)[0];
 
 	/* this sets up the idle task to run on the current cpu */
 	voyager_extended_cpus = 1;
@@ -670,7 +670,7 @@ void __init smp_boot_cpus(void)
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
 	for (i = 0; i < nr_cpu_ids; i++) {
-		if (i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
+		if (i == boot_cpu_id || !cpu_isset(i, voyager_phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
 		/* This udelay seems to be needed for the Quad boots
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index ca53224..6c2b1af 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -20,6 +20,24 @@
 #include <asm/pat.h>
 #include <linux/module.h>
 
+#ifdef CONFIG_X86_PAE
+int
+is_io_mapping_possible(resource_size_t base, unsigned long size)
+{
+	return 1;
+}
+#else
+int
+is_io_mapping_possible(resource_size_t base, unsigned long size)
+{
+	/* There is no way to map greater than 1 << 32 address without PAE */
+	if (base + size > 0x100000000ULL)
+		return 0;
+
+	return 1;
+}
+#endif
+
 /* Map 'pfn' using fixed map 'type' and protections 'prot'
  */
 void *
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bea2152..b58e963 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1672,6 +1672,9 @@ asmlinkage void __init xen_start_kernel(void)
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
+	local_irq_disable();
+	early_boot_irqs_off();
+
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 2d797ff..6949c2d 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1090,6 +1090,11 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
         dev_priv->mm.gtt_mapping =
 		io_mapping_create_wc(dev->agp->base,
 				     dev->agp->agp_info.aper_size * 1024*1024);
+	if (dev_priv->mm.gtt_mapping == NULL) {
+		ret = -EIO;
+		goto out_rmmap;
+	}
+
 	/* Set up a WC MTRR for non-PAT systems.  This is more common than
 	 * one would think, because the kernel disables PAT on first
 	 * generation Core chips because WC PAT gets overridden by a UC
@@ -1122,7 +1127,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (!I915_NEED_GFX_HWS(dev)) {
 		ret = i915_init_phys_hws(dev);
 		if (ret != 0)
-			goto out_rmmap;
+			goto out_iomapfree;
 	}
 
 	/* On the 945G/GM, the chipset reports the MSI capability on the
@@ -1161,6 +1166,8 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 
 	return 0;
 
+out_iomapfree:
+	io_mapping_free(dev_priv->mm.gtt_mapping);
 out_rmmap:
 	iounmap(dev_priv->regs);
 free_priv:
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 82df317..cbc2f0c 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -30,11 +30,14 @@
  * See Documentation/io_mapping.txt
  */
 
-/* this struct isn't actually defined anywhere */
-struct io_mapping;
-
 #ifdef CONFIG_HAVE_ATOMIC_IOMAP
 
+struct io_mapping {
+	resource_size_t base;
+	unsigned long size;
+	pgprot_t prot;
+};
+
 /*
  * For small address space machines, mapping large objects
  * into the kernel virtual space isn't practical. Where
@@ -43,23 +46,40 @@ struct io_mapping;
  */
 
 static inline struct io_mapping *
-io_mapping_create_wc(unsigned long base, unsigned long size)
+io_mapping_create_wc(resource_size_t base, unsigned long size)
 {
-	return (struct io_mapping *) base;
+	struct io_mapping *iomap;
+
+	if (!is_io_mapping_possible(base, size))
+		return NULL;
+
+	iomap = kmalloc(sizeof(*iomap), GFP_KERNEL);
+	if (!iomap)
+		return NULL;
+
+	iomap->base = base;
+	iomap->size = size;
+	iomap->prot = pgprot_writecombine(__pgprot(__PAGE_KERNEL));
+	return iomap;
 }
 
 static inline void
 io_mapping_free(struct io_mapping *mapping)
 {
+	kfree(mapping);
 }
 
 /* Atomic map/unmap */
 static inline void *
 io_mapping_map_atomic_wc(struct io_mapping *mapping, unsigned long offset)
 {
-	offset += (unsigned long) mapping;
-	return iomap_atomic_prot_pfn(offset >> PAGE_SHIFT, KM_USER0,
-				     __pgprot(__PAGE_KERNEL_WC));
+	resource_size_t phys_addr;
+	unsigned long pfn;
+
+	BUG_ON(offset >= mapping->size);
+	phys_addr = mapping->base + offset;
+	pfn = (unsigned long) (phys_addr >> PAGE_SHIFT);
+	return iomap_atomic_prot_pfn(pfn, KM_USER0, mapping->prot);
 }
 
 static inline void
@@ -71,8 +91,9 @@ io_mapping_unmap_atomic(void *vaddr)
 static inline void *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
-	offset += (unsigned long) mapping;
-	return ioremap_wc(offset, PAGE_SIZE);
+	BUG_ON(offset >= mapping->size);
+	resource_size_t phys_addr = mapping->base + offset;
+	return ioremap_wc(phys_addr, PAGE_SIZE);
 }
 
 static inline void
@@ -83,9 +104,12 @@ io_mapping_unmap(void *vaddr)
 
 #else
 
+/* this struct isn't actually defined anywhere */
+struct io_mapping;
+
 /* Create the io_mapping object*/
 static inline struct io_mapping *
-io_mapping_create_wc(unsigned long base, unsigned long size)
+io_mapping_create_wc(resource_size_t base, unsigned long size)
 {
 	return (struct io_mapping *) ioremap_wc(base, size);
 }
