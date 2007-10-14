Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbXJNSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbXJNSml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762894AbXJNSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:41:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33759 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764051AbXJNSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:41:30 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ipg: endianness fixes
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, romieu@fr.zoreil.com
Message-Id: <E1Ih8P3-0004D6-8L@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:41:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


if your mask is host-endian, you should apply it after le64_to_cpu();
if it's little-endian - before.  Doing both (for the same mask and
little-endian value) is broken.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ipg.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
index 59898ce..6888723 100644
--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -754,7 +754,7 @@ static int init_rfdlist(struct net_device *dev)
 
 		if (sp->RxBuff[i]) {
 			pci_unmap_single(sp->pdev,
-				le64_to_cpu(rxfd->frag_info & ~IPG_RFI_FRAGLEN),
+				le64_to_cpu(rxfd->frag_info) & ~IPG_RFI_FRAGLEN,
 				sp->rx_buf_sz, PCI_DMA_FROMDEVICE);
 			IPG_DEV_KFREE_SKB(sp->RxBuff[i]);
 			sp->RxBuff[i] = NULL;
@@ -871,7 +871,7 @@ static void ipg_nic_txfree(struct net_device *dev)
 		/* Free the transmit buffer. */
 		if (skb) {
 			pci_unmap_single(sp->pdev,
-				le64_to_cpu(txfd->frag_info & ~IPG_TFI_FRAGLEN),
+				le64_to_cpu(txfd->frag_info) & ~IPG_TFI_FRAGLEN,
 				skb->len, PCI_DMA_TODEVICE);
 
 			IPG_DEV_KFREE_SKB(skb);
@@ -1413,10 +1413,10 @@ static int ipg_nic_rx(struct net_device *dev)
 			framelen = IPG_RXFRAG_SIZE;
 		}
 
-		if ((IPG_DROP_ON_RX_ETH_ERRORS && (le64_to_cpu(rxfd->rfs &
+		if ((IPG_DROP_ON_RX_ETH_ERRORS && (le64_to_cpu(rxfd->rfs) &
 		       (IPG_RFS_RXFIFOOVERRUN | IPG_RFS_RXRUNTFRAME |
 			IPG_RFS_RXALIGNMENTERROR | IPG_RFS_RXFCSERROR |
-			IPG_RFS_RXOVERSIZEDFRAME | IPG_RFS_RXLENGTHERROR))))) {
+			IPG_RFS_RXOVERSIZEDFRAME | IPG_RFS_RXLENGTHERROR)))) {
 
 			IPG_DEBUG_MSG("Rx error, RFS = %16.16lx\n",
 				      (unsigned long int) rxfd->rfs);
@@ -1425,27 +1425,27 @@ static int ipg_nic_rx(struct net_device *dev)
 			sp->stats.rx_errors++;
 
 			/* Increment detailed receive error statistics. */
-			if (le64_to_cpu(rxfd->rfs & IPG_RFS_RXFIFOOVERRUN)) {
+			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
 				IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
 				sp->stats.rx_fifo_errors++;
 			}
 
-			if (le64_to_cpu(rxfd->rfs & IPG_RFS_RXRUNTFRAME)) {
+			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
 				IPG_DEBUG_MSG("RX runt occured.\n");
 				sp->stats.rx_length_errors++;
 			}
 
-			if (le64_to_cpu(rxfd->rfs & IPG_RFS_RXOVERSIZEDFRAME)) ;
+			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXOVERSIZEDFRAME) ;
 			/* Do nothing, error count handled by a IPG
 			 * statistic register.
 			 */
 
-			if (le64_to_cpu(rxfd->rfs & IPG_RFS_RXALIGNMENTERROR)) {
+			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
 				IPG_DEBUG_MSG("RX alignment error occured.\n");
 				sp->stats.rx_frame_errors++;
 			}
 
-			if (le64_to_cpu(rxfd->rfs & IPG_RFS_RXFCSERROR)) ;
+			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFCSERROR) ;
 			/* Do nothing, error count handled by a IPG
 			 * statistic register.
 			 */
@@ -1455,10 +1455,10 @@ static int ipg_nic_rx(struct net_device *dev)
 			 * not pass it to higher layer processes.
 			 */
 			if (skb) {
-				u64 info = rxfd->frag_info;
+				__le64 info = rxfd->frag_info;
 
 				pci_unmap_single(sp->pdev,
-					le64_to_cpu(info & ~IPG_RFI_FRAGLEN),
+					le64_to_cpu(info) & ~IPG_RFI_FRAGLEN,
 					sp->rx_buf_sz, PCI_DMA_FROMDEVICE);
 
 				IPG_DEV_KFREE_SKB(skb);
@@ -1532,9 +1532,9 @@ static int ipg_nic_rx(struct net_device *dev)
 	if (!i)
 		sp->EmptyRFDListCount++;
 #endif
-	while ((le64_to_cpu(rxfd->rfs & IPG_RFS_RFDDONE)) &&
-	       !((le64_to_cpu(rxfd->rfs & IPG_RFS_FRAMESTART)) &&
-		 (le64_to_cpu(rxfd->rfs & IPG_RFS_FRAMEEND)))) {
+	while ((le64_to_cpu(rxfd->rfs) & IPG_RFS_RFDDONE) &&
+	       !((le64_to_cpu(rxfd->rfs) & IPG_RFS_FRAMESTART) &&
+		 (le64_to_cpu(rxfd->rfs) & IPG_RFS_FRAMEEND))) {
 		unsigned int entry = curr++ % IPG_RFDLIST_LENGTH;
 
 		rxfd = sp->rxd + entry;
@@ -1552,7 +1552,7 @@ static int ipg_nic_rx(struct net_device *dev)
 		 */
 		if (sp->RxBuff[entry]) {
 			pci_unmap_single(sp->pdev,
-				le64_to_cpu(rxfd->frag_info & ~IPG_RFI_FRAGLEN),
+				le64_to_cpu(rxfd->frag_info) & ~IPG_RFI_FRAGLEN,
 				sp->rx_buf_sz, PCI_DMA_FROMDEVICE);
 			IPG_DEV_KFREE_SKB(sp->RxBuff[entry]);
 		}
@@ -1730,7 +1730,7 @@ static void ipg_rx_clear(struct ipg_nic_private *sp)
 			IPG_DEV_KFREE_SKB(sp->RxBuff[i]);
 			sp->RxBuff[i] = NULL;
 			pci_unmap_single(sp->pdev,
-				le64_to_cpu(rxfd->frag_info & ~IPG_RFI_FRAGLEN),
+				le64_to_cpu(rxfd->frag_info) & ~IPG_RFI_FRAGLEN,
 				sp->rx_buf_sz, PCI_DMA_FROMDEVICE);
 		}
 	}
@@ -1745,7 +1745,7 @@ static void ipg_tx_clear(struct ipg_nic_private *sp)
 			struct ipg_tx *txfd = sp->txd + i;
 
 			pci_unmap_single(sp->pdev,
-				le64_to_cpu(txfd->frag_info & ~IPG_TFI_FRAGLEN),
+				le64_to_cpu(txfd->frag_info) & ~IPG_TFI_FRAGLEN,
 				sp->TxBuff[i]->len, PCI_DMA_TODEVICE);
 
 			IPG_DEV_KFREE_SKB(sp->TxBuff[i]);
-- 
1.5.3.GIT

