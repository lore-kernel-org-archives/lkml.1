Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab0BEE7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:59:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:44887 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382Ab0BEE7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:59:10 -0500
Date: Fri, 5 Feb 2010 13:57:42 +0900
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, rolandd@cisco.com, eli@mellanox.co.il,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mlx4: replace the dma_sync_single_range_for_cpu/device API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100205135626G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 05 Feb 2010 13:57:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are only two users of the dma_sync_single_range_for_cpu/device
API in mainline (mlx4 and ssb). The
dma_sync_single_range_for_cpu/device API has never been documented and
the dma_sync_single_for_cpu/device API also support a partial sync.

This converts mlx4 to use the dma_sync_single_for_cpu/device API
(preparations for the removal of the dma_sync_single_range_for_cpu/device API).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/net/mlx4/en_rx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 829b9ec..6439464 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -508,11 +508,11 @@ static struct sk_buff *mlx4_en_rx_skb(struct mlx4_en_priv *priv,
 		/* We are copying all relevant data to the skb - temporarily
 		 * synch buffers for the copy */
 		dma = be64_to_cpu(rx_desc->data[0].addr);
-		dma_sync_single_range_for_cpu(&mdev->pdev->dev, dma, 0,
-					      length, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&mdev->pdev->dev, dma, length,
+					DMA_FROM_DEVICE);
 		skb_copy_to_linear_data(skb, va, length);
-		dma_sync_single_range_for_device(&mdev->pdev->dev, dma, 0,
-						 length, DMA_FROM_DEVICE);
+		dma_sync_single_for_device(&mdev->pdev->dev, dma, length,
+					   DMA_FROM_DEVICE);
 		skb->tail += length;
 	} else {
 
-- 
1.5.6.5

