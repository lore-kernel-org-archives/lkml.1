Return-Path: <linux-kernel-owner+w=401wt.eu-S941074AbYCSW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941074AbYCSW0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763663AbYCSVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:03:21 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:25008 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935761AbYCSVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=YfRXBKtR161EAYbMLAzeSDGJgGwn2vSv00YVTiznclV5c1XMaT7iPk4XX4XHmsKFoxzU6yxJ2H3YaXaYXSx9z+zk4aPOotq6cySU7cJmnnXltnpkdDqsbPsMddFIoTwTOEvoeG09sHUXFy4kywxQsHSrbp2ysupUydGZ8zarCE0=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 04/12] x86_64: reserve dma32 early for gart
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 5326
Date: Wed, 19 Mar 2008 14:03:54 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191403.54766.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: reserve dma32 early for gart

one system with 256g when numa is disabled said:

Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Cannot allocate aperture memory hole (ffff8101c0000000,65536K)
Kernel panic - not syncing: Not enough memory for aperture
Pid: 0, comm: swapper Not tainted 2.6.25-rc4-x86-latest.git #33

Call Trace:
 [<ffffffff84037c62>] panic+0xb2/0x190
 [<ffffffff840381fc>] ? release_console_sem+0x7c/0x250
 [<ffffffff847b1628>] ? __alloc_bootmem_nopanic+0x48/0x90
 [<ffffffff847b0ac9>] ? free_bootmem+0x29/0x50
 [<ffffffff847ac1f7>] gart_iommu_hole_init+0x5e7/0x680
 [<ffffffff847b255b>] ? alloc_large_system_hash+0x16b/0x310
 [<ffffffff84506a2f>] ? _etext+0x0/0x1
 [<ffffffff847a2e8c>] pci_iommu_alloc+0x1c/0x40
 [<ffffffff847ac795>] mem_init+0x45/0x1a0
 [<ffffffff8479ff35>] start_kernel+0x295/0x380
 [<ffffffff8479f1c2>] _sinittext+0x1c2/0x230

the root cause is : memmap PMD is too big,
[ffffe200e0600000-ffffe200e07fffff] PMD ->ffff81383c000000 on node 0
almost near 4G..., and vmemmap_alloc_block will use up the ram under 4G.

solution will be:
1. make memmap allocation get memory above 4G...
2. reserve some dma32 range early before we try to set up memmap for all.
and release that before pci_iommu_alloc, so gart or swiotlb could get some
range under 4g limit for sure.

the patch is using method 2.
because method1 may need more code to handle SPARSEMEM and SPASEMEM_VMEMMAP

will get
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 264245736k/268959744k available (8484k kernel code, 4187464k reserved, 4004k data, 724k init)

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/pci-dma_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma_64.c
+++ linux-2.6/arch/x86/kernel/pci-dma_64.c
@@ -8,6 +8,8 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/dmar.h>
+#include <linux/bootmem.h>
+#include <asm/proto.h>
 #include <asm/io.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
@@ -286,8 +288,53 @@ static __init int iommu_setup(char *p)
 }
 early_param("iommu", iommu_setup);
 
+static __initdata void *dma32_bootmem_ptr;
+static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
+
+static int __init parse_dma32_size_opt(char *p)
+{
+	if (!p)
+		return -EINVAL;
+	dma32_bootmem_size = memparse(p, &p);
+	return 0;
+}
+early_param("dma32_size", parse_dma32_size_opt);
+
+void __init dma32_reserve_bootmem(void)
+{
+	unsigned long size, align;
+	if (end_pfn <= MAX_DMA32_PFN)
+		return;
+
+	align = 64ULL<<20;
+	size = round_up(dma32_bootmem_size, align);
+	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
+				 __pa(MAX_DMA_ADDRESS));
+	if (dma32_bootmem_ptr)
+		dma32_bootmem_size = size;
+	else
+		dma32_bootmem_size = 0;
+}
+static void __init dma32_free_bootmem(void)
+{
+	int node;
+
+	if (end_pfn <= MAX_DMA32_PFN)
+		return;
+
+	if (!dma32_bootmem_ptr)
+		return;
+
+	free_bootmem(__pa(dma32_bootmem_ptr), dma32_bootmem_size);
+
+	dma32_bootmem_ptr = NULL;
+	dma32_bootmem_size = 0;
+}
+
 void __init pci_iommu_alloc(void)
 {
+	/* free the range so iommu could get some range less than 4G */
+	dma32_free_bootmem();
 	/*
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -397,6 +397,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_res_to_bootmem();
 
+	dma32_reserve_bootmem();
+
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
Index: linux-2.6/include/asm-x86/pci_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pci_64.h
+++ linux-2.6/include/asm-x86/pci_64.h
@@ -25,6 +25,7 @@ extern int (*pci_config_write)(int seg, 
 
 
 
+extern void dma32_reserve_bootmem(void);
 extern void pci_iommu_alloc(void);
 
 /* The PCI address space does equal the physical memory
