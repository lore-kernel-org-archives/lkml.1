Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYLCSNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYLCSNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYLCSNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:13:43 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:48763 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLCSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GLn1aN4j0GTEtAVplAsFgnfuTKf6VFYSRygb56xx36UlTYmOHqeX5liwXkAxdQw/DP
         UpAol905jsx4x7fMv3S503tZfp0jXL3UiprM/HcGA/UX+QHoBYeKnH+eb0EmHEnElz0W
         bGtUUTVDA0jqskLC9O4utZkdJlDh9yrmxnzn0=
Subject: [PATCH-mm 1/2] crypto: replace private helper with common
 unaligned endian helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:13:39 -0800
Message-Id: <1228328019.5412.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the unaligned access work in -mm.

 crypto/salsa20_generic.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index b07d559..dbc9e4a 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #define SALSA20_IV_SIZE        8U
 #define SALSA20_MIN_KEY_SIZE  16U
@@ -46,12 +47,6 @@ Public domain.
 #define XOR(v,w) ((v) ^ (w))
 #define PLUS(v,w) (((v) + (w)))
 #define PLUSONE(v) (PLUS((v),1))
-#define U32TO8_LITTLE(p, v) \
-	{ (p)[0] = (v >>  0) & 0xff; (p)[1] = (v >>  8) & 0xff; \
-	  (p)[2] = (v >> 16) & 0xff; (p)[3] = (v >> 24) & 0xff; }
-#define U8TO32_LITTLE(p)   \
-	(((u32)((p)[0])      ) | ((u32)((p)[1]) <<  8) | \
-	 ((u32)((p)[2]) << 16) | ((u32)((p)[3]) << 24)   )
 
 struct salsa20_ctx
 {
@@ -101,7 +96,7 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
 	for (i = 0; i < 16; ++i)
 		x[i] = PLUS(x[i],input[i]);
 	for (i = 0; i < 16; ++i)
-		U32TO8_LITTLE(output + 4 * i,x[i]);
+		store_le32_noalign((__le32 *)(output + 4 * i), x[i]);
 }
 
 static const char sigma[16] = "expand 32-byte k";
@@ -111,30 +106,30 @@ static void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k, u32 kbytes)
 {
 	const char *constants;
 
-	ctx->input[1] = U8TO32_LITTLE(k + 0);
-	ctx->input[2] = U8TO32_LITTLE(k + 4);
-	ctx->input[3] = U8TO32_LITTLE(k + 8);
-	ctx->input[4] = U8TO32_LITTLE(k + 12);
+	ctx->input[1] = load_le32_noalign((__le32 *)(k + 0));
+	ctx->input[2] = load_le32_noalign((__le32 *)(k + 4));
+	ctx->input[3] = load_le32_noalign((__le32 *)(k + 8));
+	ctx->input[4] = load_le32_noalign((__le32 *)(k + 12));
 	if (kbytes == 32) { /* recommended */
 		k += 16;
 		constants = sigma;
 	} else { /* kbytes == 16 */
 		constants = tau;
 	}
-	ctx->input[11] = U8TO32_LITTLE(k + 0);
-	ctx->input[12] = U8TO32_LITTLE(k + 4);
-	ctx->input[13] = U8TO32_LITTLE(k + 8);
-	ctx->input[14] = U8TO32_LITTLE(k + 12);
-	ctx->input[0] = U8TO32_LITTLE(constants + 0);
-	ctx->input[5] = U8TO32_LITTLE(constants + 4);
-	ctx->input[10] = U8TO32_LITTLE(constants + 8);
-	ctx->input[15] = U8TO32_LITTLE(constants + 12);
+	ctx->input[11] = load_le32_noalign((__le32 *)(k + 0));
+	ctx->input[12] = load_le32_noalign((__le32 *)(k + 4));
+	ctx->input[13] = load_le32_noalign((__le32 *)(k + 8));
+	ctx->input[14] = load_le32_noalign((__le32 *)(k + 12));
+	ctx->input[0] = load_le32_noalign((__le32 *)(constants + 0));
+	ctx->input[5] = load_le32_noalign((__le32 *)(constants + 4));
+	ctx->input[10] = load_le32_noalign((__le32 *)(constants + 8));
+	ctx->input[15] = load_le32_noalign((__le32 *)(constants + 12));
 }
 
 static void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv)
 {
-	ctx->input[6] = U8TO32_LITTLE(iv + 0);
-	ctx->input[7] = U8TO32_LITTLE(iv + 4);
+	ctx->input[6] = load_le32_noalign((__le32 *)(iv + 0));
+	ctx->input[7] = load_le32_noalign((__le32 *)(iv + 4));
 	ctx->input[8] = 0;
 	ctx->input[9] = 0;
 }
-- 
1.6.1.rc1.262.gb6810


