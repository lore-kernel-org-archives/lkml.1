Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXCVTTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXCVTTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXCVTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:19:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153AbXCVTTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:19:08 -0400
Date: Thu, 22 Mar 2007 12:18:59 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sky2 still broken in 2.6.20.3
Message-ID: <20070322121859.37c9787e@freekitty>
In-Reply-To: <4601AB37.7070302@redhat.com>
References: <4601950D.5000503@redhat.com>
	<20070321144052.02eb2ac7@dxpl.pdx.osdl.net>
	<4601AB37.7070302@redhat.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a backport of the 2.6.21 logic to do more complete
recovery in case of transmit timeout. I added a little more diagnostic
output as well.

Since I can't reproduce a real timeout (my switches seem to work correctly).
Someone else needs to test this.


--- linux-2.6.20.y.orig/drivers/net/sky2.c	2007-03-21 15:10:56.000000000 -0700
+++ linux-2.6.20.y/drivers/net/sky2.c	2007-03-22 11:23:19.000000000 -0700
@@ -1802,38 +1802,22 @@
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
-	unsigned txq = txqaddr[sky2->port];
-	u16 report, done;
+	unsigned port = sky2->port;
 
 	if (netif_msg_timer(sky2))
 		printk(KERN_ERR PFX "%s: tx timeout\n", dev->name);
 
-	report = sky2_read16(hw, sky2->port == 0 ? STAT_TXA1_RIDX : STAT_TXA2_RIDX);
-	done = sky2_read16(hw, Q_ADDR(txq, Q_DONE));
-
-	printk(KERN_DEBUG PFX "%s: transmit ring %u .. %u report=%u done=%u\n",
-	       dev->name,
-	       sky2->tx_cons, sky2->tx_prod, report, done);
-
-	if (report != done) {
-		printk(KERN_INFO PFX "status burst pending (irq moderation?)\n");
+	/* Get information for bug report :-) */
+	printk(KERN_INFO PFX "%s: transmit ring %u .. %u report=%u done=%u\n",
+	       dev->name, sky2->tx_cons, sky2->tx_prod,
+	       sky2_read16(hw, port == 0 ? STAT_TXA1_RIDX : STAT_TXA2_RIDX),
+	       sky2_read16(hw, Q_ADDR(txqaddr[sky2->port], Q_DONE)));
 
-		sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_STOP);
-		sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_START);
-	} else if (report != sky2->tx_cons) {
-		printk(KERN_INFO PFX "status report lost?\n");
-		sky2_tx_complete(sky2, report);
-	} else {
-		printk(KERN_INFO PFX "hardware hung? flushing\n");
+	printk(KERN_INFO PFX "gmac control %#x status %#x\n",
+	       gma_read16(hw, port, GM_GP_CTRL), gma_read16(hw, port, GM_GP_STAT));
 
-		sky2_write32(hw, Q_ADDR(txq, Q_CSR), BMU_STOP);
-		sky2_write32(hw, Y2_QADDR(txq, PREF_UNIT_CTRL), PREF_UNIT_RST_SET);
-
-		sky2_tx_complete(sky2, sky2->tx_prod);
-
-		sky2_qset(hw, txq);
-		sky2_prefetch_init(hw, txq, sky2->tx_le_map, TX_RING_SIZE - 1);
-	}
+	/* can't restart safely under softirq */
+	schedule_work(&hw->restart_work);
 }
 
 static int sky2_change_mtu(struct net_device *dev, int new_mtu)
@@ -2565,6 +2549,49 @@
 	return 0;
 }
 
+static void sky2_restart(struct work_struct *work)
+{
+	struct sky2_hw *hw = container_of(work, struct sky2_hw, restart_work);
+	struct net_device *dev;
+	int i, err;
+
+	dev_dbg(&hw->pdev->dev, "restarting\n");
+
+	del_timer_sync(&hw->idle_timer);
+
+	rtnl_lock();
+	sky2_write32(hw, B0_IMSK, 0);
+	sky2_read32(hw, B0_IMSK);
+
+	netif_poll_disable(hw->dev[0]);
+
+	for (i = 0; i < hw->ports; i++) {
+		dev = hw->dev[i];
+		if (netif_running(dev))
+			sky2_down(dev);
+	}
+
+	sky2_reset(hw);
+	sky2_write32(hw, B0_IMSK, Y2_IS_BASE);
+	netif_poll_enable(hw->dev[0]);
+
+	for (i = 0; i < hw->ports; i++) {
+		dev = hw->dev[i];
+		if (netif_running(dev)) {
+			err = sky2_up(dev);
+			if (err) {
+				printk(KERN_INFO PFX "%s: could not restart %d\n",
+				       dev->name, err);
+				dev_close(dev);
+			}
+		}
+	}
+
+	sky2_idle_start(hw);
+
+	rtnl_unlock();
+}
+
 static u32 sky2_supported_modes(const struct sky2_hw *hw)
 {
 	if (sky2_is_copper(hw)) {
@@ -3508,6 +3535,8 @@
 	}
 
 	setup_timer(&hw->idle_timer, sky2_idle, (unsigned long) hw);
+	INIT_WORK(&hw->restart_work, sky2_restart);
+
 	sky2_idle_start(hw);
 
 	pci_set_drvdata(pdev, hw);
--- linux-2.6.20.y.orig/drivers/net/sky2.h	2007-03-21 15:16:54.000000000 -0700
+++ linux-2.6.20.y/drivers/net/sky2.h	2007-03-21 15:17:19.000000000 -0700
@@ -1898,6 +1898,7 @@
 	dma_addr_t   	     st_dma;
 
 	struct timer_list    idle_timer;
+	struct work_struct   restart_work;
 	int		     msi;
 	wait_queue_head_t    msi_wait;
 };
