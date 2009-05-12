Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZEMDLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZEMDLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZEMDGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:15 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36218
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755439AbZEMDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/10] xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
Date: Tue, 12 May 2009 14:50:43 -0700
Message-Id: <1242165051-6636-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Don't attempt to make larger memory ranges than Xen can cope with
contiguous.

[ Impact: bugfix ]
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 8c034b8..ee7b9fb 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/scatterlist.h>
+#include <linux/swiotlb.h>
 #include <linux/io.h>
 #include <linux/bug.h>
 
@@ -36,20 +37,29 @@ do {							\
 } while (0)
 
 
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
-					 order, DMA_BIT_MASK(32)))
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
+
 static inline int address_needs_mapping(struct device *hwdev,
 						dma_addr_t addr)
 {
-- 
1.6.0.6

