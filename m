Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935937Ab0CMA5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:57:01 -0500
Received: from kroah.org ([198.145.64.141]:46843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935322Ab0CMAbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:20 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.167305520@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [045/145] sky2: fix transmit DMA map leakage
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit f6815077e75c5b7f55b56fc3788e328514d4e72a ]

The book keeping structure for transmit always had the flags value
cleared so transmit DMA maps were never released correctly.
Based on patch by Jarek Poplawski, problem observed by Michael Breuer.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1008,11 +1008,8 @@ static void sky2_prefetch_init(struct sk
 static inline struct sky2_tx_le *get_tx_le(struct sky2_port *sky2, u16 *slot)
 {
 	struct sky2_tx_le *le = sky2->tx_le + *slot;
-	struct tx_ring_info *re = sky2->tx_ring + *slot;
 
 	*slot = RING_NEXT(*slot, sky2->tx_ring_size);
-	re->flags = 0;
-	re->skb = NULL;
 	le->ctrl = 0;
 	return le;
 }
@@ -1580,8 +1577,7 @@ static unsigned tx_le_req(const struct s
 	return count;
 }
 
-static void sky2_tx_unmap(struct pci_dev *pdev,
-			  const struct tx_ring_info *re)
+static void sky2_tx_unmap(struct pci_dev *pdev, struct tx_ring_info *re)
 {
 	if (re->flags & TX_MAP_SINGLE)
 		pci_unmap_single(pdev, pci_unmap_addr(re, mapaddr),
@@ -1591,6 +1587,7 @@ static void sky2_tx_unmap(struct pci_dev
 		pci_unmap_page(pdev, pci_unmap_addr(re, mapaddr),
 			       pci_unmap_len(re, maplen),
 			       PCI_DMA_TODEVICE);
+	re->flags = 0;
 }
 
 /*
@@ -1797,6 +1794,7 @@ static void sky2_tx_complete(struct sky2
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += skb->len;
 
+			re->skb = NULL;
 			dev_kfree_skb_any(skb);
 
 			sky2->tx_next = RING_NEXT(idx, sky2->tx_ring_size);


