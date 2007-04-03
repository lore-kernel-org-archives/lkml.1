Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXDCCmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXDCCmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 22:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXDCCmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 22:42:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61125 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXDCCmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 22:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=H3obaniIz8yVtizFQ9XWLux7thXickCKrIl9jOu7xfOqFcU3C95dDs6CYd13iSEvGqr4ABaxEm3Tr+7XwMoxvJ7TVw4cr1/5OvPf19u0LU7IQ7PriQ7UYG0SV9Pb8gDhhJJFTqTi5beaD6pCMkrUm7ormbEZ2Lpk1J8EvLI5oZQ=
Date: Tue, 3 Apr 2007 08:13:45 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, e1000-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, ayyappan.veeraiyan@intel.com
Subject: [KJ][PATCH]ROUND_UP macro cleanup in drivers/net/ixgb
Message-ID: <20070403024345.GB9479@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IXGB_ROUNDUP macro cleanup ,use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---

 ixgb.h         |    3 ---
 ixgb_ethtool.c |    4 ++--
 ixgb_main.c    |    4 ++--
 ixgb_param.c   |    4 ++--
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ixgb/ixgb.h b/drivers/net/ixgb/ixgb.h
index cf30a10..c8e9086 100644
--- a/drivers/net/ixgb/ixgb.h
+++ b/drivers/net/ixgb/ixgb.h
@@ -111,9 +111,6 @@ struct ixgb_adapter;
 /* How many Rx Buffers do we bundle into one write to the hardware ? */
 #define IXGB_RX_BUFFER_WRITE	8	/* Must be power of 2 */
 
-/* only works for sizes that are powers of 2 */
-#define IXGB_ROUNDUP(i, size) ((i) = (((i) + (size) - 1) & ~((size) - 1)))
-
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer */
 struct ixgb_buffer {
diff --git a/drivers/net/ixgb/ixgb_ethtool.c b/drivers/net/ixgb/ixgb_ethtool.c
index d6628bd..cdefaff 100644
--- a/drivers/net/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ixgb/ixgb_ethtool.c
@@ -577,11 +577,11 @@ ixgb_set_ringparam(struct net_device *netdev,
 
 	rxdr->count = max(ring->rx_pending,(uint32_t)MIN_RXD);
 	rxdr->count = min(rxdr->count,(uint32_t)MAX_RXD);
-	IXGB_ROUNDUP(rxdr->count, IXGB_REQ_RX_DESCRIPTOR_MULTIPLE); 
+	rxdr->count = ALIGN(rxdr->count, IXGB_REQ_RX_DESCRIPTOR_MULTIPLE); 
 
 	txdr->count = max(ring->tx_pending,(uint32_t)MIN_TXD);
 	txdr->count = min(txdr->count,(uint32_t)MAX_TXD);
-	IXGB_ROUNDUP(txdr->count, IXGB_REQ_TX_DESCRIPTOR_MULTIPLE); 
+	txdr->count = ALIGN(txdr->count, IXGB_REQ_TX_DESCRIPTOR_MULTIPLE); 
 
 	if(netif_running(adapter->netdev)) {
 		/* Try to get new resources before deleting old */
diff --git a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
index afc2ec7..158c71e 100644
--- a/drivers/net/ixgb/ixgb_main.c
+++ b/drivers/net/ixgb/ixgb_main.c
@@ -685,7 +685,7 @@ ixgb_setup_tx_resources(struct ixgb_adapter *adapter)
 	/* round up to nearest 4K */
 
 	txdr->size = txdr->count * sizeof(struct ixgb_tx_desc);
-	IXGB_ROUNDUP(txdr->size, 4096);
+	txdr->size = ALIGN(txdr->size, 4096);
 
 	txdr->desc = pci_alloc_consistent(pdev, txdr->size, &txdr->dma);
 	if(!txdr->desc) {
@@ -774,7 +774,7 @@ ixgb_setup_rx_resources(struct ixgb_adapter *adapter)
 	/* Round up to nearest 4K */
 
 	rxdr->size = rxdr->count * sizeof(struct ixgb_rx_desc);
-	IXGB_ROUNDUP(rxdr->size, 4096);
+	rxdr->size = ALIGN(rxdr->size, 4096);
 
 	rxdr->desc = pci_alloc_consistent(pdev, rxdr->size, &rxdr->dma);
 
diff --git a/drivers/net/ixgb/ixgb_param.c b/drivers/net/ixgb/ixgb_param.c
index b27442a..ee8cc67 100644
--- a/drivers/net/ixgb/ixgb_param.c
+++ b/drivers/net/ixgb/ixgb_param.c
@@ -284,7 +284,7 @@ ixgb_check_options(struct ixgb_adapter *adapter)
 		} else {
 			tx_ring->count = opt.def;
 		}
-		IXGB_ROUNDUP(tx_ring->count, IXGB_REQ_TX_DESCRIPTOR_MULTIPLE);
+		tx_ring->count = ALIGN(tx_ring->count, IXGB_REQ_TX_DESCRIPTOR_MULTIPLE);
 	}
 	{ /* Receive Descriptor Count */
 		struct ixgb_option opt = {
@@ -303,7 +303,7 @@ ixgb_check_options(struct ixgb_adapter *adapter)
 		} else {
 			rx_ring->count = opt.def;
 		}
-		IXGB_ROUNDUP(rx_ring->count, IXGB_REQ_RX_DESCRIPTOR_MULTIPLE);
+		rx_ring->count = ALIGN(rx_ring->count, IXGB_REQ_RX_DESCRIPTOR_MULTIPLE);
 	}
 	{ /* Receive Checksum Offload Enable */
 		struct ixgb_option opt = {


-- 
Milind Arun Choudhary
