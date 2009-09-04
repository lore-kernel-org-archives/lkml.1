Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbZIDJmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbZIDJmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933418AbZIDJml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:41 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58878 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbZIDJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:37 -0400
X-WSS-ID: 0KPFXLO-04-HX3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/14] x86/amd-iommu: Make fetch_pte aware of dynamic mapping levels
Date: Fri, 4 Sep 2009 11:40:39 +0200
Message-ID: <1252057252-32074-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0236 (UTC) FILETIME=[CC9CB040:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the fetch_pte function in the AMD IOMMU
driver to support dynamic mapping levels.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    9 +++++++++
 arch/x86/kernel/amd_iommu.c            |   24 +++++++++++++-----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0c878ca..7fce4ef 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -146,12 +146,21 @@
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
 #define PAGE_MODE_3_LEVEL 0x03
+#define PAGE_MODE_4_LEVEL 0x04
+#define PAGE_MODE_5_LEVEL 0x05
+#define PAGE_MODE_6_LEVEL 0x06
 
 #define IOMMU_PDE_NL_0   0x000ULL
 #define IOMMU_PDE_NL_1   0x200ULL
 #define IOMMU_PDE_NL_2   0x400ULL
 #define IOMMU_PDE_NL_3   0x600ULL
 
+#define PM_LEVEL_SHIFT(x)	(12 + ((x) * 9))
+#define PM_LEVEL_SIZE(x)	(((x) < 6) ? \
+				  ((1ULL << PM_LEVEL_SHIFT((x))) - 1): \
+				   (0xffffffffffffffffULL))
+#define PM_LEVEL_INDEX(x, a)	(((a) >> PM_LEVEL_SHIFT((x))) & 0x1ffULL)
+
 #define IOMMU_PTE_L2_INDEX(address) (((address) >> 30) & 0x1ffULL)
 #define IOMMU_PTE_L1_INDEX(address) (((address) >> 21) & 0x1ffULL)
 #define IOMMU_PTE_L0_INDEX(address) (((address) >> 12) & 0x1ffULL)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6c99f50..29bcd35 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -61,6 +61,8 @@ static u64* alloc_pte(struct protection_domain *dom,
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
+static u64 *fetch_pte(struct protection_domain *domain,
+		      unsigned long address);
 
 #ifndef BUS_NOTIFY_UNBOUND_DRIVER
 #define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
@@ -670,24 +672,24 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  * This function checks if there is a PTE for a given dma address. If
  * there is one, it returns the pointer to it.
  */
-static u64* fetch_pte(struct protection_domain *domain,
+static u64 *fetch_pte(struct protection_domain *domain,
 		      unsigned long address)
 {
+	int level;
 	u64 *pte;
 
-	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(address)];
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return NULL;
+	while (level > 0) {
+		if (!IOMMU_PTE_PRESENT(*pte))
+			return NULL;
 
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+		level -= 1;
 
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return NULL;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+		pte = IOMMU_PTE_PAGE(*pte);
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
+	}
 
 	return pte;
 }
-- 
1.6.3.3


