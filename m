Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZEMDI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZEMDI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZEMDGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:03 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36219
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755519AbZEMDF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:05:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/10] xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
Date: Tue, 12 May 2009 14:50:48 -0700
Message-Id: <1242165051-6636-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Clarify why we don't care about the kernel's pseudo-phys restrictions,
so long as the underlying pages are in the right place.

[ Impact: cleanup ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index bc64397..d09ff91 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -203,15 +203,17 @@ static void *xen_alloc_coherent(struct device *dev, size_t size,
 	unsigned long vstart;
 	u64 mask;
 
-	/* ignore region specifiers */
+	/*
+	 * Ignore region specifiers - the kernel's ideas of
+	 * pseudo-phys memory layout has nothing to do with the
+	 * machine physical layout.  We can't allocate highmem
+	 * because we can't return a pointer to it.
+	 */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
 		return ret;
 
-	if (dev == NULL || (dev->coherent_dma_mask < DMA_BIT_MASK(32)))
-		gfp |= GFP_DMA;
-
 	vstart = __get_free_pages(gfp, order);
 	ret = (void *)vstart;
 
-- 
1.6.0.6

