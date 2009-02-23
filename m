Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZBWRci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZBWRci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZBWRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:32:26 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54335 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752011AbZBWRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:32:24 -0500
Date: Mon, 23 Feb 2009 18:32:19 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
In-Reply-To: <20090219104250.GA9633@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.00.0902231822080.22762@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au> <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au>
 <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be> <20090219104250.GA9633@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Herbert,

On Thu, 19 Feb 2009, Herbert Xu wrote:
> On Thu, Feb 19, 2009 at 10:12:18AM +0100, Geert Uytterhoeven wrote:
> > IIUC, my setup() routines should decode the parameters using nla_parse()?
> 
> Right.
> 
> > And the caller of a setup() routine should encode the data. But how? All the
> > nla_put*() routines seem to be targeted at skb's.
> 
> The callers in the kernel should just lay it out on the stack, e.g.,
> 
> 	struct {
> 		struct nlattr foo;
> 		u32 foo_val;
> 		struct nlattr bar;
> 		u32 bar_val;
> 		...
> 	};
> 
> Note that the netlink alignment is 4 so u32 doesn't need any padding
> though u8/u16 would need padding before the next nlattr.  Although
> for our purposes u32 should be sufficient.
> 
> > The only place where nla_parse() is called with a void */length pair is
> > net/sched/em_meta.c:em_meta_change(). But I can find no place where the actual
> > TCA_EM_META_* fields are encoded.
> 
> For simple things like u32 the format is just header followed by
> the u32.  See nla_get_u32 for details.

Is the below (on top of my last patch series) what you have in mind?

Notes:
  - I had to drop the `const' from the `params' pointers of
    pcomp_alg.{,de}compress_setup().
    Trying to make nla_parse() take const nlattr structures instead seems to
    open a big can of worms...
  - I should add a dependency of CONFIG_CRYPTO_ZLIB on CONFIG_NET (due to the
    need for nla_parse()). However, I don't like that.

Thanks for your comments!

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4703137..b50c3c6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -919,7 +919,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	for (i = 0; i < ctcount; i++) {
 		struct comp_request req;
 
-		error = crypto_compress_setup(tfm, ctemplate[i].params);
+		error = crypto_compress_setup(tfm, ctemplate[i].params,
+					      ctemplate[i].paramsize);
 		if (error) {
 			pr_err("alg: pcomp: compression setup failed on test "
 			       "%d for %s: error=%d\n", i + 1, algo, error);
@@ -986,7 +987,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	for (i = 0; i < dtcount; i++) {
 		struct comp_request req;
 
-		error = crypto_decompress_setup(tfm, dtemplate[i].params);
+		error = crypto_decompress_setup(tfm, dtemplate[i].params,
+						dtemplate[i].paramsize);
 		if (error) {
 			pr_err("alg: pcomp: decompression setup failed on "
 			       "test %d for %s: error=%d\n", i + 1, algo,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 098c033..526f00a 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,7 +15,9 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
+#include <linux/netlink.h>
 #include <linux/zlib.h>
+
 #include <crypto/compress.h>
 
 #define MAX_DIGEST_SIZE		64
@@ -8351,7 +8353,8 @@ struct comp_testvec {
 };
 
 struct pcomp_testvec {
-	const void *params;
+	void *params;
+	unsigned int paramsize;
 	int inlen, outlen;
 	char input[COMP_BUF_SIZE];
 	char output[COMP_BUF_SIZE];
@@ -8440,21 +8443,60 @@ static struct comp_testvec deflate_decomp_tv_template[] = {
 #define ZLIB_COMP_TEST_VECTORS 2
 #define ZLIB_DECOMP_TEST_VECTORS 2
 
-static const struct zlib_comp_params deflate_comp_params = {
-	.level			= Z_DEFAULT_COMPRESSION,
-	.method			= Z_DEFLATED,
-	.windowBits		= -11,
-	.memLevel		= MAX_MEM_LEVEL,
-	.strategy		= Z_DEFAULT_STRATEGY
+static const struct {
+	struct nlattr nla;
+	int val;
+} deflate_comp_params[] = {
+	{
+		.nla = {
+			.nla_len	= NLA_HDRLEN + sizeof(int),
+			.nla_type	= ZLIB_COMP_LEVEL,
+		},
+		.val			= Z_DEFAULT_COMPRESSION,
+	}, {
+		.nla = {
+			.nla_len	= NLA_HDRLEN + sizeof(int),
+			.nla_type	= ZLIB_COMP_METHOD,
+		},
+		.val			= Z_DEFLATED,
+	}, {
+		.nla = {
+			.nla_len	= NLA_HDRLEN + sizeof(int),
+			.nla_type	= ZLIB_COMP_WINDOWBITS,
+		},
+		.val			= -11,
+	}, {
+		.nla = {
+			.nla_len	= NLA_HDRLEN + sizeof(int),
+			.nla_type	= ZLIB_COMP_MEMLEVEL,
+		},
+		.val			= MAX_MEM_LEVEL,
+	}, {
+		.nla = {
+			.nla_len	= NLA_HDRLEN + sizeof(int),
+			.nla_type	= ZLIB_COMP_STRATEGY,
+		},
+		.val			= Z_DEFAULT_STRATEGY,
+	}
 };
 
-static const struct zlib_decomp_params deflate_decomp_params = {
-	.windowBits		= -11,
+static const struct {
+	struct nlattr nla;
+	int val;
+} deflate_decomp_params[] = {
+	{
+		.nla = {
+			.nla_len	= NLA_HDRLEN + sizeof(int),
+			.nla_type	= ZLIB_DECOMP_WINDOWBITS,
+		},
+		.val			= -11,
+	}
 };
 
 static struct pcomp_testvec zlib_comp_tv_template[] = {
 	{
 		.params = &deflate_comp_params,
+		.paramsize = sizeof(deflate_comp_params),
 		.inlen	= 70,
 		.outlen	= 38,
 		.input	= "Join us now and share the software "
@@ -8466,6 +8508,7 @@ static struct pcomp_testvec zlib_comp_tv_template[] = {
 			  "\x71\xbc\x08\x2b\x01\x00",
 	}, {
 		.params = &deflate_comp_params,
+		.paramsize = sizeof(deflate_comp_params),
 		.inlen	= 191,
 		.outlen	= 122,
 		.input	= "This document describes a compression method based on the DEFLATE"
@@ -8493,6 +8536,7 @@ static struct pcomp_testvec zlib_comp_tv_template[] = {
 static struct pcomp_testvec zlib_decomp_tv_template[] = {
 	{
 		.params = &deflate_decomp_params,
+		.paramsize = sizeof(deflate_decomp_params),
 		.inlen	= 122,
 		.outlen	= 191,
 		.input	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
@@ -8516,6 +8560,7 @@ static struct pcomp_testvec zlib_decomp_tv_template[] = {
 			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
 	}, {
 		.params = &deflate_decomp_params,
+		.paramsize = sizeof(deflate_decomp_params),
 		.inlen	= 38,
 		.outlen	= 70,
 		.input	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 77b865d..33609ba 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -33,11 +33,13 @@
 
 #include <crypto/internal/compress.h>
 
+#include <net/netlink.h>
+
 
 struct zlib_ctx {
-	struct zlib_decomp_params decomp_params;
 	struct z_stream_s comp_stream;
 	struct z_stream_s decomp_stream;
+	int decomp_windowBits;
 };
 
 
@@ -77,13 +79,18 @@ static void zlib_exit(struct crypto_tfm *tfm)
 }
 
 
-static int zlib_compress_setup(struct crypto_pcomp *tfm, const void *params)
+static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
+			       unsigned int len)
 {
 	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	const struct zlib_comp_params *zparams = params;
 	struct z_stream_s *stream = &ctx->comp_stream;
+	struct nlattr *tb[ZLIB_COMP_MAX + 1];
 	size_t workspacesize;
-	int ret = 0;
+	int ret;
+
+	ret = nla_parse(tb, ZLIB_COMP_MAX, params, len, NULL);
+	if (ret)
+		return ret;
 
 	zlib_comp_exit(ctx);
 
@@ -93,9 +100,22 @@ static int zlib_compress_setup(struct crypto_pcomp *tfm, const void *params)
 		return -ENOMEM;
 
 	memset(stream->workspace, 0, workspacesize);
-	ret = zlib_deflateInit2(stream, zparams->level, zparams->method,
-				zparams->windowBits, zparams->memLevel,
-				zparams->strategy);
+	ret = zlib_deflateInit2(stream,
+				tb[ZLIB_COMP_LEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_LEVEL])
+					: Z_DEFAULT_COMPRESSION,
+				tb[ZLIB_COMP_METHOD]
+					? nla_get_u32(tb[ZLIB_COMP_METHOD])
+					: Z_DEFLATED,
+				tb[ZLIB_COMP_WINDOWBITS]
+					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
+					: MAX_WBITS,
+				tb[ZLIB_COMP_MEMLEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
+					: DEF_MEM_LEVEL,
+				tb[ZLIB_COMP_STRATEGY]
+					? nla_get_u32(tb[ZLIB_COMP_STRATEGY])
+					: Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK) {
 		vfree(stream->workspace);
 		stream->workspace = NULL;
@@ -187,22 +207,29 @@ static int zlib_compress_final(struct crypto_pcomp *tfm,
 }
 
 
-static int zlib_decompress_setup(struct crypto_pcomp *tfm, const void *params)
+static int zlib_decompress_setup(struct crypto_pcomp *tfm, void *params,
+				 unsigned int len)
 {
 	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	const struct zlib_decomp_params *zparams = params;
 	struct z_stream_s *stream = &ctx->decomp_stream;
+	struct nlattr *tb[ZLIB_DECOMP_MAX + 1];
 	int ret = 0;
 
+	ret = nla_parse(tb, ZLIB_DECOMP_MAX, params, len, NULL);
+	if (ret)
+		return ret;
+
 	zlib_decomp_exit(ctx);
 
-	ctx->decomp_params = *zparams;
+	ctx->decomp_windowBits = tb[ZLIB_DECOMP_WINDOWBITS]
+				 ? nla_get_u32(tb[ZLIB_DECOMP_WINDOWBITS])
+				 : DEF_WBITS;
 
 	stream->workspace = kzalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
 	if (!stream->workspace)
 		return -ENOMEM;
 
-	ret = zlib_inflateInit2(stream, zparams->windowBits);
+	ret = zlib_inflateInit2(stream, ctx->decomp_windowBits);
 	if (ret != Z_OK) {
 		kfree(stream->workspace);
 		stream->workspace = NULL;
@@ -277,7 +304,7 @@ static int zlib_decompress_final(struct crypto_pcomp *tfm,
 	stream->next_out = req->next_out;
 	stream->avail_out = req->avail_out;
 
-	if (dctx->decomp_params.windowBits < 0) {
+	if (dctx->decomp_windowBits < 0) {
 		ret = zlib_inflate(stream, Z_SYNC_FLUSH);
 		/*
 		 * Work around a bug in zlib, which sometimes wants to taste an
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 12ed86d..62be5ae 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -39,6 +39,8 @@
 
 #include <crypto/compress.h>
 
+#include <net/netlink.h>
+
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
@@ -81,7 +83,16 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned short flags;
 	unsigned int fragments;
 	u64 lookup_table_start;
-	struct zlib_decomp_params params = { .windowBits = DEF_WBITS };
+	struct {
+		struct nlattr nla;
+		int val;
+	} params = {
+		.nla = {
+			.nla_len	= nla_attr_size(sizeof(int)),
+			.nla_type	= ZLIB_DECOMP_WINDOWBITS,
+		},
+		.val			= DEF_WBITS,
+	};
 	int err;
 
 	TRACE("Entered squashfs_fill_superblock\n");
@@ -102,7 +113,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_pcomp;
 	}
 
-	err = crypto_decompress_setup(msblk->tfm, &params);
+	err = crypto_decompress_setup(msblk->tfm, &params, sizeof(params));
 	if (err) {
 		ERROR("Failed to set up decompression parameters\n");
 		goto failure;
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 67ba57d..86163ef 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -30,30 +30,40 @@ struct comp_request {
 	unsigned int avail_out;		/* bytes available at next_out */
 };
 
-struct zlib_comp_params {
-	int level;			/* e.g. Z_DEFAULT_COMPRESSION */
-	int method;			/* e.g. Z_DEFLATED */
-	int windowBits;			/* e.g. MAX_WBITS */
-	int memLevel;			/* e.g. DEF_MEM_LEVEL */
-	int strategy;			/* e.g. Z_DEFAULT_STRATEGY */
+enum zlib_comp_params {
+	ZLIB_COMP_LEVEL = 1,		/* e.g. Z_DEFAULT_COMPRESSION */
+	ZLIB_COMP_METHOD,		/* e.g. Z_DEFLATED */
+	ZLIB_COMP_WINDOWBITS,		/* e.g. MAX_WBITS */
+	ZLIB_COMP_MEMLEVEL,		/* e.g. DEF_MEM_LEVEL */
+	ZLIB_COMP_STRATEGY,		/* e.g. Z_DEFAULT_STRATEGY */
+	__ZLIB_COMP_MAX,
 };
 
-struct zlib_decomp_params {
-	int windowBits;			/* e.g. DEF_WBITS */
+#define ZLIB_COMP_MAX	(__ZLIB_COMP_MAX - 1)
+
+
+enum zlib_decomp_params {
+	ZLIB_DECOMP_WINDOWBITS = 1,	/* e.g. DEF_WBITS */
+	__ZLIB_DECOMP_MAX,
 };
 
+#define ZLIB_DECOMP_MAX	(__ZLIB_DECOMP_MAX - 1)
+
+
 struct crypto_pcomp {
 	struct crypto_tfm base;
 };
 
 struct pcomp_alg {
-	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params);
+	int (*compress_setup)(struct crypto_pcomp *tfm, void *params,
+			      unsigned int len);
 	int (*compress_init)(struct crypto_pcomp *tfm);
 	int (*compress_update)(struct crypto_pcomp *tfm,
 			       struct comp_request *req);
 	int (*compress_final)(struct crypto_pcomp *tfm,
 			      struct comp_request *req);
-	int (*decompress_setup)(struct crypto_pcomp *tfm, const void *params);
+	int (*decompress_setup)(struct crypto_pcomp *tfm, void *params,
+				unsigned int len);
 	int (*decompress_init)(struct crypto_pcomp *tfm);
 	int (*decompress_update)(struct crypto_pcomp *tfm,
 				 struct comp_request *req);
@@ -87,9 +97,9 @@ static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
 }
 
 static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
-					const void *params)
+					void *params, unsigned int len)
 {
-	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params);
+	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
 }
 
 static inline int crypto_compress_init(struct crypto_pcomp *tfm)
@@ -110,9 +120,9 @@ static inline int crypto_compress_final(struct crypto_pcomp *tfm,
 }
 
 static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
-					  const void *params)
+					  void *params, unsigned int len)
 {
-	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params);
+	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
 }
 
 static inline int crypto_decompress_init(struct crypto_pcomp *tfm)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village � Da Vincilaan 7-D1 � B-1935 Zaventem � Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 � RPR Brussels
Fortis � BIC GEBABEBB � IBAN BE41293037680010
