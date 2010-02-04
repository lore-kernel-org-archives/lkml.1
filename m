Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457Ab0BDRfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:35:04 -0500
Received: from kroah.org ([198.145.64.141]:34640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab0BDRVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:41 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:59 2010
Message-Id: <20100204171458.846742728@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [18/74] e1000e: enhance frame fragment detection
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit b94b50289622e816adc9f94111cfc2679c80177c upstream.

Originally patched by Neil Horman <nhorman@tuxdriver.com>

e1000e could with a jumbo frame enabled interface, and packet split disabled,
receive a packet that would overflow a single rx buffer.  While in practice
very hard to craft a packet that could abuse this, it is possible.

this is related to CVE-2009-4538

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/e1000.h  |    1 +
 drivers/net/e1000e/netdev.c |   25 +++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -417,6 +417,7 @@ struct e1000_info {
 /* CRC Stripping defines */
 #define FLAG2_CRC_STRIPPING               (1 << 0)
 #define FLAG2_HAS_PHY_WAKEUP              (1 << 1)
+#define FLAG2_IS_DISCARDING               (1 << 2)
 
 #define E1000_RX_DESC_PS(R, i)	    \
 	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -482,14 +482,24 @@ static bool e1000_clean_rx_irq(struct e1
 
 		length = le16_to_cpu(rx_desc->length);
 
-		/* !EOP means multiple descriptors were used to store a single
-		 * packet, also make sure the frame isn't just CRC only */
-		if (!(status & E1000_RXD_STAT_EOP) || (length <= 4)) {
+		/*
+		 * !EOP means multiple descriptors were used to store a single
+		 * packet, if that's the case we need to toss it.  In fact, we
+		 * need to toss every packet with the EOP bit clear and the
+		 * next frame that _does_ have the EOP bit set, as it is by
+		 * definition only a frame fragment
+		 */
+		if (unlikely(!(status & E1000_RXD_STAT_EOP)))
+			adapter->flags2 |= FLAG2_IS_DISCARDING;
+
+		if (adapter->flags2 & FLAG2_IS_DISCARDING) {
 			/* All receives must fit into a single buffer */
 			e_dbg("%s: Receive packet consumed multiple buffers\n",
 			      netdev->name);
 			/* recycle */
 			buffer_info->skb = skb;
+			if (status & E1000_RXD_STAT_EOP)
+				adapter->flags2 &= ~FLAG2_IS_DISCARDING;
 			goto next_desc;
 		}
 
@@ -747,10 +757,16 @@ static bool e1000_clean_rx_irq_ps(struct
 				 PCI_DMA_FROMDEVICE);
 		buffer_info->dma = 0;
 
-		if (!(staterr & E1000_RXD_STAT_EOP)) {
+		/* see !EOP comment in other rx routine */
+		if (!(staterr & E1000_RXD_STAT_EOP))
+			adapter->flags2 |= FLAG2_IS_DISCARDING;
+
+		if (adapter->flags2 & FLAG2_IS_DISCARDING) {
 			e_dbg("%s: Packet Split buffers didn't pick up the "
 			      "full packet\n", netdev->name);
 			dev_kfree_skb_irq(skb);
+			if (staterr & E1000_RXD_STAT_EOP)
+				adapter->flags2 &= ~FLAG2_IS_DISCARDING;
 			goto next_desc;
 		}
 
@@ -1120,6 +1136,7 @@ static void e1000_clean_rx_ring(struct e
 
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
+	adapter->flags2 &= ~FLAG2_IS_DISCARDING;
 
 	writel(0, adapter->hw.hw_addr + rx_ring->head);
 	writel(0, adapter->hw.hw_addr + rx_ring->tail);


