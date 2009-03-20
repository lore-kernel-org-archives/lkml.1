Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbZCTXRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbZCTXRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758855AbZCTXNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:44 -0400
Received: from kroah.org ([198.145.64.141]:53099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755836AbZCTXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:10 2009
Message-Id: <20090320222710.657121996@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Huang Ying <ying.huang@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 11/32] dm crypt: fix kcryptd_async_done parameter
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=dm-crypt-fix-kcryptd_async_done-parameter.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Huang Ying <ying.huang@intel.com>

commit b2174eebd1fadb76454dad09a1dacbc17081e6b0 upstream.

In the async encryption-complete function (kcryptd_async_done), the
crypto_async_request passed in may be different from the one passed to
crypto_ablkcipher_encrypt/decrypt.  Only crypto_async_request->data is
guaranteed to be same as the one passed in.  The current
kcryptd_async_done uses the passed-in crypto_async_request directly
which may cause the AES-NI-based AES algorithm implementation to panic.

This patch fixes this bug by only using crypto_async_request->data,
which points to dm_crypt_request, the crypto_async_request passed in.
The original data (convert_context) is gotten from dm_crypt_request.

[mbroz@redhat.com: reworked]
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -59,6 +59,7 @@ struct dm_crypt_io {
 };
 
 struct dm_crypt_request {
+	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 };
@@ -336,6 +337,18 @@ static void crypt_convert_init(struct cr
 	atomic_set(&ctx->pending, 1);
 }
 
+static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
+					     struct ablkcipher_request *req)
+{
+	return (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+}
+
+static struct ablkcipher_request *req_of_dmreq(struct crypt_config *cc,
+					       struct dm_crypt_request *dmreq)
+{
+	return (struct ablkcipher_request *)((char *)dmreq - cc->dmreq_start);
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
@@ -346,10 +359,11 @@ static int crypt_convert_block(struct cr
 	u8 *iv;
 	int r = 0;
 
-	dmreq = (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
 
+	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
 		    bv_in->bv_offset + ctx->offset_in);
@@ -396,8 +410,9 @@ static void crypt_alloc_req(struct crypt
 		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 	ablkcipher_request_set_tfm(cc->req, cc->tfm);
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-					     CRYPTO_TFM_REQ_MAY_SLEEP,
-					     kcryptd_async_done, ctx);
+					CRYPTO_TFM_REQ_MAY_SLEEP,
+					kcryptd_async_done,
+					dmreq_of_req(cc, cc->req));
 }
 
 /*
@@ -757,7 +772,8 @@ static void kcryptd_crypt_read_convert(s
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error)
 {
-	struct convert_context *ctx = async_req->data;
+	struct dm_crypt_request *dmreq = async_req->data;
+	struct convert_context *ctx = dmreq->ctx;
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->target->private;
 
@@ -766,7 +782,7 @@ static void kcryptd_async_done(struct cr
 		return;
 	}
 
-	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
+	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;


