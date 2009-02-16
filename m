Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZBQD35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZBQD35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZBQD3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:29:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:14318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZBQD3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:29:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,220,1233561600"; 
   d="scan'208";a="111302119"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v9 2/7] PCI: restore saved SR-IOV state
Date: Mon, 16 Feb 2009 21:28:35 +0800
Message-Id: <1234790920-1810-3-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234790920-1810-1-git-send-email-yu.zhao@intel.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c |   25 +++++++++++++++++++++++++
 drivers/pci/pci.c |    1 +
 drivers/pci/pci.h |    4 ++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index e6736d4..1cc879b 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -128,6 +128,21 @@ static void sriov_release(struct pci_dev *dev)
 	dev->sriov = NULL;
 }
 
+static void sriov_restore_state(struct pci_dev *dev)
+{
+	u16 ctrl;
+	struct pci_sriov *iov = dev->sriov;
+
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_CTRL, &ctrl);
+	if (ctrl & PCI_SRIOV_CTRL_VFE)
+		return;
+
+	pci_write_config_dword(dev, iov->pos + PCI_SRIOV_SYS_PGSIZE, iov->pgsz);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	if (iov->ctrl & PCI_SRIOV_CTRL_VFE)
+		msleep(100);
+}
+
 /**
  * pci_iov_init - initialize the IOV capability
  * @dev: the PCI device
@@ -179,3 +194,13 @@ int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 	return dev->sriov->pos + PCI_SRIOV_BAR +
 		4 * (resno - PCI_SRIOV_RESOURCES);
 }
+
+/**
+ * pci_restore_iov_state - restore the state of the IOV capability
+ * @dev: the PCI device
+ */
+void pci_restore_iov_state(struct pci_dev *dev)
+{
+	if (dev->sriov)
+		sriov_restore_state(dev);
+}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c4f14f3..f791dcf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -773,6 +773,7 @@ pci_restore_state(struct pci_dev *dev)
 	}
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
+	pci_restore_iov_state(dev);
 
 	return 0;
 }
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d2dc6b7..9d76737 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -216,6 +216,7 @@ extern int pci_iov_init(struct pci_dev *dev);
 extern void pci_iov_release(struct pci_dev *dev);
 extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 				enum pci_bar_type *type);
+extern void pci_restore_iov_state(struct pci_dev *dev);
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -230,6 +231,9 @@ static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 {
 	return 0;
 }
+static inline void pci_restore_iov_state(struct pci_dev *dev)
+{
+}
 #endif /* CONFIG_PCI_IOV */
 
 #endif /* DRIVERS_PCI_H */
-- 
1.5.6.4

