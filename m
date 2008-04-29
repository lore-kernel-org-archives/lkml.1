Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbYD2RXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbYD2RXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbYD2RUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:51913 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYD2RUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:35 -0400
Date: Tue, 29 Apr 2008 10:18:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [10/37] IPSEC: Fix catch-22 with algorithm IDs above 31
Message-ID: <20080429171818.GK14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipsec-fix-catch-22-with-algorithm-ids-above-31.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit: c5d18e984a313adf5a1a4ae69e0b1d93cf410229 ]

As it stands it's impossible to use any authentication algorithms
with an ID above 31 portably.  It just happens to work on x86 but
fails miserably on ppc64.

The reason is that we're using a bit mask to check the algorithm
ID but the mask is only 32 bits wide.

After looking at how this is used in the field, I have concluded
that in the long term we should phase out state matching by IDs
because this is made superfluous by the reqid feature.  For current
applications, the best solution IMHO is to allow all algorithms when
the bit masks are all ~0.

The following patch does exactly that.

This bug was identified by IBM when testing on the ppc64 platform
using the NULL authentication algorithm which has an ID of 251.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/xfrm.h     |    3 +++
 net/key/af_key.c       |    2 +-
 net/xfrm/xfrm_policy.c |    2 +-
 net/xfrm/xfrm_user.c   |    2 ++
 4 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -435,6 +435,9 @@ struct xfrm_tmpl
 /* May skip this transfomration if no SA is found */
 	__u8			optional;
 
+/* Skip aalgos/ealgos/calgos checks. */
+	__u8			allalgs;
+
 /* Bit mask of algos allowed for acquisition */
 	__u32			aalgos;
 	__u32			ealgos;
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1856,7 +1856,7 @@ parse_ipsecrequest(struct xfrm_policy *x
 		t->encap_family = xp->family;
 
 	/* No way to set this via kame pfkey */
-	t->aalgos = t->ealgos = t->calgos = ~0;
+	t->allalgs = 1;
 	xp->xfrm_nr++;
 	return 0;
 }
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1772,7 +1772,7 @@ xfrm_state_ok(struct xfrm_tmpl *tmpl, st
 		(x->id.spi == tmpl->id.spi || !tmpl->id.spi) &&
 		(x->props.reqid == tmpl->reqid || !tmpl->reqid) &&
 		x->props.mode == tmpl->mode &&
-		((tmpl->aalgos & (1<<x->props.aalgo)) ||
+		(tmpl->allalgs || (tmpl->aalgos & (1<<x->props.aalgo)) ||
 		 !(xfrm_id_proto_match(tmpl->id.proto, IPSEC_PROTO_ANY))) &&
 		!(x->props.mode != XFRM_MODE_TRANSPORT &&
 		  xfrm_state_addr_cmp(tmpl, x, family));
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -975,6 +975,8 @@ static void copy_templates(struct xfrm_p
 		t->aalgos = ut->aalgos;
 		t->ealgos = ut->ealgos;
 		t->calgos = ut->calgos;
+		/* If all masks are ~0, then we allow all algorithms. */
+		t->allalgs = !~(t->aalgos & t->ealgos & t->calgos);
 		t->encap_family = ut->family;
 	}
 }

-- 
