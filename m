Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZBSRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZBSRLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZBSRLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:11:10 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12380 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbZBSRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:11:09 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH] PCI: Enable PCIe AER only after checking firmware support
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: andrew.patterson@hp.com
Date: Thu, 19 Feb 2009 10:11:07 -0700
Message-ID: <20090219171107.26521.7298.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: Enable PCIe AER only after checking firmware support

The PCIe port driver currently sets the PCIe AER error reporting bits for
any root or switch port without first checking to see if firmware will grant
control. This patch moves setting these bits to the AER service driver
aer_enable_port routine.  The bits are then set for the root port and any
downstream switch ports after the check for firmware support (aer_osc_setup)
is made. The patch also unsets the bits in a similar fashion when the AER
service driver is unloaded.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 872ea7d..2070830 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -108,6 +108,35 @@ int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
 }
 #endif  /*  0  */
 
+
+static void set_device_error_reporting(struct pci_dev *dev, void *data)
+{
+	bool enable = *((bool *)data);
+
+	if (dev->pcie_type != PCIE_RC_PORT &&
+	    dev->pcie_type != PCIE_SW_UPSTREAM_PORT &&
+	    dev->pcie_type != PCIE_SW_DOWNSTREAM_PORT)
+		return;
+
+	if (enable)
+		pci_enable_pcie_error_reporting(dev);
+	else
+		pci_disable_pcie_error_reporting(dev);
+}
+
+/**
+ * set_downstream_devices_error_reporting - enable/disable the error reporting
+ * bits on the root port and its downstream ports.
+ * @dev: pointer to root port's pci_dev data structure
+ * @enable: true = enable error reporting, false = disable error reporting.
+ */
+static void set_downstream_devices_error_reporting(struct pci_dev *dev,
+						   bool enable)
+{
+	set_device_error_reporting(dev, &enable);
+	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
+}
+
 static int find_device_iter(struct device *device, void *data)
 {
 	struct pci_dev *dev;
@@ -525,15 +554,11 @@ void aer_enable_rootport(struct aer_rpc *rpc)
 	pci_read_config_dword(pdev, aer_pos + PCI_ERR_UNCOR_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer_pos + PCI_ERR_UNCOR_STATUS, reg32);
 
-	/* Enable Root Port device reporting error itself */
-	pci_read_config_word(pdev, pos+PCI_EXP_DEVCTL, &reg16);
-	reg16 = reg16 |
-		PCI_EXP_DEVCTL_CERE |
-		PCI_EXP_DEVCTL_NFERE |
-		PCI_EXP_DEVCTL_FERE |
-		PCI_EXP_DEVCTL_URRE;
-	pci_write_config_word(pdev, pos+PCI_EXP_DEVCTL,
-		reg16);
+	/*
+	 * Enable error reporting for the root port device and downstream port
+	 * devices.
+	 */
+	set_downstream_devices_error_reporting(pdev, true);
 
 	/* Enable Root Port's interrupt in response to error messages */
 	pci_write_config_dword(pdev,
@@ -553,6 +578,12 @@ static void disable_root_aer(struct aer_rpc *rpc)
 	u32 reg32;
 	int pos;
 
+	/*
+	 * Disable error reporting for the root port device and downstream port
+	 * devices.
+	 */
+	set_downstream_devices_error_reporting(pdev, false);
+
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
 	/* Disable Root's interrupt in response to error messages */
 	pci_write_config_dword(pdev, pos + PCI_ERR_ROOT_COMMAND, 0);
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 32ab6dd..db8700b 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -87,8 +87,6 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
 
 	pci_save_state(dev);
 
-	pci_enable_pcie_error_reporting(dev);
-
 	return 0;
 }
 

