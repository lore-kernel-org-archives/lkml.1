Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYDQOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYDQOXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYDQOXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:23:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48204 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755470AbYDQOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:23:39 -0400
Date: Thu, 17 Apr 2008 22:22:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joy Latten <latten@austin.ibm.com>
Subject: Re: CRYPTO xcbc: Fix crash when ipsec uses xcbc-mac with big data chunk
Message-ID: <20080417142259.GA12808@gondor.apana.org.au>
References: <20080417010122.148289106@sous-sol.org> <20080417010337.793546930@sous-sol.org> <200804171426.15334.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804171426.15334.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 02:26:12PM +0300, S.Çağlar Onur wrote:
>
>   CC [M]  crypto/xcbc.o
> crypto/xcbc.c: In function `crypto_xcbc_digest_update2':
> crypto/xcbc.c:186: error: implicit declaration of function `scatterwalk_sg_next'
> crypto/xcbc.c:186: warning: assignment makes pointer from integer without a cast
> make[1]: *** [crypto/xcbc.o] Hata 1
> make: *** [crypto] Hata 2

Sorry, my fault.  That should've been sg_next for 2.6.24.

Thanks for catching this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
From: Joy Latten <latten@austin.ibm.com>

[CRYPTO] xcbc: Fix crash when ipsec uses xcbc-mac with big data chunk

[ Upstream commit: 1edcf2e1ee2babb011cfca80ad9d202e9c491669 ]

The kernel crashes when ipsec passes a udp packet of about 14XX bytes
of data to aes-xcbc-mac.

It seems the first xxxx bytes of the data are in first sg entry,
and remaining xx bytes are in next sg entry. But we don't
check next sg entry to see if we need to go look the page up.

I noticed in hmac.c, we do a scatterwalk_sg_next(), to do this check
and possible lookup, thus xcbc.c needs to use this routine too.

A 15-hour run of an ipsec stress test sending streams of tcp and
udp packets of various sizes,  using this patch and
aes-xcbc-mac completed successfully, so hopefully this fixes the
problem.

Signed-off-by: Joy Latten <latten@austin.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 2feb0f2..b63b633 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -116,13 +116,11 @@ static int crypto_xcbc_digest_update2(struct hash_desc *pdesc,
 	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
 	struct crypto_cipher *tfm = ctx->child;
 	int bs = crypto_hash_blocksize(parent);
-	unsigned int i = 0;
 
-	do {
-
-		struct page *pg = sg_page(&sg[i]);
-		unsigned int offset = sg[i].offset;
-		unsigned int slen = sg[i].length;
+	for (;;) {
+		struct page *pg = sg_page(sg);
+		unsigned int offset = sg->offset;
+		unsigned int slen = sg->length;
 
 		if (unlikely(slen > nbytes))
 			slen = nbytes;
@@ -182,8 +180,11 @@ static int crypto_xcbc_digest_update2(struct hash_desc *pdesc,
 			offset = 0;
 			pg++;
 		}
-		i++;
-	} while (nbytes>0);
+
+		if (!nbytes)
+			break;
+		sg = sg_next(sg);
+	}
 
 	return 0;
 }

