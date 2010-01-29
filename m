Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125Ab0A2N1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0A2N1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876Ab0A2N1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:27:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50357 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0A2N1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=G6qfX+0dL0r2sN2czAet3KcVotN57Q4KfCxdo+cXd6XMPEukBndABnIthYbXi9crOs
         pDsiR6wf3QKVKRtrPFnK61lf+4gs+mWpiz6f0GtiKHJ0DIghLdoL1WbvgM/OCSKwsWdz
         2TRNaaQWrP9/5TwoykEhMf7vHFr4t0q8nJNdY=
Message-ID: <4B62E388.1070707@gmail.com>
Date: Fri, 29 Jan 2010 14:32:56 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] geode: Fix cip/blk confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto_cipher cip members were set where crypto_cipher blk members should
have been, also the PTR_ERR of the wrong pointer was returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This was already discussed in december/januari but I still cannot find it in
mainline, was it lost?

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6be4503..58f4673 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -78,14 +78,14 @@ static int setkey_fallback_cip(struct crypto_tfm *tfm, const u8 *in_key,
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 	int ret;
 
-	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
+	sctx->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	sctx->fallback.cip->base.crt_flags |= (tfm->crt_flags &
 			CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
+		tfm->crt_flags |= (sctx->fallback.cip->base.crt_flags &
 				CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..c7a5a43 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -135,13 +135,13 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	op->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	op->fallback.cip->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= (op->fallback.cip->base.crt_flags & CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
 }
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}
 
 	return 0;
