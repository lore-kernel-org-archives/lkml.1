Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbYEMUTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbYEMUTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762196AbYEMUOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:53 -0400
Received: from ns.suse.de ([195.135.220.2]:38049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762187AbYEMUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:51 -0400
Date: Tue, 13 May 2008 13:12:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Hartkopp <oliver@hartkopp.net>,
       Urs Thuermann <urs@isnogud.escape.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/37] can: Fix can_send() handling on dev_queue_xmit()
	failures
Message-ID: <20080513201211.GR31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="can-fix-can_send-handling-on-dev_queue_xmit-failures.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Oliver Hartkopp <oliver@hartkopp.net>

[ Upstream commit: c2ab7ac225e29006b7117d6a9fe8f3be8d98b0c2 ]

The tx packet counting and the local loopback of CAN frames should
only happen in the case that the CAN frame has been enqueued to the
netdevice tx queue successfully.

Thanks to Andre Naujoks <nautsch@gmail.com> for reporting this issue.

Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>
Signed-off-by: Urs Thuermann <urs@isnogud.escape.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/af_can.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -208,6 +208,7 @@ static int can_create(struct net *net, s
  */
 int can_send(struct sk_buff *skb, int loop)
 {
+	struct sk_buff *newskb = NULL;
 	int err;
 
 	if (skb->dev->type != ARPHRD_CAN) {
@@ -244,8 +245,7 @@ int can_send(struct sk_buff *skb, int lo
 			 * If the interface is not capable to do loopback
 			 * itself, we do it here.
 			 */
-			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
-
+			newskb = skb_clone(skb, GFP_ATOMIC);
 			if (!newskb) {
 				kfree_skb(skb);
 				return -ENOMEM;
@@ -254,7 +254,6 @@ int can_send(struct sk_buff *skb, int lo
 			newskb->sk = skb->sk;
 			newskb->ip_summed = CHECKSUM_UNNECESSARY;
 			newskb->pkt_type = PACKET_BROADCAST;
-			netif_rx(newskb);
 		}
 	} else {
 		/* indication for the CAN driver: no loopback required */
@@ -266,11 +265,20 @@ int can_send(struct sk_buff *skb, int lo
 	if (err > 0)
 		err = net_xmit_errno(err);
 
+	if (err) {
+		if (newskb)
+			kfree_skb(newskb);
+		return err;
+	}
+
+	if (newskb)
+		netif_rx(newskb);
+
 	/* update statistics */
 	can_stats.tx_frames++;
 	can_stats.tx_frames_delta++;
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(can_send);
 

-- 
