Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXJVSO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXJVSO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJVSMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22188 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXJVSMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:25 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/10] [SG] Update net/ to use sg helpers
Date: Mon, 22 Oct 2007 20:11:00 +0200
Message-Id: <1193076664-13652-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 net/core/skbuff.c                     |    4 ++--
 net/ieee80211/ieee80211_crypt_tkip.c  |   13 +++++--------
 net/ieee80211/ieee80211_crypt_wep.c   |    8 ++------
 net/mac80211/wep.c                    |    8 ++------
 net/sctp/auth.c                       |    3 ++-
 net/sctp/sm_make_chunk.c              |    6 ++++--
 net/sunrpc/auth_gss/gss_krb5_crypto.c |   10 +++++-----
 net/sunrpc/xdr.c                      |    2 +-
 net/xfrm/xfrm_algo.c                  |    4 ++--
 9 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 70d9b5d..4e2c84f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2045,7 +2045,7 @@ skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len)
 	if (copy > 0) {
 		if (copy > len)
 			copy = len;
-		sg[elt].page = virt_to_page(skb->data + offset);
+		sg_set_page(&sg[elt], virt_to_page(skb->data + offset));
 		sg[elt].offset = (unsigned long)(skb->data + offset) % PAGE_SIZE;
 		sg[elt].length = copy;
 		elt++;
@@ -2065,7 +2065,7 @@ skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len)
 
 			if (copy > len)
 				copy = len;
-			sg[elt].page = frag->page;
+			sg_set_page(&sg[elt], frag->page);
 			sg[elt].offset = frag->page_offset+offset-start;
 			sg[elt].length = copy;
 			elt++;
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index 72e6ab6..c796661 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -390,9 +390,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[3] = crc >> 24;
 
 	crypto_blkcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = len + 4;
+	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
 
@@ -485,9 +483,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 12;
 
 	crypto_blkcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = plen + 4;
+	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG ": TKIP: failed to decrypt "
@@ -539,11 +535,12 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
 		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
 		return -1;
 	}
-	sg[0].page = virt_to_page(hdr);
+	sg_init_table(sg, 2);
+	sg_set_page(&sg[0], virt_to_page(hdr));
 	sg[0].offset = offset_in_page(hdr);
 	sg[0].length = 16;
 
-	sg[1].page = virt_to_page(data);
+	sg_set_page(&sg[1], virt_to_page(data));
 	sg[1].offset = offset_in_page(data);
 	sg[1].length = data_len;
 
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index 8d18245..0af6103 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -170,9 +170,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[3] = crc >> 24;
 
 	crypto_blkcipher_setkey(wep->tx_tfm, key, klen);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = len + 4;
+	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
 
@@ -212,9 +210,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	crypto_blkcipher_setkey(wep->rx_tfm, key, klen);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = plen + 4;
+	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4))
 		return -7;
 
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6675261..cc806d6 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -138,9 +138,7 @@ void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	*icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg.page = virt_to_page(data);
-	sg.offset = offset_in_page(data);
-	sg.length = data_len + WEP_ICV_LEN;
+	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
 }
 
@@ -204,9 +202,7 @@ int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	__le32 crc;
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg.page = virt_to_page(data);
-	sg.offset = offset_in_page(data);
-	sg.length = data_len + WEP_ICV_LEN;
+	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_decrypt(&desc, &sg, &sg, sg.length);
 
 	crc = cpu_to_le32(~crc32_le(~0, data, data_len));
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 7818107..cbd64b2 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -726,7 +726,8 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 
 	/* set up scatter list */
 	end = skb_tail_pointer(skb);
-	sg.page = virt_to_page(auth);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(auth));
 	sg.offset = (unsigned long)(auth) % PAGE_SIZE;
 	sg.length = end - (unsigned char *)auth;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f983a36..d5a9785 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1513,7 +1513,8 @@ static sctp_cookie_param_t *sctp_pack_cookie(const struct sctp_endpoint *ep,
 		struct hash_desc desc;
 
 		/* Sign the message.  */
-		sg.page = virt_to_page(&cookie->c);
+		sg_init_table(&sg, 1);
+		sg_set_page(&sg, virt_to_page(&cookie->c));
 		sg.offset = (unsigned long)(&cookie->c) % PAGE_SIZE;
 		sg.length = bodysize;
 		keylen = SCTP_SECRET_SIZE;
@@ -1585,7 +1586,8 @@ struct sctp_association *sctp_unpack_cookie(
 
 	/* Check the signature.  */
 	keylen = SCTP_SECRET_SIZE;
-	sg.page = virt_to_page(bear_cookie);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(bear_cookie));
 	sg.offset = (unsigned long)(bear_cookie) % PAGE_SIZE;
 	sg.length = bodysize;
 	key = (char *)ep->secret_key[ep->current_key];
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index bfb6a29..32be431 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -197,9 +197,9 @@ encryptor(struct scatterlist *sg, void *data)
 		int i = (page_pos + outbuf->page_base) >> PAGE_CACHE_SHIFT;
 		in_page = desc->pages[i];
 	} else {
-		in_page = sg->page;
+		in_page = sg_page(sg);
 	}
-	desc->infrags[desc->fragno].page = in_page;
+	sg_set_page(&desc->infrags[desc->fragno], in_page);
 	desc->fragno++;
 	desc->fraglen += sg->length;
 	desc->pos += sg->length;
@@ -215,11 +215,11 @@ encryptor(struct scatterlist *sg, void *data)
 	if (ret)
 		return ret;
 	if (fraglen) {
-		desc->outfrags[0].page = sg->page;
+		sg_set_page(&desc->outfrags[0], sg_page(sg));
 		desc->outfrags[0].offset = sg->offset + sg->length - fraglen;
 		desc->outfrags[0].length = fraglen;
 		desc->infrags[0] = desc->outfrags[0];
-		desc->infrags[0].page = in_page;
+		sg_set_page(&desc->infrags[0], in_page);
 		desc->fragno = 1;
 		desc->fraglen = fraglen;
 	} else {
@@ -287,7 +287,7 @@ decryptor(struct scatterlist *sg, void *data)
 	if (ret)
 		return ret;
 	if (fraglen) {
-		desc->frags[0].page = sg->page;
+		sg_set_page(&desc->frags[0], sg_page(sg));
 		desc->frags[0].offset = sg->offset + sg->length - fraglen;
 		desc->frags[0].length = fraglen;
 		desc->fragno = 1;
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 6a59180..3d1f7cd 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1059,7 +1059,7 @@ xdr_process_buf(struct xdr_buf *buf, unsigned int offset, unsigned int len,
 		do {
 			if (thislen > page_len)
 				thislen = page_len;
-			sg->page = buf->pages[i];
+			sg_set_page(sg, buf->pages[i]);
 			sg->offset = page_offset;
 			sg->length = thislen;
 			ret = actor(sg, data);
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 5ced62c..fb2220a 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -552,7 +552,7 @@ int skb_icv_walk(const struct sk_buff *skb, struct hash_desc *desc,
 		if (copy > len)
 			copy = len;
 
-		sg.page = virt_to_page(skb->data + offset);
+		sg_set_page(&sg, virt_to_page(skb->data + offset));
 		sg.offset = (unsigned long)(skb->data + offset) % PAGE_SIZE;
 		sg.length = copy;
 
@@ -577,7 +577,7 @@ int skb_icv_walk(const struct sk_buff *skb, struct hash_desc *desc,
 			if (copy > len)
 				copy = len;
 
-			sg.page = frag->page;
+			sg_set_page(&sg, frag->page);
 			sg.offset = frag->page_offset + offset-start;
 			sg.length = copy;
 
-- 
1.5.3.GIT

