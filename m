Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXFTW1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXFTW1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXFTW04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:26:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43417 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXFTW0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:26:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 21 Jun 2007 00:26:41 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.36157d8fd8c1ab52@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following fixes for a lockup in IRQ, an oops (AFAIK with
lockup), and packet corruption.  Two commits are the same as in the
pull request last week (http://lkml.org/lkml/2007/6/16/82), one is new.


 drivers/firewire/fw-cdev.c |   19 +++++++++++--------
 drivers/firewire/fw-ohci.c |    2 +-
 drivers/ieee1394/eth1394.c |   21 +++++++++++++++------
 3 files changed, 27 insertions(+), 15 deletions(-)

Carlos E. Ugarte (1):
      ieee1394: fix to ether1394_tx in ether1394.c

Kristian Høgsberg (1):
      firewire: Only set client->iso_context if allocation was successful.

Stefan Richter (1):
      firewire: fix hang after card ejection


diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 5d402d6..dbb7642 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -640,6 +640,7 @@ iso_callback(struct fw_iso_context *context, u32 cycle,
 static int ioctl_create_iso_context(struct client *client, void *buffer)
 {
 	struct fw_cdev_create_iso_context *request = buffer;
+	struct fw_iso_context *context;
 
 	if (request->channel > 63)
 		return -EINVAL;
@@ -661,15 +662,17 @@ static int ioctl_create_iso_context(struct client *client, void *buffer)
 		return -EINVAL;
 	}
 
+	context =  fw_iso_context_create(client->device->card,
+					 request->type,
+					 request->channel,
+					 request->speed,
+					 request->header_size,
+					 iso_callback, client);
+	if (IS_ERR(context))
+		return PTR_ERR(context);
+
 	client->iso_closure = request->closure;
-	client->iso_context = fw_iso_context_create(client->device->card,
-						    request->type,
-						    request->channel,
-						    request->speed,
-						    request->header_size,
-						    iso_callback, client);
-	if (IS_ERR(client->iso_context))
-		return PTR_ERR(client->iso_context);
+	client->iso_context = context;
 
 	/* We only support one context at this time. */
 	request->handle = 0;
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 0d08bf9..b72a5c1 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1001,7 +1001,7 @@ static irqreturn_t irq_handler(int irq, void *data)
 
 	event = reg_read(ohci, OHCI1394_IntEventClear);
 
-	if (!event)
+	if (!event || !~event)
 		return IRQ_NONE;
 
 	reg_write(ohci, OHCI1394_IntEventClear, event);
diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index 5f026b5..7c13fb3 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -1565,7 +1565,7 @@ static void ether1394_complete_cb(void *__ptask)
 /* Transmit a packet (called by kernel) */
 static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct eth1394hdr *eth;
+	struct eth1394hdr hdr_buf;
 	struct eth1394_priv *priv = netdev_priv(dev);
 	__be16 proto;
 	unsigned long flags;
@@ -1595,16 +1595,17 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 	if (!skb)
 		goto fail;
 
-	/* Get rid of the fake eth1394 header, but save a pointer */
-	eth = (struct eth1394hdr *)skb->data;
+	/* Get rid of the fake eth1394 header, but first make a copy.
+	 * We might need to rebuild the header on tx failure. */
+	memcpy(&hdr_buf, skb->data, sizeof(hdr_buf));
 	skb_pull(skb, ETH1394_HLEN);
 
-	proto = eth->h_proto;
+	proto = hdr_buf.h_proto;
 	dg_size = skb->len;
 
 	/* Set the transmission type for the packet.  ARP packets and IP
 	 * broadcast packets are sent via GASP. */
-	if (memcmp(eth->h_dest, dev->broadcast, ETH1394_ALEN) == 0 ||
+	if (memcmp(hdr_buf.h_dest, dev->broadcast, ETH1394_ALEN) == 0 ||
 	    proto == htons(ETH_P_ARP) ||
 	    (proto == htons(ETH_P_IP) &&
 	     IN_MULTICAST(ntohl(ip_hdr(skb)->daddr)))) {
@@ -1616,7 +1617,7 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 		if (max_payload < dg_size + hdr_type_len[ETH1394_HDR_LF_UF])
 			priv->bc_dgl++;
 	} else {
-		__be64 guid = get_unaligned((u64 *)eth->h_dest);
+		__be64 guid = get_unaligned((u64 *)hdr_buf.h_dest);
 
 		node = eth1394_find_node_guid(&priv->ip_node_list,
 					      be64_to_cpu(guid));
@@ -1673,6 +1674,14 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
 		if (dest_node == (LOCAL_BUS | ALL_NODES))
 			goto fail;
 
+		/* At this point we want to restore the packet.  When we return
+		 * here with NETDEV_TX_BUSY we will get another entrance in this
+		 * routine with the same skb and we need it to look the same.
+		 * So we pull 4 more bytes, then build the header again. */
+		skb_pull(skb, 4);
+		ether1394_header(skb, dev, ntohs(hdr_buf.h_proto),
+				 hdr_buf.h_dest, NULL, 0);
+
 		/* Most failures of ether1394_send_packet are recoverable. */
 		netif_stop_queue(dev);
 		priv->wake_node = dest_node;


-- 
Stefan Richter
-=====-=-=== -==- =-=-=
http://arcgraph.de/sr/

