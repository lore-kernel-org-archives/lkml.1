Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbZJBBti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbZJBBti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZJBBd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:28 -0400
Received: from kroah.org ([198.145.64.141]:33229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbZJBBd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:16 2009
Message-Id: <20091002012416.788303162@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Hartkopp <oliver@hartkopp.net>,
       Urs Thuermann <urs@isnogud.escape.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [068/136] can: fix NOHZ local_softirq_pending 08 warning
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=can-fix-nohz-local_softirq_pending-08-warning.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Hartkopp <oliver@hartkopp.net>

commit 481a8199142c050b72bff8a1956a49fd0a75bbe0 upstream.

When using nanosleep() in an userspace application we get a ratelimit warning

NOHZ: local_softirq_pending 08

for 10 times.

The echo of CAN frames is done from process context and softirq context only.
Therefore the usage of netif_rx() was wrong (for years).

This patch replaces netif_rx() with netif_rx_ni() which has to be used from
process/softirq context. It also adds a missing comment that can_send() must
no be used from hardirq context.

Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>
Signed-off-by: Urs Thuermann <urs@isnogud.escape.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/can/vcan.c |    2 +-
 net/can/af_can.c       |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -80,7 +80,7 @@ static void vcan_rx(struct sk_buff *skb,
 	skb->dev       = dev;
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-	netif_rx(skb);
+	netif_rx_ni(skb);
 }
 
 static int vcan_tx(struct sk_buff *skb, struct net_device *dev)
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -199,6 +199,8 @@ static int can_create(struct net *net, s
  * @skb: pointer to socket buffer with CAN frame in data section
  * @loop: loopback for listeners on local CAN sockets (recommended default!)
  *
+ * Due to the loopback this routine must not be called from hardirq context.
+ *
  * Return:
  *  0 on success
  *  -ENETDOWN when the selected interface is down
@@ -278,7 +280,7 @@ int can_send(struct sk_buff *skb, int lo
 	}
 
 	if (newskb)
-		netif_rx(newskb);
+		netif_rx_ni(newskb);
 
 	/* update statistics */
 	can_stats.tx_frames++;


