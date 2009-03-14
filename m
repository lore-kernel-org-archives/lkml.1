Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbZCNCDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbZCNCDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZCNBWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:22:08 -0400
Received: from kroah.org ([198.145.64.141]:35832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755125AbZCNBVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:47 2009
Message-Id: <20090314011047.734304002@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:27 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       Kerin Millar <kerframil@gmail.com>
Subject: [patch 110/114] crypto: api - Fix algorithm test race that broke aead initialisation
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=crypto-api-fix-algorithm-test-race-that-broke-aead-initialisation.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit b8e15992b420d09dae831125a623c474c8637cee upstream.

When we complete a test we'll notify everyone waiting on it, drop
the mutex, and then remove the test larval (after reacquiring the
mutex).  If one of the notified parties tries to register another
algorithm with the same driver name prior to the removal of the
test larval, they will fail with EEXIST as only one algorithm of
a given name can be tested at any time.

This broke the initialisation of aead and givcipher algorithms as
they will register two algorithms with the same driver name, in
sequence.

This patch fixes the problem by marking the larval as dead before
we drop the mutex, and also ignoring all dead or dying algorithms
on the registration path.

Tested-by: Andreas Steffen <andreas.steffen@strongswan.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/algapi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -149,6 +149,9 @@ static struct crypto_larval *__crypto_re
 		if (q == alg)
 			goto err;
 
+		if (crypto_is_moribund(q))
+			continue;
+
 		if (crypto_is_larval(q)) {
 			if (!strcmp(alg->cra_driver_name, q->cra_driver_name))
 				goto err;
@@ -197,7 +200,7 @@ void crypto_alg_tested(const char *name,
 
 	down_write(&crypto_alg_sem);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
-		if (!crypto_is_larval(q))
+		if (crypto_is_moribund(q) || !crypto_is_larval(q))
 			continue;
 
 		test = (struct crypto_larval *)q;
@@ -210,6 +213,7 @@ void crypto_alg_tested(const char *name,
 	goto unlock;
 
 found:
+	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 	if (err || list_empty(&alg->cra_list))
 		goto complete;


