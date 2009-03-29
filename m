Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZC2MAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZC2MAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZC2MAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:00:05 -0400
Received: from mail.us.es ([193.147.175.20]:42827 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756553AbZC2MAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:00:00 -0400
Message-ID: <49CF62A2.6050803@netfilter.org>
Date: Sun, 29 Mar 2009 13:59:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gorcunov@gmail.com, randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
References: <20090328102852.GA7697@localhost>	<49CEF882.5000005@oracle.com>	<20090329064704.GA7255@localhost> <20090328.234739.26481917.davem@davemloft.net>
In-Reply-To: <20090328.234739.26481917.davem@davemloft.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------030407000400070201090800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030407000400070201090800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Date: Sun, 29 Mar 2009 10:47:04 +0400
> 
>> [Randy Dunlap - Sat, Mar 28, 2009 at 09:26:42PM -0700]
>> ... 
>> | works_for_me.  Thanks.
>> | but missing S-O-B.
>> | 
>> | Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ...
>>
>> Thanks for testing Randy. So if nobody will complain
>> here is a solid version of the patch. Though I would like
>> if Pablo or Patrick confirm its correctness. Thanks!
> 
> I'll apply this once Patrick or Pablo have a look at it.

I think that the patch attached is better since it removes the overhead
of the IPv6 dependency, which is indeed too much for the use of one
function. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------030407000400070201090800
Content-Type: text/x-diff;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.patch"

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
---

 net/netfilter/xt_cluster.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index ad5bd89..f2d2482 100644
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

--------------030407000400070201090800--
