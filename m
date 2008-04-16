Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYDPS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYDPS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYDPS31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:29:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:10271 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYDPS30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ETyZleaXf2M6gRQMy/2d+uOaxn2mwJyulnVOtdY1oqHy5Nq1sNyID1MnOohg2L9VKnb3lILMFnMO/7QkdHeywVyzNEaI8WxXo/W/gm1cGbbV+JMADLQ1Vsf9qwnFW6g0IT2JlCOA6nyRS/mbpg61WPA/0uIOSrMj2WAnzRFAJ8U=
Subject: [PATCH-mm 1/3] mac80211: tkip.c use get/put_unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 11:29:30 -0700
Message-Id: <1208370570.11920.107.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This depends on the introduction of the new unaligned helpers, and applies
on top of the cleanup patches already in -mm.

 net/mac80211/tkip.c |   62 +++++++++++++++++++--------------------------------
 1 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 61c60d3..1c5a46a 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -63,16 +63,6 @@ static const u16 tkip_sbox[256] =
 	0x82C3, 0x29B0, 0x5A77, 0x1E11, 0x7BCB, 0xA8FC, 0x6DD6, 0x2C3A,
 };
 
-
-/*
- * Get a cpu-byteorder u16 from a u8 pointer fixing up possible unaligned
- * accesses.
- */
-static inline u16 getle16(const u8 *x)
-{
-	return le16_to_cpu(get_unaligned((__le16 *)x));
-}
-
 static inline u16 tkip_S(u16 val)
 {
 	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
@@ -91,17 +81,17 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 
 	p1k[0] = tsc_IV32 & 0xFFFF;
 	p1k[1] = tsc_IV32 >> 16;
-	p1k[2] = getle16(ta + 0);
-	p1k[3] = getle16(ta + 2);
-	p1k[4] = getle16(ta + 4);
+	p1k[2] = get_unaligned_le16(ta + 0);
+	p1k[3] = get_unaligned_le16(ta + 2);
+	p1k[4] = get_unaligned_le16(ta + 4);
 
 	for (i = 0; i < PHASE1_LOOP_COUNT; i++) {
 		j = 2 * (i & 1);
-		p1k[0] += tkip_S(p1k[4] ^ getle16(tk + 0 + j));
-		p1k[1] += tkip_S(p1k[0] ^ getle16(tk + 4 + j));
-		p1k[2] += tkip_S(p1k[1] ^ getle16(tk + 8 + j));
-		p1k[3] += tkip_S(p1k[2] ^ getle16(tk + 12 + j));
-		p1k[4] += tkip_S(p1k[3] ^ getle16(tk + 0 + j)) + i;
+		p1k[0] += tkip_S(p1k[4] ^ get_unaligned_le16(tk + 0 + j));
+		p1k[1] += tkip_S(p1k[0] ^ get_unaligned_le16(tk + 4 + j));
+		p1k[2] += tkip_S(p1k[1] ^ get_unaligned_le16(tk + 8 + j));
+		p1k[3] += tkip_S(p1k[2] ^ get_unaligned_le16(tk + 12 + j));
+		p1k[4] += tkip_S(p1k[3] ^ get_unaligned_le16(tk + 0 + j)) + i;
 	}
 }
 
@@ -119,14 +109,14 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	ppk[4] = p1k[4];
 	ppk[5] = p1k[4] + tsc_IV16;
 
-	ppk[0] += tkip_S(ppk[5] ^ getle16(tk + 0));
-	ppk[1] += tkip_S(ppk[0] ^ getle16(tk + 2));
-	ppk[2] += tkip_S(ppk[1] ^ getle16(tk + 4));
-	ppk[3] += tkip_S(ppk[2] ^ getle16(tk + 6));
-	ppk[4] += tkip_S(ppk[3] ^ getle16(tk + 8));
-	ppk[5] += tkip_S(ppk[4] ^ getle16(tk + 10));
-	ppk[0] +=  ror16(ppk[5] ^ getle16(tk + 12), 1);
-	ppk[1] +=  ror16(ppk[0] ^ getle16(tk + 14), 1);
+	ppk[0] += tkip_S(ppk[5] ^ get_unaligned_le16(tk + 0));
+	ppk[1] += tkip_S(ppk[0] ^ get_unaligned_le16(tk + 2));
+	ppk[2] += tkip_S(ppk[1] ^ get_unaligned_le16(tk + 4));
+	ppk[3] += tkip_S(ppk[2] ^ get_unaligned_le16(tk + 6));
+	ppk[4] += tkip_S(ppk[3] ^ get_unaligned_le16(tk + 8));
+	ppk[5] += tkip_S(ppk[4] ^ get_unaligned_le16(tk + 10));
+	ppk[0] +=  ror16(ppk[5] ^ get_unaligned_le16(tk + 12), 1);
+	ppk[1] +=  ror16(ppk[0] ^ get_unaligned_le16(tk + 14), 1);
 	ppk[2] +=  ror16(ppk[1], 1);
 	ppk[3] +=  ror16(ppk[2], 1);
 	ppk[4] +=  ror16(ppk[3], 1);
@@ -135,11 +125,11 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	rc4key[0] = tsc_IV16 >> 8;
 	rc4key[1] = ((tsc_IV16 >> 8) | 0x20) & 0x7f;
 	rc4key[2] = tsc_IV16 & 0xFF;
-	rc4key[3] = ((ppk[5] ^ getle16(tk)) >> 1) & 0xFF;
+	rc4key[3] = ((ppk[5] ^ get_unaligned_le16(tk)) >> 1) & 0xFF;
 
 	rc4key += 4;
-	for (i = 0; i < 6; i++)
-		put_unaligned(cpu_to_le16(ppk[i]), (__le16 *)rc4key + i);
+	for (i = 0; i < 12; i += 2)
+		put_unaligned_le16(ppk[i], rc4key + i);
 }
 

@@ -153,11 +143,8 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 	*pos++ = iv1;
 	*pos++ = iv2;
 	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
-	*pos++ = key->u.tkip.iv32 & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 8) & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 16) & 0xff;
-	*pos++ = (key->u.tkip.iv32 >> 24) & 0xff;
-	return pos;
+	put_unaligned_le32(key->u.tkip.iv32, pos);
+	return pos + 4;
 }
 

@@ -200,10 +187,7 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 
 	iv16 = data[hdr_len] << 8;
 	iv16 += data[hdr_len + 2];
-	iv32 = data[hdr_len + 4] +
-		(data[hdr_len + 5] >> 8) +
-		(data[hdr_len + 6] >> 16) +
-		(data[hdr_len + 7] >> 24);
+	iv32 = get_unaligned_le32(data + hdr_len + 4);
 
 #ifdef CONFIG_TKIP_DEBUG
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
@@ -274,7 +258,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 	iv16 = (pos[0] << 8) | pos[2];
 	keyid = pos[3];
-	iv32 = pos[4] | (pos[5] << 8) | (pos[6] << 16) | (pos[7] << 24);
+	iv32 = get_unaligned_le32(pos + 4);
 	pos += 8;
 #ifdef CONFIG_TKIP_DEBUG
 	{
-- 
1.5.5.144.g3e42


