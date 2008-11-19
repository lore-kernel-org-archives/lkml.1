Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYKSXf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYKSXf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYKSXfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:35:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57654
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751940AbYKSXfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:35:45 -0500
Date: Wed, 19 Nov 2008 15:35:45 -0800 (PST)
Message-Id: <20081119.153545.42955147.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: folkert@vanheusden.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Re: [2.6.26] OOPS in __linkwatch_run_queue (unable to
 handle kernel NULL pointer dereference at 00000235)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117.011509.71878779.davem@davemloft.net>
References: <20081117.005025.141630310.davem@davemloft.net>
	<20081117091108.GB6345@ff.dom.local>
	<20081117.011509.71878779.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 17 Nov 2008 01:15:09 -0800 (PST)

> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Mon, 17 Nov 2008 09:11:08 +0000
> 
> > On Mon, Nov 17, 2008 at 12:50:25AM -0800, David Miller wrote:
> > Yes, this looks very nice! But this should be done in "a few" more
> > drivers, like cxgb3 etc.
> 
> Thanks for pointing that out, I'll fix those cases too.

I did an audit, and found that this construct is too pervasive to
fix right now.  Even e1000 and e1000e do this call of netif_carrier_off()
before the device is even registered.

So here is the bandaid I'll use to fix the bug in 2.6.28

net: Do not fire linkwatch events until the device is registered.

Several device drivers try to do things like netif_carrier_off()
before register_netdev() is invoked.  This is bogus, but too many
drivers do this to fix them all up in one go.

Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/sch_generic.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 93cd30c..cdcd16f 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -270,6 +270,8 @@ static void dev_watchdog_down(struct net_device *dev)
 void netif_carrier_on(struct net_device *dev)
 {
 	if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
+		if (dev->reg_state == NETREG_UNINITIALIZED)
+			return;
 		linkwatch_fire_event(dev);
 		if (netif_running(dev))
 			__netdev_watchdog_up(dev);
@@ -285,8 +287,11 @@ EXPORT_SYMBOL(netif_carrier_on);
  */
 void netif_carrier_off(struct net_device *dev)
 {
-	if (!test_and_set_bit(__LINK_STATE_NOCARRIER, &dev->state))
+	if (!test_and_set_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
+		if (dev->reg_state == NETREG_UNINITIALIZED)
+			return;
 		linkwatch_fire_event(dev);
+	}
 }
 EXPORT_SYMBOL(netif_carrier_off);
 
-- 
1.5.6.5

