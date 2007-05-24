Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbXEXWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbXEXWZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXEXWZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:25:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54998 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXEXWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:25:08 -0400
Date: Thu, 24 May 2007 15:24:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.12
Message-ID: <20070524222425.GV3429@sequoia.sous-sol.org>
References: <20070524222355.GU3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524222355.GU3429@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index f585e79..87f5956 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .11
+EXTRAVERSION = .12
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 43a6839..9dbb218 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -104,10 +104,15 @@ geode_aes_crypt(struct geode_aes_op *op)
 	u32 flags = 0;
 	int iflags;
 
-	if (op->len == 0 || op->src == op->dst)
+	if (op->len == 0)
 		return 0;
 
-	if (op->flags & AES_FLAGS_COHERENT)
+	/* If the source and destination is the same, then
+	 * we need to turn on the coherent flags, otherwise
+	 * we don't need to worry
+	 */
+
+	if (op->src == op->dst)
 		flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
 
 	if (op->dir == AES_DIR_ENCRYPT)
@@ -122,7 +127,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 		_writefield(AES_WRITEIV0_REG, op->iv);
 	}
 
-	if (op->flags & AES_FLAGS_USRKEY) {
+	if (!(op->flags & AES_FLAGS_HIDDENKEY)) {
 		flags |= AES_CTRL_WRKEY;
 		_writefield(AES_WRITEKEY0_REG, op->key);
 	}
@@ -291,6 +296,7 @@ static struct crypto_alg geode_cbc_alg = {
 			.setkey			=	geode_setkey,
 			.encrypt		=	geode_cbc_encrypt,
 			.decrypt		=	geode_cbc_decrypt,
+			.ivsize			=	AES_IV_LENGTH,
 		}
 	}
 };
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 8003a36..f479686 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -20,8 +20,7 @@
 #define AES_DIR_DECRYPT 0
 #define AES_DIR_ENCRYPT 1
 
-#define AES_FLAGS_USRKEY   (1 << 0)
-#define AES_FLAGS_COHERENT (1 << 1)
+#define AES_FLAGS_HIDDENKEY (1 << 0)
 
 struct geode_aes_op {
 
