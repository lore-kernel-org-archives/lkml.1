Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbZAREVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbZAREVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZAREVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:21:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:46484 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbZAREVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:21:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,282,1231142400"; 
   d="scan'208";a="101153950"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v2 1/6] PCI: support the ATS capability
Date: Sun, 18 Jan 2009 12:17:29 +0800
Message-Id: <1232252254-7614-2-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1232252254-7614-1-git-send-email-yu.zhao@intel.com>
References: <1232252254-7614-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ATS spec can be found at http://www.pcisig.com/specifications/iov/ats/
(it requires membership).

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/pci.c        |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h      |   15 ++++++++++
 include/linux/pci_regs.h |   10 +++++++
 3 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e491fde..243e61c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1411,6 +1411,74 @@ void pci_enable_ari(struct pci_dev *dev)
 }
 
 /**
+ * pci_enable_ats - enable the ATS capability
+ * @dev: the PCI device
+ * @ps: the IOMMU page shift
+ *
+ * Returns 0 on success, or a negative value on error.
+ */
+int pci_enable_ats(struct pci_dev *dev, int ps)
+{
+	int pos;
+	u16 ctrl;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return -ENODEV;
+
+	if (ps < PCI_ATS_MIN_STU)
+		return -EINVAL;
+
+	ctrl = PCI_ATS_CTRL_STU(ps - PCI_ATS_MIN_STU) | PCI_ATS_CTRL_ENABLE;
+	pci_write_config_word(dev, pos + PCI_ATS_CTRL, ctrl);
+
+	dev->ats_enabled = 1;
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
+	int pos;
+	u16 ctrl;
+
+	if (!dev->ats_enabled)
+		return;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return;
+
+	pci_read_config_word(dev, pos + PCI_ATS_CTRL, &ctrl);
+	ctrl &= ~PCI_ATS_CTRL_ENABLE;
+	pci_write_config_word(dev, pos + PCI_ATS_CTRL, ctrl);
+}
+
+/**
+ * pci_ats_qdep - query ATS invalidate queue depth
+ * @dev: the PCI device
+ *
+ * Returns the queue depth on success, or 0 on error.
+ */
+int pci_ats_qdep(struct pci_dev *dev)
+{
+	int pos;
+	u16 cap;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS);
+	if (!pos)
+		return 0;
+
+	pci_read_config_word(dev, pos + PCI_ATS_CAP, &cap);
+
+	return PCI_ATS_CAP_QDEP(cap) ? : PCI_ATS_MAX_QDEP;
+}
+
+/**
  * pci_swizzle_interrupt_pin - swizzle INTx for device behind bridge
  * @dev: the PCI device
  * @pin: the INTx pin (1=INTA, 2=INTB, 3=INTD, 4=INTD)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 80f8b8b..021a3ae 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -250,6 +250,7 @@ struct pci_dev {
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	ari_enabled:1;	/* ARI forwarding */
+	unsigned int	ats_enabled:1;	/* Address Translation Service */
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
 	pci_dev_flags_t dev_flags;
@@ -1189,5 +1190,19 @@ int pci_ext_cfg_avail(struct pci_dev *dev);
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
+extern int pci_enable_ats(struct pci_dev *dev, int ps);
+extern void pci_disable_ats(struct pci_dev *dev);
+extern int pci_ats_qdep(struct pci_dev *dev);
+/**
+ * pci_ats_enabled - query the ATS status
+ * @dev: the PCI device
+ *
+ * Returns 1 if ATS capability is enabled, or 0 if not.
+ */
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return dev->ats_enabled;
+}
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 027815b..3858b4f 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -498,6 +498,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_ATS	15
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -615,4 +616,13 @@
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
 #endif /* LINUX_PCI_REGS_H */
-- 
1.5.6.4

