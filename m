Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZKXA40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZKXA40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbZKXA4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:56:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZKXA4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:56:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Patrick McHardy <kaber@trash.net>,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/4] macvlan: implement bridge, VEPA and private mode
Date: Tue, 24 Nov 2009 00:56:05 +0000
Message-Id: <1259024166-28158-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259024166-28158-1-git-send-email-arnd@arndb.de>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ZkHh1N33vnpecmGW+K/m6mZZDIlDniUqxq89
 xV3nmmJyynwNzYVAl20IgKjdkf5Kgq0dqJEEliTjYBGfEX4JwH
 fpXDuzZ+tUekMPQYBt7aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows each macvlan slave device to be in one
of three modes, depending on the use case:

MACVLAN_PRIVATE:
  The device never communicates with any other device
  on the same upper_dev. This even includes frames
  coming back from a reflective relay, where supported
  by the adjacent bridge.

MACVLAN_VEPA:
  The new Virtual Ethernet Port Aggregator (VEPA) mode,
  we assume that the adjacent bridge returns all frames
  where both source and destination are local to the
  macvlan port, i.e. the bridge is set up as a reflective
  relay.
  Broadcast frames coming in from the upper_dev get
  flooded to all macvlan interfaces in VEPA mode.
  We never deliver any frames locally.

MACVLAN_BRIDGE:
  We provide the behavior of a simple bridge between
  different macvlan interfaces on the same port. Frames
  from one interface to another one get delivered directly
  and are not sent out externally. Broadcast frames get
  flooded to all other bridge ports and to the external
  interface, but when they come back from a reflective
  relay, we don't deliver them again.
  Since we know all the MAC addresses, the macvlan bridge
  mode does not require learning or STP like the bridge
  module does.

Based on an earlier patch "macvlan: Reflect macvlan packets
meant for other macvlan devices" by Eric Biederman.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biederman <ebiederm@xmission.com>
---
 drivers/net/macvlan.c |   75 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index a0dea23..b840b3a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -29,9 +29,16 @@
 #include <linux/if_link.h>
 #include <linux/if_macvlan.h>
 #include <net/rtnetlink.h>
+#include <net/xfrm.h>
 
 #define MACVLAN_HASH_SIZE	(1 << BITS_PER_BYTE)
 
+enum macvlan_mode {
+	MACVLAN_MODE_PRIVATE	= 1,
+	MACVLAN_MODE_VEPA	= 2,
+	MACVLAN_MODE_BRIDGE	= 4,
+};
+
 struct macvlan_port {
 	struct net_device	*dev;
 	struct hlist_head	vlan_hash[MACVLAN_HASH_SIZE];
@@ -59,6 +66,7 @@ struct macvlan_dev {
 	struct macvlan_port	*port;
 	struct net_device	*lowerdev;
 	struct macvlan_rx_stats *rx_stats;
+	enum macvlan_mode	mode;
 };
 
 
@@ -129,11 +137,14 @@ static inline void macvlan_count_rx(const struct macvlan_dev *vlan, int length,
 }
 
 static int macvlan_broadcast_one(struct sk_buff *skb, struct net_device *dev,
-				 const struct ethhdr *eth)
+				 const struct ethhdr *eth, int local)
 {
 	if (!skb)
 		return NET_RX_DROP;
 
+	if (local)
+		return dev_forward_skb(dev, skb);
+
 	skb->dev = dev;
 	if (!compare_ether_addr_64bits(eth->h_dest,
 				       dev->broadcast))
@@ -145,7 +156,9 @@ static int macvlan_broadcast_one(struct sk_buff *skb, struct net_device *dev,
 }
 
 static void macvlan_broadcast(struct sk_buff *skb,
-			      const struct macvlan_port *port)
+			      const struct macvlan_port *port,
+			      struct net_device *src,
+			      enum macvlan_mode mode)
 {
 	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_dev *vlan;
@@ -159,8 +172,12 @@ static void macvlan_broadcast(struct sk_buff *skb,
 
 	for (i = 0; i < MACVLAN_HASH_SIZE; i++) {
 		hlist_for_each_entry_rcu(vlan, n, &port->vlan_hash[i], hlist) {
+			if ((vlan->dev == src) || !(vlan->mode & mode))
+				continue;
+
 			nskb = skb_clone(skb, GFP_ATOMIC);
-			err = macvlan_broadcast_one(nskb, vlan->dev, eth);
+			err = macvlan_broadcast_one(nskb, vlan->dev, eth,
+					 mode == MACVLAN_MODE_BRIDGE);
 			macvlan_count_rx(vlan, skb->len + ETH_HLEN,
 					 likely(err == NET_RX_SUCCESS), 1);
 		}
@@ -173,6 +190,7 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_port *port;
 	const struct macvlan_dev *vlan;
+	const struct macvlan_dev *src;
 	struct net_device *dev;
 
 	port = rcu_dereference(skb->dev->macvlan_port);
@@ -180,7 +198,20 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 		return skb;
 
 	if (is_multicast_ether_addr(eth->h_dest)) {
-		macvlan_broadcast(skb, port);
+		src = macvlan_hash_lookup(port, eth->h_source);
+		if (!src)
+			/* frame comes from an external address */
+			macvlan_broadcast(skb, port, NULL, MACVLAN_MODE_PRIVATE
+				| MACVLAN_MODE_VEPA | MACVLAN_MODE_BRIDGE);
+		else if (src->mode == MACVLAN_MODE_VEPA)
+			/* flood to everyone except source */
+			macvlan_broadcast(skb, port, src->dev,
+				MACVLAN_MODE_VEPA | MACVLAN_MODE_BRIDGE);
+		else if (src->mode == MACVLAN_MODE_BRIDGE)
+			/* flood only to VEPA ports, bridge ports
+			   already saw the frame */
+			macvlan_broadcast(skb, port, src->dev,
+				MACVLAN_MODE_VEPA);
 		return skb;
 	}
 
@@ -203,18 +234,46 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 	return NULL;
 }
 
+static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	const struct macvlan_dev *vlan = netdev_priv(dev);
+	const struct macvlan_port *port = vlan->port;
+	const struct macvlan_dev *dest;
+
+	if (vlan->mode == MACVLAN_MODE_BRIDGE) {
+		const struct ethhdr *eth = (void *)skb->data;
+
+		/* send to other bridge ports directly */
+		if (is_multicast_ether_addr(eth->h_dest)) {
+			macvlan_broadcast(skb, port, dev, MACVLAN_MODE_BRIDGE);
+			goto xmit_world;
+		}
+
+		dest = macvlan_hash_lookup(port, eth->h_dest);
+		if (dest && dest->mode == MACVLAN_MODE_BRIDGE) {
+			int length = skb->len + ETH_HLEN;
+			int ret = dev_forward_skb(dest->dev, skb);
+			macvlan_count_rx(dest, length,
+					 likely(ret == NET_RX_SUCCESS), 0);
+
+			return NET_XMIT_SUCCESS;
+		}
+	}
+
+xmit_world:
+	skb->dev = vlan->lowerdev;
+	return dev_queue_xmit(skb);
+}
+
 static netdev_tx_t macvlan_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	int i = skb_get_queue_mapping(skb);
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
-	const struct macvlan_dev *vlan = netdev_priv(dev);
 	unsigned int len = skb->len;
 	int ret;
 
-	skb->dev = vlan->lowerdev;
-	ret = dev_queue_xmit(skb);
-
+	ret = macvlan_queue_xmit(skb, dev);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		txq->tx_packets++;
 		txq->tx_bytes += len;
-- 
1.6.3.3

