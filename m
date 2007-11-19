Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXKSSZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXKSSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXKSSWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49202 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXKSSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:04 -0500
Date: Mon, 19 Nov 2007 10:19:00 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
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
Subject: [patch 12/26] Fix crypto_alloc_comp() error checking.
Message-ID: <20071119181900.GM15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="fix-crypto_alloc_comp-error-checking.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

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
