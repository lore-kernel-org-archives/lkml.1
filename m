Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZBBGmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZBBGmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZBBGmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:42:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:23415 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZBBGmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:42:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,363,1231142400"; 
   d="asc'?scan'208";a="383119535"
Subject: [PATCH 1/3] crypto: Use dedicated workqueue for crypto subsystem
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uR8Gy2LaaMJl8A2zH1FI"
Date: Mon, 02 Feb 2009 14:42:14 +0800
Message-Id: <1233556934.19806.57.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uR8Gy2LaaMJl8A2zH1FI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

A dedicated workqueue named kcrypto_wq is created to be used by crypto
subsystem. The system shared keventd_wq is not suitable for
encryption/decryption, because of potential starvation problem.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig             |    3 +++
 crypto/Makefile            |    2 ++
 crypto/crypto_wq.c         |   38 ++++++++++++++++++++++++++++++++++++++
 include/crypto/crypto_wq.h |    7 +++++++
 4 files changed, 50 insertions(+)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -106,6 +106,9 @@ config CRYPTO_NULL
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
=20
+config CRYPTO_WORKQUEUE
+       tristate
+
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
 	select CRYPTO_BLKCIPHER
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -5,6 +5,8 @@
 obj-$(CONFIG_CRYPTO) +=3D crypto.o
 crypto-objs :=3D api.o cipher.o digest.o compress.o
=20
+obj-$(CONFIG_CRYPTO_WORKQUEUE) +=3D crypto_wq.o
+
 obj-$(CONFIG_CRYPTO_FIPS) +=3D fips.o
=20
 crypto_algapi-$(CONFIG_PROC_FS) +=3D proc.o
--- /dev/null
+++ b/crypto/crypto_wq.c
@@ -0,0 +1,38 @@
+/*
+ * Workqueue for crypto subsystem
+ *
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation; either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ */
+
+#include <linux/workqueue.h>
+#include <crypto/algapi.h>
+#include <crypto/crypto_wq.h>
+
+struct workqueue_struct *kcrypto_wq;
+EXPORT_SYMBOL_GPL(kcrypto_wq);
+
+static int __init crypto_wq_init(void)
+{
+	kcrypto_wq =3D create_workqueue("crypto");
+	if (unlikely(!kcrypto_wq))
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit crypto_wq_exit(void)
+{
+	destroy_workqueue(kcrypto_wq);
+}
+
+module_init(crypto_wq_init);
+module_exit(crypto_wq_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Workqueue for crypto subsystem");
--- /dev/null
+++ b/include/crypto/crypto_wq.h
@@ -0,0 +1,7 @@
+#ifndef CRYPTO_WQ_H
+#define CRYPTO_WQ_H
+
+#include <linux/workqueue.h>
+
+extern struct workqueue_struct *kcrypto_wq;
+#endif


--=-uR8Gy2LaaMJl8A2zH1FI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmGlcMACgkQKhFGF+eHlpjB9gCfftD0tTc/a+2cjk+Z+x+urD0H
PFcAnRBQCY8+RLK4chPEoxqMLjP6ZEpH
=52cR
-----END PGP SIGNATURE-----

--=-uR8Gy2LaaMJl8A2zH1FI--

