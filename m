Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbZAGO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbZAGO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZAGO7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:59:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:61838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZAGO7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:59:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,226,1231142400"; 
   d="scan'208";a="479648869"
Date: Wed, 7 Jan 2009 22:52:24 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] PCI: support the ATS capability
Message-ID: <20090107145224.GB4697@yzhao12-linux.sh.intel.com>
References: <20090107144716.GA4697@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107144716.GA4697@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
index 061d1ee..5abab14 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1337,6 +1337,74 @@ void pci_enable_ari(struct pci_dev *dev)
 	bridge->ari_enabled = 1;
 }
 
+/**
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
+ * pci_ats_qdep - query ATS Invalidate Queue Depth
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
 int
 pci_get_interrupt_pin(struct pci_dev *dev, struct pci_dev **bridge)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4bb156b..e6a1b5a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -227,6 +227,7 @@ struct pci_dev {
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	ari_enabled:1;	/* ARI forwarding */
+	unsigned int	ats_enabled:1;	/* Address Translation Service */
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
 	pci_dev_flags_t dev_flags;
@@ -1155,5 +1156,19 @@ static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
 }
 #endif
 
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
index e5effd4..00c9db5 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -436,6 +436,7 @@
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
 #define PCI_EXT_CAP_ID_ARI	14
+#define PCI_EXT_CAP_ID_ATS	15
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -553,4 +554,13 @@
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

