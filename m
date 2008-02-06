Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbYBFX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbYBFX6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYBFXy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:45103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764078AbYBFXyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:23 -0500
Date: Wed, 6 Feb 2008 15:51:12 -0800
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
Subject: [patch 09/73] IPSEC: Fix potential dst leak in xfrm_lookup
Message-ID: <20080206235112.GJ13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipsec-fix-potential-dst-leak-in-xfrm_lookup.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[IPSEC]: Fix potential dst leak in xfrm_lookup

[ Upstream commit: 75b8c133267053c9986a7c8db5131f0e7349e806 ]

If we get an error during the actual policy lookup we don't free the
original dst while the caller expects us to always free the original
dst in case of error.

This patch fixes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_policy.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1479,8 +1479,9 @@ restart:
 
 	if (sk && sk->sk_policy[1]) {
 		policy = xfrm_sk_policy_lookup(sk, XFRM_POLICY_OUT, fl);
+		err = PTR_ERR(policy);
 		if (IS_ERR(policy))
-			return PTR_ERR(policy);
+			goto dropdst;
 	}
 
 	if (!policy) {
@@ -1491,8 +1492,9 @@ restart:
 
 		policy = flow_cache_lookup(fl, dst_orig->ops->family,
 					   dir, xfrm_policy_lookup);
+		err = PTR_ERR(policy);
 		if (IS_ERR(policy))
-			return PTR_ERR(policy);
+			goto dropdst;
 	}
 
 	if (!policy)
@@ -1661,8 +1663,9 @@ restart:
 	return 0;
 
 error:
-	dst_release(dst_orig);
 	xfrm_pols_put(pols, npols);
+dropdst:
+	dst_release(dst_orig);
 	*dst_p = NULL;
 	return err;
 }

-- 
