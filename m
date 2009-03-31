Return-Path: <linux-kernel-owner+w=401wt.eu-S1764485AbZCaXX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764485AbZCaXX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761255AbZCaXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:30 -0400
Received: from sous-sol.org ([216.99.217.87]:33138 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758874AbZCaXU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:28 -0400
Message-Id: <20090331231358.141644571@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Jesper Nilsson <jesper.nilsson@axis.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 06/45] ipv6: Plug sk_buff leak in ipv6_rcv (net/ipv6/ip6_input.c)
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=ipv6-plug-sk_buff-leak-in-ipv6_rcv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jesper Nilsson <jesper.nilsson@axis.com>

[ Upstream commit 71f6f6dfdf7c7a67462386d9ea05c1095a89c555 ]

Commit 778d80be52699596bf70e0eb0761cf5e1e46088d
(ipv6: Add disable_ipv6 sysctl to disable IPv6 operaion on specific interface)
seems to have introduced a leak of sk_buff's for ipv6 traffic,
at least in some configurations where idev is NULL, or when ipv6
is disabled via sysctl.

The problem is that if the first condition of the if-statement
returns non-NULL, it returns an skb with only one reference,
and when the other conditions apply, execution jumps to the "out"
label, which does not call kfree_skb for it.

To plug this leak, change to use the "drop" label instead.
(this relies on it being ok to call kfree_skb on NULL)
This also allows us to avoid calling rcu_read_unlock here,
and removes the only user of the "out" label.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv6/ip6_input.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -75,8 +75,7 @@ int ipv6_rcv(struct sk_buff *skb, struct
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
 	    !idev || unlikely(idev->cnf.disable_ipv6)) {
 		IP6_INC_STATS_BH(net, idev, IPSTATS_MIB_INDISCARDS);
-		rcu_read_unlock();
-		goto out;
+		goto drop;
 	}
 
 	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
@@ -147,7 +146,6 @@ err:
 drop:
 	rcu_read_unlock();
 	kfree_skb(skb);
-out:
 	return 0;
 }
 

