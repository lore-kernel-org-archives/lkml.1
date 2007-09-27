Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXI0RC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXI0RC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbXI0RCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:02:20 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:35344 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbXI0RCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:02:19 -0400
Date: Thu, 27 Sep 2007 13:01:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - Correctly handle skb allocation failures
Message-ID: <20070927170126.GA6542@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle memory allocation failures when reading packets.

We have to read something from the host, even if we can't allocate any
memory.  If we don't, the host side of the device may fill up and stop
delivering interrupts because no new packets can be queued.

A single sk_buff is allocated whenever an MTU is seen which is larger
than any seen earlier.  This is used to read packets if there is a
memory allocation failure.

The large MTU check is done from eth_configure, which is called when a
interface is added to the system.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/net_kern.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

Index: linux-2.6.20/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.20.orig/arch/um/drivers/net_kern.c	2007-09-27 12:04:34.000000000 -0400
+++ linux-2.6.20/arch/um/drivers/net_kern.c	2007-09-27 12:57:42.000000000 -0400
@@ -34,6 +34,45 @@ static inline void set_ether_mac(struct 
 static DEFINE_SPINLOCK(opened_lock);
 static LIST_HEAD(opened);
 
+/*
+ * The drop_skb is used when we can't allocate an skb.  The
+ * packet is read into drop_skb in order to get the data off the
+ * connection to the host.
+ * It is reallocated whenever a maximum packet size is seen which is
+ * larger than any seen before.  update_drop_skb is called from
+ * eth_configure when a new interface is added.
+ */
+static DEFINE_SPINLOCK(drop_lock);
+static struct sk_buff *drop_skb;
+static int drop_max;
+
+static int update_drop_skb(int max)
+{
+	struct sk_buff *new;
+	int err = 0;
+
+	spin_lock(&drop_lock);
+
+	if (max <= drop_max)
+		goto out;
+
+	err = -ENOMEM;
+	new = dev_alloc_skb(max);
+	if (new == NULL)
+		goto out;
+
+	skb_put(new, max);
+
+	kfree_skb(drop_skb);
+	drop_skb = new;
+	drop_max = max;
+	err = 0;
+out:
+	spin_unlock(&drop_lock);
+
+	return err;
+}
+
 static int uml_net_rx(struct net_device *dev)
 {
 	struct uml_net_private *lp = dev->priv;
@@ -43,6 +82,9 @@ static int uml_net_rx(struct net_device 
 	/* If we can't allocate memory, try again next round. */
 	skb = dev_alloc_skb(lp->max_packet);
 	if (skb == NULL) {
+		drop_skb->dev = dev;
+		/* Read a packet into drop_skb and don't do anything with it. */
+		(*lp->read)(lp->fd, drop_skb, lp);
 		lp->stats.rx_dropped++;
 		return 0;
 	}
@@ -447,6 +489,10 @@ static void eth_configure(int n, void *i
 	dev->watchdog_timeo = (HZ >> 1);
 	dev->irq = UM_ETH_IRQ;
 
+	err = update_drop_skb(lp->max_packet);
+	if (err)
+		goto out_undo_user_init;
+
 	rtnl_lock();
 	err = register_netdevice(dev);
 	rtnl_unlock();
