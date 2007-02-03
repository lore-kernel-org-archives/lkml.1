Return-Path: <linux-kernel-owner+w=401wt.eu-S1946250AbXBCCzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946250AbXBCCzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946246AbXBCCgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:20 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52704 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946245AbXBCCgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:00 -0500
Message-Id: <20070203024023.249180000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:22 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       gernoth@informatik.uni-erlangen.de
Subject: [patch 18/59] IPV6 MCAST: Fix joining all-node multicast group on device initialization.
Content-Disposition: inline; filename=ipv6-mcast-fix-joining-all-node-multicast-group-on-device-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Join all-node multicast group after assignment of dev->ip6_ptr
because it must be assigned when ipv6_dev_mc_inc() is called.
This fixes Bug#7817, reported by <gernoth@informatik.uni-erlangen.de>.

Closes: 7817
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv6/addrconf.c |    6 ++++++
 net/ipv6/mcast.c    |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.19.2.orig/net/ipv6/addrconf.c
+++ linux-2.6.19.2/net/ipv6/addrconf.c
@@ -341,6 +341,7 @@ void in6_dev_finish_destroy(struct inet6
 static struct inet6_dev * ipv6_add_dev(struct net_device *dev)
 {
 	struct inet6_dev *ndev;
+	struct in6_addr maddr;
 
 	ASSERT_RTNL();
 
@@ -425,6 +426,11 @@ static struct inet6_dev * ipv6_add_dev(s
 #endif
 	/* protected by rtnl_lock */
 	rcu_assign_pointer(dev->ip6_ptr, ndev);
+
+	/* Join all-node multicast group */
+	ipv6_addr_all_nodes(&maddr);
+	ipv6_dev_mc_inc(dev, &maddr);
+
 	return ndev;
 }
 
--- linux-2.6.19.2.orig/net/ipv6/mcast.c
+++ linux-2.6.19.2/net/ipv6/mcast.c
@@ -2252,8 +2252,6 @@ void ipv6_mc_up(struct inet6_dev *idev)
 
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
-	struct in6_addr maddr;
-
 	write_lock_bh(&idev->lock);
 	rwlock_init(&idev->mc_lock);
 	idev->mc_gq_running = 0;
@@ -2269,10 +2267,6 @@ void ipv6_mc_init_dev(struct inet6_dev *
 	idev->mc_maxdelay = IGMP6_UNSOLICITED_IVAL;
 	idev->mc_v1_seen = 0;
 	write_unlock_bh(&idev->lock);
-
-	/* Add all-nodes address. */
-	ipv6_addr_all_nodes(&maddr);
-	ipv6_dev_mc_inc(idev->dev, &maddr);
 }
 
 /*

--
