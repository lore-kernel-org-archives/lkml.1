Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXJXCpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXJXCpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbXJXCpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:45:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:8235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXJXCo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:44:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,322,1188802800"; 
   d="scan'208";a="356462840"
Subject: [RFC] pcie port driver: fix something inconsist with spec
From: Shaohua Li <shaohua.li@intel.com>
To: linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 10:44:19 +0800
Message-Id: <1193193859.27150.16.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The port driver interrupt assignment has two issues for MSI-X:
1. PME and HP share an interrupt, VC hasn't interrupt and only root port and event collector has interrupt for AER.
2. For each capability, its interrupt should be read from specific PCI config register per spec.

This is true for multiple vector MSI, but as we didn't support it so far, I just ignore it.

Note, this is just passed compiling, I can't find a root port which supports MSI-X.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/pci/pcie/portdrv_core.c |   70 +++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 12 deletions(-)

Index: linux/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux.orig/drivers/pci/pcie/portdrv_core.c	2007-10-22 09:41:25.000000000 +0800
+++ linux/drivers/pci/pcie/portdrv_core.c	2007-10-22 14:54:36.000000000 +0800
@@ -128,7 +128,62 @@ static int is_msi_quirked(struct pci_dev
 	}
 	return quirk;
 }
-	
+
+static int assign_msix_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
+{
+	struct msix_entry msix_entries[2] = {{0, 0}, {0, 1}};
+	int nvec = 0;
+	int status;
+	int pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	u16 reg;
+	int i;
+
+	pci_read_config_word(dev, pos + PCIE_CAPABILITIES_REG, &reg);
+	/*
+	 * PME and HP share an interrupt, VC hasn't interrupt, so we needs 2
+	 * interrupts at most
+	 */
+	if (mask & (PCIE_PORT_SERVICE_PME|PCIE_PORT_SERVICE_HP))
+		nvec ++;
+	/* root port needs interrupt */
+	if ((mask & PCIE_PORT_SERVICE_AER)
+		 && ((reg >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT)
+			nvec ++;
+
+	status = pci_enable_msix(dev, msix_entries, nvec);
+	if (status)
+		return status;
+
+	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
+		if (!(mask & (1 << i)))
+			continue;
+		if (mask & (PCIE_PORT_SERVICE_PME|PCIE_PORT_SERVICE_HP)) {
+			u16 reg16;
+
+			pci_read_config_word(dev,
+				pos + PCIE_CAPABILITIES_REG, &reg16);
+			reg16 = (reg16 & PCI_EXP_FLAGS_IRQ) >> 9;
+			BUG_ON(reg16 >= nvec);
+			vectors[i] = msix_entries[reg16].vector;
+			printk("Capability %d uses %d MSI-X entry\n", i, reg16);
+		}
+		if ((mask & PCIE_PORT_SERVICE_AER)
+		   && ((reg >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT) {
+			u32 reg32;
+			int aer_pos = pci_find_ext_capability(dev,
+				PCI_EXT_CAP_ID_ERR);
+
+			pci_read_config_dword(dev,
+				aer_pos + PCI_ERR_ROOT_STATUS, &reg32);
+			reg32 >>= 27;
+			BUG_ON(reg32 >= nvec);
+			vectors[i] = msix_entries[reg32].vector;
+			printk("Capability %d uses %d MSI-X entry\n", i, reg32);
+		}
+	}
+	return 0;
+}
+
 static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 {
 	int i, pos, nvec, status = -EINVAL;
@@ -148,19 +203,10 @@ static int assign_interrupt_mode(struct 
 	/* Select MSI-X over MSI if supported */		
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
 	if (pos) {
-		struct msix_entry msix_entries[PCIE_PORT_DEVICE_MAXSERVICES] = 
-			{{0, 0}, {0, 1}, {0, 2}, {0, 3}};
 		printk("%s Found MSIX capability\n", __FUNCTION__);
-		status = pci_enable_msix(dev, msix_entries, nvec);
-		if (!status) {
-			int j = 0;
-
+		status = assign_msix_interrupt_mode(dev, vectors, mask);
+		if (!status)
 			interrupt_mode = PCIE_PORT_MSIX_MODE;
-			for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
-				if (mask & (1 << i)) 
-					vectors[i] = msix_entries[j++].vector;
-			}
-		}
 	} 
 	if (status) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
