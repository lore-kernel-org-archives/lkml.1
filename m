Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbYBGVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbYBGVH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933467AbYBGUwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933451AbYBGUwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:51 -0500
Date: Thu, 7 Feb 2008 12:47:54 -0800
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
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 32/45] b43: Drop packets we are not able to encrypt
Message-ID: <20080207204754.GG16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-drop-packets-we-are-not-able-to-encrypt.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

patch 09552ccd8277e6382097e93a40f7311a09449367 in mainline

We must drop any packets we are not able to encrypt.
We must not send them unencrypted or with an all-zero-key (which
basically is the same as unencrypted, from a security point of view).

This might only trigger shortly after resume before mac80211 reassociated
and reconfigured the keys.

It is safe to drop these packets, as the association they belong to
is not guaranteed anymore anyway.
This is a security fix in the sense that it prevents information leakage.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c  |   11 ++++++++++-
 drivers/net/wireless/b43/xmit.c |   20 +++++++++++++++-----
 drivers/net/wireless/b43/xmit.h |    2 +-
 3 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1122,9 +1122,11 @@ static int dma_tx_fragment(struct b43_dm
 	memset(meta_hdr, 0, sizeof(*meta_hdr));
 
 	header = &(ring->txhdr_cache[slot * sizeof(struct b43_txhdr_fw4)]);
-	b43_generate_txhdr(ring->dev, header,
+	err = b43_generate_txhdr(ring->dev, header,
 			   skb->data, skb->len, ctl,
 			   generate_cookie(ring, slot));
+	if (unlikely(err))
+		return err;
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   sizeof(struct b43_txhdr_fw4), 1);
@@ -1219,6 +1221,13 @@ int b43_dma_tx(struct b43_wldev *dev,
 	B43_WARN_ON(ring->stopped);
 
 	err = dma_tx_fragment(ring, skb, ctl);
+	if (unlikely(err == -ENOKEY)) {
+		/* Drop this packet, as we don't have the encryption key
+		 * anymore and must not transmit it unencrypted. */
+		dev_kfree_skb_any(skb);
+		err = 0;
+		goto out_unlock;
+	}
 	if (unlikely(err)) {
 		b43err(dev->wl, "DMA tx mapping failure\n");
 		goto out_unlock;
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -177,7 +177,7 @@ static u8 b43_calc_fallback_rate(u8 bitr
 	return 0;
 }
 
-static void generate_txhdr_fw4(struct b43_wldev *dev,
+static int generate_txhdr_fw4(struct b43_wldev *dev,
 			       struct b43_txhdr_fw4 *txhdr,
 			       const unsigned char *fragment_data,
 			       unsigned int fragment_len,
@@ -235,7 +235,15 @@ static void generate_txhdr_fw4(struct b4
 
 		B43_WARN_ON(key_idx >= dev->max_nr_keys);
 		key = &(dev->key[key_idx]);
-		B43_WARN_ON(!key->keyconf);
+
+		if (unlikely(!key->keyconf)) {
+			/* This key is invalid. This might only happen
+			 * in a short timeframe after machine resume before
+			 * we were able to reconfigure keys.
+			 * Drop this packet completely. Do not transmit it
+			 * unencrypted to avoid leaking information. */
+			return -ENOKEY;
+		}
 
 		/* Hardware appends ICV. */
 		plcp_fragment_len += txctl->icv_len;
@@ -352,16 +360,18 @@ static void generate_txhdr_fw4(struct b4
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
 	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
 	txhdr->extra_ft = extra_ft;
+
+	return 0;
 }
 
-void b43_generate_txhdr(struct b43_wldev *dev,
+int b43_generate_txhdr(struct b43_wldev *dev,
 			u8 * txhdr,
 			const unsigned char *fragment_data,
 			unsigned int fragment_len,
 			const struct ieee80211_tx_control *txctl, u16 cookie)
 {
-	generate_txhdr_fw4(dev, (struct b43_txhdr_fw4 *)txhdr,
-			   fragment_data, fragment_len, txctl, cookie);
+	return generate_txhdr_fw4(dev, (struct b43_txhdr_fw4 *)txhdr,
+				  fragment_data, fragment_len, txctl, cookie);
 }
 
 static s8 b43_rssi_postprocess(struct b43_wldev *dev,
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -82,7 +82,7 @@ struct b43_txhdr_fw4 {
 #define  B43_TX4_PHY_ANT1		0x0100	/* Use antenna 1 */
 #define  B43_TX4_PHY_ANTLAST	0x0300	/* Use last used antenna */
 
-void b43_generate_txhdr(struct b43_wldev *dev,
+int b43_generate_txhdr(struct b43_wldev *dev,
 			u8 * txhdr,
 			const unsigned char *fragment_data,
 			unsigned int fragment_len,

-- 
