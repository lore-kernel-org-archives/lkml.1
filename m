Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZLKFrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZLKFrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZLKFrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:47:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:8401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZLKFrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:47:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,379,1257148800"; 
   d="scan'208";a="474865169"
Date: Fri, 11 Dec 2009 08:23:21 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: [PATCH]crypto: Fix complain about lack test for internal used algorithm
Message-ID: <20091211132321.GA17228@youquan-linux.bj.intel.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de> <200912102013.59329.david-b@pacbell.net> <20091211043849.GA18007@suse.de> <1260509771.12346.138.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260509771.12346.138.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When load aesni-intel and ghash_clmulni-intel driver,kernel will complain no
 test for some internal used algorithm.
The strange information as following:

alg: No test for __aes-aesni (__driver-aes-aesni)
alg: No test for __ecb-aes-aesni (__driver-ecb-aes-aesni)
alg: No test for __cbc-aes-aesni (__driver-cbc-aes-aesni)
alg: No test for __ecb-aes-aesni (cryptd(__driver-ecb-aes-aesni)
alg: No test for __ghash (__ghash-pclmulqdqni)
alg: No test for __ghash (cryptd(__ghash-pclmulqdqni))

After summarize, the internal used algorithm driver with priority equal 0 or
equal 50 when cryptd is used.

This patch add function to check driver is internal used and will shut up when
internal driver is not tested.  

Signed-off-by: Youquan, Song <youquan.song@intel.com>
Signed-off-by: Ying, Huang <ying.huang@intel.com>
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
index fe68115..542941c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2413,7 +2413,8 @@ test_done:
 	return rc;
 
 notest:
-	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+	if (!crypto_is_internal(driver))
+		printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
 	return 0;
 non_fips_alg:
 	return -EINVAL;
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
