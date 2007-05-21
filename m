Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbXEUTf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbXEUTf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765114AbXEUTWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:25 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46504 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765521AbXEUTWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:14 -0400
Message-Id: <20070521191758.389528000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 69/69] CRYPTO: api: Read module pointer before freeing algorithm
Content-Disposition: inline; filename=crypto-api-read-module-pointer-before-freeing-algorithm.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

The function crypto_mod_put first frees the algorithm and then drops
the reference to its module.  Unfortunately we read the module pointer
which after freeing the algorithm and that pointer sits inside the
object that we just freed.

So this patch reads the module pointer out before we free the object.

Thanks to Luca Tettamanti for reporting this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 crypto/api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.21.1.orig/crypto/api.c
+++ linux-2.6.21.1/crypto/api.c
@@ -48,8 +48,10 @@ EXPORT_SYMBOL_GPL(crypto_mod_get);
 
 void crypto_mod_put(struct crypto_alg *alg)
 {
+	struct module *module = alg->cra_module;
+
 	crypto_alg_put(alg);
-	module_put(alg->cra_module);
+	module_put(module);
 }
 EXPORT_SYMBOL_GPL(crypto_mod_put);
 

-- 
