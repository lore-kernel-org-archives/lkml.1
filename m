Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZCQMyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZCQMyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZCQMyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:54:07 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40301 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754914AbZCQMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:54:05 -0400
Date: Tue, 17 Mar 2009 13:54:01 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] crypto: compress - Add comp_request.total_out (was: Re:
 [PATCH 6/6] squashfs: Make SquashFS 4 use the new pcomp crypto interface)
In-Reply-To: <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be>
Message-ID: <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au>
 <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Geert Uytterhoeven wrote:
> On Sun, 8 Mar 2009, Phillip Lougher wrote:
> > Two API issues of concern (one major, one minor).  Both of these relate to the
> > way Squashfs drives the decompression code, where it repeatedly calls it
> > supplying additional input/output buffers, rather than using a "single-shot"
> > approach where it calls the decompression code once supplying all the
> > necessary input and output buffer space.
> > 
> > 1. Minor issue -the lack of a stream.total_out field.  The current
> > zlib_inflate code collects the total number of bytes decompressed over the
> > multiple calls into the stream.total_out field.
> > 
> >    There is clearly no such field available in the cryto API, leading to the
> > somewhat clumsy need to track it, i.e. it leads to the following additional
> > code.
> 
> If people feel the need for a total_out field, I can add it to struct
> comp_request.
> 
> BTW, what about total_in, which is also provided by plain zlib's z_stream?
> Do people see a need for a similar field?

The patch below (on top of the updated one to convert SquashFS to pcomp) adds
comp_request.total_out, so you don't have to calculate and accumulate the
decompressed output sizes in SquashFS.

Notes:
  - This required the addition of a `struct comp_request *' parameter to
    crypto_{,de}compress_init()
  - Still, there's one of the 

	produced = req.avail_out;
	...
	produced -= req.avail_out;

    left, as this is part of the logic to discover the end of decompression
    (no bytes produced, no error returned).

Perhaps it's better to instead make crypto_{,de}compress_{update,final}()
return the (positive) number of output bytes (of the current step)?

Currently it returns zero (no error) or a negative error value.
That would allow to get rid of both `produced = ... / produced -= ...'
constructs, but the user would have to accumulate the total output size again
(which is not such a big deal, IMHO).

Thanks for your comments!

>From e43f85baa75668be4cce340ae98a3b76e66a452a Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Mon, 16 Mar 2009 15:53:30 +0100
Subject: [PATCH] crypto: compress - Add comp_request.total_out

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c          |    4 ++--
 crypto/zlib.c             |   12 ++++++++++--
 fs/squashfs/block.c       |   10 +++-------
 include/crypto/compress.h |   17 +++++++++++------
 4 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b50c3c6..2b112ae 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -927,7 +927,7 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 			return error;
 		}
 
-		error = crypto_compress_init(tfm);
+		error = crypto_compress_init(tfm, &req);
 		if (error) {
 			pr_err("alg: pcomp: compression init failed on test "
 			       "%d for %s: error=%d\n", i + 1, algo, error);
@@ -996,7 +996,7 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 			return error;
 		}
 
-		error = crypto_decompress_init(tfm);
+		error = crypto_decompress_init(tfm, &req);
 		if (error) {
 			pr_err("alg: pcomp: decompression init failed on test "
 			       "%d for %s: error=%d\n", i + 1, algo, error);
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 33609ba..93ec380 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -125,7 +125,8 @@ static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
 	return 0;
 }
 
-static int zlib_compress_init(struct crypto_pcomp *tfm)
+static int zlib_compress_init(struct crypto_pcomp *tfm,
+			      struct comp_request *req)
 {
 	int ret;
 	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
@@ -135,6 +136,7 @@ static int zlib_compress_init(struct crypto_pcomp *tfm)
 	if (ret != Z_OK)
 		return -EINVAL;
 
+	req->total_out = 0;
 	return 0;
 }
 
@@ -173,6 +175,7 @@ static int zlib_compress_update(struct crypto_pcomp *tfm,
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
+	req->total_out = stream->total_out;
 	return 0;
 }
 
@@ -203,6 +206,7 @@ static int zlib_compress_final(struct crypto_pcomp *tfm,
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
+	req->total_out = stream->total_out;
 	return 0;
 }
 
@@ -239,7 +243,8 @@ static int zlib_decompress_setup(struct crypto_pcomp *tfm, void *params,
 	return 0;
 }
 
-static int zlib_decompress_init(struct crypto_pcomp *tfm)
+static int zlib_decompress_init(struct crypto_pcomp *tfm,
+				struct comp_request *req)
 {
 	int ret;
 	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
@@ -249,6 +254,7 @@ static int zlib_decompress_init(struct crypto_pcomp *tfm)
 	if (ret != Z_OK)
 		return -EINVAL;
 
+	req->total_out = 0;
 	return 0;
 }
 
@@ -288,6 +294,7 @@ static int zlib_decompress_update(struct crypto_pcomp *tfm,
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
+	req->total_out = stream->total_out;
 	return 0;
 }
 
@@ -336,6 +343,7 @@ static int zlib_decompress_final(struct crypto_pcomp *tfm,
 	req->avail_in = stream->avail_in;
 	req->next_out = stream->next_out;
 	req->avail_out = stream->avail_out;
+	req->total_out = stream->total_out;
 	return 0;
 }
 
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 6196821..11e19b6 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -168,7 +168,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 		req.avail_in = 0;
 
 		bytes = length;
-		length = 0;
 		do {
 			if (req.avail_in == 0 && k < b) {
 				avail = min(bytes, msblk->devblksize - offset);
@@ -194,7 +193,8 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 			}
 
 			if (!decomp_init) {
-				error = crypto_decompress_init(msblk->tfm);
+				error = crypto_decompress_init(msblk->tfm,
+							       &req);
 				if (error) {
 					ERROR("crypto_decompress_init "
 						"returned %d, srclength %d\n",
@@ -213,22 +213,18 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 			}
 			produced -= req.avail_out;
 
-			length += produced;
-
 			if (req.avail_in == 0 && k < b)
 				put_bh(bh[k++]);
 		} while (bytes || produced);
 
-		produced = req.avail_out;
 		error = crypto_decompress_final(msblk->tfm, &req);
 		if (error) {
 			ERROR("crypto_decompress_final returned %d, data "
 				"probably corrupt\n", error);
 			goto release_mutex;
 		}
-		produced -= req.avail_out;
 
-		length += produced;
+		length = req.total_out;
 
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 86163ef..d872c06 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -28,6 +28,7 @@ struct comp_request {
 	void *next_out;			/* next output byte */
 	unsigned int avail_in;		/* bytes available at next_in */
 	unsigned int avail_out;		/* bytes available at next_out */
+	size_t total_out;		/* total bytes output so far */
 };
 
 enum zlib_comp_params {
@@ -57,14 +58,16 @@ struct crypto_pcomp {
 struct pcomp_alg {
 	int (*compress_setup)(struct crypto_pcomp *tfm, void *params,
 			      unsigned int len);
-	int (*compress_init)(struct crypto_pcomp *tfm);
+	int (*compress_init)(struct crypto_pcomp *tfm,
+			     struct comp_request *req);
 	int (*compress_update)(struct crypto_pcomp *tfm,
 			       struct comp_request *req);
 	int (*compress_final)(struct crypto_pcomp *tfm,
 			      struct comp_request *req);
 	int (*decompress_setup)(struct crypto_pcomp *tfm, void *params,
 				unsigned int len);
-	int (*decompress_init)(struct crypto_pcomp *tfm);
+	int (*decompress_init)(struct crypto_pcomp *tfm,
+			       struct comp_request *req);
 	int (*decompress_update)(struct crypto_pcomp *tfm,
 				 struct comp_request *req);
 	int (*decompress_final)(struct crypto_pcomp *tfm,
@@ -102,9 +105,10 @@ static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
 	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
 }
 
-static inline int crypto_compress_init(struct crypto_pcomp *tfm)
+static inline int crypto_compress_init(struct crypto_pcomp *tfm,
+				       struct comp_request *req)
 {
-	return crypto_pcomp_alg(tfm)->compress_init(tfm);
+	return crypto_pcomp_alg(tfm)->compress_init(tfm, req);
 }
 
 static inline int crypto_compress_update(struct crypto_pcomp *tfm,
@@ -125,9 +129,10 @@ static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
 	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
 }
 
-static inline int crypto_decompress_init(struct crypto_pcomp *tfm)
+static inline int crypto_decompress_init(struct crypto_pcomp *tfm,
+					 struct comp_request *req)
 {
-	return crypto_pcomp_alg(tfm)->decompress_init(tfm);
+	return crypto_pcomp_alg(tfm)->decompress_init(tfm, req);
 }
 
 static inline int crypto_decompress_update(struct crypto_pcomp *tfm,
-- 
1.6.0.4

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
