Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbXESEug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbXESEug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 00:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXESEu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 00:50:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2298 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755016AbXESEu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 00:50:28 -0400
Date: Sat, 19 May 2007 14:50:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070519045021.GA3649@gondor.apana.org.au>
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan> <20070515014344.GA8850@gondor.apana.org.au> <20070515185212.GA18783@dreamland.darkstar.lan> <20070518031931.GA13048@gondor.apana.org.au> <68676e00705180509s64b737e2k37c5b2e713c96932@mail.gmail.com> <20070518131455.GA20918@gondor.apana.org.au> <20070518191645.GA10815@dreamland.darkstar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518191645.GA10815@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 09:16:45PM +0200, Luca Tettamanti wrote:
> 
> Output from serial console is enlightening (sort of...):
> 
> Loading IPsec SA/SP database from /etc/ipsec-tools.conf: BUG: unable to
> handle kernel paging request at virtual address 6b6b6ceb printing eip:
> b0141aef
> [oops]

Thanks.  Turns out to be a silly bug :) It's been around for a while
though.

[CRYPTO] api: Read module pointer before freeing algorithm

The function crypto_mod_put first frees the algorithm and then drops
the reference to its module.  Unfortunately we read the module pointer
which after freeing the algorithm and that pointer sits inside the
object that we just freed.

So this patch reads the module pointer out before we free the object.

Thanks to Luca Tettamanti for reporting this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/api.c b/crypto/api.c
index 55af8bb..33734fd 100644
--- a/crypto/api.c
+++ b/crypto/api.c
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
 
