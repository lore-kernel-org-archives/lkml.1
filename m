Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXDKWzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXDKWzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXDKWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:54:43 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55513 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161337AbXDKWyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:02 -0400
Date: Wed, 11 Apr 2007 15:51:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, davef1624@aol.com,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 03/31] sky2: reliable recovery
Message-ID: <20070411225121.GD24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-reliable-recovery.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

This adds working recovery from transmit timeouts.  Previous code
didn't do enough to truly reset chip.

It is a backport of the 2.6.21 code.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |   81 +++++++++++++++++++++++++++++++++++------------------
 drivers/net/sky2.h |    1 
 2 files changed, 56 insertions(+), 26 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1802,38 +1802,22 @@ static void sky2_tx_timeout(struct net_d
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
@@ -2565,6 +2549,49 @@ static int sky2_reset(struct sky2_hw *hw
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
@@ -3508,6 +3535,8 @@ static int __devinit sky2_probe(struct p
 	}
 
 	setup_timer(&hw->idle_timer, sky2_idle, (unsigned long) hw);
+	INIT_WORK(&hw->restart_work, sky2_restart);
+
 	sky2_idle_start(hw);
 
 	pci_set_drvdata(pdev, hw);
--- a/drivers/net/sky2.h
+++ b/drivers/net/sky2.h
@@ -1898,6 +1898,7 @@ struct sky2_hw {
 	dma_addr_t   	     st_dma;
 
 	struct timer_list    idle_timer;
+	struct work_struct   restart_work;
 	int		     msi;
 	wait_queue_head_t    msi_wait;
 };

-- 
