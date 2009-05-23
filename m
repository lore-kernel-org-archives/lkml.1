Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZEWLrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZEWLrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 07:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZEWLrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 07:47:10 -0400
Received: from xi.wantstofly.org ([80.101.37.227]:37481 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZEWLrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 07:47:09 -0400
Date: Sat, 23 May 2009 13:51:43 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Andy Fleming <afleming@freescale.com>,
       Michael Guntsche <mike@it-loops.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH,RFC] gianfar: fix BUG under load after introduction of skb recycling
Message-ID: <20090523115143.GB1672@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 0fd56bb5be6455d0d42241e65aed057244665e5e ("gianfar:
Add support for skb recycling"), gianfar puts skbuffs that are in
the rx ring back onto the recycle list as-is in case there was a
receive error, but this breaks the following invariant: that all
skbuffs on the recycle list have skb->data = skb->head + NET_SKB_PAD.

The RXBUF_ALIGNMENT realignment done in gfar_new_skb() will be done
twice on skbuffs recycled in this way, causing there not to be enough
room in the skb anymore to receive a full packet, eventually leading
to an skb_over_panic from gfar_clean_rx_ring() -> skb_put().

Resetting the skb->data pointer to skb->head + NET_SKB_PAD before
putting the skb back onto the recycle list restores the mentioned
invariant, and should fix this issue.

Reported-by: Michael Guntsche <mike@it-loops.com>
Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
This might/should/could fix http://bugzilla.kernel.org/show_bug.cgi?id=13293

Michael, can you re-test with this version of the patch?
Andy, can you see if this is OK with you?

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index b2c4967..a051918 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1885,8 +1885,17 @@ int gfar_clean_rx_ring(struct net_device *dev, int rx_work_limit)
 
 			if (unlikely(!newskb))
 				newskb = skb;
-			else if (skb)
+			else if (skb) {
+				/*
+				 * We need to reset ->data to what it
+				 * was before gfar_new_skb() re-aligned
+				 * it to an RXBUF_ALIGNMENT boundary
+				 * before we put the skb back on the
+				 * recycle list.
+				 */
+				skb->data = skb->head + NET_SKB_PAD;
 				__skb_queue_head(&priv->rx_recycle, skb);
+			}
 		} else {
 			/* Increment the number of packets */
 			dev->stats.rx_packets++;
-- 
1.5.6.4

