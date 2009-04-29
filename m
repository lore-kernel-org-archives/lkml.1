Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZD2BSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZD2BSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZD2BSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:18:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbZD2BSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:18:37 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in fips mode
Date: Tue, 28 Apr 2009 21:18:22 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904282118.22823.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the NIST AESAVS document, Appendix A[1], it isn't possible to
have automated self-tests for counter-mode AES, but people are
misled to believe something is wrong by the message that says there
is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
messages if fips_enabled is set to avoid confusion.

Dependent on earlier patch 'crypto: catch base cipher self-test
failures in fips mode', which adds the test_done label.

[1] http://csrc.nist.gov/groups/STM/cavp/documents/aes/AESAVS.pdf

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5a50416..39ffa69 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2134,6 +2134,17 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 				      type, mask);
 	goto test_done;
 notest:
+	/*
+	 * Per NIST AESAVS[1], it isn't possible to have automated self-tests
+	 * for counter mode aes vectors, they have to be covered by ecb mode
+	 * and code inspection. The ecb mode tests are trigger above in the
+	 * CRYPTO_ALG_TYPE_CIPHER section. Suppress warnings about missing
+	 * ctr tests if we're in fips mode to avoid confusion.
+	 *
+	 * [1] http://csrc.nist.gov/groups/STM/cavp/documents/aes/AESAVS.pdf
+	 */
+	if (fips_enabled && !strncmp(alg, "ctr(aes", 7))
+		goto test_done;
 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
 test_done:
 	if (fips_enabled && rc)

-- 
Jarod Wilson
jarod@redhat.com
