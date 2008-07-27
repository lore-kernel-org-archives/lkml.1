Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYG0QOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYG0QOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYG0QO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:14:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50744 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYG0QO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:14:28 -0400
Date: Mon, 28 Jul 2008 02:14:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] powerpc/ibmveth: fix multiple errors with dma_mapping_error
 conversion
Message-Id: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addition of an argument to dma_mapping_error() in commit
8d8bb39b9eba32dd70e87fd5ad5c5dd4ba118e06 "dma-mapping: add the device
argument to dma_mapping_error()" left a bit of fallout:

drivers/net/ibmveth.c:263: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:264: error: expected ')' before 'goto'
drivers/net/ibmveth.c:284: error: expected expression before '}' token
drivers/net/ibmveth.c:297: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:298: error: expected ')' before 'dma_unmap_single'
drivers/net/ibmveth.c:306: error: expected expression before '}' token
drivers/net/ibmveth.c:491: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:927: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:927: error: expected ')' before '{' token
drivers/net/ibmveth.c:974: error: expected expression before '}' token
drivers/net/ibmveth.c:914: error: label 'out' used but not defined m

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ibmveth.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Compiler tested for ppc64_defconfig.

diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 91ec9fd..a03fe1f 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -260,7 +260,7 @@ static void ibmveth_replenish_buffer_pool(struct ibmveth_adapter *adapter, struc
 		dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
 				pool->buff_size, DMA_FROM_DEVICE);
 
-		if (dma_mapping_error((&adapter->vdev->dev, dma_addr))
+		if (dma_mapping_error(&adapter->vdev->dev, dma_addr))
 			goto failure;
 
 		pool->free_map[free_index] = IBM_VETH_INVALID_MAP;
@@ -294,7 +294,7 @@ failure:
 		pool->consumer_index = pool->size - 1;
 	else
 		pool->consumer_index--;
-	if (!dma_mapping_error((&adapter->vdev->dev, dma_addr))
+	if (!dma_mapping_error(&adapter->vdev->dev, dma_addr))
 		dma_unmap_single(&adapter->vdev->dev,
 		                 pool->dma_addr[index], pool->buff_size,
 		                 DMA_FROM_DEVICE);
@@ -488,7 +488,7 @@ static void ibmveth_cleanup(struct ibmveth_adapter *adapter)
 						 &adapter->rx_buff_pool[i]);
 
 	if (adapter->bounce_buffer != NULL) {
-		if (!dma_mapping_error(adapter->bounce_buffer_dma)) {
+		if (!dma_mapping_error(dev, adapter->bounce_buffer_dma)) {
 			dma_unmap_single(&adapter->vdev->dev,
 					adapter->bounce_buffer_dma,
 					adapter->netdev->mtu + IBMVETH_BUFF_OH,
@@ -924,7 +924,7 @@ static int ibmveth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		buf[1] = 0;
 	}
 
-	if (dma_mapping_error((&adapter->vdev->dev, data_dma_addr)) {
+	if (dma_mapping_error(&adapter->vdev->dev, data_dma_addr)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
 			ibmveth_error_printk("tx: unable to map xmit buffer\n");
 		skb_copy_from_linear_data(skb, adapter->bounce_buffer,
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
