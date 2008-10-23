Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYJWJm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYJWJm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYJWJmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:42:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:52260 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYJWJmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:42:17 -0400
Date: Thu, 23 Oct 2008 18:42:03 +0900
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, tiwai@suse.de
Subject: [PATCH] swiotlb: remove panic for alloc_coherent failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081023184032F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_alloc_coherent calls panic() when allocated swiotlb pages is
not fit for a device's dma mask. However, alloc_coherent failure is
not a disaster at all. AFAIK, none of other x86 and IA64 IOMMU
implementations don't crash in case of alloc_coherent failure.

There are some drivers that don't check alloc_coherent failure but not
many (about ten and I've already started to fix some of
them). alloc_coherent returns NULL in case of failure so it's likely
that these guilty drivers crash immediately. So swiotlb doesn't need
to call panic() just for them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f8eebd4..78330c3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -497,8 +497,10 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)*hwdev->dma_mask,
 		       (unsigned long long)dev_addr);
-		panic("swiotlb_alloc_coherent: allocated memory is out of "
-		      "range for device");
+
+		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
+		unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		return NULL;
 	}
 	*dma_handle = dev_addr;
 	return ret;
-- 
1.5.5.GIT

