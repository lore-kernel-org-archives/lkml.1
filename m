Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYIHJzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYIHJzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYIHJzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:55:19 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54243 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYIHJzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:55:18 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tony.luck@intel.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] swiotlb: use map_single instead of swiotlb_map_single in swiotlb_alloc_coherent
Date: Mon,  8 Sep 2008 18:53:48 +0900
Message-Id: <1220867630-1995-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220867630-1995-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always need swiotlb memory here so address_needs_mapping and
swiotlb_force testings are irrelevant. map_single should be used here
instead of swiotlb_map_single.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 3066ffe..2fb485d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -483,12 +483,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		dma_addr_t handle;
-		handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
-		if (swiotlb_dma_mapping_error(hwdev, handle))
+		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
+		if (!ret)
 			return NULL;
-
-		ret = bus_to_virt(handle);
 	}
 
 	memset(ret, 0, size);
-- 
1.5.5.GIT

