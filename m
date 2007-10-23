Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbXJWPxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbXJWPxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXJWPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:53:28 -0400
Received: from flpi185.sbcis.sbc.com ([207.115.20.187]:42358 "EHLO
	flpi185.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXJWPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:53:26 -0400
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 3/5] NET: Treat the sign of the result of skb_headroom()
	consistently
To: linux-kernel@vger.kernel.org
Cc: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 23 Oct 2007 11:44:23 -0400
Message-ID: <20071023154423.28115.88775.stgit@ingres.1015granger.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In some places, the result of skb_headroom() is compared to an unsigned
integer, and in others, the result is compared to a signed integer.  Make
the comparisons consistent and correct.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <netdev@vger.kernel.org>
---

 include/linux/skbuff.h     |    4 ++--
 net/ipv4/ip_gre.c          |    2 +-
 net/ipv4/ip_output.c       |    2 +-
 net/ipv4/ipip.c            |    2 +-
 net/ipv4/ipvs/ip_vs_xmit.c |    2 +-
 net/ipv4/tcp_input.c       |    2 +-
 net/ipv6/ip6_output.c      |    2 +-
 net/ipv6/ip6_tunnel.c      |    2 +-
 net/ipv6/sit.c             |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 91f0bac..57257d2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -994,7 +994,7 @@ static inline int pskb_may_pull(struct sk_buff *skb, unsigned int len)
  *
  *	Return the number of bytes of free space at the head of an &sk_buff.
  */
-static inline int skb_headroom(const struct sk_buff *skb)
+static inline unsigned int skb_headroom(const struct sk_buff *skb)
 {
 	return skb->data - skb->head;
 }
@@ -1347,7 +1347,7 @@ static inline struct sk_buff *netdev_alloc_skb(struct net_device *dev,
  *	Returns true if modifying the header part of the cloned buffer
  *	does not requires the data to be copied.
  */
-static inline int skb_clone_writable(struct sk_buff *skb, int len)
+static inline int skb_clone_writable(struct sk_buff *skb, unsigned int len)
 {
 	return !skb_header_cloned(skb) &&
 	       skb_headroom(skb) + len <= skb->hdr_len;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f151900..c3568ab 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -674,7 +674,7 @@ static int ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct rtable *rt;     			/* Route to the other host */
 	struct net_device *tdev;			/* Device to other host */
 	struct iphdr  *iph;			/* Our new IP header */
-	int    max_headroom;			/* The extra header space needed */
+	unsigned int max_headroom;		/* The extra header space needed */
 	int    gre_hlen;
 	__be32 dst;
 	int    mtu;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f508835..e5f7dc2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -161,7 +161,7 @@ static inline int ip_finish_output2(struct sk_buff *skb)
 	struct dst_entry *dst = skb->dst;
 	struct rtable *rt = (struct rtable *)dst;
 	struct net_device *dev = dst->dev;
-	int hh_len = LL_RESERVED_SPACE(dev);
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
 
 	if (rt->rt_type == RTN_MULTICAST)
 		IP_INC_STATS(IPSTATS_MIB_OUTMCASTPKTS);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 5cd5bbe..8c2b2b0 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -515,7 +515,7 @@ static int ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct net_device *tdev;			/* Device to other host */
 	struct iphdr  *old_iph = ip_hdr(skb);
 	struct iphdr  *iph;			/* Our new IP header */
-	int    max_headroom;			/* The extra header space needed */
+	unsigned int max_headroom;		/* The extra header space needed */
 	__be32 dst = tiph->daddr;
 	int    mtu;
 
diff --git a/net/ipv4/ipvs/ip_vs_xmit.c b/net/ipv4/ipvs/ip_vs_xmit.c
index d0a92de..7c074e3 100644
--- a/net/ipv4/ipvs/ip_vs_xmit.c
+++ b/net/ipv4/ipvs/ip_vs_xmit.c
@@ -325,7 +325,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	__be16 df = old_iph->frag_off;
 	sk_buff_data_t old_transport_header = skb->transport_header;
 	struct iphdr  *iph;			/* Our new IP header */
-	int    max_headroom;			/* The extra header space needed */
+	unsigned int max_headroom;		/* The extra header space needed */
 	int    mtu;
 
 	EnterFunction(10);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9288220..3dbbb44 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3909,7 +3909,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list,
 
 	while (before(start, end)) {
 		struct sk_buff *nskb;
-		int header = skb_headroom(skb);
+		unsigned int header = skb_headroom(skb);
 		int copy = SKB_MAX_ORDER(header, 0);
 
 		/* Too big header? This can happen with IPv6. */
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 13565df..653fc0a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -171,7 +171,7 @@ int ip6_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 	u32 mtu;
 
 	if (opt) {
-		int head_room;
+		unsigned int head_room;
 
 		/* First: exthdrs may take lots of space (~8K for now)
 		   MAX_HEADER is not enough.
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2320cc2..5383b33 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -838,7 +838,7 @@ static int ip6_tnl_xmit2(struct sk_buff *skb,
 	struct dst_entry *dst;
 	struct net_device *tdev;
 	int mtu;
-	int max_headroom = sizeof(struct ipv6hdr);
+	unsigned int max_headroom = sizeof(struct ipv6hdr);
 	u8 proto;
 	int err = -1;
 	int pkt_len;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 466657a..71433d2 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -430,7 +430,7 @@ static int ipip6_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct rtable *rt;     			/* Route to the other host */
 	struct net_device *tdev;			/* Device to other host */
 	struct iphdr  *iph;			/* Our new IP header */
-	int    max_headroom;			/* The extra header space needed */
+	unsigned int max_headroom;		/* The extra header space needed */
 	__be32 dst = tiph->daddr;
 	int    mtu;
 	struct in6_addr *addr6;

