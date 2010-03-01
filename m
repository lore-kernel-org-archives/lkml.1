Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0CANZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:25:10 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:20720 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0CANZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:25:03 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz936eMab9bhab78ozz1202hzzz32i6bh2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLULE-01-6WT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] x86/amd-iommu: Protect IOMMU-API map/unmap path
Date: Mon, 1 Mar 2010 14:24:40 +0100
Message-ID: <1267449882-1415-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
References: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 13:24:48.0771 (UTC) FILETIME=[9126F530:01CAB942]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a mutex to lock page table updates in
the IOMMU-API path. We can't use the spin_lock here because
this patch might sleep.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu.c            |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ba19ad4..5e46e78 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -21,6 +21,7 @@
 #define _ASM_X86_AMD_IOMMU_TYPES_H
 
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
@@ -237,6 +238,7 @@ struct protection_domain {
 	struct list_head list;  /* for list of all protection domains */
 	struct list_head dev_list; /* List of all devices in this domain */
 	spinlock_t lock;	/* mostly used to lock the page table*/
+	struct mutex api_lock;	/* protect page tables in the iommu-api path */
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2c4a501..b97f2f1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2327,6 +2327,7 @@ static struct protection_domain *protection_domain_alloc(void)
 		return NULL;
 
 	spin_lock_init(&domain->lock);
+	mutex_init(&domain->api_lock);
 	domain->id = domain_id_alloc();
 	if (!domain->id)
 		goto out_err;
@@ -2456,6 +2457,8 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	iova  &= PAGE_MASK;
 	paddr &= PAGE_MASK;
 
+	mutex_lock(&domain->api_lock);
+
 	for (i = 0; i < npages; ++i) {
 		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
 		if (ret)
@@ -2465,6 +2468,8 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 		paddr += PAGE_SIZE;
 	}
 
+	mutex_unlock(&domain->api_lock);
+
 	return 0;
 }
 
@@ -2477,12 +2482,16 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
 	iova  &= PAGE_MASK;
 
+	mutex_lock(&domain->api_lock);
+
 	for (i = 0; i < npages; ++i) {
 		iommu_unmap_page(domain, iova, PM_MAP_4k);
 		iova  += PAGE_SIZE;
 	}
 
 	iommu_flush_tlb_pde(domain);
+
+	mutex_unlock(&domain->api_lock);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
-- 
1.7.0


