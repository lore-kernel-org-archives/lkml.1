Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936386Ab0CMBUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:20:38 -0500
Received: from kroah.org ([198.145.64.141]:60930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934952Ab0CMAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.628373592@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 074/123] ath5k: use correct packet type when transmitting
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Bob Copeland <me@bobcopeland.com>

commit 2ac2927a953a01c83df255118922cce1523d1a18 upstream.

The hardware needs to know what type of frames are being
sent in order to fill in various fields, for example the
timestamp in probe responses (before this patch, it was
always 0).  Set it correctly when initializing the TX
descriptor.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 -
 drivers/net/wireless/ath/ath5k/base.c  |   26 +++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -541,7 +541,6 @@ struct ath5k_txq_info {
 /*
  * Transmit packet types.
  * used on tx control descriptor
- * TODO: Use them inside base.c corectly
  */
 enum ath5k_pkt_type {
 	AR5K_PKT_TYPE_NORMAL		= 0,
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1246,6 +1246,29 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
 	return 0;
 }
 
+static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	enum ath5k_pkt_type htype;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	if (ieee80211_is_beacon(fc))
+		htype = AR5K_PKT_TYPE_BEACON;
+	else if (ieee80211_is_probe_resp(fc))
+		htype = AR5K_PKT_TYPE_PROBE_RESP;
+	else if (ieee80211_is_atim(fc))
+		htype = AR5K_PKT_TYPE_ATIM;
+	else if (ieee80211_is_pspoll(fc))
+		htype = AR5K_PKT_TYPE_PSPOLL;
+	else
+		htype = AR5K_PKT_TYPE_NORMAL;
+
+	return htype;
+}
+
 static int
 ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		  struct ath5k_txq *txq)
@@ -1300,7 +1323,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
 			sc->vif, pktlen, info));
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
-		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
+		ieee80211_get_hdrlen_from_skb(skb),
+		get_hw_packet_type(skb),
 		(sc->power_level * 2),
 		hw_rate,
 		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,


