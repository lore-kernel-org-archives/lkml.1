Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYICRkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYICRkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbYICRj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:39:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:56852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbYICRjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:39:53 -0400
Date: Wed, 3 Sep 2008 10:26:03 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Brian Haley <brian.haley@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/42] netns: Add network namespace argument to
	rt6_fill_node() and ipv6_dev_get_saddr()
Message-ID: <20080903172603.GW7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003-netns-Add-network-namespace-argument-to-rt6_fill_no.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian Haley <brian.haley@hp.com>

[ Upstream commit 191cd582500f49b32a63040fedeebb0168c720af ]

ipv6_dev_get_saddr() blindly de-references dst_dev to get the network
namespace, but some callers might pass NULL.  Change callers to pass a
namespace pointer instead.

Signed-off-by: Brian Haley <brian.haley@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/addrconf.h  |    3 ++-
 include/net/ip6_route.h |    1 +
 net/ipv6/addrconf.c     |    3 +--
 net/ipv6/fib6_rules.c   |    3 ++-
 net/ipv6/ip6_fib.c      |    1 +
 net/ipv6/ip6_output.c   |    2 +-
 net/ipv6/ndisc.c        |    2 +-
 net/ipv6/route.c        |   12 +++++++-----
 net/ipv6/xfrm6_policy.c |    4 +++-
 net/sctp/ipv6.c         |    3 ++-
 10 files changed, 21 insertions(+), 13 deletions(-)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -80,7 +80,8 @@ extern struct inet6_ifaddr      *ipv6_ge
 						 struct net_device *dev,
 						 int strict);
 
-extern int			ipv6_dev_get_saddr(struct net_device *dev, 
+extern int			ipv6_dev_get_saddr(struct net *net,
+					       struct net_device *dev,
 					       const struct in6_addr *daddr,
 					       unsigned int srcprefs,
 					       struct in6_addr *saddr);
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -112,6 +112,7 @@ struct rt6_rtnl_dump_arg
 {
 	struct sk_buff *skb;
 	struct netlink_callback *cb;
+	struct net *net;
 };
 
 extern int rt6_dump_route(struct rt6_info *rt, void *p_arg);
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1076,13 +1076,12 @@ out:
 	return ret;
 }
 
-int ipv6_dev_get_saddr(struct net_device *dst_dev,
+int ipv6_dev_get_saddr(struct net *net, struct net_device *dst_dev,
 		       const struct in6_addr *daddr, unsigned int prefs,
 		       struct in6_addr *saddr)
 {
 	struct ipv6_saddr_score scores[2],
 				*score = &scores[0], *hiscore = &scores[1];
-	struct net *net = dev_net(dst_dev);
 	struct ipv6_saddr_dst dst;
 	struct net_device *dev;
 	int dst_type;
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -93,7 +93,8 @@ static int fib6_rule_action(struct fib_r
 			if (flags & RT6_LOOKUP_F_SRCPREF_COA)
 				srcprefs |= IPV6_PREFER_SRC_COA;
 
-			if (ipv6_dev_get_saddr(ip6_dst_idev(&rt->u.dst)->dev,
+			if (ipv6_dev_get_saddr(net,
+					       ip6_dst_idev(&rt->u.dst)->dev,
 					       &flp->fl6_dst, srcprefs,
 					       &saddr))
 				goto again;
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -380,6 +380,7 @@ static int inet6_dump_fib(struct sk_buff
 
 	arg.skb = skb;
 	arg.cb = cb;
+	arg.net = net;
 	w->args = &arg;
 
 	for (h = s_h; h < FIB_TABLE_HASHSZ; h++, s_e = 0) {
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -925,7 +925,7 @@ static int ip6_dst_lookup_tail(struct so
 		goto out_err_release;
 
 	if (ipv6_addr_any(&fl->fl6_src)) {
-		err = ipv6_dev_get_saddr(ip6_dst_idev(*dst)->dev,
+		err = ipv6_dev_get_saddr(net, ip6_dst_idev(*dst)->dev,
 					 &fl->fl6_dst,
 					 sk ? inet6_sk(sk)->srcprefs : 0,
 					 &fl->fl6_src);
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -549,7 +549,7 @@ static void ndisc_send_na(struct net_dev
 			override = 0;
 		in6_ifa_put(ifp);
 	} else {
-		if (ipv6_dev_get_saddr(dev, daddr,
+		if (ipv6_dev_get_saddr(dev_net(dev), dev, daddr,
 				       inet6_sk(dev_net(dev)->ipv6.ndisc_sk)->srcprefs,
 				       &tmpaddr))
 			return;
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2098,7 +2098,8 @@ static inline size_t rt6_nlmsg_size(void
 	       + nla_total_size(sizeof(struct rta_cacheinfo));
 }
 
-static int rt6_fill_node(struct sk_buff *skb, struct rt6_info *rt,
+static int rt6_fill_node(struct net *net,
+			 struct sk_buff *skb, struct rt6_info *rt,
 			 struct in6_addr *dst, struct in6_addr *src,
 			 int iif, int type, u32 pid, u32 seq,
 			 int prefix, int nowait, unsigned int flags)
@@ -2181,7 +2182,7 @@ static int rt6_fill_node(struct sk_buff 
 	} else if (dst) {
 		struct inet6_dev *idev = ip6_dst_idev(&rt->u.dst);
 		struct in6_addr saddr_buf;
-		if (ipv6_dev_get_saddr(idev ? idev->dev : NULL,
+		if (ipv6_dev_get_saddr(net, idev ? idev->dev : NULL,
 				       dst, 0, &saddr_buf) == 0)
 			NLA_PUT(skb, RTA_PREFSRC, 16, &saddr_buf);
 	}
@@ -2226,7 +2227,8 @@ int rt6_dump_route(struct rt6_info *rt, 
 	} else
 		prefix = 0;
 
-	return rt6_fill_node(arg->skb, rt, NULL, NULL, 0, RTM_NEWROUTE,
+	return rt6_fill_node(arg->net,
+		     arg->skb, rt, NULL, NULL, 0, RTM_NEWROUTE,
 		     NETLINK_CB(arg->cb->skb).pid, arg->cb->nlh->nlmsg_seq,
 		     prefix, 0, NLM_F_MULTI);
 }
@@ -2292,7 +2294,7 @@ static int inet6_rtm_getroute(struct sk_
 	rt = (struct rt6_info*) ip6_route_output(net, NULL, &fl);
 	skb->dst = &rt->u.dst;
 
-	err = rt6_fill_node(skb, rt, &fl.fl6_dst, &fl.fl6_src, iif,
+	err = rt6_fill_node(net, skb, rt, &fl.fl6_dst, &fl.fl6_src, iif,
 			    RTM_NEWROUTE, NETLINK_CB(in_skb).pid,
 			    nlh->nlmsg_seq, 0, 0, 0);
 	if (err < 0) {
@@ -2319,7 +2321,7 @@ void inet6_rt_notify(int event, struct r
 	if (skb == NULL)
 		goto errout;
 
-	err = rt6_fill_node(skb, rt, NULL, NULL, 0,
+	err = rt6_fill_node(net, skb, rt, NULL, NULL, 0,
 				event, info->pid, seq, 0, 0, 0);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -52,12 +52,14 @@ static struct dst_entry *xfrm6_dst_looku
 static int xfrm6_get_saddr(xfrm_address_t *saddr, xfrm_address_t *daddr)
 {
 	struct dst_entry *dst;
+	struct net_device *dev;
 
 	dst = xfrm6_dst_lookup(0, NULL, daddr);
 	if (IS_ERR(dst))
 		return -EHOSTUNREACH;
 
-	ipv6_dev_get_saddr(ip6_dst_idev(dst)->dev,
+	dev = ip6_dst_idev(dst)->dev;
+	ipv6_dev_get_saddr(dev_net(dev), dev,
 			   (struct in6_addr *)&daddr->a6, 0,
 			   (struct in6_addr *)&saddr->a6);
 	dst_release(dst);
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -317,7 +317,8 @@ static void sctp_v6_get_saddr(struct sct
 			  __func__, asoc, dst, NIP6(daddr->v6.sin6_addr));
 
 	if (!asoc) {
-		ipv6_dev_get_saddr(dst ? ip6_dst_idev(dst)->dev : NULL,
+		ipv6_dev_get_saddr(sock_net(sctp_opt2sk(sk)),
+				   dst ? ip6_dst_idev(dst)->dev : NULL,
 				   &daddr->v6.sin6_addr,
 				   inet6_sk(&sk->inet.sk)->srcprefs,
 				   &saddr->v6.sin6_addr);

-- 
