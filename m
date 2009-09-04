Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbZIDJnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbZIDJnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933478AbZIDJmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:12 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26885 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbZIDJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:04 -0400
X-WSS-ID: 0KPFXLY-04-HX9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/14] x86/amd-iommu: Introduce increase_address_space function
Date: Fri, 4 Sep 2009 11:40:45 +0200
Message-ID: <1252057252-32074-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0533 (UTC) FILETIME=[CCCA01D0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will be used to increase the address space
size of a protection domain.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    4 ++++
 arch/x86/kernel/amd_iommu.c            |   27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 97f3d09..1b4b3d6 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -160,6 +160,10 @@
 				  ((1ULL << PM_LEVEL_SHIFT((x))) - 1): \
 				   (0xffffffffffffffffULL))
 #define PM_LEVEL_INDEX(x, a)	(((a) >> PM_LEVEL_SHIFT((x))) & 0x1ffULL)
+#define PM_LEVEL_ENC(x)		(((x) << 9) & 0xe00ULL)
+#define PM_LEVEL_PDE(x, a)	((a) | PM_LEVEL_ENC((x)) | \
+				 IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
+
 
 #define IOMMU_PTE_L2_INDEX(address) (((address) >> 30) & 0x1ffULL)
 #define IOMMU_PTE_L1_INDEX(address) (((address) >> 21) & 0x1ffULL)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5eab6a8..fc97b51 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1325,6 +1325,33 @@ static void update_domain(struct protection_domain *domain)
 }
 
 /*
+ * This function is used to add another level to an IO page table. Adding
+ * another level increases the size of the address space by 9 bits to a size up
+ * to 64 bits.
+ */
+static bool increase_address_space(struct protection_domain *domain,
+				   gfp_t gfp)
+{
+	u64 *pte;
+
+	if (domain->mode == PAGE_MODE_6_LEVEL)
+		/* address space already 64 bit large */
+		return false;
+
+	pte = (void *)get_zeroed_page(gfp);
+	if (!pte)
+		return false;
+
+	*pte             = PM_LEVEL_PDE(domain->mode,
+					virt_to_phys(domain->pt_root));
+	domain->pt_root  = pte;
+	domain->mode    += 1;
+	domain->updated  = true;
+
+	return true;
+}
+
+/*
  * If the pte_page is not yet allocated this function is called
  */
 static u64* alloc_pte(struct protection_domain *dom,
-- 
1.6.3.3


