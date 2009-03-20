Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZCTDZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZCTDZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZCTDYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:15421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZCTDYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042857"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 1/8] PCI: initialize and release SR-IOV capability
Date: Fri, 20 Mar 2009 11:25:11 +0800
Message-Id: <1237519518-24048-2-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a device has the SR-IOV capability, initialize it (set the ARI
Capable Hierarchy in the lowest numbered PF if necessary; calculate
the System Page Size for the VF MMIO, probe the VF Offset, Stride
and BARs). A lock for the VF bus allocation is also initialized if
a PF is the lowest numbered PF.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/Kconfig      |   10 +++
 drivers/pci/Makefile     |    2 +
 drivers/pci/iov.c        |  182 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.c        |    7 ++
 drivers/pci/pci.h        |   37 +++++++++
 drivers/pci/probe.c      |    4 +
 include/linux/pci.h      |   11 +++
 include/linux/pci_regs.h |   33 ++++++++
 8 files changed, 286 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/iov.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 2a4501d..fdc864f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -59,3 +59,13 @@ config HT_IRQ
 	   This allows native hypertransport devices to use interrupts.
 
 	   If unsure say Y.
+
+config PCI_IOV
+	bool "PCI IOV support"
+	depends on PCI
+	help
+	  I/O Virtualization is a PCI feature supported by some devices
+	  which allows them to create virtual devices which share their
+	  physical resources.
+
+	  If unsure, say N.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 3d07ce2..ba6af16 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -29,6 +29,8 @@ obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 
 obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
 
+obj-$(CONFIG_PCI_IOV) += iov.o
+
 #
 # Some architectures use the generic PCI setup functions
 #
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
new file mode 100644
index 0000000..66cc414
--- /dev/null
+++ b/drivers/pci/iov.c
@@ -0,0 +1,182 @@
+/*
+ * drivers/pci/iov.c
+ *
+ * Copyright (C) 2009 Intel Corporation, Yu Zhao <yu.zhao@intel.com>
+ *
+ * PCI Express I/O Virtualization (IOV) support.
+ *   Single Root IOV 1.0
+ */
+
+#include <linux/pci.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include "pci.h"
+
+
+static int sriov_init(struct pci_dev *dev, int pos)
+{
+	int i;
+	int rc;
+	int nres;
+	u32 pgsz;
+	u16 ctrl, total, offset, stride;
+	struct pci_sriov *iov;
+	struct resource *res;
+	struct pci_dev *pdev;
+
+	if (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
+	    dev->pcie_type != PCI_EXP_TYPE_ENDPOINT)
+		return -ENODEV;
+
+	pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl);
+	if (ctrl & PCI_SRIOV_CTRL_VFE) {
+		pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
+		ssleep(1);
+	}
+
+	pci_read_config_word(dev, pos + PCI_SRIOV_TOTAL_VF, &total);
+	if (!total)
+		return 0;
+
+	ctrl = 0;
+	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
+		if (pdev->is_physfn)
+			goto found;
+
+	pdev = NULL;
+	if (pci_ari_enabled(dev->bus))
+		ctrl |= PCI_SRIOV_CTRL_ARI;
+
+found:
+	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
+	pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, total);
+	pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
+	if (!offset || (total > 1 && !stride))
+		return -EIO;
+
+	pci_read_config_dword(dev, pos + PCI_SRIOV_SUP_PGSIZE, &pgsz);
+	i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
+	pgsz &= ~((1 << i) - 1);
+	if (!pgsz)
+		return -EIO;
+
+	pgsz &= ~(pgsz - 1);
+	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
+
+	nres = 0;
+	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		i += __pci_read_base(dev, pci_bar_unknown, res,
+				     pos + PCI_SRIOV_BAR + i * 4);
+		if (!res->flags)
+			continue;
+		if (resource_size(res) & (PAGE_SIZE - 1)) {
+			rc = -EIO;
+			goto failed;
+		}
+		res->end = res->start + resource_size(res) * total - 1;
+		nres++;
+	}
+
+	iov = kzalloc(sizeof(*iov), GFP_KERNEL);
+	if (!iov) {
+		rc = -ENOMEM;
+		goto failed;
+	}
+
+	iov->pos = pos;
+	iov->nres = nres;
+	iov->ctrl = ctrl;
+	iov->total = total;
+	iov->offset = offset;
+	iov->stride = stride;
+	iov->pgsz = pgsz;
+	iov->self = dev;
+	pci_read_config_dword(dev, pos + PCI_SRIOV_CAP, &iov->cap);
+	pci_read_config_byte(dev, pos + PCI_SRIOV_FUNC_LINK, &iov->link);
+
+	if (pdev)
+		iov->dev = pci_dev_get(pdev);
+	else {
+		iov->dev = dev;
+		mutex_init(&iov->lock);
+	}
+
+	dev->sriov = iov;
+	dev->is_physfn = 1;
+
+	return 0;
+
+failed:
+	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		res->flags = 0;
+	}
+
+	return rc;
+}
+
+static void sriov_release(struct pci_dev *dev)
+{
+	if (dev == dev->sriov->dev)
+		mutex_destroy(&dev->sriov->lock);
+	else
+		pci_dev_put(dev->sriov->dev);
+
+	kfree(dev->sriov);
+	dev->sriov = NULL;
+}
+
+/**
+ * pci_iov_init - initialize the IOV capability
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_iov_init(struct pci_dev *dev)
+{
+	int pos;
+
+	if (!dev->is_pcie)
+		return -ENODEV;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_SRIOV);
+	if (pos)
+		return sriov_init(dev, pos);
+
+	return -ENODEV;
+}
+
+/**
+ * pci_iov_release - release resources used by the IOV capability
+ * @dev: the PCI device
+ */
+void pci_iov_release(struct pci_dev *dev)
+{
+	if (dev->is_physfn)
+		sriov_release(dev);
+}
+
+/**
+ * pci_iov_resource_bar - get position of the SR-IOV BAR
+ * @dev: the PCI device
+ * @resno: the resource number
+ * @type: the BAR type to be filled in
+ *
+ * Returns position of the BAR encapsulated in the SR-IOV capability.
+ */
+int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+			 enum pci_bar_type *type)
+{
+	if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCE_END)
+		return 0;
+
+	BUG_ON(!dev->is_physfn);
+
+	*type = pci_bar_unknown;
+
+	return dev->sriov->pos + PCI_SRIOV_BAR +
+		4 * (resno - PCI_IOV_RESOURCES);
+}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d61200..2eba2a5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2346,12 +2346,19 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
  */
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 {
+	int reg;
+
 	if (resno < PCI_ROM_RESOURCE) {
 		*type = pci_bar_unknown;
 		return PCI_BASE_ADDRESS_0 + 4 * resno;
 	} else if (resno == PCI_ROM_RESOURCE) {
 		*type = pci_bar_mem32;
 		return dev->rom_base_reg;
+	} else if (resno < PCI_BRIDGE_RESOURCES) {
+		/* device specific resource */
+		reg = pci_iov_resource_bar(dev, resno, type);
+		if (reg)
+			return reg;
 	}
 
 	dev_err(&dev->dev, "BAR: invalid resource #%d\n", resno);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 07c0aa5..196be5e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -195,4 +195,41 @@ static inline int pci_ari_enabled(struct pci_bus *bus)
 	return bus->self && bus->self->ari_enabled;
 }
 
+/* Single Root I/O Virtualization */
+struct pci_sriov {
+	int pos;		/* capability position */
+	int nres;		/* number of resources */
+	u32 cap;		/* SR-IOV Capabilities */
+	u16 ctrl;		/* SR-IOV Control */
+	u16 total;		/* total VFs associated with the PF */
+	u16 offset;		/* first VF Routing ID offset */
+	u16 stride;		/* following VF stride */
+	u32 pgsz;		/* page size for BAR alignment */
+	u8 link;		/* Function Dependency Link */
+	struct pci_dev *dev;	/* lowest numbered PF */
+	struct pci_dev *self;	/* this PF */
+	struct mutex lock;	/* lock for VF bus */
+};
+
+#ifdef CONFIG_PCI_IOV
+extern int pci_iov_init(struct pci_dev *dev);
+extern void pci_iov_release(struct pci_dev *dev);
+extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+				enum pci_bar_type *type);
+#else
+static inline int pci_iov_init(struct pci_dev *dev)
+{
+	return -ENODEV;
+}
+static inline void pci_iov_release(struct pci_dev *dev)
+
+{
+}
+static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
+				       enum pci_bar_type *type)
+{
+	return 0;
+}
+#endif /* CONFIG_PCI_IOV */
+
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 55ec44a..03b6f29 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -785,6 +785,7 @@ static int pci_setup_device(struct pci_dev * dev)
 static void pci_release_capabilities(struct pci_dev *dev)
 {
 	pci_vpd_release(dev);
+	pci_iov_release(dev);
 }
 
 /**
@@ -972,6 +973,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Alternative Routing-ID Forwarding */
 	pci_enable_ari(dev);
+
+	/* Single Root I/O Virtualization */
+	pci_iov_init(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7bd624b..01eed8f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -93,6 +93,12 @@ enum {
 	/* #6: expansion ROM resource */
 	PCI_ROM_RESOURCE,
 
+	/* device specific resources */
+#ifdef CONFIG_PCI_IOV
+	PCI_IOV_RESOURCES,
+	PCI_IOV_RESOURCE_END = PCI_IOV_RESOURCES + PCI_SRIOV_NUM_BARS - 1,
+#endif
+
 	/* resources assigned to buses behind the bridge */
 #define PCI_BRIDGE_RESOURCE_NUM 4
 
@@ -180,6 +186,7 @@ struct pci_cap_saved_state {
 
 struct pcie_link_state;
 struct pci_vpd;
+struct pci_sriov;
 
 /*
  * The pci_dev structure is used to describe PCI devices.
@@ -257,6 +264,7 @@ struct pci_dev {
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
 	unsigned int	state_saved:1;
+	unsigned int	is_physfn:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
@@ -270,6 +278,9 @@ struct pci_dev {
 	struct list_head msi_list;
 #endif
 	struct pci_vpd *vpd;
+#ifdef CONFIG_PCI_IOV
+	struct pci_sriov *sriov;	/* SR-IOV capability related */
+#endif
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 027815b..4ce5eb0 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -375,6 +375,7 @@
 #define  PCI_EXP_TYPE_UPSTREAM	0x5	/* Upstream Port */
 #define  PCI_EXP_TYPE_DOWNSTREAM 0x6	/* Downstream Port */
 #define  PCI_EXP_TYPE_PCI_BRIDGE 0x7	/* PCI/PCI-X Bridge */
+#define  PCI_EXP_TYPE_RC_END	0x9	/* Root Complex Integrated Endpoint */
 #define PCI_EXP_FLAGS_SLOT	0x0100	/* Slot implemented */
 #define PCI_EXP_FLAGS_IRQ	0x3e00	/* Interrupt message number */
 #define PCI_EXP_DEVCAP		4	/* Device capabilities */
@@ -498,6 +499,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_SRIOV	16
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -615,4 +617,35 @@
 #define  PCI_ARI_CTRL_ACS	0x0002	/* ACS Function Groups Enable */
 #define  PCI_ARI_CTRL_FG(x)	(((x) >> 4) & 7) /* Function Group */
 
+/* Single Root I/O Virtualization */
+#define PCI_SRIOV_CAP		0x04	/* SR-IOV Capabilities */
+#define  PCI_SRIOV_CAP_VFM	0x01	/* VF Migration Capable */
+#define  PCI_SRIOV_CAP_INTR(x)	((x) >> 21) /* Interrupt Message Number */
+#define PCI_SRIOV_CTRL		0x08	/* SR-IOV Control */
+#define  PCI_SRIOV_CTRL_VFE	0x01	/* VF Enable */
+#define  PCI_SRIOV_CTRL_VFM	0x02	/* VF Migration Enable */
+#define  PCI_SRIOV_CTRL_INTR	0x04	/* VF Migration Interrupt Enable */
+#define  PCI_SRIOV_CTRL_MSE	0x08	/* VF Memory Space Enable */
+#define  PCI_SRIOV_CTRL_ARI	0x10	/* ARI Capable Hierarchy */
+#define PCI_SRIOV_STATUS	0x0a	/* SR-IOV Status */
+#define  PCI_SRIOV_STATUS_VFM	0x01	/* VF Migration Status */
+#define PCI_SRIOV_INITIAL_VF	0x0c	/* Initial VFs */
+#define PCI_SRIOV_TOTAL_VF	0x0e	/* Total VFs */
+#define PCI_SRIOV_NUM_VF	0x10	/* Number of VFs */
+#define PCI_SRIOV_FUNC_LINK	0x12	/* Function Dependency Link */
+#define PCI_SRIOV_VF_OFFSET	0x14	/* First VF Offset */
+#define PCI_SRIOV_VF_STRIDE	0x16	/* Following VF Stride */
+#define PCI_SRIOV_VF_DID	0x1a	/* VF Device ID */
+#define PCI_SRIOV_SUP_PGSIZE	0x1c	/* Supported Page Sizes */
+#define PCI_SRIOV_SYS_PGSIZE	0x20	/* System Page Size */
+#define PCI_SRIOV_BAR		0x24	/* VF BAR0 */
+#define  PCI_SRIOV_NUM_BARS	6	/* Number of VF BARs */
+#define PCI_SRIOV_VFM		0x3c	/* VF Migration State Array Offset*/
+#define  PCI_SRIOV_VFM_BIR(x)	((x) & 7)	/* State BIR */
+#define  PCI_SRIOV_VFM_OFFSET(x) ((x) & ~7)	/* State Offset */
+#define  PCI_SRIOV_VFM_UA	0x0	/* Inactive.Unavailable */
+#define  PCI_SRIOV_VFM_MI	0x1	/* Dormant.MigrateIn */
+#define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
+#define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
+
 #endif /* LINUX_PCI_REGS_H */
-- 
1.5.6.4

