Return-Path: <linux-kernel-owner+w=401wt.eu-S1161392AbXDKXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161392AbXDKXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161368AbXDKXDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:03:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55638 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161365AbXDKWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:42 -0400
Date: Wed, 11 Apr 2007 15:52:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Patrick McHardy <kaber@trash.net>, Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/31] Fix IFB net driver input device crashes
Message-ID: <20070411225203.GO24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ifb-net-driver-input-device-crashes.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[IFB]: Fix crash on input device removal

The input_device pointer is not refcounted, which means the device may
disappear while packets are queued, causing a crash when ifb passes packets
with a stale skb->dev pointer to netif_rx().

Fix by storing the interface index instead and do a lookup where neccessary.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ifb.c      |   35 +++++++++++++----------------------
 include/linux/skbuff.h |    5 +++--
 include/net/pkt_cls.h  |    7 +++++--
 net/core/dev.c         |    8 ++++----
 net/core/skbuff.c      |    2 +-
 net/sched/act_mirred.c |    2 +-
 6 files changed, 27 insertions(+), 32 deletions(-)

--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -96,17 +96,24 @@ static void ri_tasklet(unsigned long dev
 		skb->tc_verd = SET_TC_NCLS(skb->tc_verd);
 		stats->tx_packets++;
 		stats->tx_bytes +=skb->len;
+
+		skb->dev = __dev_get_by_index(skb->iif);
+		if (!skb->dev) {
+			dev_kfree_skb(skb);
+			stats->tx_dropped++;
+			break;
+		}
+		skb->iif = _dev->ifindex;
+
 		if (from & AT_EGRESS) {
 			dp->st_rx_frm_egr++;
 			dev_queue_xmit(skb);
 		} else if (from & AT_INGRESS) {
-
 			dp->st_rx_frm_ing++;
+			skb_pull(skb, skb->dev->hard_header_len);
 			netif_rx(skb);
-		} else {
-			dev_kfree_skb(skb);
-			stats->tx_dropped++;
-		}
+		} else
+			BUG();
 	}
 
 	if (netif_tx_trylock(_dev)) {
@@ -157,26 +164,10 @@ static int ifb_xmit(struct sk_buff *skb,
 	stats->rx_packets++;
 	stats->rx_bytes+=skb->len;
 
-	if (!from || !skb->input_dev) {
-dropped:
+	if (!(from & (AT_INGRESS|AT_EGRESS)) || !skb->iif) {
 		dev_kfree_skb(skb);
 		stats->rx_dropped++;
 		return ret;
-	} else {
-		/*
-		 * note we could be going
-		 * ingress -> egress or
-		 * egress -> ingress
-		*/
-		skb->dev = skb->input_dev;
-		skb->input_dev = dev;
-		if (from & AT_INGRESS) {
-			skb_pull(skb, skb->dev->hard_header_len);
-		} else {
-			if (!(from & AT_EGRESS)) {
-				goto dropped;
-			}
-		}
 	}
 
 	if (skb_queue_len(&dp->rq) >= dev->tx_queue_len) {
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -188,7 +188,7 @@ enum {
  *	@sk: Socket we are owned by
  *	@tstamp: Time we arrived
  *	@dev: Device we arrived on/are leaving by
- *	@input_dev: Device we arrived on
+ *	@iif: ifindex of device we arrived on
  *	@h: Transport layer header
  *	@nh: Network layer header
  *	@mac: Link layer header
@@ -235,7 +235,8 @@ struct sk_buff {
 	struct sock		*sk;
 	struct skb_timeval	tstamp;
 	struct net_device	*dev;
-	struct net_device	*input_dev;
+	int			iif;
+	/* 4 byte hole on 64 bit*/
 
 	union {
 		struct tcphdr	*th;
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -352,10 +352,13 @@ tcf_change_indev(struct tcf_proto *tp, c
 static inline int
 tcf_match_indev(struct sk_buff *skb, char *indev)
 {
+	struct net_device *dev;
+
 	if (indev[0]) {
-		if  (!skb->input_dev)
+		if  (!skb->iif)
 			return 0;
-		if (strcmp(indev, skb->input_dev->name))
+		dev = __dev_get_by_index(skb->iif);
+		if (!dev || strcmp(indev, dev->name))
 			return 0;
 	}
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1741,8 +1741,8 @@ static int ing_filter(struct sk_buff *sk
 	if (dev->qdisc_ingress) {
 		__u32 ttl = (__u32) G_TC_RTTL(skb->tc_verd);
 		if (MAX_RED_LOOP < ttl++) {
-			printk(KERN_WARNING "Redir loop detected Dropping packet (%s->%s)\n",
-				skb->input_dev->name, skb->dev->name);
+			printk(KERN_WARNING "Redir loop detected Dropping packet (%d->%d)\n",
+				skb->iif, skb->dev->ifindex);
 			return TC_ACT_SHOT;
 		}
 
@@ -1775,8 +1775,8 @@ int netif_receive_skb(struct sk_buff *sk
 	if (!skb->tstamp.off_sec)
 		net_timestamp(skb);
 
-	if (!skb->input_dev)
-		skb->input_dev = skb->dev;
+	if (!skb->iif)
+		skb->iif = skb->dev->ifindex;
 
 	orig_dev = skb_bond(skb);
 
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -497,7 +497,7 @@ struct sk_buff *skb_clone(struct sk_buff
 	n->tc_verd = SET_TC_VERD(skb->tc_verd,0);
 	n->tc_verd = CLR_TC_OK2MUNGE(n->tc_verd);
 	n->tc_verd = CLR_TC_MUNGED(n->tc_verd);
-	C(input_dev);
+	C(iif);
 #endif
 	skb_copy_secmark(n, skb);
 #endif
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -199,7 +199,7 @@ bad_mirred:
 		skb2->tc_verd = SET_TC_FROM(skb2->tc_verd, at);
 
 	skb2->dev = dev;
-	skb2->input_dev = skb->dev;
+	skb2->iif = skb->dev->ifindex;
 	dev_queue_xmit(skb2);
 	spin_unlock(&m->tcf_lock);
 	return m->tcf_action;

-- 
