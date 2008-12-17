Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758884AbYLQQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbYLQQpZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYLQQmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:42:18 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65210 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751964AbYLQQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Message-Id: <20081217164036.784802597@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 17 Dec 2008 17:36:41 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
        James Morris <jmorris@intercode.com.au>
Subject: [PATCH/RFC 6/8] crypto: deflate - switch to pcomp
Content-Disposition: inline; filename=crypto-convert-deflate-to-pcomp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Change the "deflate" crypto module from the "comp" to the "pcomp" interface.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Morris <jmorris@intercode.com.au>
---
 crypto/deflate.c       |  342 ++++++++++++++++++++++++++++++++++++-------------
 include/linux/crypto.h |   12 +
 2 files changed, 266 insertions(+), 88 deletions(-)

--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -1,14 +1,15 @@
-/* 
+/*
  * Cryptographic API.
  *
- * Deflate algorithm (RFC 1951), implemented here primarily for use
- * by IPCOMP (RFC 3173 & RFC 2394).
+ * Deflate algorithm (RFC 1951), implemented here for use
+ * by e.g. IPCOMP (RFC 3173 & RFC 2394).
  *
  * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- * 
+ * Copyright 2008 Sony Corporation
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  * FIXME: deflate transforms will require up to a total of about 436k of kernel
@@ -16,14 +17,10 @@
  * current zlib kernel code uses a worst case pre-allocation system by default.
  * This needs to be fixed so that the amount of memory required is properly
  * related to the  winbits and memlevel parameters.
- *
- * The default winbits of 11 should suit most packets, and it may be something
- * to configure on a per-tfm basis in the future.
- *
- * Currently, compression history is not maintained between tfm calls, as
- * it is not needed for IPCOMP and keeps the code simpler.  It can be
- * implemented if someone wants it.
  */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
@@ -39,6 +36,7 @@
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
 
 struct deflate_ctx {
+	struct deflate_comp_params params;
 	struct z_stream_s comp_stream;
 	struct z_stream_s decomp_stream;
 };
@@ -47,24 +45,27 @@ static int deflate_comp_init(struct defl
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
+	size_t workspacesize;
 
-	stream->workspace = vmalloc(zlib_deflate_workspacesize());
-	if (!stream->workspace ) {
+	workspacesize = zlib_deflate_workspacesize();
+	stream->workspace = vmalloc(workspacesize);
+	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memset(stream->workspace, 0, zlib_deflate_workspacesize());
-	ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
-	                        -DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
-	                        Z_DEFAULT_STRATEGY);
+	memset(stream->workspace, 0, workspacesize);
+	ret = zlib_deflateInit2(stream, ctx->params.level, ctx->params.method,
+				ctx->params.windowBits, ctx->params.memLevel,
+				ctx->params.strategy);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
 	}
-out:	
+out:
 	return ret;
 out_free:
 	vfree(stream->workspace);
+	stream->workspace = NULL;
 	goto out;
 }
 
@@ -74,11 +75,11 @@ static int deflate_decomp_init(struct de
 	struct z_stream_s *stream = &ctx->decomp_stream;
 
 	stream->workspace = kzalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
-	if (!stream->workspace ) {
+	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
+	ret = zlib_inflateInit2(stream, ctx->params.windowBits);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
@@ -87,34 +88,35 @@ out:
 	return ret;
 out_free:
 	kfree(stream->workspace);
+	stream->workspace = NULL;
 	goto out;
 }
 
 static void deflate_comp_exit(struct deflate_ctx *ctx)
 {
-	zlib_deflateEnd(&ctx->comp_stream);
-	vfree(ctx->comp_stream.workspace);
+	struct z_stream_s *stream = &ctx->comp_stream;
+
+	if (stream->workspace) {
+		zlib_deflateEnd(stream);
+		vfree(stream->workspace);
+		stream->workspace = NULL;
+	}
 }
 
 static void deflate_decomp_exit(struct deflate_ctx *ctx)
 {
-	zlib_inflateEnd(&ctx->decomp_stream);
-	kfree(ctx->decomp_stream.workspace);
+	struct z_stream_s *stream = &ctx->decomp_stream;
+
+	if (stream->workspace) {
+		zlib_inflateEnd(stream);
+		kfree(stream->workspace);
+		stream->workspace = NULL;
+	}
 }
 
 static int deflate_init(struct crypto_tfm *tfm)
 {
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
-	int ret;
-	
-	ret = deflate_comp_init(ctx);
-	if (ret)
-		goto out;
-	ret = deflate_decomp_init(ctx);
-	if (ret)
-		deflate_comp_exit(ctx);
-out:
-	return ret;
+	return 0;
 }
 
 static void deflate_exit(struct crypto_tfm *tfm)
@@ -125,87 +127,251 @@ static void deflate_exit(struct crypto_t
 	deflate_decomp_exit(ctx);
 }
 
-static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static int deflate_setup(struct crypto_tfm *tfm, const void *params)
 {
-	int ret = 0;
+	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct deflate_comp_params *zparams = params;
+	int ret;
+
+	deflate_comp_exit(ctx);
+	deflate_decomp_exit(ctx);
+
+	ctx->params = *zparams;
+
+	if (zparams->enable_comp) {
+		ret = deflate_comp_init(ctx);
+		if (ret)
+			return ret;
+	}
+
+	if (zparams->enable_decomp) {
+		ret = deflate_decomp_init(ctx);
+		if (ret) {
+			deflate_comp_exit(ctx);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+
+static int deflate_compress_update(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	int ret;
 	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream = &dctx->comp_stream;
 
-	ret = zlib_deflateReset(stream);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out;
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	ret = zlib_deflate(stream, Z_NO_FLUSH);
+	switch (ret) {
+	case Z_OK:
+		break;
+
+	case Z_BUF_ERROR:
+		pr_debug("zlib_deflate could not make progress\n");
+		return -EAGAIN;
+
+	default:
+		pr_debug("zlib_deflate failed %d\n", ret);
+		return -EINVAL;
 	}
 
-	stream->next_in = (u8 *)src;
-	stream->avail_in = slen;
-	stream->next_out = (u8 *)dst;
-	stream->avail_out = *dlen;
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
+}
+
+static int deflate_compress_init(struct crypto_tfm *tfm,
+				 struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	ret = zlib_deflateReset(stream);
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	return deflate_compress_update(tfm, req);
+}
+
+static int deflate_compress_final(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
 
 	ret = zlib_deflate(stream, Z_FINISH);
 	if (ret != Z_STREAM_END) {
-		ret = -EINVAL;
-		goto out;
+		pr_debug("zlib_deflate failed %d\n", ret);
+		return -EINVAL;
 	}
-	ret = 0;
-	*dlen = stream->total_out;
-out:
-	return ret;
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
 }
- 
-static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+
+static int deflate_decompress_update(struct crypto_tfm *tfm,
+				     struct comp_request *req)
 {
-	
-	int ret = 0;
+	int ret;
 	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream = &dctx->decomp_stream;
 
-	ret = zlib_inflateReset(stream);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out;
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
+	switch (ret) {
+	case Z_OK:
+	case Z_STREAM_END:
+		break;
+
+	case Z_BUF_ERROR:
+		pr_debug("zlib_inflate could not make progress\n");
+		return -EAGAIN;
+
+	default:
+		pr_debug("zlib_inflate failed %d\n", ret);
+		return -EINVAL;
 	}
 
-	stream->next_in = (u8 *)src;
-	stream->avail_in = slen;
-	stream->next_out = (u8 *)dst;
-	stream->avail_out = *dlen;
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
+}
 
-	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-	/*
-	 * Work around a bug in zlib, which sometimes wants to taste an extra
-	 * byte when being used in the (undocumented) raw deflate mode.
-	 * (From USAGI).
-	 */
-	if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
-		u8 zerostuff = 0;
-		stream->next_in = &zerostuff;
-		stream->avail_in = 1; 
+static int deflate_decompress_init(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	ret = zlib_inflateReset(stream);
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	return deflate_decompress_update(tfm, req);
+}
+
+static int deflate_decompress_final(struct crypto_tfm *tfm,
+				    struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	if (dctx->params.windowBits < 0) {
+		ret = zlib_inflate(stream, Z_SYNC_FLUSH);
+		/*
+		 * Work around a bug in zlib, which sometimes wants to taste an
+		 * extra byte when being used in the (undocumented) raw deflate
+		 * mode. (From USAGI).
+		 */
+		if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
+			const void *saved_next_in = stream->next_in;
+			u8 zerostuff = 0;
+
+			stream->next_in = &zerostuff;
+			stream->avail_in = 1;
+			ret = zlib_inflate(stream, Z_FINISH);
+			stream->next_in = saved_next_in;
+			stream->avail_in = 0;
+		}
+	} else
 		ret = zlib_inflate(stream, Z_FINISH);
-	}
 	if (ret != Z_STREAM_END) {
-		ret = -EINVAL;
-		goto out;
+		pr_debug("zlib_inflate failed %d\n", ret);
+		return -EINVAL;
 	}
-	ret = 0;
-	*dlen = stream->total_out;
-out:
-	return ret;
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
 }
 
+
+static const struct deflate_comp_params deflate_default_params = {
+	.enable_comp		= 1,
+	.enable_decomp		= 1,
+	.windowBits		= -DEFLATE_DEF_WINBITS,
+	.level			= DEFLATE_DEF_LEVEL,
+	.method			= Z_DEFLATED,
+	.memLevel		= DEFLATE_DEF_MEMLEVEL,
+	.strategy		= Z_DEFAULT_STRATEGY
+};
+
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_flags		= CRYPTO_ALG_TYPE_PCOMPRESS,
 	.cra_ctxsize		= sizeof(struct deflate_ctx),
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(alg.cra_list),
 	.cra_init		= deflate_init,
 	.cra_exit		= deflate_exit,
-	.cra_u			= { .compress = {
-	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
+	.cra_u			= {
+		.pcompress = {
+			.coa_setup		= deflate_setup,
+			.coa_compress_init	= deflate_compress_init,
+			.coa_compress_update	= deflate_compress_update,
+			.coa_compress_final	= deflate_compress_final,
+			.coa_decompress_init	= deflate_decompress_init,
+			.coa_decompress_update	= deflate_decompress_update,
+			.coa_decompress_final	= deflate_decompress_final,
+			.coa_default_params	= &deflate_default_params
+		}
+	}
 };
 
 static int __init deflate_mod_init(void)
@@ -222,6 +388,6 @@ module_init(deflate_mod_init);
 module_exit(deflate_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
+MODULE_DESCRIPTION("Deflate Compression Algorithm");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
 
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -311,6 +311,18 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
 
+struct deflate_comp_params {
+	unsigned int enable_comp:1;
+	unsigned int enable_decomp:1;
+	/* common (de)compression (deflate and inflate) parameters */
+	int windowBits;		/* e.g. MAX_WBITS or DEF_WBITS */
+	/* compression only (deflate) parameters */
+	int level;		/* e.g. Z_DEFAULT_COMPRESSION */
+	int method;		/* e.g. Z_DEFLATED */
+	int memLevel;		/* e.g. DEF_MEM_LEVEL */
+	int strategy		/* e.g. Z_DEFAULT_STRATEGY */;
+};
+
 struct pcompress_alg {
 	int (*coa_setup)(struct crypto_tfm *tfm, const void *params);
 	int (*coa_compress_init)(struct crypto_tfm *tfm,

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

