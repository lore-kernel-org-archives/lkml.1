Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbXJXVwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbXJXVwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbXJXVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:52:39 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46354 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223AbXJXVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:52:38 -0400
Date: Wed, 24 Oct 2007 23:46:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Volker Sauer <vsauer@dvs.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org, adi@postpi.com,
       Jesse Huang <jesse@icplus.com.tw>
Subject: Re: D-Link DFE-580TX and snmpd problems, who's maintainer of
	sundance.c ?
Message-ID: <20071024214650.GA6253@electric-eye.fr.zoreil.com>
References: <20071024171129.GA14255@volker-sauer.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20071024171129.GA14255@volker-sauer.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Volker Sauer <vsauer@dvs.tu-darmstadt.de> :
[...]
> I'm neither a skilled C-programmer nor a kernel-expert, but looking at
> drivers/net/sundance.c:1605 I see, that SIOCDEVPRIVATE does
> nothing else then printing this debug message.

Yuck.

> So the questions is: why? What is this good for?
> And: can I remove it? I can not abandon snmpd and the messages spam my
> syslog.
> Or: do I have to patch snmpd?

Please try the attached patch.

[...]
> P.S.: there's no one in the MAINTAINERS file for sundance.c. Is someone
> here who still cares about this driver?

Please Cc: netdev@vger.kernel.org on further replies, thanks.

-- 
Ueimor

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-sundance-SIOCDEVPRIVATE-pollution.patch"

>From 27ad88dda586b28327e2e1e95e3a46986d30e0c7 Mon Sep 17 00:00:00 2001
From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 24 Oct 2007 23:35:51 +0200
Subject: [PATCH] sundance: SIOCDEVPRIVATE pollution

To quote one of my favorite contemporary author:
[include/linux/sockios.h]
 *      THESE IOCTLS ARE _DEPRECATED_ AND WILL DISAPPEAR IN 2.5.X -DaveM
 */

#define SIOCDEVPRIVATE  0x89F0  /* to 89FF */

[...]

Gentoo's snmpd trips up over this code when trying to figure if the
driver supports the non-SIOCDEVPRIVATE API or not. One can argue over
its choice of heuristic but there no reason to make ioctl more ugly
than needed.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jesse Huang <jesse@icplus.com.tw>
Tester-Cc: Volker Sauer <vsauer@dvs.tu-darmstadt.de>
---
 drivers/net/sundance.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index ff98f5d..f12e727 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -1596,9 +1596,7 @@ static const struct ethtool_ops ethtool_ops = {
 static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	void __iomem *ioaddr = np->base;
 	int rc;
-	int i;
 
 	if (!netif_running(dev))
 		return -EINVAL;
@@ -1606,30 +1604,6 @@ static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	spin_lock_irq(&np->lock);
 	rc = generic_mii_ioctl(&np->mii_if, if_mii(rq), cmd, NULL);
 	spin_unlock_irq(&np->lock);
-	switch (cmd) {
-		case SIOCDEVPRIVATE:
-		for (i=0; i<TX_RING_SIZE; i++) {
-			printk(KERN_DEBUG "%02x %08llx %08x %08x(%02x) %08x %08x\n", i,
-				(unsigned long long)(np->tx_ring_dma + i*sizeof(*np->tx_ring)),
-				le32_to_cpu(np->tx_ring[i].next_desc),
-				le32_to_cpu(np->tx_ring[i].status),
-				(le32_to_cpu(np->tx_ring[i].status) >> 2)
-					& 0xff,
-				le32_to_cpu(np->tx_ring[i].frag[0].addr),
-				le32_to_cpu(np->tx_ring[i].frag[0].length));
-		}
-		printk(KERN_DEBUG "TxListPtr=%08x netif_queue_stopped=%d\n",
-			ioread32(np->base + TxListPtr),
-			netif_queue_stopped(dev));
-		printk(KERN_DEBUG "cur_tx=%d(%02x) dirty_tx=%d(%02x)\n",
-			np->cur_tx, np->cur_tx % TX_RING_SIZE,
-			np->dirty_tx, np->dirty_tx % TX_RING_SIZE);
-		printk(KERN_DEBUG "cur_rx=%d dirty_rx=%d\n", np->cur_rx, np->dirty_rx);
-		printk(KERN_DEBUG "cur_task=%d\n", np->cur_task);
-		printk(KERN_DEBUG "TxStatus=%04x\n", ioread16(ioaddr + TxStatus));
-			return 0;
-	}
-
 
 	return rc;
 }
-- 
1.5.2.4


--Kj7319i9nmIyA2yE--
