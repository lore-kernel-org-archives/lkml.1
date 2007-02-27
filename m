Return-Path: <linux-kernel-owner+w=401wt.eu-S1161450AbXB0AJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161450AbXB0AJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161458AbXB0AH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:57 -0500
Received: from mail.kroah.org ([69.55.234.183]:44839 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161450AbXB0AHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:24 -0500
Date: Mon, 26 Feb 2007 16:06:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 4/9] netpoll: drivers must not enable IRQ unconditionally in their NAPI handler
Message-ID: <20070227000626.GE6283@kroah.com>
References: <20070226235248.438556696@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netpoll-drivers-must-not-enable-irq-unconditionally-in-their-napi-handler.patch"
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Francois Romieu <romieu@fr.zoreil.com>

netpoll: drivers must not enable IRQ unconditionally in their NAPI handler

net/core/netpoll.c::netpoll_send_skb() calls the poll handler when
it is available. As netconsole can be used from almost any context,
IRQ must not be enabled blindly in the NAPI handler of a driver which
supports netpoll.

b57bd06655a028aba7b92e1c19c2093e7fcfb341 fixed the issue for the
8139too.c driver.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/8139cp.c    |    6 ++++--
 drivers/net/b44.c       |    6 ++++--
 drivers/net/forcedeth.c |   11 +++++++----
 drivers/net/skge.c      |    5 +++--
 4 files changed, 18 insertions(+), 10 deletions(-)

--- linux-2.6.19.5.orig/drivers/net/8139cp.c
+++ linux-2.6.19.5/drivers/net/8139cp.c
@@ -617,13 +617,15 @@ rx_next:
 	 * this round of polling
 	 */
 	if (rx_work) {
+		unsigned long flags;
+
 		if (cpr16(IntrStatus) & cp_rx_intr_mask)
 			goto rx_status_loop;
 
-		local_irq_disable();
+		local_irq_save(flags);
 		cpw16_f(IntrMask, cp_intr_mask);
 		__netif_rx_complete(dev);
-		local_irq_enable();
+		local_irq_restore(flags);
 
 		return 0;	/* done */
 	}
--- linux-2.6.19.5.orig/drivers/net/b44.c
+++ linux-2.6.19.5/drivers/net/b44.c
@@ -879,12 +879,14 @@ static int b44_poll(struct net_device *n
 	}
 
 	if (bp->istat & ISTAT_ERRORS) {
-		spin_lock_irq(&bp->lock);
+		unsigned long flags;
+
+		spin_lock_irqsave(&bp->lock, flags);
 		b44_halt(bp);
 		b44_init_rings(bp);
 		b44_init_hw(bp, 1);
 		netif_wake_queue(bp->dev);
-		spin_unlock_irq(&bp->lock);
+		spin_unlock_irqrestore(&bp->lock, flags);
 		done = 1;
 	}
 
--- linux-2.6.19.5.orig/drivers/net/forcedeth.c
+++ linux-2.6.19.5/drivers/net/forcedeth.c
@@ -2544,14 +2544,15 @@ static int nv_napi_poll(struct net_devic
 	int pkts, limit = min(*budget, dev->quota);
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
+	unsigned long flags;
 
 	pkts = nv_rx_process(dev, limit);
 
 	if (nv_alloc_rx(dev)) {
-		spin_lock_irq(&np->lock);
+		spin_lock_irqsave(&np->lock, flags);
 		if (!np->in_shutdown)
 			mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
-		spin_unlock_irq(&np->lock);
+		spin_unlock_irqrestore(&np->lock, flags);
 	}
 
 	if (pkts < limit) {
@@ -2559,13 +2560,15 @@ static int nv_napi_poll(struct net_devic
 		netif_rx_complete(dev);
 
 		/* re-enable receive interrupts */
-		spin_lock_irq(&np->lock);
+		spin_lock_irqsave(&np->lock, flags);
+
 		np->irqmask |= NVREG_IRQ_RX_ALL;
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
 		else
 			writel(np->irqmask, base + NvRegIrqMask);
-		spin_unlock_irq(&np->lock);
+
+		spin_unlock_irqrestore(&np->lock, flags);
 		return 0;
 	} else {
 		/* used up our quantum, so reschedule */
--- linux-2.6.19.5.orig/drivers/net/skge.c
+++ linux-2.6.19.5/drivers/net/skge.c
@@ -2919,6 +2919,7 @@ static int skge_poll(struct net_device *
 	struct skge_hw *hw = skge->hw;
 	struct skge_ring *ring = &skge->rx_ring;
 	struct skge_element *e;
+	unsigned long flags;
 	int to_do = min(dev->quota, *budget);
 	int work_done = 0;
 
@@ -2956,12 +2957,12 @@ static int skge_poll(struct net_device *
 	if (work_done >=  to_do)
 		return 1; /* not done */
 
-	spin_lock_irq(&hw->hw_lock);
+	spin_lock_irqsave(&hw->hw_lock, flags);
 	__netif_rx_complete(dev);
 	hw->intr_mask |= irqmask[skge->port];
   	skge_write32(hw, B0_IMSK, hw->intr_mask);
 	skge_read32(hw, B0_IMSK);
-	spin_unlock_irq(&hw->hw_lock);
+	spin_unlock_irqrestore(&hw->hw_lock, flags);
 
 	return 0;
 }

--
