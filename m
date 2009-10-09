Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbZJIXmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbZJIXmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbZJIXmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:10 -0400
Received: from kroah.org ([198.145.64.141]:51432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123AbZJIXmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:39 2009
Message-Id: <20091009233439.552024626@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 27/37] net: restore tx timestamping for accelerated vlans
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=net-restore-tx-timestamping-for-accelerated-vlans.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 81bbb3d4048cf577b5babcb0834230de391a35c5 ]

Since commit 9b22ea560957de1484e6b3e8538f7eef202e3596
( net: fix packet socket delivery in rx irq handler )

We lost rx timestamping of packets received on accelerated vlans.

Effect is that tcpdump on real dev can show strange timings, since it gets rx timestamps
too late (ie at skb dequeueing time, not at skb queueing time)

14:47:26.986871 IP 192.168.20.110 > 192.168.20.141: icmp 64: echo request seq 1
14:47:26.986786 IP 192.168.20.141 > 192.168.20.110: icmp 64: echo reply seq 1

14:47:27.986888 IP 192.168.20.110 > 192.168.20.141: icmp 64: echo request seq 2
14:47:27.986781 IP 192.168.20.141 > 192.168.20.110: icmp 64: echo reply seq 2

14:47:28.986896 IP 192.168.20.110 > 192.168.20.141: icmp 64: echo request seq 3
14:47:28.986780 IP 192.168.20.141 > 192.168.20.110: icmp 64: echo reply seq 3

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2248,6 +2248,9 @@ int netif_receive_skb(struct sk_buff *sk
 	int ret = NET_RX_DROP;
 	__be16 type;
 
+	if (!skb->tstamp.tv64)
+		net_timestamp(skb);
+
 	if (skb->vlan_tci && vlan_hwaccel_do_receive(skb))
 		return NET_RX_SUCCESS;
 
@@ -2255,9 +2258,6 @@ int netif_receive_skb(struct sk_buff *sk
 	if (netpoll_receive_skb(skb))
 		return NET_RX_DROP;
 
-	if (!skb->tstamp.tv64)
-		net_timestamp(skb);
-
 	if (!skb->iif)
 		skb->iif = skb->dev->ifindex;
 


