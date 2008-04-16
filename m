Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbYDPXZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbYDPXZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbYDPXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:24:25 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:6647 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbYDPXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fAIr3+BrE4V0E5FZYOLF4Zu2KHdfuLMPPztkkv4QM6aE5n3q/v01c2Cnwu1BGL1cRR0eFCDeq8smROd3XciKAGijEpotojKRZn8y8bCdn0xAsLmGqhrhQuUQFYpRvcdk0h9syhec2DLJK5qMNGvLp7M27wf45J4Sq3xbJAbXssE=
Subject: [PATCH-mm 4/5] mac80211: tkip.c use struct tkip_ctx in phase 1 key
	mixing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:24:26 -0700
Message-Id: <1208388266.11920.129.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 00a3734..996b1c0 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -71,10 +71,12 @@ static inline u16 tkip_S(u16 val)
  * TSC = TKIP sequence counter (48 bits, only 32 msb bits used)
  * P1K: 80 bits
  */
-static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
-			       u16 *p1k)
+static void tkip_mixing_phase1(struct ieee80211_key *key, const u8 *ta,
+			       struct tkip_ctx *ctx, u32 tsc_IV32)
 {
 	int i, j;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+	u16 *p1k = ctx->p1k;
 
 	p1k[0] = tsc_IV32 & 0xFFFF;
 	p1k[1] = tsc_IV32 >> 16;
@@ -90,6 +92,8 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 		p1k[3] += tkip_S(p1k[2] ^ get_unaligned_le16(tk + 12 + j));
 		p1k[4] += tkip_S(p1k[3] ^ get_unaligned_le16(tk + 0 + j)) + i;
 	}
+
+	ctx->initialized = 1;
 }
 
 static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
@@ -146,12 +150,8 @@ void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
 	/* Calculate per-packet key */
-	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized) {
-		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   key->u.tkip.tx.iv32, key->u.tkip.tx.p1k);
-		key->u.tkip.tx.initialized = 1;
-	}
+	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
+		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
 
 	tkip_mixing_phase2(key->u.tkip.tx.p1k,
 			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
@@ -191,12 +191,8 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !key->u.tkip.tx.initialized) {
-		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			iv32, key->u.tkip.tx.p1k);
-		key->u.tkip.tx.initialized = 1;
-	}
+	if (iv16 == 0 || !key->u.tkip.tx.initialized)
+		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, iv32);
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
 		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
@@ -287,10 +283,8 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 	if (!key->u.tkip.rx[queue].initialized ||
 	    key->u.tkip.rx[queue].iv32 != iv32) {
-		key->u.tkip.rx[queue].initialized = 1;
 		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-				   iv32, key->u.tkip.rx[queue].p1k);
+		tkip_mixing_phase1(key, ta, &key->u.tkip.rx[queue], iv32);
 #ifdef CONFIG_TKIP_DEBUG
 		{
 			int i;
-- 
1.5.5.144.g3e42


