Return-Path: <linux-kernel-owner+w=401wt.eu-S1765364AbXKOGYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765364AbXKOGYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764175AbXKOGVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45864 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764826AbXKOGVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:44 -0500
Date: Wed, 14 Nov 2007 22:20:08 -0800
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
       warmcat <andy@warmcat.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 02/23] mac80211: Improve sanity checks on injected packets
Message-ID: <20071115062008.GC8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-improve-sanity-checks-on-injected-packets.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Green <andy@warmcat.com>

patch 9b8a74e3482f9fc077a88c13fa0ceca8feb0b772 in mainline.

Michael Wu noticed that the skb length checking is not taken care of enough when
a packet is presented on the Monitor interface for injection.

This patch improves the sanity checking and removes fake offsets placed
into the skb network and transport header.

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211.c |   48 +++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1680,46 +1680,54 @@ int ieee80211_monitor_start_xmit(struct 
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
-	u16 len;
+	u16 len_rthdr;
 
-	/*
-	 * there must be a radiotap header at the
-	 * start in this case
-	 */
-	if (unlikely(prthdr->it_version)) {
-		/* only version 0 is supported */
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
+	/* check for not even having the fixed radiotap header part */
+	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
+		goto fail; /* too short to be possibly valid */
+
+	/* is it a header version we can trust to find length from? */
+	if (unlikely(prthdr->it_version))
+		goto fail; /* only version 0 is supported */
+
+	/* then there must be a radiotap header with a length we can use */
+	len_rthdr = ieee80211_get_radiotap_len(skb);
+
+	/* does the skb contain enough to deliver on the alleged length? */
+	if (unlikely(skb->len < len_rthdr))
+		goto fail; /* skb too short for claimed rt header extent */
 
 	skb->dev = local->mdev;
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(*pkt_data));
+	/* needed because we set skb device to master */
 	pkt_data->ifindex = dev->ifindex;
+
 	pkt_data->mgmt_iface = 0;
 	pkt_data->do_not_encrypt = 1;
 
-	/* above needed because we set skb device to master */
-
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
 	 * a precooked IEEE80211 header so no need for
 	 * normal processing
 	 */
-	len = le16_to_cpu(get_unaligned(&prthdr->it_len));
-	skb_set_mac_header(skb, len);
-	skb_set_network_header(skb, len + sizeof(struct ieee80211_hdr));
-	skb_set_transport_header(skb, len + sizeof(struct ieee80211_hdr));
-
+	skb_set_mac_header(skb, len_rthdr);
 	/*
-	 * pass the radiotap header up to
-	 * the next stage intact
+	 * these are just fixed to the end of the rt area since we
+	 * don't have any better information and at this point, nobody cares
 	 */
-	dev_queue_xmit(skb);
+	skb_set_network_header(skb, len_rthdr);
+	skb_set_transport_header(skb, len_rthdr);
 
+	/* pass the radiotap header up to the next stage intact */
+	dev_queue_xmit(skb);
 	return NETDEV_TX_OK;
+
+fail:
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK; /* meaning, we dealt with the skb */
 }
 
 

-- 
