Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYH0Ha2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYH0Ha2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYH0HaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:30:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:42829 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYH0HaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=crnpFzJys7CoT2rfJ53L/yOSo/OqazMfjVoywX8z2LeqsKKi/1Kl1uuKFU2msNZ2ec
         GGnLv3XBNdjWPL3htIlNo7NOK1CwfajTl//lqdLFgOr2rjEU4w9+vYBu3GAilfIPqWIe
         LMWilQbdELHgv2hcUKnhGtl2caoBU10CS4/8k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Pavel Machek <pavel@suse.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: RFC [PATCH] x86/pci: reserve extra page to avoid error caused by P2P pref DMA reads
Date: Wed, 27 Aug 2008 00:29:19 -0700
Message-Id: <1219822159-17245-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diag guys, found one system when loading is high, will have gart wark error.
root cause is P2P bridge try to prefetch for several intel e1000 under
it. and that skb is near GART iommu area.

try to reserve page in the boundary at first.
last page near TOM2, and last page near MMIO
also gart first and last page.

need one better way for all arch support PCI and memory with a lot of holes etc.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes<jbarnes@virtuousgeek.org>

---
 arch/x86/kernel/pci-dma.c     |   28 ++++++++++++++++++++++++++++
 arch/x86/kernel/pci-gart_64.c |    6 ++++++
 2 files changed, 34 insertions(+)

Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -72,12 +72,40 @@ static int __init parse_dma32_size_opt(c
 }
 early_param("dma32_size", parse_dma32_size_opt);
 
+static void __init reserve_last_page(unsigned long pfn)
+{
+	unsigned long phys;
+	void *ptr;
+
+	phys = (pfn - 1)<<PAGE_SHIFT;
+	ptr = __alloc_bootmem_nopanic(PAGE_SIZE, PAGE_SIZE, phys);
+
+	if (!ptr || virt_to_phys(ptr) != phys)
+		printk(KERN_WARNING "Can not hold last page near %lx for workaround P2P pref DMA reads!\n", phys);
+	else
+		printk(KERN_WARNING "Last page is reserved near %lx for workaround P2P pref DMA reads!\n", phys);
+}
 void __init dma32_reserve_bootmem(void)
 {
 	unsigned long size, align;
+
+	/*
+	 * try to reserve last page to workaround P2P bridge pref DMA reads
+	 * normally don't need to reserve the page near mmio,
+	 * because always has acpi etc sit there.
+	 * but some system has that acpi in the middle of ram below 4g
+	 * so just reserve it.
+	 */
+	if (max_low_pfn_mapped < max_pfn_mapped)
+		reserve_last_page(max_low_pfn_mapped);
+
+	/* less than 4G, don't need iommu */
 	if (max_pfn <= MAX_DMA32_PFN)
 		return;
 
+	/* try to reserve last page to workaround P2P bridge pref DMA reads */
+	reserve_last_page(max_pfn);
+
 	/*
 	 * check aperture_64.c allocate_aperture() for reason about
 	 * using 512M as goal
Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -826,6 +826,9 @@ void __init gart_iommu_init(void)
 	 */
 	set_bit_string(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
+	/* reserve one page at tail, for P2P bridge pref DMA reads */
+	set_bit_string(iommu_gart_bitmap, iommu_pages - 1, 1);
+
 	agp_memory_reserved = iommu_size;
 	printk(KERN_INFO
 	       "PCI-DMA: Reserving %luMB of IOMMU area in the AGP aperture\n",
@@ -870,6 +873,9 @@ void __init gart_iommu_init(void)
 	for (i = EMERGENCY_PAGES; i < iommu_pages; i++)
 		iommu_gatt_base[i] = gart_unmapped_entry;
 
+	/* we need set unmapped on head too, for P2P bridge pref DMA reads */
+	iommu_gatt_base[0] = gart_unmapped_entry;
+
 	flush_gart();
 	dma_ops = &gart_dma_ops;
 }
