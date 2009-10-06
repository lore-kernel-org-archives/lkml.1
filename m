Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbZJFUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbZJFUhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933240AbZJFUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:37:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:63523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183AbZJFUhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,514,1249282800"; 
   d="scan'208";a="455061730"
From: Allen Kay <allen.m.kay@intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx, chris@sous-sol.org,
       jeremy@goop.org, Allen Kay <allen.m.kay@intel.com>
Subject: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Date: Tue,  6 Oct 2009 13:33:46 -0700
Message-Id: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
        - enable ACS only if iommu is enabled or if kernel is running as xen dom0
        - changed xen_domain_type from enum to #define to allow it to be used
          in pci/probe.c and to avoid excessive changes to code structure.

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
Reviewed--by: Mathew Wilcox <willy@linux.intel.com>
Reviewed--by: Chris Wright <chris@sous-sol.org>

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
---
 arch/x86/include/asm/xen/hypervisor.h |   10 +++-----
 arch/x86/xen/enlighten.c              |    2 +-
 drivers/pci/dmar.c                    |    1 +
 drivers/pci/pci.c                     |   35 +++++++++++++++++++++++++++++++++
 drivers/pci/pci.h                     |   10 +++++++++
 drivers/pci/probe.c                   |   11 ++++++++++
 include/linux/dmar.h                  |    2 +-
 include/linux/pci_regs.h              |   13 ++++++++++++
 8 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index d5b7e90..a1e65dd 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,14 +37,12 @@
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
-enum xen_domain_type {
-	XEN_NATIVE,		/* running on bare hardware    */
-	XEN_PV_DOMAIN,		/* running in a PV domain      */
-	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
-};
+#define XEN_NATIVE	0	/* running on bare hardware    */
+#define XEN_PV_DOMAIN	1	/* running in a PV domain      */
+#define XEN_HVM_DOMAIN	2	/* running in a Xen hvm domain */
 
 #ifdef CONFIG_XEN
-extern enum xen_domain_type xen_domain_type;
+extern int xen_domain_type;
 #else
 #define xen_domain_type		XEN_NATIVE
 #endif
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 3439616..b263e85 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(hypercall_page);
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 
-enum xen_domain_type xen_domain_type = XEN_NATIVE;
+int xen_domain_type = XEN_NATIVE;
 EXPORT_SYMBOL_GPL(xen_domain_type);
 
 struct start_info *xen_start_info;
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 22b02c6..814faa3 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
+#include "pci.h"
 
 #define PREFIX "DMAR: "
 
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
index d92d195..5b3a8f9 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -311,4 +311,14 @@ static inline int pci_resource_alignment(struct pci_dev *dev,
 	return resource_alignment(res);
 }
 
+extern void pci_enable_acs(struct pci_dev *dev);
+
+#ifdef CONFIG_DMAR
+extern int iommu_detected;
+#endif
+
+#ifdef CONFIG_XEN
+extern int xen_domain_type;
+#endif
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..32703c7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1014,6 +1014,17 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Single Root I/O Virtualization */
 	pci_iov_init(dev);
+
+	/* Enable ACS P2P upstream forwarding if HW iommu is detected */
+	if (iommu_detected)
+		pci_enable_acs(dev);
+
+#ifdef CONFIG_XEN
+	/* HW iommu is not visible in xen dom0 */
+	if (xen_domain_type)
+		pci_enable_acs(dev);
+#endif
+
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 69a6fba..d13c21c 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -196,7 +196,7 @@ extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
 #ifdef CONFIG_DMAR
-extern int iommu_detected, no_iommu;
+extern int no_iommu;
 extern struct list_head dmar_rmrr_units;
 struct dmar_rmrr_unit {
 	struct list_head list;		/* list of rmrr units	*/
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

