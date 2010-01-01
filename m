Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994Ab0AAVvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0AAVvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502Ab0AAVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:51:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0AAVvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:51:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH][RFC] e1000e: Add basic runtime PM support (rev. 3) (was: [PATCH 0/12] PCI run-time PM support (rev. 2))
Date: Fri, 1 Jan 2010 22:51:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       e1000-devel@lists.sourceforge.net
References: <200912272057.10443.rjw@sisk.pl> <201001010229.24061.rjw@sisk.pl> <201001012003.07722.rjw@sisk.pl>
In-Reply-To: <201001012003.07722.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001012251.58150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 January 2010, Rafael J. Wysocki wrote:
> On Friday 01 January 2010, Rafael J. Wysocki wrote:
> > On Sunday 27 December 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > The following (updated) series of patches provides preliminary run-time power
> > > management support for PCI devices through ACPI and/or the native PCIe PME.
> > > 
> > > Some patches have been modified since the previous iteration, one patch has
> > > been merged and there's one more.
> > > 
> > > I've tested this patchset with the native PCIe PME mechanism using the r8169
> > > driver on the MSI Wind U-100 (see the last patch for details) and with the ACPI
> > > mechanism using the e1000e driver on the Toshiba Portege R500 (the patch still
> > > requires some work to be shown in public ;-)).
> > 
> > The e1000e patch is now in a better shape IMO, at least it worked for me in all
> > conditions I tested it, so it is appended below.
> 
> This one was actually buggy, as it triggered a netdevice.h BUG_ON() during
> resume from suspend to RAM with network cable attached.
> 
> Appended is a new version that doesn't have this problem and enables runtime PM
> in _probe(), so the device can be put into the low power state if _open()
> hasn't been called yet (or after _close()).

This one also has a few problems (triggers a warning about an already freed
interrupt being freed again during suspend to RAM with the adapter suspended at
run time if it is maganed by NetworkManager and doesn't put the adapter into
the low power state if the link is not present from the start), so appended is
a fixed one (at least it doesn't show any more problems in my testing).

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / PM / e1000e: Add basic runtime PM support (rev. 3)

Use the PCI run-time power management framework to add simplified
run-time PM support to the e1000e driver.  Namely, make the driver
suspend the device when the link is off and set it up for generating
wake-up event after the link has been detected again.

Based on a patch from Matthew Garrett.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/e1000e/netdev.c |  141 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 115 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/net/e1000e/netdev.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000e/netdev.c
+++ linux-2.6/drivers/net/e1000e/netdev.c
@@ -44,6 +44,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/pm_qos_params.h>
+#include <linux/pm_runtime.h>
 #include <linux/aer.h>
 
 #include "e1000.h"
@@ -3093,12 +3094,15 @@ static int e1000_open(struct net_device 
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	struct pci_dev *pdev = adapter->pdev;
 	int err;
 
 	/* disallow open during test */
 	if (test_bit(__E1000_TESTING, &adapter->state))
 		return -EBUSY;
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	netif_carrier_off(netdev);
 
 	/* allocate transmit descriptors */
@@ -3159,6 +3163,10 @@ static int e1000_open(struct net_device 
 
 	netif_start_queue(netdev);
 
+	pm_runtime_put_noidle(&pdev->dev);
+	if (!e1000_has_link(adapter))
+		pm_schedule_suspend(&pdev->dev, 100);
+
 	/* fire a link status change interrupt to start the watchdog */
 	ew32(ICS, E1000_ICS_LSC);
 
@@ -3172,6 +3180,7 @@ err_setup_rx:
 	e1000e_free_tx_resources(adapter);
 err_setup_tx:
 	e1000e_reset(adapter);
+	pm_runtime_put_noidle(&pdev->dev);
 
 	return err;
 }
@@ -3190,11 +3199,17 @@ err_setup_tx:
 static int e1000_close(struct net_device *netdev)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
 
 	WARN_ON(test_bit(__E1000_RESETTING, &adapter->state));
-	e1000e_down(adapter);
+
+	pm_runtime_get_sync(&pdev->dev);
+
+	if (!test_bit(__E1000_DOWN, &adapter->state)) {
+		e1000e_down(adapter);
+		e1000_free_irq(adapter);
+	}
 	e1000_power_down_phy(adapter);
-	e1000_free_irq(adapter);
 
 	e1000e_free_tx_resources(adapter);
 	e1000e_free_rx_resources(adapter);
@@ -3216,6 +3231,8 @@ static int e1000_close(struct net_device
 	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_release_hw_control(adapter);
 
+	pm_runtime_put_noidle(&pdev->dev);
+
 	return 0;
 }
 /**
@@ -3571,6 +3588,10 @@ static void e1000_watchdog_task(struct w
 	if (link) {
 		if (!netif_carrier_ok(netdev)) {
 			bool txb2b = 1;
+
+			/* This is to cancel scheduled suspend requests. */
+			pm_runtime_resume(netdev->dev.parent);
+
 			/* update snapshot of PHY registers on LSC */
 			e1000_phy_read_status(adapter);
 			mac->ops.get_link_up_info(&adapter->hw,
@@ -3686,6 +3707,8 @@ static void e1000_watchdog_task(struct w
 
 			if (adapter->flags & FLAG_RX_NEEDS_RESTART)
 				schedule_work(&adapter->reset_task);
+			else
+				pm_schedule_suspend(netdev->dev.parent, 100);
 		}
 	}
 
@@ -4489,13 +4512,15 @@ out:
 	return retval;
 }
 
-static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
+static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
+			    bool runtime)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, ctrl_ext, rctl, status;
-	u32 wufc = adapter->wol;
+	/* Runtime suspend should only enable wakeup for link changes */
+	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
 	int retval = 0;
 
 	netif_device_detach(netdev);
@@ -4653,40 +4678,59 @@ static void e1000e_disable_l1aspm(struct
 }
 
 #ifdef CONFIG_PM
-static int e1000_suspend(struct pci_dev *pdev, pm_message_t state)
+static bool e1000e_pm_ready(struct e1000_adapter *adapter)
+{
+	return !!adapter->tx_ring->buffer_info;
+}
+
+static int e1000_idle(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+
+	/*  If we're active, prevent the driver core from changing our state */
+	if (e1000e_pm_ready(adapter))
+		return -EBUSY;
+
+	pm_schedule_suspend(dev, MSEC_PER_SEC);
+	return 0;
+}
+
+static int e1000_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
 	int retval;
 	bool wake;
 
-	retval = __e1000_shutdown(pdev, &wake);
+	retval = __e1000_shutdown(pdev, &wake, false);
 	if (!retval)
 		e1000_complete_shutdown(pdev, true, wake);
 
 	return retval;
 }
 
-static int e1000_resume(struct pci_dev *pdev)
+static int e1000_runtime_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	struct e1000_hw *hw = &adapter->hw;
-	u32 err;
+	bool wake;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	e1000e_disable_l1aspm(pdev);
+	if (e1000e_pm_ready(adapter))
+		return __e1000_shutdown(pdev, &wake, true);
 
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev,
-			"Cannot enable PCI device from suspend\n");
-		return err;
-	}
+	return 0;
+}
 
-	pci_set_master(pdev);
+static int __e1000_resume(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	struct e1000_hw *hw = &adapter->hw;
+	u32 err;
 
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	pci_enable_wake(pdev, PCI_D3cold, 0);
+	e1000e_disable_l1aspm(pdev);
 
 	e1000e_set_interrupt_capability(adapter);
 	if (netif_running(netdev)) {
@@ -4745,13 +4789,30 @@ static int e1000_resume(struct pci_dev *
 
 	return 0;
 }
+
+static int e1000_resume(struct device *dev)
+{
+	return __e1000_resume(to_pci_dev(dev));
+}
+
+static int e1000_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+
+	if (e1000e_pm_ready(adapter))
+		return __e1000_resume(pdev);
+
+	return 0;
+}
 #endif
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
 	bool wake = false;
 
-	__e1000_shutdown(pdev, &wake);
+	__e1000_shutdown(pdev, &wake, false);
 
 	if (system_state == SYSTEM_POWER_OFF)
 		e1000_complete_shutdown(pdev, false, wake);
@@ -5231,6 +5292,11 @@ static int __devinit e1000_probe(struct 
 
 	e1000_print_device_info(adapter);
 
+	if (pci_dev_run_wake(pdev)) {
+		pm_runtime_set_active(&pdev->dev);
+		pm_runtime_enable(&pdev->dev);
+	}
+
 	return 0;
 
 err_register:
@@ -5273,12 +5339,16 @@ static void __devexit e1000_remove(struc
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	bool down = test_bit(__E1000_DOWN, &adapter->state);
+
+	pm_runtime_get_sync(&pdev->dev);
 
 	/*
 	 * flush_scheduled work may reschedule our watchdog task, so
 	 * explicitly disable watchdog tasks from being rescheduled
 	 */
-	set_bit(__E1000_DOWN, &adapter->state);
+	if (!down)
+		set_bit(__E1000_DOWN, &adapter->state);
 	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
@@ -5292,8 +5362,17 @@ static void __devexit e1000_remove(struc
 	if (!(netdev->flags & IFF_UP))
 		e1000_power_down_phy(adapter);
 
+	/* Don't lie to e1000_close() down the road. */
+	if (!down)
+		clear_bit(__E1000_DOWN, &adapter->state);
 	unregister_netdev(netdev);
 
+	if (pci_dev_run_wake(pdev)) {
+		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
+	pm_runtime_put_noidle(&pdev->dev);
+
 	/*
 	 * Release control of h/w to f/w.  If f/w is AMT enabled, this
 	 * would have already happened in close and is redundant.
@@ -5393,6 +5472,18 @@ static struct pci_device_id e1000_pci_tb
 };
 MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
 
+static const struct dev_pm_ops e1000_pm_ops = {
+	.suspend  = e1000_suspend,
+	.resume   = e1000_resume,
+	.freeze = e1000_suspend,
+	.thaw = e1000_resume,
+	.poweroff = e1000_suspend,
+	.restore = e1000_resume,
+	.runtime_suspend = e1000_runtime_suspend,
+	.runtime_resume = e1000_runtime_resume,
+	.runtime_idle = e1000_idle,
+};
+
 /* PCI Device API Driver */
 static struct pci_driver e1000_driver = {
 	.name     = e1000e_driver_name,
@@ -5400,9 +5491,7 @@ static struct pci_driver e1000_driver = 
 	.probe    = e1000_probe,
 	.remove   = __devexit_p(e1000_remove),
 #ifdef CONFIG_PM
-	/* Power Management Hooks */
-	.suspend  = e1000_suspend,
-	.resume   = e1000_resume,
+	.driver.pm = &e1000_pm_ops,
 #endif
 	.shutdown = e1000_shutdown,
 	.err_handler = &e1000_err_handler
