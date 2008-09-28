Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYI1PHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYI1PHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYI1PG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:06:58 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:54355 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYI1PG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:06:58 -0400
Date: Mon, 29 Sep 2008 00:06:36 +0900
To: joerg.roedel@amd.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] AMD IOMMU: use iommu_device_max_index
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080929000525E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against tip/iommu.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] AMD IOMMU: use iommu_device_max_index

AMD IOMMU can use iommu_device_max_index() instead of the homegrown
function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/amd_iommu.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2028810..34e4d11 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -480,10 +480,6 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  * efficient allocator.
  *
  ****************************************************************************/
-static unsigned long dma_mask_to_pages(unsigned long mask)
-{
-	return PAGE_ALIGN(mask) >> PAGE_SHIFT;
-}
 
 /*
  * The address allocator core function.
@@ -496,14 +492,14 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     unsigned long align_mask,
 					     u64 dma_mask)
 {
-	unsigned long limit = dma_mask_to_pages(dma_mask);
+	unsigned long limit;
 	unsigned long address;
-	unsigned long size = dom->aperture_size >> PAGE_SHIFT;
 	unsigned long boundary_size;
 
 	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
 			PAGE_SIZE) >> PAGE_SHIFT;
-	limit = limit < size ? limit : size;
+	limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
+				       dma_mask >> PAGE_SHIFT);
 
 	if (dom->next_bit >= limit) {
 		dom->next_bit = 0;
-- 
1.5.4.2

