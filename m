Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXJYXIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXJYXIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXJYXId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:08:33 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:43363 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXJYXIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:08:32 -0400
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, tomof@acm.org
Subject: [PATCH] x86: fix pci-gart failure handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071026080814Z.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 26 Oct 2007 08:08:14 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_map_sg doesn't initialize sg->dma_address/length to zero
anymore. Some low level drivers reuse sg lists without initializing so
IOMMUs might get non-zero dma_address/length. If map_sg fails, we need
pass the number of the mapped entries to gart_unmap_sg.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c56e9ee..6e7f826 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -436,7 +436,7 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 error:
 	flush_gart();
-	gart_unmap_sg(dev, sg, nents, dir);
+	gart_unmap_sg(dev, sg, out, dir);
 	/* When it was forced or merged try again in a dumb way */
 	if (force_iommu || iommu_merge) {
 		out = dma_map_sg_nonforce(dev, sg, nents, dir);
-- 
1.5.2.4

