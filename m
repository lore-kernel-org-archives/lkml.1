Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbZFPQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbZFPQdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZFPQdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:33:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:64045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbZFPQdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,229,1243839600"; 
   d="scan'208";a="699899071"
Date: Tue, 16 Jun 2009 09:33:15 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Joerg Roedel <joerg.roedel@amd.com>
cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dma-debug warning with ixgbe
In-Reply-To: <20090616153417.GN5139@amd.com>
Message-ID: <alpine.WNT.2.00.0906160907580.6076@jbrandeb-desk1.amr.corp.intel.com>
References: <20090616153417.GN5139@amd.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Joerg Roedel wrote:
> today I got this dma-debug warning with the ixgbe driver with a kernel
> near 2.6.30-rc8.

Hi Joerg, thanks for the report, I thought we had fixed all of these 
already but we must have missed this one.

> ------------[ cut here ]------------
> WARNING: at /data/repos/linux-2.6-iommu/lib/dma-debug.c:806
> check_unmap+0x214/0x5c3()
> Hardware name: Toonie
> ixgbe 0000:02:00.0: DMA-API: device driver frees DMA memory with
> different size [device address=0x0000000000045c12] [map size=258
> bytes] [unmap size=256 bytes]

The following patch should fix it, compile tested only, but it is pretty 
straight forward.

---

ixgbe: fix map length bug

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

ixgbe is mapping more than it unmaps, reduce the length of the map call and
remove the "used once" local variable.

found by Joerg Roedel <joerg.roedel@amd.com> in 2.6.30, so is a candidate for
-stable.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Joerg Roedel <joerg.roedel@amd.com>
---

 drivers/net/ixgbe/ixgbe_main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index a551a96..01c2193 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -563,7 +563,6 @@ static void ixgbe_alloc_rx_buffers(struct ixgbe_adapter *adapter,
 	union ixgbe_adv_rx_desc *rx_desc;
 	struct ixgbe_rx_buffer *bi;
 	unsigned int i;
-	unsigned int bufsz = rx_ring->rx_buf_len + NET_IP_ALIGN;
 
 	i = rx_ring->next_to_use;
 	bi = &rx_ring->rx_buffer_info[i];
@@ -593,7 +592,9 @@ static void ixgbe_alloc_rx_buffers(struct ixgbe_adapter *adapter,
 
 		if (!bi->skb) {
 			struct sk_buff *skb;
-			skb = netdev_alloc_skb(adapter->netdev, bufsz);
+			skb = netdev_alloc_skb(adapter->netdev,
+			                       (rx_ring->rx_buf_len +
+			                        NET_IP_ALIGN));
 
 			if (!skb) {
 				adapter->alloc_rx_buff_failed++;
@@ -608,7 +609,8 @@ static void ixgbe_alloc_rx_buffers(struct ixgbe_adapter *adapter,
 			skb_reserve(skb, NET_IP_ALIGN);
 
 			bi->skb = skb;
-			bi->dma = pci_map_single(pdev, skb->data, bufsz,
+			bi->dma = pci_map_single(pdev, skb->data,
+			                         rx_ring->rx_buf_len,
 			                         PCI_DMA_FROMDEVICE);
 		}
 		/* Refresh the desc even if buffer_addrs didn't change because
