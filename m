Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbZKXJ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbZKXJ3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbZKXJ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:29:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbZKXJ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:29:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/4] macvlan: cleanup rx statistics
Date: Tue, 24 Nov 2009 09:28:43 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31bisect; KDE/4.3.2; x86_64; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Anna Fischer <anna.fischer@hp.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Patrick Mullaney <pmullaney@novell.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       David Miller <davem@davemloft.net>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <4B0B9639.4070607@gmail.com> <200911240845.14454.arnd@arndb.de>
In-Reply-To: <200911240845.14454.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200911240928.43901.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UMHpEImZp6ZcpO2vQ8KnoGZ+xsT9+Ig0xiI1
 VZ2xFdIKcyR9RAchMSv8h3RVz+QdzQrIacSXc0mZ5/6lwDP2cH
 Dr80Xh6VGt4nmGL5+vq+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009 08:45:14 Arnd Bergmann wrote:
> On Tuesday 24 November 2009 08:15:53 Eric Dumazet wrote:
> > Arnd Bergmann a écrit :
> > I find following more readable, it probably generates more branches,
> > but avoid dirtying rx_errors if it is in another cache line.
> > 
> > if (likely(success)) {
> > 	rx_stats->rx_packets++;
> > 	rx_stats->rx_bytes += length;
> > 	if (multicast)
> > 		rx_stats->multicast++;
> > } else {
> > 	rx_stats->rx_errors++;
> > }
> 
> Given that the structure only has four members and alloc_percpu requests
> cache aligned data, it is rather likely to be in the same cache line.
> 
> I'll have a look at what gcc generates on x86-64 for both versions
> and use the version you suggested unless it looks significantly more
> expensive.

Ok, that's what I got for trying to be clever. My version did not avoid
any branches, just created more code. I'll fold this update into my
patches then:
---
macvlan: cleanups

Use bool instead of int for flags, don't misoptimize rx counters,
avoid accessing a NULL skb.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 3db96b9..ff5f0b0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -119,19 +119,23 @@ static int macvlan_addr_busy(const struct macvlan_port *port,
 }
 
 static inline void macvlan_count_rx(const struct macvlan_dev *vlan, int length,
-			     int success, int multicast)
+			     bool success, bool multicast)
 {
 	struct macvlan_rx_stats *rx_stats;
 
 	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
-	rx_stats->rx_packets += success != 0;
-	rx_stats->rx_bytes   += success ? length : 0;
-	rx_stats->multicast  += success && multicast;
-	rx_stats->rx_errors  += !success;
+	if (likely(success)) {
+		rx_stats->rx_packets++;;
+		rx_stats->rx_bytes += length;
+		if (multicast)
+			rx_stats->multicast++;
+	} else {
+		rx_stats->rx_errors++;
+	}
 }
 
 static int macvlan_broadcast_one(struct sk_buff *skb, struct net_device *dev,
-				 const struct ethhdr *eth, int local)
+				 const struct ethhdr *eth, bool local)
 {
 	if (!skb)
 		return NET_RX_DROP;
@@ -173,7 +177,7 @@ static void macvlan_broadcast(struct sk_buff *skb,
 			err = macvlan_broadcast_one(nskb, vlan->dev, eth,
 					 mode == MACVLAN_MODE_BRIDGE);
 			macvlan_count_rx(vlan, skb->len + ETH_HLEN,
-					 likely(err == NET_RX_SUCCESS), 1);
+					 err == NET_RX_SUCCESS, 1);
 		}
 	}
 }
@@ -186,6 +190,7 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 	const struct macvlan_dev *vlan;
 	const struct macvlan_dev *src;
 	struct net_device *dev;
+	int len;
 
 	port = rcu_dereference(skb->dev->macvlan_port);
 	if (port == NULL)
@@ -218,8 +223,11 @@ static struct sk_buff *macvlan_handle_frame(struct sk_buff *skb)
 		kfree_skb(skb);
 		return NULL;
 	}
+	len = skb->len + ETH_HLEN;
 	skb = skb_share_check(skb, GFP_ATOMIC);
-	macvlan_count_rx(vlan, skb->len + ETH_HLEN, likely(skb != NULL), 0);
+	macvlan_count_rx(vlan, len, skb != NULL, 0);
+	if (!skb)
+		return NULL;
 
 	skb->dev = dev;
 	skb->pkt_type = PACKET_HOST;
@@ -248,7 +256,7 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 			int length = skb->len + ETH_HLEN;
 			int ret = dev_forward_skb(dest->dev, skb);
 			macvlan_count_rx(dest, length,
-					 likely(ret == NET_RX_SUCCESS), 0);
+					 ret == NET_RX_SUCCESS, 0);
 
 			return NET_XMIT_SUCCESS;
 		}
