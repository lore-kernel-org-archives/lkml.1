Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZAPHKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZAPHKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZAPHKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:10:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:29107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZAPHKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:10:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,276,1231142400"; 
   d="asc'?scan'208";a="482158597"
Subject: [PATCH crypto -v5 1/2] AES-NI: Add support to access underlying
	blkcipher under cryptd ablkcipher
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ksa8edocmFr4QH5UQUSG"
Date: Fri, 16 Jan 2009 15:10:20 +0800
Message-Id: <1232089820.13948.28.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ksa8edocmFr4QH5UQUSG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
specified algorithm name. The new allocated one is guaranteed to be
cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
cryptd_ablkcipher_child().


v5:

- Move declaration to crypto/cryptd.h

- Fix allocation error processing in cryptd_alloc_ablkcipher()

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c         |   33 +++++++++++++++++++++++++++++++++
 include/crypto/cryptd.h |   27 +++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -12,6 +12,7 @@
=20
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/cryptd.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -537,6 +538,38 @@ static struct crypto_template cryptd_tmp
 	.module =3D THIS_MODULE,
 };
=20
+struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_ablkcipher *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "cryptd(%s)", alg_name) >=3D CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D THIS_MODULE)
+		return ERR_PTR(-EINVAL);
+
+	return __cryptd_ablkcipher_cast(tfm);
+}
+EXPORT_SYMBOL_GPL(cryptd_alloc_ablkcipher);
+
+struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher =
*tfm)
+{
+	struct cryptd_blkcipher_ctx *ctx =3D crypto_ablkcipher_ctx(&tfm->base);
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(cryptd_ablkcipher_child);
+
+void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm)
+{
+	crypto_free_ablkcipher(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
+
 static inline int cryptd_create_thread(struct cryptd_state *state,
 				       int (*fn)(void *data), const char *name)
 {
--- /dev/null
+++ b/include/crypto/cryptd.h
@@ -0,0 +1,27 @@
+/*
+ * Software async crypto daemon
+ */
+
+#ifndef _CRYPTO_CRYPT_H
+#define _CRYPTO_CRYPT_H
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+
+struct cryptd_ablkcipher {
+	struct crypto_ablkcipher base;
+};
+
+static inline struct cryptd_ablkcipher *__cryptd_ablkcipher_cast(
+	struct crypto_ablkcipher *tfm)
+{
+	return (struct cryptd_ablkcipher *)tfm;
+}
+
+/* alg_name should be algorithm to be cryptd-ed */
+struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask);
+struct crypto_blkcipher *cryptd_ablkcipher_child(struct cryptd_ablkcipher =
*tfm);
+void cryptd_free_ablkcipher(struct cryptd_ablkcipher *tfm);
+
+#endif


--=-Ksa8edocmFr4QH5UQUSG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklwMtYACgkQKhFGF+eHlpg1XwCdF7MdkcJxRObx2hTl3uI/IwV1
TBcAn1z0ky0uJDZ4Wt20GMLwZUE30xbS
=VBeh
-----END PGP SIGNATURE-----

--=-Ksa8edocmFr4QH5UQUSG--

