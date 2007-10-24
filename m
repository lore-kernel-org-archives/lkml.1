Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXJXCp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXJXCp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXJXCpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:45:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:52803 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbXJXCpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:45:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,322,1188802800"; 
   d="scan'208";a="184276214"
Subject: [patch] pcie: utilize pcie transaction pending bit
From: Shaohua Li <shaohua.li@intel.com>
To: linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 10:45:08 +0800
Message-Id: <1193193908.27150.17.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCIE has a mechanism to wait for Non-Posted request to complete. I think
pci_disable_device is a good place to do this.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/pci/pci.c   |   21 +++++++++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 23 insertions(+)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c	2007-10-17 10:33:48.000000000 +0800
+++ linux/drivers/pci/pci.c	2007-10-22 14:22:53.000000000 +0800
@@ -314,6 +314,24 @@ int pci_find_ht_capability(struct pci_de
 }
 EXPORT_SYMBOL_GPL(pci_find_ht_capability);
 
+void pcie_wait_pending_transaction(struct pci_dev *dev)
+{
+	int pos;
+	u16 reg16;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!pos)
+		return;
+	while (1) {
+		pci_read_config_word(dev, pos + PCI_EXP_DEVSTA, &reg16);
+		if (!(reg16 & PCI_EXP_DEVSTA_TRPND))
+			break;
+		cpu_relax();
+	}
+
+}
+EXPORT_SYMBOL_GPL(pcie_wait_pending_transaction);
+
 /**
  * pci_find_parent_resource - return resource region of parent bus of given region
  * @dev: PCI device structure contains resources to be searched
@@ -884,6 +902,9 @@ pci_disable_device(struct pci_dev *dev)
 	if (atomic_sub_return(1, &dev->enable_cnt) != 0)
 		return;
 
+	/* Wait for all transactions are finished before disabling the device */
+	pcie_wait_pending_transaction(dev);
+
 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
 	if (pci_command & PCI_COMMAND_MASTER) {
 		pci_command &= ~PCI_COMMAND_MASTER;
Index: linux/include/linux/pci.h
===================================================================
--- linux.orig/include/linux/pci.h	2007-10-17 10:33:52.000000000 +0800
+++ linux/include/linux/pci.h	2007-10-22 14:19:56.000000000 +0800
@@ -484,6 +484,7 @@ int pci_find_next_capability (struct pci
 int pci_find_ext_capability (struct pci_dev *dev, int cap);
 int pci_find_ht_capability (struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability (struct pci_dev *dev, int pos, int ht_cap);
+void pcie_wait_pending_transaction(struct pci_dev *dev);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
 
 struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
@@ -749,6 +750,7 @@ static inline void pci_unregister_driver
 static inline int pci_find_capability (struct pci_dev *dev, int cap) {return 0; }
 static inline int pci_find_next_capability (struct pci_dev *dev, u8 post, int cap) { return 0; }
 static inline int pci_find_ext_capability (struct pci_dev *dev, int cap) {return 0; }
+static inline void pcie_wait_pending_transaction(struct pci_dev *dev) {}
 static inline const struct pci_device_id *pci_match_device(const struct pci_device_id *ids, const struct pci_dev *dev) { return NULL; }
 
 /* Power management related routines */
