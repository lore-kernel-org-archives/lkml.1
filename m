Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0BKOd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:33:56 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:21167
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755740Ab0BKOdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:45 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRO-01-0UK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/7] x86/amd-iommu: Move dte udpate flag into flush_info structure
Date: Thu, 11 Feb 2010 15:33:13 +0100
Message-ID: <1265898797-32183-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0540 (UTC) FILETIME=[291E3440:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the flag to indicate a DTE flush is needed
to the new flush_info structure. It also renames the
update_domain function to iommu_update_domain_dte to match
the name with iommu_update_domain_tlb nomenclature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 30c4410..529180f 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -234,6 +234,7 @@ extern bool amd_iommu_np_cache;
  * needs to be flushed on the IOMMU hardware.
  */
 struct flush_info {
+	bool dte;
 	bool tlb;
 	u64 start;
 	u64 end;
@@ -251,7 +252,6 @@ struct protection_domain {
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
 	unsigned long flags;	/* flags to find out type of domain */
-	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 	struct flush_info flush;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9318512..02ab775 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -58,7 +58,7 @@ struct iommu_cmd {
 };
 
 static void reset_iommu_command_buffer(struct amd_iommu *iommu);
-static void update_domain(struct protection_domain *domain);
+static void iommu_update_domain_dte(struct protection_domain *domain);
 
 /****************************************************************************
  *
@@ -745,9 +745,9 @@ static bool increase_address_space(struct protection_domain *domain,
 
 	*pte             = PM_LEVEL_PDE(domain->mode,
 					virt_to_phys(domain->pt_root));
-	domain->pt_root  = pte;
-	domain->mode    += 1;
-	domain->updated  = true;
+	domain->pt_root    = pte;
+	domain->mode      += 1;
+	domain->flush.dte  = true;
 
 	return true;
 }
@@ -856,7 +856,7 @@ static int iommu_map_page(struct protection_domain *dom,
 
 	*pte = __pte;
 
-	update_domain(dom);
+	iommu_update_domain_dte(dom);
 
 	return 0;
 }
@@ -1072,12 +1072,12 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
 	}
 
-	update_domain(&dma_dom->domain);
+	iommu_update_domain_dte(&dma_dom->domain);
 
 	return 0;
 
 out_free:
-	update_domain(&dma_dom->domain);
+	iommu_update_domain_dte(&dma_dom->domain);
 
 	free_page((unsigned long)dma_dom->aperture[index]->bitmap);
 
@@ -1708,16 +1708,16 @@ static void update_device_table(struct protection_domain *domain)
 	}
 }
 
-static void update_domain(struct protection_domain *domain)
+static void iommu_update_domain_dte(struct protection_domain *domain)
 {
-	if (!domain->updated)
+	if (!domain->flush.dte)
 		return;
 
 	update_device_table(domain);
 	iommu_flush_domain_devices(domain);
 	iommu_flush_tlb_pde(domain);
 
-	domain->updated = false;
+	domain->flush.dte = false;
 }
 
 /*
@@ -1741,7 +1741,7 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 	} else
 		pte += PM_LEVEL_INDEX(0, address);
 
-	update_domain(&dom->domain);
+	iommu_update_domain_dte(&dom->domain);
 
 	return pte;
 }
-- 
1.6.6


