Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZLGARo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZLGARo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbZLGARk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:17:40 -0500
Received: from kroah.org ([198.145.64.141]:34719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758611AbZLGAN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:58 2009
Message-Id: <20091207000658.781274324@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [103/119] netfilter: xt_connlimit: fix regression caused by zero family value
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-xt_connlimit-fix-regression-caused-by-zero-family-value.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Engelhardt <jengelh@medozas.de>

commit 539054a8fa5141c9a4e9ac6a86d249e3f2bdef45 upstream.

Commit v2.6.28-rc1~717^2~109^2~2 was slightly incomplete; not all
instances of par->match->family were changed to par->family.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=610
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_connlimit.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -103,7 +103,7 @@ static int count_them(struct xt_connlimi
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
-		      const struct xt_match *match)
+		      u_int8_t family)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
@@ -113,8 +113,7 @@ static int count_them(struct xt_connlimi
 	bool addit = true;
 	int matches = 0;
 
-
-	if (match->family == NFPROTO_IPV6)
+	if (family == NFPROTO_IPV6)
 		hash = &data->iphash[connlimit_iphash6(addr, mask)];
 	else
 		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
@@ -157,8 +156,7 @@ static int count_them(struct xt_connlimi
 			continue;
 		}
 
-		if (same_source_net(addr, mask, &conn->tuple.src.u3,
-		    match->family))
+		if (same_source_net(addr, mask, &conn->tuple.src.u3, family))
 			/* same source network -> be counted! */
 			++matches;
 		nf_ct_put(found_ct);
@@ -207,7 +205,7 @@ connlimit_mt(const struct sk_buff *skb, 
 
 	spin_lock_bh(&info->data->lock);
 	connections = count_them(info->data, tuple_ptr, &addr,
-	                         &info->mask, par->match);
+	                         &info->mask, par->family);
 	spin_unlock_bh(&info->data->lock);
 
 	if (connections < 0) {


