Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941Ab0AAB3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0AAB3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 20:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570Ab0AAB3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 20:29:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab0AAB3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 20:29:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH][RFC] e1000e: Add basic runtime PM support (was: [PATCH 0/12] PCI run-time PM support (rev. 2))
Date: Fri, 1 Jan 2010 02:29:23 +0100
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
References: <200912272057.10443.rjw@sisk.pl>
In-Reply-To: <200912272057.10443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001010229.24061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 December 2009, Rafael J. Wysocki wrote:
> Hi,
> 
> The following (updated) series of patches provides preliminary run-time power
> management support for PCI devices through ACPI and/or the native PCIe PME.
> 
> Some patches have been modified since the previous iteration, one patch has
> been merged and there's one more.
> 
> I've tested this patchset with the native PCIe PME mechanism using the r8169
> driver on the MSI Wind U-100 (see the last patch for details) and with the ACPI
> mechanism using the e1000e driver on the Toshiba Portege R500 (the patch still
> requires some work to be shown in public ;-)).

The e1000e patch is now in a better shape IMO, at least it worked for me in all
conditions I tested it, so it is appended below.

> [1/12] - Add function for checking PME status of devices
>  
> [2/12] - Modify wake-up enable propagation so that it's done for PCIe devices
>          too (this one is in the Jesse's tree already, but it's reproduced here
>          for completness)
>  
> [3/12] - PCIe PME root port service driver
> 
> [4/12] - "Don't use MSIs for PME signaling" switch for PCIe
>  
> [5/12] - ACPI GPE refcounting, from Matthew
>  
> [6/12] - ACPI drivers support for GPE refcounting, from Matthew
>  
> [7/12] - ACPI removal of the old GPE API, from Matthew
>  
> [8/12] - ACPI add fields for handling run-wake devices
>  
> [9/12][New] - ACPI add helper function for enabling/disabling wake-up power
> 
> [10/12] - PCI / ACPI platform support for run-time power management
> 
> [11/12] - Runtime PM callbacks for the PCI bus type
> 
> [12/12] - Runtime PM support for r8169 (experimental)
> 
> If there are no objections, I think the patches [1-11/12] are ready for the
> upstream.

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: e1000e: Add basic runtime PM support

Add support for suspending the device on link removal and resuming it
on link gain.

Based on a patch from Matthew Garrett.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/e1000e/netdev.c |   90 ++++++++++++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 24 deletions(-)

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
@@ -3093,12 +3094,18 @@ static int e1000_open(struct net_device 
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	struct pci_dev *pdev = adapter->pdev;
 	int err;
 
 	/* disallow open during test */
 	if (test_bit(__E1000_TESTING, &adapter->state))
 		return -EBUSY;
 
+	if (pci_dev_run_wake(pdev)) {
+		pm_runtime_set_active(&pdev->dev);
+		pm_runtime_enable(&pdev->dev);
+	}
+
 	netif_carrier_off(netdev);
 
 	/* allocate transmit descriptors */
@@ -3190,9 +3197,21 @@ err_setup_tx:
 static int e1000_close(struct net_device *netdev)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
 
 	WARN_ON(test_bit(__E1000_RESETTING, &adapter->state));
-	e1000e_down(adapter);
+
+	if (pci_dev_run_wake(pdev)) {
+		pm_runtime_get_noresume(&pdev->dev);
+		pm_runtime_resume(&pdev->dev);
+		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
+	}
+
+	if (netif_running(netdev))
+		e1000e_down(adapter);
+
 	e1000_power_down_phy(adapter);
 	e1000_free_irq(adapter);
 
@@ -3571,6 +3590,10 @@ static void e1000_watchdog_task(struct w
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
@@ -3686,6 +3709,8 @@ static void e1000_watchdog_task(struct w
 
 			if (adapter->flags & FLAG_RX_NEEDS_RESTART)
 				schedule_work(&adapter->reset_task);
+			else
+				pm_schedule_suspend(netdev->dev.parent, 100);
 		}
 	}
 
@@ -4489,13 +4514,15 @@ out:
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
@@ -4653,41 +4680,43 @@ static void e1000e_disable_l1aspm(struct
 }
 
 #ifdef CONFIG_PM
-static int e1000_suspend(struct pci_dev *pdev, pm_message_t state)
+static int e1000_idle(struct device *dev)
 {
+	/* Prevent the driver core from changing our state */
+	return -EBUSY;
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
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	bool wake;
+
+	return __e1000_shutdown(pdev, &wake, true);
+}
+
+static int e1000_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 err;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
 	e1000e_disable_l1aspm(pdev);
 
-	err = pci_enable_device_mem(pdev);
-	if (err) {
-		dev_err(&pdev->dev,
-			"Cannot enable PCI device from suspend\n");
-		return err;
-	}
-
-	pci_set_master(pdev);
-
-	pci_enable_wake(pdev, PCI_D3hot, 0);
-	pci_enable_wake(pdev, PCI_D3cold, 0);
-
 	e1000e_set_interrupt_capability(adapter);
 	if (netif_running(netdev)) {
 		err = e1000_request_irq(adapter);
@@ -4751,7 +4780,7 @@ static void e1000_shutdown(struct pci_de
 {
 	bool wake = false;
 
-	__e1000_shutdown(pdev, &wake);
+	__e1000_shutdown(pdev, &wake, false);
 
 	if (system_state == SYSTEM_POWER_OFF)
 		e1000_complete_shutdown(pdev, false, wake);
@@ -5274,6 +5303,9 @@ static void __devexit e1000_remove(struc
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
+	if (pci_dev_run_wake(pdev))
+		pm_runtime_resume(&pdev->dev);
+
 	/*
 	 * flush_scheduled work may reschedule our watchdog task, so
 	 * explicitly disable watchdog tasks from being rescheduled
@@ -5393,6 +5425,18 @@ static struct pci_device_id e1000_pci_tb
 };
 MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
 
+static struct dev_pm_ops e1000_pm_ops = {
+	.suspend  = e1000_suspend,
+	.resume   = e1000_resume,
+	.freeze = e1000_suspend,
+	.thaw = e1000_resume,
+	.poweroff = e1000_suspend,
+	.restore = e1000_resume,
+	.runtime_suspend = e1000_runtime_suspend,
+	.runtime_resume = e1000_resume,
+	.runtime_idle = e1000_idle,
+};
+
 /* PCI Device API Driver */
 static struct pci_driver e1000_driver = {
 	.name     = e1000e_driver_name,
@@ -5400,9 +5444,7 @@ static struct pci_driver e1000_driver = 
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
