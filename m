Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbZEHFAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbZEHFAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZEHFAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:00:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZEHFAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:00:18 -0400
Message-ID: <4A03BC5C.2040303@redhat.com>
Date: Fri, 08 May 2009 01:00:12 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 2/2] crypto: skip algs not flagged fips_allowed in fips mode
References: <200905071441.27093.jarod@redhat.com> <200905071527.59809.jarod@redhat.com> <20090508021233.GA20388@gondor.apana.org.au>
In-Reply-To: <20090508021233.GA20388@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because all fips-allowed algorithms must be self-tested before they
can be used, they will all have entries in testmgr.c's alg_test_descs[].
Skip self-tests for any algs not flagged as fips_approved and return
-EINVAL when in fips mode.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 51bae62..f93b26d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2308,6 +2308,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (i < 0)
 			goto notest;
 
+		if (fips_enabled && !alg_test_descs[i].fips_allowed)
+			goto non_fips_alg;
+
 		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
 		goto test_done;
 	}
@@ -2316,6 +2319,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (i < 0)
 		goto notest;
 
+	if (fips_enabled && !alg_test_descs[i].fips_allowed)
+		goto non_fips_alg;
+
 	rc = alg_test_descs[i].test(alg_test_descs + i, driver,
 				      type, mask);
 test_done:
@@ -2331,5 +2337,7 @@ test_done:
 notest:
 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
 	return 0;
+non_fips_alg:
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(alg_test);


-- 
Jarod Wilson
jarod@redhat.com

