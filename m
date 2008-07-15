Return-Path: <linux-kernel-owner+w=401wt.eu-S1762431AbYGOPcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431AbYGOPcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762139AbYGOPca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:32:30 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3559 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762132AbYGOPc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:32:29 -0400
Date: Tue, 15 Jul 2008 11:31:40 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au, mingo@elte.hu,
       nhorman@tuxdriver.com
Subject: [cyrpto]: fix bad ERRPTR check in prng
Message-ID: <20080715153140.GD4918@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to correct a bad return code check from crypto_alloc_blkcipher
Also correct Kconfig to pull in the needed ciphers to make prng work when its
enabled

Signed-off-by: Neil Horman <nhorman@tuxdriver.com


 Kconfig |    3 +++
 prng.c  |    8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/crypto/Kconfig b/crypto/Kconfig
index ea50357..91e0d07 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -670,6 +670,9 @@ comment "Random Number Generation"
 
 config CRYPTO_PRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
+	select CRYPTO_AES
+	select CRYPTO_CTR
+	depends on CRYPTO
 	help
 	  This option enables the generic pseudo random number generator
 	  for cryptographic modules.  Uses the Algorithm specified in
diff --git a/crypto/prng.c b/crypto/prng.c
index 11b9306..b28f89a 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -300,6 +300,9 @@ struct prng_context *alloc_prng_context(void)
 	struct prng_context *ctx = kzalloc(sizeof(struct prng_context),
 					GFP_KERNEL);
 
+	if (!ctx)
+		return NULL;
+
 	spin_lock_init(&ctx->prng_lock);
 
 	if (reset_prng_context(ctx, NULL, NULL, NULL, NULL)) {
@@ -357,9 +360,10 @@ int reset_prng_context(struct prng_context *ctx,
 		crypto_free_blkcipher(ctx->tfm);
 
 	ctx->tfm = crypto_alloc_blkcipher("rfc3686(ctr(aes))", 0, 0);
-	if (!ctx->tfm) {
+	if (IS_ERR(ctx->tfm)) {
 		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
-			ctx->tfm);
+			ctx);
+		ctx->tfm = NULL;
 		goto out;
 	}
 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
