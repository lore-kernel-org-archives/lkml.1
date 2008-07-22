Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbYGVXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbYGVXcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbYGVXXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbYGVXXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:22 -0400
Date: Tue, 22 Jul 2008 16:17:29 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 42/47] crypto: chainiv - Invoke completion function
Message-ID: <20080722231729.GQ8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-chainiv-invoke-completion-function.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

Upstream commit: 872ac8743cb400192a9fce4ba2d3ffd7bb309685

When chainiv postpones requests it never calls their completion functions.
This causes symptoms such as memory leaks when IPsec is in use.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/chainiv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -117,6 +117,7 @@ static int chainiv_init(struct crypto_tf
 static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
 {
 	int queued;
+	int err = ctx->err;
 
 	if (!ctx->queue.qlen) {
 		smp_mb__before_clear_bit();
@@ -131,7 +132,7 @@ static int async_chainiv_schedule_work(s
 	BUG_ON(!queued);
 
 out:
-	return ctx->err;
+	return err;
 }
 
 static int async_chainiv_postpone_request(struct skcipher_givcrypt_request *req)
@@ -227,6 +228,7 @@ static void async_chainiv_do_postponed(s
 						     postponed);
 	struct skcipher_givcrypt_request *req;
 	struct ablkcipher_request *subreq;
+	int err;
 
 	/* Only handle one request at a time to avoid hogging keventd. */
 	spin_lock_bh(&ctx->lock);
@@ -241,7 +243,11 @@ static void async_chainiv_do_postponed(s
 	subreq = skcipher_givcrypt_reqctx(req);
 	subreq->base.flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	async_chainiv_givencrypt_tail(req);
+	err = async_chainiv_givencrypt_tail(req);
+
+	local_bh_disable();
+	skcipher_givcrypt_complete(req, err);
+	local_bh_enable();
 }
 
 static int async_chainiv_init(struct crypto_tfm *tfm)

-- 
