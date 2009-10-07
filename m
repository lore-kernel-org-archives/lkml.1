Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZJGRbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZJGRbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZJGRbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:31:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:1602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZJGRbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:31:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,520,1249282800"; 
   d="scan'208";a="557401265"
From: Allen Kay <allen.m.kay@intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx, chris@sous-sol.org,
       jeremy@goop.org, don.dugger@intel.com,
       Allen Kay <allen.m.kay@intel.com>
Subject: [ACS PATCH v5 1/2] acs p2p upsteram forwarding enabling
Date: Wed,  7 Oct 2009 10:27:17 -0700
Message-Id: <1254936437-18577-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: dom0 checking in v4 has been separated out into 2/2.

This patch enables P2P upstream forwarding in ACS capable PCIe switches.
It solves two potential problems in virtualization environment where a PCIe 
device is assigned to a guest domain using a HW iommu such as VT-d:

1) Unintentional failure caused by guest physical address programmed
   into the device's DMA that happens to match the memory address range
   of other downstream ports in the same PCIe switch.  This causes the PCI
   transaction to go to the matching downstream port instead of go to the
   root complex to get translated by VT-d as it should be.

2) Malicious guest software intentionally attacks another downstream
   PCIe device by programming the DMA address into the assigned device
   that matches memory address range of the downstream PCIe port.

We are in process of implementing device filtering software in KVM/XEN 
management software to allow device assignment of PCIe devices behind a PCIe 
switch only if it has ACS capability and with the P2P upstream forwarding bits 
enabled.  This patch is intended to work for both KVM and Xen environments.

Changes from initial to v1:
        - removed #define ACS_ENABLE and dev_info() call
        - changed ctrl value setting without using if-condition
        - fixed ACS #defines in pci_regs.h

Changes from v2 to v3:
        - change #define indention to 2 for PCI reg and 1 for bit
          position

Changes from v3 to v4:
        - enable ACS only if iommu is enabled or if kernel is xen dom0
        - changed xen_domain_type from enum to #define to allow it to be used
          in pci/probe.c and to avoid excessive changes to code structure.

Changes from v4 to v5:
	- separate out dom0 checking out of v4
	- use iommu_found() for detecting HW iommu presence

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
Reviewed--by: Mathew Wilcox <willy@linux.intel.com>
Reviewed--by: Chris Wright <chris@sous-sol.org>
---
 drivers/pci/pci.c        |   35 +++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    2 ++
 drivers/pci/probe.c      |    5 +++++
 include/linux/pci_regs.h |   13 +++++++++++++
 4 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6edecff..ec61c76 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1533,6 +1533,41 @@ void pci_enable_ari(struct pci_dev *dev)
 }
 
 /**
+ * pci_enable_acs - enable ACS if hardware support it
+ * @dev: the PCI device
+ */
+void pci_enable_acs(struct pci_dev *dev)
+{
+	int pos;
+	u16 cap;
+	u16 ctrl;
+
+	if (!dev->is_pcie)
+		return;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		return;
+
+	pci_read_config_word(dev, pos + PCI_ACS_CAP, &cap);
+	pci_read_config_word(dev, pos + PCI_ACS_CTRL, &ctrl);
+
+	/* Source Validation */
+	ctrl |= (cap & PCI_ACS_SV);
+
+	/* P2P Request Redirect */
+	ctrl |= (cap & PCI_ACS_RR);
+
+	/* P2P Completion Redirect */
+	ctrl |= (cap & PCI_ACS_CR);
+
+	/* Upstream Forwarding */
+	ctrl |= (cap & PCI_ACS_UF);
+
+	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
+}
+
+/**
  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
  * @dev: the PCI device
  * @pin: the INTx pin (1=INTA, 2=INTB, 3=INTD, 4=INTD)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d92d195..33ed8e0 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -311,4 +311,6 @@ static inline int pci_resource_alignment(struct pci_dev *dev,
 	return resource_alignment(res);
 }
 
+extern void pci_enable_acs(struct pci_dev *dev);
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..aa98258 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/cpumask.h>
 #include <linux/pci-aspm.h>
+#include <linux/iommu.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -1014,6 +1015,10 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Single Root I/O Virtualization */
 	pci_iov_init(dev);
+
+	/* Enable ACS P2P upstream forwarding */
+	if (iommu_found())
+		pci_enable_acs(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index dd0bed4..d798770 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -502,6 +502,7 @@
 #define PCI_EXT_CAP_ID_VC	2
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
+#define PCI_EXT_CAP_ID_ACS	13
 #define PCI_EXT_CAP_ID_ARI	14
 #define PCI_EXT_CAP_ID_ATS	15
 #define PCI_EXT_CAP_ID_SRIOV	16
@@ -662,4 +663,16 @@
 #define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
 #define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
 
+/* Access Control Service */
+#define PCI_ACS_CAP		0x04	/* ACS Capability Register */
+#define  PCI_ACS_SV		0x01	/* Source Validation */
+#define  PCI_ACS_TB		0x02	/* Translation Blocking */
+#define  PCI_ACS_RR		0x04	/* P2P Request Redirect */
+#define  PCI_ACS_CR		0x08	/* P2P Completion Redirect */
+#define  PCI_ACS_UF		0x10	/* Upstream Forwarding */
+#define  PCI_ACS_EC		0x20	/* P2P Egress Control */
+#define  PCI_ACS_DT		0x40	/* Direct Translated P2P */
+#define PCI_ACS_CTRL		0x06	/* ACS Control Register */
+#define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
+
 #endif /* LINUX_PCI_REGS_H */
-- 
1.6.0.6

