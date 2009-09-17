Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZIQCKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZIQCKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZIQCKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:10:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:3006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZIQCKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:10:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,401,1249282800"; 
   d="scan'208";a="551285481"
From: Allen Kay <allen.m.kay@intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx,
       Allen Kay <allen.m.kay@intel.com>
Subject: [ACS v2 1/1] clean up base on Matt Wilcox feedback.
Date: Wed, 16 Sep 2009 19:07:41 -0700
Message-Id: <1253153261-23398-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
---
 drivers/pci/pci.c        |   35 +++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    1 +
 drivers/pci/probe.c      |    3 +++
 include/linux/pci_regs.h |   13 +++++++++++++
 4 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6edecff..1171c6d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1533,6 +1533,41 @@ void pci_enable_ari(struct pci_dev *dev)
 }
 
 /**
+ * pci_acs_enable - enable ACS if hardware support it
+ * @dev: the PCI device
+ */
+void pci_acs_init(struct pci_dev *dev)
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
index d92d195..ec8e2c1 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -202,6 +202,7 @@ static inline int pci_ari_enabled(struct pci_bus *bus)
 {
 	return bus->self && bus->self->ari_enabled;
 }
+extern void pci_acs_init(struct pci_dev *dev);
 
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_is_reassigndev(struct pci_dev *dev);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..72b9822 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1014,6 +1014,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	/* Single Root I/O Virtualization */
 	pci_iov_init(dev);
+
+	/* Access Control Service */
+	pci_acs_init(dev);
 }
 
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index dd0bed4..0bfe318 100644
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
+#define  PCI_ACS_CAP		0x04	/* ACS Capability Register */
+#define  PCI_ACS_CTRL		0x06	/* ACS Control Register */
+#define  PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
+#define  PCI_ACS_SV		0x01	/* Source Validation */
+#define  PCI_ACS_TB		0x02	/* Translation Blocking */
+#define  PCI_ACS_RR		0x04	/* P2P Request Redirect */
+#define  PCI_ACS_CR		0x08	/* P2P Completion Redirect */
+#define  PCI_ACS_UF		0x10	/* Upstream Forwarding */
+#define  PCI_ACS_EC		0x20	/* P2P Egress Control */
+#define  PCI_ACS_DT		0x40	/* Direct Translated P2P */
+
 #endif /* LINUX_PCI_REGS_H */
-- 
1.6.0.6

