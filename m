Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYKCVY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYKCVY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYKCVYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:24:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51676 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYKCVYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:24:47 -0500
Date: Mon, 3 Nov 2008 16:22:40 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nhorman@tuxdriver.com, jarod@redhat.com
Subject: [PATCH] crypto: extend ansi_cprng to allow resetting of DT value
Message-ID: <20081103212240.GB24888@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	This is a patch that was sent to me by Jarod Wilson, marking off my
outstanding todo to allow the ansi cprng to set/reset the DT counter value in a
cprng instance.  Currently crytpo_rng_reset accepts a seed byte array which is
interpreted by the ansi_cprng as a {V key} tuple.  This patch extends that tuple
to now be {V key DT}, with DT an optional value during reset.  This patch also
fixes  a bug we noticed in which the offset of the key area of the seed is
started at DEFAULT_PRNG_KSZ rather than DEFAULT_BLK_SZ as it should be.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 ansi_cprng.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 72db0fd..486aa93 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -349,15 +349,25 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 	return get_prng_bytes(rdata, dlen, prng);
 }
 
+/*
+ *  This is the cprng_registered reset method the seed value is
+ *  interpreted as the tuple { V KEY DT}
+ *  V and KEY are required during reset, and DT is optional, detected
+ *  as being present by testing the length of the seed
+ */
 static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
-	u8 *key = seed + DEFAULT_PRNG_KSZ;
+	u8 *key = seed + DEFAULT_BLK_SZ;
+	u8 *dt = NULL;
 
 	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
 		return -EINVAL;
 
-	reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, NULL);
+	if (slen >= (2 * DEFAULT_BLK_SZ + DEFAULT_PRNG_KSZ))
+		dt = key + DEFAULT_PRNG_KSZ;
+
+	reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, dt);
 
 	if (prng->flags & PRNG_NEED_RESET)
 		return -EINVAL;
@@ -379,7 +389,7 @@ static struct crypto_alg rng_alg = {
 		.rng = {
 			.rng_make_random	= cprng_get_random,
 			.rng_reset		= cprng_reset,
-			.seedsize = DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ,
+			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
 		}
 	}
 };
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
