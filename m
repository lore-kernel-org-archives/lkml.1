Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZE2Ipn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZE2Ipn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZE2IoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:44:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56015 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830AbZE2IoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:44:12 -0400
X-IronPort-AV: E=Sophos;i="4.41,270,1241409600"; 
   d="scan'208";a="4461768"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Olaf Kirch <okir@suse.de>,
       Greg KH <gregkh@suse.de>, Tony Luck <tony.luck@intel.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>, <x86@kernel.org>,
       <linux-ia64@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: [PATCH 6/9] swiotlb: use dma_to_phys and phys_to_dma
Date: Fri, 29 May 2009 09:44:00 +0100
Message-ID: <1243586643-5554-7-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These new architecture-specific interfaces subsume the existing __weak
function hooks.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
Cc: linux-ia64@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
---
 include/linux/swiotlb.h |    5 -----
 lib/swiotlb.c           |   18 ++++--------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cb1a663..954feec 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -27,11 +27,6 @@ swiotlb_init(void);
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
-extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
-				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
-				       dma_addr_t address);
-
 extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
 
 extern void
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bffe6d7..baa1991 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -124,25 +124,15 @@ void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-
-phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	return baddr;
-}
-
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
 {
-	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
+	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
 void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
-	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
+	return phys_to_virt(dma_to_phys(hwdev, address));
 }
 
 int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
@@ -646,7 +636,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
+	dma_addr_t dev_addr = phys_to_dma(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -817,7 +807,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
+		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
 
 		if (range_needs_mapping(paddr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
-- 
1.5.6.5

