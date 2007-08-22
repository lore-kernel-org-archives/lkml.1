Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXHVIxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXHVIxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbXHVIwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:34 -0400
Received: from 1wt.eu ([62.212.114.60]:1894 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbXHVIwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:32 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083944.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:51 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 07/58] Fix ipv6 link down handling.
Content-Disposition: inline; filename=0007-Fix-ipv6-link-down-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[IPV6]: Call inet6addr_chain notifiers on link down

Currently if the link is brought down via ip link or ifconfig down,
the inet6addr_chain notifiers are not called even though all
the addresses are removed from the interface.  This caused SCTP
to add duplicate addresses to it's list.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/addrconf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e383ac8..0d21d96 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2451,6 +2451,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 		write_unlock_bh(&idev->lock);
 
 		__ipv6_ifa_notify(RTM_DELADDR, ifa);
+		atomic_notifier_call_chain(&inet6addr_chain, NETDEV_DOWN, ifa);
 		in6_ifa_put(ifa);
 
 		write_lock_bh(&idev->lock);
-- 
1.5.2.5

-- 
