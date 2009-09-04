Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbZIDJmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbZIDJmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbZIDJmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:10 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:46261 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352AbZIDJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:02 -0400
X-SpamScore: 5
X-BigFish: VPS5(zza332jzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXLT-03-O1K-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/14] x86/amd-iommu: Flush domains if address space size was increased
Date: Fri, 4 Sep 2009 11:40:44 +0200
Message-ID: <1252057252-32074-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0486 (UTC) FILETIME=[CCC2D5E0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thist patch introduces the update_domain function which
propagates the larger address space of a protection domain
to the device table and flushes all relevant DTEs and the
domain TLB.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 7fce4ef..97f3d09 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -235,6 +235,7 @@ struct protection_domain {
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
 	unsigned long flags;	/* flags to find out type of domain */
+	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	void *priv;		/* private data */
 };
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0fab1f1..5eab6a8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -63,6 +63,7 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned int pages);
 static u64 *fetch_pte(struct protection_domain *domain,
 		      unsigned long address);
+static void update_domain(struct protection_domain *domain);
 
 #ifndef BUS_NOTIFY_UNBOUND_DRIVER
 #define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
@@ -546,6 +547,8 @@ static int iommu_map_page(struct protection_domain *dom,
 
 	*pte = __pte;
 
+	update_domain(dom);
+
 	return 0;
 }
 
@@ -762,9 +765,13 @@ static int alloc_new_range(struct amd_iommu *iommu,
 		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
 	}
 
+	update_domain(&dma_dom->domain);
+
 	return 0;
 
 out_free:
+	update_domain(&dma_dom->domain);
+
 	free_page((unsigned long)dma_dom->aperture[index]->bitmap);
 
 	kfree(dma_dom->aperture[index]);
@@ -1294,6 +1301,29 @@ static int get_device_resources(struct device *dev,
 	return 1;
 }
 
+static void update_device_table(struct protection_domain *domain)
+{
+	int i;
+
+	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
+		if (amd_iommu_pd_table[i] != domain)
+			continue;
+		set_dte_entry(i, domain);
+	}
+}
+
+static void update_domain(struct protection_domain *domain)
+{
+	if (!domain->updated)
+		return;
+
+	update_device_table(domain);
+	flush_devices_by_domain(domain);
+	iommu_flush_domain(domain->id);
+
+	domain->updated = false;
+}
+
 /*
  * If the pte_page is not yet allocated this function is called
  */
@@ -1351,6 +1381,8 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 	} else
 		pte += IOMMU_PTE_L0_INDEX(address);
 
+	update_domain(&dom->domain);
+
 	return pte;
 }
 
-- 
1.6.3.3


