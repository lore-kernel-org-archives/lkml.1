Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZK2Prm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZK2Prm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZK2Pri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:47:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbZK2Pq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:46:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 12/12] PM / r8169: Add simplified run-time PM support
Date: Sun, 29 Nov 2009 16:44:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291632.44763.rjw@sisk.pl>
In-Reply-To: <200911291632.44763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291644.27288.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the PCI run-time power management framework to add simplified
run-time PM support to the r8169 driver.  Namely, make the driver
suspend the device when the link is off and set it up for generating
wake-up event after the link has been detected again.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/r8169.c |  133 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 106 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/net/r8169.c
===================================================================
--- linux-2.6.orig/drivers/net/r8169.c
+++ linux-2.6/drivers/net/r8169.c
@@ -23,6 +23,7 @@
 #include <linux/tcp.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -504,6 +505,8 @@ struct rtl8169_private {
 
 	struct mii_if_info mii;
 	struct rtl8169_counters counters;
+	u32 saved_wolopts;
+	bool exiting;
 };
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
@@ -750,48 +753,54 @@ static void rtl8169_check_link_status(st
 		if (netif_msg_ifdown(tp))
 			printk(KERN_INFO PFX "%s: link down\n", dev->name);
 		netif_carrier_off(dev);
+		pm_schedule_suspend(&tp->pci_dev->dev, 100);
 	}
 	spin_unlock_irqrestore(&tp->lock, flags);
 }
 
-static void rtl8169_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+#define WAKE_ANY (WAKE_PHY | WAKE_MAGIC | WAKE_UCAST | WAKE_BCAST | WAKE_MCAST)
+
+static u32 __rtl8169_get_wol(struct rtl8169_private *tp)
 {
-	struct rtl8169_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->mmio_addr;
 	u8 options;
-
-	wol->wolopts = 0;
-
-#define WAKE_ANY (WAKE_PHY | WAKE_MAGIC | WAKE_UCAST | WAKE_BCAST | WAKE_MCAST)
-	wol->supported = WAKE_ANY;
-
-	spin_lock_irq(&tp->lock);
+	u32 wolopts = 0;
 
 	options = RTL_R8(Config1);
 	if (!(options & PMEnable))
-		goto out_unlock;
+		return 0;
 
 	options = RTL_R8(Config3);
 	if (options & LinkUp)
-		wol->wolopts |= WAKE_PHY;
+		wolopts |= WAKE_PHY;
 	if (options & MagicPacket)
-		wol->wolopts |= WAKE_MAGIC;
+		wolopts |= WAKE_MAGIC;
 
 	options = RTL_R8(Config5);
 	if (options & UWF)
-		wol->wolopts |= WAKE_UCAST;
+		wolopts |= WAKE_UCAST;
 	if (options & BWF)
-		wol->wolopts |= WAKE_BCAST;
+		wolopts |= WAKE_BCAST;
 	if (options & MWF)
-		wol->wolopts |= WAKE_MCAST;
+		wolopts |= WAKE_MCAST;
 
-out_unlock:
-	spin_unlock_irq(&tp->lock);
+	return wolopts;
 }
 
-static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+static void rtl8169_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
+
+	spin_lock_irq(&tp->lock);
+
+	wol->supported = WAKE_ANY;
+	wol->wolopts = __rtl8169_get_wol(tp);
+
+	spin_unlock_irq(&tp->lock);
+}
+
+static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
+{
 	void __iomem *ioaddr = tp->mmio_addr;
 	unsigned int i;
 	static struct {
@@ -808,23 +817,29 @@ static int rtl8169_set_wol(struct net_de
 		{ WAKE_ANY,   Config5, LanWake }
 	};
 
-	spin_lock_irq(&tp->lock);
-
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
 
 	for (i = 0; i < ARRAY_SIZE(cfg); i++) {
 		u8 options = RTL_R8(cfg[i].reg) & ~cfg[i].mask;
-		if (wol->wolopts & cfg[i].opt)
+		if (wolopts & cfg[i].opt)
 			options |= cfg[i].mask;
 		RTL_W8(cfg[i].reg, options);
 	}
 
 	RTL_W8(Cfg9346, Cfg9346_Lock);
+}
+
+static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	spin_lock_irq(&tp->lock);
 
 	if (wol->wolopts)
 		tp->features |= RTL_FEATURE_WOL;
 	else
 		tp->features &= ~RTL_FEATURE_WOL;
+	__rtl8169_set_wol(tp, wol->wolopts);
 	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
 
 	spin_unlock_irq(&tp->lock);
@@ -3000,6 +3015,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	tp->dev = dev;
 	tp->pci_dev = pdev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
+	tp->exiting = false;
 
 	mii = &tp->mii;
 	mii->dev = dev;
@@ -3232,6 +3248,8 @@ static void __devexit rtl8169_remove_one
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
+	tp->exiting = true;
+
 	flush_scheduled_work();
 
 	unregister_netdev(dev);
@@ -3254,7 +3272,6 @@ static int rtl8169_open(struct net_devic
 	struct pci_dev *pdev = tp->pci_dev;
 	int retval = -ENOMEM;
 
-
 	rtl8169_set_rxbufsize(tp, dev);
 
 	/*
@@ -3291,6 +3308,13 @@ static int rtl8169_open(struct net_devic
 
 	rtl8169_request_timer(dev);
 
+	tp->saved_wolopts = 0;
+
+	if (pci_dev_run_wake(pdev)) {
+		pm_runtime_set_active(&pdev->dev);
+		pm_runtime_enable(&pdev->dev);
+	}
+
 	rtl8169_check_link_status(dev, tp, tp->mmio_addr);
 out:
 	return retval;
@@ -4724,6 +4748,14 @@ static int rtl8169_close(struct net_devi
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct pci_dev *pdev = tp->pci_dev;
 
+	if (pci_dev_run_wake(pdev)) {
+		pm_runtime_get_noresume(&pdev->dev);
+		pm_runtime_resume(&pdev->dev);
+		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
+	}
+
 	/* update counters before going down */
 	rtl8169_update_counters(dev);
 
@@ -4841,21 +4873,65 @@ static int rtl8169_suspend(struct device
 	return 0;
 }
 
+static void __rtl8169_resume(struct net_device *dev)
+{
+	netif_device_attach(dev);
+	rtl8169_schedule_work(dev, rtl8169_reset_task);
+}
+
 static int rtl8169_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct net_device *dev = pci_get_drvdata(pdev);
 
-	if (!netif_running(dev))
-		goto out;
+	if (netif_running(dev))
+		__rtl8169_resume(dev);
 
-	netif_device_attach(dev);
+	return 0;
+}
+
+static int rtl8169_runtime_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	dev_dbg(&pdev->dev, "suspending\n");
+
+	spin_lock_irq(&tp->lock);
+	tp->saved_wolopts = __rtl8169_get_wol(tp);
+	__rtl8169_set_wol(tp, WAKE_ANY);
+	spin_unlock_irq(&tp->lock);
+
+	rtl8169_net_suspend(dev);
+
+	return 0;
+}
+
+static int rtl8169_runtime_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	dev_dbg(&pdev->dev, "resuming\n");
+
+	spin_lock_irq(&tp->lock);
+	__rtl8169_set_wol(tp, tp->saved_wolopts);
+	tp->saved_wolopts = 0;
+	spin_unlock_irq(&tp->lock);
+
+	if (!tp->exiting)
+		__rtl8169_resume(dev);
 
-	rtl8169_schedule_work(dev, rtl8169_reset_task);
-out:
 	return 0;
 }
 
+static int rtl8169_runtime_idle(struct device *device)
+{
+	return -EBUSY;
+}
+
 static struct dev_pm_ops rtl8169_pm_ops = {
 	.suspend = rtl8169_suspend,
 	.resume = rtl8169_resume,
@@ -4863,6 +4939,9 @@ static struct dev_pm_ops rtl8169_pm_ops 
 	.thaw = rtl8169_resume,
 	.poweroff = rtl8169_suspend,
 	.restore = rtl8169_resume,
+	.runtime_suspend = rtl8169_runtime_suspend,
+	.runtime_resume = rtl8169_runtime_resume,
+	.runtime_idle = rtl8169_runtime_idle,
 };
 
 #define RTL8169_PM_OPS	(&rtl8169_pm_ops)

