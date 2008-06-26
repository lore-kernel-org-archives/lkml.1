Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbYFZTeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbYFZTeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760851AbYFZT2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12895 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760769AbYFZT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:48 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334R4-03-2YG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/34] AMD IOMMU: add domain allocation and deallocation functions
Date: Thu, 26 Jun 2008 21:27:58 +0200
Message-ID: <1214508490-29683-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0980 (UTC) FILETIME=[C5A7E0C0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to allocate and free protection domains for the
IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  147 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 69d8d02..c43d15d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -314,3 +314,150 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 	iommu_area_free(dom->bitmap, address, pages);
 }
 
+static u16 domain_id_alloc(void)
+{
+	unsigned long flags;
+	int id;
+
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	id = find_first_zero_bit(amd_iommu_pd_alloc_bitmap, MAX_DOMAIN_ID);
+	BUG_ON(id == 0);
+	if (id > 0 && id < MAX_DOMAIN_ID)
+		__set_bit(id, amd_iommu_pd_alloc_bitmap);
+	else
+		id = 0;
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	return id;
+}
+
+static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
+				      unsigned long start_page,
+				      unsigned int pages)
+{
+	unsigned int last_page = dom->aperture_size >> PAGE_SHIFT;
+
+	if (start_page + pages > last_page)
+		pages = last_page - start_page;
+
+	set_bit_string(dom->bitmap, start_page, pages);
+}
+
+static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
+{
+	int i, j;
+	u64 *p1, *p2, *p3;
+
+	p1 = dma_dom->domain.pt_root;
+
+	if (!p1)
+		return;
+
+	for (i = 0; i < 512; ++i) {
+		if (!IOMMU_PTE_PRESENT(p1[i]))
+			continue;
+
+		p2 = IOMMU_PTE_PAGE(p1[i]);
+		for (j = 0; j < 512; ++i) {
+			if (!IOMMU_PTE_PRESENT(p2[j]))
+				continue;
+			p3 = IOMMU_PTE_PAGE(p2[j]);
+			free_page((unsigned long)p3);
+		}
+
+		free_page((unsigned long)p2);
+	}
+
+	free_page((unsigned long)p1);
+}
+
+static void dma_ops_domain_free(struct dma_ops_domain *dom)
+{
+	if (!dom)
+		return;
+
+	dma_ops_free_pagetable(dom);
+
+	kfree(dom->pte_pages);
+
+	kfree(dom->bitmap);
+
+	kfree(dom);
+}
+
+static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
+						   unsigned order)
+{
+	struct dma_ops_domain *dma_dom;
+	unsigned i, num_pte_pages;
+	u64 *l2_pde;
+	u64 address;
+
+	/*
+	 * Currently the DMA aperture must be between 32 MB and 1GB in size
+	 */
+	if ((order < 25) || (order > 30))
+		return NULL;
+
+	dma_dom = kzalloc(sizeof(struct dma_ops_domain), GFP_KERNEL);
+	if (!dma_dom)
+		return NULL;
+
+	spin_lock_init(&dma_dom->domain.lock);
+
+	dma_dom->domain.id = domain_id_alloc();
+	if (dma_dom->domain.id == 0)
+		goto free_dma_dom;
+	dma_dom->domain.mode = PAGE_MODE_3_LEVEL;
+	dma_dom->domain.pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+	dma_dom->domain.priv = dma_dom;
+	if (!dma_dom->domain.pt_root)
+		goto free_dma_dom;
+	dma_dom->aperture_size = (1ULL << order);
+	dma_dom->bitmap = kzalloc(dma_dom->aperture_size / (PAGE_SIZE * 8),
+				  GFP_KERNEL);
+	if (!dma_dom->bitmap)
+		goto free_dma_dom;
+	/*
+	 * mark the first page as allocated so we never return 0 as
+	 * a valid dma-address. So we can use 0 as error value
+	 */
+	dma_dom->bitmap[0] = 1;
+	dma_dom->next_bit = 0;
+
+	if (iommu->exclusion_start &&
+	    iommu->exclusion_start < dma_dom->aperture_size) {
+		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
+		int pages = to_pages(iommu->exclusion_start,
+				iommu->exclusion_length);
+		dma_ops_reserve_addresses(dma_dom, startpage, pages);
+	}
+
+	num_pte_pages = dma_dom->aperture_size / (PAGE_SIZE * 512);
+	dma_dom->pte_pages = kzalloc(num_pte_pages * sizeof(void *),
+			GFP_KERNEL);
+	if (!dma_dom->pte_pages)
+		goto free_dma_dom;
+
+	l2_pde = (u64 *)get_zeroed_page(GFP_KERNEL);
+	if (l2_pde == NULL)
+		goto free_dma_dom;
+
+	dma_dom->domain.pt_root[0] = IOMMU_L2_PDE(virt_to_phys(l2_pde));
+
+	for (i = 0; i < num_pte_pages; ++i) {
+		dma_dom->pte_pages[i] = (u64 *)get_zeroed_page(GFP_KERNEL);
+		if (!dma_dom->pte_pages[i])
+			goto free_dma_dom;
+		address = virt_to_phys(dma_dom->pte_pages[i]);
+		l2_pde[i] = IOMMU_L1_PDE(address);
+	}
+
+	return dma_dom;
+
+free_dma_dom:
+	dma_ops_domain_free(dma_dom);
+
+	return NULL;
+}
+
-- 
1.5.3.7


