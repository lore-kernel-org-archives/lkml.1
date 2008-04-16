Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYDPX0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYDPX0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbYDPXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:24:27 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:34395 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbYDPXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YSzGRsvNRm0w6gyevXOPuZT9UmbXFX32WOb2W/cjisO4Hn1t+XMm2CjlOBqYWYOuWVE3haaWgh3Hodl2emjKluFYO5xjgvVLOvDngp6OYCQIqKMkLsx7RnB1cxE2beuSg9H00XU/UupK+r0vyZxQPJBd30s6QF9IfQZj9WFCL60=
Subject: [PATCH-mm 5/5] mac80211: tkip.c use struct tkip_ctx in phase 2 key
	mixing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:24:26 -0700
Message-Id: <1208388267.11920.130.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 996b1c0..9c03431 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -96,10 +96,12 @@ static void tkip_mixing_phase1(struct ieee80211_key *key, const u8 *ta,
 	ctx->initialized = 1;
 }
 
-static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
-			       u8 *rc4key)
+static void tkip_mixing_phase2(struct ieee80211_key *key, struct tkip_ctx *ctx,
+			       u16 tsc_IV16, u8 *rc4key)
 {
 	u16 ppk[6];
+	const u16 *p1k = ctx->p1k;
+	const u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
 	int i;
 
 	ppk[0] = p1k[0];
@@ -153,9 +155,7 @@ void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 	if (key->u.tkip.tx.iv16 == 0 || !key->u.tkip.tx.initialized)
 		tkip_mixing_phase1(key, ta, &key->u.tkip.tx, key->u.tkip.tx.iv32);
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.tx.iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, key->u.tkip.tx.iv16, rc4key);
 }
 
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
@@ -199,8 +199,7 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 		return;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.tx.p1k,
-		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
+	tkip_mixing_phase2(key, &key->u.tkip.tx, iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
@@ -317,9 +316,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		}
 	}
 
-	tkip_mixing_phase2(key->u.tkip.rx[queue].p1k,
-			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   iv16, rc4key);
+	tkip_mixing_phase2(key, &key->u.tkip.rx[queue], iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
 	{
 		int i;
-- 
1.5.5.144.g3e42

