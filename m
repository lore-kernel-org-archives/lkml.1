Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYLIB1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYLIB1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 20:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYLIB0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 20:26:43 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:61392 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYLIB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 20:26:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wwtMoE3BUzZKg9dDnzIrtG405JoxnRMpLYjFfLAsedYbiJ82+aECEe9lPWQNY38B83
         YH9wNeGs4COxkOfYnOaPdKgyH1OPbSoRNtfH5Bsu6wyvLChNYNbBbGSxTEb+ZjDtvt1k
         iIzVER3f8A8QpK+BAXT75ElMnhPkY96yWf2WE=
Subject: [PATCH 2/2] crypto: salsa20 use endian access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 17:26:36 -0800
Message-Id: <1228785996.4353.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aligned versions are suitable as this hash sets alignmask = 3
so the iv and key passed in will be 4-byte aligned.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Herbert, as requested this is the aligned version.  Apologies for the
idiotic MAKE_U32 macro....I wanted to make sure this gets done at compile
time.  I hope the comment is sufficient, please feel free to suggest something
better and I'll revise.  Other than that wart, it is pretty simple.

This depends on the load/store api which is -mm only, so don't apply directly
until the helpers are upstream.

 crypto/salsa20_generic.c |   60 ++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index eac10c1..93ea772 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -43,13 +43,6 @@ D. J. Bernstein
 Public domain.
 */
 
-#define U32TO8_LITTLE(p, v) \
-	{ (p)[0] = (v >>  0) & 0xff; (p)[1] = (v >>  8) & 0xff; \
-	  (p)[2] = (v >> 16) & 0xff; (p)[3] = (v >> 24) & 0xff; }
-#define U8TO32_LITTLE(p)   \
-	(((u32)((p)[0])      ) | ((u32)((p)[1]) <<  8) | \
-	 ((u32)((p)[2]) << 16) | ((u32)((p)[3]) << 24)   )
-
 struct salsa20_ctx
 {
 	u32 input[16];
@@ -98,40 +91,51 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
 	for (i = 0; i < 16; ++i)
 		x[i] += input[i];
 	for (i = 0; i < 16; ++i)
-		U32TO8_LITTLE(output + 4 * i,x[i]);
+		store_le32((__le32 *)(output + 4 * i), x[i]);
 }
 
-static const char sigma[16] = "expand 32-byte k";
-static const char tau[16] = "expand 16-byte k";
-
 static void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k, u32 kbytes)
 {
-	const char *constants;
+	int usesigma;
 
-	ctx->input[1] = U8TO32_LITTLE(k + 0);
-	ctx->input[2] = U8TO32_LITTLE(k + 4);
-	ctx->input[3] = U8TO32_LITTLE(k + 8);
-	ctx->input[4] = U8TO32_LITTLE(k + 12);
+	ctx->input[1] = load_le32((__le32 *)(k + 0));
+	ctx->input[2] = load_le32((__le32 *)(k + 4));
+	ctx->input[3] = load_le32((__le32 *)(k + 8));
+	ctx->input[4] = load_le32((__le32 *)(k + 12));
 	if (kbytes == 32) { /* recommended */
 		k += 16;
-		constants = sigma;
+		usesigma = 1;
 	} else { /* kbytes == 16 */
-		constants = tau;
+		usesigma = 0;
+	}
+	ctx->input[11] = load_le32((__le32 *)(k + 0));
+	ctx->input[12] = load_le32((__le32 *)(k + 4));
+	ctx->input[13] = load_le32((__le32 *)(k + 8));
+	ctx->input[14] = load_le32((__le32 *)(k + 12));
+	/*
+	 * Choice of two similar strings used in initialization:
+	 * sigma - "expand 32-byte k"
+	 * tau   - "expand 16-byte k"
+	 * which differ only in bytes 7-8. (16 vs 32)
+	 */
+#define MAKE_U32(s) ((u32)(s[0]) | ((u32)(s[1]) << 8) | \
+		    ((u32)(s[2]) << 16) | ((u32)(s[3]) << 24))
+	ctx->input[ 0] = MAKE_U32("expa");
+	if (usesigma) {
+		ctx->input[ 5] = MAKE_U32("nd 3");
+		ctx->input[10] = MAKE_U32("2-by");
+	} else {
+		ctx->input[ 5] = MAKE_U32("nd 1");
+		ctx->input[10] = MAKE_U32("6-by");
 	}
-	ctx->input[11] = U8TO32_LITTLE(k + 0);
-	ctx->input[12] = U8TO32_LITTLE(k + 4);
-	ctx->input[13] = U8TO32_LITTLE(k + 8);
-	ctx->input[14] = U8TO32_LITTLE(k + 12);
-	ctx->input[0] = U8TO32_LITTLE(constants + 0);
-	ctx->input[5] = U8TO32_LITTLE(constants + 4);
-	ctx->input[10] = U8TO32_LITTLE(constants + 8);
-	ctx->input[15] = U8TO32_LITTLE(constants + 12);
+	ctx->input[15] = MAKE_U32("te k");
+#undef MAKE_U32
 }
 
 static void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv)
 {
-	ctx->input[6] = U8TO32_LITTLE(iv + 0);
-	ctx->input[7] = U8TO32_LITTLE(iv + 4);
+	ctx->input[6] = load_le32((__le32 *)(iv + 0));
+	ctx->input[7] = load_le32((__le32 *)(iv + 4));
 	ctx->input[8] = 0;
 	ctx->input[9] = 0;
 }
-- 
1.6.1.rc2.282.ga5881

