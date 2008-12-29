Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYL2USV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYL2USV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYL2USJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:18:09 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:31511 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYL2USI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:18:08 -0500
X-IronPort-AV: E=Sophos;i="4.36,297,1228089600"; 
   d="scan'208";a="123433527"
From: Roland Dreier <rdreier@cisco.com>
To: Aleksey Senin <alekseys@voltaire.com>
Cc: "general\@lists.openfabrics.org" <general@lists.openfabrics.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<ada4p0nve4r.fsf@cisco.com> <1230544737.4261.33.camel@alst60>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 29 Dec 2008 12:18:06 -0800
In-Reply-To: <1230544737.4261.33.camel@alst60> (Aleksey Senin's message of
	"Mon, 29 Dec 2008 11:58:57 +0200")
Message-ID: <adaljtyu45d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Dec 2008 20:18:07.0258 (UTC) FILETIME=[8FD087A0:01C969F2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something like the following maybe?  (This turns off the RDMA CM if
INFINIBAND=y and IPV6=m -- another possibility would be to just turn off
RDMA CM IPv6 support in the case that IB is build-in but IPv6 is
modular, but that seems like a worse idea overall)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index a5dc78a..538a0ba 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -36,7 +36,7 @@ config INFINIBAND_USER_MEM
 
 config INFINIBAND_ADDR_TRANS
 	bool
-	depends on INET
+	depends on INET && !(INFINIBAND = y && IPV6 = m)
 	default y
 
 source "drivers/infiniband/hw/mthca/Kconfig"
diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index d98b05b..ec7abb5 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -128,6 +128,7 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 		ret = rdma_copy_addr(dev_addr, dev, NULL);
 		dev_put(dev);
 		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6:
 		for_each_netdev(&init_net, dev) {
 			if (ipv6_chk_addr(&init_net,
@@ -138,6 +139,7 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 			}
 		}
 		break;
+#endif
 	default:
 		break;
 	}
@@ -179,10 +181,11 @@ static void addr_send_arp(struct sockaddr *dst_in)
 {
 	struct rtable *rt;
 	struct flowi fl;
-	struct dst_entry *dst;
 
 	memset(&fl, 0, sizeof fl);
-	if (dst_in->sa_family == AF_INET)  {
+
+	switch (dst_in->sa_family) {
+	case AF_INET:
 		fl.nl_u.ip4_u.daddr =
 			((struct sockaddr_in *) dst_in)->sin_addr.s_addr;
 
@@ -191,8 +194,13 @@ static void addr_send_arp(struct sockaddr *dst_in)
 
 		neigh_event_send(rt->u.dst.neighbour, NULL);
 		ip_rt_put(rt);
+		break;
+
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+	{
+		struct dst_entry *dst;
 
-	} else {
 		fl.nl_u.ip6_u.daddr =
 			((struct sockaddr_in6 *) dst_in)->sin6_addr;
 
@@ -202,6 +210,9 @@ static void addr_send_arp(struct sockaddr *dst_in)
 
 		neigh_event_send(dst->neighbour, NULL);
 		dst_release(dst);
+		break;
+	}
+#endif
 	}
 }
 
@@ -254,6 +265,7 @@ out:
 	return ret;
 }
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 			       struct sockaddr_in6 *dst_in,
 			       struct rdma_dev_addr *addr)
@@ -282,6 +294,14 @@ static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
 	dst_release(dst);
 	return ret;
 }
+#else
+static int addr6_resolve_remote(struct sockaddr_in6 *src_in,
+			       struct sockaddr_in6 *dst_in,
+			       struct rdma_dev_addr *addr)
+{
+	return -EADDRNOTAVAIL;
+}
+#endif
 
 static int addr_resolve_remote(struct sockaddr *src_in,
 				struct sockaddr *dst_in,
@@ -340,7 +360,9 @@ static int addr_resolve_local(struct sockaddr *src_in,
 	struct net_device *dev;
 	int ret;
 
-	if (dst_in->sa_family == AF_INET) {
+	switch (dst_in->sa_family) {
+	case AF_INET:
+	{
 		__be32 src_ip = ((struct sockaddr_in *) src_in)->sin_addr.s_addr;
 		__be32 dst_ip = ((struct sockaddr_in *) dst_in)->sin_addr.s_addr;
 
@@ -362,7 +384,12 @@ static int addr_resolve_local(struct sockaddr *src_in,
 				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
 		}
 		dev_put(dev);
-	} else {
+		break;
+	}
+
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+	{
 		struct in6_addr *a;
 
 		for_each_netdev(&init_net, dev)
@@ -390,6 +417,13 @@ static int addr_resolve_local(struct sockaddr *src_in,
 			if (!ret)
 				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
 		}
+		break;
+	}
+#endif
+
+	default:
+		ret = -EADDRNOTAVAIL;
+		break;
 	}
 
 	return ret;
