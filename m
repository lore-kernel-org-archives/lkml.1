Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXJMOwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXJMOwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762044AbXJMOmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:49 -0400
Received: from 1wt.eu ([62.212.114.60]:3022 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762007AbXJMOms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:48 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143511.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:53 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 31/35] Fix IPV6 append OOPS.
Content-Disposition: inline; filename=0091-Fix-IPV6-append-OOPS.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit e1f52208bb968291f7d9142eff60b62984b4a511 in mainline.

[IPv6]: Fix NULL pointer dereference in ip6_flush_pending_frames

Some of skbs in sk->write_queue do not have skb->dst because
we do not fill skb->dst when we allocate new skb in append_data().

BTW, I think we may not need to (or we should not) increment some stats
when using corking; if 100 sendmsg() (with MSG_MORE) result in 2 packets,
how many should we increment?

If 100, we should set skb->dst for every queued skbs.

If 1 (or 2 (*)), we increment the stats for the first queued skb and
we should just skip incrementing OutDiscards for the rest of queued skbs,
adn we should also impelement this semantics in other places;
e.g., we should increment other stats just once, not 100 times.

*: depends on the place we are discarding the datagram.

I guess should just increment by 1 (or 2).

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/ip6_output.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

Index: 2.6/net/ipv6/ip6_output.c
===================================================================
--- 2.6.orig/net/ipv6/ip6_output.c
+++ 2.6/net/ipv6/ip6_output.c
@@ -1357,8 +1357,9 @@ void ip6_flush_pending_frames(struct soc
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue_tail(&sk->sk_write_queue)) != NULL) {
-		IP6_INC_STATS(ip6_dst_idev(skb->dst),
-			      IPSTATS_MIB_OUTDISCARDS);
+		if (skb->dst)
+			IP6_INC_STATS(ip6_dst_idev(skb->dst),
+				      IPSTATS_MIB_OUTDISCARDS);
 		kfree_skb(skb);
 	}
 

-- 
