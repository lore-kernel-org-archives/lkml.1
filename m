Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936416Ab0CMBXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:23:49 -0500
Received: from kroah.org ([198.145.64.141]:60870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934930Ab0CMAUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:17 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.425507773@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 060/123] p54pci: handle dma mapping errors
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 288c8ce8047695fd8872dd5db3ef21a9679c402f upstream.

This patch adds error-paths to handle pci_dma_mapping errors.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54pci.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -157,6 +157,14 @@ static void p54p_refill_rx_ring(struct i
 						 skb_tail_pointer(skb),
 						 priv->common.rx_mtu + 32,
 						 PCI_DMA_FROMDEVICE);
+
+			if (pci_dma_mapping_error(priv->pdev, mapping)) {
+				dev_kfree_skb_any(skb);
+				dev_err(&priv->pdev->dev,
+					"RX DMA Mapping error\n");
+				break;
+			}
+
 			desc->host_addr = cpu_to_le32(mapping);
 			desc->device_addr = 0;	// FIXME: necessary?
 			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
@@ -325,14 +333,20 @@ static void p54p_tx(struct ieee80211_hw
 	u32 device_idx, idx, i;
 
 	spin_lock_irqsave(&priv->lock, flags);
-
 	device_idx = le32_to_cpu(ring_control->device_idx[1]);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
-	priv->tx_buf_data[i] = skb;
 	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(priv->pdev, mapping)) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		p54_free_skb(dev, skb);
+		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
+		return ;
+	}
+	priv->tx_buf_data[i] = skb;
+
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
 	desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;


