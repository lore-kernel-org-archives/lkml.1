Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYLGPzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYLGPzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 10:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYLGPzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 10:55:20 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43912 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753233AbYLGPzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 10:55:19 -0500
Date: Sun, 7 Dec 2008 23:55:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kay.sievers@vrfy.org, zbr@ioremap.net, linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207155507.GA15355@gondor.apana.org.au>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 10:49:27PM +0800, Herbert Xu wrote:
>
> In any case the loop itself does not involve any crypto components
> so I don't think making changes in the crypto layer is going to
> make this go away forever as anyone calling request_module early
> enough will get into this loop.

Having said that I think this patch should remove this particular
trigger.  Unfortunately I couldn't find a more succinct way of
expressing this relationship: if ALGAPI is built-in because it's
selected by an algorithm, and CRYPTO_MANAGER is enabled then we
require CRYPTO_MANAGER to be built-in as well.

Evgeniy, please let me know whether this fixes the problem.

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6593b5a..3f88a52 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -31,35 +31,63 @@ config CRYPTO_FIPS
 
 config CRYPTO_ALGAPI
 	tristate
+	select CRYPTO_ALGAPI2
 	help
 	  This option provides the API for cryptographic algorithms.
 
+config CRYPTO_ALGAPI2
+	tristate
+
 config CRYPTO_AEAD
 	tristate
+	select CRYPTO_AEAD2
 	select CRYPTO_ALGAPI
 
+config CRYPTO_AEAD2
+	tristate
+	select CRYPTO_ALGAPI2
+
 config CRYPTO_BLKCIPHER
 	tristate
+	select CRYPTO_BLKCIPHER2
 	select CRYPTO_ALGAPI
-	select CRYPTO_RNG
+
+config CRYPTO_BLKCIPHER2
+	tristate
+	select CRYPTO_ALGAPI2
+	select CRYPTO_RNG2
 
 config CRYPTO_HASH
 	tristate
+	select CRYPTO_HASH2
 	select CRYPTO_ALGAPI
 
+config CRYPTO_HASH2
+	tristate
+	select CRYPTO_ALGAPI2
+
 config CRYPTO_RNG
 	tristate
+	select CRYPTO_RNG2
 	select CRYPTO_ALGAPI
 
+config CRYPTO_RNG2
+	tristate
+	select CRYPTO_ALGAPI2
+
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
-	select CRYPTO_AEAD
-	select CRYPTO_HASH
-	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER2
 	help
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
 
+config CRYPTO_MANAGER2
+	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
+	select CRYPTO_AEAD2
+	select CRYPTO_HASH2
+	select CRYPTO_BLKCIPHER2
+
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/crypto/Makefile b/crypto/Makefile
index 0e93f32..73e7c30 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -9,25 +9,25 @@ obj-$(CONFIG_CRYPTO_FIPS) += fips.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
-obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
+obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
-obj-$(CONFIG_CRYPTO_AEAD) += aead.o
+obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
 
 crypto_blkcipher-objs := ablkcipher.o
 crypto_blkcipher-objs += blkcipher.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER) += chainiv.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER) += eseqiv.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER2) += chainiv.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER2) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
 crypto_hash-objs += ahash.o
 crypto_hash-objs += shash.o
-obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
+obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 cryptomgr-objs := algboss.o testmgr.o
 
-obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
+obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
