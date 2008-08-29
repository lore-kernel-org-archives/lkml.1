Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYH2NpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYH2NpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYH2Nos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:44:48 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33840 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756725AbYH2Noo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:44:44 -0400
Message-Id: <20080829134418.874948211@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Fri, 29 Aug 2008 15:41:59 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 1/3] crypto: Add a zlib crypto module
Content-Disposition: inline; filename=crypto/add-zlib-crypto-module.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a (de)compression module for the "zlib" format using the crypto API.

While both the "zlib" and "deflate" crypto modules are implemented on top of
the zlib library, they differ in the following aspects:
  - The "deflate" crypto module (used by IPSec and UBIFS) does not support
    partial decompression, i.e. all compressed data has to be passed at once.
    The "zlib" crypto module does support partial decompression;
    zlib_decompress() will return -EAGAIN if not all compressed data has been
    passed.
  - The deflate crypto module uses the raw deflate data format (zlib is
    initialized with a windowBits parameter of -DEFLATE_DEF_WINBITS = -11),
    while e.g. squashfs and axfs use the zlib data format, with the default
    windowBits parameter DEF_WBITS = 15.
    Both parameters are incompatible with each other due to the different data
    formats, as indicated by the sign of the windowbits parameter.
    The absolute value of this parameter is the base two logarithm of the
    maximum window size, and larger values are backwards compatible with
    smaller values (as far as decompression is concerned).

TODO:
  - As the crypto wrapper around the zlib library supports both compression and
    decompression (and always allocates temporary space for both during
    initialization; lazy allocation was removed in 2004 because IPComp calls
    the crypto routines in non-process context), more memory is needed:
      * decompression (inflate) needs only ca. 41 KiB
      * compression (deflate) needs ca. 262 KiB! 
    It would be nice to allow having support for decompression only.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/Kconfig  |    8 ++
 crypto/Makefile |    1 
 crypto/zlib.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 225 insertions(+)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -666,6 +666,14 @@ config CRYPTO_LZO
 	help
 	  This is the LZO algorithm.
 
+config CRYPTO_ZLIB
+	tristate "Zlib compression algorithm"
+	select CRYPTO_ALGAPI
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	help
+	  This is the Zlib algorithm.
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += mich
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
+obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 
--- /dev/null
+++ b/crypto/zlib.c
@@ -0,0 +1,216 @@
+/*
+ * Cryptographic API.
+ *
+ * "zlib" crypto module, based on the "deflate" crypto module
+ *
+ * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
+ * Copyright 2008 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * FIXME: deflate transforms will require up to a total of about 436k of kernel
+ * memory on i386 (390k for compression, the rest for decompression), as the
+ * current zlib kernel code uses a worst case pre-allocation system by default.
+ * This needs to be fixed so that the amount of memory required is properly
+ * related to the  winbits and memlevel parameters.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/zlib.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/net.h>
+#include <linux/slab.h>
+
+#define ZLIB_DEF_LEVEL		Z_DEFAULT_COMPRESSION
+
+struct zlib_ctx {
+	struct z_stream_s comp_stream;
+	struct z_stream_s decomp_stream;
+	bool decomp_needs_reset;
+};
+
+static int zlib_comp_init(struct zlib_ctx *ctx)
+{
+	int ret = 0;
+	struct z_stream_s *stream = &ctx->comp_stream;
+
+	stream->workspace = vmalloc(zlib_deflate_workspacesize());
+	if (!stream->workspace ) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memset(stream->workspace, 0, zlib_deflate_workspacesize());
+	ret = zlib_deflateInit(stream, ZLIB_DEF_LEVEL);
+	if (ret != Z_OK) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+out:
+	return ret;
+out_free:
+	vfree(stream->workspace);
+	goto out;
+}
+
+static int zlib_decomp_init(struct zlib_ctx *ctx)
+{
+	int ret = 0;
+	struct z_stream_s *stream = &ctx->decomp_stream;
+
+	stream->workspace = kzalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
+	if (!stream->workspace ) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = zlib_inflateInit(stream);
+	if (ret != Z_OK) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+	ctx->decomp_needs_reset = true;
+out:
+	return ret;
+out_free:
+	kfree(stream->workspace);
+	goto out;
+}
+
+static void zlib_comp_exit(struct zlib_ctx *ctx)
+{
+	zlib_deflateEnd(&ctx->comp_stream);
+	vfree(ctx->comp_stream.workspace);
+}
+
+static void zlib_decomp_exit(struct zlib_ctx *ctx)
+{
+	zlib_inflateEnd(&ctx->decomp_stream);
+	kfree(ctx->decomp_stream.workspace);
+}
+
+static int zlib_init(struct crypto_tfm *tfm)
+{
+	struct zlib_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = zlib_comp_init(ctx);
+	if (ret)
+		goto out;
+	ret = zlib_decomp_init(ctx);
+	if (ret)
+		zlib_comp_exit(ctx);
+out:
+	return ret;
+}
+
+static void zlib_exit(struct crypto_tfm *tfm)
+{
+	struct zlib_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	zlib_comp_exit(ctx);
+	zlib_decomp_exit(ctx);
+}
+
+static int zlib_compress(struct crypto_tfm *tfm, const u8 *src,
+			 unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int ret = 0;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	ret = zlib_deflateReset(stream);
+	if (ret != Z_OK) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	stream->next_in = (u8 *)src;
+	stream->avail_in = slen;
+	stream->next_out = (u8 *)dst;
+	stream->avail_out = *dlen;
+
+	ret = zlib_deflate(stream, Z_FINISH);
+	if (ret != Z_STREAM_END) {
+		ret = -EINVAL;
+		goto out;
+	}
+	ret = 0;
+	*dlen = stream->total_out;
+out:
+	return ret;
+}
+
+static int zlib_decompress(struct crypto_tfm *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int ret = 0;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->decomp_stream;
+	unsigned long old_total_out;
+
+	if (dctx->decomp_needs_reset) {
+		ret = zlib_inflateReset(stream);
+		if (ret != Z_OK)
+			return -EINVAL;
+		dctx->decomp_needs_reset = false;
+	}
+
+	stream->next_in = (u8 *)src;
+	stream->avail_in = slen;
+	stream->next_out = (u8 *)dst;
+	stream->avail_out = *dlen;
+	old_total_out = stream->total_out;
+
+	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
+	switch (ret) {
+	case Z_STREAM_END:
+		dctx->decomp_needs_reset = true;
+		ret = 0;
+		break;
+
+	case Z_OK:
+		ret = -EAGAIN;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	*dlen = stream->total_out - old_total_out;
+	return ret;
+}
+
+static struct crypto_alg alg = {
+	.cra_name	= "zlib",
+	.cra_flags	= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize	= sizeof(struct zlib_ctx),
+	.cra_module	= THIS_MODULE,
+	.cra_list	= LIST_HEAD_INIT(alg.cra_list),
+	.cra_init	= zlib_init,
+	.cra_exit	= zlib_exit,
+	.cra_u		= { .compress = {
+	.coa_compress	= zlib_compress,
+	.coa_decompress	= zlib_decompress } }
+};
+
+static int __init zlib_mod_init(void)
+{
+	return crypto_register_alg(&alg);
+}
+
+static void __exit zlib_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(zlib_mod_init);
+module_exit(zlib_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Zlib Compression Algorithm");
+

-- 
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

