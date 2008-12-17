Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754398AbYLQQnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYLQQnA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYLQQmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:42:05 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65190 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751493AbYLQQmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:00 -0500
Message-Id: <20081217164036.598702037@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 17 Dec 2008 17:36:38 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 3/8] crypto: testmgr - Add support for the pcomp interface
Content-Disposition: inline; filename=crypto-add-pcomp-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |    7 ++
 2 files changed, 173 insertions(+)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -72,6 +72,13 @@ struct comp_test_suite {
 	} comp, decomp;
 };
 
+struct pcomp_test_suite {
+	struct {
+		struct pcomp_testvec *vecs;
+		unsigned int count;
+	} comp, decomp;
+};
+
 struct hash_test_suite {
 	struct hash_testvec *vecs;
 	unsigned int count;
@@ -86,6 +93,7 @@ struct alg_test_desc {
 		struct aead_test_suite aead;
 		struct cipher_test_suite cipher;
 		struct comp_test_suite comp;
+		struct pcomp_test_suite pcomp;
 		struct hash_test_suite hash;
 	} suite;
 };
@@ -898,6 +906,142 @@ out:
 	return ret;
 }
 
+static int test_pcomp(struct crypto_pcomp *tfm,
+		      struct pcomp_testvec *ctemplate,
+		      struct pcomp_testvec *dtemplate, int ctcount,
+		      int dtcount)
+{
+	const char *algo = crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm));
+	unsigned int i;
+	char result[COMP_BUF_SIZE];
+	int error;
+
+	for (i = 0; i < ctcount; i++) {
+		struct comp_request req;
+
+		error = crypto_pcomp_setup(tfm, ctemplate[i].params);
+		if (error) {
+			pr_err("alg: pcomp: compression setup failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		memset(result, 0, sizeof(result));
+
+		req.next_in = ctemplate[i].input;
+		req.avail_in = ctemplate[i].inlen / 2;
+		req.next_out = result;
+		req.avail_out = ctemplate[i].outlen / 2;
+
+		error = crypto_pcomp_compress_init(tfm, &req);
+		if (error && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: compression init failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Add remaining input data */
+		req.avail_in += (ctemplate[i].inlen + 1) / 2;
+
+		error = crypto_pcomp_compress_update(tfm, &req);
+		if (error && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: compression update failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Provide remaining output space */
+		req.avail_out += COMP_BUF_SIZE - ctemplate[i].outlen / 2;
+
+		error = crypto_pcomp_compress_final(tfm, &req);
+		if (error) {
+			pr_err("alg: pcomp: compression final failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		if (COMP_BUF_SIZE - req.avail_out != ctemplate[i].outlen) {
+			pr_err("alg: comp: Compression test %d failed for %s: "
+			       "output len = %d (expected %d)\n", i + 1, algo,
+			       COMP_BUF_SIZE - req.avail_out,
+			       ctemplate[i].outlen);
+			return -EINVAL;
+		}
+
+		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
+			pr_err("alg: pcomp: Compression test %d failed for "
+			       "%s\n", i + 1, algo);
+			hexdump(result, ctemplate[i].outlen);
+			return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < dtcount; i++) {
+		struct comp_request req;
+
+		error = crypto_pcomp_setup(tfm, dtemplate[i].params);
+		if (error) {
+			pr_err("alg: pcomp: decompression setup failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		memset(result, 0, sizeof(result));
+
+		req.next_in = dtemplate[i].input;
+		req.avail_in = dtemplate[i].inlen / 2;
+		req.next_out = result;
+		req.avail_out = dtemplate[i].outlen / 2;
+
+		error = crypto_pcomp_decompress_init(tfm, &req);
+		if (error  && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression init failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Add remaining input data */
+		req.avail_in += (dtemplate[i].inlen + 1) / 2;
+
+		error = crypto_pcomp_decompress_update(tfm, &req);
+		if (error  && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression update failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		/* Provide remaining output space */
+		req.avail_out += COMP_BUF_SIZE - dtemplate[i].outlen / 2;
+
+		error = crypto_pcomp_decompress_final(tfm, &req);
+		if (error  && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression final failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		if (COMP_BUF_SIZE - req.avail_out != dtemplate[i].outlen) {
+			pr_err("alg: comp: Decompression test %d failed for "
+			       "%s: output len = %d (expected %d)\n", i + 1,
+			       algo, COMP_BUF_SIZE - req.avail_out,
+			       dtemplate[i].outlen);
+			return -EINVAL;
+		}
+
+		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
+			pr_err("alg: pcomp: Decompression test %d failed for "
+			       "%s\n", i + 1, algo);
+			hexdump(result, dtemplate[i].outlen);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -1007,6 +1151,28 @@ static int alg_test_comp(const struct al
 	return err;
 }
 
+static int alg_test_pcomp(const struct alg_test_desc *desc, const char *driver,
+			  u32 type, u32 mask)
+{
+	struct crypto_pcomp *tfm;
+	int err;
+
+	tfm = crypto_alloc_pcomp(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: pcomp: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	err = test_pcomp(tfm, desc->suite.pcomp.comp.vecs,
+			 desc->suite.pcomp.decomp.vecs,
+			 desc->suite.pcomp.comp.count,
+			 desc->suite.pcomp.decomp.count);
+
+	crypto_free_pcomp(tfm);
+	return err;
+}
+
 static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -8347,6 +8347,13 @@ struct comp_testvec {
 	char output[COMP_BUF_SIZE];
 };
 
+struct pcomp_testvec {
+	const void *params;
+	int inlen, outlen;
+	char input[COMP_BUF_SIZE];
+	char output[COMP_BUF_SIZE];
+};
+
 /*
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.

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

