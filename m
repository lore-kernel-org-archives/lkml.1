Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbXJBKpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbXJBKpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXJBKpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:45:04 -0400
Received: from david.siemens.de ([192.35.17.14]:17190 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbXJBKpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:45:01 -0400
X-Greylist: delayed 2779 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 06:45:01 EDT
Subject: [PATCH] Fallback to ipv4 if we try to add join IPv4 multicast
	group via ipv4-mapped address.
From: Dmitry Baryshkov <Dmitry.Baryshkov@siemens.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain
Date: Tue, 02 Oct 2007 13:59:42 +0400
Message-Id: <1191319182.28331.6.camel@doriath.ww600.siemens.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index ae98818..c70a87d 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -38,6 +38,7 @@
 #include <linux/times.h>
 #include <linux/net.h>
 #include <linux/in.h>
+#include <linux/igmp.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
@@ -183,6 +184,17 @@ int ipv6_sock_mc_join(struct sock *sk, int ifindex, struct in6_addr *addr)
 	struct ipv6_mc_socklist *mc_lst;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	int err;
+	int addr_type = ipv6_addr_type(addr);
+
+	if (addr_type == IPV6_ADDR_MAPPED) {
+		__be32 v4addr = addr->s6_addr32[3];
+		struct ip_mreqn mreq;
+		mreq.imr_multiaddr.s_addr = v4addr;
+		mreq.imr_address.s_addr = INADDR_ANY;
+		mreq.imr_ifindex = ifindex;
+
+		return ip_mc_join_group(sk, &mreq);
+	}
 
 	if (!ipv6_addr_is_multicast(addr))
 		return -EINVAL;
@@ -256,6 +268,18 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, struct in6_addr *addr)
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct ipv6_mc_socklist *mc_lst, **lnk;
 
+	int addr_type = ipv6_addr_type(addr);
+
+	if (addr_type == IPV6_ADDR_MAPPED) {
+		__be32 v4addr = addr->s6_addr32[3];
+		struct ip_mreqn mreq;
+		mreq.imr_multiaddr.s_addr = v4addr;
+		mreq.imr_address.s_addr = INADDR_ANY;
+		mreq.imr_ifindex = ifindex;
+
+		return ip_mc_leave_group(sk, &mreq);
+	}
+
 	write_lock_bh(&ipv6_sk_mc_lock);
 	for (lnk = &np->ipv6_mc_list; (mc_lst = *lnk) !=NULL ; lnk = &mc_lst->next) {
 		if ((ifindex == 0 || mc_lst->ifindex == ifindex) &&

