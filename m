Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbZD2BMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbZD2BMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZD2BMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:12:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbZD2BMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:12:00 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: catch base cipher self-test failures in fips mode
Date: Tue, 28 Apr 2009 21:11:51 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904282111.52074.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this might have already been posted by Neil Horman, and
we already have it in the Red Hat Enterprise Linux 5.x kernels,
but in fips mode, we need to panic on the base cipher self-tests
failing as well as the later tests.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 40c1078..5a50416 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2109,7 +2109,7 @@ static int alg_find_test(const char *alg)
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 {
 	int i;
-	int rc;
+	int rc = 0;
 
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
@@ -2122,7 +2122,8 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (i < 0)
 			goto notest;
 
-		return alg_test_cipher(alg_test_descs + i, driver, type, mask);
+		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
+		goto test_done;
 	}
 
 	i = alg_find_test(alg);
@@ -2131,14 +2132,13 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 
 	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
 				      type, mask);
+	goto test_done;
+notest:
+	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+test_done:
 	if (fips_enabled && rc)
 		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
-
 	return rc;
-
-notest:
-	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(alg_test);
 

-- 
Jarod Wilson
jarod@redhat.com
