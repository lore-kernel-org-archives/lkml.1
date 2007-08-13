Return-Path: <linux-kernel-owner+w=401wt.eu-S1764945AbXHMNac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764945AbXHMNac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939343AbXHMJcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:32:48 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:40099 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971176AbXHMJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:32:43 -0400
Subject: cli/sti cleanup in drivers/net/cris/eth_v10.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: starvik@axis.com
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 15:02:14 +0530
Message-Id: <1186997534.3175.21.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 09:33:00.0069 (UTC) FILETIME=[F0563550:01C7DD8C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Removed the cli/sti reference in eth_v10.c and updated it with 
proper spinlock code.



Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
--- 

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 5bdf5ca..d1f7225 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -642,6 +642,7 @@ e100_set_mac_address(struct net_device *dev, void *p)
 static int
 e100_open(struct net_device *dev)
 {
+	struct net_local *np = (struct net_local *)dev->priv;
 	unsigned long flags;
 
 	/* enable the MDIO output pin */
@@ -723,9 +724,7 @@ e100_open(struct net_device *dev)
 	SETS(network_tr_ctrl_shadow, R_NETWORK_TR_CTRL, crc, enable);
 	*R_NETWORK_TR_CTRL = network_tr_ctrl_shadow;
 
-	save_flags(flags);
-	cli();
-
+	spin_lock_irqsave(&np->lock, flags);
 	/* enable the irq's for ethernet DMA */
 
 	*R_IRQ_MASK2_SET =
@@ -757,7 +756,7 @@ e100_open(struct net_device *dev)
 	*R_DMA_CH0_FIRST = 0;
 	*R_DMA_CH0_DESCR = virt_to_phys(myLastTxDesc);
 
-	restore_flags(flags);
+	spin_unlock_irqrestore(&np->lock, flags);
 
 	/* Probe for transceiver */
 	if (e100_probe_transceiver(dev))

--
thanks
surya.

