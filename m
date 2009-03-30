Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbZC3U7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbZC3U7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZC3U6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:58:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbZC3U6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:58:53 -0400
Date: Mon, 30 Mar 2009 13:58:42 -0700 (PDT)
Message-Id: <20090330.135842.184291063.davem@davemloft.net>
To: nix.or.die@googlemail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Compile error in net/netfilter/xt_cluster.ko with current git
From: David Miller <davem@davemloft.net>
In-Reply-To: <49D087E9.4000004@googlemail.com>
References: <49D087E9.4000004@googlemail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel C <nix.or.die@googlemail.com>
Date: Mon, 30 Mar 2009 10:50:49 +0200

> Hello ,
> 
> on 2.6.29-5102-g0d34fb8 I get the following compile error :
> 
> ERROR: "__ipv6_addr_type" [net/netfilter/xt_cluster.ko] undefined!
> 
> with the following config :

known problem with fix pending:

netfilter: xtables: fix IPv6 dependency in the cluster match

This patch fixes a dependency with IPv6:

ERROR: "__ipv6_addr_type" [net/netfilter/xt_cluster.ko] undefined!

This patch adds a function that checks if the higher bits of the
address is 0xFF to identify a multicast address, instead of adding a
dependency due to __ipv6_addr_type(). I came up with this idea after
Patrick McHardy pointed possible problems with runtime module
dependencies.

Reported-by: Steven Noonan <steven@uplinklabs.net>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/netfilter/xt_cluster.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index ad5bd89..6c48476 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -58,6 +58,13 @@ xt_cluster_hash(const struct nf_conn *ct,
 }
 
 static inline bool
+xt_cluster_ipv6_is_multicast(const struct in6_addr *addr)
+{
+	__be32 st = addr->s6_addr32[0];
+	return ((st & htonl(0xFF000000)) == htonl(0xFF000000));
+}
+
+static inline bool
 xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 {
 	bool is_multicast = false;
@@ -67,8 +74,8 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 		is_multicast = ipv4_is_multicast(ip_hdr(skb)->daddr);
 		break;
 	case NFPROTO_IPV6:
-		is_multicast = ipv6_addr_type(&ipv6_hdr(skb)->daddr) &
-						IPV6_ADDR_MULTICAST;
+		is_multicast =
+			xt_cluster_ipv6_is_multicast(&ipv6_hdr(skb)->daddr);
 		break;
 	default:
 		WARN_ON(1);
-- 
1.6.2.1.222.g570cc

