Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXLNCER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXLNCER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbXLNCEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:04:05 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41521 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760943AbXLNCEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:04:04 -0500
Date: Thu, 13 Dec 2007 21:03:46 -0500
Message-Id: <200712140203.lBE23kF6021203@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
       akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: aead_geniv_* [crypto/seqiv.ko] undefined! (MMOTM stamp-2007-12-13-15-37)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting undefined symbols while building MMOTM kernel
stamp-2007-12-13-15-37:

  MODPOST 32 modules
ERROR: "aead_geniv_exit" [crypto/seqiv.ko] undefined!
ERROR: "aead_geniv_alloc" [crypto/seqiv.ko] undefined!
ERROR: "aead_geniv_init" [crypto/seqiv.ko] undefined!
ERROR: "aead_geniv_free" [crypto/seqiv.ko] undefined!
make[1]: *** [__modpost] Error 1

My defined kernel symbols which are relevant are:

CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_CAST5=m

The missing symbols are in crypto/aead.c, but aead.c doesn't get compiled
in.  It can't be compiled in b/c the config option for it doesn't seem to
show up in "make menuconfig".  This simple patch makes the symbol show up in
menuconfig so I can turn it on:

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 304ecc7..6876abe 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -25,7 +25,7 @@ config CRYPTO_ALGAPI
 	  This option provides the API for cryptographic algorithms.
 
 config CRYPTO_AEAD
-	tristate
+	tristate "AEAD: Authenticated Encryption with Associated Data"
 	select CRYPTO_ALGAPI
 
 config CRYPTO_BLKCIPHER

*However*, while the above small patch resolves the symbols, there's still a
problem: crypto/seqiv.c seems to depend unconditionally on symbols in
crypto/aead.c, so maybe seqiv.c needs some #ifdef CONFIG_CRYPTO_AEAD or
something.

Cheers,
Erez.
