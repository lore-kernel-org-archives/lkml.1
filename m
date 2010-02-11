Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0BKOey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:34:54 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40452
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754191Ab0BKOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:38 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i87h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRQ-01-0UN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/7] x86/amd-iommu: Add function to commit domain changes
Date: Thu, 11 Feb 2010 15:33:15 +0100
Message-ID: <1265898797-32183-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0759 (UTC) FILETIME=[293F9EF0:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the function iommu_update_domain() which
makes sure that the hardware caches are in sync with the
software changes. This function is used in the iommu-api
path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index bda00f0..4063f55 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -761,6 +761,13 @@ static void iommu_update_domain_dte(struct protection_domain *domain)
 	domain->flush.dte = false;
 }
 
+static void iommu_update_domain(struct protection_domain *domain)
+{
+	iommu_update_domain_dte(domain);
+	iommu_update_domain_tlb(domain, false);
+	iommu_flush_complete(domain);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -899,8 +906,6 @@ static int iommu_map_page(struct protection_domain *dom,
 
 	*pte = __pte;
 
-	iommu_update_domain_dte(dom);
-
 	return 0;
 }
 
@@ -2495,8 +2500,7 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	if (unlikely(amd_iommu_np_cache))
 		update_flush_info_tlb(domain, iova, iova + size);
 
-	iommu_update_domain_tlb(domain, true);
-	iommu_flush_complete(domain);
+	iommu_update_domain(domain);
 
 	return 0;
 }
@@ -2517,8 +2521,7 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
 	update_flush_info_tlb(domain, iova, iova + size);
 
-	iommu_update_domain_tlb(domain, true);
-	iommu_flush_complete(domain);
+	iommu_update_domain(domain);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
-- 
1.6.6


