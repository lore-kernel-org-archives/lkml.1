Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbYLELfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbYLELfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLELew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:34:52 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39596 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYLELev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:34:51 -0500
Date: Fri, 5 Dec 2008 12:34:46 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] net/netfilter: simplify error handling
Message-ID: <Pine.LNX.4.64.0812051234230.9560@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

nf_conntrack_alloc cannot return NULL, so there is no need to check for
NULL before using the value.  I have also removed the initialization of ct
to NULL in nf_conntrack_alloc, since the value is never used, and since
perhaps it might lead one to think that return ct at the end might return
NULL.

The semantic patch that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match exists@
expression x, E;
position p1,p2;
statement S1, S2;
@@

x@p1 = nf_conntrack_alloc(...)
... when != x = E
(
  if (x@p2 == NULL || ...) S1 else S2
|
  if (x@p2 == NULL && ...) S1 else S2
)

@other_match exists@
expression match.x, E1, E2;
position p1!=match.p1,match.p2;
@@

x@p1 = E1
... when != x = E2
x@p2

@ script:python depends on !other_match@
p1 << match.p1;
p2 << match.p2;
@@

print "%s: call to nf_conntrack_alloc %s bad test %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/netfilter/nf_conntrack_core.c    |    4 ++--
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 233fdd2..79582e0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -468,7 +468,7 @@ struct nf_conn *nf_conntrack_alloc(struct net *net,
 				   const struct nf_conntrack_tuple *repl,
 				   gfp_t gfp)
 {
-	struct nf_conn *ct = NULL;
+	struct nf_conn *ct;
 
 	if (unlikely(!nf_conntrack_hash_rnd_initted)) {
 		get_random_bytes(&nf_conntrack_hash_rnd, 4);
@@ -550,7 +550,7 @@ init_conntrack(struct net *net,
 	}
 
 	ct = nf_conntrack_alloc(net, tuple, &repl_tuple, GFP_ATOMIC);
-	if (ct == NULL || IS_ERR(ct)) {
+	if (IS_ERR(ct)) {
 		pr_debug("Can't allocate conntrack.\n");
 		return (struct nf_conntrack_tuple_hash *)ct;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5f4a651..37d6b9c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1091,7 +1091,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	struct nf_conntrack_helper *helper;
 
 	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_ATOMIC);
-	if (ct == NULL || IS_ERR(ct))
+	if (IS_ERR(ct))
 		return -ENOMEM;
 
 	if (!cda[CTA_TIMEOUT])
