Return-Path: <linux-kernel-owner+w=401wt.eu-S932368Ab0ANXwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0ANXwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094Ab0ANXwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:52:42 -0500
Received: from [206.15.93.42] ([206.15.93.42]:14347 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756453Ab0ANXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:52:42 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net/ipv4/fib_semantics.c: quiet sparse "shadows" noise
Date: Thu, 14 Jan 2010 16:52:41 -0700
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141652.42757.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/ipv4/fib_semantics.c: quiet sparse "shadows" noise

If CONFIG_IP_ROUTE_MULTIPATH is defined the symbol 'nh' is
declared twice in the function fib_sync_down_dev. First as the
loop variable used to iterate the hlist. Then again due to the
change_nexthops macro. This produces a sparse warning and
makes the code harder to understand.

Fix the issue by renaming the first symbol.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>

---

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ed19aa6..cec97f0 100644
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
