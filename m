Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbXLIUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbXLIUCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 15:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXLIUCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 15:02:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33049 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXLIUCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 15:02:35 -0500
Date: Sun, 9 Dec 2007 21:02:31 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jdike@karaya.com, wangchen@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] Fix use of skb after netif_rx
Message-ID: <Pine.LNX.4.64.0712092101160.11165@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Recently, Wang Chen submitted a patch
(d30f53aeb31d453a5230f526bea592af07944564) to move a call to netif_rx(skb)
after a subsequent reference to skb, because netif_rx may call kfree_skb on
its argument.  The same problem occurs in some other drivers as well.

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

diff a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c	2007-11-15 15:09:36.000000000 +0100
+++ b/arch/um/drivers/net_kern.c	2007-12-05 19:01:14.000000000 +0100
@@ -98,10 +98,10 @@ static int uml_net_rx(struct net_device 
 	if (pkt_len > 0) {
 		skb_trim(skb, pkt_len);
 		skb->protocol = (*lp->protocol)(skb);
-		netif_rx(skb);
 
 		lp->stats.rx_bytes += skb->len;
 		lp->stats.rx_packets++;
+		netif_rx(skb);
 		return pkt_len;
 	}
 
