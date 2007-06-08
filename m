Return-Path: <linux-kernel-owner+w=401wt.eu-S968381AbXFHHdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968381AbXFHHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938333AbXFHHXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:20 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58275 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938281AbXFHHXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:18 -0400
Message-Id: <20070608071539.568721000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:21 -0700
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
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/32] CRYPTO: api: Read module pointer before freeing algorithm
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.20.13.orig/crypto/api.c
+++ linux-2.6.20.13/crypto/api.c
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
