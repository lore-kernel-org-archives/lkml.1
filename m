Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZAaCyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZAaCyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbZAaCq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:58 -0500
Received: from kroah.org ([198.145.64.141]:54943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755321AbZAaCqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:55 -0500
Date: Fri, 30 Jan 2009 18:40:28 -0800
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
Subject: [patch 22/32] crypto: authenc - Fix zero-length IV crash
Message-ID: <20090131024028.GW12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-authenc-fix-zero-length-iv-crash.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 29b37f42127f7da511560a40ea74f5047da40c13 upstream.

As it is if an algorithm with a zero-length IV is used (e.g.,
NULL encryption) with authenc, authenc may generate an SG entry
of length zero, which will trigger a BUG check in the hash layer.

This patch fixes it by skipping the IV SG generation if the IV
size is zero.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/authenc.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -157,16 +157,19 @@ static int crypto_authenc_genicv(struct 
 	dstp = sg_page(dst);
 	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
 
-	sg_init_table(cipher, 2);
-	sg_set_buf(cipher, iv, ivsize);
-	authenc_chain(cipher, dst, vdst == iv + ivsize);
+	if (ivsize) {
+		sg_init_table(cipher, 2);
+		sg_set_buf(cipher, iv, ivsize);
+		authenc_chain(cipher, dst, vdst == iv + ivsize);
+		dst = cipher;
+	}
 
 	cryptlen = req->cryptlen + ivsize;
-	hash = crypto_authenc_hash(req, flags, cipher, cryptlen);
+	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
-	scatterwalk_map_and_copy(hash, cipher, cryptlen,
+	scatterwalk_map_and_copy(hash, dst, cryptlen,
 				 crypto_aead_authsize(authenc), 1);
 	return 0;
 }
@@ -284,11 +287,14 @@ static int crypto_authenc_iverify(struct
 	srcp = sg_page(src);
 	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
 
-	sg_init_table(cipher, 2);
-	sg_set_buf(cipher, iv, ivsize);
-	authenc_chain(cipher, src, vsrc == iv + ivsize);
+	if (ivsize) {
+		sg_init_table(cipher, 2);
+		sg_set_buf(cipher, iv, ivsize);
+		authenc_chain(cipher, src, vsrc == iv + ivsize);
+		src = cipher;
+	}
 
-	return crypto_authenc_verify(req, cipher, cryptlen + ivsize);
+	return crypto_authenc_verify(req, src, cryptlen + ivsize);
 }
 
 static int crypto_authenc_decrypt(struct aead_request *req)

