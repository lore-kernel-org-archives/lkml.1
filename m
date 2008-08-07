Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYHGDYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYHGDYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYHGDXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:23:35 -0400
Received: from ex2.resilience.com ([207.47.19.10]:38525 "EHLO
	ex2.resilience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYHGDXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:23:34 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 23:23:34 EDT
From: "Xiaoming.Zhang" <Xiaoming.Zhang@resilience.com>
To: shemminger@linux-foundation.org
Subject: [PATCH] driver/net/skge.c: Restart the interface when it's options or pauseparam is set
Date: Thu, 7 Aug 2008 11:02:52 +0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Eric Brower <eric.brower@resilience.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071102.52415.Xiaoming.Zhang@resilience.com>
X-OriginalArrivalTime: 07 Aug 2008 03:08:11.0143 (UTC) FILETIME=[D2F9B170:01C8F83A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have an issue of the skge driver: The card won't work when it's options are
changed. That's the hardware info:
# lspci -v
05:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit Ethernet Controller (rev 13)
        Subsystem: Marvell Technology Group Ltd. Marvell RDK-8001
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
        Memory at d042c000 (32-bit, non-prefetchable) [size=16K]
        I/O ports at d000 [size=256]
        [virtual] Expansion ROM at 20400000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data

The happens in both Linux-2.6.26(skge version 1.23) and RHEL5.2(skge version 1.6).


For example, at first it is set to "speed 1000 duplex full auto-neg on" and
it works, then run 
       ethtool -s <ethx> autoneg off
or     ethtool -s <ethx> speed 100 duplex full autoneg off

Then it will stop working. After that if we restart the interface:
	ifconifg <ethx> down
	ifconfig <ethx> up
It will work again. And `ethtool -A' has the same issue.

So we think after setting the options, the interface should be restarted.
That's the patch, thank you.


skge: Restart the interface when it's options or pauseparam is set.

Signed-off-by: Zhang Xiaoming <xiaoming.zhang@resilience.com>
---
diff -uprN linux-2.6.26/drivers/net/skge.c.orig linux-2.6.26/drivers/net/skge.c
--- linux-2.6.26/drivers/net/skge.c.orig        2008-08-07 01:26:34.000000000 +0800
+++ linux-2.6.26/drivers/net/skge.c     2008-08-07 01:29:31.000000000 +0800
@@ -367,8 +367,10 @@ static int skge_set_settings(struct net_
        skge->autoneg = ecmd->autoneg;
        skge->advertising = ecmd->advertising;

-       if (netif_running(dev))
-               skge_phy_reset(skge);
+       if (netif_running(dev)) {
+               skge_down(dev);
+               skge_up(dev);
+       }

        return (0);
 }
@@ -609,8 +611,10 @@ static int skge_set_pauseparam(struct ne
                        skge->flow_control = FLOW_MODE_NONE;
        }

-       if (netif_running(dev))
-               skge_phy_reset(skge);
+       if (netif_running(dev)) {
+               skge_down(dev);
+               skge_up(dev);
+       }

        return 0;
 }



-- 
Have fun,
Xiaoming (Mark) Zhang

