Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYETSFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYETSFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbYETSFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:05:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:3341 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240AbYETSFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xwUrQTtVvwWpUn+0rbWt8qlgT7vWxyUsyUR0Pg58eowMThLz+SuQ0vyHc3RB5JxmCeUL1AsASvDuqGZcpb3CXmLRiuxvpu9SH5hEXJzevToMSds/13Bylhr2TCPgsCYKHfCW6TjEZF50sFZkQDGS5GsodwVXJ2fL/B07lzl2QB8=
Subject: [PATCH 02/21] crypto: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:05:27 -0700
Message-Id: <1211306727.5915.168.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 crypto/ccm.c         |    6 +++---
 crypto/crc32c.c      |    4 ++--
 crypto/lrw.c         |    2 +-
 crypto/michael_mic.c |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 7cf7e5a..9fdc2db 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -150,11 +150,11 @@ static int format_adata(u8 *adata, unsigned int a)
 	 * RFC 3610 and NIST Special Publication 800-38C
 	 */
 	if (a < 65280) {
-		*(__be16 *)adata = cpu_to_be16(a);
+		put_be16(a, adata);
 		len = 2;
 	} else  {
-		*(__be16 *)adata = cpu_to_be16(0xfffe);
-		*(__be32 *)&adata[2] = cpu_to_be32(a);
+		put_be16(0xfffe, adata);
+		put_be32(a, &adata[2]);
 		len = 6;
 	}
 
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 0dcf64a..c86c89b 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -52,7 +52,7 @@ static int chksum_setkey(struct crypto_tfm *tfm, const u8 *key,
 		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
-	mctx->key = le32_to_cpu(*(__le32 *)key);
+	mctx->key = get_le32(key);
 	return 0;
 }
 
@@ -68,7 +68,7 @@ static void chksum_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
 	
-	*(__le32 *)out = ~cpu_to_le32(mctx->crc);
+	put_le32(~mctx->crc, out);
 }
 
 static int crc32c_cra_init(struct crypto_tfm *tfm)
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 8ef664e..42a4533 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -111,7 +111,7 @@ static inline int get_index128(be128 *block)
 	__be32 *p = (__be32 *) block;
 
 	for (p += 3, x = 0; x < 128; p--, x += 32) {
-		u32 val = be32_to_cpup(p);
+		u32 val = get_be32(p);
 
 		if (!~val)
 			continue;
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 9e917b8..8aab62f 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -71,7 +71,7 @@ static void michael_update(struct crypto_tfm *tfm, const u8 *data,
 			return;
 
 		src = (const __le32 *)mctx->pending;
-		mctx->l ^= le32_to_cpup(src);
+		mctx->l ^= get_le32(src);
 		michael_block(mctx->l, mctx->r);
 		mctx->pending_len = 0;
 	}
@@ -79,7 +79,7 @@ static void michael_update(struct crypto_tfm *tfm, const u8 *data,
 	src = (const __le32 *)data;
 
 	while (len >= 4) {
-		mctx->l ^= le32_to_cpup(src++);
+		mctx->l ^= get_le32(src++);
 		michael_block(mctx->l, mctx->r);
 		len -= 4;
 	}
-- 
1.5.5.1.570.g26b5e


