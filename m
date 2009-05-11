Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZEKPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZEKPf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZEKPfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:35:11 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47099 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbZEKPfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:35:09 -0400
Date: Mon, 11 May 2009 17:35:08 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-crypto@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}()
In-Reply-To: <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
 <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be> <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If crypto_{,de}compress_{update,final}() succeed, return the actual number of
bytes produced instead of zero, so their users don't have to calculate that
theirselves.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
As we're already at 2.6.30-rc5, I do not want to delay any longer this API
change for a new module introduced for 2.6.30.

Herbert, please apply for 2.6.30.
Thanks!

 crypto/testmgr.c |  117 ++++++++++++++++++++++++++++++++----------------------
 crypto/zlib.c    |   24 ++++++------
 2 files changed, 82 insertions(+), 59 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bfee6e9..b55bccc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -916,24 +916,25 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	const char *algo = crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm));
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
-	int error;
+	int res;
 
 	for (i = 0; i < ctcount; i++) {
 		struct comp_request req;
+		unsigned int produced = 0;
 
-		error = crypto_compress_setup(tfm, ctemplate[i].params,
-					      ctemplate[i].paramsize);
-		if (error) {
+		res = crypto_compress_setup(tfm, ctemplate[i].params,
+					    ctemplate[i].paramsize);
+		if (res) {
 			pr_err("alg: pcomp: compression setup failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
 
-		error = crypto_compress_init(tfm);
-		if (error) {
+		res = crypto_compress_init(tfm);
+		if (res) {
 			pr_err("alg: pcomp: compression init failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
 
 		memset(result, 0, sizeof(result));
@@ -943,32 +944,37 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 		req.next_out = result;
 		req.avail_out = ctemplate[i].outlen / 2;
 
-		error = crypto_compress_update(tfm, &req);
-		if (error && (error != -EAGAIN || req.avail_in)) {
+		res = crypto_compress_update(tfm, &req);
+		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced += res;
 
 		/* Add remaining input data */
 		req.avail_in += (ctemplate[i].inlen + 1) / 2;
 
-		error = crypto_compress_update(tfm, &req);
-		if (error && (error != -EAGAIN || req.avail_in)) {
+		res = crypto_compress_update(tfm, &req);
+		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced += res;
 
 		/* Provide remaining output space */
 		req.avail_out += COMP_BUF_SIZE - ctemplate[i].outlen / 2;
 
-		error = crypto_compress_final(tfm, &req);
-		if (error) {
+		res = crypto_compress_final(tfm, &req);
+		if (res < 0) {
 			pr_err("alg: pcomp: compression final failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
+		produced += res;
 
 		if (COMP_BUF_SIZE - req.avail_out != ctemplate[i].outlen) {
 			pr_err("alg: comp: Compression test %d failed for %s: "
@@ -978,6 +984,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 			return -EINVAL;
 		}
 
+		if (produced != ctemplate[i].outlen) {
+			pr_err("alg: comp: Compression test %d failed for %s: "
+			       "returned len = %u (expected %d)\n", i + 1,
+			       algo, produced, ctemplate[i].outlen);
+			return -EINVAL;
+		}
+
 		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
 			pr_err("alg: pcomp: Compression test %d failed for "
 			       "%s\n", i + 1, algo);
@@ -988,21 +1001,21 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 	for (i = 0; i < dtcount; i++) {
 		struct comp_request req;
+		unsigned int produced = 0;
 
-		error = crypto_decompress_setup(tfm, dtemplate[i].params,
-						dtemplate[i].paramsize);
-		if (error) {
+		res = crypto_decompress_setup(tfm, dtemplate[i].params,
+					      dtemplate[i].paramsize);
+		if (res) {
 			pr_err("alg: pcomp: decompression setup failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
 
-		error = crypto_decompress_init(tfm);
-		if (error) {
+		res = crypto_decompress_init(tfm);
+		if (res) {
 			pr_err("alg: pcomp: decompression init failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, error);
-			return error;
+			       "%d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
 
 		memset(result, 0, sizeof(result));
@@ -1012,35 +1025,38 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 		req.next_out = result;
 		req.avail_out = dtemplate[i].outlen / 2;
 
-		error = crypto_decompress_update(tfm, &req);
-		if (error  && (error != -EAGAIN || req.avail_in)) {
+		res = crypto_decompress_update(tfm, &req);
+		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced += res;
 
 		/* Add remaining input data */
 		req.avail_in += (dtemplate[i].inlen + 1) / 2;
 
-		error = crypto_decompress_update(tfm, &req);
-		if (error  && (error != -EAGAIN || req.avail_in)) {
+		res = crypto_decompress_update(tfm, &req);
+		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced += res;
 
 		/* Provide remaining output space */
 		req.avail_out += COMP_BUF_SIZE - dtemplate[i].outlen / 2;
 
-		error = crypto_decompress_final(tfm, &req);
-		if (error  && (error != -EAGAIN || req.avail_in)) {
+		res = crypto_decompress_final(tfm, &req);
+		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
 			pr_err("alg: pcomp: decompression final failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo,
-			       error);
-			return error;
+			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			return res;
 		}
+		if (res > 0)
+			produced += res;
 
 		if (COMP_BUF_SIZE - req.avail_out != dtemplate[i].outlen) {
 			pr_err("alg: comp: Decompression test %d failed for "
@@ -1050,6 +1066,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 			return -EINVAL;
 		}
 
+		if (produced != dtemplate[i].outlen) {
+			pr_err("alg: comp: Decompression test %d failed for "
+			       "%s: returned len = %u (expected %d)\n", i + 1,
+			       algo, produced, dtemplate[i].outlen);
+			return -EINVAL;
+		}
+
 		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
 			pr_err("alg: pcomp: Decompression test %d failed for "
 			       "%s\n", i + 1, algo);
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 33609ba..c301573 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -165,15 +165,15 @@ static int zlib_compress_update(struct crypto_pcomp *tfm,
 		return -EINVAL;
 	}
 
+	ret = req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
-	return 0;
+	return ret;
 }
 
 static int zlib_compress_final(struct crypto_pcomp *tfm,
@@ -195,15 +195,15 @@ static int zlib_compress_final(struct crypto_pcomp *tfm,
 		return -EINVAL;
 	}
 
+	ret = req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
-	return 0;
+	return ret;
 }
 
 
@@ -280,15 +280,15 @@ static int zlib_decompress_update(struct crypto_pcomp *tfm,
 		return -EINVAL;
 	}
 
+	ret = req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
-	return 0;
+	return ret;
 }
 
 static int zlib_decompress_final(struct crypto_pcomp *tfm,
@@ -328,15 +328,15 @@ static int zlib_decompress_final(struct crypto_pcomp *tfm,
 		return -EINVAL;
 	}
 
+	ret = req->avail_out - stream->avail_out;
 	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
 		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in,
-		 req->avail_out - stream->avail_out);
+		 req->avail_in - stream->avail_in, ret);
 	req->next_in = stream->next_in;
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
-	return 0;
+	return ret;
 }
 
 
-- 
1.6.2.4


With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village � Da Vincilaan 7-D1 � B-1935 Zaventem � Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 � RPR Brussels
Fortis � BIC GEBABEBB � IBAN BE41293037680010
