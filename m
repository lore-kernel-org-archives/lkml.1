Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYICRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYICRoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYICRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:43:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:52835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYICRn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:43:56 -0400
Date: Wed, 3 Sep 2008 10:26:30 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 32/42] ipsec: Fix deadlock in xfrm_state management.
Message-ID: <20080903172630.GG7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0013-ipsec-Fix-deadlock-in-xfrm_state-management.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 37b08e34a98c664bea86e3fae718ac45a46b7276 ]

Ever since commit 4c563f7669c10a12354b72b518c2287ffc6ebfb3
("[XFRM]: Speed up xfrm_policy and xfrm_state walking") it is
illegal to call __xfrm_state_destroy (and thus xfrm_state_put())
with xfrm_state_lock held.  If we do, we'll deadlock since we
have the lock already and __xfrm_state_destroy() tries to take
it again.

Fix this by pushing the xfrm_state_put() calls after the lock
is dropped.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_state.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -780,11 +780,13 @@ xfrm_state_find(xfrm_address_t *daddr, x
 {
 	unsigned int h;
 	struct hlist_node *entry;
-	struct xfrm_state *x, *x0;
+	struct xfrm_state *x, *x0, *to_put;
 	int acquire_in_progress = 0;
 	int error = 0;
 	struct xfrm_state *best = NULL;
 
+	to_put = NULL;
+
 	spin_lock_bh(&xfrm_state_lock);
 	h = xfrm_dst_hash(daddr, saddr, tmpl->reqid, family);
 	hlist_for_each_entry(x, entry, xfrm_state_bydst+h, bydst) {
@@ -833,7 +835,7 @@ xfrm_state_find(xfrm_address_t *daddr, x
 		if (tmpl->id.spi &&
 		    (x0 = __xfrm_state_lookup(daddr, tmpl->id.spi,
 					      tmpl->id.proto, family)) != NULL) {
-			xfrm_state_put(x0);
+			to_put = x0;
 			error = -EEXIST;
 			goto out;
 		}
@@ -849,7 +851,7 @@ xfrm_state_find(xfrm_address_t *daddr, x
 		error = security_xfrm_state_alloc_acquire(x, pol->security, fl->secid);
 		if (error) {
 			x->km.state = XFRM_STATE_DEAD;
-			xfrm_state_put(x);
+			to_put = x;
 			x = NULL;
 			goto out;
 		}
@@ -870,7 +872,7 @@ xfrm_state_find(xfrm_address_t *daddr, x
 			xfrm_hash_grow_check(x->bydst.next != NULL);
 		} else {
 			x->km.state = XFRM_STATE_DEAD;
-			xfrm_state_put(x);
+			to_put = x;
 			x = NULL;
 			error = -ESRCH;
 		}
@@ -881,6 +883,8 @@ out:
 	else
 		*err = acquire_in_progress ? -EAGAIN : error;
 	spin_unlock_bh(&xfrm_state_lock);
+	if (to_put)
+		xfrm_state_put(to_put);
 	return x;
 }
 
@@ -1067,18 +1071,20 @@ static struct xfrm_state *__xfrm_find_ac
 
 int xfrm_state_add(struct xfrm_state *x)
 {
-	struct xfrm_state *x1;
+	struct xfrm_state *x1, *to_put;
 	int family;
 	int err;
 	int use_spi = xfrm_id_proto_match(x->id.proto, IPSEC_PROTO_ANY);
 
 	family = x->props.family;
 
+	to_put = NULL;
+
 	spin_lock_bh(&xfrm_state_lock);
 
 	x1 = __xfrm_state_locate(x, use_spi, family);
 	if (x1) {
-		xfrm_state_put(x1);
+		to_put = x1;
 		x1 = NULL;
 		err = -EEXIST;
 		goto out;
@@ -1088,7 +1094,7 @@ int xfrm_state_add(struct xfrm_state *x)
 		x1 = __xfrm_find_acq_byseq(x->km.seq);
 		if (x1 && ((x1->id.proto != x->id.proto) ||
 		    xfrm_addr_cmp(&x1->id.daddr, &x->id.daddr, family))) {
-			xfrm_state_put(x1);
+			to_put = x1;
 			x1 = NULL;
 		}
 	}
@@ -1110,6 +1116,9 @@ out:
 		xfrm_state_put(x1);
 	}
 
+	if (to_put)
+		xfrm_state_put(to_put);
+
 	return err;
 }
 EXPORT_SYMBOL(xfrm_state_add);
@@ -1269,10 +1278,12 @@ EXPORT_SYMBOL(xfrm_state_migrate);
 
 int xfrm_state_update(struct xfrm_state *x)
 {
-	struct xfrm_state *x1;
+	struct xfrm_state *x1, *to_put;
 	int err;
 	int use_spi = xfrm_id_proto_match(x->id.proto, IPSEC_PROTO_ANY);
 
+	to_put = NULL;
+
 	spin_lock_bh(&xfrm_state_lock);
 	x1 = __xfrm_state_locate(x, use_spi, x->props.family);
 
@@ -1281,7 +1292,7 @@ int xfrm_state_update(struct xfrm_state 
 		goto out;
 
 	if (xfrm_state_kern(x1)) {
-		xfrm_state_put(x1);
+		to_put = x1;
 		err = -EEXIST;
 		goto out;
 	}
@@ -1295,6 +1306,9 @@ int xfrm_state_update(struct xfrm_state 
 out:
 	spin_unlock_bh(&xfrm_state_lock);
 
+	if (to_put)
+		xfrm_state_put(to_put);
+
 	if (err)
 		return err;
 

-- 
