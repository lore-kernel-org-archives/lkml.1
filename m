Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbYHDVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbYHDVhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764007AbYHDVfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:35:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51913
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759022AbYHDVfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:35:43 -0400
Date: Mon, 04 Aug 2008 14:35:41 -0700 (PDT)
Message-Id: <20080804.143541.96067332.davem@davemloft.net>
To: arekm@maven.pl
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, akpm@linux-foundation.org
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808041845.10893.arekm@maven.pl>
References: <200808041845.10893.arekm@maven.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arkadiusz Miskiewicz <arekm@maven.pl>
Date: Mon, 4 Aug 2008 18:45:10 +0200

> 
> git kernel, pulled around  Sat Aug 2 13:32:05 CEST,
> i686, thinkpad z60m notebook

Obviously the tg3 PCI power-management changes were totally untested.

And unfortunately this is usually par for the course for driver
changes of this kind that I end up applying directly from Andrew's
patch bombs. :-/

Please try reverting this patch:

commit 12dac0756d357325b107fe6ec24921ec38661839
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Jul 30 16:37:33 2008 -0700

    tg3: adapt tg3 to use reworked PCI PM code
    
    Adapt the tg3 driver to use the reworked PCI PM and make it use the
    exported PCI PM core functions instead of accessing the PCI PM registers
    directly by itself.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 633c128..26aa37a 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -1982,8 +1982,6 @@ static void tg3_power_down_phy(struct tg3 *tp)
 static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 {
 	u32 misc_host_ctrl;
-	u16 power_control, power_caps;
-	int pm = tp->pm_cap;
 
 	/* Make sure register accesses (indirect or otherwise)
 	 * will function correctly.
@@ -1992,18 +1990,10 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 			       TG3PCI_MISC_HOST_CTRL,
 			       tp->misc_host_ctrl);
 
-	pci_read_config_word(tp->pdev,
-			     pm + PCI_PM_CTRL,
-			     &power_control);
-	power_control |= PCI_PM_CTRL_PME_STATUS;
-	power_control &= ~(PCI_PM_CTRL_STATE_MASK);
 	switch (state) {
 	case PCI_D0:
-		power_control |= 0;
-		pci_write_config_word(tp->pdev,
-				      pm + PCI_PM_CTRL,
-				      power_control);
-		udelay(100);	/* Delay after power state change */
+		pci_enable_wake(tp->pdev, state, false);
+		pci_set_power_state(tp->pdev, PCI_D0);
 
 		/* Switch out of Vaux if it is a NIC */
 		if (tp->tg3_flags2 & TG3_FLG2_IS_NIC)
@@ -2012,26 +2002,15 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 		return 0;
 
 	case PCI_D1:
-		power_control |= 1;
-		break;
-
 	case PCI_D2:
-		power_control |= 2;
-		break;
-
 	case PCI_D3hot:
-		power_control |= 3;
 		break;
 
 	default:
-		printk(KERN_WARNING PFX "%s: Invalid power state (%d) "
-		       "requested.\n",
-		       tp->dev->name, state);
+		printk(KERN_ERR PFX "%s: Invalid power state (D%d) requested\n",
+			tp->dev->name, state);
 		return -EINVAL;
 	}
-
-	power_control |= PCI_PM_CTRL_PME_ENABLE;
-
 	misc_host_ctrl = tr32(TG3PCI_MISC_HOST_CTRL);
 	tw32(TG3PCI_MISC_HOST_CTRL,
 	     misc_host_ctrl | MISC_HOST_CTRL_MASK_PCI_INT);
@@ -2109,8 +2088,6 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 						     WOL_DRV_WOL |
 						     WOL_SET_MAGIC_PKT);
 
-	pci_read_config_word(tp->pdev, pm + PCI_PM_PMC, &power_caps);
-
 	if (tp->tg3_flags & TG3_FLAG_WOL_ENABLE) {
 		u32 mac_mode;
 
@@ -2143,8 +2120,8 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 		if (!(tp->tg3_flags2 & TG3_FLG2_5750_PLUS))
 			tw32(MAC_LED_CTRL, tp->led_ctrl);
 
-		if (((power_caps & PCI_PM_CAP_PME_D3cold) &&
-		     (tp->tg3_flags & TG3_FLAG_WOL_ENABLE)))
+		if (pci_pme_capable(tp->pdev, state) &&
+		     (tp->tg3_flags & TG3_FLAG_WOL_ENABLE))
 			mac_mode |= MAC_MODE_MAGIC_PKT_ENABLE;
 
 		tw32_f(MAC_MODE, mac_mode);
@@ -2236,9 +2213,11 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
 
 	tg3_write_sig_post_reset(tp, RESET_KIND_SHUTDOWN);
 
+	if (tp->tg3_flags & TG3_FLAG_WOL_ENABLE)
+		pci_enable_wake(tp->pdev, state, true);
+
 	/* Finally, set the new power state. */
-	pci_write_config_word(tp->pdev, pm + PCI_PM_CTRL, power_control);
-	udelay(100);	/* Delay after power state change */
+	pci_set_power_state(tp->pdev, state);
 
 	return 0;
 }
@@ -9065,7 +9044,8 @@ static void tg3_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	if (tp->tg3_flags & TG3_FLAG_WOL_CAP)
+	if ((tp->tg3_flags & TG3_FLAG_WOL_CAP) &&
+	    device_can_wakeup(&tp->pdev->dev))
 		wol->supported = WAKE_MAGIC;
 	else
 		wol->supported = 0;
@@ -9078,18 +9058,22 @@ static void tg3_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 static int tg3_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct tg3 *tp = netdev_priv(dev);
+	struct device *dp = &tp->pdev->dev;
 
 	if (wol->wolopts & ~WAKE_MAGIC)
 		return -EINVAL;
 	if ((wol->wolopts & WAKE_MAGIC) &&
-	    !(tp->tg3_flags & TG3_FLAG_WOL_CAP))
+	    !((tp->tg3_flags & TG3_FLAG_WOL_CAP) && device_can_wakeup(dp)))
 		return -EINVAL;
 
 	spin_lock_bh(&tp->lock);
-	if (wol->wolopts & WAKE_MAGIC)
+	if (wol->wolopts & WAKE_MAGIC) {
 		tp->tg3_flags |= TG3_FLAG_WOL_ENABLE;
-	else
+		device_set_wakeup_enable(dp, true);
+	} else {
 		tp->tg3_flags &= ~TG3_FLAG_WOL_ENABLE;
+		device_set_wakeup_enable(dp, false);
+	}
 	spin_unlock_bh(&tp->lock);
 
 	return 0;
@@ -11296,7 +11280,8 @@ static void __devinit tg3_get_eeprom_hw_cfg(struct tg3 *tp)
 		if (val & VCPU_CFGSHDW_ASPM_DBNC)
 			tp->tg3_flags |= TG3_FLAG_ASPM_WORKAROUND;
 		if ((val & VCPU_CFGSHDW_WOL_ENABLE) &&
-		    (val & VCPU_CFGSHDW_WOL_MAGPKT))
+		    (val & VCPU_CFGSHDW_WOL_MAGPKT) &&
+		    device_may_wakeup(&tp->pdev->dev))
 			tp->tg3_flags |= TG3_FLAG_WOL_ENABLE;
 		return;
 	}
@@ -11426,8 +11411,9 @@ static void __devinit tg3_get_eeprom_hw_cfg(struct tg3 *tp)
 		    !(nic_cfg & NIC_SRAM_DATA_CFG_FIBER_WOL))
 			tp->tg3_flags &= ~TG3_FLAG_WOL_CAP;
 
-		if (tp->tg3_flags & TG3_FLAG_WOL_CAP &&
-		    nic_cfg & NIC_SRAM_DATA_CFG_WOL_ENABLE)
+		if ((tp->tg3_flags & TG3_FLAG_WOL_CAP) &&
+		    (nic_cfg & NIC_SRAM_DATA_CFG_WOL_ENABLE) &&
+		    device_may_wakeup(&tp->pdev->dev))
 			tp->tg3_flags |= TG3_FLAG_WOL_ENABLE;
 
 		if (cfg2 & (1 << 17))
@@ -13613,6 +13599,7 @@ static int tg3_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct tg3 *tp = netdev_priv(dev);
+	pci_power_t target_state;
 	int err;
 
 	/* PCI register 4 needs to be saved whether netif_running() or not.
@@ -13641,7 +13628,9 @@ static int tg3_suspend(struct pci_dev *pdev, pm_message_t state)
 	tp->tg3_flags &= ~TG3_FLAG_INIT_COMPLETE;
 	tg3_full_unlock(tp);
 
-	err = tg3_set_power_state(tp, pci_choose_state(pdev, state));
+	target_state = pdev->pm_cap ? pci_target_state(pdev) : PCI_D3hot;
+
+	err = tg3_set_power_state(tp, target_state);
 	if (err) {
 		int err2;
 
