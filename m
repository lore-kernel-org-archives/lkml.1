Return-Path: <linux-kernel-owner+w=401wt.eu-S1423220AbXBUWqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423220AbXBUWqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423227AbXBUWqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:46:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423220AbXBUWqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:46:36 -0500
Message-ID: <45DCCB23.5050001@redhat.com>
Date: Wed, 21 Feb 2007 17:43:47 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com>
In-Reply-To: <20070221013619.GA30227@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------060009040103080201030605"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060009040103080201030605
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.19.5 release.
> 
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.

This is the rest of the NAPI fixes for 2.6.19-stable.





--------------060009040103080201030605
Content-Type: text/plain;
 name="linux-2.6-NAPI-irqsave.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-NAPI-irqsave.patch"

# HG changeset patch
# User Francois Romieu <romieu@fr.zoreil.com>
# Date 1167168251 18000
# Node ID 7c05514de8881339775cfd86e6357a82735c34f2
# Parent bf34fac7fcce4300f7199337160dab99deefc738
netpoll: drivers must not enable IRQ unconditionally in their NAPI handler

net/core/netpoll.c::netpoll_send_skb() calls the poll handler when
it is available. As netconsole can be used from almost any context,
IRQ must not be enabled blindly in the NAPI handler of a driver which
supports netpoll.

b57bd06655a028aba7b92e1c19c2093e7fcfb341 fixed the issue for the
8139too.c driver.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>

committer: Jeff Garzik <jeff@garzik.org> 1167168251 -0500

--- a/drivers/net/8139cp.c	Tue Dec 26 15:51:30 2006 -0500
+++ b/drivers/net/8139cp.c	Tue Dec 26 16:24:11 2006 -0500
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
--- a/drivers/net/b44.c	Tue Dec 26 15:51:30 2006 -0500
+++ b/drivers/net/b44.c	Tue Dec 26 16:24:11 2006 -0500
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
 
--- a/drivers/net/forcedeth.c	Tue Dec 26 15:51:30 2006 -0500
+++ b/drivers/net/forcedeth.c	Tue Dec 26 16:24:11 2006 -0500
@@ -2576,14 +2576,15 @@ static int nv_napi_poll(struct net_devic
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
@@ -2591,13 +2592,15 @@ static int nv_napi_poll(struct net_devic
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
--- a/drivers/net/skge.c	Tue Dec 26 15:51:30 2006 -0500
+++ b/drivers/net/skge.c	Tue Dec 26 16:24:11 2006 -0500
@@ -2920,6 +2920,7 @@ static int skge_poll(struct net_device *
 	struct skge_hw *hw = skge->hw;
 	struct skge_ring *ring = &skge->rx_ring;
 	struct skge_element *e;
+	unsigned long flags;
 	int to_do = min(dev->quota, *budget);
 	int work_done = 0;
 
@@ -2957,12 +2958,12 @@ static int skge_poll(struct net_device *
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

--------------060009040103080201030605--
