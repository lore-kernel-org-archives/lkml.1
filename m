Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbZFIKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbZFIKcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759689AbZFIKVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:21:03 -0400
Received: from kroah.org ([198.145.64.141]:55288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbZFIKVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:02 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:06 2009
Message-Id: <20090609094106.622250240@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:50 -0700
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
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 62/87] crypto: api - Fix algorithm module auto-loading
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=crypto-api-fix-algorithm-module-auto-loading.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 37fc334cc8eb84f5fe0a5a1cbe6a6a68049e142a upstream.

The commit a760a6656e6f00bb0144a42a048cf0266646e22c (crypto:
api - Fix module load deadlock with fallback algorithms) broke
the auto-loading of algorithms that require fallbacks.  The
problem is that the fallback mask check is missing an and which
cauess bits that should be considered to interfere with the
result.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -221,7 +221,8 @@ struct crypto_alg *crypto_larval_lookup(
 
 		request_module(name);
 
-		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask) &&
+		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask &
+		      CRYPTO_ALG_NEED_FALLBACK) &&
 		    snprintf(tmp, sizeof(tmp), "%s-all", name) < sizeof(tmp))
 			request_module(tmp);
 


