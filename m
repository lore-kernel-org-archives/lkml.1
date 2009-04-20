Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbZDTWOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbZDTWOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbZDTWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:14:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53181 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbZDTWOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:14:42 -0400
Date: Mon, 20 Apr 2009 18:14:02 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: VIA Padlock driver no longer loads automatically
Message-ID: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 machines only aes_generic and aes_i586 get loaded automatically as of
kernel 2.6.29. Looks like this was caused by:

  commit a760a6656e6f00bb0144a42a048cf0266646e22c
  crypto: api - Fix module load deadlock with fallback algorithms

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index c42cd89..6118890 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -556,7 +556,7 @@ static void __exit aes_s390_fini(void)
 module_init(aes_s390_init);
 module_exit(aes_s390_fini);
 
-MODULE_ALIAS("aes");
+MODULE_ALIAS("aes-all");
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("GPL");
diff --git a/crypto/api.c b/crypto/api.c
index efe77df..38a2bc0 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -215,8 +215,19 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 	mask &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 	type &= mask;
 
-	alg = try_then_request_module(crypto_alg_lookup(name, type, mask),
-				      name);
+	alg = crypto_alg_lookup(name, type, mask);
+	if (!alg) {
+		char tmp[CRYPTO_MAX_ALG_NAME];
+
+		request_module(name);
+
+		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask) &&
+		    snprintf(tmp, sizeof(tmp), "%s-all", name) < sizeof(tmp))
+			request_module(tmp);
+
+		alg = crypto_alg_lookup(name, type, mask);
+	}
+
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 856b3cc..3f0fdd1 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -489,4 +489,4 @@ MODULE_DESCRIPTION("VIA PadLock AES algorithm support");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("aes");
+MODULE_ALIAS("aes-all");
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index a7fbade..a2c8e85 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -304,7 +304,7 @@ MODULE_DESCRIPTION("VIA PadLock SHA1/SHA256 algorithms support.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("sha1");
-MODULE_ALIAS("sha256");
+MODULE_ALIAS("sha1-all");
+MODULE_ALIAS("sha256-all");
 MODULE_ALIAS("sha1-padlock");
 MODULE_ALIAS("sha256-padlock");
