Return-Path: <linux-kernel-owner+w=401wt.eu-S1030893AbXCNUIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030893AbXCNUIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030891AbXCNUIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:08:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3948 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030889AbXCNUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:08:40 -0400
Message-Id: <20070314195158.073574000@sirena.org.uk>
References: <20070314194912.414925000@sirena.org.uk>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 19:49:15 +0000
From: broonie@sirena.org.uk
To: Jeff Garzik <jeff@garzik.org>, Tim Hockin <thockin@hockin.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/3] natsemi: Avoid IntrStatus lossage if RX state machine resets.
Content-Disposition: inline; filename=natsemi-fix-poll-ordering
X-Spam-Score: -2.8 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the poll routine for the natsemi driver so that if the
driver detects an RX state machine lockup then no interrupts will be
lost while the driver recovers from that.

Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
Index: linux-2.6/drivers/net/natsemi.c
===================================================================
--- linux-2.6.orig/drivers/net/natsemi.c	2007-03-13 19:38:31.000000000 +0000
+++ linux-2.6/drivers/net/natsemi.c	2007-03-13 19:39:08.000000000 +0000
@@ -2169,6 +2169,14 @@
 			       dev->name, np->intr_status,
 			       readl(ioaddr + IntrMask));
 
+		/* netdev_rx() may read IntrStatus again if the RX state
+		 * machine falls over so do it first. */
+		if (np->intr_status &
+		    (IntrRxDone | IntrRxIntr | RxStatusFIFOOver |
+		     IntrRxErr | IntrRxOverrun)) {
+			netdev_rx(dev, &work_done, work_to_do);
+		}
+
 		if (np->intr_status &
 		    (IntrTxDone | IntrTxIntr | IntrTxIdle | IntrTxErr)) {
 			spin_lock(&np->lock);
@@ -2180,12 +2188,6 @@
 		if (np->intr_status & IntrAbnormalSummary)
 			netdev_error(dev, np->intr_status);
 
-		if (np->intr_status &
-		    (IntrRxDone | IntrRxIntr | RxStatusFIFOOver |
-		     IntrRxErr | IntrRxOverrun)) {
-			netdev_rx(dev, &work_done, work_to_do);
-		}
-
 		*budget -= work_done;
 		dev->quota -= work_done;
 

--
"You grabbed my hand and we fell into it, like a daydream - or a fever."
