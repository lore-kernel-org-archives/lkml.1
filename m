Return-Path: <linux-kernel-owner+w=401wt.eu-S935323AbXEUTra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323AbXEUTra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765916AbXEUT2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:20 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52601 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXEUT2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:18 -0400
Message-Id: <20070521191748.976528000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 53/69] IPSEC: Check validity of direction in xfrm_policy_byid
Content-Disposition: inline; filename=ipsec-check-validity-of-direction-in-xfrm_policy_byid.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

The function xfrm_policy_byid takes a dir argument but finds the policy
using the index instead.  We only use the dir argument to update the
policy count for that direction.  Since the user can supply any value
for dir, this can corrupt our policy count.

I know this is the problem because a few days ago I was deleting
policies by hand using indicies and accidentally typed in the wrong
direction.  It still deleted the policy and at the time I thought
that was cool.  In retrospect it isn't such a good idea :)

I decided against letting it delete the policy anyway just in case
we ever remove the connection between indicies and direction.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/xfrm/xfrm_policy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.21.1.orig/net/xfrm/xfrm_policy.c
+++ linux-2.6.21.1/net/xfrm/xfrm_policy.c
@@ -782,6 +782,10 @@ struct xfrm_policy *xfrm_policy_byid(u8 
 	struct hlist_head *chain;
 	struct hlist_node *entry;
 
+	*err = -ENOENT;
+	if (xfrm_policy_id2dir(id) != dir)
+		return NULL;
+
 	*err = 0;
 	write_lock_bh(&xfrm_policy_lock);
 	chain = xfrm_policy_byidx + idx_hash(id);

-- 
