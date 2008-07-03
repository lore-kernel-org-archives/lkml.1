Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYGCIXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYGCIXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYGCIQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:16:37 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:43179 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760326AbYGCHGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:06:30 -0400
Date: Thu, 3 Jul 2008 16:06:28 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, xen-ia64-devel@lists.xensource.com
Subject: [PATCH] xen/netfront: Avoid unaligned accesses to IP datagrams.
Message-ID: <20080703070628.GA15683%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align ip header to a 16 byte boundary.
This patch eliminates noisy warnings on IA64.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/net/xen-netfront.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 44aed80..2724688 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -239,11 +239,14 @@ static void xennet_alloc_rx_buffers(struct net_device *dev)
 	 */
 	batch_target = np->rx_target - (req_prod - np->rx.rsp_cons);
 	for (i = skb_queue_len(&np->rx_batch); i < batch_target; i++) {
-		skb = __netdev_alloc_skb(dev, RX_COPY_THRESHOLD,
+		skb = __netdev_alloc_skb(dev, RX_COPY_THRESHOLD + NET_IP_ALIGN,
 					 GFP_ATOMIC | __GFP_NOWARN);
 		if (unlikely(!skb))
 			goto no_skb;
 
+		/* Align ip header to a 16 bytes boundary */
+		skb_reserve(skb, NET_IP_ALIGN);
+
 		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
 		if (!page) {
 			kfree_skb(skb);
-- 
1.5.3


-- 
yamahata
