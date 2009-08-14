Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZHNNCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZHNNCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZHNNCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:02:44 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:33218 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753493AbZHNNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:02:43 -0400
Date: Fri, 14 Aug 2009 23:02:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Message-ID: <20090814130241.GA7068@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com> <20090805094506.GA12528@gondor.apana.org.au> <1249524767.24238.318.camel@yhuang-dev.sh.intel.com> <1250044020.5337.214.camel@yhuang-dev.sh.intel.com> <20090813045300.GA19993@gondor.apana.org.au> <20090813073910.GA21784@gondor.apana.org.au> <20090813131253.GA27289@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813131253.GA27289@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:12:53PM +1000, Herbert Xu wrote:
> 
> Actually we can't use seqiv on raw counter mode because it cannot
> guarantee IV uniqueness.  I think reverting to chainiv is the safer
> option.

In fact this is needed by all stream ciphers, not just ctr.

commit 63b5ac286d5d7f668da537cc53a552578f7674a2
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Aug 14 22:55:35 2009 +1000

    crypto: blkcipher - Do not use eseqiv on stream ciphers
    
    Recently we switched to using eseqiv on SMP machines in preference
    over chainiv.  However, eseqiv does not support stream ciphers so
    they should still default to chainiv.
    
    This patch applies the same check as done by eseqiv to weed out
    the stream ciphers.  In particular, all algorithms where the IV
    size is not equal to the block size will now default to chainiv.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 03fb5fa..f6f0833 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -183,6 +183,12 @@ EXPORT_SYMBOL_GPL(crypto_givcipher_type);
 
 const char *crypto_default_geniv(const struct crypto_alg *alg)
 {
+	if (((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
+					 alg->cra_ablkcipher.ivsize) !=
+	    alg->cra_blocksize)
+		return "chainiv";
+
 	return alg->cra_flags & CRYPTO_ALG_ASYNC ?
 	       "eseqiv" : skcipher_default_geniv;
 }

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
