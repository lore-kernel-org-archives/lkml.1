Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYDPSad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYDPSad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYDPS3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:29:33 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:21232 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980AbYDPS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UYJaE03OyjfJJn7Gx6L682ZNvzowsT3Vy6vOQUn9EXpbBRHeK3QwynN87Jie46dtUTnYZ1qtnTsqMgbwr2ZdmLGt8mB5OrdIRfJtGDZySSYjmAe0rq9lGl8xb72NCywOhV+PpETG9cdSF2TGaYt+YLgnVJj5UTasceDmseITJKU=
Subject: [PATCH-mm 3/3] mac80211: Introduce struct michael_mic_ctx
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 11:29:31 -0700
Message-Id: <1208370571.11920.109.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small holder for the michael_mic context allows the cleanup of
michael.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |   55 +++++++++++++++++++++++------------------------
 net/mac80211/michael.h |   11 +++++++-
 net/mac80211/wpa.c     |   14 ++++++++++-
 3 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 698d7b3..a9f5323 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -9,46 +9,48 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
-#include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
 #include "michael.h"
 
-static void michael_block(u32 val, u32 *l, u32 *r)
+static void michael_block(u32 val, struct michael_mic_ctx *mctx)
 {
-	*l ^= val;
-	*r ^= rol32(*l, 17);
-	*l += *r;
-	*r ^= ((*l & 0xff00ff00) >> 8) | ((*l & 0x00ff00ff) << 8);
-	*l += *r;
-	*r ^= rol32(*l, 3);
-	*l += *r;
-	*r ^= ror32(*l, 2);
-	*l += *r;
+	mctx->l ^= val;
+	mctx->r ^= rol32(mctx->l, 17);
+	mctx->l += mctx->r;
+	mctx->r ^= ((mctx->l & 0xff00ff00) >> 8) | ((mctx->l & 0x00ff00ff) << 8);
+	mctx->l += mctx->r;
+	mctx->r ^= rol32(mctx->l, 3);
+	mctx->l += mctx->r;
+	mctx->r ^= ror32(mctx->l, 2);
+	mctx->l += mctx->r;
 }
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic)
+void michael_mic_init(struct michael_mic_ctx *mctx,
+		      u8 *key, u8 *da, u8 *sa, u8 priority)
 {
-	u32 l, r, val;
-	size_t block, blocks, left;
-
-	l = get_unaligned_le32(key);
-	r = get_unaligned_le32(key + 4);
+	mctx->l = get_unaligned_le32(key);
+	mctx->r = get_unaligned_le32(key + 4);
 
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
-	michael_block(get_unaligned_le32(da), &l, &r);
-	michael_block(get_unaligned_le16(da) | (get_unaligned_le16(sa) << 16), &l, &r);
-	michael_block(get_unaligned_le32(sa + 2), &l, &r);
-	michael_block(priority, &l, &r);
+	michael_block(get_unaligned_le32(da), mctx);
+	michael_block(get_unaligned_le16(da) | (get_unaligned_le16(sa) << 16), mctx);
+	michael_block(get_unaligned_le32(sa + 2), mctx);
+	michael_block(priority, mctx);
+}
+
+void michael_mic(struct michael_mic_ctx *mctx, u8 *data, size_t data_len)
+{
+	u32 val;
+	size_t block, blocks, left;
 
 	/* Real data */
 	blocks = data_len / 4;
 	left = data_len % 4;
 
 	for (block = 0; block < blocks; block++)
-		michael_block(get_unaligned_le32(data + (block * 4)), &l, &r);
+		michael_block(get_unaligned_le32(data + (block * 4)), mctx);
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
 	 * total length a multiple of 4. */
@@ -58,9 +60,6 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		left--;
 		val |= data[blocks * 4 + left];
 	}
-	michael_block(val, &l, &r);
-	michael_block(0, &l, &r);
-
-	put_unaligned_le32(l, mic);
-	put_unaligned_le32(r, mic + 4);
+	michael_block(val, mctx);
+	michael_block(0, mctx);
 }
diff --git a/net/mac80211/michael.h b/net/mac80211/michael.h
index 2e6aeba..5976550 100644
--- a/net/mac80211/michael.h
+++ b/net/mac80211/michael.h
@@ -14,7 +14,14 @@
 
 #define MICHAEL_MIC_LEN 8
 
-void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
-		 u8 *data, size_t data_len, u8 *mic);
+struct michael_mic_ctx {
+	u32 l, r;
+};
+
+extern void michael_mic_init(struct michael_mic_ctx *mctx,
+		 u8 *key, u8 *da, u8 *sa, u8 priority);
+
+extern void michael_mic(struct michael_mic_ctx *mctx,
+		 u8 *data, size_t data_len);
 
 #endif /* MICHAEL_H */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 45709ad..7db7b8e 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -12,6 +12,7 @@
 #include <linux/skbuff.h>
 #include <linux/compiler.h>
 #include <net/mac80211.h>
+#include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
 #include "michael.h"
@@ -79,6 +80,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	struct sk_buff *skb = tx->skb;
 	int authenticator;
 	int wpa_test = 0;
+	struct michael_mic_ctx mctx;
 
 	fc = tx->fc;
 
@@ -117,7 +119,10 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	key = &tx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_TX_MIC_KEY :
 				 ALG_TKIP_TEMP_AUTH_RX_MIC_KEY];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
-	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
+	michael_mic_init(&mctx, key, da, sa, qos_tid & 0x0f);
+	michael_mic(&mctx, data, data_len);
+	put_unaligned_le32(mctx.l, mic);
+	put_unaligned_le32(mctx.r, mic + 4);
 
 	return TX_CONTINUE;
 }
@@ -131,6 +136,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	u16 fc;
 	u8 mic[MICHAEL_MIC_LEN];
 	struct sk_buff *skb = rx->skb;
+	struct michael_mic_ctx mctx;
 	int authenticator = 1, wpa_test = 0;
 	DECLARE_MAC_BUF(mac);
 
@@ -159,7 +165,11 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 #endif
 	key = &rx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_RX_MIC_KEY :
 				 ALG_TKIP_TEMP_AUTH_TX_MIC_KEY];
-	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
+	michael_mic_init(&mctx, key, da, sa, qos_tid & 0x0f);
+	michael_mic(&mctx, data, data_len);
+	put_unaligned_le32(mctx.l, mic);
+	put_unaligned_le32(mctx.r, mic + 4);
+
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
 		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
-- 
1.5.5.144.g3e42

