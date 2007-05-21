Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbXEUTga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbXEUTga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765533AbXEUTW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46513 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765024AbXEUTWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:22 -0400
Message-Id: <20070521191641.705484000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Horman <nhorman@tuxdriver.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 02/69] sis900: Allocate rx replacement buffer before rx operation
Content-Disposition: inline; filename=sis900-allocate-rx-replacement-buffer-before-rx-operation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Neil Horman <nhorman@tuxdriver.com>

Just found a hole in my last patch.  It was reported to me that shortly after we
integrated this patch.  The report was of an oops that took place inside of
netif_rx when using the sis900 driver.  Looking at my origional patch I noted
that there was a spot between the new skb_alloc and the refill_rx_ring label
where skb got reassigned to the pointer currently held in the rx_ring for the
purposes of receiveing the frame.  The result of this is however that the buffer
that gets passed to netif_rx (if it is called), then gets placed right back into
the rx_ring.  So if you receive frames fast enough the skb being processed by
the network stack can get corrupted.  The reporter is testing out the fix I've
written for this below (I'm not near my hardware at the moment to test myself),
but I wanted to post it for review ASAP.  I'll post test results when I hear
them, but I think this is a pretty straightforward fix.  It just uses a separate
pointer to do the rx operation, so that we don't improperly reassign the pointer
that we use to refill the rx ring.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/sis900.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/sis900.c
+++ linux-2.6.21.1/drivers/net/sis900.c
@@ -1754,6 +1754,7 @@ static int sis900_rx(struct net_device *
 			sis_priv->rx_ring[entry].cmdsts = RX_BUF_SIZE;
 		} else {
 			struct sk_buff * skb;
+			struct sk_buff * rx_skb;
 
 			pci_unmap_single(sis_priv->pci_dev,
 				sis_priv->rx_ring[entry].bufptr, RX_BUF_SIZE,
@@ -1787,10 +1788,10 @@ static int sis900_rx(struct net_device *
 			}
 
 			/* give the socket buffer to upper layers */
-			skb = sis_priv->rx_skbuff[entry];
-			skb_put(skb, rx_size);
-			skb->protocol = eth_type_trans(skb, net_dev);
-			netif_rx(skb);
+			rx_skb = sis_priv->rx_skbuff[entry];
+			skb_put(rx_skb, rx_size);
+			rx_skb->protocol = eth_type_trans(rx_skb, net_dev);
+			netif_rx(rx_skb);
 
 			/* some network statistics */
 			if ((rx_status & BCAST) == MCAST)

-- 
