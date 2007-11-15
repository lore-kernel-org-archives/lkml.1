Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbXKOG3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbXKOG3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764125AbXKOGWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45995 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbXKOGWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:18 -0500
Date: Wed, 14 Nov 2007 22:20:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/23] Fix crypto_alloc_comp() error checking.
Message-ID: <20071115062047.GO8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="fix-crypto_alloc_comp-error-checking.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[IPSEC]: Fix crypto_alloc_comp error checking

[ Upstream commit: 4999f3621f4da622e77931b3d33ada6c7083c705 ]

The function crypto_alloc_comp returns an errno instead of NULL
to indicate error.  So it needs to be tested with IS_ERR.

This is based on a patch by Vicenç Beltran Querol.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ipcomp.c  |    3 ++-
 net/ipv6/ipcomp6.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -17,6 +17,7 @@
 #include <asm/scatterlist.h>
 #include <asm/semaphore.h>
 #include <linux/crypto.h>
+#include <linux/err.h>
 #include <linux/pfkeyv2.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
@@ -355,7 +356,7 @@ static struct crypto_comp **ipcomp_alloc
 	for_each_possible_cpu(cpu) {
 		struct crypto_comp *tfm = crypto_alloc_comp(alg_name, 0,
 							    CRYPTO_ALG_ASYNC);
-		if (!tfm)
+		if (IS_ERR(tfm))
 			goto error;
 		*per_cpu_ptr(tfms, cpu) = tfm;
 	}
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -37,6 +37,7 @@
 #include <asm/scatterlist.h>
 #include <asm/semaphore.h>
 #include <linux/crypto.h>
+#include <linux/err.h>
 #include <linux/pfkeyv2.h>
 #include <linux/random.h>
 #include <linux/percpu.h>
@@ -366,7 +367,7 @@ static struct crypto_comp **ipcomp6_allo
 	for_each_possible_cpu(cpu) {
 		struct crypto_comp *tfm = crypto_alloc_comp(alg_name, 0,
 							    CRYPTO_ALG_ASYNC);
-		if (!tfm)
+		if (IS_ERR(tfm))
 			goto error;
 		*per_cpu_ptr(tfms, cpu) = tfm;
 	}

-- 
