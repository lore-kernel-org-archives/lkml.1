Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYIQQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYIQQ4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYIQQxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52967 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbYIQQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:15 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K7CMWB-03-U9C-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/23] AMD IOMMU: some set_device_domain cleanups
Date: Wed, 17 Sep 2008 18:52:49 +0200
Message-ID: <1221670377-19295-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0126 (UTC) FILETIME=[D673CAE0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some magic numbers and split the pte_root using standard
functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |    9 +++++----
 include/asm-x86/amd_iommu_types.h |    3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 09d5e92..8c97360 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -739,12 +739,13 @@ static void set_device_domain(struct amd_iommu *iommu,
 
 	u64 pte_root = virt_to_phys(domain->pt_root);
 
-	pte_root |= (domain->mode & 0x07) << 9;
-	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | 2;
+	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
+		    << DEV_ENTRY_MODE_SHIFT;
+	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	amd_iommu_dev_table[devid].data[0] = pte_root;
-	amd_iommu_dev_table[devid].data[1] = pte_root >> 32;
+	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
 	amd_iommu_dev_table[devid].data[2] = domain->id;
 
 	amd_iommu_pd_table[devid] = domain;
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 56dc6bd..b308586 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -130,6 +130,8 @@
 #define DEV_ENTRY_NMI_PASS      0xba
 #define DEV_ENTRY_LINT0_PASS    0xbe
 #define DEV_ENTRY_LINT1_PASS    0xbf
+#define DEV_ENTRY_MODE_MASK	0x07
+#define DEV_ENTRY_MODE_SHIFT	0x09
 
 /* constants to configure the command buffer */
 #define CMD_BUFFER_SIZE    8192
@@ -159,6 +161,7 @@
 #define IOMMU_MAP_SIZE_L3 (1ULL << 39)
 
 #define IOMMU_PTE_P  (1ULL << 0)
+#define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
 #define IOMMU_PTE_FC (1ULL << 60)
 #define IOMMU_PTE_IR (1ULL << 61)
-- 
1.5.6.4


