Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbYCUXsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbYCUXsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYCUXpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:41 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60189 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYCUXp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:28 -0400
Message-Id: <20080321224335.920240276@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:59 -0700
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
       Matti Linnanvuori <mattilinnanvuori@yahoo.com>,
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/76] NET: Fix race in dev_close(). (Bug 9750)
Content-Disposition: inline; filename=net-fix-race-in-dev_close.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Upstream commit: d8b2a4d21e0b37b9669b202867bfef19f68f786a

There is a race in Linux kernel file net/core/dev.c, function dev_close.
The function calls function dev_deactivate, which calls function
dev_watchdog_down that deletes the watchdog timer. However, after that, a
driver can call netif_carrier_ok, which calls function
__netdev_watchdog_up that can add the watchdog timer again. Function
unregister_netdevice calls function dev_shutdown that traps the bug
!timer_pending(&dev->watchdog_timer). Moving dev_deactivate after
netif_running() has been cleared prevents function netif_carrier_on
from calling __netdev_watchdog_up and adding the watchdog timer again.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1068,8 +1068,6 @@ int dev_close(struct net_device *dev)
 	 */
 	call_netdevice_notifiers(NETDEV_GOING_DOWN, dev);
 
-	dev_deactivate(dev);
-
 	clear_bit(__LINK_STATE_START, &dev->state);
 
 	/* Synchronize to scheduled poll. We cannot touch poll list,
@@ -1080,6 +1078,8 @@ int dev_close(struct net_device *dev)
 	 */
 	smp_mb__after_clear_bit(); /* Commit netif_running(). */
 
+	dev_deactivate(dev);
+
 	/*
 	 *	Call the device specific close. This cannot fail.
 	 *	Only if device is UP

-- 
