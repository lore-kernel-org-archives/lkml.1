Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab0APBFX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 20:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273Ab0APBFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 20:05:21 -0500
Received: from [206.15.93.42] ([206.15.93.42]:29279 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758169Ab0APBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 20:05:19 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        gregkh@suse.de
Subject: [PATCH] staging/rtl8187se: use %p[Mm] to show MAC addresses
Date: Fri, 15 Jan 2010 18:05:17 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001151805.17829.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

staging/rtl8187se: use %p[Mm] to show MAC addresses

Trivial, use the %p[Mm] extensions instead of the custom macros.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---

 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    4 --
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |   23 ++++-----
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |   22 ++++----
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   52 +++++++++-----------
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    6 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    5 +-
 7 files changed, 51 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index 0d490c1..04a48e7 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -161,10 +161,6 @@ do { if (ieee80211_debug_level & (level)) \
 #define IEEE80211_DEBUG(level, fmt, args...) do {} while (0)
 #endif	/* CONFIG_IEEE80211_DEBUG */
 
-#define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
-#define MAC_ARG(x) ((u8 *)(x))[0], ((u8 *)(x))[1], ((u8 *)(x))[2], \
-		   ((u8 *)(x))[3], ((u8 *)(x))[4], ((u8 *)(x))[5]
-
 /*
  * To use the debug system;
  *
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 172e8f3..5f5f991 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -285,7 +285,7 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	if (!(keyidx & (1 << 5))) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "CCMP: received packet without ExtIV"
-			       " flag from " MAC_FMT "\n", MAC_ARG(hdr->addr2));
+			       " flag from %pM\n", hdr->addr2);
 		}
 		key->dot11RSNAStatsCCMPFormatErrors++;
 		return -2;
@@ -298,9 +298,9 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	}
 	if (!key->key_set) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: received packet from " MAC_FMT
+			printk(KERN_DEBUG "CCMP: received packet from %pM"
 			       " with keyid=%d that does not have a configured"
-			       " key\n", MAC_ARG(hdr->addr2), keyidx);
+			       " key\n", hdr->addr2, keyidx);
 		}
 		return -3;
 	}
@@ -315,11 +315,9 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (memcmp(pn, key->rx_pn, CCMP_PN_LEN) <= 0) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: replay detected: STA=" MAC_FMT
-			       " previous PN %02x%02x%02x%02x%02x%02x "
-			       "received PN %02x%02x%02x%02x%02x%02x\n",
-			       MAC_ARG(hdr->addr2), MAC_ARG(key->rx_pn),
-			       MAC_ARG(pn));
+			printk(KERN_DEBUG "CCMP: replay detected: STA=%pM"
+			       " previous PN %pm received PN %pm\n",
+			       hdr->addr2, key->rx_pn, pn);
 		}
 		key->dot11RSNAStatsCCMPReplays++;
 		return -4;
@@ -346,8 +344,8 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (memcmp(mic, a, CCMP_MIC_LEN) != 0) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: decrypt failed: STA="
-			       MAC_FMT "\n", MAC_ARG(hdr->addr2));
+			printk(KERN_DEBUG "CCMP: decrypt failed: STA=%pM\n",
+				hdr->addr2);
 		}
 		key->dot11RSNAStatsCCMPDecryptErrors++;
 		return -5;
@@ -423,11 +421,10 @@ static char * ieee80211_ccmp_print_stats(char *p, void *priv)
 {
 	struct ieee80211_ccmp_data *ccmp = priv;
 	p += sprintf(p, "key[%d] alg=CCMP key_set=%d "
-		     "tx_pn=%02x%02x%02x%02x%02x%02x "
-		     "rx_pn=%02x%02x%02x%02x%02x%02x "
+		     "tx_pn=%pm rx_pn=%pm "
 		     "format_errors=%d replays=%d decrypt_errors=%d\n",
 		     ccmp->key_idx, ccmp->key_set,
-		     MAC_ARG(ccmp->tx_pn), MAC_ARG(ccmp->rx_pn),
+		     ccmp->tx_pn, ccmp->rx_pn,
 		     ccmp->dot11RSNAStatsCCMPFormatErrors,
 		     ccmp->dot11RSNAStatsCCMPReplays,
 		     ccmp->dot11RSNAStatsCCMPDecryptErrors);
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
index e6d8385..4aaf395 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -385,7 +385,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	if (!(keyidx & (1 << 5))) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "TKIP: received packet without ExtIV"
-			       " flag from " MAC_FMT "\n", MAC_ARG(hdr->addr2));
+			       " flag from %pM\n", hdr->addr2);
 		}
 		return -2;
 	}
@@ -397,9 +397,9 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	}
 	if (!tkey->key_set) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: received packet from " MAC_FMT
+			printk(KERN_DEBUG "TKIP: received packet from %pM"
 			       " with keyid=%d that does not have a configured"
-			       " key\n", MAC_ARG(hdr->addr2), keyidx);
+			       " key\n", hdr->addr2, keyidx);
 		}
 		return -3;
 	}
@@ -410,9 +410,9 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	if (iv32 < tkey->rx_iv32 ||
 	    (iv32 == tkey->rx_iv32 && iv16 <= tkey->rx_iv16)) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: replay detected: STA=" MAC_FMT
+			printk(KERN_DEBUG "TKIP: replay detected: STA=%pM"
 			       " previous TSC %08x%04x received TSC "
-			       "%08x%04x\n", MAC_ARG(hdr->addr2),
+			       "%08x%04x\n", hdr->addr2,
 			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
 		}
 		tkey->dot11RSNAStatsTKIPReplays++;
@@ -431,8 +431,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG ": TKIP: failed to decrypt "
-			       "received packet from " MAC_FMT "\n",
-			       MAC_ARG(hdr->addr2));
+			       "received packet from %pM\n",
+			       hdr->addr2);
 		}
 		return -7;
 	}
@@ -449,8 +449,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			tkey->rx_phase1_done = 0;
 		}
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: ICV error detected: STA="
-			       MAC_FMT "\n", MAC_ARG(hdr->addr2));
+			printk(KERN_DEBUG "TKIP: ICV error detected: STA=%pM\n",
+				hdr->addr2);
 		}
 		tkey->dot11RSNAStatsTKIPICVErrors++;
 		return -5;
@@ -604,8 +604,8 @@ static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 		struct ieee80211_hdr_4addr *hdr;
 		hdr = (struct ieee80211_hdr_4addr *)skb->data;
 		printk(KERN_DEBUG "%s: Michael MIC verification failed for "
-		       "MSDU from " MAC_FMT " keyidx=%d\n",
-		       skb->dev ? skb->dev->name : "N/A", MAC_ARG(hdr->addr2),
+		       "MSDU from %pM keyidx=%d\n",
+		       skb->dev ? skb->dev->name : "N/A", hdr->addr2,
 		       keyidx);
 		if (skb->dev)
 			ieee80211_michael_mic_failure(skb->dev, hdr, keyidx);
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 9128c18..f001e9d 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -311,8 +311,8 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device* ieee, struct sk_buff *skb,
 	    strcmp(crypt->ops->name, "TKIP") == 0) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: TKIP countermeasures: dropped "
-			       "received packet from " MAC_FMT "\n",
-			       ieee->dev->name, MAC_ARG(hdr->addr2));
+			       "received packet from %pM\n",
+			       ieee->dev->name, hdr->addr2);
 		}
 		return -1;
 	}
@@ -323,8 +323,8 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device* ieee, struct sk_buff *skb,
 	atomic_dec(&crypt->refcnt);
 	if (res < 0) {
 		IEEE80211_DEBUG_DROP(
-			"decryption failed (SA=" MAC_FMT
-			") res=%d\n", MAC_ARG(hdr->addr2), res);
+			"decryption failed (SA=%pM) res=%d\n",
+			hdr->addr2, res);
 		if (res == -2)
 			IEEE80211_DEBUG_DROP("Decryption failed ICV "
 					     "mismatch (key %d)\n",
@@ -356,8 +356,8 @@ ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device* ieee, struct sk_buff *s
 	atomic_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_DEBUG "%s: MSDU decryption/MIC verification failed"
-		       " (SA=" MAC_FMT " keyidx=%d)\n",
-		       ieee->dev->name, MAC_ARG(hdr->addr2), keyidx);
+		       " (SA=%pM keyidx=%d)\n",
+		       ieee->dev->name, hdr->addr2, keyidx);
 		return -1;
 	}
 
@@ -549,9 +549,8 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 			 * frames from other than current BSS, so just drop the
 			 * frames silently instead of filling system log with
 			 * these reports. */
-			IEEE80211_DEBUG_DROP("Decryption failed (not set)"
-					     " (SA=" MAC_FMT ")\n",
-					     MAC_ARG(hdr->addr2));
+			IEEE80211_DEBUG_DROP("Decryption failed (not set) (SA=%pM)\n",
+					     hdr->addr2);
 			ieee->ieee_stats.rx_discards_undecryptable++;
 			goto rx_dropped;
 		}
@@ -709,8 +708,8 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		} else {
 			IEEE80211_DEBUG_DROP(
 				"encryption configured, but RX "
-				"frame not encrypted (SA=" MAC_FMT ")\n",
-				MAC_ARG(hdr->addr2));
+				"frame not encrypted (SA=%pM)\n",
+				hdr->addr2);
 			goto rx_dropped;
 		}
 	}
@@ -728,10 +727,9 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (crypt && !(fc & IEEE80211_FCTL_WEP) && !ieee->open_wep &&
 	    !ieee80211_is_eapol_frame(ieee, skb, hdrlen)) {
 		IEEE80211_DEBUG_DROP(
-			"dropped unencrypted RX data "
-			"frame from " MAC_FMT
+			"dropped unencrypted RX data frame from %pM"
 			" (drop_unencrypted=1)\n",
-			MAC_ARG(hdr->addr2));
+			hdr->addr2);
 		goto rx_dropped;
 	}
 /*
@@ -1196,11 +1194,10 @@ inline int ieee80211_network_init(
 	}
 
 	if (network->mode == 0) {
-		IEEE80211_DEBUG_SCAN("Filtered out '%s (" MAC_FMT ")' "
-				     "network.\n",
+		IEEE80211_DEBUG_SCAN("Filtered out '%s (%pM)' network.\n",
 				     escape_essid(network->ssid,
 						  network->ssid_len),
-				     MAC_ARG(network->bssid));
+				     network->bssid);
 		return 1;
 	}
 
@@ -1341,9 +1338,9 @@ inline void ieee80211_process_probe_response(
 	memset(&network, 0, sizeof(struct ieee80211_network));
 
 	IEEE80211_DEBUG_SCAN(
-		"'%s' (" MAC_FMT "): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
+		"'%s' (%pM): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
 		escape_essid(info_element->data, info_element->len),
-		MAC_ARG(beacon->header.addr3),
+		beacon->header.addr3,
 		(beacon->capability & (1<<0xf)) ? '1' : '0',
 		(beacon->capability & (1<<0xe)) ? '1' : '0',
 		(beacon->capability & (1<<0xd)) ? '1' : '0',
@@ -1362,10 +1359,10 @@ inline void ieee80211_process_probe_response(
 		(beacon->capability & (1<<0x0)) ? '1' : '0');
 
 	if (ieee80211_network_init(ieee, beacon, &network, stats)) {
-		IEEE80211_DEBUG_SCAN("Dropped '%s' (" MAC_FMT ") via %s.\n",
+		IEEE80211_DEBUG_SCAN("Dropped '%s' (%pM) via %s.\n",
 				     escape_essid(info_element->data,
 						  info_element->len),
-				     MAC_ARG(beacon->header.addr3),
+				     beacon->header.addr3,
 				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
 				     IEEE80211_STYPE_PROBE_RESP ?
 				     "PROBE RESPONSE" : "BEACON");
@@ -1464,11 +1461,10 @@ inline void ieee80211_process_probe_response(
 			/* If there are no more slots, expire the oldest */
 			list_del(&oldest->list);
 			target = oldest;
-			IEEE80211_DEBUG_SCAN("Expired '%s' (" MAC_FMT ") from "
-					     "network list.\n",
+			IEEE80211_DEBUG_SCAN("Expired '%s' (%pM) from network list.\n",
 					     escape_essid(target->ssid,
 							  target->ssid_len),
-					     MAC_ARG(target->bssid));
+					     target->bssid);
 		} else {
 			/* Otherwise just pull from the free list */
 			target = list_entry(ieee->network_free_list.next,
@@ -1478,10 +1474,10 @@ inline void ieee80211_process_probe_response(
 
 
 #ifdef CONFIG_IEEE80211_DEBUG
-		IEEE80211_DEBUG_SCAN("Adding '%s' (" MAC_FMT ") via %s.\n",
+		IEEE80211_DEBUG_SCAN("Adding '%s' (%pM) via %s.\n",
 				     escape_essid(network.ssid,
 						  network.ssid_len),
-				     MAC_ARG(network.bssid),
+				     network.bssid,
 				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
 				     IEEE80211_STYPE_PROBE_RESP ?
 				     "PROBE RESPONSE" : "BEACON");
@@ -1492,10 +1488,10 @@ inline void ieee80211_process_probe_response(
 		if(ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE)
 			ieee80211_softmac_new_net(ieee,&network);
 	} else {
-		IEEE80211_DEBUG_SCAN("Updating '%s' (" MAC_FMT ") via %s.\n",
+		IEEE80211_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
 				     escape_essid(target->ssid,
 						  target->ssid_len),
-				     MAC_ARG(target->bssid),
+				     target->bssid,
 				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
 				     IEEE80211_STYPE_PROBE_RESP ?
 				     "PROBE RESPONSE" : "BEACON");
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index c7c645a..e8cfcb8 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1573,7 +1573,7 @@ ieee80211_rx_assoc_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
 		ieee80211_resp_to_assoc_rq(ieee, dest);
 	}
 
-	printk(KERN_INFO"New client associated: "MAC_FMT"\n", MAC_ARG(dest));
+	printk(KERN_INFO"New client associated: %pM\n", dest);
 }
 
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
index 69bd021..f89f1c4 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
@@ -198,8 +198,8 @@ int ieee80211_encrypt_fragment(
 		header = (struct ieee80211_hdr_4addr *)frag->data;
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: TKIP countermeasures: dropped "
-			       "TX packet to " MAC_FMT "\n",
-			       ieee->dev->name, MAC_ARG(header->addr1));
+			       "TX packet to %pM\n",
+			       ieee->dev->name, header->addr1));
 		}
 		return -1;
 	}
@@ -407,7 +407,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb,
 			memcpy(&header.addr2, src, ETH_ALEN);
 			memcpy(&header.addr3, ieee->current_network.bssid, ETH_ALEN);
 		}
-	//	printk(KERN_WARNING "essid MAC address is "MAC_FMT, MAC_ARG(&header.addr1));
+	//	printk(KERN_WARNING "essid MAC address is %pM", &header.addr1);
 		header.frame_ctl = cpu_to_le16(fc);
 		//hdr_len = IEEE80211_3ADDR_LEN;
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index 6aad48f..9b96534 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -233,11 +233,10 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 			}
 			else
 				IEEE80211_DEBUG_SCAN(
-					"Not showing network '%s ("
-					MAC_FMT ")' due to age (%lums).\n",
+					"Not showing network '%s (%pM)' due to age (%lums).\n",
 					escape_essid(network->ssid,
 						     network->ssid_len),
-					MAC_ARG(network->bssid),
+					network->bssid,
 					(jiffies - network->last_scanned) / (HZ / 100));
 		}
 	}
