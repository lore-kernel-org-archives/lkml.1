Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbXLMHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbXLMHNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbXLMG55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55552 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762472AbXLMG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:54 -0500
Date: Wed, 12 Dec 2007 22:53:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 43/60] CRYPTO api: Fix potential race in crypto_remove_spawn
Message-ID: <20071213065308.GS6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-api-fix-potential-race-in-crypto_remove_spawn.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[CRYPTO] api: Fix potential race in crypto_remove_spawn

[ Upstream commit: 38cb2419f544ad413c7f7aa8c17fd7377610cdd8 ]

As it is crypto_remove_spawn may try to unregister an instance which is
yet to be registered.  This patch fixes this by checking whether the
instance has been registered before attempting to remove it.

It also removes a bogus cra_destroy check in crypto_register_instance as
1) it's outside the mutex;
2) we have a check in __crypto_register_alg already.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/algapi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -98,6 +98,9 @@ static void crypto_remove_spawn(struct c
 		return;
 
 	inst->alg.cra_flags |= CRYPTO_ALG_DEAD;
+	if (hlist_unhashed(&inst->list))
+		return;
+
 	if (!tmpl || !crypto_tmpl_get(tmpl))
 		return;
 
@@ -333,9 +336,6 @@ int crypto_register_instance(struct cryp
 	LIST_HEAD(list);
 	int err = -EINVAL;
 
-	if (inst->alg.cra_destroy)
-		goto err;
-
 	err = crypto_check_alg(&inst->alg);
 	if (err)
 		goto err;

-- 
