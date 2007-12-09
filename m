Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbXLIUFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbXLIUFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 15:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXLIUFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 15:05:34 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:36373 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXLIUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 15:05:33 -0500
Date: Sun, 9 Dec 2007 21:05:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: fpavlic@de.ibm.com, wangchen@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] Fix use of skb after netif_rx
Message-ID: <Pine.LNX.4.64.0712092103560.11165@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Recently, Wang Chen submitted a patch
(d30f53aeb31d453a5230f526bea592af07944564) to move a call to netif_rx(skb)
after a subsequent reference to skb, because netif_rx may call kfree_skb on
its argument.  netif_rx_ni calls netif_rx, so the same problem occurs in
the files below.

I have left the updating of dev->last_rx after the calls to netif_rx_ni
because it seems time dependent, but moved the other field updates before.

This was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression skb, e,e1;
@@

(
 netif_rx(skb);
|
 netif_rx_ni(skb);
)
  ... when != skb = e
(
  skb = e1
|
* skb
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff a/drivers/s390/net/ctcmain.c b/drivers/s390/net/ctcmain.c
--- a/drivers/s390/net/ctcmain.c	2007-12-05 09:21:56.000000000 +0100
+++ b/drivers/s390/net/ctcmain.c	2007-12-05 19:03:40.000000000 +0100
@@ -478,14 +478,14 @@ ctc_unpack_skb(struct channel *ch, struc
 		skb->dev = pskb->dev;
 		skb->protocol = pskb->protocol;
 		pskb->ip_summed = CHECKSUM_UNNECESSARY;
-		netif_rx_ni(skb);
 		/**
-		 * Successful rx; reset logflags
+		 * reset logflags
 		 */
 		ch->logflags = 0;
-		dev->last_rx = jiffies;
 		privptr->stats.rx_packets++;
 		privptr->stats.rx_bytes += skb->len;
+		netif_rx_ni(skb);
+		dev->last_rx = jiffies;
 		if (len > 0) {
 			skb_pull(pskb, header->length);
 			if (skb_tailroom(pskb) < LL_HEADER_LENGTH) {
diff a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c	2007-10-22 11:25:20.000000000 +0200
+++ b/drivers/s390/net/netiucv.c	2007-12-05 19:03:10.000000000 +0100
@@ -639,14 +639,14 @@ static void netiucv_unpack_skb(struct iu
 		skb->dev = pskb->dev;
 		skb->protocol = pskb->protocol;
 		pskb->ip_summed = CHECKSUM_UNNECESSARY;
+		privptr->stats.rx_packets++;
+		privptr->stats.rx_bytes += skb->len;
 		/*
 		 * Since receiving is always initiated from a tasklet (in iucv.c),
 		 * we must use netif_rx_ni() instead of netif_rx()
 		 */
 		netif_rx_ni(skb);
 		dev->last_rx = jiffies;
-		privptr->stats.rx_packets++;
-		privptr->stats.rx_bytes += skb->len;
 		skb_pull(pskb, header->next);
 		skb_put(pskb, NETIUCV_HDRLEN);
 	}
