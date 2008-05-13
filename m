Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYEMT1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYEMT1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYEMT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:27:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50484 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbYEMT10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:27:26 -0400
Date: Tue, 13 May 2008 21:27:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080513192706.GA13677@elte.hu>
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


Linus, please pull the latest x86 fixes branch from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

It includes a ISA-DMA fix that was a fallout of the PCI unification. 
Thanks,

	Ingo

------------------>
Andrew Morton (1):
      x86: early_init_centaur(): use set_cpu_cap()

Cyrill Gorcunov (1):
      x86: wakeup.lds.S - section ordering fix

Hugh Dickins (1):
      x86: fix app crashes after SMP resume

Ingo Molnar (1):
      x86: fix csum_partial() export

James Bottomley (1):
      x86: [VOYAGER] fix duplicate phys_cpu_present_map symbol

Pranith Kumar (1):
      x86: arch/x86/mm/pat.c - fix warning

Roland McGrath (1):
      x86: user_regset_view table fix for ia32 on 64-bit

Takashi Iwai (1):
      x86/pci: fix broken ISA DMA

 arch/x86/kernel/acpi/realmode/wakeup.lds.S |   10 +++++-----
 arch/x86/kernel/pci-dma.c                  |    8 +++++---
 arch/x86/kernel/ptrace.c                   |    7 +++++--
 arch/x86/kernel/setup.c                    |    4 +++-
 arch/x86/kernel/setup_64.c                 |    2 +-
 arch/x86/kernel/smp.c                      |    3 ++-
 arch/x86/kernel/smpboot.c                  |   24 +++++++++++++++++-------
 arch/x86/kernel/x8664_ksyms_64.c           |    3 +++
 arch/x86/lib/csum-partial_64.c             |    2 --
 arch/x86/mm/init_32.c                      |   12 +-----------
 arch/x86/mm/pat.c                          |    4 ++--
 11 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 22fab6c..7da00b7 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -12,11 +12,6 @@ ENTRY(_start)
 
 SECTIONS
 {
-	. = HEADER_OFFSET;
-	.header : {
-		 *(.header)
-	}
-
 	. = 0;
 	.text : {
 		 *(.text*)
@@ -50,6 +45,11 @@ SECTIONS
 		__bss_end = .;
 	}
 
+	. = HEADER_OFFSET;
+	.header : {
+		*(.header)
+	}
+
 	. = ALIGN(16);
 	_end = .;
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 0c37f16..c5ef1af 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -385,11 +385,13 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
 		return memory;
 
-	if (!dev)
+	if (!dev) {
 		dev = &fallback_dev;
+		gfp |= GFP_DMA;
+	}
 	dma_mask = dev->coherent_dma_mask;
 	if (dma_mask == 0)
-		dma_mask = DMA_32BIT_MASK;
+		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
 
 	/* Device not DMA able */
 	if (dev->dma_mask == NULL)
@@ -403,7 +405,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	   larger than 16MB and in this case we have a chance of
 	   finding fitting memory in the next higher zone first. If
 	   not retry with true GFP_DMA. -AK */
-	if (dma_mask <= DMA_32BIT_MASK)
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index fb03ef3..a7835f2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1303,6 +1303,9 @@ static const struct user_regset_view user_x86_64_view = {
 #define genregs32_get		genregs_get
 #define genregs32_set		genregs_set
 
+#define user_i387_ia32_struct	user_i387_struct
+#define user32_fxsr_struct	user_fxsr_struct
+
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
@@ -1315,13 +1318,13 @@ static const struct user_regset x86_32_regsets[] = {
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.n = sizeof(struct user_i387_ia32_struct) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = fpregs_active, .get = fpregs_get, .set = fpregs_set
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c0c68c1..6f80b85 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,6 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
+#ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
@@ -23,8 +24,9 @@ EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
+#endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index f2fc8fe..6dff128 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -951,7 +951,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 {
 	if (c->x86 == 0x6 && c->x86_model >= 0xf)
-		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 }
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 8f75893..0cb7aad 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -231,7 +231,8 @@ native_smp_call_function_mask(cpumask_t mask,
 	wmb();
 
 	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
+	if (cpus_equal(mask, allbutself) &&
+	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6b087ab..3898849 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -86,6 +86,7 @@ void *x86_bios_cpu_apicid_early_ptr;
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
+static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -326,6 +327,12 @@ static void __cpuinit start_secondary(void *unused)
 		enable_8259A_irq(0);
 	}
 
+#ifdef CONFIG_X86_32
+	while (low_mappings)
+		cpu_relax();
+	__flush_tlb_all();
+#endif
+
 	/* This must be done before setting cpu_online_map */
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
@@ -1040,14 +1047,20 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 #ifdef CONFIG_X86_32
 	/* init low mem mapping */
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
+		min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
 	flush_tlb_all();
-#endif
+	low_mappings = 1;
 
 	err = do_boot_cpu(apicid, cpu);
-	if (err < 0) {
+
+	zap_low_mappings();
+	low_mappings = 0;
+#else
+	err = do_boot_cpu(apicid, cpu);
+#endif
+	if (err) {
 		Dprintk("do_boot_cpu failed %d\n", err);
-		return err;
+		return -EIO;
 	}
 
 	/*
@@ -1259,9 +1272,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	setup_ioapic_dest();
 #endif
 	check_nmi_watchdog();
-#ifdef CONFIG_X86_32
-	zap_low_mappings();
-#endif
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 58882f9..f6c05d0 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -2,6 +2,7 @@
    All C exports should go in the respective C files. */
 
 #include <linux/module.h>
+#include <net/checksum.h>
 #include <linux/smp.h>
 
 #include <asm/processor.h>
@@ -29,6 +30,8 @@ EXPORT_SYMBOL(__copy_from_user_inatomic);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 
+EXPORT_SYMBOL(csum_partial);
+
 /*
  * Export string functions. We normally rely on gcc builtin for most of these,
  * but gcc sometimes decides not to inline them.
diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index bc503f5..bf51144 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -136,8 +136,6 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 						(__force u32)sum);
 }
 
-EXPORT_SYMBOL(csum_partial);
-
 /*
  * this routine is used for miscellaneous IP-like checksums, mainly
  * in icmp.c
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index de236e4..ec30d10 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -438,8 +438,6 @@ void zap_low_mappings(void)
 {
 	int i;
 
-	save_pg_dir();
-
 	/*
 	 * Zap initial low-memory mappings.
 	 *
@@ -663,16 +661,8 @@ void __init mem_init(void)
 		test_wp_bit();
 
 	cpa_init();
-
-	/*
-	 * Subtle. SMP is doing it's boot stuff late (because it has to
-	 * fork idle threads) - but it also needs low mappings for the
-	 * protected-mode entry to work. We zap these entries only after
-	 * the WP-bit has been tested.
-	 */
-#ifndef CONFIG_SMP
+	save_pg_dir();
 	zap_low_mappings();
-#endif
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 60adbe2..bcb1a8e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -555,7 +555,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
 			current->comm, current->pid,
 			cattr_name(flags),
-			offset, offset + size);
+			offset, (unsigned long long)(offset + size));
 		return 0;
 	}
 
@@ -576,7 +576,7 @@ void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
 			current->comm, current->pid,
 			cattr_name(want_flags),
-			addr, addr + size,
+			addr, (unsigned long long)(addr + size),
 			cattr_name(flags));
 	}
 }
