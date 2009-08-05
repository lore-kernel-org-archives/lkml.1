Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbZHEAgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbZHEAgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933844AbZHEAga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:36:30 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:17037 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933309AbZHEAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:36:29 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/ipv4/fib_semantics.c: fix "symbol shadows an earlier one" noise
Date: Tue, 4 Aug 2009 17:36:34 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041736.34604.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fib_sync_down_dev() uses a variable named 'nh' when doing a
hlist_for_each_entry loop.  Later the same variable name is used
in a change_nexthops loop.  This results in a sparse warning and is
potentially confusing.  Fix both issues by changing the name of
the outer loop variable.  The sparse warning is:

  warning: symbol 'nh' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 9b096d6..b0e485a 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1065,17 +1065,17 @@ int fib_sync_down_dev(struct net_device *dev, int force)
 	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
 	struct hlist_head *head = &fib_info_devhash[hash];
 	struct hlist_node *node;
-	struct fib_nh *nh;
+	struct fib_nh *this_nh;
 
 	if (force)
 		scope = -1;
 
-	hlist_for_each_entry(nh, node, head, nh_hash) {
-		struct fib_info *fi = nh->nh_parent;
+	hlist_for_each_entry(this_nh, node, head, nh_hash) {
+		struct fib_info *fi = this_nh->nh_parent;
 		int dead;
 
 		BUG_ON(!fi->fib_nhs);
-		if (nh->nh_dev != dev || fi == prev_fi)
+		if (this_nh->nh_dev != dev || fi == prev_fi)
 			continue;
 		prev_fi = fi;
 		dead = 0;
