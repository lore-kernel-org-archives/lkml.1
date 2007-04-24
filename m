Return-Path: <linux-kernel-owner+w=401wt.eu-S1161820AbXDXPIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161820AbXDXPIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161817AbXDXPIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:08:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:19686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161801AbXDXPI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218705930:sNHT66677716"
Message-Id: <20070424061037.508715000@intel.com>
References: <20070424060259.426374000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 23:03:01 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [Intel IOMMU][patch 2/8] Some generic search functions required to lookup device relationships.
Content-Disposition: inline; filename=pci-exp.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCI support functions for DMAR, to find parent bridge. 

When devices are under a p2p bridge, upstream
transactions get replaced by the device id of the bridge as it owns the 
PCIE transaction. Hence its necessary to setup translations on behalf of the 
bridge as well. Due to this limitation all devices under a p2p share the same
domain in a DMAR. 

We just cache the type of device, if its a native PCIe device
or not for later use.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
-------------------------------------------------

Index: 2.6.21-rc6/drivers/pci/pci.h
===================================================================
--- 2.6.21-rc6.orig/drivers/pci/pci.h	2007-04-06 10:36:56.000000000 +0800
+++ 2.6.21-rc6/drivers/pci/pci.h	2007-04-11 13:52:29.000000000 +0800
@@ -90,3 +90,4 @@ pci_match_one_device(const struct pci_de
 	return NULL;
 }
 
+struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
Index: 2.6.21-rc6/drivers/pci/probe.c
===================================================================
--- 2.6.21-rc6.orig/drivers/pci/probe.c	2007-04-06 10:36:56.000000000 +0800
+++ 2.6.21-rc6/drivers/pci/probe.c	2007-04-11 13:52:29.000000000 +0800
@@ -822,6 +822,19 @@ static void pci_release_dev(struct devic
 	kfree(pci_dev);
 }
 
+static void set_pcie_port_type(struct pci_dev *pdev)
+{
+	int pos;
+	u16 reg16;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	if (!pos)
+		return;
+	pdev->is_pcie = 1;
+	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
+	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
+}
+
 /**
  * pci_cfg_space_size - get the configuration space size of the PCI device.
  * @dev: PCI device
@@ -919,6 +932,7 @@ pci_scan_device(struct pci_bus *bus, int
 	dev->device = (l >> 16) & 0xffff;
 	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
+	set_pcie_port_type(dev);
 
 	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
 	   set this higher, assuming the system even supports it.  */
Index: 2.6.21-rc6/drivers/pci/search.c
===================================================================
--- 2.6.21-rc6.orig/drivers/pci/search.c	2007-04-06 10:36:56.000000000 +0800
+++ 2.6.21-rc6/drivers/pci/search.c	2007-04-11 13:52:29.000000000 +0800
@@ -14,6 +14,36 @@
 #include "pci.h"
 
 DECLARE_RWSEM(pci_bus_sem);
+/*
+ * find the upstream PCIE-to-PCI bridge of a PCI device
+ * if the device is PCIE, return NULL
+ * if the device isn't connected to a PCIE bridge (that is its parent is a
+ * legacy PCI bridge and the bridge is directly connected to bus 0), return its
+ * parent
+ */
+struct pci_dev *
+pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
+{
+	struct pci_dev *tmp = NULL;
+
+	if (pdev->is_pcie)
+		return NULL;
+	while (1) {
+		if (!pdev->bus->self)
+			break;
+		pdev = pdev->bus->self;
+		/* a p2p bridge */
+		if (!pdev->is_pcie) {
+			tmp = pdev;
+			continue;
+		}
+		/* PCI device should connect to a PCIE bridge */
+		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
+		return pdev;
+	}
+
+	return tmp;
+}
 
 static struct pci_bus *
 pci_do_find_bus(struct pci_bus* bus, unsigned char busnr)
Index: 2.6.21-rc6/include/linux/pci.h
===================================================================
--- 2.6.21-rc6.orig/include/linux/pci.h	2007-04-06 10:36:56.000000000 +0800
+++ 2.6.21-rc6/include/linux/pci.h	2007-04-11 13:52:29.000000000 +0800
@@ -126,6 +126,7 @@ struct pci_dev {
 	unsigned short	subsystem_device;
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
+	u8		pcie_type;	/* PCI-E device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
 
@@ -168,6 +169,7 @@ struct pci_dev {
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
+	unsigned int	is_pcie:1;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* config space saved at suspend time */

-- 
