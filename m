Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYG3LpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYG3LpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYG3LpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:45:06 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37368 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYG3LpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:45:05 -0400
Date: Wed, 30 Jul 2008 13:44:55 +0200 (MEST)
Message-Id: <200807301144.m6UBitOG022822@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: alan@lxorguk.ukuu.org.uk
Subject: [PATCH 2.6.27-rc1]: fix NE2000 linkage error
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build with CONFIG_NE2000=m fails with:

  scripts/mod/modpost   -o /tmp/tmp/linux-2.6.27-rc1/Module.symvers    -S     -s
ERROR: "NS8390_init" [drivers/net/ne.ko] undefined!

This is because the split of 8390 into pausing and non-pausing
versions was incompletely propagated to ne.c. This fixes it.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---

--- linux-2.6.27-rc1/drivers/net/ne.c.~1~	2008-07-29 10:40:11.000000000 +0200
+++ linux-2.6.27-rc1/drivers/net/ne.c	2008-07-30 13:17:16.000000000 +0200
@@ -536,7 +536,7 @@ static int __init ne_probe1(struct net_d
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = eip_poll;
 #endif
-	NS8390_init(dev, 0);
+	NS8390p_init(dev, 0);
 
 	ret = register_netdev(dev);
 	if (ret)
@@ -794,7 +794,7 @@ retry:
 		if (time_after(jiffies, dma_start + 2*HZ/100)) {		/* 20ms */
 			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
 			ne_reset_8390(dev);
-			NS8390_init(dev,1);
+			NS8390p_init(dev, 1);
 			break;
 		}
 
@@ -855,7 +855,7 @@ static int ne_drv_resume(struct platform
 
 	if (netif_running(dev)) {
 		ne_reset_8390(dev);
-		NS8390_init(dev, 1);
+		NS8390p_init(dev, 1);
 		netif_device_attach(dev);
 	}
 	return 0;
