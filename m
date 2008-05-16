Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYEPGRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYEPGRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYEPGR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:17:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:22507 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYEPGR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GcMh6Ns1DdwiqP1vXxzjBQAhyfM/b1RJ602nyGkQz6uPUx6fR95yOMxr+iL65rq5SyRRw96rZ6cGBb/TINFfUGudJx+L+Gcr5wu41dEj3SzbpY4JZ9ZTR9LncRnVpK1knktQw8wxidOA/aQmX0EFxJOWB/BQHd/3itsY/fU8wbw=
Subject: [PATCH] crypto: make michael_block a function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 23:17:17 -0700
Message-Id: <1210918637.5915.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the michael_block macro a function and change the calling
function to take a struct michael_mic_ctx * and the value for
the initial xor with ctx->l.

Also open-code xswap in its one use in michael_block.

Some use of get_unaligned is probably needed as an add-on.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 crypto/michael_mic.c |   55 +++++++++++++++++++++----------------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 9e917b8..792dbf9 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -31,19 +31,18 @@ static inline u32 xswap(u32 val)
 	return ((val & 0x00ff00ff) << 8) | ((val & 0xff00ff00) >> 8);
 }
 
-
-#define michael_block(l, r)	\
-do {				\
-	r ^= rol32(l, 17);	\
-	l += r;			\
-	r ^= xswap(l);		\
-	l += r;			\
-	r ^= rol32(l, 3);	\
-	l += r;			\
-	r ^= ror32(l, 2);	\
-	l += r;			\
-} while (0)
-
+static void michael_block(struct michael_mic_ctx *ctx, u32 val)
+{
+	ctx->l ^= val;
+	ctx->r ^= rol32(ctx->l, 17);
+	ctx->l += ctx->r;
+	ctx->r ^= ((ctx->l & 0x00ff00ff) << 8) | ((ctx->l & 0xff00ff00) >> 8);
+	ctx->l += ctx->r;
+	ctx->r ^= rol32(ctx->l, 3);
+	ctx->l += ctx->r;
+	ctx->r ^= ror32(ctx->l, 2);
+	ctx->l += ctx->r;
+}
 
 static void michael_init(struct crypto_tfm *tfm)
 {
@@ -71,16 +70,14 @@ static void michael_update(struct crypto_tfm *tfm, const u8 *data,
 			return;
 
 		src = (const __le32 *)mctx->pending;
-		mctx->l ^= le32_to_cpup(src);
-		michael_block(mctx->l, mctx->r);
+		michael_block(mctx, le32_to_cpup(src));
 		mctx->pending_len = 0;
 	}
 
 	src = (const __le32 *)data;
 
 	while (len >= 4) {
-		mctx->l ^= le32_to_cpup(src++);
-		michael_block(mctx->l, mctx->r);
+		michael_block(mctx, le32_to_cpup(src++));
 		len -= 4;
 	}
 
@@ -96,26 +93,22 @@ static void michael_final(struct crypto_tfm *tfm, u8 *out)
 	struct michael_mic_ctx *mctx = crypto_tfm_ctx(tfm);
 	u8 *data = mctx->pending;
 	__le32 *dst = (__le32 *)out;
+	u32 tmp;
 
 	/* Last block and padding (0x5a, 4..7 x 0) */
+	tmp = 0x5a;
 	switch (mctx->pending_len) {
-	case 0:
-		mctx->l ^= 0x5a;
-		break;
-	case 1:
-		mctx->l ^= data[0] | 0x5a00;
-		break;
-	case 2:
-		mctx->l ^= data[0] | (data[1] << 8) | 0x5a0000;
-		break;
 	case 3:
-		mctx->l ^= data[0] | (data[1] << 8) | (data[2] << 16) |
-			0x5a000000;
+		tmp = (tmp << 8) | data[2];
+	case 2:
+		tmp = (tmp << 8) | data[1];
+	case 1:
+		tmp = (tmp << 8) | data[0];
+	case 0:
 		break;
 	}
-	michael_block(mctx->l, mctx->r);
-	/* l ^= 0; */
-	michael_block(mctx->l, mctx->r);
+	michael_block(mctx, tmp);
+	michael_block(mctx, 0);
 
 	dst[0] = cpu_to_le32(mctx->l);
 	dst[1] = cpu_to_le32(mctx->r);
-- 
1.5.5.1.570.g26b5e



