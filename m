Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZBJJGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZBJJGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZBJJDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:03:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:4656 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZBJJDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:03:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,185,1233561600"; 
   d="scan'208";a="488749295"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v8 5/7] PCI: handle SR-IOV Virtual Function Migration
Date: Tue, 10 Feb 2009 16:59:13 +0800
Message-Id: <1234256355-23153-6-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234256355-23153-1-git-send-email-yu.zhao@intel.com>
References: <1234256355-23153-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c   |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    4 ++
 include/linux/pci.h |    6 +++
 3 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index d576160..d622167 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -203,6 +203,97 @@ static void sriov_release_dev(struct device *dev)
 	iov->nr_virtfn = 0;
 }
 
+static int sriov_migration(struct pci_dev *dev)
+{
+	u16 status;
+	struct pci_sriov *iov = dev->sriov;
+
+	if (!iov->nr_virtfn)
+		return 0;
+
+	if (!(iov->cap & PCI_SRIOV_CAP_VFM))
+		return 0;
+
+	pci_read_config_word(iov->self, iov->pos + PCI_SRIOV_STATUS, &status);
+	if (!(status & PCI_SRIOV_STATUS_VFM))
+		return 0;
+
+	schedule_work(&iov->mtask);
+
+	return 1;
+}
+
+static void sriov_migration_task(struct work_struct *work)
+{
+	int i;
+	u8 state;
+	u16 status;
+	struct pci_sriov *iov = container_of(work, struct pci_sriov, mtask);
+
+	for (i = iov->initial; i < iov->nr_virtfn; i++) {
+		state = readb(iov->mstate + i);
+		if (state == PCI_SRIOV_VFM_MI) {
+			writeb(PCI_SRIOV_VFM_AV, iov->mstate + i);
+			state = readb(iov->mstate + i);
+			if (state == PCI_SRIOV_VFM_AV)
+				virtfn_add(iov->self, i, 1);
+		} else if (state == PCI_SRIOV_VFM_MO) {
+			virtfn_remove(iov->self, i, 1);
+			writeb(PCI_SRIOV_VFM_UA, iov->mstate + i);
+			state = readb(iov->mstate + i);
+			if (state == PCI_SRIOV_VFM_AV)
+				virtfn_add(iov->self, i, 0);
+		}
+	}
+
+	pci_read_config_word(iov->self, iov->pos + PCI_SRIOV_STATUS, &status);
+	status &= ~PCI_SRIOV_STATUS_VFM;
+	pci_write_config_word(iov->self, iov->pos + PCI_SRIOV_STATUS, status);
+}
+
+static int sriov_enable_migration(struct pci_dev *dev, int nr_virtfn)
+{
+	int bir;
+	u32 table;
+	resource_size_t pa;
+	struct pci_sriov *iov = dev->sriov;
+
+	if (nr_virtfn <= iov->initial)
+		return 0;
+
+	pci_read_config_dword(dev, iov->pos + PCI_SRIOV_VFM, &table);
+	bir = PCI_SRIOV_VFM_BIR(table);
+	if (bir > PCI_STD_RESOURCE_END)
+		return -EIO;
+
+	table = PCI_SRIOV_VFM_OFFSET(table);
+	if (table + nr_virtfn > pci_resource_len(dev, bir))
+		return -EIO;
+
+	pa = pci_resource_start(dev, bir) + table;
+	iov->mstate = ioremap(pa, nr_virtfn);
+	if (!iov->mstate)
+		return -ENOMEM;
+
+	INIT_WORK(&iov->mtask, sriov_migration_task);
+
+	iov->ctrl |= PCI_SRIOV_CTRL_VFM | PCI_SRIOV_CTRL_INTR;
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+
+	return 0;
+}
+
+static void sriov_disable_migration(struct pci_dev *dev)
+{
+	struct pci_sriov *iov = dev->sriov;
+
+	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFM | PCI_SRIOV_CTRL_INTR);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+
+	cancel_work_sync(&iov->mtask);
+	iounmap(iov->mstate);
+}
+
 static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 {
 	int rc;
@@ -287,6 +378,12 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 			goto failed2;
 	}
 
+	if (iov->cap & PCI_SRIOV_CAP_VFM) {
+		rc = sriov_enable_migration(dev, nr_virtfn);
+		if (rc)
+			goto failed2;
+	}
+
 	kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
 	iov->nr_virtfn = nr_virtfn;
 
@@ -316,6 +413,9 @@ static void sriov_disable(struct pci_dev *dev)
 	if (!iov->nr_virtfn)
 		return;
 
+	if (iov->cap & PCI_SRIOV_CAP_VFM)
+		sriov_disable_migration(dev);
+
 	for (i = 0; i < iov->nr_virtfn; i++)
 		virtfn_remove(dev, i, 0);
 
@@ -571,3 +671,22 @@ void pci_disable_sriov(struct pci_dev *dev)
 		sriov_disable(dev);
 }
 EXPORT_SYMBOL_GPL(pci_disable_sriov);
+
+/**
+ * pci_sriov_migration - notify SR-IOV core of Virtual Function Migration
+ * @dev: the PCI device
+ *
+ * Returns IRQ_HANDLED if the IRQ is handled, or IRQ_NONE if not.
+ *
+ * Physical Function driver is responsible to register IRQ handler using
+ * VF Migration Interrupt Message Number, and call this function when the
+ * interrupt is generated by the hardware.
+ */
+irqreturn_t pci_sriov_migration(struct pci_dev *dev)
+{
+	if (!dev->sriov)
+		return IRQ_NONE;
+
+	return sriov_migration(dev) ? IRQ_HANDLED : IRQ_NONE;
+}
+EXPORT_SYMBOL_GPL(pci_sriov_migration);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 328a611..51bebb2 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1,6 +1,8 @@
 #ifndef DRIVERS_PCI_H
 #define DRIVERS_PCI_H
 
+#include <linux/workqueue.h>
+
 #define PCI_CFG_SPACE_SIZE	256
 #define PCI_CFG_SPACE_EXP_SIZE	4096
 
@@ -211,6 +213,8 @@ struct pci_sriov {
 	struct pci_dev *pdev;	/* lowest numbered PF */
 	struct pci_dev *self;	/* this PF */
 	struct mutex lock;	/* lock for VF bus */
+	struct work_struct mtask; /* VF Migration task */
+	u8 __iomem *mstate;	/* VF Migration State Array */
 	struct device dev;
 };
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b14ecf0..84caf8c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -52,6 +52,7 @@
 #include <asm/atomic.h>
 #include <linux/device.h>
 #include <linux/io.h>
+#include <linux/irqreturn.h>
 
 /* Include the ID list */
 #include <linux/pci_ids.h>
@@ -1206,6 +1207,7 @@ void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 #ifdef CONFIG_PCI_IOV
 extern int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 extern void pci_disable_sriov(struct pci_dev *dev);
+extern irqreturn_t pci_sriov_migration(struct pci_dev *dev);
 #else
 static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 {
@@ -1214,6 +1216,10 @@ static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 static inline void pci_disable_sriov(struct pci_dev *dev)
 {
 }
+static inline irqreturn_t pci_sriov_migration(struct pci_dev *dev)
+{
+	return IRQ_NONE;
+}
 #endif
 
 #endif /* __KERNEL__ */
-- 
1.5.6.4

