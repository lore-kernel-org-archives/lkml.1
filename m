Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbZKFWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbZKFWF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759955AbZKFWF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:56 -0500
Received: from kroah.org ([198.145.64.141]:39773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759922AbZKFWFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:52 2009
Message-Id: <20091106215952.229428650@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [17/30] appletalk: Fix skb leak when ipddp interface is not loaded (CVE-2009-2903)
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=appletalk-fix-skb-leak-when-ipddp-interface-is-not-loaded-cve-2009-2903.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit ffcfb8db540ff879c2a85bf7e404954281443414 upstream

appletalk: Fix skb leak when ipddp interface is not loaded

[ backport to 2.6.27 : Chuck Ebbert <cebbert@redhat.com ]

And also do a better job of returning proper NET_{RX,XMIT}_ values.

Based on a patch and suggestions by Mark Smith.

This fixes CVE-2009-2903

Reported-by: Mark Smith <lk-netdev@lk-netdev.nosense.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/appletalk/ipddp.c |    3 --
 net/appletalk/aarp.c          |   16 +++++++++-----
 net/appletalk/ddp.c           |   47 +++++++++++++++++++++---------------------
 3 files changed, 36 insertions(+), 30 deletions(-)

--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -173,8 +173,7 @@ static int ipddp_xmit(struct sk_buff *sk
 	((struct net_device_stats *) dev->priv)->tx_packets++;
         ((struct net_device_stats *) dev->priv)->tx_bytes+=skb->len;
 
-        if(aarp_send_ddp(rt->dev, skb, &rt->at, NULL) < 0)
-                dev_kfree_skb(skb);
+	aarp_send_ddp(rt->dev, skb, &rt->at, NULL);
 
         return 0;
 }
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -598,7 +598,7 @@ int aarp_send_ddp(struct net_device *dev
 
 	/* Non ELAP we cannot do. */
 	if (dev->type != ARPHRD_ETHER)
-		return -1;
+		goto free_it;
 
 	skb->dev = dev;
 	skb->protocol = htons(ETH_P_ATALK);
@@ -633,7 +633,7 @@ int aarp_send_ddp(struct net_device *dev
 	if (!a) {
 		/* Whoops slipped... good job it's an unreliable protocol 8) */
 		write_unlock_bh(&aarp_lock);
-		return -1;
+		goto free_it;
 	}
 
 	/* Set up the queue */
@@ -662,15 +662,21 @@ out_unlock:
 	write_unlock_bh(&aarp_lock);
 
 	/* Tell the ddp layer we have taken over for this frame. */
-	return 0;
+	goto sent;
 
 sendit:
 	if (skb->sk)
 		skb->priority = skb->sk->sk_priority;
-	dev_queue_xmit(skb);
+	if (dev_queue_xmit(skb))
+		goto drop;
 sent:
-	return 1;
+	return NET_XMIT_SUCCESS;
+free_it:
+	kfree_skb(skb);
+drop:
+	return NET_XMIT_DROP;
 }
+EXPORT_SYMBOL(aarp_send_ddp);
 
 /*
  *	An entry in the aarp unresolved queue has become resolved. Send
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1277,8 +1277,10 @@ static int handle_ip_over_ddp(struct sk_
 	struct net_device_stats *stats;
 
 	/* This needs to be able to handle ipddp"N" devices */
-	if (!dev)
-		return -ENODEV;
+	if (!dev) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb->protocol = htons(ETH_P_IP);
 	skb_pull(skb, 13);
@@ -1288,8 +1290,7 @@ static int handle_ip_over_ddp(struct sk_
 	stats = dev->priv;
 	stats->rx_packets++;
 	stats->rx_bytes += skb->len + 13;
-	netif_rx(skb);  /* Send the SKB up to a higher place. */
-	return 0;
+	return netif_rx(skb);  /* Send the SKB up to a higher place. */
 }
 #else
 /* make it easy for gcc to optimize this test out, i.e. kill the code */
@@ -1297,9 +1298,8 @@ static int handle_ip_over_ddp(struct sk_
 #define handle_ip_over_ddp(skb) 0
 #endif
 
-static void atalk_route_packet(struct sk_buff *skb, struct net_device *dev,
-			       struct ddpehdr *ddp, __u16 len_hops,
-			       int origlen)
+static int atalk_route_packet(struct sk_buff *skb, struct net_device *dev,
+			      struct ddpehdr *ddp, __u16 len_hops, int origlen)
 {
 	struct atalk_route *rt;
 	struct atalk_addr ta;
@@ -1366,8 +1366,6 @@ static void atalk_route_packet(struct sk
 		/* 22 bytes - 12 ether, 2 len, 3 802.2 5 snap */
 		struct sk_buff *nskb = skb_realloc_headroom(skb, 32);
 		kfree_skb(skb);
-		if (!nskb)
-			goto out;
 		skb = nskb;
 	} else
 		skb = skb_unshare(skb, GFP_ATOMIC);
@@ -1376,12 +1374,16 @@ static void atalk_route_packet(struct sk
 	 * If the buffer didn't vanish into the lack of space bitbucket we can
 	 * send it.
 	 */
-	if (skb && aarp_send_ddp(rt->dev, skb, &ta, NULL) == -1)
-		goto free_it;
-out:
-	return;
+	if (skb == NULL)
+		goto drop;
+
+	if (aarp_send_ddp(rt->dev, skb, &ta, NULL) == NET_XMIT_DROP)
+		return NET_RX_DROP;
+	return NET_XMIT_SUCCESS;
 free_it:
 	kfree_skb(skb);
+drop:
+	return NET_RX_DROP;
 }
 
 /**
@@ -1455,8 +1457,7 @@ static int atalk_rcv(struct sk_buff *skb
 		/* Not ours, so we route the packet via the correct
 		 * AppleTalk iface
 		 */
-		atalk_route_packet(skb, dev, ddp, len_hops, origlen);
-		goto out;
+		return atalk_route_packet(skb, dev, ddp, len_hops, origlen);
 	}
 
 	/* if IP over DDP is not selected this code will be optimized out */
@@ -1663,10 +1664,10 @@ static int atalk_sendmsg(struct kiocb *i
 		if (skb2) {
 			loopback = 1;
 			SOCK_DEBUG(sk, "SK %p: send out(copy).\n", sk);
-			if (aarp_send_ddp(dev, skb2,
-					  &usat->sat_addr, NULL) == -1)
-				kfree_skb(skb2);
-				/* else queued/sent above in the aarp queue */
+			/*
+			 * If it fails it is queued/sent above in the aarp queue
+			 */
+			aarp_send_ddp(dev, skb2, &usat->sat_addr, NULL);
 		}
 	}
 
@@ -1696,9 +1697,10 @@ static int atalk_sendmsg(struct kiocb *i
 		    usat = &gsat;
 		}
 
-		if (aarp_send_ddp(dev, skb, &usat->sat_addr, NULL) == -1)
-			kfree_skb(skb);
-		/* else queued/sent above in the aarp queue */
+		/*
+		 * If it fails it is queued/sent above in the aarp queue
+		 */
+		aarp_send_ddp(dev, skb, &usat->sat_addr, NULL);
 	}
 	SOCK_DEBUG(sk, "SK %p: Done write (%Zd).\n", sk, len);
 
@@ -1877,7 +1879,6 @@ static struct packet_type ppptalk_packet
 static unsigned char ddp_snap_id[] = { 0x08, 0x00, 0x07, 0x80, 0x9B };
 
 /* Export symbols for use by drivers when AppleTalk is a module */
-EXPORT_SYMBOL(aarp_send_ddp);
 EXPORT_SYMBOL(atrtr_get_dev);
 EXPORT_SYMBOL(atalk_find_dev_addr);
 


