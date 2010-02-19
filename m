Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0BSRJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:09:15 -0500
Received: from kroah.org ([198.145.64.141]:57654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab0BSRAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:50 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:46 2010
Message-Id: <20100219163246.019476055@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [55/93] crypto: padlock-sha - Add import/export support
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a8d7ac279743077965afeca0c9ed748507b68e89 upstream.

As the padlock driver for SHA uses a software fallback to perform
partial hashing, it must implement custom import/export functions.
Otherwise hmac which depends on import/export for prehashing will
not work with padlock-sha.

Reported-by: Wolfgang Walter <wolfgang.walter@stwm.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/crypto/padlock-sha.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -57,6 +57,23 @@ static int padlock_sha_update(struct sha
 	return crypto_shash_update(&dctx->fallback, data, length);
 }
 
+static int padlock_sha_export(struct shash_desc *desc, void *out)
+{
+	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
+
+	return crypto_shash_export(&dctx->fallback, out);
+}
+
+static int padlock_sha_import(struct shash_desc *desc, const void *in)
+{
+	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
+	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
+
+	dctx->fallback.tfm = ctx->fallback;
+	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_shash_import(&dctx->fallback, in);
+}
+
 static inline void padlock_output_block(uint32_t *src,
 		 	uint32_t *dst, size_t count)
 {
@@ -235,7 +252,10 @@ static struct shash_alg sha1_alg = {
 	.update 	=	padlock_sha_update,
 	.finup  	=	padlock_sha1_finup,
 	.final  	=	padlock_sha1_final,
+	.export		=	padlock_sha_export,
+	.import		=	padlock_sha_import,
 	.descsize	=	sizeof(struct padlock_sha_desc),
+	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
 		.cra_name		=	"sha1",
 		.cra_driver_name	=	"sha1-padlock",
@@ -256,7 +276,10 @@ static struct shash_alg sha256_alg = {
 	.update 	=	padlock_sha_update,
 	.finup  	=	padlock_sha256_finup,
 	.final  	=	padlock_sha256_final,
+	.export		=	padlock_sha_export,
+	.import		=	padlock_sha_import,
 	.descsize	=	sizeof(struct padlock_sha_desc),
+	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name		=	"sha256",
 		.cra_driver_name	=	"sha256-padlock",


