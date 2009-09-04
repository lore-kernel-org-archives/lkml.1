Return-Path: <linux-kernel-owner+w=401wt.eu-S933451AbZIDJi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbZIDJi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbZIDJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:54 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:2201 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933417AbZIDJib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXFV-01-4M3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/8] x86/amd-iommu: Align locking between attach_device and detach_device
Date: Fri, 4 Sep 2009 11:36:31 +0200
Message-ID: <1252056994-31980-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0513 (UTC) FILETIME=[3692CE90:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the locking behavior between the functions
attach_device and __attach_device consistent with the
locking behavior between detach_device and __detach_device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2b1e77c..9aa135d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1077,29 +1077,38 @@ static void __attach_device(struct amd_iommu *iommu,
 			    struct protection_domain *domain,
 			    u16 devid)
 {
-	unsigned long flags;
-	u64 pte_root = virt_to_phys(domain->pt_root);
+	u64 pte_root;
 
-	domain->dev_cnt += 1;
+	/* lock domain */
+	spin_lock(&domain->lock);
+
+	pte_root = virt_to_phys(domain->pt_root);
 
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
-	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 	amd_iommu_dev_table[devid].data[2] = domain->id;
 	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
 	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
 
 	amd_iommu_pd_table[devid] = domain;
-	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	domain->dev_cnt += 1;
+
+	/* ready */
+	spin_unlock(&domain->lock);
 }
 
 static void attach_device(struct amd_iommu *iommu,
 			  struct protection_domain *domain,
 			  u16 devid)
 {
+	unsigned long flags;
+
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 	__attach_device(iommu, domain, devid);
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
 	/*
 	 * We might boot into a crash-kernel here. The crashed kernel
-- 
1.6.3.3


