Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYBPGER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYBPGER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYBPGEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:04:06 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49894 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYBPGEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:04:04 -0500
Date: Sat, 16 Feb 2008 15:03:43 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20080211.214036.154985035.davem@davemloft.net>
References: <20080206.160147.25411834.davem@davemloft.net>
	<20080207103801T.fujita.tomonori@lab.ntt.co.jp>
	<20080211.214036.154985035.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080216150341A.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response,

On Mon, 11 Feb 2008 21:40:36 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 07 Feb 2008 10:38:01 +0900
> 
> > Great, thanks! SPARC IOMMUs use bitmap for the free area management
> > like POWER IOMMUs so it could use lib/iommu-helper as POWER does.
> 
> Please look at Linus's current tree, I believe I have things
> in a working state, and the DMA mask portions should be easier
> to add now.

Thanks! It looks great.

iommu->page_table_map_base is on IO_PAGE_SIZE boundary? If so, the
following patch works, I think (sorry, it's only compile tested
again).

Thanks,

=
>From 91af83802c30d071f98444846e85310a8d58ab3d Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 16 Feb 2008 14:29:02 +0900
Subject: [PATCH] sparc64: make IOMMU code respect the segment boundary limits

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc64/kernel/iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index d3276eb..ffefbf7 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -134,7 +134,8 @@ unsigned long iommu_range_alloc(struct device *dev,
 	else
 		boundary_size = ALIGN(1UL << 32, 1 << IO_PAGE_SHIFT);
 
-	n = iommu_area_alloc(arena->map, limit, start, npages, 0,
+	n = iommu_area_alloc(arena->map, limit, start, npages,
+			     iommu->page_table_map_base >> IO_PAGE_SHIFT,
 			     boundary_size >> IO_PAGE_SHIFT, 0);
 	if (n == -1) {
 		if (likely(pass < 1)) {
-- 
1.5.3.4


