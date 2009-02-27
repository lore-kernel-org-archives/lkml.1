Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZB0I4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZB0I4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZB0I4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:56:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:50176 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZB0I4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:56:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,275,1233561600"; 
   d="asc'?scan'208";a="390230913"
Subject: [BUGFIX] dm-crypt: Fix a bug of async cryption complete function
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mpy7IBeGMATwSM7UcNHh"
Date: Fri, 27 Feb 2009 16:56:11 +0800
Message-Id: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mpy7IBeGMATwSM7UcNHh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

In async cryption complete function (kcryptd_async_done), the
crypto_async_request passed in may be different from the one passed to
crypto_ablkcipher_encrypt/decrypt. Only crypto_async_request->data is
guaranteed to be same as the passed in one. Current kcryptd_async_done
uses passed in crypto_async_request directly, which may cause AES-NI
based AES algorithm implementation panic.

This patch fix this bug by using crypto_async_request->data only,
which point to dm_crypt_request, the crypto_async_request passed in
and original data (convert_context) can be gotten from
dm_crypt_request.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 drivers/md/dm-crypt.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -60,6 +60,8 @@ struct dm_crypt_io {
 };
=20
 struct dm_crypt_request {
+	struct ablkcipher_request *req;
+	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 };
@@ -349,6 +351,8 @@ static int crypt_convert_block(struct cr
 	iv =3D (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
=20
+	dmreq->req =3D req;
+	dmreq->ctx =3D ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
 		    bv_in->bv_offset + ctx->offset_in);
@@ -391,12 +395,15 @@ static void kcryptd_async_done(struct cr
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
+	struct dm_crypt_request *dmreq;
+
 	if (!cc->req)
 		cc->req =3D mempool_alloc(cc->req_pool, GFP_NOIO);
 	ablkcipher_request_set_tfm(cc->req, cc->tfm);
+	dmreq =3D (struct dm_crypt_request *)((char *)cc->req + cc->dmreq_start);
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 					     CRYPTO_TFM_REQ_MAY_SLEEP,
-					     kcryptd_async_done, ctx);
+					     kcryptd_async_done, dmreq);
 }
=20
 /*
@@ -821,7 +828,8 @@ static void kcryptd_crypt_read_convert(s
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error)
 {
-	struct convert_context *ctx =3D async_req->data;
+	struct dm_crypt_request *dmreq =3D async_req->data;
+	struct convert_context *ctx =3D dmreq->ctx;
 	struct dm_crypt_io *io =3D container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc =3D io->target->private;
=20
@@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
 		return;
 	}
=20
-	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
+	mempool_free(dmreq->req, cc->req_pool);
=20
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;


--=-Mpy7IBeGMATwSM7UcNHh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmnqqcACgkQKhFGF+eHlpgOhQCfYYPneGJgDtyBmjYWP4GrcZ0F
ULkAnj6JYcFEl57wsArQUL6aog3zl/jm
=AEIJ
-----END PGP SIGNATURE-----

--=-Mpy7IBeGMATwSM7UcNHh--

