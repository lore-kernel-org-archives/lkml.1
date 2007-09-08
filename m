Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXIHTl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXIHTl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 15:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXIHTls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 15:41:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbXIHTls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 15:41:48 -0400
Date: Sat, 8 Sep 2007 19:41:40 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.20.19
Message-ID: <20070908194140.GA24824@hera.kernel.org>
References: <20070908194105.GA24334@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908194105.GA24334@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 48daec7..6bb9f2e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .18
+EXTRAVERSION = .19
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index de96e1a..82a3444 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -653,6 +653,14 @@ EXPORT_SYMBOL_GPL(ipv6_invert_rthdr);
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
@@ -679,25 +687,25 @@ static int ipv6_hop_jumbo(struct sk_buff **skbp, int optoff)
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
 
