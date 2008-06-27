Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYF0OxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYF0OxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYF0Owh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:52:37 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:28766 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYF0Owe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:52:34 -0400
Message-Id: <20080627144753.610931382@ldl.fc.hp.com>
References: <20080627144538.743154341@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 08:45:42 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/6] PCIE: aer: use dev_printk when possible
Content-Disposition: inline; filename=pci-aer-dev_printk
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to use dev_printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pci/pcie/aer/aerdrv.c      |    8 +++-----
 drivers/pci/pcie/aer/aerdrv_acpi.c |    8 ++++----
 drivers/pci/pcie/aer/aerdrv_core.c |   24 ++++++++++++------------
 3 files changed, 19 insertions(+), 21 deletions(-)

Index: work11/drivers/pci/pcie/aer/aerdrv.c
===================================================================
--- work11.orig/drivers/pci/pcie/aer/aerdrv.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/pcie/aer/aerdrv.c	2008-06-26 12:30:14.000000000 -0600
@@ -219,8 +219,7 @@ static int __devinit aer_probe (struct p
 
 	/* Alloc rpc data structure */
 	if (!(rpc = aer_alloc_rpc(dev))) {
-		printk(KERN_DEBUG "%s: Alloc rpc fails on PCIE device[%s]\n",
-			__func__, device->bus_id);
+		dev_printk(KERN_DEBUG, device, "alloc rpc failed\n");
 		aer_remove(dev);
 		return -ENOMEM;
 	}
@@ -228,8 +227,7 @@ static int __devinit aer_probe (struct p
 	/* Request IRQ ISR */
 	if ((status = request_irq(dev->irq, aer_irq, IRQF_SHARED, "aerdrv",
 				dev))) {
-		printk(KERN_DEBUG "%s: Request ISR fails on PCIE device[%s]\n",
-			__func__, device->bus_id);
+		dev_printk(KERN_DEBUG, device, "request IRQ failed\n");
 		aer_remove(dev);
 		return status;
 	}
@@ -273,7 +271,7 @@ static pci_ers_result_t aer_root_reset(s
 	 * to issue Configuration Requests to those devices.
 	 */
 	msleep(200);
-	printk(KERN_DEBUG "Complete link reset at Root[%s]\n", dev->dev.bus_id);
+	dev_printk(KERN_DEBUG, &dev->dev, "Root Port link has been reset\n");
 
 	/* Enable Root Port's interrupt in response to error messages */
 	pci_read_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, &status);
Index: work11/drivers/pci/pcie/aer/aerdrv_acpi.c
===================================================================
--- work11.orig/drivers/pci/pcie/aer/aerdrv_acpi.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/pcie/aer/aerdrv_acpi.c	2008-06-26 12:30:14.000000000 -0600
@@ -50,10 +50,10 @@ int aer_osc_setup(struct pcie_device *pc
 	}
 
 	if (ACPI_FAILURE(status)) {
-		printk(KERN_DEBUG "AER service couldn't init device %s - %s\n",
-		    pciedev->device.bus_id,
-		    (status == AE_SUPPORT || status == AE_NOT_FOUND) ?
-		    "no _OSC support" : "Run ACPI _OSC fails");
+		dev_printk(KERN_DEBUG, &pciedev->device, "AER service couldn't "
+			   "init device: %s\n",
+			   (status == AE_SUPPORT || status == AE_NOT_FOUND) ?
+			   "no _OSC support" : "_OSC failed");
 		return -1;
 	}
 
Index: work11/drivers/pci/pcie/aer/aerdrv_core.c
===================================================================
--- work11.orig/drivers/pci/pcie/aer/aerdrv_core.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/pcie/aer/aerdrv_core.c	2008-06-26 12:30:14.000000000 -0600
@@ -221,9 +221,9 @@ static void report_error_detected(struct
 			 * of a driver for this device is unaware of
 			 * its hw state.
 			 */
-			printk(KERN_DEBUG "Device ID[%s] has %s\n",
-					dev->dev.bus_id, (dev->driver) ?
-					"no AER-aware driver" : "no driver");
+			dev_printk(KERN_DEBUG, &dev->dev, "device has %s\n",
+				   dev->driver ?
+				   "no AER-aware driver" : "no driver");
 		}
 		return;
 	}
@@ -304,7 +304,7 @@ static pci_ers_result_t broadcast_error_
 {
 	struct aer_broadcast_data result_data;
 
-	printk(KERN_DEBUG "Broadcast %s message\n", error_mesg);
+	dev_printk(KERN_DEBUG, &dev->dev, "broadcast %s message\n", error_mesg);
 	result_data.state = state;
 	if (cb == report_error_detected)
 		result_data.result = PCI_ERS_RESULT_CAN_RECOVER;
@@ -404,18 +404,16 @@ static pci_ers_result_t reset_link(struc
 			data.aer_driver =
 				to_service_driver(aerdev->device.driver);
 		} else {
-			printk(KERN_DEBUG "No link-reset support to Device ID"
-				"[%s]\n",
-				dev->dev.bus_id);
+			dev_printk(KERN_DEBUG, &dev->dev, "no link-reset "
+				   "support\n");
 			return PCI_ERS_RESULT_DISCONNECT;
 		}
 	}
 
 	status = data.aer_driver->reset_link(udev);
 	if (status != PCI_ERS_RESULT_RECOVERED) {
-		printk(KERN_DEBUG "Link reset at upstream Device ID"
-			"[%s] failed\n",
-			udev->dev.bus_id);
+		dev_printk(KERN_DEBUG, &dev->dev, "link reset at upstream "
+			   "device %s failed\n", pci_name(udev));
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -511,10 +509,12 @@ static void handle_error_source(struct p
 	} else {
 		status = do_recovery(aerdev, dev, info.severity);
 		if (status == PCI_ERS_RESULT_RECOVERED) {
-			printk(KERN_DEBUG "AER driver successfully recovered\n");
+			dev_printk(KERN_DEBUG, &dev->dev, "AER driver "
+				   "successfully recovered\n");
 		} else {
 			/* TODO: Should kernel panic here? */
-			printk(KERN_DEBUG "AER driver didn't recover\n");
+			dev_printk(KERN_DEBUG, &dev->dev, "AER driver didn't "
+				   "recover\n");
 		}
 	}
 }

-- 
