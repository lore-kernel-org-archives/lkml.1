Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYLIB0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYLIB0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 20:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYLIB0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 20:26:42 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:65053 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYLIB0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 20:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=j4nFAgHHRL+wizMfpKJmlHSCONspMOjkt9Mpj1vqADhYjBCgVrqfPe39Bi2dnZV2rO
         knj7wz97o1xzcPOnemdzYSLrc1jpL09q0NVvfQRGgJ9hmlrD+x0JhzzrLn+NnA20KQTt
         JlBQl9i/VAdoqDgDcd1l1mSHvd2HuWfVnvrek=
Subject: [PATCH 1/2] crypto: salsa20 remove private wrappers around various
 operations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 17:26:35 -0800
Message-Id: <1228785995.4353.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ROTATE -> rol32
XOR was always used with the same destination, use ^=
PLUS/PLUSONE use ++ or +=

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Herbert, perhaps slightly larger than you had in mind, but since I
was getting rid of two local-private helpers, I got rid of all of them.

 crypto/salsa20_generic.c |   75 ++++++++++++++++++++++------------------------
 1 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index b07d559..eac10c1 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include <crypto/algapi.h>
 #include <asm/byteorder.h>
 
@@ -42,10 +43,6 @@ D. J. Bernstein
 Public domain.
 */
 
-#define ROTATE(v,n) (((v) << (n)) | ((v) >> (32 - (n))))
-#define XOR(v,w) ((v) ^ (w))
-#define PLUS(v,w) (((v) + (w)))
-#define PLUSONE(v) (PLUS((v),1))
 #define U32TO8_LITTLE(p, v) \
 	{ (p)[0] = (v >>  0) & 0xff; (p)[1] = (v >>  8) & 0xff; \
 	  (p)[2] = (v >> 16) & 0xff; (p)[3] = (v >> 24) & 0xff; }
@@ -65,41 +62,41 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
 
 	memcpy(x, input, sizeof(x));
 	for (i = 20; i > 0; i -= 2) {
-		x[ 4] = XOR(x[ 4],ROTATE(PLUS(x[ 0],x[12]), 7));
-		x[ 8] = XOR(x[ 8],ROTATE(PLUS(x[ 4],x[ 0]), 9));
-		x[12] = XOR(x[12],ROTATE(PLUS(x[ 8],x[ 4]),13));
-		x[ 0] = XOR(x[ 0],ROTATE(PLUS(x[12],x[ 8]),18));
-		x[ 9] = XOR(x[ 9],ROTATE(PLUS(x[ 5],x[ 1]), 7));
-		x[13] = XOR(x[13],ROTATE(PLUS(x[ 9],x[ 5]), 9));
-		x[ 1] = XOR(x[ 1],ROTATE(PLUS(x[13],x[ 9]),13));
-		x[ 5] = XOR(x[ 5],ROTATE(PLUS(x[ 1],x[13]),18));
-		x[14] = XOR(x[14],ROTATE(PLUS(x[10],x[ 6]), 7));
-		x[ 2] = XOR(x[ 2],ROTATE(PLUS(x[14],x[10]), 9));
-		x[ 6] = XOR(x[ 6],ROTATE(PLUS(x[ 2],x[14]),13));
-		x[10] = XOR(x[10],ROTATE(PLUS(x[ 6],x[ 2]),18));
-		x[ 3] = XOR(x[ 3],ROTATE(PLUS(x[15],x[11]), 7));
-		x[ 7] = XOR(x[ 7],ROTATE(PLUS(x[ 3],x[15]), 9));
-		x[11] = XOR(x[11],ROTATE(PLUS(x[ 7],x[ 3]),13));
-		x[15] = XOR(x[15],ROTATE(PLUS(x[11],x[ 7]),18));
-		x[ 1] = XOR(x[ 1],ROTATE(PLUS(x[ 0],x[ 3]), 7));
-		x[ 2] = XOR(x[ 2],ROTATE(PLUS(x[ 1],x[ 0]), 9));
-		x[ 3] = XOR(x[ 3],ROTATE(PLUS(x[ 2],x[ 1]),13));
-		x[ 0] = XOR(x[ 0],ROTATE(PLUS(x[ 3],x[ 2]),18));
-		x[ 6] = XOR(x[ 6],ROTATE(PLUS(x[ 5],x[ 4]), 7));
-		x[ 7] = XOR(x[ 7],ROTATE(PLUS(x[ 6],x[ 5]), 9));
-		x[ 4] = XOR(x[ 4],ROTATE(PLUS(x[ 7],x[ 6]),13));
-		x[ 5] = XOR(x[ 5],ROTATE(PLUS(x[ 4],x[ 7]),18));
-		x[11] = XOR(x[11],ROTATE(PLUS(x[10],x[ 9]), 7));
-		x[ 8] = XOR(x[ 8],ROTATE(PLUS(x[11],x[10]), 9));
-		x[ 9] = XOR(x[ 9],ROTATE(PLUS(x[ 8],x[11]),13));
-		x[10] = XOR(x[10],ROTATE(PLUS(x[ 9],x[ 8]),18));
-		x[12] = XOR(x[12],ROTATE(PLUS(x[15],x[14]), 7));
-		x[13] = XOR(x[13],ROTATE(PLUS(x[12],x[15]), 9));
-		x[14] = XOR(x[14],ROTATE(PLUS(x[13],x[12]),13));
-		x[15] = XOR(x[15],ROTATE(PLUS(x[14],x[13]),18));
+		x[ 4] ^= rol32((x[ 0] + x[12]),  7);
+		x[ 8] ^= rol32((x[ 4] + x[ 0]),  9);
+		x[12] ^= rol32((x[ 8] + x[ 4]), 13);
+		x[ 0] ^= rol32((x[12] + x[ 8]), 18);
+		x[ 9] ^= rol32((x[ 5] + x[ 1]),  7);
+		x[13] ^= rol32((x[ 9] + x[ 5]),  9);
+		x[ 1] ^= rol32((x[13] + x[ 9]), 13);
+		x[ 5] ^= rol32((x[ 1] + x[13]), 18);
+		x[14] ^= rol32((x[10] + x[ 6]),  7);
+		x[ 2] ^= rol32((x[14] + x[10]),  9);
+		x[ 6] ^= rol32((x[ 2] + x[14]), 13);
+		x[10] ^= rol32((x[ 6] + x[ 2]), 18);
+		x[ 3] ^= rol32((x[15] + x[11]),  7);
+		x[ 7] ^= rol32((x[ 3] + x[15]),  9);
+		x[11] ^= rol32((x[ 7] + x[ 3]), 13);
+		x[15] ^= rol32((x[11] + x[ 7]), 18);
+		x[ 1] ^= rol32((x[ 0] + x[ 3]),  7);
+		x[ 2] ^= rol32((x[ 1] + x[ 0]),  9);
+		x[ 3] ^= rol32((x[ 2] + x[ 1]), 13);
+		x[ 0] ^= rol32((x[ 3] + x[ 2]), 18);
+		x[ 6] ^= rol32((x[ 5] + x[ 4]),  7);
+		x[ 7] ^= rol32((x[ 6] + x[ 5]),  9);
+		x[ 4] ^= rol32((x[ 7] + x[ 6]), 13);
+		x[ 5] ^= rol32((x[ 4] + x[ 7]), 18);
+		x[11] ^= rol32((x[10] + x[ 9]),  7);
+		x[ 8] ^= rol32((x[11] + x[10]),  9);
+		x[ 9] ^= rol32((x[ 8] + x[11]), 13);
+		x[10] ^= rol32((x[ 9] + x[ 8]), 18);
+		x[12] ^= rol32((x[15] + x[14]),  7);
+		x[13] ^= rol32((x[12] + x[15]),  9);
+		x[14] ^= rol32((x[13] + x[12]), 13);
+		x[15] ^= rol32((x[14] + x[13]), 18);
 	}
 	for (i = 0; i < 16; ++i)
-		x[i] = PLUS(x[i],input[i]);
+		x[i] += input[i];
 	for (i = 0; i < 16; ++i)
 		U32TO8_LITTLE(output + 4 * i,x[i]);
 }
@@ -150,9 +147,9 @@ static void salsa20_encrypt_bytes(struct salsa20_ctx *ctx, u8 *dst,
 	while (bytes) {
 		salsa20_wordtobyte(buf, ctx->input);
 
-		ctx->input[8] = PLUSONE(ctx->input[8]);
+		ctx->input[8]++;
 		if (!ctx->input[8])
-			ctx->input[9] = PLUSONE(ctx->input[9]);
+			ctx->input[9]++;
 
 		if (bytes <= 64) {
 			crypto_xor(dst, buf, bytes);
-- 
1.6.1.rc2.282.ga5881


