Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXEXW1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXEXW1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXEXW0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:26:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55020 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbXEXW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:26:52 -0400
Date: Thu, 24 May 2007 15:26:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.21.3
Message-ID: <20070524222609.GX3429@sequoia.sous-sol.org>
References: <20070524222541.GW3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524222541.GW3429@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 22839cb..7980f39 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 21
-EXTRAVERSION = .2
+EXTRAVERSION = .3
 NAME = Nocturnal Monster Puppy
 
 # *DOCUMENTATION*
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 6d3840e..6a86958 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -102,10 +102,15 @@ geode_aes_crypt(struct geode_aes_op *op)
 	u32 flags = 0;
 	unsigned long iflags;
 
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
@@ -120,7 +125,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 		_writefield(AES_WRITEIV0_REG, op->iv);
 	}
 
-	if (op->flags & AES_FLAGS_USRKEY) {
+	if (!(op->flags & AES_FLAGS_HIDDENKEY)) {
 		flags |= AES_CTRL_WRKEY;
 		_writefield(AES_WRITEKEY0_REG, op->key);
 	}
@@ -289,6 +294,7 @@ static struct crypto_alg geode_cbc_alg = {
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
 
