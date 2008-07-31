Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYGaVnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYGaVnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYGaVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:42:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbYGaVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:42:50 -0400
Date: Thu, 31 Jul 2008 23:42:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20080731214232.GA22330@elte.hu>
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

(the out-of-topic bits come from a half-revert of a bad commit that went 
upstream prematurely via the PCI tree - has the ack of Jesse as well.)

 out-of-topic modifications in x86-fixes-for-linus:
 --------------------------------------------------
 include/linux/iommu-helper.h     # 8978b74: generic, x86: fix add iommu_num_p
 init/calibrate.c                 # d7ba11d: x86: remove stray <6> in BogoMIPS
 lib/iommu-helper.c               # 8978b74: generic, x86: fix add iommu_num_p

Thanks,

	Ingo

------------------>
Bernhard Walle (1):
      x86: move dma32_reserve_bootmem() after reserve_crashkernel()

FUJITA Tomonori (1):
      generic, x86: fix add iommu_num_pages helper function

Joe Perches (1):
      x86: remove stray <6> in BogoMIPS printk


 arch/x86/kernel/pci-dma.c    |    8 ++++++++
 arch/x86/kernel/setup.c      |   13 +++++++++----
 include/asm-x86/iommu.h      |    2 ++
 include/linux/iommu-helper.h |    1 -
 init/calibrate.c             |    2 +-
 lib/iommu-helper.c           |    8 --------
 6 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 8dbffb8..87d4d69 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -123,6 +123,14 @@ void __init pci_iommu_alloc(void)
 
 	pci_swiotlb_init();
 }
+
+unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
+{
+	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
+
+	return size >> PAGE_SHIFT;
+}
+EXPORT_SYMBOL(iommu_num_pages);
 #endif
 
 /*
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b520dae..2d88858 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -788,10 +788,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn);
 
-#ifdef CONFIG_X86_64
-	dma32_reserve_bootmem();
-#endif
-
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
@@ -806,6 +802,15 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	reserve_crashkernel();
 
+#ifdef CONFIG_X86_64
+	/*
+	 * dma32_reserve_bootmem() allocates bootmem which may conflict
+	 * with the crashkernel command line, so do that after
+	 * reserve_crashkernel()
+	 */
+	dma32_reserve_bootmem();
+#endif
+
 	reserve_ibft_region();
 
 #ifdef CONFIG_KVM_CLOCK
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index ecc8061..5f888cc 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -7,6 +7,8 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
+extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
+
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
 extern int gart_iommu_aperture_allowed;
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index f8598f5..c975caf 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -8,4 +8,3 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
diff --git a/init/calibrate.c b/init/calibrate.c
index 7963e3f..a379c90 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -170,7 +170,7 @@ void __cpuinit calibrate_delay(void)
 				loops_per_jiffy &= ~loopbit;
 		}
 	}
-	printk(KERN_INFO "%lu.%02lu BogoMIPS (lpj=%lu)\n",
+	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			loops_per_jiffy/(500000/HZ),
 			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 }
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 889ddce..a3b8d4c 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -80,11 +80,3 @@ void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
 	}
 }
 EXPORT_SYMBOL(iommu_area_free);
-
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
-{
-	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
-
-	return size >> PAGE_SHIFT;
-}
-EXPORT_SYMBOL(iommu_num_pages);
