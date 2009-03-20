Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbZCTDZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbZCTDZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZCTDYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:15421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZCTDYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042864"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 2/8] PCI: restore saved SR-IOV state
Date: Fri, 20 Mar 2009 11:25:12 +0800
Message-Id: <1237519518-24048-3-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the volatile registers in the SR-IOV capability after the
D3->D0 transition.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c |   29 +++++++++++++++++++++++++++++
 drivers/pci/pci.c |    1 +
 drivers/pci/pci.h |    4 ++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 66cc414..b121e47 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -129,6 +129,25 @@ static void sriov_release(struct pci_dev *dev)
 	dev->sriov = NULL;
 }
 
+static void sriov_restore_state(struct pci_dev *dev)
+{
+	int i;
+	u16 ctrl;
+	struct pci_sriov *iov = dev->sriov;
+
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_CTRL, &ctrl);
+	if (ctrl & PCI_SRIOV_CTRL_VFE)
+		return;
+
+	for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++)
+		pci_update_resource(dev, i);
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
@@ -180,3 +199,13 @@ int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 	return dev->sriov->pos + PCI_SRIOV_BAR +
 		4 * (resno - PCI_IOV_RESOURCES);
 }
+
+/**
+ * pci_restore_iov_state - restore the state of the IOV capability
+ * @dev: the PCI device
+ */
+void pci_restore_iov_state(struct pci_dev *dev)
+{
+	if (dev->is_physfn)
+		sriov_restore_state(dev);
+}
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2eba2a5..8e21912 100644
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
index 196be5e..efd79a2 100644
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

