Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZKXA5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZKXA5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZKXA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:57:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50419 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbZKXA5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:57:00 -0500
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
Subject: [PATCH 2/4] macvlan: cleanup rx statistics
Date: Tue, 24 Nov 2009 00:56:04 +0000
Message-Id: <1259024166-28158-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259024166-28158-1-git-send-email-arnd@arndb.de>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX191/ZGcgmqckL9yz8YFwp5RU/Sn+UGglQ1EJ16
 bvU7xP0XQRUCKF98bBmGvrvU6HcR7xU90/r+jHhuvyDH02jnhH
 CVDLaaq32uBYh3d2dWkqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have very similar code for rx statistics in
two places in the macvlan driver, with a third
one being added in the next patch.

Consolidate them into one function to improve
overall readability of the driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/macvlan.c |   63 +++++++++++++++++++++++++-----------------------
 1 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index ae2b5c7..a0dea23 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -116,42 +116,53 @@ static int macvlan_addr_busy(const struct macvlan_port *port,
 	return 0;
 }
 
+static inline void macvlan_count_rx(const struct macvlan_dev *vlan, int length,
+			     int success, int multicast)
+{
+	struct macvlan_rx_stats *rx_stats;
+
+	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
+	rx_stats->rx_packets += success != 0;
+	rx_stats->rx_bytes   += success ? length : 0;
+	rx_stats->multicast  += success && multicast;
+	rx_stats->rx_errors  += !success;
+}
+
+static int macvlan_broadcast_one(struct sk_buff *skb, struct net_device *dev,
+				 const struct ethhdr *eth)
+{
+	if (!skb)
+		return NET_RX_DROP;
+
+	skb->dev = dev;
+	if (!compare_ether_addr_64bits(eth->h_dest,
+				       dev->broadcast))
+		skb->pkt_type = PACKET_BROADCAST;
+	else
+		skb->pkt_type = PACKET_MULTICAST;
+
+	return netif_rx(skb);
+}
+
 static void macvlan_broadcast(struct sk_buff *skb,
 			      const struct macvlan_port *port)
 {
 	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_dev *vlan;
 	struct hlist_node *n;
-	struct net_device *dev;
 	struct sk_buff *nskb;
 	unsigned int i;
-	struct macvlan_rx_stats *rx_stats;
+	int err;
 
 	if (skb->protocol == htons(ETH_P_PAUSE))
 		return;
 
 	for (i = 0; i < MACVLAN_HASH_SIZE; i++) {
 		hlist_for_each_entry_rcu(vlan, n, &port->vlan_hash[i], hlist) {
-			dev = vlan->dev;
-			rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
-
 			nskb = skb_clone(skb, GFP_ATOMIC);
-			if (nskb == NULL) {
-				rx_stats->rx_errors++;
-				continue;
-			}
-
-			rx_stats->rx_bytes += skb->len + ETH_HLEN;
-			rx_stats->rx_packets++;
-			rx_stats->multicast++;
-
-			nskb->dev = dev;
-			if (!compare_ether_addr_64bits(eth->h_dest, dev->broadcast))
-				nskb->pkt_type = PACKET_BROADCAST;
-			else
-				nskb->pkt_type = PACKET_MULTICAST;
-
-			netif_rx(nskb);
+			err = macvlan_broadcast_one(nskb, vlan->dev, eth);
+			macvlan_count_rx(vlan, skb->len + ETH_HLEN,
+					 likely(err == NET_RX_SUCCESS), 1);
 		}
 	}
 }
@@ -163,7 +174,6 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 	const struct macvlan_port *port;
 	const struct macvlan_dev *vlan;
 	struct net_device *dev;
-	struct macvlan_rx_stats *rx_stats;
 
 	port = rcu_dereference(skb->dev->macvlan_port);
 	if (port == NULL)
@@ -183,15 +193,8 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 		kfree_skb(skb);
 		return NULL;
 	}
-	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
 	skb = skb_share_check(skb, GFP_ATOMIC);
-	if (skb == NULL) {
-		rx_stats->rx_errors++;
-		return NULL;
-	}
-
-	rx_stats->rx_bytes += skb->len + ETH_HLEN;
-	rx_stats->rx_packets++;
+	macvlan_count_rx(vlan, skb->len + ETH_HLEN, likely(skb != NULL), 0);
 
 	skb->dev = dev;
 	skb->pkt_type = PACKET_HOST;
-- 
1.6.3.3

