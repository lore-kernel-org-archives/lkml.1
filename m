Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbYIVT3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbYIVT3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYIVT3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:29:38 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYIVT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:29:37 -0400
Date: Mon, 22 Sep 2008 15:27:27 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] trigger a panic when operating in FIPS mode and a crypto
	self test fails.
Message-ID: <20080922192727.GA4718@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	The FIPS specification requires that should self test for any supported
crypto algorithm fail during operation in fips mode, we need to prevent the use
of any crypto functionality until such time as the system can be re-initialized.
Seems like the best way to handle that would be to panic the system if we were
in fips mode and failed a self test.  This patch implements that functionality.
I've built and run it successfully with and 

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 testmgr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b828c6c..a55cd14 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1801,6 +1801,7 @@ static int alg_find_test(const char *alg)
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 {
 	int i;
+	int rc;
 
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
@@ -1820,8 +1821,12 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (i < 0)
 		goto notest;
 
-	return alg_test_descs[i].test(alg_test_descs + i, driver,
+	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
 				      type, mask);
+	if (fips_enabled && rc)
+		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
+
+	return rc;
 
 notest:
 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
