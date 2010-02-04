Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab0BDR3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:29:30 -0500
Received: from kroah.org ([198.145.64.141]:34840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304Ab0BDRWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:10 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:15 2010
Message-Id: <20100204171514.818399920@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [47/74] af_packet: Dont use skb after dev_queue_xmit()
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit eb70df13ee52dbc0f2c0ffd8ed34a8cd27440baf ]

tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
which is illegal.

With debugging by: Stephen Hemminger <shemminger@vyatta.com>

Reported-by: Michael Breuer <mbreuer@majjas.com>
With help from: David S. Miller <davem@davemloft.net>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Tested-by: Michael Breuer<mbreuer@majjas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/packet/af_packet.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1028,8 +1028,20 @@ static int tpacket_snd(struct packet_soc
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = dev_queue_xmit(skb);
-		if (unlikely(err > 0 && (err = net_xmit_errno(err)) != 0))
-			goto out_xmit;
+		if (unlikely(err > 0)) {
+			err = net_xmit_errno(err);
+			if (err && __packet_get_status(po, ph) ==
+				   TP_STATUS_AVAILABLE) {
+				/* skb was destructed already */
+				skb = NULL;
+				goto out_status;
+			}
+			/*
+			 * skb was dropped but not destructed yet;
+			 * let's treat it like congestion or err < 0
+			 */
+			err = 0;
+		}
 		packet_increment_head(&po->tx_ring);
 		len_sum += tp_len;
 	} while (likely((ph != NULL) || ((!(msg->msg_flags & MSG_DONTWAIT))
@@ -1039,9 +1051,6 @@ static int tpacket_snd(struct packet_soc
 	err = len_sum;
 	goto out_put;
 
-out_xmit:
-	skb->destructor = sock_wfree;
-	atomic_dec(&po->tx_ring.pending);
 out_status:
 	__packet_set_status(po, ph, status);
 	kfree_skb(skb);


