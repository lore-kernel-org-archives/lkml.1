Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYG2LjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYG2LjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYG2LjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:39:12 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46844 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYG2LjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:39:10 -0400
Date: Tue, 29 Jul 2008 12:37:56 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Johannes Berg <johannes@sipsolutions.net>
cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
In-Reply-To: <1217330777.10489.21.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0807291233080.3105@blonde.site>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
  <200807291049.47342.alistair@devzero.co.uk>  <1217326195.10489.10.camel@johannes.berg>
  <200807291225.00679.alistair@devzero.co.uk> <1217330777.10489.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, Johannes Berg wrote:
> 
> > If it doesn't strain you too much more, could you actually tell me where this 
> > is? Your last 5 posts to LKML don't seem to contain such a patch, and I'm not 
> > subscribed to linux-wireless.
> 
> Well, the latter has archives.

Wow, your patches seem to be a lot more helpful than your emails.
I presume it's this one below, which at first sight seems to be
working for me on iwl3945 - thank you for that.

Hugh


This patch fixes mac80211 to not use the skb->cb over the queue step
from virtual interfaces to the master. The patch also, for now,
disables aggregation because that would still require requeuing,
will fix that in a separate patch. There are two other places (software
requeue and powersaving stations) where requeue can happen, but that is
not currently used by any drivers/not possible to use respectively.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This fixes wireless. At least it works on my WPA network, I haven't
actually tested a broken kernel.

 drivers/net/wireless/ath5k/base.c           |    2 -
 drivers/net/wireless/b43/xmit.c             |    2 -
 drivers/net/wireless/b43legacy/xmit.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 -
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 -
 include/linux/skbuff.h                      |    5 ++
 include/net/mac80211.h                      |    6 ---
 net/core/skbuff.c                           |    3 +
 net/mac80211/main.c                         |    8 ----
 net/mac80211/mlme.c                         |    8 +---
 net/mac80211/tx.c                           |   47 ++++++++++++----------------
 net/mac80211/wme.c                          |    3 +
 13 files changed, 40 insertions(+), 52 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-07-29 09:08:16.000000000 +0200
+++ everything/include/net/mac80211.h	2008-07-29 11:07:41.000000000 +0200
@@ -206,8 +206,6 @@ struct ieee80211_bss_conf {
  * These flags are used with the @flags member of &ieee80211_tx_info.
  *
  * @IEEE80211_TX_CTL_REQ_TX_STATUS: request TX status callback for this frame.
- * @IEEE80211_TX_CTL_DO_NOT_ENCRYPT: send this frame without encryption;
- *	e.g., for EAPOL frame
  * @IEEE80211_TX_CTL_USE_RTS_CTS: use RTS-CTS before sending frame
  * @IEEE80211_TX_CTL_USE_CTS_PROTECT: use CTS protection for the frame (e.g.,
  *	for combined 802.11g / 802.11b networks)
@@ -220,7 +218,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_SHORT_PREAMBLE: TBD
  * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
  *	through set_retry_limit configured long retry value
- * @IEEE80211_TX_CTL_EAPOL_FRAME: internal to mac80211
  * @IEEE80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
  * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
  * @IEEE80211_TX_CTL_OFDM_HT: this frame can be sent in HT OFDM rates. number
@@ -253,7 +250,6 @@ struct ieee80211_bss_conf {
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
-	IEEE80211_TX_CTL_DO_NOT_ENCRYPT		= BIT(1),
 	IEEE80211_TX_CTL_USE_RTS_CTS		= BIT(2),
 	IEEE80211_TX_CTL_USE_CTS_PROTECT	= BIT(3),
 	IEEE80211_TX_CTL_NO_ACK			= BIT(4),
@@ -263,7 +259,6 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(8),
 	IEEE80211_TX_CTL_SHORT_PREAMBLE		= BIT(9),
 	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	= BIT(10),
-	IEEE80211_TX_CTL_EAPOL_FRAME		= BIT(11),
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(12),
 	IEEE80211_TX_CTL_AMPDU			= BIT(13),
 	IEEE80211_TX_CTL_OFDM_HT		= BIT(14),
@@ -323,7 +318,6 @@ struct ieee80211_tx_info {
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
 			unsigned long jiffies;
-			int ifindex;
 			u16 aid;
 			s8 rts_cts_rate_idx, alt_retry_rate_idx;
 			u8 retry_limit;
--- everything.orig/net/mac80211/tx.c	2008-07-29 09:08:16.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-07-29 11:09:09.000000000 +0200
@@ -439,14 +439,14 @@ ieee80211_tx_h_select_key(struct ieee802
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	u16 fc = tx->fc;
 
-	if (unlikely(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
+	if (unlikely(tx->skb->do_not_encrypt))
 		tx->key = NULL;
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
 		tx->key = key;
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !(info->flags & IEEE80211_TX_CTL_EAPOL_FRAME) &&
+		 (tx->skb->protocol != cpu_to_be16(ETH_P_PAE)) &&
 		 !(info->flags & IEEE80211_TX_CTL_INJECTED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
@@ -476,7 +476,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	}
 
 	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+		tx->skb->do_not_encrypt = 1;
 
 	return TX_CONTINUE;
 }
@@ -732,6 +732,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 		memcpy(skb_put(frag, copylen), pos, copylen);
 		memcpy(frag->cb, first->cb, sizeof(frag->cb));
 		skb_copy_queue_mapping(frag, first);
+		frag->do_not_encrypt = first->do_not_encrypt;
 
 		pos += copylen;
 		left -= copylen;
@@ -852,7 +853,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
-	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	skb->do_not_encrypt = 1;
 	info->flags |= IEEE80211_TX_CTL_INJECTED;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
@@ -925,8 +926,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 				skb_trim(skb, skb->len - FCS_LEN);
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
-				info->flags &=
-					~IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+				tx->skb->do_not_encrypt = 0;
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
@@ -1042,10 +1042,9 @@ static int ieee80211_tx_prepare(struct i
 				struct sk_buff *skb,
 				struct net_device *mdev)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct net_device *dev;
 
-	dev = dev_get_by_index(&init_net, info->control.ifindex);
+	dev = dev_get_by_index(&init_net, skb->iif);
 	if (unlikely(dev && !is_ieee80211_device(dev, mdev))) {
 		dev_put(dev);
 		dev = NULL;
@@ -1306,8 +1305,8 @@ int ieee80211_master_start_xmit(struct s
 	bool may_encrypt;
 	int ret;
 
-	if (info->control.ifindex)
-		odev = dev_get_by_index(&init_net, info->control.ifindex);
+	if (skb->iif)
+		odev = dev_get_by_index(&init_net, skb->iif);
 	if (unlikely(odev && !is_ieee80211_device(odev, dev))) {
 		dev_put(odev);
 		odev = NULL;
@@ -1321,9 +1320,13 @@ int ieee80211_master_start_xmit(struct s
 		return 0;
 	}
 
+	memset(info, 0, sizeof(*info));
+
+	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
 
-	may_encrypt = !(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT);
+	may_encrypt = !skb->do_not_encrypt;
 
 	headroom = osdata->local->tx_headroom;
 	if (may_encrypt)
@@ -1348,7 +1351,6 @@ int ieee80211_monitor_start_xmit(struct 
 				 struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	u16 len_rthdr;
@@ -1371,11 +1373,11 @@ int ieee80211_monitor_start_xmit(struct 
 	skb->dev = local->mdev;
 
 	/* needed because we set skb device to master */
-	info->control.ifindex = dev->ifindex;
+	skb->iif = dev->ifindex;
 
-	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
-	/* Interfaces should always request a status report */
-	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	/* sometimes we do encrypt injected frames, will be fixed
+	 * up in radiotap parser if not wanted */
+	skb->do_not_encrypt = 0;
 
 	/*
 	 * fix up the pointers accounting for the radiotap
@@ -1419,7 +1421,6 @@ int ieee80211_subif_start_xmit(struct sk
 			       struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
@@ -1645,14 +1646,7 @@ int ieee80211_subif_start_xmit(struct sk
 	nh_pos += hdrlen;
 	h_pos += hdrlen;
 
-	info = IEEE80211_SKB_CB(skb);
-	memset(info, 0, sizeof(*info));
-	info->control.ifindex = dev->ifindex;
-	if (ethertype == ETH_P_PAE)
-		info->flags |= IEEE80211_TX_CTL_EAPOL_FRAME;
-
-	/* Interfaces should always request a status report */
-	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	skb->iif = dev->ifindex;
 
 	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
@@ -1922,6 +1916,8 @@ struct sk_buff *ieee80211_beacon_get(str
 
 	info = IEEE80211_SKB_CB(skb);
 
+	skb->do_not_encrypt = 1;
+
 	info->band = band;
 	rate_control_get_rate(local->mdev, sband, skb, &rsel);
 
@@ -1940,7 +1936,6 @@ struct sk_buff *ieee80211_beacon_get(str
 	info->tx_rate_idx = rsel.rate_idx;
 
 	info->flags |= IEEE80211_TX_CTL_NO_ACK;
-	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
 	if (sdata->bss_conf.use_short_preamble &&
--- everything.orig/net/mac80211/mlme.c	2008-07-29 09:08:16.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-07-29 09:15:17.000000000 +0200
@@ -606,7 +606,6 @@ void ieee80211_sta_tx(struct net_device 
 		      int encrypt)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_info *info;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	skb->dev = sdata->local->mdev;
@@ -614,11 +613,8 @@ void ieee80211_sta_tx(struct net_device 
 	skb_set_network_header(skb, 0);
 	skb_set_transport_header(skb, 0);
 
-	info = IEEE80211_SKB_CB(skb);
-	memset(info, 0, sizeof(struct ieee80211_tx_info));
-	info->control.ifindex = sdata->dev->ifindex;
-	if (!encrypt)
-		info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	skb->iif = sdata->dev->ifindex;
+	skb->do_not_encrypt = !encrypt;
 
 	dev_queue_xmit(skb);
 }
--- everything.orig/include/linux/skbuff.h	2008-07-29 09:08:16.000000000 +0200
+++ everything/include/linux/skbuff.h	2008-07-29 09:15:17.000000000 +0200
@@ -316,7 +316,10 @@ struct sk_buff {
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
-	/* 14 bit hole */
+#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
+	__u8			do_not_encrypt:1;
+#endif
+	/* 0/13/14 bit hole */
 
 #ifdef CONFIG_NET_DMA
 	dma_cookie_t		dma_cookie;
--- everything.orig/net/core/skbuff.c	2008-07-29 09:15:39.000000000 +0200
+++ everything/net/core/skbuff.c	2008-07-29 09:16:13.000000000 +0200
@@ -485,6 +485,9 @@ static struct sk_buff *__skb_clone(struc
 	C(head);
 	C(data);
 	C(truesize);
+#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
+	C(do_not_encrypt);
+#endif
 	atomic_set(&n->users, 1);
 
 	atomic_inc(&(skb_shinfo(skb)->dataref));
--- everything.orig/net/mac80211/main.c	2008-07-29 09:18:20.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-29 09:19:06.000000000 +0200
@@ -1233,18 +1233,12 @@ static void ieee80211_tasklet_handler(un
 /* Remove added headers (e.g., QoS control), encryption header/MIC, etc. to
  * make a prepared TX frame (one that has been given to hw) to look like brand
  * new IEEE 802.11 frame that is ready to go through TX processing again.
- * Also, tx_packet_data in cb is restored from tx_control. */
+ */
 static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 				      struct ieee80211_key *key,
 				      struct sk_buff *skb)
 {
 	int hdrlen, iv_len, mic_len;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	info->flags &=	IEEE80211_TX_CTL_REQ_TX_STATUS |
-			IEEE80211_TX_CTL_DO_NOT_ENCRYPT |
-			IEEE80211_TX_CTL_REQUEUE |
-			IEEE80211_TX_CTL_EAPOL_FRAME;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-07-29 09:38:38.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-07-29 09:38:53.000000000 +0200
@@ -1224,7 +1224,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
 
 	pktlen = skb->len;
 
-	if (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT)) {
+	if (info->control.hw_key) {
 		keyidx = info->control.hw_key->hw_key_idx;
 		pktlen += info->control.icv_len;
 	}
--- everything.orig/drivers/net/wireless/b43/xmit.c	2008-07-29 09:39:28.000000000 +0200
+++ everything/drivers/net/wireless/b43/xmit.c	2008-07-29 09:40:19.000000000 +0200
@@ -192,7 +192,7 @@ int b43_generate_txhdr(struct b43_wldev 
 	const struct b43_phy *phy = &dev->phy;
 	const struct ieee80211_hdr *wlhdr =
 	    (const struct ieee80211_hdr *)fragment_data;
-	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
+	int use_encryption = !!info->control.hw_key;
 	__le16 fctl = wlhdr->frame_control;
 	struct ieee80211_rate *fbrate;
 	u8 rate, rate_fb;
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2008-07-29 09:39:29.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2008-07-29 09:40:25.000000000 +0200
@@ -192,7 +192,7 @@ static int generate_txhdr_fw3(struct b43
 			       u16 cookie)
 {
 	const struct ieee80211_hdr *wlhdr;
-	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
+	int use_encryption = !!info->control.hw_key;
 	u16 fctl;
 	u8 rate;
 	struct ieee80211_rate *rate_fb;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-07-29 09:39:28.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-07-29 09:39:44.000000000 +0200
@@ -906,7 +906,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 	 * first entry */
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
-	if (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
+	if (info->control.hw_key)
 		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-07-29 09:39:28.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-07-29 09:39:39.000000000 +0200
@@ -2667,7 +2667,7 @@ static int iwl3945_tx_skb(struct iwl3945
 	 * first entry */
 	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
-	if (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT))
+	if (info->control.hw_key)
 		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, 0);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-07-29 09:39:28.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-07-29 09:40:08.000000000 +0200
@@ -63,7 +63,7 @@ static int rt2x00mac_tx_rts_cts(struct r
 	 */
 	memcpy(skb->cb, frag_skb->cb, sizeof(skb->cb));
 	rts_info = IEEE80211_SKB_CB(skb);
-	rts_info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	rts_info->control.hw_key = NULL;
 	rts_info->flags &= ~IEEE80211_TX_CTL_USE_RTS_CTS;
 	rts_info->flags &= ~IEEE80211_TX_CTL_USE_CTS_PROTECT;
 	rts_info->flags &= ~IEEE80211_TX_CTL_REQ_TX_STATUS;
--- everything.orig/net/mac80211/wme.c	2008-07-29 09:45:41.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-07-29 09:47:17.000000000 +0200
@@ -188,6 +188,9 @@ int ieee80211_ht_agg_queue_add(struct ie
 {
 	int i;
 
+	/* XXX: currently broken due to cb/requeue use */
+	return -EPERM;
+
 	/* prepare the filter and save it for the SW queue
 	 * matching the received HW queue */
 
