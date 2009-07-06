Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZGFS0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZGFS0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZGFS0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:26:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35161 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbZGFS0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:26:13 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 14:26:13 EDT
Message-ID: <4A523CB0.8080005@polymtl.ca>
Date: Mon, 06 Jul 2009 14:04:32 -0400
From: Benjamin Poirier <benjamin.poirier@polymtl.ca>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tcpdump-workers@lists.tcpdump.org, wireshark-dev@wireshark.org
Subject: [PATCH] net: Take GSO into account when capturing packets
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (hal.drap.polymtl.ca [132.207.162.51]) at Mon,  6 Jul 2009 18:04:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the point where the support routine for packet capture is called to
better reflect what is transmitted on the wire when GSO is active.

At the moment, packet capture (a la tcpdump) on the transmission side happens
before GSO takes place (if it does). Therefore, even if a packet gets
segmented by GSO, the capture shows that one big packet was sent when in fact
many small packets were sent on the wire. This behavior does not reflect the
"reality" of what is transmitted and could lead to confusion, especially since
a capture on the receiving side shows the segmented packets.

Signed-off-by: Benjamin Poirier <benjamin.poirier@polymtl.ca>

---

I've tested that the patch does what it intends to do by taking a capture on
the sending and receiving side of a network benchmark that sends incrementally
larger chunks of data. Without the patch, Wireshark shows that frames larger
than the MTU were sent as is and it shows that they were received as many
smaller frames. With the patch it shows that many small frames were sent and
received.

I would've liked to test the performance impact of the additional
list_empty() tests in the GSO loop but unfortunately I'm already limited by
the network speed, not the cpu. Fast Ethernet, blah

 net/core/dev.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 70c27e0..e87bbaf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1686,9 +1686,6 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 	int rc;
 
 	if (likely(!skb->next)) {
-		if (!list_empty(&ptype_all))
-			dev_queue_xmit_nit(skb, dev);
-
 		if (netif_needs_gso(dev, skb)) {
 			if (unlikely(dev_gso_segment(skb)))
 				goto out_kfree_skb;
@@ -1696,6 +1693,9 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				goto gso;
 		}
 
+		if (!list_empty(&ptype_all))
+			dev_queue_xmit_nit(skb, dev);
+
 		/*
 		 * If device doesnt need skb->dst, release it right now while
 		 * its hot in this cpu cache
@@ -1729,6 +1729,10 @@ gso:
 
 		skb->next = nskb->next;
 		nskb->next = NULL;
+
+		if (!list_empty(&ptype_all))
+			dev_queue_xmit_nit(nskb, dev);
+
 		rc = ops->ndo_start_xmit(nskb, dev);
 		if (unlikely(rc)) {
 			nskb->next = skb->next;
-- 
1.6.3.3

