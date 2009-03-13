Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbZCMRDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbZCMRDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbZCMRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:05 -0400
Received: from gw.goop.org ([64.81.55.164]:57409 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759038AbZCMRBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/27] xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
Date: Fri, 13 Mar 2009 09:59:56 -0700
Message-Id: <1236963612-14287-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Don't attempt to make larger memory ranges than Xen can cope with
contiguous.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb.c |    7 +------
 drivers/pci/xen-iommu.c       |   27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index a7b9410..298f01d 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -28,12 +28,7 @@ void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 
 void *swiotlb_alloc(unsigned order, unsigned long nslabs)
 {
-	void *ret = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-
-	if (ret && xen_pv_domain())
-		xen_swiotlb_fixup(ret, 1u << order, nslabs);
-
-	return ret;
+	BUG();
 }
 
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index dc0da76..d546698 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/scatterlist.h>
+#include <linux/swiotlb.h>
 #include <linux/io.h>
 #include <linux/bug.h>
 
@@ -43,19 +44,27 @@ struct dma_coherent_mem {
 	unsigned long	*bitmap;
 };
 
+static int max_dma_bits = 32;
+
 void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
-	unsigned order = get_order(size);
-
-	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu order=%u\n",
-		buf, size, order);
-
-	if (WARN_ON(size != (PAGE_SIZE << order)))
-		return;
-
-	if (xen_create_contiguous_region((unsigned long)buf,
-					 order, 0xffffffff))
-		printk(KERN_ERR "xen_create_contiguous_region failed\n");
+	int i, rc;
+	int dma_bits;
+
+	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu\n",
+		buf, size);
+
+	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
+	for (i = 0; i < nslabs; i += IO_TLB_SEGSIZE) {
+		do {
+			rc = xen_create_contiguous_region(
+				(unsigned long)buf + (i << IO_TLB_SHIFT),
+				get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT),
+				dma_bits);
+		} while (rc && dma_bits++ < max_dma_bits);
+		if (rc)
+			panic(KERN_ERR "xen_create_contiguous_region failed\n");
+	}
 }
 
 static inline int address_needs_mapping(struct device *hwdev,
-- 
1.6.0.6

