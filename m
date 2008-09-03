Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYICRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYICRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYICRv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:51:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:54072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYICRv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:51:56 -0400
Date: Wed, 3 Sep 2008 10:33:00 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 09/16] crypto: authenc - Avoid using clobbered request
	pointer
Message-ID: <20080903173300.GJ10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-authenc-avoid-using-clobbered-request-pointer.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

crypto: authenc - Avoid using clobbered request pointer

[ Upstream commit: a697690bece75d4ba424c1318eb25c37d41d5829 ]

Authenc works in two stages for encryption, it first encrypts and
then computes an ICV.  The context memory of the request is used
by both operations.  The problem is that when an asynchronous
encryption completes, we will compute the ICV and then reread the
context memory of the encryption to get the original request.

It just happens that we have a buffer of 16 bytes in front of the
request pointer, so ICVs of 16 bytes (such as SHA1) do not trigger
the bug.  However, any attempt to uses a larger ICV instantly kills
the machine when the first asynchronous encryption is completed.

This patch fixes this by saving the request pointer before we start
the ICV computation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/authenc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -174,8 +174,9 @@ static int crypto_authenc_genicv(struct 
 static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 					int err)
 {
+	struct aead_request *areq = req->data;
+
 	if (!err) {
-		struct aead_request *areq = req->data;
 		struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 		struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 		struct ablkcipher_request *abreq = aead_request_ctx(areq);
@@ -185,7 +186,7 @@ static void crypto_authenc_encrypt_done(
 		err = crypto_authenc_genicv(areq, iv, 0);
 	}
 
-	aead_request_complete(req->data, err);
+	aead_request_complete(areq, err);
 }
 
 static int crypto_authenc_encrypt(struct aead_request *req)
@@ -216,14 +217,15 @@ static int crypto_authenc_encrypt(struct
 static void crypto_authenc_givencrypt_done(struct crypto_async_request *req,
 					   int err)
 {
+	struct aead_request *areq = req->data;
+
 	if (!err) {
-		struct aead_request *areq = req->data;
 		struct skcipher_givcrypt_request *greq = aead_request_ctx(areq);
 
 		err = crypto_authenc_genicv(areq, greq->giv, 0);
 	}
 
-	aead_request_complete(req->data, err);
+	aead_request_complete(areq, err);
 }
 
 static int crypto_authenc_givencrypt(struct aead_givcrypt_request *req)

-- 
