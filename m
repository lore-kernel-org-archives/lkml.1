Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZFWGUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZFWGUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZFWGTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:19:46 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:63377 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZFWGTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:19:44 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 02:19:44 EDT
X-IronPort-AV: E=Sophos;i="4.42,274,1243814400"; 
   d="scan'208";a="38044261"
From: Roland Dreier <rdreier@cisco.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: linux-next: origin tree build warning
References: <20090622110113.7cd89382.sfr@canb.auug.org.au>
	<20090622121054K.fujita.tomonori@lab.ntt.co.jp>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 22 Jun 2009 23:10:17 -0700
In-Reply-To: <20090622121054K.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Mon, 22 Jun 2009 12:11:12 +0900")
Message-ID: <adatz27pjjq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2009 06:10:20.0213 (UTC) FILETIME=[49656E50:01C9F3C9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I queued up:

commit 99987bea474ceca8ec6fb05f81d7d188634cdffd
Author: Roland Dreier <rolandd@cisco.com>
Date:   Mon Jun 22 23:04:13 2009 -0700

    IB/mthca: Replace dma_sync_single() use with proper functions
    
    dma_sync_single() is deprecated now, and the use in mthca is wrong:
    there should be a dma_sync_single_for_cpu() before touching the memory
    from the CPU, and a dma_sync_single_for_device() afterwards.  Fix
    this, prompted by a kick in the pants from a patch from FUJITA
    Tomonori <fujita.tomonori@lab.ntt.co.jp>.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index d606edf..065b208 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -352,10 +352,14 @@ static void mthca_arbel_write_mtt_seg(struct mthca_dev *dev,
 
 	BUG_ON(!mtts);
 
+	dma_sync_single_for_cpu(&dev->pdev->dev, dma_handle,
+				list_len * sizeof (u64), DMA_TO_DEVICE);
+
 	for (i = 0; i < list_len; ++i)
 		mtts[i] = cpu_to_be64(buffer_list[i] | MTHCA_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, dma_handle, list_len * sizeof (u64), DMA_TO_DEVICE);
+	dma_sync_single_for_device(&dev->pdev->dev, dma_handle,
+				   list_len * sizeof (u64), DMA_TO_DEVICE);
 }
 
 int mthca_write_mtt(struct mthca_dev *dev, struct mthca_mtt *mtt,
@@ -803,12 +807,15 @@ int mthca_arbel_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 
 	wmb();
 
+	dma_sync_single_for_cpu(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
+				list_len * sizeof(u64), DMA_TO_DEVICE);
+
 	for (i = 0; i < list_len; ++i)
 		fmr->mem.arbel.mtts[i] = cpu_to_be64(page_list[i] |
 						     MTHCA_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
-			list_len * sizeof(u64), DMA_TO_DEVICE);
+	dma_sync_single_for_device(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
+				   list_len * sizeof(u64), DMA_TO_DEVICE);
 
 	fmr->mem.arbel.mpt->key    = cpu_to_be32(key);
 	fmr->mem.arbel.mpt->lkey   = cpu_to_be32(key);
