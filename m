Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbYFZTjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbYFZTjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760520AbYFZT3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:19 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14203 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761299AbYFZT3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:13 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334RU-03-2Z4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/34] AMD IOMMU: add functions to initialize unity mappings
Date: Thu, 26 Jun 2008 21:27:56 +0200
Message-ID: <1214508490-29683-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0924 (UTC) FILETIME=[C59F5540:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions which will initialize the unity mappings in the
device page tables.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  122 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a24ee4a..1d70f5e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -37,6 +37,9 @@ struct command {
 	u32 data[4];
 };
 
+static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
+			     struct unity_map_entry *e);
+
 static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
 {
 	u32 tail, head;
@@ -144,3 +147,122 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 	return 0;
 }
 
+static int iommu_map(struct protection_domain *dom,
+		     unsigned long bus_addr,
+		     unsigned long phys_addr,
+		     int prot)
+{
+	u64 __pte, *pte, *page;
+
+	bus_addr  = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(bus_addr);
+
+	/* only support 512GB address spaces for now */
+	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
+		return -EINVAL;
+
+	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(bus_addr)];
+
+	if (!IOMMU_PTE_PRESENT(*pte)) {
+		page = (u64 *)get_zeroed_page(GFP_KERNEL);
+		if (!page)
+			return -ENOMEM;
+		*pte = IOMMU_L2_PDE(virt_to_phys(page));
+	}
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
+
+	if (!IOMMU_PTE_PRESENT(*pte)) {
+		page = (u64 *)get_zeroed_page(GFP_KERNEL);
+		if (!page)
+			return -ENOMEM;
+		*pte = IOMMU_L1_PDE(virt_to_phys(page));
+	}
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L0_INDEX(bus_addr)];
+
+	if (IOMMU_PTE_PRESENT(*pte))
+		return -EBUSY;
+
+	__pte = phys_addr | IOMMU_PTE_P;
+	if (prot & IOMMU_PROT_IR)
+		__pte |= IOMMU_PTE_IR;
+	if (prot & IOMMU_PROT_IW)
+		__pte |= IOMMU_PTE_IW;
+
+	*pte = __pte;
+
+	return 0;
+}
+
+static int iommu_for_unity_map(struct amd_iommu *iommu,
+			       struct unity_map_entry *entry)
+{
+	u16 bdf, i;
+
+	for (i = entry->devid_start; i <= entry->devid_end; ++i) {
+		bdf = amd_iommu_alias_table[i];
+		if (amd_iommu_rlookup_table[bdf] == iommu)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int iommu_init_unity_mappings(struct amd_iommu *iommu)
+{
+	struct unity_map_entry *entry;
+	int ret;
+
+	list_for_each_entry(entry, &amd_iommu_unity_map, list) {
+		if (!iommu_for_unity_map(iommu, entry))
+			continue;
+		ret = dma_ops_unity_map(iommu->default_dom, entry);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
+			     struct unity_map_entry *e)
+{
+	u64 addr;
+	int ret;
+
+	for (addr = e->address_start; addr < e->address_end;
+	     addr += PAGE_SIZE) {
+		ret = iommu_map(&dma_dom->domain, addr, addr, e->prot);
+		if (ret)
+			return ret;
+		/*
+		 * if unity mapping is in aperture range mark the page
+		 * as allocated in the aperture
+		 */
+		if (addr < dma_dom->aperture_size)
+			__set_bit(addr >> PAGE_SHIFT, dma_dom->bitmap);
+	}
+
+	return 0;
+}
+
+static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
+					  u16 devid)
+{
+	struct unity_map_entry *e;
+	int ret;
+
+	list_for_each_entry(e, &amd_iommu_unity_map, list) {
+		if (!(devid >= e->devid_start && devid <= e->devid_end))
+			continue;
+		ret = dma_ops_unity_map(dma_dom, e);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
-- 
1.5.3.7


