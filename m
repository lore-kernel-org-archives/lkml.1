Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYDQBOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYDQBOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbYDQBHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:32 -0400
Received: from sous-sol.org ([216.99.217.87]:58851 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbYDQBHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:30 -0400
Message-Id: <20080417010347.660452049@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, David S Miller <davem@davemloft.net>
Subject: NET: Fix multicast device ioctl checks
Content-Disposition: inline; filename=net-fix-multicast-device-ioctl-checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

Upstream commit: 61ee6bd487b9cc160e533034eb338f2085dc7922

SIOCADDMULTI/SIOCDELMULTI check whether the driver has a set_multicast_list
method to determine whether it supports multicast. Drivers implementing
secondary unicast support use set_rx_mode however.

Check for both dev->set_multicast_mode and dev->set_rx_mode to determine
multicast capabilities.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3240,7 +3240,7 @@ static int dev_ifsioc(struct net *net, s
 			return -EOPNOTSUPP;
 
 		case SIOCADDMULTI:
-			if (!dev->set_multicast_list ||
+			if ((!dev->set_multicast_list && !dev->set_rx_mode) ||
 			    ifr->ifr_hwaddr.sa_family != AF_UNSPEC)
 				return -EINVAL;
 			if (!netif_device_present(dev))
@@ -3249,7 +3249,7 @@ static int dev_ifsioc(struct net *net, s
 					  dev->addr_len, 1);
 
 		case SIOCDELMULTI:
-			if (!dev->set_multicast_list ||
+			if ((!dev->set_multicast_list && !dev->set_rx_mode) ||
 			    ifr->ifr_hwaddr.sa_family != AF_UNSPEC)
 				return -EINVAL;
 			if (!netif_device_present(dev))

-- 
