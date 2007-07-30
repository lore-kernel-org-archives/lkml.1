Return-Path: <linux-kernel-owner+w=401wt.eu-S938862AbXG3Gam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938862AbXG3Gam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938697AbXG3G3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:29:53 -0400
Received: from rex.snapgear.com ([203.143.235.140]:44881 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S938494AbXG3G3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:29:48 -0400
Date: Mon, 30 Jul 2007 16:29:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707300629.l6U6T9Qi020358@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] fix work queues in FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the work queue code in the FEC driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/drivers/net/fec.c linux/drivers/net/fec.c
--- linux-2.6.23-rc1-git2/drivers/net/fec.c	2007-07-26 10:46:14.000000000 +1000
+++ linux/drivers/net/fec.c	2007-07-26 23:09:23.000000000 +1000
@@ -191,6 +190,8 @@
 	/* Hardware registers of the FEC device */
 	volatile fec_t	*hwp;
 
+	struct net_device *netdev;
+
 	/* The saved address of a sent-in-place packet/buffer, for skfree(). */
 	unsigned char *tx_bounce[TX_RING_SIZE];
 	struct	sk_buff* tx_skbuff[TX_RING_SIZE];
@@ -1940,9 +1964,10 @@
 	printk(".\n");
 }
 
-static void mii_display_config(struct net_device *dev)
+static void mii_display_config(struct work_struct *work)
 {
-	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_private *fep = container_of(work, struct fec_enet_private, phy_task);
+	struct net_device *dev = fep->netdev;
 	uint status = fep->phy_status;
 
 	/*
@@ -1976,9 +2001,10 @@
 	fep->sequence_done = 1;
 }
 
-static void mii_relink(struct net_device *dev)
+static void mii_relink(struct work_struct *work)
 {
-	struct fec_enet_private *fep = netdev_priv(dev);
+	struct fec_enet_private *fep = container_of(work, struct fec_enet_private, phy_task);
+	struct net_device *dev = fep->netdev;
 	int duplex;
 
 	/*
@@ -2022,7 +2048,7 @@
 		return;
 
 	fep->mii_phy_task_queued = 1;
-	INIT_WORK(&fep->phy_task, (void*)mii_relink, dev);
+	INIT_WORK(&fep->phy_task, mii_relink);
 	schedule_work(&fep->phy_task);
 }
 
@@ -2035,7 +2061,7 @@
 		return;
 
 	fep->mii_phy_task_queued = 1;
-	INIT_WORK(&fep->phy_task, (void*)mii_display_config, dev);
+	INIT_WORK(&fep->phy_task, mii_display_config);
 	schedule_work(&fep->phy_task);
 }
 
@@ -2330,6 +2356,7 @@
 
 	fep->index = index;
 	fep->hwp = fecp;
+	fep->netdev = dev;
 
 	/* Whack a reset.  We should wait for this.
 	*/
