Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbZCXQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbZCXQdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761930AbZCXQdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:33:24 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35707 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761502AbZCXQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:33:17 -0400
Date: Tue, 24 Mar 2009 17:33:01 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}() (was: Re: [PATCH/RFC] crypto: compress
 - Add comp_request.total_out (was: Re: [PATCH 6/6] squashfs: Make SquashFS
 4 use the new pcomp crypto interface))
In-Reply-To: <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au>
 <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Geert Uytterhoeven wrote:
> On Wed, 11 Mar 2009, Geert Uytterhoeven wrote:
> > On Sun, 8 Mar 2009, Phillip Lougher wrote:
> > > Two API issues of concern (one major, one minor).  Both of these relate to the
> > > way Squashfs drives the decompression code, where it repeatedly calls it
> > > supplying additional input/output buffers, rather than using a "single-shot"
> > > approach where it calls the decompression code once supplying all the
> > > necessary input and output buffer space.
> > > 
> > > 1. Minor issue -the lack of a stream.total_out field.  The current
> > > zlib_inflate code collects the total number of bytes decompressed over the
> > > multiple calls into the stream.total_out field.
> > > 
> > >    There is clearly no such field available in the cryto API, leading to the
> > > somewhat clumsy need to track it, i.e. it leads to the following additional
> > > code.
> > 
> > If people feel the need for a total_out field, I can add it to struct
> > comp_request.
> > 
> > BTW, what about total_in, which is also provided by plain zlib's z_stream?
> > Do people see a need for a similar field?
> 
> The patch below (on top of the updated one to convert SquashFS to pcomp) adds
> comp_request.total_out, so you don't have to calculate and accumulate the
> decompressed output sizes in SquashFS.
> 
> Notes:
>   - This required the addition of a `struct comp_request *' parameter to
>     crypto_{,de}compress_init()
>   - Still, there's one of the 
> 
> 	produced = req.avail_out;
> 	...
> 	produced -= req.avail_out;
> 
>     left, as this is part of the logic to discover the end of decompression
>     (no bytes produced, no error returned).
> 
> Perhaps it's better to instead make crypto_{,de}compress_{update,final}()
> return the (positive) number of output bytes (of the current step)?
> 
> Currently it returns zero (no error) or a negative error value.
> That would allow to get rid of both `produced = ... / produced -= ...'
> constructs, but the user would have to accumulate the total output size again
> (which is not such a big deal, IMHO).

Here's an alternative patch, which does exactly that.
Phillip, what do you think?

Thanks for your comments!

>From be7d630f96a85d3ce48716b8e328563ba217647b Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Tue, 24 Mar 2009 17:19:05 +0100
Subject: [PATCH] crypto: compress - Return produced bytes in crypto_{,de}compress_{update,final}()

If crypto_{,de}compress_{update,final}() succeed, return the actual number of
bytes produced instead of zero, so their users don't have to calculate that
theirselves.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c    |  117 ++++++++++++++++++++++++++++++--------------------
 crypto/zlib.c       |   24 +++++-----
 fs/squashfs/block.c |   33 ++++++---------
 3 files changed, 95 insertions(+), 79 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b50c3c6..9cee018 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -914,24 +914,25 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -941,32 +942,37 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -976,6 +982,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -986,21 +999,21 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
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
@@ -1010,35 +1023,38 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
@@ -1048,6 +1064,13 @@ static int test_pcomp(struct crypto_pcomp *tfm,
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
 
 
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 6196821..433f065 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -154,9 +154,8 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 	}
 
 	if (compressed) {
-		int error = 0, decomp_init = 0;
+		int res = 0, decomp_init = 0;
 		struct comp_request req;
-		unsigned int produced = 0;
 
 		/*
 		 * Uncompress block.
@@ -194,41 +193,35 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 			}
 
 			if (!decomp_init) {
-				error = crypto_decompress_init(msblk->tfm);
-				if (error) {
+				res = crypto_decompress_init(msblk->tfm);
+				if (res) {
 					ERROR("crypto_decompress_init "
 						"returned %d, srclength %d\n",
-						error, srclength);
+						res, srclength);
 					goto release_mutex;
 				}
 				decomp_init = 1;
 			}
 
-			produced = req.avail_out;
-			error = crypto_decompress_update(msblk->tfm, &req);
-			if (error) {
+			res = crypto_decompress_update(msblk->tfm, &req);
+			if (res < 0) {
 				ERROR("crypto_decompress_update returned %d, "
-					"data probably corrupt\n", error);
+					"data probably corrupt\n", res);
 				goto release_mutex;
 			}
-			produced -= req.avail_out;
-
-			length += produced;
+			length += res;
 
 			if (req.avail_in == 0 && k < b)
 				put_bh(bh[k++]);
-		} while (bytes || produced);
+		} while (bytes || res);
 
-		produced = req.avail_out;
-		error = crypto_decompress_final(msblk->tfm, &req);
-		if (error) {
+		res = crypto_decompress_final(msblk->tfm, &req);
+		if (res < 0) {
 			ERROR("crypto_decompress_final returned %d, data "
-				"probably corrupt\n", error);
+				"probably corrupt\n", res);
 			goto release_mutex;
 		}
-		produced -= req.avail_out;
-
-		length += produced;
+		length += res;
 
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
-- 
1.6.0.4


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
