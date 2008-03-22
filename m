Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYCVTE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYCVTE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 15:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757718AbYCVTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 15:04:18 -0400
Received: from www.tglx.de ([62.245.132.106]:60884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbYCVTER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 15:04:17 -0400
Date: Sat, 22 Mar 2008 20:03:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [GIT pull] x86 revert dma32 gart
Message-ID: <alpine.LFD.1.00.0803221926580.3781@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

 ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

the revert below.

Thanks,

	tglx

---
x86: revert: reserve dma32 early for gart

Revert

commit f62f1fc9ef94f74fda2b456d935ba2da69fa0a40
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Fri Mar 7 15:02:50 2008 -0800

    x86: reserve dma32 early for gart

The patch has a dependency on bootmem modifications which are not .25
material that late in the -rc cycle. The problem which is addressed by
the patch is limited to machines with 256G and more memory booted with
NUMA disabled. This is not a .25 regression and the audience which is
affected by this problem is very limited, so it's safer to do the
revert than pulling in intrusive bootmem changes right now.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/pci-dma_64.c |   49 -------------------------------------------
 arch/x86/kernel/setup_64.c   |    2 -
 include/asm-x86/pci_64.h     |    1 
 3 files changed, 52 deletions(-)

Index: linux-2.6/arch/x86/kernel/pci-dma_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma_64.c
+++ linux-2.6/arch/x86/kernel/pci-dma_64.c
@@ -8,8 +8,6 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/dmar.h>
-#include <linux/bootmem.h>
-#include <asm/proto.h>
 #include <asm/io.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
@@ -288,55 +286,8 @@ static __init int iommu_setup(char *p)
 }
 early_param("iommu", iommu_setup);
 
-static __initdata void *dma32_bootmem_ptr;
-static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
-
-static int __init parse_dma32_size_opt(char *p)
-{
-	if (!p)
-		return -EINVAL;
-	dma32_bootmem_size = memparse(p, &p);
-	return 0;
-}
-early_param("dma32_size", parse_dma32_size_opt);
-
-void __init dma32_reserve_bootmem(void)
-{
-	unsigned long size, align;
-	if (end_pfn <= MAX_DMA32_PFN)
-		return;
-
-	align = 64ULL<<20;
-	size = round_up(dma32_bootmem_size, align);
-	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
-				 __pa(MAX_DMA_ADDRESS));
-	if (dma32_bootmem_ptr)
-		dma32_bootmem_size = size;
-	else
-		dma32_bootmem_size = 0;
-}
-static void __init dma32_free_bootmem(void)
-{
-	int node;
-
-	if (end_pfn <= MAX_DMA32_PFN)
-		return;
-
-	if (!dma32_bootmem_ptr)
-		return;
-
-	for_each_online_node(node)
-		free_bootmem_node(NODE_DATA(node), __pa(dma32_bootmem_ptr),
-				  dma32_bootmem_size);
-
-	dma32_bootmem_ptr = NULL;
-	dma32_bootmem_size = 0;
-}
-
 void __init pci_iommu_alloc(void)
 {
-	/* free the range so iommu could get some range less than 4G */
-	dma32_free_bootmem();
 	/*
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -389,8 +389,6 @@ void __init setup_arch(char **cmdline_p)
 
 	early_res_to_bootmem();
 
-	dma32_reserve_bootmem();
-
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
Index: linux-2.6/include/asm-x86/pci_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pci_64.h
+++ linux-2.6/include/asm-x86/pci_64.h
@@ -25,7 +25,6 @@ extern int (*pci_config_write)(int seg, 
 
 
 
-extern void dma32_reserve_bootmem(void);
 extern void pci_iommu_alloc(void);
 
 /* The PCI address space does equal the physical memory
