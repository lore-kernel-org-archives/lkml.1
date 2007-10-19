Return-Path: <linux-kernel-owner+w=401wt.eu-S966898AbXJSHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966898AbXJSHdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966838AbXJSHdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:33:32 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53243 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966830AbXJSHda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:33:30 -0400
Date: Fri, 19 Oct 2007 03:33:29 -0400
From: Jeff Garzik <jeff@garzik.org>
To: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib82596, netxen: delete pointless tests from irq handler
Message-ID: <20071019073329.GA5755@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit e96888518af94d9f607b996f8b90873330dbfc32
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 03:14:03 2007 -0400

    [NETDRVR] lib82596, netxen: delete pointless tests from irq handler
    
    Remove always-false tests in irq handler.
    
    Also a few other minor cleanups.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/net/lib82596.c               |    8 +-------
 drivers/net/netxen/netxen_nic_main.c |   11 ++---------
 2 files changed, 3 insertions(+), 16 deletions(-)

e96888518af94d9f607b996f8b90873330dbfc32
diff --git a/drivers/net/lib82596.c b/drivers/net/lib82596.c
index ffaa14f..9a855e5 100644
--- a/drivers/net/lib82596.c
+++ b/drivers/net/lib82596.c
@@ -1124,12 +1124,6 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 	struct i596_dma *dma;
 	unsigned short status, ack_cmd = 0;
 
-	if (dev == NULL) {
-		printk(KERN_WARNING "%s: irq %d for unknown device.\n",
-		       __FUNCTION__, irq);
-		return IRQ_NONE;
-	}
-
 	lp = netdev_priv(dev);
 	dma = lp->dma;
 
@@ -1140,7 +1134,7 @@ static irqreturn_t i596_interrupt(int irq, void *dev_id)
 
 	DEB(DEB_INTS, printk(KERN_DEBUG
 			     "%s: i596 interrupt, IRQ %d, status %4.4x.\n",
-			dev->name, irq, status));
+			dev->name, dev->irq, status));
 
 	ack_cmd = status & 0xf000;
 
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 601051c..a80f0cd 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -1268,17 +1268,10 @@ netxen_handle_int(struct netxen_adapter *adapter, struct net_device *netdev)
  */
 irqreturn_t netxen_intr(int irq, void *data)
 {
-	struct netxen_adapter *adapter;
-	struct net_device *netdev;
+	struct netxen_adapter *adapter = data;
+	struct net_device *netdev = adapter->netdev;
 	u32 our_int = 0;
 
-	if (unlikely(!irq)) {
-		return IRQ_NONE;	/* Not our interrupt */
-	}
-
-	adapter = (struct netxen_adapter *)data;
-	netdev  = adapter->netdev;
-
 	if (!(adapter->flags & NETXEN_NIC_MSI_ENABLED)) {
 		our_int = readl(NETXEN_CRB_NORMALIZE(adapter, CRB_INT_VECTOR));
 		/* not our interrupt */
