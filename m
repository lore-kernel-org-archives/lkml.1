Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYCUW7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYCUW7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762997AbYCUWus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:48 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59280 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762979AbYCUWup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:45 -0400
Message-Id: <20080321224352.047750900@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Sebastian Siewior <sebastian@breakpoint.cc>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 24/76] CRYPTO xts: Use proper alignment
Content-Disposition: inline; filename=crypto-xts-use-proper-alignment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Sebastian Siewior <sebastian@breakpoint.cc>

[ Upstream commit: 6212f2c7f70c591efb0d9f3d50ad29112392fee2 ]

The XTS blockmode uses a copy of the IV which is saved on the stack
and may or may not be properly aligned. If it is not, it will break
hardware cipher like the geode or padlock.
This patch encrypts the IV in place so we don't have to worry about
alignment.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Tested-by: Stefan Hellermann <stefan@the2masters.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 crypto/xts.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -77,16 +77,16 @@ static int setkey(struct crypto_tfm *par
 }
 
 struct sinfo {
-	be128 t;
+	be128 *t;
 	struct crypto_tfm *tfm;
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
 };
 
 static inline void xts_round(struct sinfo *s, void *dst, const void *src)
 {
-	be128_xor(dst, &s->t, src);		/* PP <- T xor P */
+	be128_xor(dst, s->t, src);		/* PP <- T xor P */
 	s->fn(s->tfm, dst, dst);		/* CC <- E(Key1,PP) */
-	be128_xor(dst, dst, &s->t);		/* C <- T xor CC */
+	be128_xor(dst, dst, s->t);		/* C <- T xor CC */
 }
 
 static int crypt(struct blkcipher_desc *d,
@@ -101,7 +101,6 @@ static int crypt(struct blkcipher_desc *
 		.tfm = crypto_cipher_tfm(ctx->child),
 		.fn = fn
 	};
-	be128 *iv;
 	u8 *wsrc;
 	u8 *wdst;
 
@@ -109,20 +108,20 @@ static int crypt(struct blkcipher_desc *
 	if (!w->nbytes)
 		return err;
 
+	s.t = (be128 *)w->iv;
 	avail = w->nbytes;
 
 	wsrc = w->src.virt.addr;
 	wdst = w->dst.virt.addr;
 
 	/* calculate first value of T */
-	iv = (be128 *)w->iv;
-	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s.t, w->iv);
+	tw(crypto_cipher_tfm(ctx->tweak), w->iv, w->iv);
 
 	goto first;
 
 	for (;;) {
 		do {
-			gf128mul_x_ble(&s.t, &s.t);
+			gf128mul_x_ble(s.t, s.t);
 
 first:
 			xts_round(&s, wdst, wsrc);

-- 
