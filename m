Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbXEUTo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbXEUTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933576AbXEUT1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:27:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52558 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741AbXEUT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:27:53 -0400
Message-Id: <20070521191745.964321000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [patch 48/69] IPV6: Do no rely on skb->dst before it is assigned.
Content-Disposition: inline; filename=ipv6-do-no-rely-on-skb-dst-before-it-is-assigned.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Because skb->dst is assigned in ip6_route_input(), it is really
bad to use it in hop-by-hop option handler(s).

Closes: Bug #8450 (Eric Sesterhenn <snakebyte@gmx.de>)
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv6/exthdrs.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/net/ipv6/exthdrs.c
+++ linux-2.6.21.1/net/ipv6/exthdrs.c
@@ -652,6 +652,14 @@ EXPORT_SYMBOL_GPL(ipv6_invert_rthdr);
   Hop-by-hop options.
  **********************************/
 
+/*
+ * Note: we cannot rely on skb->dst before we assign it in ip6_route_input().
+ */
+static inline struct inet6_dev *ipv6_skb_idev(struct sk_buff *skb)
+{
+	return skb->dst ? ip6_dst_idev(skb->dst) : __in6_dev_get(skb->dev);
+}
+
 /* Router Alert as of RFC 2711 */
 
 static int ipv6_hop_ra(struct sk_buff **skbp, int optoff)
@@ -678,25 +686,25 @@ static int ipv6_hop_jumbo(struct sk_buff
 	if (skb->nh.raw[optoff+1] != 4 || (optoff&3) != 2) {
 		LIMIT_NETDEBUG(KERN_DEBUG "ipv6_hop_jumbo: wrong jumbo opt length/alignment %d\n",
 			       skb->nh.raw[optoff+1]);
-		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst),
+		IP6_INC_STATS_BH(ipv6_skb_idev(skb),
 				 IPSTATS_MIB_INHDRERRORS);
 		goto drop;
 	}
 
 	pkt_len = ntohl(*(__be32*)(skb->nh.raw+optoff+2));
 	if (pkt_len <= IPV6_MAXPLEN) {
-		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst), IPSTATS_MIB_INHDRERRORS);
+		IP6_INC_STATS_BH(ipv6_skb_idev(skb), IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
 		return 0;
 	}
 	if (skb->nh.ipv6h->payload_len) {
-		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst), IPSTATS_MIB_INHDRERRORS);
+		IP6_INC_STATS_BH(ipv6_skb_idev(skb), IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
 		return 0;
 	}
 
 	if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
-		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst), IPSTATS_MIB_INTRUNCATEDPKTS);
+		IP6_INC_STATS_BH(ipv6_skb_idev(skb), IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
 	}
 

-- 
