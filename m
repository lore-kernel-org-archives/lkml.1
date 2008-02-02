Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbYBBAco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbYBBAco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763175AbYBBAZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:55796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761775AbYBBAZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:26 -0500
Date: Fri, 1 Feb 2008 16:21:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
       greearb@candelatech.com, divy@chelsio.com,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 23/27] cxgb: fix T2 GSO
Message-ID: <20080202002106.GX8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cxgb-fix-t2-gso.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Divy Le Ray <divy@chelsio.com>

patch 7832ee034b6ef78aab020c9ec1348544cd65ccbd in mainline.

The patch ensures that a GSO skb has enough headroom
to push an encapsulating cpl_tx_pkt_lso header.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/chelsio/cxgb2.c |    3 ++-
 drivers/net/chelsio/sge.c   |   34 +++++++++++++++-------------------
 drivers/net/chelsio/sge.h   |    1 +
 3 files changed, 18 insertions(+), 20 deletions(-)

--- a/drivers/net/chelsio/cxgb2.c
+++ b/drivers/net/chelsio/cxgb2.c
@@ -397,7 +397,8 @@ static char stats_strings[][ETH_GSTRING_
 	"TxTso",
 	"RxVlan",
 	"TxVlan",
-
+	"TxNeedHeadroom",
+
 	/* Interrupt stats */
 	"rx drops",
 	"pure_rsps",
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -991,6 +991,7 @@ void t1_sge_get_port_stats(const struct 
 		ss->tx_packets += st->tx_packets;
 		ss->tx_cso += st->tx_cso;
 		ss->tx_tso += st->tx_tso;
+		ss->tx_need_hdrroom += st->tx_need_hdrroom;
 		ss->vlan_xtract += st->vlan_xtract;
 		ss->vlan_insert += st->vlan_insert;
 	}
@@ -1851,7 +1852,8 @@ int t1_start_xmit(struct sk_buff *skb, s
 {
 	struct adapter *adapter = dev->priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port], smp_processor_id());
+	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port],
+						smp_processor_id());
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
@@ -1859,6 +1861,18 @@ int t1_start_xmit(struct sk_buff *skb, s
 	if (skb->protocol == htons(ETH_P_CPL5))
 		goto send;
 
+	/*
+	 * We are using a non-standard hard_header_len.
+	 * Allocate more header room in the rare cases it is not big enough.
+	 */
+	if (unlikely(skb_headroom(skb) < dev->hard_header_len - ETH_HLEN)) {
+		skb = skb_realloc_headroom(skb, sizeof(struct cpl_tx_pkt_lso));
+		++st->tx_need_hdrroom;
+		dev_kfree_skb_any(orig_skb);
+		if (!skb)
+			return NETDEV_TX_OK;
+	}
+
 	if (skb_shinfo(skb)->gso_size) {
 		int eth_type;
 		struct cpl_tx_pkt_lso *hdr;
@@ -1892,24 +1906,6 @@ int t1_start_xmit(struct sk_buff *skb, s
 			return NETDEV_TX_OK;
 		}
 
-		/*
-		 * We are using a non-standard hard_header_len and some kernel
-		 * components, such as pktgen, do not handle it right.
-		 * Complain when this happens but try to fix things up.
-		 */
-		if (unlikely(skb_headroom(skb) < dev->hard_header_len - ETH_HLEN)) {
-			pr_debug("%s: headroom %d header_len %d\n", dev->name,
-				 skb_headroom(skb), dev->hard_header_len);
-
-			if (net_ratelimit())
-				printk(KERN_ERR "%s: inadequate headroom in "
-				       "Tx packet\n", dev->name);
-			skb = skb_realloc_headroom(skb, sizeof(*cpl));
-			dev_kfree_skb_any(orig_skb);
-			if (!skb)
-				return NETDEV_TX_OK;
-		}
-
 		if (!(adapter->flags & UDP_CSUM_CAPABLE) &&
 		    skb->ip_summed == CHECKSUM_PARTIAL &&
 		    ip_hdr(skb)->protocol == IPPROTO_UDP) {
--- a/drivers/net/chelsio/sge.h
+++ b/drivers/net/chelsio/sge.h
@@ -64,6 +64,7 @@ struct sge_port_stats {
 	u64 tx_tso;          /* # of TSO requests */
 	u64 vlan_xtract;     /* # of VLAN tag extractions */
 	u64 vlan_insert;     /* # of VLAN tag insertions */
+	u64 tx_need_hdrroom; /* # of TX skbs in need of more header room */
 };
 
 struct sk_buff;

-- 
