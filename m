Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYIYKPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYIYKPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYIYKOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:14:22 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:39568 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYIYKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:14:20 -0400
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7QXRB-03-FWH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] x86/iommu: convert GART need_flush to bool
Date: Thu, 25 Sep 2008 12:13:54 +0200
Message-ID: <1222337635-28285-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Sep 2008 10:13:55.0518 (UTC) FILETIME=[6AD9BDE0:01C91EF7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index aa569db..aecea06 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -80,7 +80,7 @@ AGPEXTERN int agp_memory_reserved;
 AGPEXTERN __u32 *agp_gatt_table;
 
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
-static int need_flush;		/* global flush state. set for each gart wrap */
+static bool need_flush;		/* global flush state. set for each gart wrap */
 
 static unsigned long alloc_iommu(struct device *dev, int size,
 				 unsigned long align_mask)
@@ -98,7 +98,7 @@ static unsigned long alloc_iommu(struct device *dev, int size,
 	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
 				  size, base_index, boundary_size, align_mask);
 	if (offset == -1) {
-		need_flush = 1;
+		need_flush = true;
 		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
 					  size, base_index, boundary_size,
 					  align_mask);
@@ -107,11 +107,11 @@ static unsigned long alloc_iommu(struct device *dev, int size,
 		next_bit = offset+size;
 		if (next_bit >= iommu_pages) {
 			next_bit = 0;
-			need_flush = 1;
+			need_flush = true;
 		}
 	}
 	if (iommu_fullflush)
-		need_flush = 1;
+		need_flush = true;
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 
 	return offset;
@@ -136,7 +136,7 @@ static void flush_gart(void)
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	if (need_flush) {
 		k8_flush_garts();
-		need_flush = 0;
+		need_flush = false;
 	}
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 }
-- 
1.5.6.4


