Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbZCTD1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbZCTD1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZCTDZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:25:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:39425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZCTDYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042879"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 5/8] PCI: add SR-IOV API for Physical Function driver
Date: Fri, 20 Mar 2009 11:25:15 +0800
Message-Id: <1237519518-24048-6-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add or remove the Virtual Function when the SR-IOV is enabled or
disabled by the device driver. This can happen anytime rather than
only at the device probe stage.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c   |  314 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    2 +
 include/linux/pci.h |   19 +++-
 3 files changed, 334 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 5ddfc09..d0ff8ad 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include "pci.h"
 
+#define VIRTFN_ID_LEN	16
 
 static inline u8 virtfn_bus(struct pci_dev *dev, int id)
 {
@@ -26,6 +27,284 @@ static inline u8 virtfn_devfn(struct pci_dev *dev, int id)
 		dev->sriov->stride * id) & 0xff;
 }
 
+static struct pci_bus *virtfn_add_bus(struct pci_bus *bus, int busnr)
+{
+	int rc;
+	struct pci_bus *child;
+
+	if (bus->number == busnr)
+		return bus;
+
+	child = pci_find_bus(pci_domain_nr(bus), busnr);
+	if (child)
+		return child;
+
+	child = pci_add_new_bus(bus, NULL, busnr);
+	if (!child)
+		return NULL;
+
+	child->subordinate = busnr;
+	child->dev.parent = bus->bridge;
+	rc = pci_bus_add_child(child);
+	if (rc) {
+		pci_remove_bus(child);
+		return NULL;
+	}
+
+	return child;
+}
+
+static void virtfn_remove_bus(struct pci_bus *bus, int busnr)
+{
+	struct pci_bus *child;
+
+	if (bus->number == busnr)
+		return;
+
+	child = pci_find_bus(pci_domain_nr(bus), busnr);
+	BUG_ON(!child);
+
+	if (list_empty(&child->devices))
+		pci_remove_bus(child);
+}
+
+static int virtfn_add(struct pci_dev *dev, int id, int reset)
+{
+	int i;
+	int rc;
+	u64 size;
+	char buf[VIRTFN_ID_LEN];
+	struct pci_dev *virtfn;
+	struct resource *res;
+	struct pci_sriov *iov = dev->sriov;
+
+	virtfn = alloc_pci_dev();
+	if (!virtfn)
+		return -ENOMEM;
+
+	mutex_lock(&iov->dev->sriov->lock);
+	virtfn->bus = virtfn_add_bus(dev->bus, virtfn_bus(dev, id));
+	if (!virtfn->bus) {
+		kfree(virtfn);
+		mutex_unlock(&iov->dev->sriov->lock);
+		return -ENOMEM;
+	}
+	virtfn->devfn = virtfn_devfn(dev, id);
+	virtfn->vendor = dev->vendor;
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
+	pci_setup_device(virtfn);
+	virtfn->dev.parent = dev->dev.parent;
+
+	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		if (!res->parent)
+			continue;
+		virtfn->resource[i].name = pci_name(virtfn);
+		virtfn->resource[i].flags = res->flags;
+		size = resource_size(res);
+		do_div(size, iov->total);
+		virtfn->resource[i].start = res->start + size * id;
+		virtfn->resource[i].end = virtfn->resource[i].start + size - 1;
+		rc = request_resource(res, &virtfn->resource[i]);
+		BUG_ON(rc);
+	}
+
+	if (reset)
+		pci_execute_reset_function(virtfn);
+
+	pci_device_add(virtfn, virtfn->bus);
+	mutex_unlock(&iov->dev->sriov->lock);
+
+	virtfn->physfn = pci_dev_get(dev);
+	virtfn->is_virtfn = 1;
+
+	rc = pci_bus_add_device(virtfn);
+	if (rc)
+		goto failed1;
+	sprintf(buf, "virtfn%u", id);
+	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
+	if (rc)
+		goto failed1;
+	rc = sysfs_create_link(&virtfn->dev.kobj, &dev->dev.kobj, "physfn");
+	if (rc)
+		goto failed2;
+
+	kobject_uevent(&virtfn->dev.kobj, KOBJ_CHANGE);
+
+	return 0;
+
+failed2:
+	sysfs_remove_link(&dev->dev.kobj, buf);
+failed1:
+	pci_dev_put(dev);
+	mutex_lock(&iov->dev->sriov->lock);
+	pci_remove_bus_device(virtfn);
+	virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
+	mutex_unlock(&iov->dev->sriov->lock);
+
+	return rc;
+}
+
+static void virtfn_remove(struct pci_dev *dev, int id, int reset)
+{
+	char buf[VIRTFN_ID_LEN];
+	struct pci_bus *bus;
+	struct pci_dev *virtfn;
+	struct pci_sriov *iov = dev->sriov;
+
+	bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
+	if (!bus)
+		return;
+
+	virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
+	if (!virtfn)
+		return;
+
+	pci_dev_put(virtfn);
+
+	if (reset) {
+		device_release_driver(&virtfn->dev);
+		pci_execute_reset_function(virtfn);
+	}
+
+	sprintf(buf, "virtfn%u", id);
+	sysfs_remove_link(&dev->dev.kobj, buf);
+	sysfs_remove_link(&virtfn->dev.kobj, "physfn");
+
+	mutex_lock(&iov->dev->sriov->lock);
+	pci_remove_bus_device(virtfn);
+	virtfn_remove_bus(dev->bus, virtfn_bus(dev, id));
+	mutex_unlock(&iov->dev->sriov->lock);
+
+	pci_dev_put(dev);
+}
+
+static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
+{
+	int rc;
+	int i, j;
+	int nres;
+	u16 offset, stride, initial;
+	struct resource *res;
+	struct pci_dev *pdev;
+	struct pci_sriov *iov = dev->sriov;
+
+	if (!nr_virtfn)
+		return 0;
+
+	if (iov->nr_virtfn)
+		return -EINVAL;
+
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_INITIAL_VF, &initial);
+	if (initial > iov->total ||
+	    (!(iov->cap & PCI_SRIOV_CAP_VFM) && (initial != iov->total)))
+		return -EIO;
+
+	if (nr_virtfn < 0 || nr_virtfn > iov->total ||
+	    (!(iov->cap & PCI_SRIOV_CAP_VFM) && (nr_virtfn > initial)))
+		return -EINVAL;
+
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_OFFSET, &offset);
+	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_STRIDE, &stride);
+	if (!offset || (nr_virtfn > 1 && !stride))
+		return -EIO;
+
+	nres = 0;
+	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		res = dev->resource + PCI_IOV_RESOURCES + i;
+		if (res->parent)
+			nres++;
+	}
+	if (nres != iov->nres) {
+		dev_err(&dev->dev, "not enough MMIO resources for SR-IOV\n");
+		return -ENOMEM;
+	}
+
+	iov->offset = offset;
+	iov->stride = stride;
+
+	if (virtfn_bus(dev, nr_virtfn - 1) > dev->bus->subordinate) {
+		dev_err(&dev->dev, "SR-IOV: bus number out of range\n");
+		return -ENOMEM;
+	}
+
+	if (iov->link != dev->devfn) {
+		pdev = pci_get_slot(dev->bus, iov->link);
+		if (!pdev)
+			return -ENODEV;
+
+		pci_dev_put(pdev);
+
+		if (!pdev->is_physfn)
+			return -ENODEV;
+
+		rc = sysfs_create_link(&dev->dev.kobj,
+					&pdev->dev.kobj, "dep_link");
+		if (rc)
+			return rc;
+	}
+
+	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
+	pci_block_user_cfg_access(dev);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	msleep(100);
+	pci_unblock_user_cfg_access(dev);
+
+	iov->initial = initial;
+	if (nr_virtfn < initial)
+		initial = nr_virtfn;
+
+	for (i = 0; i < initial; i++) {
+		rc = virtfn_add(dev, i, 0);
+		if (rc)
+			goto failed;
+	}
+
+	kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
+	iov->nr_virtfn = nr_virtfn;
+
+	return 0;
+
+failed:
+	for (j = 0; j < i; j++)
+		virtfn_remove(dev, j, 0);
+
+	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	pci_block_user_cfg_access(dev);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	ssleep(1);
+	pci_unblock_user_cfg_access(dev);
+
+	if (iov->link != dev->devfn)
+		sysfs_remove_link(&dev->dev.kobj, "dep_link");
+
+	return rc;
+}
+
+static void sriov_disable(struct pci_dev *dev)
+{
+	int i;
+	struct pci_sriov *iov = dev->sriov;
+
+	if (!iov->nr_virtfn)
+		return;
+
+	for (i = 0; i < iov->nr_virtfn; i++)
+		virtfn_remove(dev, i, 0);
+
+	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
+	pci_block_user_cfg_access(dev);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	ssleep(1);
+	pci_unblock_user_cfg_access(dev);
+
+	if (iov->link != dev->devfn)
+		sysfs_remove_link(&dev->dev.kobj, "dep_link");
+
+	iov->nr_virtfn = 0;
+}
+
 static int sriov_init(struct pci_dev *dev, int pos)
 {
 	int i;
@@ -132,6 +411,8 @@ failed:
 
 static void sriov_release(struct pci_dev *dev)
 {
+	BUG_ON(dev->sriov->nr_virtfn);
+
 	if (dev == dev->sriov->dev)
 		mutex_destroy(&dev->sriov->lock);
 	else
@@ -155,6 +436,7 @@ static void sriov_restore_state(struct pci_dev *dev)
 		pci_update_resource(dev, i);
 
 	pci_write_config_dword(dev, iov->pos + PCI_SRIOV_SYS_PGSIZE, iov->pgsz);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, iov->nr_virtfn);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	if (iov->ctrl & PCI_SRIOV_CTRL_VFE)
 		msleep(100);
@@ -245,3 +527,35 @@ int pci_iov_bus_range(struct pci_bus *bus)
 
 	return max ? max - bus->number : 0;
 }
+
+/**
+ * pci_enable_sriov - enable the SR-IOV capability
+ * @dev: the PCI device
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
+{
+	might_sleep();
+
+	if (!dev->is_physfn)
+		return -ENODEV;
+
+	return sriov_enable(dev, nr_virtfn);
+}
+EXPORT_SYMBOL_GPL(pci_enable_sriov);
+
+/**
+ * pci_disable_sriov - disable the SR-IOV capability
+ * @dev: the PCI device
+ */
+void pci_disable_sriov(struct pci_dev *dev)
+{
+	might_sleep();
+
+	if (!dev->is_physfn)
+		return;
+
+	sriov_disable(dev);
+}
+EXPORT_SYMBOL_GPL(pci_disable_sriov);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 80ad848..1bdace3 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -203,6 +203,8 @@ struct pci_sriov {
 	u32 cap;		/* SR-IOV Capabilities */
 	u16 ctrl;		/* SR-IOV Control */
 	u16 total;		/* total VFs associated with the PF */
+	u16 initial;		/* initial VFs associated with the PF */
+	u16 nr_virtfn;		/* number of VFs available */
 	u16 offset;		/* first VF Routing ID offset */
 	u16 stride;		/* following VF stride */
 	u32 pgsz;		/* page size for BAR alignment */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 01eed8f..a83f662 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -265,6 +265,7 @@ struct pci_dev {
 	unsigned int	is_pcie:1;
 	unsigned int	state_saved:1;
 	unsigned int	is_physfn:1;
+	unsigned int	is_virtfn:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
@@ -279,7 +280,10 @@ struct pci_dev {
 #endif
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_IOV
-	struct pci_sriov *sriov;	/* SR-IOV capability related */
+	union {
+		struct pci_sriov *sriov;	/* SR-IOV capability related */
+		struct pci_dev *physfn;	/* the PF this VF is associated with */
+	};
 #endif
 };
 
@@ -1205,5 +1209,18 @@ int pci_ext_cfg_avail(struct pci_dev *dev);
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
+#ifdef CONFIG_PCI_IOV
+extern int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
+extern void pci_disable_sriov(struct pci_dev *dev);
+#else
+static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
+{
+	return -ENODEV;
+}
+static inline void pci_disable_sriov(struct pci_dev *dev)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.5.6.4

