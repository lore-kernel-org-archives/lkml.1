Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZLSCFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZLSCFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 21:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZLSCFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 21:05:23 -0500
Received: from mga10.intel.com ([192.55.52.92]:22426 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755970AbZLSCFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 21:05:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,421,1257148800"; 
   d="scan'208";a="524561348"
Date: Sat, 19 Dec 2009 04:40:43 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Fix complain about lack test for internal used algorithm
Message-ID: <20091219094043.GA23639@youquan-linux.bj.intel.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost> <20091211132321.GA17228@youquan-linux.bj.intel.com> <20091211060448.GA28704@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211060448.GA28704@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Dec 11, 2009 at 08:23:21AM -0500, Youquan,Song wrote:
> > When load aesni-intel and ghash_clmulni-intel driver,kernel will complain no
> >  test for some internal used algorithm.
> > The strange information as following:
> > 
> > alg: No test for __aes-aesni (__driver-aes-aesni)
> > alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
> > alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
> > alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)
> > alg: No test for __ghash (__ghash-pclmulqdqni)
> > alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))
> 
> I'd prefer to just add nul testmgr entries for these algorithms.

Hi Herbert,

Do you like the following modification to the patch?
If yes, I will resend the patch.

Thanks

-Youquan

---

diff --git a/crypto/algapi.c b/crypto/algapi.c
index a03ebcb..a602223 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
 #include <linux/string.h>
+#include <crypto/cryptd.h>
 
 #include "internal.h"
 
@@ -243,6 +244,32 @@ err:
 	goto out;
 }
 
+int crypto_is_internal(const char *driver)
+{
+	struct crypto_alg *q;
+	int found = 0;
+
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (!strcmp(q->cra_driver_name, driver)) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+
+		if (q->cra_priority == 0)
+			return 1;
+		if (q->cra_priority == CRYPTD_PRIORITY_ADDITION &&
+				strstr(q->cra_driver_name, "cryptd"))
+			return 1;
+	}
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(crypto_is_internal);
+
 void crypto_alg_tested(const char *name, int err)
 {
 	struct crypto_larval *test;
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index f8ae0d9..79785b7 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -275,7 +275,7 @@ static void *cryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
 
 	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
 
-	inst->alg.cra_priority = alg->cra_priority + 50;
+	inst->alg.cra_priority = alg->cra_priority + CRYPTD_PRIORITY_ADDITION;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
 	inst->alg.cra_alignmask = alg->cra_alignmask;
 
diff --git a/crypto/internal.h b/crypto/internal.h
index 2d22636..23b6498 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -101,6 +101,8 @@ int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
 int crypto_probing_notify(unsigned long val, void *v);
 
+int crypto_is_internal(const char *driver);
+
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
 	if (atomic_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f70ce52..0de1ef4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1316,6 +1316,12 @@ out:
 	return err;
 }
 
+static int alg_test_null(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	return 0;
+}
+
 static int alg_test_skcipher(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -2086,6 +2092,15 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "null",
+		.test = alg_test_null,
+		.suite = {
+			.hash = {
+				.vecs = NULL,
+				.count = 0
+			}
+		}
+	}, {
 		.alg = "pcbc(fcrypt)",
 		.test = alg_test_skcipher,
 		.suite = {
@@ -2365,6 +2380,15 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	int j;
 	int rc;
 
+	if (crypto_is_internal(driver)) {
+		i = alg_find_test("null");
+		if (i < 0)
+			goto notest;
+		rc = alg_test_descs[i].test(alg_test_descs + i, "null",
+					     type, mask);
+		goto test_done;
+
+	}
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
 
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 1c96b25..50cd473 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <crypto/hash.h>
 
+#define CRYPTD_PRIORITY_ADDITION 50
+
 struct cryptd_ablkcipher {
 	struct crypto_ablkcipher base;
 };

