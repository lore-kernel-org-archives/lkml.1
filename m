Return-Path: <linux-kernel-owner+w=401wt.eu-S935193AbZLGON2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193AbZLGON2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935160AbZLGON0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:13:26 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59568 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935156AbZLGONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:13:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sjtlEm91gSlN/9elVn4gdJiHcz1V4eKWqwGrb/lhtxOQTn1BpzzjDyKh79ARcEJcQB
         jk39VqhQNZkf7StKhustt1UeIvvHiHE6imcoCKd136tgLLgLHTY85BpWbqTGWQ5Js/zQ
         YWpxXdFVppGLUjiFR9qU20TfMBa5pjqrqJfm4=
Message-ID: <4B1D0DC9.5000908@gmail.com>
Date: Mon, 07 Dec 2009 15:14:33 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sergey Mironov <ierton@gmail.com>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in fallback_init_cip()
References: <4B1D02F7.2020505@gmail.com> <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
In-Reply-To: <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> This is correct however you missed one spot a few lines above that one.
> Sergey Mironov sent a patch a while ago unfortunatelly a mangled one and
> he hasn't resent it yet.
> Could you please look at [0] for the missing spot? If you had fun fixing
> that one, I've a made a similar mistake in s390's driver [1]. If not
> please say so.

Yes, I found that one too, although I sent a patch in a seperate thread.
You can ignore that and ack this if you like it.
I did not find the additional mistakes, though, so a new patch below.

> [0] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03883.html
> [1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03888.html
> 
> Sebastian

Thanks,

Roel

 arch/s390/crypto/aes_s390.c |    8 ++++----
 drivers/crypto/geode-aes.c  |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6118890..58f4673 100644
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
@@ -174,7 +174,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 	if (IS_ERR(sctx->fallback.cip)) {
 		pr_err("Allocating AES fallback algorithm %s failed\n",
 		       name);
-		return PTR_ERR(sctx->fallback.blk);
+		return PTR_ERR(sctx->fallback.cip);
 	}
 
 	return 0;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..03e71b1 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -135,8 +135,8 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	op->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	op->fallback.cip->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}
 
 	return 0;
