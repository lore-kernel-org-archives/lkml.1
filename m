Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZKTNwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZKTNwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZKTNwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:52:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:45136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZKTNwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:52:09 -0500
Subject: [PATCH] crypto: move fips_cprng_get_random and fips_cprng_reset to
 CONFIG_CRYPTO_FIPS
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>, Jarod Wilson <jarod@redhat.com>,
       David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 19:20:19 +0530
Message-Id: <1258725019.3562.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fips_cprng_get_random and fips_cprng_reset is used only by
CONFIG_CRYPTO_FIPS. This also fixes compilation warnings:

 crypto/ansi_cprng.c:360: warning: ‘fips_cprng_get_random’ defined but not used
 crypto/ansi_cprng.c:393: warning: ‘fips_cprng_reset’ defined but not used

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 crypto/ansi_cprng.c |   56 +++++++++++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 45bd218..2bc3321 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -357,14 +357,6 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 	return get_prng_bytes(rdata, dlen, prng, 0);
 }
 
-static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
-			    unsigned int dlen)
-{
-	struct prng_context *prng = crypto_rng_ctx(tfm);
-
-	return get_prng_bytes(rdata, dlen, prng, 1);
-}
-
 /*
  *  This is the cprng_registered reset method the seed value is
  *  interpreted as the tuple { V KEY DT}
@@ -390,26 +382,6 @@ static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 	return 0;
 }
 
-static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
-{
-	u8 rdata[DEFAULT_BLK_SZ];
-	int rc;
-
-	struct prng_context *prng = crypto_rng_ctx(tfm);
-
-	rc = cprng_reset(tfm, seed, slen);
-
-	if (!rc)
-		goto out;
-
-	/* this primes our continuity test */
-	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
-	prng->rand_data_valid = DEFAULT_BLK_SZ;
-
-out:
-	return rc;
-}
-
 static struct crypto_alg rng_alg = {
 	.cra_name		= "stdrng",
 	.cra_driver_name	= "ansi_cprng",
@@ -431,6 +403,34 @@ static struct crypto_alg rng_alg = {
 };
 
 #ifdef CONFIG_CRYPTO_FIPS
+static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
+			    unsigned int dlen)
+{
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+
+	return get_prng_bytes(rdata, dlen, prng, 1);
+}
+
+static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	u8 rdata[DEFAULT_BLK_SZ];
+	int rc;
+
+	struct prng_context *prng = crypto_rng_ctx(tfm);
+
+	rc = cprng_reset(tfm, seed, slen);
+
+	if (!rc)
+		goto out;
+
+	/* this primes our continuity test */
+	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
+	prng->rand_data_valid = DEFAULT_BLK_SZ;
+
+out:
+	return rc;
+}
+
 static struct crypto_alg fips_rng_alg = {
 	.cra_name		= "fips(ansi_cprng)",
 	.cra_driver_name	= "fips_ansi_cprng",
-- 
1.6.5.3


