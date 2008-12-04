Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYLDRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYLDRiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYLDRc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:29 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47509 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbYLDRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:11 -0500
X-BigFish: VPS27(z1857r1039ozzzzzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0KBD4P6-03-CX3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/19] AMD IOMMU: make dma_ops_free_pagetable generic
Date: Thu, 4 Dec 2008 18:31:41 +0100
Message-ID: <1228411916-22668-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0011 (UTC) FILETIME=[34C1D230:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: change code to free pagetables from protection domains

The dma_ops_free_pagetable function can only free pagetables from
dma_ops domains. Change that to free pagetables of pure protection
domains.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f3dd4cd..bec34fd 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -584,12 +584,12 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 	iommu_area_reserve(dom->bitmap, start_page, pages);
 }
 
-static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
+static void free_pagetable(struct protection_domain *domain)
 {
 	int i, j;
 	u64 *p1, *p2, *p3;
 
-	p1 = dma_dom->domain.pt_root;
+	p1 = domain->pt_root;
 
 	if (!p1)
 		return;
@@ -610,6 +610,8 @@ static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
 	}
 
 	free_page((unsigned long)p1);
+
+	domain->pt_root = NULL;
 }
 
 /*
@@ -621,7 +623,7 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 	if (!dom)
 		return;
 
-	dma_ops_free_pagetable(dom);
+	free_pagetable(&dom->domain);
 
 	kfree(dom->pte_pages);
 
-- 
1.5.6.4


