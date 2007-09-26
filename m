Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbXIZVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbXIZVqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbXIZVq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:46:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60764 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXIZVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:46:27 -0400
Date: Wed, 26 Sep 2007 17:46:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       caker@linode.com
Subject: [PATCH 3/3] UML - Correctly handle skb allocation failures
Message-ID: <20070926214613.GA11547@c2.user-mode-linux.org>
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
interface is added to the system, and from uml_net_change_mtu, which
is called when an existing interface has its MTU changed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/net_kern.c |   60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

Index: linux-2.6.20/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.20.orig/arch/um/drivers/net_kern.c	2007-09-26 16:48:21.000000000 -0400
+++ linux-2.6.20/arch/um/drivers/net_kern.c	2007-09-26 16:56:16.000000000 -0400
@@ -34,6 +34,48 @@ static inline void set_ether_mac(struct 
 static DEFINE_SPINLOCK(opened_lock);
 static LIST_HEAD(opened);
 
+/*
+ * The throwaway skb is used when we can't allocate an skb.  The
+ * packet is read into throwaway in order to get the data off the
+ * connection to the host.
+ * It is reallocated whenever an MTU is seen which is larger than
+ * anything seen before.  update_throwaway_skb is called from
+ * eth_configure for new interfaces and from uml_net_change_mtu for
+ * MTU changes on existing interfaces.
+ */
+static DEFINE_SPINLOCK(throwaway_lock);
+static struct sk_buff *throwaway;
+static int throwaway_max;
+
+static int update_throwaway_skb(int max)
+{
+	struct sk_buff *new;
+	int err = 0;
+
+	spin_lock(&throwaway_lock);
+
+	if (max <= throwaway_max)
+		goto out;
+
+	err = -ENOMEM;
+	new = dev_alloc_skb(max);
+	if (new == NULL)
+		goto out;
+
+	skb_put(new, max);
+
+	kfree_skb(throwaway);
+	throwaway = new;
+	throwaway_max = max;
+	err = 0;
+out:
+	spin_unlock(&throwaway_lock);
+
+	return err;
+}
+
+int npackets = 0;
+
 static int uml_net_rx(struct net_device *dev)
 {
 	struct uml_net_private *lp = dev->priv;
@@ -42,7 +84,14 @@ static int uml_net_rx(struct net_device 
 
 	/* If we can't allocate memory, try again next round. */
 	skb = dev_alloc_skb(lp->max_packet);
+	if ((++npackets % 100) == 0){
+		kfree_skb(skb);
+		skb = NULL;
+	}
+
 	if (skb == NULL) {
+		throwaway->dev = dev;
+		(*lp->read)(lp->fd, throwaway, lp);
 		lp->stats.rx_dropped++;
 		return 0;
 	}
@@ -240,6 +289,13 @@ static int uml_net_set_mac(struct net_de
 
 static int uml_net_change_mtu(struct net_device *dev, int new_mtu)
 {
+	struct uml_net_private *lp = dev->priv;
+	int err;
+
+	err = update_throwaway_skb(lp->max_packet);
+	if (err)
+		return err;
+
 	dev->mtu = new_mtu;
 
 	return 0;
@@ -447,6 +503,10 @@ static void eth_configure(int n, void *i
 	dev->watchdog_timeo = (HZ >> 1);
 	dev->irq = UM_ETH_IRQ;
 
+	err = update_throwaway_skb(lp->max_packet);
+	if (err)
+		goto out_undo_user_init;
+
 	rtnl_lock();
 	err = register_netdevice(dev);
 	rtnl_unlock();
