Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXDQMgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXDQMgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 08:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbXDQMgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 08:36:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:8234 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbXDQMgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 08:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pIMJtIv2wOTLS70Sa7RSaa1/iH4dLsJM1PRWRZ2VQ1JU6zG/d/YL64xIWebTTMuN9i+3JTwnkGFQfQ3Lzp/1AFJuZUqKkNWM13npSLUmg3EKMUeCIxB7AH2FyNhtzJ795sgh+KE38PAFFCx11aX8glX8EailG9GsOUvKlnha9yM=
Message-ID: <38b2ab8a0704170536x15920b15xedfd518cad50cee@mail.gmail.com>
Date: Tue, 17 Apr 2007 14:36:09 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
In-Reply-To: <20070417004117.GA16513@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704141410q65f55381w26527aeb10fb4988@mail.gmail.com>
	 <20070415075201.GA1644@gondor.apana.org.au>
	 <38b2ab8a0704160137g1ef0713fl943c51ed9049212b@mail.gmail.com>
	 <20070417004117.GA16513@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Apr 16, 2007 at 10:37:01AM +0200, Francis Moreau wrote:
> >
> > BTW, here are figures I got with 2 different versions of the driver
> > when using tcrypt module. The second being the result with the
> > optimized driver (no key reloading on each block):
> >
> > normal version:
> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 67991 cycles (8192
> > bytes)
> >
> > optimized version:
> > test 4 (128 bit key, 8192 byte blocks): 1 operation in 51783 cycles (8192
> > bytes)
> >
> > So the gain is 16000 cycles which seems to worth the change, isn't it ?
>
> Sounds like it would.  It would help of course if you posted the patch :)
>

OK, I tried to cook up something very simple. Since I don't know this
code, please be indulgent when reading the following patch ;)

diff --git a/crypto/api.c b/crypto/api.c
index 55af8bb..f067de8 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -71,6 +71,10 @@ struct crypto_alg *__crypto_alg_lookup(const char
*name, u32 type, u32 mask)
 		    ((struct crypto_larval *)q)->mask != mask)
 			continue;

+		if (alg->cra_flags & CRYPTO_ALG_EXCLUSIVE &&
+		    atomic_read(&alg->cra_refcnt) > 0)
+			continue;
+
 		exact = !strcmp(q->cra_driver_name, name);
 		fuzzy = !strcmp(q->cra_name, name);
 		if (!exact && !(fuzzy && q->cra_priority > best))
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 779aa78..278d386 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -41,6 +41,7 @@
 #define CRYPTO_ALG_DEAD			0x00000020
 #define CRYPTO_ALG_DYING		0x00000040
 #define CRYPTO_ALG_ASYNC		0x00000080
+#define CRYPTO_ALG_EXCLUSIVE		0x00000100

 /*
  * Set this bit if and only if the algorithm requires another algorithm of

-- 
Francis
