Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbXHCRfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbXHCRfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763492AbXHCRfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:35:07 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37134 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763464AbXHCRex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:34:53 -0400
Date: Fri, 3 Aug 2007 19:33:27 +0200 (MEST)
Message-Id: <200708031733.TAA00739@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 02/13] dev->priv to netdev_priv(dev), for drivers/net/appletalk
Cc: jeff@garzik.org, netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing accesses to dev->priv to netdev_priv(dev). The replacment
is safe when netdev_priv is used to access a private structure that is
right next to the net_device structure in memory. Cf
http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
This is the case when the net_device structure was allocated with
a call to alloc_netdev or one of its derivative.

Here is an excerpt of the semantic patch that performs the transformation

@ rule1 @
type T;
struct net_device *dev;
@@

 dev = 
(
        alloc_netdev
|         
        alloc_etherdev
|
        alloc_trdev
)
   (sizeof(T), ...)

@ rule1bis @
struct net_device *dev;
expression E;
@@
 dev->priv = E

@ rule2 depends on rule1 && !rule1bis  @
struct net_device *dev;
type rule1.T;
@@

- (T*) dev->priv
+ netdev_priv(dev)

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: jeff@garzik.org
Cc: netdev@vger.kernel.org
Cc: akpm@linux-foundation.org
---

 drivers/net/appletalk/ipddp.c |    6 +++---
 drivers/net/appletalk/ltpc.c  |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
index f22e46d..61add0e 100644
--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -109,7 +109,7 @@ static struct net_device * __init ipddp_
  */
 static struct net_device_stats *ipddp_get_stats(struct net_device *dev)
 {
-        return dev->priv;
+        return netdev_priv(dev);
 }
 
 /*
@@ -171,8 +171,8 @@ static int ipddp_xmit(struct sk_buff *sk
 
         skb->protocol = htons(ETH_P_ATALK);     /* Protocol has changed */
 
-	((struct net_device_stats *) dev->priv)->tx_packets++;
-        ((struct net_device_stats *) dev->priv)->tx_bytes+=skb->len;
+	((struct net_device_stats *)netdev_priv(dev))->tx_packets++;
+        ((struct net_device_stats *)netdev_priv(dev))->tx_bytes+=skb->len;
 
         if(aarp_send_ddp(rt->dev, skb, &rt->at, NULL) < 0)
                 dev_kfree_skb(skb);
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 6a6cbd3..be12c6b 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -726,7 +726,7 @@ static int sendup_buffer (struct net_dev
 	int dnode, snode, llaptype, len; 
 	int sklen;
 	struct sk_buff *skb;
-	struct net_device_stats *stats = &((struct ltpc_private *)dev->priv)->stats;
+	struct net_device_stats *stats = &((struct ltpc_private *)netdev_priv(dev))->stats;
 	struct lt_rcvlap *ltc = (struct lt_rcvlap *) ltdmacbuf;
 
 	if (ltc->command != LT_RCVLAP) {
@@ -823,7 +823,7 @@ static int ltpc_ioctl(struct net_device 
 {
 	struct sockaddr_at *sa = (struct sockaddr_at *) &ifr->ifr_addr;
 	/* we'll keep the localtalk node address in dev->pa_addr */
-	struct atalk_addr *aa = &((struct ltpc_private *)dev->priv)->my_addr;
+	struct atalk_addr *aa = &((struct ltpc_private *)netdev_priv(dev))->my_addr;
 	struct lt_init c;
 	int ltflags;
 
@@ -913,7 +913,7 @@ static int ltpc_xmit(struct sk_buff *skb
 	 * and skb->len is the length of the ddp data + ddp header
 	 */
 
-	struct net_device_stats *stats = &((struct ltpc_private *)dev->priv)->stats;
+	struct net_device_stats *stats = &((struct ltpc_private *)netdev_priv(dev))->stats;
 
 	int i;
 	struct lt_sendlap cbuf;
@@ -952,7 +952,7 @@ static int ltpc_xmit(struct sk_buff *skb
 
 static struct net_device_stats *ltpc_get_stats(struct net_device *dev)
 {
-	struct net_device_stats *stats = &((struct ltpc_private *) dev->priv)->stats;
+	struct net_device_stats *stats = &((struct ltpc_private *)netdev_priv(dev))->stats;
 	return stats;
 }
 

