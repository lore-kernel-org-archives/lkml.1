Return-Path: <linux-kernel-owner+w=401wt.eu-S1946253AbXBCChy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946253AbXBCChy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946255AbXBCChT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:37:19 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52826 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946253AbXBCChE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:37:04 -0500
Message-Id: <20070203024055.928618000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:25 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       David Miller <davem@davemloft.net>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>, pupilla@hotmail.com
Subject: [patch 21/59] IPSEC: Policy list disorder
Content-Disposition: inline; filename=ipsec-policy-list-disorder.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

The recent hashing introduced an off-by-one bug in policy list insertion.
Instead of adding after the last entry with a lesser or equal priority,
we're adding after the successor of that entry.

This patch fixes this and also adds a warning if we detect a duplicate
entry in the policy list.  This should never happen due to this if clause.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/xfrm/xfrm_policy.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- linux-2.6.19.2.orig/net/xfrm/xfrm_policy.c
+++ linux-2.6.19.2/net/xfrm/xfrm_policy.c
@@ -615,19 +615,18 @@ int xfrm_policy_insert(int dir, struct x
 	struct xfrm_policy *pol;
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
-	struct hlist_node *entry, *newpos, *last;
+	struct hlist_node *entry, *newpos;
 	struct dst_entry *gc_list;
 
 	write_lock_bh(&xfrm_policy_lock);
 	chain = policy_hash_bysel(&policy->selector, policy->family, dir);
 	delpol = NULL;
 	newpos = NULL;
-	last = NULL;
 	hlist_for_each_entry(pol, entry, chain, bydst) {
-		if (!delpol &&
-		    pol->type == policy->type &&
+		if (pol->type == policy->type &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_sec_ctx_match(pol->security, policy->security)) {
+		    xfrm_sec_ctx_match(pol->security, policy->security) &&
+		    !WARN_ON(delpol)) {
 			if (excl) {
 				write_unlock_bh(&xfrm_policy_lock);
 				return -EEXIST;
@@ -636,17 +635,12 @@ int xfrm_policy_insert(int dir, struct x
 			if (policy->priority > pol->priority)
 				continue;
 		} else if (policy->priority >= pol->priority) {
-			last = &pol->bydst;
+			newpos = &pol->bydst;
 			continue;
 		}
-		if (!newpos)
-			newpos = &pol->bydst;
 		if (delpol)
 			break;
-		last = &pol->bydst;
 	}
-	if (!newpos)
-		newpos = last;
 	if (newpos)
 		hlist_add_after(newpos, &policy->bydst);
 	else

--
