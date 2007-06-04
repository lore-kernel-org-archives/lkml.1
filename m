Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbXFDWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbXFDWbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbXFDWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:30:37 -0400
Received: from mga05.intel.com ([192.55.52.89]:22013 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759274AbXFDWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:30:35 -0400
X-ExtLoopCount2: 2 from 172.25.110.8
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="253153849"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="93415250"
Message-Id: <20070604210644.237004000@askeshav-devel.jf.intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jun 2007 14:02:45 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 03/10] PCI generic helper function
Content-Disposition: inline; filename=pcie_port_type.patch
X-OriginalArrivalTime: 04 Jun 2007 21:23:57.0821 (UTC) FILETIME=[A96C1AD0:01C7A6EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When devices are under a p2p bridge, upstream
transactions get replaced by the device id of the bridge as it owns the
PCIE transaction. Hence its necessary to setup translations on behalf of the
bridge as well. Due to this limitation all devices under a p2p share the same
domain in a DMAR.

We just cache the type of device, if its a native PCIe device
or not for later use.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 drivers/pci/pci.h    |    1 +
 drivers/pci/probe.c  |   14 ++++++++++++++
 drivers/pci/search.c |   30 ++++++++++++++++++++++++++++++
 include/linux/pci.h  |    2 ++
 4 files changed, 47 insertions(+)

Index: linux-2.6.22-rc3/drivers/pci/pci.h
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/pci.h	2007-06-04 12:27:34.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/pci.h	2007-06-04 12:36:31.000000000 -0700
@@ -92,3 +92,4 @@
 	return NULL;
 }
 
+struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
Index: linux-2.6.22-rc3/drivers/pci/probe.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/probe.c	2007-06-04 12:27:34.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/probe.c	2007-06-04 12:36:31.000000000 -0700
@@ -803,6 +803,19 @@
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
@@ -917,6 +930,7 @@
 	dev->device = (l >> 16) & 0xffff;
 	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
+	set_pcie_port_type(dev);
 
 	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
 	   set this higher, assuming the system even supports it.  */
Index: linux-2.6.22-rc3/drivers/pci/search.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/search.c	2007-06-04 12:27:34.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/search.c	2007-06-04 12:36:31.000000000 -0700
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
 
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
Index: linux-2.6.22-rc3/include/linux/pci.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/pci.h	2007-06-04 12:27:34.000000000 -0700
+++ linux-2.6.22-rc3/include/linux/pci.h	2007-06-04 12:36:31.000000000 -0700
@@ -139,6 +139,7 @@
 	unsigned short	subsystem_device;
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
+	u8		pcie_type;	/* PCI-E device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
 
@@ -181,6 +182,7 @@
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
+	unsigned int	is_pcie:1;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* config space saved at suspend time */

-- 
