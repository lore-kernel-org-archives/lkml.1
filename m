Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYDPXZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYDPXZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbYDPXYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:24:23 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:34408 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756646AbYDPXYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KRSg6DEpH55uZq/qVbMW5gmYLO00TG02gyWEeq2AGKF18KtknRVaXkdJKmXDAcOt3S8e25UmcZy6RLLE2dIDlb14UHQw05O1+anWy78QGaT88TesBlNXchHLgqPaSRIrup4qasnDe6ggwUbW3VBbKbYI9e9j9eXfWqR/JqZEgR4=
Subject: [PATCH-mm 3/5] mac80211: add a struct to hold tkip context
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Benc <jbenc@suse.cz>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:24:25 -0700
Message-Id: <1208388265.11920.127.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/cfg.c         |    4 +-
 net/mac80211/debugfs_key.c |    8 +++---
 net/mac80211/key.h         |   17 +++++++------
 net/mac80211/tkip.c        |   54 ++++++++++++++++++++++----------------------
 net/mac80211/wpa.c         |   16 ++++++------
 5 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8af576c..88e1904 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -254,8 +254,8 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	case ALG_TKIP:
 		params.cipher = WLAN_CIPHER_SUITE_TKIP;
 
-		iv32 = key->u.tkip.iv32;
-		iv16 = key->u.tkip.iv16;
+		iv32 = key->u.tkip.tx.iv32;
+		iv16 = key->u.tkip.tx.iv16;
 
 		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 		    sdata->local->ops->get_tkip_seq)
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 879e721..c13b08b 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -97,8 +97,8 @@ static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
 		break;
 	case ALG_TKIP:
 		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
-				key->u.tkip.iv32,
-				key->u.tkip.iv16);
+				key->u.tkip.tx.iv32,
+				key->u.tkip.tx.iv16);
 		break;
 	case ALG_CCMP:
 		tpn = key->u.ccmp.tx_pn;
@@ -128,8 +128,8 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%08x %04x\n",
-				       key->u.tkip.iv32_rx[i],
-				       key->u.tkip.iv16_rx[i]);
+				       key->u.tkip.rx[i].iv32,
+				       key->u.tkip.rx[i].iv16);
 		len = p - buf;
 		break;
 	case ALG_CCMP:
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 5d48518..b378cf4 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -66,6 +66,13 @@ enum ieee80211_internal_key_flags {
 	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(4),
 };
 
+struct tkip_ctx {
+	u32 iv32;
+	u16 iv16;
+	u16 p1k[5];
+	int initialized;
+};
+
 struct ieee80211_key {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -82,16 +89,10 @@ struct ieee80211_key {
 	union {
 		struct {
 			/* last used TSC */
-			u32 iv32;
-			u16 iv16;
-			u16 p1k[5];
-			int tx_initialized;
+			struct tkip_ctx tx;
 
 			/* last received RSC */
-			u32 iv32_rx[NUM_RX_DATA_QUEUES];
-			u16 iv16_rx[NUM_RX_DATA_QUEUES];
-			u16 p1k_rx[NUM_RX_DATA_QUEUES][5];
-			int rx_initialized[NUM_RX_DATA_QUEUES];
+			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
 		} tkip;
 		struct {
 			u8 tx_pn[6];
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index f5815ac..00a3734 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -138,7 +138,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 	*pos++ = iv1;
 	*pos++ = iv2;
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	put_unaligned_le32(key->u.tkip.iv32, pos);
+	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
 	return pos + 4;
 }
 
@@ -146,16 +146,16 @@ void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
-	if (key->u.tkip.iv16 == 0 || !key->u.tkip.tx_initialized) {
+	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   key->u.tkip.iv32, key->u.tkip.p1k);
-		key->u.tkip.tx_initialized = 1;
+				   key->u.tkip.tx.iv32, key->u.tkip.tx.p1k);
+		key->u.tkip.tx.initialized = 1;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k,
+	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv16, rc4key);
+			   key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -180,9 +180,9 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
 			iv16, iv32);
 
-	if (iv32 != key->u.tkip.iv32) {
+	if (iv32 != key->u.tkip.tx.iv32) {
 		printk(KERN_DEBUG "skb: iv32 = 0x%08x key: iv32 = 0x%08x\n",
-			iv32, key->u.tkip.iv32);
+			iv32, key->u.tkip.tx.iv32);
 		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
 			"fragmented packet\n");
 	}
@@ -191,19 +191,19 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !key->u.tkip.tx_initialized) {
+	if (iv16 == 0 || !key->u.tkip.tx.initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			iv32, key->u.tkip.p1k);
-		key->u.tkip.tx_initialized = 1;
+			iv32, key->u.tkip.tx.p1k);
+		key->u.tkip.tx.initialized = 1;
 	}
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
-		memcpy(outkey, key->u.tkip.p1k, sizeof(u16) * 5);
+		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k,
+	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
@@ -264,33 +264,33 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;
 
-	if (key->u.tkip.rx_initialized[queue] &&
-	    (iv32 < key->u.tkip.iv32_rx[queue] ||
-	     (iv32 == key->u.tkip.iv32_rx[queue] &&
-	      iv16 <= key->u.tkip.iv16_rx[queue]))) {
+	if (key->u.tkip.rx[queue].initialized &&
+	    (iv32 < key->u.tkip.rx[queue].iv32 ||
+	     (iv32 == key->u.tkip.rx[queue].iv32 &&
+	      iv16 <= key->u.tkip.rx[queue].iv16))) {
 #ifdef CONFIG_TKIP_DEBUG
 		DECLARE_MAC_BUF(mac);
 		printk(KERN_DEBUG "TKIP replay detected for RX frame from "
 		       "%s (RX IV (%04x,%02x) <= prev. IV (%04x,%02x)\n",
 		       print_mac(mac, ta),
-		       iv32, iv16, key->u.tkip.iv32_rx[queue],
-		       key->u.tkip.iv16_rx[queue]);
+		       iv32, iv16, key->u.tkip.rx[queue].iv32,
+		       key->u.tkip.rx[queue].iv16);
 #endif /* CONFIG_TKIP_DEBUG */
 		return TKIP_DECRYPT_REPLAY;
 	}
 
 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx_initialized[queue] = 1;
+		key->u.tkip.rx[queue].initialized = 1;
 		goto done;
 	}
 
-	if (!key->u.tkip.rx_initialized[queue] ||
-	    key->u.tkip.iv32_rx[queue] != iv32) {
-		key->u.tkip.rx_initialized[queue] = 1;
+	if (!key->u.tkip.rx[queue].initialized ||
+	    key->u.tkip.rx[queue].iv32 != iv32) {
+		key->u.tkip.rx[queue].initialized = 1;
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   iv32, key->u.tkip.p1k_rx[queue]);
+				   iv32, key->u.tkip.rx[queue].p1k);
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
@@ -304,7 +304,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 			printk("\n");
 			printk(KERN_DEBUG "TKIP decrypt: P1K=");
 			for (i = 0; i < 5; i++)
-				printk("%04x ", key->u.tkip.p1k_rx[queue][i]);
+				printk("%04x ", key->u.tkip.rx[queue].p1k[i]);
 			printk("\n");
 		}
 #endif /* CONFIG_TKIP_DEBUG */
@@ -319,11 +319,11 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 			key->local->ops->update_tkip_key(
 				local_to_hw(key->local), &key->conf,
-				sta_addr, iv32, key->u.tkip.p1k_rx[queue]);
+				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
+	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 7db7b8e..ef72504 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -186,8 +186,8 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.iv32_rx[rx->queue] = rx->tkip_iv32;
-	rx->key->u.tkip.iv16_rx[rx->queue] = rx->tkip_iv16;
+	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
+	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 }
@@ -224,19 +224,19 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx,
 	pos += hdrlen;
 
 	/* Increase IV for the frame */
-	key->u.tkip.iv16++;
-	if (key->u.tkip.iv16 == 0)
-		key->u.tkip.iv32++;
+	key->u.tkip.tx.iv16++;
+	if (key->u.tkip.tx.iv16 == 0)
+		key->u.tkip.tx.iv32++;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		hdr = (struct ieee80211_hdr *)skb->data;
 
 		/* hwaccel - with preallocated room for IV */
 		ieee80211_tkip_add_iv(pos, key,
-				      (u8) (key->u.tkip.iv16 >> 8),
-				      (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
+				      (u8) (key->u.tkip.tx.iv16 >> 8),
+				      (u8) (((key->u.tkip.tx.iv16 >> 8) | 0x20) &
 					    0x7f),
-				      (u8) key->u.tkip.iv16);
+				      (u8) key->u.tkip.tx.iv16);
 
 		tx->control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
-- 
1.5.5.144.g3e42


