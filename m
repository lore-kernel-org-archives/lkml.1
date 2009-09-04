Return-Path: <linux-kernel-owner+w=401wt.eu-S933422AbZIDJic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbZIDJic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933357AbZIDJia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:38:30 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:6358 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbZIDJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:21 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXFQ-01-4LX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/8] x86/amd-iommu: Fix device table write order
Date: Fri, 4 Sep 2009 11:36:30 +0200
Message-ID: <1252056994-31980-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0201 (UTC) FILETIME=[36633310:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The V bit of the device table entry has to be set after the
rest of the entry is written to not confuse the hardware.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7987f20..2b1e77c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1087,9 +1087,9 @@ static void __attach_device(struct amd_iommu *iommu,
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
 	amd_iommu_dev_table[devid].data[2] = domain->id;
+	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
 
 	amd_iommu_pd_table[devid] = domain;
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
-- 
1.6.3.3


