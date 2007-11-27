Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXK0KY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXK0KY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXK0KYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:24:21 -0500
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:64371 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXK0KYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:24:19 -0500
X-Greylist: delayed 2373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 05:24:19 EST
Message-ID: <474BE6E7.3080107@inf.u-szeged.hu>
Date: Tue, 27 Nov 2007 10:44:07 +0100
From: Zoltan Sogor <weth@inf.u-szeged.hu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: herbert@gondor.apana.org.au
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, Ferenc Havasi <havasi@inf.u-szeged.hu>,
       ext-adrian.hunter@nokia.com
Subject: Add LZO compression support to cryptoapi
Content-Type: multipart/mixed;
 boundary="------------070700060604020604090101"
X-SZTE-local: YES
X-SZTE-HU-local: YES
X-SZTE-AVcheck: YES
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070700060604020604090101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Herbert!

I'm Zoltan Sogor at University of Szeged, Hungary, and we are working on 
new flash file system (UBIFS) cooperating with Nokia Corp. We would like 
to use cryptoapi in UBIFS compression/encrypt mechanism.

I've ported LZO compressor into cryptoapi. If you think the patch is 
good, please apply it.

If you have any problem with the patch, your feedbacks are welcome.

Thanks,
   Zoltan

--------------070700060604020604090101
Content-Type: text/plain;
 name="0001-Cryptoapi-add-LZO-compression-algorithm-support.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Cryptoapi-add-LZO-compression-algorithm-support.txt"

>From 57c2ed2d2bf37607ce5e9abcc878b6b4f35d7cd0 Mon Sep 17 00:00:00 2001
From: Zoltan Sogor <weth@inf.u-szeged.hu>
Date: Tue, 27 Nov 2007 10:11:50 +0100
Subject: [PATCH] Cryptoapi: add LZO compression algorithm support

Add LZO compression algorithm support

Signed-off-by: Zoltan Sogor <weth@inf.u-szeged.hu>
---
 crypto/Kconfig  |    8 ++++
 crypto/Makefile |    1 +
 crypto/lzo.c    |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 083d2e1..d23ea63 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -502,6 +502,14 @@ config CRYPTO_AUTHENC
 	  Authenc: Combined mode wrapper for IPsec.
 	  This is required for IPSec.
 
+config CRYPTO_LZO
+	tristate "LZO compression algorithm"
+	select CRYPTO_ALGAPI
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+	help
+	  This is the LZO algorithm.
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index 43c2a0d..355cf92 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o
+obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 
diff --git a/crypto/lzo.c b/crypto/lzo.c
new file mode 100644
index 0000000..48c3288
--- /dev/null
+++ b/crypto/lzo.c
@@ -0,0 +1,106 @@
+/*
+ * Cryptographic API.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/vmalloc.h>
+#include <linux/lzo.h>
+
+struct lzo_ctx {
+	void *lzo_comp_mem;
+};
+
+static int lzo_init(struct crypto_tfm *tfm)
+{
+	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->lzo_comp_mem = vmalloc(LZO1X_MEM_COMPRESS);
+	if (!ctx->lzo_comp_mem)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void lzo_exit(struct crypto_tfm *tfm)
+{
+	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	vfree(ctx->lzo_comp_mem);
+}
+
+static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
+			    unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
+	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
+	int err;
+
+	err = lzo1x_1_compress(src, slen, dst, &tmp_len, ctx->lzo_comp_mem);
+
+	if (err != LZO_E_OK)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+}
+
+static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
+
+	err = lzo1x_decompress_safe(src, slen, dst, &tmp_len);
+
+	if (err != LZO_E_OK)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+
+}
+
+static struct crypto_alg alg = {
+	.cra_name		= "lzo",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct lzo_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(alg.cra_list),
+	.cra_init		= lzo_init,
+	.cra_exit		= lzo_exit,
+	.cra_u			= { .compress = {
+	.coa_compress 		= lzo_compress,
+	.coa_decompress  	= lzo_decompress } }
+};
+
+static int __init init(void)
+{
+	return crypto_register_alg(&alg);
+}
+
+static void __exit fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO Compression Algorithm");
-- 
1.4.4.4


--------------070700060604020604090101--
