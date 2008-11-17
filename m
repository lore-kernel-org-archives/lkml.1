Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYKQLwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYKQLwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 06:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYKQLwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 06:52:37 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27783 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYKQLwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:52:36 -0500
X-IronPort-AV: E=Sophos;i="4.33,618,1220241600"; 
   d="scan'208";a="28354012"
Subject: Re: [PATCH 04 of 38] swiotlb: move some definitions to header
From: Ian Campbell <Ian.Campbell@citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org
In-Reply-To: <20081117120246K.fujita.tomonori@lab.ntt.co.jp>
References: <patchbomb.1226603398@abulafia.goop.org>
	 <3d0746ce3c320ac694db.1226603402@abulafia.goop.org>
	 <20081117120246K.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 17 Nov 2008 11:52:28 +0000
Message-Id: <1226922748.18916.28.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2008 11:52:35.0349 (UTC) FILETIME=[FB3D0450:01C948AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 12:48 +0900, FUJITA Tomonori wrote:
> Why do we need to export IO_TLB_SEGSIZE and IO_TLB_SHIFT to everyone
> in include/linux?

A subsequent Xen patch needs to make use of them, although I can't see
it in the patchset Jeremy posted so here it is (not fully baked yet)

Subject: xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER

From: Ian Campbell <ian.campbell@citrix.com>

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    7 +------
 drivers/pci/xen-iommu.c          |   30 ++++++++++++++++++++----------
 2 files changed, 21 insertions(+), 16 deletions(-)

===================================================================
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -28,12 +28,7 @@
 
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
 
 static dma_addr_t
===================================================================
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -6,6 +6,7 @@
 #include <linux/version.h>
 #include <linux/scatterlist.h>
 #include <linux/bio.h>
+#include <linux/swiotlb.h>
 #include <linux/io.h>
 #include <linux/bug.h>
 
@@ -43,19 +44,27 @@
 	unsigned long	*bitmap;
 };
 
+static int max_dma_bits = 32;
+
 void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
-	unsigned order = get_order(size);
+	int i, rc;
+	int dma_bits;
 
-	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu order=%u\n",
-		buf, size, order);
+	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu\n",
+		buf, size);
 
-	if (WARN_ON(size != (PAGE_SIZE << order)))
-		return;
-
-	if (xen_create_contiguous_region((unsigned long)buf,
-					 order, 0xffffffff))
-		printk(KERN_ERR "xen_create_contiguous_region failed\n");
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
@@ -117,7 +126,8 @@
 	if (check_pages_physically_contiguous(pfn, offset, size))
 		return 0;
 
-	printk("range_straddles_page_boundary: p=%Lx size=%d pfn=%lx\n",
+	printk(KERN_WARNING "range_straddles_page_boundary: "
+	       "p=%Lx size=%zd pfn=%lx\n",
 		p, size, pfn);
 	return 1;
 }


