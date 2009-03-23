Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZCWH7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZCWH7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCWH61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:58:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:44378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZCWH6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:58:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,407,1233561600"; 
   d="scan'208";a="396704188"
From: Yu Zhao <yu.zhao@intel.com>
To: dwmw2@infradead.org, jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v4 1/6] PCI: support the ATS capability
Date: Mon, 23 Mar 2009 15:58:57 +0800
Message-Id: <1237795142-6606-2-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
References: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe ATS capability makes the Endpoint be able to request the
DMA address translation from the IOMMU and cache the translation
in the device side, thus alleviate IOMMU TLB pressure and improve
the hardware performance in the I/O virtualization environment.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c        |  105 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |   37 ++++++++++++++++
 include/linux/pci.h      |    2 +
 include/linux/pci_regs.h |   10 ++++
 4 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 7227efc..8a9817c 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -5,6 +5,7 @@
  *
  * PCI Express I/O Virtualization (IOV) support.
  *   Single Root IOV 1.0
+ *   Address Translation Service 1.0
  */
 
 #include <linux/pci.h>
@@ -678,3 +679,107 @@ irqreturn_t pci_sriov_migration(struct pci_dev *dev)
 	return sriov_migration(dev) ? IRQ_HANDLED : IRQ_NONE;
 }
 EXPORT_SYMBOL_GPL(pci_sriov_migration);
+
+static int ats_alloc_one(struct pci_dev *dev, int pgshift)
+{
+	int pos;
+	u16 cap;
+	struct pci_ats *ats;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return -ENODEV;
+
+	ats = kzalloc(sizeof(*ats), GFP_KERNEL);
+	if (!ats)
+		return -ENOMEM;
+
+	ats->pos = pos;
+	ats->stu = pgshift;
+	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
+	ats->qdep = PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
+					    PCI_ATS_MAX_QDEP;
+	dev->ats = ats;
+
+	return 0;
+}
+
+static void ats_free_one(struct pci_dev *dev)
+{
+	kfree(dev->ats);
+	dev->ats = NULL;
+}
+
+/**
+ * pci_enable_ats - enable the ATS capability
+ * @dev: the PCI device
+ * @pgshift: the IOMMU page shift
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_enable_ats(struct pci_dev *dev, int pgshift)
+{
+	int rc;
+	u16 ctrl;
+
+	BUG_ON(dev->ats);
+
+	if (pgshift < PCI_ATS_MIN_STU)
+		return -EINVAL;
+
+	rc = ats_alloc_one(dev, pgshift);
+	if (rc)
+		return rc;
+
+	ctrl = PCI_ATS_CTRL_ENABLE;
+	ctrl |= PCI_ATS_CTRL_STU(pgshift - PCI_ATS_MIN_STU);
+	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
+
+	return 0;
+}
+
+/**
+ * pci_disable_ats - disable the ATS capability
+ * @dev: the PCI device
+ */
+void pci_disable_ats(struct pci_dev *dev)
+{
+	u16 ctrl;
+
+	BUG_ON(!dev->ats);
+
+	pci_read_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, &ctrl);
+	ctrl &= ~PCI_ATS_CTRL_ENABLE;
+	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl);
+
+	ats_free_one(dev);
+}
+
+/**
+ * pci_ats_queue_depth - query the ATS Invalidate Queue Depth
+ * @dev: the PCI device
+ *
+ * Returns the queue depth on success, or negative on failure.
+ *
+ * The ATS spec uses 0 in the Invalidate Queue Depth field to
+ * indicate that the function can accept 32 Invalidate Request.
+ * But here we use the `real' values (i.e. 1~32) for the Queue
+ * Depth.
+ */
+int pci_ats_queue_depth(struct pci_dev *dev)
+{
+	int pos;
+	u16 cap;
+
+	if (dev->ats)
+		return dev->ats->qdep;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return -ENODEV;
+
+	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
+
+	return PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
+				       PCI_ATS_MAX_QDEP;
+}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index dd7c63f..9f0db6a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -218,6 +218,13 @@ struct pci_sriov {
 	u8 __iomem *mstate;	/* VF Migration State Array */
 };
 
+/* Address Translation Service */
+struct pci_ats {
+	int pos;	/* capability position */
+	int stu;	/* Smallest Translation Unit */
+	int qdep;	/* Invalidate Queue Depth */
+};
+
 #ifdef CONFIG_PCI_IOV
 extern int pci_iov_init(struct pci_dev *dev);
 extern void pci_iov_release(struct pci_dev *dev);
@@ -225,6 +232,20 @@ extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 				enum pci_bar_type *type);
 extern void pci_restore_iov_state(struct pci_dev *dev);
 extern int pci_iov_bus_range(struct pci_bus *bus);
+
+extern int pci_enable_ats(struct pci_dev *dev, int pgshift);
+extern void pci_disable_ats(struct pci_dev *dev);
+extern int pci_ats_queue_depth(struct pci_dev *dev);
+/**
+ * pci_ats_enabled - query the ATS status
+ * @dev: the PCI device
+ *
+ * Returns 1 if ATS capability is enabled, or 0 if not.
+ */
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return !!dev->ats;
+}
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -246,6 +267,22 @@ static inline int pci_iov_bus_range(struct pci_bus *bus)
 {
 	return 0;
 }
+
+static inline int pci_enable_ats(struct pci_dev *dev, int pgshift)
+{
+	return -ENODEV;
+}
+static inline void pci_disable_ats(struct pci_dev *dev)
+{
+}
+static inline int pci_ats_queue_depth(struct pci_dev *dev)
+{
+	return -ENODEV;
+}
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return 0;
+}
 #endif /* CONFIG_PCI_IOV */
 
 #endif /* DRIVERS_PCI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index df78327..de80acd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -188,6 +188,7 @@ struct pci_cap_saved_state {
 struct pcie_link_state;
 struct pci_vpd;
 struct pci_sriov;
+struct pci_ats;
 
 /*
  * The pci_dev structure is used to describe PCI devices.
@@ -285,6 +286,7 @@ struct pci_dev {
 		struct pci_sriov *sriov;	/* SR-IOV capability related */
 		struct pci_dev *physfn;	/* the PF this VF is associated with */
 	};
+	struct pci_ats	*ats;	/* Address Translation Service */
 #endif
 };
 
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 4ce5eb0..999de5f 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -499,6 +499,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_ATS	15
 #define PCI_EXT_CAP_ID_SRIOV	16
 
 /* Advanced Error Reporting */
@@ -617,6 +618,15 @@
 #define  PCI_ARI_CTRL_ACS	0x0002	/* ACS Function Groups Enable */
 #define  PCI_ARI_CTRL_FG(x)	(((x) >> 4) & 7) /* Function Group */
 
+/* Address Translation Service */
+#define PCI_ATS_CAP		0x04	/* ATS Capability Register */
+#define  PCI_ATS_CAP_QDEP(x)	((x) & 0x1f)	/* Invalidate Queue Depth */
+#define  PCI_ATS_MAX_QDEP	32	/* Max Invalidate Queue Depth */
+#define PCI_ATS_CTRL		0x06	/* ATS Control Register */
+#define  PCI_ATS_CTRL_ENABLE	0x8000	/* ATS Enable */
+#define  PCI_ATS_CTRL_STU(x)	((x) & 0x1f)	/* Smallest Translation Unit */
+#define  PCI_ATS_MIN_STU	12	/* shift of minimum STU block */
+
 /* Single Root I/O Virtualization */
 #define PCI_SRIOV_CAP		0x04	/* SR-IOV Capabilities */
 #define  PCI_SRIOV_CAP_VFM	0x01	/* VF Migration Capable */
-- 
1.5.6.4

