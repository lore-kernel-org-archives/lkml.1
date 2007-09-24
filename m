Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbXIXQjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbXIXQjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbXIXQ1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58039 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760673AbXIXQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:48 -0400
Date: Mon, 24 Sep 2007 09:22:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [38/50] Fix IPV6 append OOPS.
Message-ID: <20070924162210.GM13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-append-oops.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

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
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1423,8 +1423,9 @@ void ip6_flush_pending_frames(struct soc
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
