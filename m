Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYLIOX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYLIOX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYLIORE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:04 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40370 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYLIOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:30 -0500
X-BigFish: VPS20(z1857r1039ozzzzzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KBM4Z5-04-AEK-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/21] AMD IOMMU: make dma_ops_free_pagetable generic
Date: Tue, 9 Dec 2008 15:16:01 +0100
Message-ID: <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0817 (UTC) FILETIME=[B4504F10:01C95A08]
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
index e96a2f3..85a62e9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -585,12 +585,12 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
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
@@ -611,6 +611,8 @@ static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
 	}
 
 	free_page((unsigned long)p1);
+
+	domain->pt_root = NULL;
 }
 
 /*
@@ -622,7 +624,7 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 	if (!dom)
 		return;
 
-	dma_ops_free_pagetable(dom);
+	free_pagetable(&dom->domain);
 
 	kfree(dom->pte_pages);
 
-- 
1.5.6.4


