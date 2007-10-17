Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbXJQIt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbXJQIt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbXJQItp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:49:45 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:56517 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbXJQIto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:49:44 -0400
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, tony.luck@intel.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org
Subject: [PATCH] IA64: iommu uses sg_next with an invalid sg element
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017174927N.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 17 Oct 2007 17:49:27 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sg list elements might not be continuous.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/common/sba_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 4338f41..3c95f41 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1179,7 +1179,6 @@ sba_fill_pdir(
 	u64 *pdirp = NULL;
 	unsigned long dma_offset = 0;
 
-	dma_sg--;
 	while (nents-- > 0) {
 		int     cnt = startsg->dma_length;
 		startsg->dma_length = 0;
@@ -1201,7 +1200,8 @@ sba_fill_pdir(
 			u32 pide = startsg->dma_address & ~PIDE_FLAG;
 			dma_offset = (unsigned long) pide & ~iovp_mask;
 			startsg->dma_address = 0;
-			dma_sg = sg_next(dma_sg);
+			if (n_mappings)
+				dma_sg = sg_next(dma_sg);
 			dma_sg->dma_address = pide | ioc->ibase;
 			pdirp = &(ioc->pdir_base[pide >> iovp_shift]);
 			n_mappings++;
-- 
1.5.2.4

