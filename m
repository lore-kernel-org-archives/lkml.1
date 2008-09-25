Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYIYKOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYIYKOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYIYKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:14:12 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4163 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYIYKOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:14:10 -0400
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7QXR7-04-9SK-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for GART
Date: Thu, 25 Sep 2008 12:13:55 +0200
Message-ID: <1222337635-28285-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Sep 2008 10:13:55.0532 (UTC) FILETIME=[6ADBE0C0:01C91EF7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index aecea06..84d541f 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -674,13 +674,13 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	info->aper_size = aper_size >> 20;
 
 	gatt_size = (aper_size >> PAGE_SHIFT) * sizeof(u32);
-	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size));
+	gatt = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					get_order(gatt_size));
 	if (!gatt)
 		panic("Cannot allocate GATT table");
 	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 
-	memset(gatt, 0, gatt_size);
 	agp_gatt_table = gatt;
 
 	enable_gart_translations();
@@ -788,18 +788,15 @@ void __init gart_iommu_init(void)
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
-	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL,
+	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						      get_order(iommu_pages/8));
 	if (!iommu_gart_bitmap)
 		panic("Cannot allocate iommu bitmap\n");
-	memset(iommu_gart_bitmap, 0, iommu_pages/8);
 
 #ifdef CONFIG_IOMMU_LEAK
 	if (leak_trace) {
-		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL,
+		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 				  get_order(iommu_pages*sizeof(void *)));
-		if (iommu_leak_tab)
-			memset(iommu_leak_tab, 0, iommu_pages * 8);
 		else
 			printk(KERN_DEBUG
 			       "PCI-DMA: Cannot allocate leak trace area\n");
-- 
1.5.6.4


