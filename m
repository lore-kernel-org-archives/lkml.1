Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYIALWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYIALWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbYIALVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:21:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:45789 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599AbYIALVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:21:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,307,1217833200"; 
   d="scan'208";a="375462253"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2/4 v2] PCI: support ARI capability
Date: Mon, 1 Sep 2008 19:20:56 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4 v2] PCI: support ARI capability
Thread-Index: AckMJM1m9UecPzImTSqDwBr2UDhCDA==
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 01 Sep 2008 11:20:58.0895 (UTC) FILETIME=[CF0E59F0:01C90C24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Alternative Routing-ID Interpretation (ARI), which increases the number of functions that can be supported by a PCIe endpoint. ARI is required by SR-IOV.

PCI-SIG ARI specification can be found at http://www.pcisig.com/specifications/pciexpress/specifications/ECN-alt-rid-interpretation-070604.pdf

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Signed-off-by: Eddie Dong <eddie.dong@intel.com>

---
 drivers/pci/Kconfig      |    7 ++++
 drivers/pci/Makefile     |    2 +
 drivers/pci/ari.c        |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    8 +++++
 drivers/pci/probe.c      |    3 ++
 include/linux/pci.h      |   25 ++++++++++++++++
 include/linux/pci_regs.h |   14 +++++++++
 7 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/ari.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index e1ca425..f43cc46 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -50,3 +50,10 @@ config HT_IRQ
 	   This allows native hypertransport devices to use interrupts.
 
 	   If unsure say Y.
+
+config PCI_ARI
+	bool "PCI ARI support"
+	depends on PCI
+	default n
+	help
+	  This enables PCI Alternative Routing-ID Interpretation.
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 7d63f8c..96f2767 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -53,3 +53,5 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
+
+obj-$(CONFIG_PCI_ARI) += ari.o
diff --git a/drivers/pci/ari.c b/drivers/pci/ari.c
new file mode 100644
index 0000000..3f1a47a
--- /dev/null
+++ b/drivers/pci/ari.c
@@ -0,0 +1,71 @@
+/*
+ * drivers/pci/ari.c
+ *
+ * Copyright (C) 2008 Intel Corporation, Yu Zhao <yu.zhao@intel.com>
+ *
+ * PCI Express Alternative Routing-ID Interpretation capability support.
+ */
+
+#include <linux/pci.h>
+
+#include "pci.h"
+
+/**
+ * pci_ari_enable_fwd - enable ARI forwarding
+ * @dev: the PCI device
+ */
+void pci_ari_enable_fwd(struct pci_dev *dev)
+{
+	int pos;
+	u32 cap;
+	u16 ctrl;
+
+	if (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
+	    dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM &&
+	    dev->ari_enabled)
+		return;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!pos)
+		return;
+
+	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
+
+	if (!(cap & PCI_EXP_DEVCAP2_ARI))
+		return;
+
+	dev->ari_enabled = 1;
+	dev_info(&dev->dev, "ARI forwarding enabled.\n");
+
+	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
+	if (ctrl & PCI_EXP_DEVCTL2_ARI)
+		return;
+
+	ctrl |= PCI_EXP_DEVCTL2_ARI;
+	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+}
+
+/**
+ * pci_ari_next_fn - find next function number
+ * @dev: the PCI device
+ *
+ * Returns function number, or 0 if there are no higher numbered
+ * functions; returns negative on failure.
+ */
+int pci_ari_next_fn(struct pci_dev *dev)
+{
+	int pos;
+	u16 cap;
+
+	if (dev->pcie_type != PCI_EXP_TYPE_ENDPOINT)
+		return -EINVAL;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
+	if (!pos)
+		return -EIO;
+
+	pci_read_config_word(dev, pos + PCI_ARI_CAP, &cap);
+
+	return PCI_ARI_CAP_NFN(cap);
+}
+EXPORT_SYMBOL_GPL(pci_ari_next_fn);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5abd69c..720a607 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -147,3 +147,11 @@ struct pci_slot_attribute {
 extern int pci_resource_alignment(struct pci_dev *dev, int resno);
 extern int pci_resource_bar(struct pci_dev *dev, int resno,
 			    enum pci_bar_type *type);
+
+#ifdef CONFIG_PCI_ARI
+extern void pci_ari_enable_fwd(struct pci_dev *dev);
+#else
+static inline void pci_ari_enable_fwd(struct pci_dev *dev)
+{
+}
+#endif /* CONFIG_PCI_ARI */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3994ea3..ad7ad35 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1059,6 +1059,9 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	int func, nr = 0;
 	int scan_all_fns;
 
+	if (bus->self)
+		pci_ari_enable_fwd(bus->self);
+
 	scan_all_fns = pcibios_scan_all_fns(bus, devfn);
 
 	for (func = 0; func < 8; func++, devfn++) {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4b8018f..8ed7405 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -236,6 +236,7 @@ struct pci_dev {
 	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
+	unsigned int	ari_enabled:1;	/* ARI forwarding */
 	unsigned int	is_managed:1;
 	unsigned int	is_pcie:1;
 	pci_dev_flags_t dev_flags;
@@ -1137,5 +1138,29 @@ static inline void pci_mmcfg_early_init(void) { }
 static inline void pci_mmcfg_late_init(void) { }
 #endif
 
+#ifdef CONFIG_PCI_ARI
+/**
+ * pci_ari_fwd_enabled - query ARI forwarding status
+ * @dev: the PCI device
+ *
+ * Returns 1 if ARI forwarding is enabled, or 0 if not enabled;
+ * returns negative on failure.
+ */
+static inline int pci_ari_fwd_enabled(struct pci_dev *dev)
+{
+	return dev->ari_enabled;
+}
+extern int pci_ari_next_fn(struct pci_dev *dev);
+#else
+static inline int pci_ari_fwd_enabled(struct pci_dev *dev)
+{
+	return -EIO;
+}
+static inline int pci_ari_next_fn(struct pci_dev *dev)
+{
+	return -EIO;
+}
+#endif /* CONFIG_PCI_ARI */
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 450684f..eb6686b 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -419,6 +419,10 @@
 #define  PCI_EXP_RTCTL_CRSSVE	0x10	/* CRS Software Visibility Enable */
 #define PCI_EXP_RTCAP		30	/* Root Capabilities */
 #define PCI_EXP_RTSTA		32	/* Root Status */
+#define PCI_EXP_DEVCAP2		36	/* Device Capabilities 2 */
+#define  PCI_EXP_DEVCAP2_ARI	0x20	/* Alternative Routing-ID */
+#define PCI_EXP_DEVCTL2		40	/* Device Control 2 */
+#define  PCI_EXP_DEVCTL2_ARI	0x20	/* Alternative Routing-ID */
 
 /* Extended Capabilities (PCI-X 2.0 and Express) */
 #define PCI_EXT_CAP_ID(header)		(header & 0x0000ffff)
@@ -429,6 +433,7 @@
 #define PCI_EXT_CAP_ID_VC	2
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
+#define PCI_EXT_CAP_ID_ARI	14
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
@@ -536,5 +541,14 @@
 #define HT_CAPTYPE_GEN3		0xD0	/* Generation 3 hypertransport configuration */
 #define HT_CAPTYPE_PM		0xE0	/* Hypertransport powermanagement configuration */
 
+/* Alternative Routing-ID Interpretation */
+#define PCI_ARI_CAP		0x04	/* ARI Capability Register */
+#define  PCI_ARI_CAP_MFVC	0x0001	/* MFVC Function Groups Capability */
+#define  PCI_ARI_CAP_ACS	0x0002	/* ACS Function Groups Capability */
+#define  PCI_ARI_CAP_NFN(x)	(((x) >> 8) & 0xff) /* Next Function Number */
+#define PCI_ARI_CTRL		0x06	/* ARI Control Register */
+#define  PCI_ARI_CTRL_MFVC	0x0001	/* MFVC Function Groups Enable */
+#define  PCI_ARI_CTRL_ACS	0x0002	/* ACS Function Groups Enable */
+#define  PCI_ARI_CTRL_FG(x)	(((x) >> 4) & 7) /* Function Group */
 
 #endif /* LINUX_PCI_REGS_H */
-- 
1.5.6.4

