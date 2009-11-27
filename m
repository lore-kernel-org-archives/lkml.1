Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZK0N4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZK0N4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZK0N4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:06 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35942 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbZK0Nz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:59 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD9-01-6S2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/34] x86/amd-iommu: Make alloc_new_range aware of multiple IOMMUs
Date: Fri, 27 Nov 2009 14:55:27 +0100
Message-ID: <1259330145-14865-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0295 (UTC) FILETIME=[52AF4D70:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the assumption that an dma_ops domain is only bound to
one IOMMU was given up we need to make alloc_new_range aware
of it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index da3f9d8..687f617 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -788,11 +788,11 @@ static u64 *fetch_pte(struct protection_domain *domain,
  * aperture in case of dma_ops domain allocation or address allocation
  * failure.
  */
-static int alloc_new_range(struct amd_iommu *iommu,
-			   struct dma_ops_domain *dma_dom,
+static int alloc_new_range(struct dma_ops_domain *dma_dom,
 			   bool populate, gfp_t gfp)
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
+	struct amd_iommu *iommu;
 	int i;
 
 #ifdef CONFIG_IOMMU_STRESS
@@ -832,14 +832,17 @@ static int alloc_new_range(struct amd_iommu *iommu,
 	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
 
 	/* Intialize the exclusion range if necessary */
-	if (iommu->exclusion_start &&
-	    iommu->exclusion_start >= dma_dom->aperture[index]->offset &&
-	    iommu->exclusion_start < dma_dom->aperture_size) {
-		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
-					    iommu->exclusion_length,
-					    PAGE_SIZE);
-		dma_ops_reserve_addresses(dma_dom, startpage, pages);
+	for_each_iommu(iommu) {
+		if (iommu->exclusion_start &&
+		    iommu->exclusion_start >= dma_dom->aperture[index]->offset
+		    && iommu->exclusion_start < dma_dom->aperture_size) {
+			unsigned long startpage;
+			int pages = iommu_num_pages(iommu->exclusion_start,
+						    iommu->exclusion_length,
+						    PAGE_SIZE);
+			startpage = iommu->exclusion_start >> PAGE_SHIFT;
+			dma_ops_reserve_addresses(dma_dom, startpage, pages);
+		}
 	}
 
 	/*
@@ -1143,7 +1146,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 
 	add_domain_to_list(&dma_dom->domain);
 
-	if (alloc_new_range(iommu, dma_dom, true, GFP_KERNEL))
+	if (alloc_new_range(dma_dom, true, GFP_KERNEL))
 		goto free_dma_dom;
 
 	/*
@@ -1686,7 +1689,7 @@ retry:
 		 */
 		dma_dom->next_address = dma_dom->aperture_size;
 
-		if (alloc_new_range(iommu, dma_dom, false, GFP_ATOMIC))
+		if (alloc_new_range(dma_dom, false, GFP_ATOMIC))
 			goto out;
 
 		/*
-- 
1.6.5.3


